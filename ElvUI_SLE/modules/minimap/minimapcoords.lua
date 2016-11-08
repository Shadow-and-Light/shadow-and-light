local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule('Minimap')
local MM = SLE:NewModule("Minimap", 'AceHook-3.0', 'AceEvent-3.0')
--GLOBALS: CreateFrame, hooksecurefunc
local _G = _G
local cluster = _G["MinimapCluster"]
local UIFrameFadeIn = UIFrameFadeIn

MM.RestrictedArea = false

local function HideMinimap()
	cluster:Hide()
end

local function ShowMinimap()
	if not T.InCombatLockdown() then
		UIFrameFadeIn(cluster, 0.2, cluster:GetAlpha(), 1)
	end
end

local function CreateCoords()
	local x, y = T.GetPlayerMapPosition("player")
	if x then x = T.format(E.db.sle.minimap.coords.format, x * 100) else x = "0" end
	if y then y = T.format(E.db.sle.minimap.coords.format, y * 100) else y = "0" end
	
	return x, y
end

function MM:UpdateCoords(elapsed)
	MM.coordspanel.elapsed = (MM.coordspanel.elapsed or 0) + elapsed
	if MM.coordspanel.elapsed < E.db.sle.minimap.coords.throttle then return end
	if not MM.RestrictedArea then
		local x, y = CreateCoords()
		if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
		if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
		MM.coordspanel.Text:SetText(x.." , "..y)
	else 
		MM.coordspanel.Text:SetText("-")
	end
	MM:CoordsSize()
	MM.coordspanel.elapsed = 0
end

function MM:HideMinimapRegister()
	if E.db.sle.minimap.combat then
		M:RegisterEvent("PLAYER_REGEN_DISABLED", HideMinimap)
		M:RegisterEvent("PLAYER_REGEN_ENABLED", ShowMinimap)
	else
		M:UnregisterEvent("PLAYER_REGEN_DISABLED")
		M:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function MM:CoordFont()
	MM.coordspanel.Text:SetFont(E.LSM:Fetch('font', E.db.sle.minimap.coords.font), E.db.sle.minimap.coords.fontSize, E.db.sle.minimap.coords.fontOutline)
end

function MM:CoordsSize()
	local size = MM.coordspanel.Text:GetStringWidth()
	if size ~= MM.coordspanel.WidthValue then
		MM.coordspanel:Size(size + 4, E.db.sle.minimap.coords.fontSize + 2)
		MM.coordspanel.WidthValue = size + 4
	end
end

function MM:UpdateCoordinatesPosition()
	MM.coordspanel:ClearAllPoints()
	MM.coordspanel:SetPoint(E.db.sle.minimap.coords.position, _G["Minimap"])
end

function MM:CreateCoordsFrame()
	MM.coordspanel = CreateFrame('Frame', "SLE_CoordsPanel", _G["Minimap"])
	-- MM.coordspanel = CreateFrame('Frame', "SLE_CoordsPanel", E.UIParent)
	MM.coordspanel:Point("BOTTOM", _G["Minimap"], "BOTTOM", 0, 0)
	MM.coordspanel.WidthValue = 0
	-- MM.coordspanel:CreateBackdrop()

	MM.coordspanel.Text = MM.coordspanel:CreateFontString(nil, "OVERLAY")
	-- MM.coordspanel.Text:SetAllPoints(MM.coordspanel)
	MM.coordspanel.Text:SetPoint("CENTER", MM.coordspanel)
	MM.coordspanel.Text:SetWordWrap(false)

	_G["Minimap"]:HookScript('OnEnter', function(self)
		if E.db.sle.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then return; end
		MM.coordspanel:Show()
	end)

	_G["Minimap"]:HookScript('OnLeave', function(self)
		if E.db.sle.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then return; end
		MM.coordspanel:Hide()
	end)

	MM:UpdateCoordinatesPosition()
end

function MM:PLAYER_ENTERING_WORLD()
	local x = T.GetPlayerMapPosition("player")
	if not x then
		MM.RestrictedArea = true
	else
		MM.RestrictedArea = false
	end
end

function MM:UpdateSettings()
	if E.db.sle.minimap.alpha then E.db.sle.minimap.alpha = nil end
	if not MM.coordspanel then
		MM:CreateCoordsFrame()
	end
	MM:CoordFont()
	MM:CoordsSize()

	MM.coordspanel:SetPoint(E.db.sle.minimap.coords.position, _G["Minimap"])
	MM.coordspanel:SetScript('OnUpdate', MM.UpdateCoords)

	MM:UpdateCoordinatesPosition()
	if E.db.sle.minimap.coords.display ~= 'SHOW' or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then
		MM.coordspanel:Hide()
	else
		MM.coordspanel:Show()
	end
	MM:HideMinimapRegister()
end

function MM:Initialize()
	if not SLE.initialized or not E.private.general.minimap.enable then return end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	hooksecurefunc(M, 'UpdateSettings', MM.UpdateSettings)

	MM:UpdateSettings()
end

SLE:RegisterModule(MM:GetName())