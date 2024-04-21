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
	if SLE._Compatibility['SunnArt'] or not M.ViewportInitialized or not E.private.sle.viewport.enable then return end --compatibility check in the func itself just in case
	if InCombatLockdown() then --Don't touch stuff in combat
		M:RegisterEvent("PLAYER_REGEN_ENABLED",  M.SetViewport) --Register as M, cause self may be the world frame itself when called from WorldFrame.SetAllPoints/M:SetAllPoints
		return
	end
	if event == "PLAYER_REGEN_ENABLED" then M:UnregisterEvent(event) end --Unreg combat end event, cause we need it only once anyways
	
	local scale = E.global.general.UIScale --Get UI scale
	--Reposition world frame, this actually creating viewport
	_G.WorldFrame:ClearAllPoints()
	_G.WorldFrame:SetPoint('TOPLEFT', (M.db.viewport.left * scale), -(M.db.viewport.top * scale))
	_G.WorldFrame:SetPoint('BOTTOMRIGHT', -(M.db.viewport.right * scale), (M.db.viewport.bottom * scale))
end

function M:Initialize()
	if not SLE.initialized then return end
	M.db = E.db.sle.misc

	--Viewport
	if SLE._Compatibility['SunnArt'] or not E.private.sle.viewport.enable then return end --do not enable if otherr stuff is there
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
