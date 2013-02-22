local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local M = E:GetModule('Minimap')

local GetPlayerMapPosition = GetPlayerMapPosition
local framescreated = false
local panel, xpos, ypos

local function UpdateCoords(self, elapsed)
	panel.elapsed = (panel.elapsed or 0) + elapsed
	if panel.elapsed < .1 then return end

	xpos.pos, ypos.pos = GetPlayerMapPosition('player')
	xpos.text:SetFormattedText('%.2f', xpos.pos * 100)
	ypos.text:SetFormattedText('%.2f', ypos.pos * 100)

	panel.elapsed = 0
end

local function CreateCoordsFrame()
	panel = CreateFrame('Frame', 'EnhancedLocationPanel', E.UIParent)
	panel:SetFrameStrata("MEDIUM")
	panel:Point("CENTER", Minimap, "CENTER", 0, 0)
	panel:Size(E.MinimapSize, 22)

	xpos = CreateFrame('Frame', "MapCoordinatesX", panel)
	xpos:Point('LEFT', panel, 'LEFT', 2, 0)
	xpos:Size(40, 22)
	
	xpos.text = xpos:CreateFontString(nil, "OVERLAY")
	xpos.text:FontTemplate(E.media.font, 12, "OUTLINE")
	xpos.text:SetAllPoints(xpos)

	ypos = CreateFrame('Frame', "MapCoordinatesY", panel)
	ypos:Point('RIGHT', panel, 'RIGHT', -2, 0)
	ypos:Size(40, 22)

	ypos.text = ypos:CreateFontString(nil, "OVERLAY")
	ypos.text:FontTemplate(E.media.font, 12, "OUTLINE")
	ypos.text:SetAllPoints(ypos)
	Minimap:HookScript('OnEnter', function(self)
		if E.db.general.minimap.locationText ~= 'MOUSEOVER' or not E.private.general.minimap.enable then return; end
		panel:Show()
	end)

	Minimap:HookScript('OnLeave', function(self)
		if E.db.general.minimap.locationText ~= 'MOUSEOVER' or not E.private.general.minimap.enable then return; end
		panel:Hide()
	end)	
	framescreated = true
end

M.UpdateSettingsSLE = M.UpdateSettings
function M:UpdateSettings()
	M.UpdateSettingsSLE(self)

	if not framescreated then
		CreateCoordsFrame()
	end

	panel:SetPoint('BOTTOM', Minimap, 'BOTTOM', 0, -(E.PixelMode and 1 or 2))
	panel:Size(E.MinimapSize, 22)
	panel:SetScript('OnUpdate', UpdateCoords)
	if E.db.general.minimap.locationText ~= 'SHOW' or not E.private.general.minimap.enable then
		panel:Hide()
	else
		panel:Show()
	end
end