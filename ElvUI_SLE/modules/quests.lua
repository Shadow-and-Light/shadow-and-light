local E, L, V, P, G = unpack(ElvUI);
local Q = E:GetModule("SLE_Quests")
local frame
local B = LibStub("LibBabble-SubZone-3.0")
local BL = B:GetLookupTable()

local statedriver = {
	['FULL'] = function(frame) 
		ObjectiveTracker_Expand()
		frame:Show()
	end,
	['COLLAPSED'] = function(frame)
		ObjectiveTracker_Collapse()
		frame:Show()
	end,
	['HIDE'] = function(frame)
		frame:Hide()
	end,
}

function Q:ChangeState(event)
	if InCombatLockdown() then self:RegisterEvent("PLAYER_REGEN_ENABLED", "ChangeState") return end
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	if not Q.db then return end
	if not Q.db.visibility then return end

	if GetZoneText() == BL.Frostwall or GetZoneText() == BL.Lunarfall then
		statedriver[Q.db.visibility.garrison](frame)
	elseif IsResting() then
		statedriver[Q.db.visibility.rested](frame)
	else
		local instance, instanceType = IsInInstance()
		if instance then
			if instanceType == 'pvp' then
				statedriver[Q.db.visibility.bg](frame)
			elseif instanceType == 'arena' then
				statedriver[Q.db.visibility.arena](frame)
			elseif instanceType == 'party' then
				statedriver[Q.db.visibility.dungeon](frame)
			elseif instanceType == 'scenario' then
				statedriver[Q.db.visibility.scenario](frame)
			elseif instanceType == 'raid' then
				statedriver[Q.db.visibility.raid](frame)
			end
		else
			statedriver["FULL"](frame)
		end
		
	end
end

function Q:Initialize()
	Q.db = E.db.sle.quests
	frame = ObjectiveTrackerFrame
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ChangeState")
	self:RegisterEvent("PLAYER_UPDATE_RESTING", "ChangeState")

	hooksecurefunc(E, "UpdateAll", function()
		Q.db = E.db.sle.quests
		Q:ChangeState()
		collectgarbage('collect');
	end)
end