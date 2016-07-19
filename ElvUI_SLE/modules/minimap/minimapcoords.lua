local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule('Minimap')
local MM = SLE:NewModule("Minimap", 'AceHook-3.0', 'AceEvent-3.0')
local LSM = LibStub("LibSharedMedia-3.0");
local _G = _G
local cluster = _G["MinimapCluster"]
local UIFrameFadeIn = UIFrameFadeIn

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
	x = T.format(E.db.sle.minimap.coords.format, x * 100)
	y = T.format(E.db.sle.minimap.coords.format, y * 100)
	
	return x, y
end

function MM:UpdateCoords(elapsed)
	MM.coordspanel.elapsed = (MM.coordspanel.elapsed or 0) + elapsed
	if MM.coordspanel.elapsed < E.db.sle.minimap.coords.throttle then return end

	local x, y = CreateCoords()
	if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
	if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
	MM.coordspanel.Text:SetText(x.." , "..y)
	if not MM.coordspanel.FirstLoad then
		MM.coordspanel.FirstLoad = true
		MM:CoordsSize()
	end
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
	MM.coordspanel.Text:SetFont(LSM:Fetch('font', E.db.sle.minimap.coords.font), E.db.sle.minimap.coords.fontSize, E.db.sle.minimap.coords.fontOutline)
end

function MM:CoordsSize()
	local size = MM.coordspanel.Text:GetStringWidth()
	MM.coordspanel:Size(size + 4, E.db.sle.minimap.coords.fontSize + 2)
end

function MM:UpdateCoordinatesPosition()
	MM.coordspanel:ClearAllPoints()
	MM.coordspanel:SetPoint(E.db.sle.minimap.coords.position, Minimap)
end

function MM:CreateCoordsFrame()
	MM.coordspanel = CreateFrame('Frame', "SLE_CoordsPanel", E.UIParent)
	-- MM.coordspanel:SetFrameStrata("MEDIUM")
	MM.coordspanel:Point("BOTTOM", Minimap, "BOTTOM", 0, 0)
	-- MM.coordspanel:CreateBackdrop()
	E.FrameLocks["SLE_CoordsPanel"] = true;

	MM.coordspanel.Text = MM.coordspanel:CreateFontString(nil, "OVERLAY")
	MM.coordspanel.Text:SetAllPoints(MM.coordspanel)
	MM.coordspanel.Text:SetWordWrap(false)

	Minimap:HookScript('OnEnter', function(self)
		if E.db.sle.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then return; end
		MM.coordspanel:Show()
	end)

	Minimap:HookScript('OnLeave', function(self)
		if E.db.sle.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then return; end
		MM.coordspanel:Hide()
	end)

	MM:UpdateCoordinatesPosition()
end

function MM:MinimapTransparency()
	cluster:SetAlpha(E.db.sle.minimap.alpha)
end

function MM:UpdateSettings()
	if not MM.coordspanel then
		MM:CreateCoordsFrame()
	end
	MM:CoordFont()
	MM:CoordsSize()

	MM.coordspanel:SetPoint(E.db.sle.minimap.coords.position, Minimap)
	MM.coordspanel:SetScript('OnUpdate', MM.UpdateCoords)

	MM:UpdateCoordinatesPosition()
	if E.db.sle.minimap.coords.display ~= 'SHOW' or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then
		MM.coordspanel:Hide()
	else
		MM.coordspanel:Show()
	end
	MM:HideMinimapRegister()
	MM:MinimapTransparency()
end

function MM:Initialize()
	if not SLE.initialized then return end

	hooksecurefunc(M, 'UpdateSettings', MM.UpdateSettings)

	MM:UpdateSettings()
end

SLE:RegisterModule(MM:GetName())