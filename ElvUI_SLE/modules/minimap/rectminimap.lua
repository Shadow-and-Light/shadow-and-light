local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local RMM = SLE:NewModule("RectangleMinimap")
local MM = E:GetModule('Minimap')

--GLOBALS: unpack, select, _G, hooksecurefunc
local _G = _G

local BAR_HEIGHT = 22

function RMM:SkinMiniMap()
	_G.Minimap:SetMaskTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\map\\rectangle')
	_G.Minimap:Size(E.MinimapSize, E.MinimapSize)
	_G.Minimap:SetHitRectInsets(0, 0, (E.MinimapSize/6.1)*E.mult, (E.MinimapSize/6.1)*E.mult)
	_G.Minimap:SetClampRectInsets(0, 0, 0, 0)

	RMM:UpdateMoverSize()

	--*Relocated Minimap to MMHolder
	_G.Minimap:ClearAllPoints()
	_G.Minimap:Point("TOPRIGHT", _G.MMHolder, "TOPRIGHT", -E.Border, E.Border)
	--*Below sets mover to same size of minimap, I didn't do this on purpose due to people moving the minimap in an area not good
	-- _G.Minimap:Point("TOPRIGHT", _G.MMHolder, "TOPRIGHT", -E.Border, (E.MinimapSize/6.1)+E.Border)


	if _G.Minimap.location then
		RMM:UpdateLocationText()
	end

	_G.MinimapPanel:ClearAllPoints()
	_G.MinimapPanel:Point('TOPLEFT', _G.Minimap, 'BOTTOMLEFT', -E.Border, (E.MinimapSize/6.1)-1)
	_G.MinimapPanel:Point('BOTTOMRIGHT', _G.Minimap, 'BOTTOMRIGHT', E.Border, ((E.MinimapSize/6.1)-BAR_HEIGHT)-1)

	if _G.Minimap.backdrop then
		_G.Minimap.backdrop:SetOutside(_G.Minimap, 1, -(E.MinimapSize/6.1)+1)
	end
end

function RMM:UpdateMoverSize()
	if E.db.datatexts.panels.MinimapPanel.enable then
		_G.MMHolder:Height((_G.Minimap:GetHeight() + (_G.MinimapPanel and (_G.MinimapPanel:GetHeight() + E.Border) or 24)) + E.Spacing*3-((E.MinimapSize/6.1)))
	else
		_G.MMHolder:Height((_G.Minimap:GetHeight() + E.Border + E.Spacing*3)-(E.MinimapSize/6.1))
	end
end

function RMM:UpdateLocationText()
	_G.Minimap.location:ClearAllPoints()
	_G.Minimap.location:Point('TOP', _G.Minimap, 'TOP', 0, -25)
end

function RMM:Initialize()
	if not E.private.general.minimap.enable or not E.private.sle.minimap.rectangle then return end

	RMM:SkinMiniMap()
	hooksecurefunc(MM, "UpdateSettings", RMM.UpdateMoverSize)
end

SLE:RegisterModule(RMM:GetName())
