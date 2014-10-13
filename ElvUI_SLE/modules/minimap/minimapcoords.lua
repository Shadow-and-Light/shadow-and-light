local E, L, V, P, G = unpack(ElvUI);
local M = E:GetModule('Minimap')

local GetPlayerMapPosition = GetPlayerMapPosition
local framescreated = false
local panel, xpos, ypos
local middle

local cluster = _G['MinimapCluster']

local function HideMinimap()
	cluster:Hide()
end

local function ShowMinimap()
	if not InCombatLockdown() then
		UIFrameFadeIn(cluster, 0.2, cluster:GetAlpha(), 1)
	end
end

local function UpdateCoords(self, elapsed)
	local f = E.db.sle.minimap.coords.decimals and '%.2f' or '%.0f'
	panel.elapsed = (panel.elapsed or 0) + elapsed
	if panel.elapsed < .1 then return end

	xpos.pos, ypos.pos = GetPlayerMapPosition('player')
	xpos.text:SetFormattedText(E.db.sle.minimap.coords.middle == "CENTER" and f..'/' or f, xpos.pos * 100)
	ypos.text:SetFormattedText(f, ypos.pos * 100)

	panel.elapsed = 0
end

function M:SLEHideMinimap()
	if E.db.sle.minimap.combat then
		M:RegisterEvent("PLAYER_REGEN_DISABLED", HideMinimap)	
		M:RegisterEvent("PLAYER_REGEN_ENABLED", ShowMinimap)
	else
		M:UnregisterEvent("PLAYER_REGEN_DISABLED")	
		M:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

local function UpdatePosition(middle)
	xpos:ClearAllPoints()
	ypos:ClearAllPoints()
	if middle == "CENTER" then
		xpos:Point('BOTTOMRIGHT', panel, 'BOTTOM',10, 0)
	else
		xpos:Point('LEFT', panel, 'LEFT', 2, 0)
	end
	if middle == "CENTER" then
		ypos:Point('BOTTOMLEFT', panel, 'BOTTOM', E.db.sle.minimap.coords.decimals and 0 or -15, 0)
	else
		ypos:Point('RIGHT', panel, 'RIGHT', 2, 0)
	end
end

local function CreateCoordsFrame(middle)
	panel = CreateFrame('Frame', 'CoordsPanel', E.UIParent)
	panel:SetFrameStrata("MEDIUM")
	panel:Point("CENTER", Minimap, "CENTER", 0, 0)
	panel:Size(E.MinimapSize, 22)
	E.FrameLocks['CoordsPanel'] = true;

	xpos = CreateFrame('Frame', "MapCoordinatesX", panel)
	xpos:Size(40, 22)

	xpos.text = xpos:CreateFontString(nil, "OVERLAY")
	xpos.text:FontTemplate(E.media.font, 12, "OUTLINE")
	xpos.text:SetAllPoints(xpos)

	ypos = CreateFrame('Frame', "MapCoordinatesY", panel)
	ypos:Size(40, 22)
	
	ypos.text = ypos:CreateFontString(nil, "OVERLAY")
	ypos.text:FontTemplate(E.media.font, 12, "OUTLINE")
	ypos.text:SetAllPoints(ypos)
	Minimap:HookScript('OnEnter', function(self)
		if E.db.sle.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.sle.minimap.enable then return; end
		panel:Show()
	end)

	Minimap:HookScript('OnLeave', function(self)
		if E.db.sle.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.sle.minimap.enable then return; end
		panel:Hide()
	end)	
	framescreated = true
	
	UpdatePosition(middle)
end

function M:Transparency()
	cluster:SetAlpha(E.db.sle.minimap.alpha)
end

local function Update()
	middle = E.db.sle.minimap.coords.middle

	if not framescreated then
		CreateCoordsFrame(middle)
	end

	panel:SetPoint('BOTTOM', Minimap, 'BOTTOM', 0, -(E.PixelMode and 1 or 2))
	panel:Size(E.MinimapSize, 22)
	panel:SetScript('OnUpdate', UpdateCoords)
	UpdatePosition(middle)
	if E.db.sle.minimap.coords.display ~= 'SHOW' or not E.private.general.minimap.enable or not E.db.sle.minimap.enable then
		panel:Hide()
	else
		panel:Show()
	end
	
	M:SLEHideMinimap()
	M:Transparency()
end

hooksecurefunc(M, 'UpdateSettings', Update)