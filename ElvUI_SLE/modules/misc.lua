local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local M = SLE.Misc

local _G = _G
M.ViewportInitialized = false

--Viewports
function M:SetAllPoints()
	if InCombatLockdown() or SLE._Compatibility['SunnArt'] or not M.ViewportInitialized or not E.private.sle.viewport.enable then return end
	M:SetViewport()
end

function M:SetViewport(event)
	if InCombatLockdown() then
		M:RegisterEvent("PLAYER_REGEN_ENABLED",  M.SetViewport)
		return
	end
	if event == "PLAYER_REGEN_ENABLED" then M:UnregisterEvent(event) end
	if SLE._Compatibility['SunnArt'] or not M.ViewportInitialized or not E.private.sle.viewport.enable then return end
	local scale = E.global.general.UIScale

	_G.WorldFrame:ClearAllPoints()
	_G.WorldFrame:SetPoint('TOPLEFT', (M.db.viewport.left * scale), -(M.db.viewport.top * scale))
	_G.WorldFrame:SetPoint('BOTTOMRIGHT', -(M.db.viewport.right * scale), (M.db.viewport.bottom * scale))
end

function M:Initialize()
	if not SLE.initialized then return end
	M.db = E.db.sle.misc

	--Viewport
	-- function CinematicFrame_CancelCinematic()
	-- 	if ( CinematicFrame.isRealCinematic ) then
	-- 		StopCinematic()
	-- 	elseif ( CanCancelScene() ) then
	-- 		CancelScene()
	-- 	else
	-- 		VehicleExit()
	-- 	end
	-- end

	--Some high level bullshit
	-- WorldFrame.ORClear = WorldFrame.ClearAllPoints
	-- WorldFrame.ClearAllPoints = M.ClearAllPoints

	if SLE._Compatibility['SunnArt'] or not E.private.sle.viewport.enable then return end
	M.ViewportInitialized = true
	WorldFrame.ORSetAll = WorldFrame.SetAllPoints
	WorldFrame.SetAllPoints = M.SetAllPoints

	-- Possible Fix for Cut Scene issues during a raid
	CinematicFrame:SetScript('OnShow', nil)
	CinematicFrame:SetScript('OnHide', nil)

	hooksecurefunc(E, 'PixelScaleChanged', M.SetViewport)

	function M:ForUpdateAll()
		M.db = E.db.sle.misc
		M:SetViewport()
	end

	M:RegisterEvent("LOADING_SCREEN_DISABLED", M.SetViewport)
	M:RegisterEvent("CINEMATIC_STOP", M.SetViewport)
end

SLE:RegisterModule(M:GetName())
