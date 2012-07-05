-------------------------------------------------
--Here be Credits
-------------------------------------------------
--Testing line
local E, L, V, P, G =  unpack(ElvUI); --Engine, Locales, Profile, Global
local SLE = E:NewModule('SLE', 'AceHook-3.0', 'AceEvent-3.0');

function SLE:Initialize()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateThings");
	if E.db.general.loginmessage then
		print(L['SLE_LOGIN_MSG'])
	end
	E:GetModule('Chat'):SetTimer() --If called before Edit loaded from chat.lua will cause errors
	E.db.datatexts.panels.Top_Center = 'Version'
	if IsAddOnLoaded("ElvUI_LocPlus") and not E:HasMoverBeenMoved('LocationMover') then
		if not E.db.movers then E.db.movers = {}; end
		E.db.movers.LocationMover = "TOPUIParentTOP0-18"
	end
end

--Updating things that must be updated only after everything loads
function SLE:UpdateThings()
	E:GetModule('UnitFrames'):Update_CombatIndicator()
end

StaticPopupDialogs["VERSION_MISMATCH"] = {
	text = L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."],
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3,
}

--Showing warning message about too old versions of ElvUI
	if tonumber(E.version) < 3.86 then
		StaticPopup_Show("VERSION_MISMATCH")
	end

E.UpdateAllSLE = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllSLE(self)
	E:GetModule('DTPanels'):Update()
	E:GetModule('UnitFrames'):Update_CombatIndicator()
	E:GetModule('UIButtons'):Start()
	E.db.datatexts.panels.Top_Center = 'Version'
end

E:RegisterModule(SLE:GetName())