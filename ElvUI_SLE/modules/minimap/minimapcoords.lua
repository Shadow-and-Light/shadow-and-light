local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule('Minimap')
local MM = SLE:NewModule("Minimap", 'AceHook-3.0', 'AceEvent-3.0')

--GLOBALS: unpack, select, format, _G, UIFrameFadeIn, InCombatLockdown, CreateFrame, hooksecurefunc, SLECoordsHolder
local _G = _G
local format, UIFrameFadeIn = format, UIFrameFadeIn

local inRestrictedArea = false
local displayString = ''
local mapInfo = E.MapInfo

local function HideMinimap()
	_G.MinimapCluster:Hide()
end

local function ShowMinimap()
	if not InCombatLockdown() then
		UIFrameFadeIn(_G.MinimapCluster, 0.2, _G.MinimapCluster:GetAlpha(), 1)
	end
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

function MM:HandleEvent()
	if mapInfo.x and mapInfo.y then
		inRestrictedArea = false
		SLECoordsHolder.playerCoords:SetText(format(displayString, mapInfo.xText, mapInfo.yText))
	else
		inRestrictedArea = true
		SLECoordsHolder.playerCoords:SetText('N/A')
	end
end

function MM:UpdateCoords(elapsed)
	if inRestrictedArea or not E.MapInfo.coordsWatching then return end

	MM.elapsed = (MM.elapsed or 0) + elapsed
	if MM.elapsed < E.db.sle.minimap.coords.throttle then return end
	if mapInfo.x and mapInfo.y then
		-- inRestrictedArea = false
		-- displayString = E.db.sle.minimap.coords.format..", "..E.db.sle.minimap.coords.format
		SLECoordsHolder.playerCoords:SetText(format(displayString, mapInfo.xText, mapInfo.yText))
	else
		-- inRestrictedArea = true
		SLECoordsHolder.playerCoords:SetText('N/A')
	end

	MM.elapsed = 0
end

function MM:CoordFont()
	SLECoordsHolder.playerCoords:SetFont(E.LSM:Fetch('font', E.db.sle.minimap.coords.font), E.db.sle.minimap.coords.fontSize, E.db.sle.minimap.coords.fontOutline)
end

function MM:UpdateCoordinatesPosition()
	local db = E.db.sle.minimap.coords
	SLECoordsHolder.playerCoords:ClearAllPoints()
	SLECoordsHolder.playerCoords:Point("CENTER", _G.Minimap, "CENTER", db.xOffset, db.yOffset)
end

function MM:CreateCoordsFrame()
	local SLECoordsHolder = CreateFrame('Frame', 'SLECoordsHolder', _G.Minimap)
	SLECoordsHolder:SetFrameLevel(_G.Minimap:GetFrameLevel() + 10)
	SLECoordsHolder:SetFrameStrata(_G.Minimap:GetFrameStrata())
	SLECoordsHolder.playerCoords = SLECoordsHolder:CreateFontString(nil, 'OVERLAY')
	SLECoordsHolder:SetScript('OnUpdate', MM.UpdateCoords)

	_G.Minimap:HookScript('OnEnter', function()
		if not E.db.sle.minimap.coords.mouseover or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then return; end
		SLECoordsHolder:Show()
	end)
	_G.Minimap:HookScript('OnLeave', function()
		if not E.db.sle.minimap.coords.mouseover or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then return; end
		SLECoordsHolder:Hide()
	end)

	MM:UpdateCoordinatesPosition()
end

function MM:UpdateSettings()
	if not _G.SLECoordsHolder then
		MM:CreateCoordsFrame()
	end

	MM:CoordFont()
	MM:SetCoordsColor()
	MM:UpdateCoordinatesPosition()
	if E.db.sle.minimap.coords.mouseover or not E.private.general.minimap.enable or not E.db.sle.minimap.coords.enable then
		SLECoordsHolder:Hide()
	else
		SLECoordsHolder:Show()
	end

	displayString = E.db.sle.minimap.coords.format..", "..E.db.sle.minimap.coords.format
end

function MM:SetCoordsColor()
	local color = E.db.sle.minimap.coords.color
	SLECoordsHolder.playerCoords:SetTextColor(color.r, color.g, color.b)
end

function MM:Initialize()
	if not SLE.initialized or not E.private.general.minimap.enable then return end

	hooksecurefunc(M, 'UpdateSettings', MM.UpdateSettings)
	MM:UpdateSettings()
	MM:HideMinimapRegister()
	MM:RegisterEvent('LOADING_SCREEN_DISABLED', 'HandleEvent')
	MM:RegisterEvent('ZONE_CHANGED', "HandleEvent")
	MM:RegisterEvent('ZONE_CHANGED_INDOORS', 'HandleEvent')
	MM:RegisterEvent('ZONE_CHANGED_NEW_AREA', 'HandleEvent')
end

SLE:RegisterModule(MM:GetName())
