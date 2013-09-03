local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
--local TTOS = E:NewModule('TooltipOffset', 'AceEvent-3.0')
local TT = E:GetModule('Tooltip');

--local _G = getfenv(0)
--local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]

--Defaults
P['tooltip']['mouseOffsetX'] = 0
P['tooltip']['mouseOffsetY'] = 0
P['tooltip']['overrideCombat'] = false

--Functions to hook
TT.GameTooltip_SetDefaultAnchorSLE = TT.GameTooltip_SetDefaultAnchor
function TT:GameTooltip_SetDefaultAnchor(tt, parent)
	TT:GameTooltip_SetDefaultAnchorSLE(tt, parent)
	if E.private["tooltip"].enable ~= true then return end
	if(tt:GetAnchorType() ~= "ANCHOR_NONE") then return end
	if InCombatLockdown() and self.db.visibility.combat then
		tt:Hide()
		return
	end

	if(parent) then
		if(self.db.cursorAnchor) then
			--tt:SetOwner(parent, "ANCHOR_CURSOR")
			TTOS:AnchorFrameToMouse(tt);
			return		
		end
	end
end

--[[
function TTOS:GameTooltip_OnUpdate(tt)
	if (tt.needRefresh and tt:GetAnchorType() == 'ANCHOR_CURSOR' and E.db.tooltip.anchor ~= 'CURSOR') then
		tt:SetBackdropColor(unpack(E["media"].backdropfadecolor))
		tt:SetBackdropBorderColor(unpack(E["media"].bordercolor))
		tt.needRefresh = nil
	elseif tt.forceRefresh then
		tt.forceRefresh = nil
	else
		TTOS:AnchorFrameToMouse(tt)
	end
end
]]

function TT:AnchorFrameToMouse(frame)
	if frame:GetAnchorType() ~= "ANCHOR_CURSOR" then return end
	--if (E.db.tooltip.onlyMod and not (IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown())) then return end
	local x, y = GetCursorPosition();
	local scale = frame:GetEffectiveScale();
	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (x/scale + E.db.tooltip.mouseOffsetX), (y/scale + E.db.tooltip.mouseOffsetY));
end

function TT:AddonName_OnUpdate(self, elapsed)
  TT:AnchorFrameToMouse(self);
end

--function TTOS:MODIFIER_STATE_CHANGED(event, key)
	--if InCombatLockdown() and E.db.tooltip.combathide and not (E.db.tooltip.overrideCombat and IsShiftKeyDown()) then
	--		GameTooltip:Hide()
	--end
--end
	
--Hooking
--local TTFrame = CreateFrame('Frame', 'TTOS')
--TTFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
--TTFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
--TTFrame:SetScript("OnEvent",function(self, event)
 --   if event == "PLAYER_ENTERING_WORLD" then
		--hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", TT.GameTooltip_SetDefaultAnchor)
		--hooksecurefunc(TT, "GameTooltip_OnUpdate", TTOS.GameTooltip_OnUpdate)
		--TTFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	--end
	--if event == "MODIFIER_STATE_CHANGED" then
		--TTOS:MODIFIER_STATE_CHANGED()
	--end
--end)
--TTOSFrame:SetScript("OnUpdate", function(self)
--	hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", TTOS.GameTooltip_SetDefaultAnchor)
--end)

TT.InitializeSLE = TT.Initialize
function TT:Initialize()
	TT:InitializeSLE()
	self:HookScript(GameTooltip, "OnUpdate", "AddonName_OnUpdate");
end

--E:RegisterModule(TTOS:GetName())