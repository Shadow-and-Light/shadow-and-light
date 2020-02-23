local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = SLE:NewModule("Misc", 'AceHook-3.0', 'AceEvent-3.0')
local Tr = E:GetModule('Threat');
--GLOBALS: hooksecurefunc, UIParent
local _G = _G
local ShowUIPanel, HideUIPanel = ShowUIPanel, HideUIPanel

--Threat
function M:ElvUIConfig_OnLoad(event, addon)
	if addon ~= "ElvUI_OptionsUI" then return end

	M:Threat_UpdateConfig()
	M:UnregisterEvent("ADDON_LOADED")
end

function M:Threat_UpdatePosition()
	if not E.db.general.threat.enable or not M.db.threat or not M.db.threat.enable then return end

	Tr.bar:SetInside(M.db.threat.position)
	Tr.bar:SetParent(M.db.threat.position)

	Tr.bar.text:FontTemplate(nil, E.db.general.threat.textSize, E.db.general.threat.textOutline)
	Tr.bar:SetFrameStrata('MEDIUM')
	Tr.bar:SetAlpha(1)
end

function M:Threat_UpdateConfig()
	if T.IsAddOnLoaded("ElvUI_OptionsUI") then
		if M.db.threat.enable then
			E.Options.args.general.args.general.args.threatGroup.args.position = {
				order = 42,
				name = L["Position"],
				desc = L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."],
				type = "execute",
				func = function() E.Libs["AceConfigDialog"]:SelectGroup("ElvUI", "sle") end,
			}
		else
			E.Options.args.general.args.general.args.threatGroup.args.position = {
				order = 42,
				type = 'select',
				name = L["Position"],
				desc = L["Adjust the position of the threat bar to either the left or right datatext panels."],
				values = {
					['LEFTCHAT'] = L["Left Chat"],
					['RIGHTCHAT'] = L["Right Chat"],
				},
				get = function(info) return E.db.general.threat.position end,
				set = function(info, value) E.db.general.threat.position = value; Tr:UpdatePosition() end,
			}
		end
	end
end

--Viewports
function M:SetAllPoints(...)
	M:SetViewport()
end

--[[function M:ClearAllPoints(force)
	print("ClearAllPoints", force)
	if force then
		WorldFrame:ORClear()
	end
end]]

function M:SetViewport()
	if SLE._Compatibility["SunnArt"] then return end --Other viewport addon is enabled
	local scale = E.global.general.UIScale
	_G["WorldFrame"]:ClearAllPoints()
	_G["WorldFrame"]:SetPoint("TOPLEFT", ( M.db.viewport.left * scale ), -( M.db.viewport.top * scale ) )
	_G["WorldFrame"]:SetPoint("BOTTOMRIGHT", -( M.db.viewport.right * scale ), ( M.db.viewport.bottom * scale ) )
end

--Raid utility
function M:RaidUtility_SetMouseoverAlpha()
	local a = E.db.sle.blizzard.rumouseover and 0 or 1
	_G["RaidUtility_ShowButton"]:SetAlpha(a)
end

function M:RaidUtility_OnDragStop()
	local point, anchor, point2, x, y = self:GetPoint()
	local frame = _G["RaidUtility_ShowButton"]
	frame:ClearAllPoints()
	if T.find(point, "BOTTOM") then
		frame:SetPoint(point, anchor, point2, x, y)
	else
		frame:SetPoint(point, anchor, point2, x, y)
	end
end

function M:RaidUtility_OnEnter()
	if not E.db.sle.blizzard.rumouseover then return end
	self:SetAlpha(1)
end

function M:RaidUtility_OnLeave()
	if not E.db.sle.blizzard.rumouseover then return end
	self:SetAlpha(0)
end

function M:RaidUtility_Hook()
	--Creating mover for the button
	local frame = _G["RaidUtility_ShowButton"]
	if not frame then return end --Just in case
	E:CreateMover(frame, "RaidUtility_Mover", RAID_CONTROL, nil, nil, nil, "ALL,S&L,S&L MISC")
	local mover = _G["RaidUtility_Mover"]

	--Setting default point and stuff
	if E.db.movers == nil then E.db.movers = {} end

	--Making frame actually following mover around
	mover:HookScript("OnDragStart", function(self)
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", self)
	end)
	mover:HookScript("OnDragStop", M.RaidUtility_OnDragStop)

	if E.db.movers.RaidUtility_Mover == nil then
		frame:ClearAllPoints()
		frame:SetPoint("TOP", E.UIParent, "TOP", -400, E.Border)
	else
		M.RaidUtility_OnDragStop(mover)
	end

	frame:RegisterForDrag("") --No buttons for drag
	frame:HookScript("OnEnter", M.RaidUtility_OnEnter)
	frame:HookScript("OnLeave", M.RaidUtility_OnLeave)
	M.RaidUtility_OnLeave(frame)
end

function M:Initialize()
	if not SLE.initialized then return end
	M.db = E.db.sle.misc
	E:CreateMover(_G["UIErrorsFrame"], "UIErrorsFrameMover", L["Error Frame"], nil, nil, nil, "ALL,S&L,S&L MISC")

	--GhostFrame Mover
	ShowUIPanel(_G["GhostFrame"])
	E:CreateMover(_G["GhostFrame"], "GhostFrameMover", L["Ghost Frame"], nil, nil, nil, "ALL,S&L,S&L MISC")
	HideUIPanel(_G["GhostFrame"])

	--Raid Utility
	if _G["RaidUtility_ShowButton"] then M:RaidUtility_Hook() end

	--Threat
	hooksecurefunc(Tr, 'UpdatePosition', M.Threat_UpdatePosition)
	M:RegisterEvent("ADDON_LOADED", "ElvUIConfig_OnLoad")
	M:Threat_UpdatePosition()

	--Viewport
	function CinematicFrame_CancelCinematic()
		if ( CinematicFrame.isRealCinematic ) then
			StopCinematic();
		elseif ( CanCancelScene() ) then
			CancelScene();
		else
			VehicleExit();
		end
		
	end
	
	--Some high level bullshit
	-- WorldFrame.ORClear = WorldFrame.ClearAllPoints
	-- WorldFrame.ClearAllPoints = M.ClearAllPoints
	WorldFrame.ORSetAll = WorldFrame.SetAllPoints
	WorldFrame.SetAllPoints = M.SetAllPoints

	M:SetViewport()
	hooksecurefunc(E, "PixelScaleChanged", M.SetViewport)

	function M:ForUpdateAll()
		M.db = E.db.sle.misc
		M:Threat_UpdateConfig()
		M:Threat_UpdatePosition()
		M:SetViewport()
	end
end

SLE:RegisterModule(M:GetName())