local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Pr = SLE.Professions
local FL = LibStub("LibFishing-1.0-SLE") or LibStub("LibFishing-1.0")

-- GLOBALS: hooksecurefunc, CreateFrame
local _G = _G
local format = format
local GetTime = GetTime

local SavedWFOnMouseDown
local IsMounted = IsMounted
local IsMouselooking = IsMouselooking
local MouselookStop = MouselookStop
local UnitChannelInfo = UnitChannelInfo
local InCombatLockdown = InCombatLockdown

local C_Container_GetItemCooldown = C_Container.GetItemCooldown

function Pr:HijackFishingCheck()
	if ( not Pr.AddingLure and not InCombatLockdown() and (not IsMounted() or E.private.sle.professions.fishing.FromMount) and
	E.private.sle.professions.fishing.EasyCast and FL:IsFishingReady(E.private.sle.professions.fishing.IgnorePole)) then
		return true
	end
end

local function HideAwayAll(self, button, down)
	Pr.FishingUpdateFrame:Show()
end

function Pr:GetUpdateLure()
	if E.private.sle.professions.fishing.UseLures then
		-- only apply a lure if we're actually fishing with a "real" pole
		if (FL:IsFishingPole()) then
			-- Let's wait a bit so that the enchant can show up before we lure again
			if ( Pr.LastLure and Pr.LastLure.time and ((Pr.LastLure.time - GetTime()) > 0) ) then
				SLE:Print(format(L["SLE_Prof_Relure_Error"], Pr.LastLure.time - GetTime()))
				return false
			end

			if ( Pr.LastLure ) then
				Pr.LastLure.time = nil
				Pr.LureState = 0
			end

			local skill, _, _, _ = FL:GetCurrentSkill()
			if (skill > 0) then
				local NextLure, NextState
				local tempenchant = FL:GetPoleBonus()
				local state, bestlure = FL:FindBestLure(tempenchant, Pr.LureState)
				if ( state and bestlure and tempenchant == 0 ) then
					NextState = state
					NextLure = bestlure
				else
					NextLure = nil
				end
				local DoLure = NextLure

				if ( DoLure and DoLure.id ) then
					-- if the pole has an enchantment, we can assume it's got a lure on it (so far, anyway)
					-- remove the main hand enchantment (since it's a fishing pole, we know what it is)
					local startTime, duration, enable = C_Container_GetItemCooldown(DoLure.id)
					if (startTime == 0) then
						Pr.AddingLure = true
						Pr.LastLure = DoLure
						Pr.LureState = NextState
						Pr.LastLure.time = GetTime() + E.private.sle.professions.fishing.relureThreshold
						local id = DoLure.id
						local name = DoLure.n
						return true, id, name
					elseif ( Pr.LastLure and not Pr.LastLure.time ) then
						Pr.LastLure = nil
						Pr.LastState = 0
						Pr.AddingLure = false
					end
				end
			end
		end
	end
	return false
end

function Pr:FishCasting()
	-- put on a lure if we need to
	local update, id, n = Pr:GetUpdateLure()
	if (update and id) then
		FL:InvokeLuring(id)
	else
		Pr.LastCastTime = GetTime()

		FL:InvokeFishing()
	end
	FL:OverrideClick(HideAwayAll)
end

-- handle mouse up and mouse down in the WorldFrame so that we can steal the hardware events to implement 'Easy Cast'
-- Thanks to the Cosmos team for figuring this one out
local function WF_OnMouseDown(...)
	-- Only steal 'right clicks' (self is arg #1!)
	local key = Pr.FishingKey
	if not InCombatLockdown() then
		if (key == "None" and FL:IsFishingReady(false)) or (key ~= "None" and _G["Is"..key.."KeyDown"]()) then
			local button = select(2, ...)
			if FL:CheckForDoubleClick(button) then
				if Pr:HijackFishingCheck() then
				 -- We're stealing the mouse-up event, make sure we exit MouseLook
					if ( IsMouselooking() ) then
						MouselookStop()
					end
					Pr:FishCasting()
				end
			end
		else
			FL:ResetOverride()
		end
	end

	if ( SavedWFOnMouseDown ) then
		SavedWFOnMouseDown(...)
	end
end

local function WF_OnMouseUp(...)
	-- Only steal 'right clicks' (self is arg #1!)
	if not InCombatLockdown() then
		local key = Pr.FishingKey
		if (key == "None" and FL:IsFishingReady(false)) or (key ~= "None" and _G["Is"..key.."KeyDown"]()) then
			local button = select(2, ...)
			if FL:CheckForDoubleClick(button) then
				if Pr:HijackFishingCheck() then
				 -- We're stealing the mouse-up event, make sure we exit MouseLook
					if ( IsMouselooking() ) then
						MouselookStop()
					end
					Pr:FishCasting()
				end
			end
		else
			FL:ResetOverride()
		end
	end

	if ( SavedWFOnMouseUp ) then
		SavedWFOnMouseUp(...)
	end
end

local function TrapWorldMouse()
	if ( _G["WorldFrame"].OnMouseDown ) then
		hooksecurefunc(_G["WorldFrame"], "OnMouseDown", WF_OnMouseDown)
		hooksecurefunc(_G["WorldFrame"], "OnMouseUp", WF_OnMouseUp)
	else
		SavedWFOnMouseDown = T.SafeHookScript(_G["WorldFrame"], "OnMouseDown", WF_OnMouseDown)
		SavedWFOnMouseUp = T.SafeHookScript(_G["WorldFrame"], "OnMouseUp", WF_OnMouseUp)
	end
end

function Pr:FishingInitialize()
	Pr.FishingKey = E.private.sle.professions.fishing.CastButton
	Pr.AddingLure = false
	Pr.LastLure = nil
	Pr.LureState = 0
	Pr.LastCastTime = nil
	Pr.FishingUpdateFrame = CreateFrame("Frame", "SLE_FishingUpdateFrame", E.UIParent)
	Pr.FishingUpdateFrame:SetScript("OnUpdate", function(self)
		local stop = true
		if ( not InCombatLockdown() ) then
			FL:ResetOverride()
			if ( Pr.AddingLure ) then
				--  TODO:  Clean up as a bunch of unused variables
				local sp, sub, txt, tex, st, et, trade, int = UnitChannelInfo("player")
				local lure = FL:GetPoleBonus()
				if ( not sp or not Pr.LastLure or (lure and lure == Pr.LastLure.b) ) then
					Pr.AddingLure = false
					FL:UpdateLureInventory()
				else
					stop = false
				end
			end
			if ( stop ) then
				Pr.FishingUpdateFrame:Hide()
			end
		end
	end)
	Pr.FishingUpdateFrame:Hide()

	FL:GetPoleType()
	FL:CreateSAButton()
	FL:SetSAMouseEvent()
	TrapWorldMouse()
end
