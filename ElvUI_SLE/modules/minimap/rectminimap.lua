local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local RMM = SLE.RectangleMinimap
local MM = E.Minimap

--GLOBALS: unpack, select, hooksecurefunc
local _G = _G

function RMM:UpdateMoverSize()
	if E.db.datatexts.panels.MinimapPanel.enable then
		_G.ElvUI_MinimapHolder:Height((_G.Minimap:GetHeight() + (_G.MinimapPanel and (_G.MinimapPanel:GetHeight() + E.Border) or 24)) + E.Spacing*3-((E.MinimapSize/6.1)))
	else
		_G.ElvUI_MinimapHolder:Height((_G.Minimap:GetHeight() + E.Border + E.Spacing*3)-(E.MinimapSize/6.1))
	end
end

function RMM:UpdateLocationText()
	_G.Minimap.location:ClearAllPoints()
	_G.Minimap.location:Point('TOP', _G.Minimap, 'TOP', 0, -25)
end

function RMM:ChangeShape()
	if InCombatLockdown() then
		return
	end

	local BAR_HEIGHT = 22
	local rectmask = 'Interface\\AddOns\\ElvUI_SLE\\media\\textures\\map\\rectangle'

	_G.Minimap:SetClampedToScreen(true)
	_G.Minimap:SetMaskTexture(rectmask)
	_G.Minimap:Size(E.MinimapSize, E.MinimapSize)
	_G.Minimap:SetHitRectInsets(0, 0, (E.MinimapSize/6.1)*E.mult, (E.MinimapSize/6.1)*E.mult)
	_G.Minimap:SetClampRectInsets(0, 0, 0, 0)
	_G.Minimap:ClearAllPoints()
	_G.Minimap:Point('TOPRIGHT', _G.ElvUI_MinimapHolder, 'TOPRIGHT', -E.Border, E.Border)
	_G.Minimap.backdrop:SetOutside(_G.Minimap, 1, -(E.MinimapSize/6.1)+1)
	_G.MinimapBackdrop:SetOutside(_G.Minimap.backdrop)

	if _G.HybridMinimap then
		local rectangleMask = _G.HybridMinimap:CreateMaskTexture()
		rectangleMask:SetTexture(rectmask)
		rectangleMask:SetAllPoints(_G.HybridMinimap)
		_G.HybridMinimap.RectangleMask = rectangleMask
		_G.HybridMinimap.MapCanvas:SetMaskTexture(rectangleMask)
		_G.HybridMinimap.MapCanvas:SetUseMaskTexture(true)
	end

	RMM:UpdateMoverSize()
	RMM:UpdateLocationText()

	_G.MinimapPanel:ClearAllPoints()
	_G.MinimapPanel:Point('TOPLEFT', _G.Minimap, 'BOTTOMLEFT', -E.Border, (E.MinimapSize/6.1)-1)
	_G.MinimapPanel:Point('BOTTOMRIGHT', _G.Minimap, 'BOTTOMRIGHT', E.Border, ((E.MinimapSize/6.1)-BAR_HEIGHT)-1)
end

function RMM:PLAYER_ENTERING_WORLD()
	RMM:SetUpdateHook()
	RMM:UnregisterEvent('PLAYER_ENTERING_WORLD')
end

function RMM:ADDON_LOADED(_, addon)
	if addon == 'Blizzard_HybridMinimap' then
		RMM:ChangeShape()
		RMM:UnregisterEvent('ADDON_LOADED')
	end
end

function RMM:SetUpdateHook()
	if not self.Initialized then
		RMM:SecureHook(MM, 'SetGetMinimapShape', 'ChangeShape')
		RMM:SecureHook(MM, 'UpdateSettings', 'ChangeShape')
		RMM:SecureHook(MM, 'Initialize', 'ChangeShape')
		RMM:SecureHook(E, 'UpdateAll', 'ChangeShape')
		RMM:SecureHook(_G.ElvUI_MinimapHolder, 'Size', 'UpdateMoverSize')

		self.Initialized = true
	end

	RMM:ChangeShape()
end

function RMM:Initialize()
	if not E.private.general.minimap.enable or not E.private.sle.minimap.rectangle then return end
	RMM:RegisterEvent('ADDON_LOADED')
	RMM:RegisterEvent('PLAYER_ENTERING_WORLD')
	RMM:RegisterEvent('ZONE_CHANGED_NEW_AREA', RMM.ChangeShape)
end

SLE:RegisterModule(RMM:GetName())
