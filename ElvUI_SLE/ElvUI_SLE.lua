local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SLE = E:NewModule('SLE', 'AceHook-3.0', 'AceEvent-3.0');

function SLE:Tutorials() --Additional tutorials
	table.insert(E.TutorialList, #(E.TutorialList)+1, L["To enable full values of health/power on unitframes in Shadow & Light add \":sl\" to the end of the health/power tag.\nExample: [health:current:sl]."]);
end

function SLE:ConfigCats() --Additional config groups
	table.insert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L");
	E.ConfigModeLocalizedStrings["S&L"] = "S&L"
end

--Updating things that must be updated only after everything loads
function SLE:UpdateThings()
	if E.private.unitframe.enable then
		E:GetModule('UnitFrames'):Update_CombatIndicator()
	end
end

function SLE:LootShow()
	local instance = IsInInstance()
	LootHistoryFrame:SetAlpha(E.db.sle.lootalpha or 1)

	if (not instance and E.db.sle.lootwin) then
		LootHistoryFrame:Hide()
	end
end

function SLE:ChatPos()
	if not E:HasMoverBeenMoved("LeftChatMover") and E.db.datatexts.leftChatPanel then
		if not E.db.movers then E.db.movers = {}; end
		E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT021"
		E:SetMoversPositions()
	end
	
	if not E:HasMoverBeenMoved("RightChatMover") and E.db.datatexts.rightChatPanel then
		if not E.db.movers then E.db.movers = {}; end
		E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT021"
		E:SetMoversPositions()
	end
end

E.PopupDialogs["VERSION_MISMATCH"] = {
	text = L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."],
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3,
}

--Showing warning message about too old versions of ElvUI
if tonumber(E.version) < 4.57 then
	E:StaticPopup_Show("VERSION_MISMATCH")
end

E.UpdateAllSLE = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllSLE(self)
	E:GetModule('BackGrounds'):UpdateFrames()
	E:GetModule('DTPanels'):Update()
	E:GetModule('DTPanels'):DashboardShow()
	E:GetModule('DTPanels'):DashWidth()
	if E.private.unitframe.enable then
		E:GetModule('UnitFrames'):Update_CombatIndicator()
	end
	E:GetModule('UIButtons'):UpdateAll()
	E.db.datatexts.panels.Top_Center = 'Version'
	E:GetModule('DataTexts'):LoadDataTexts() --Prevents datatexts from not changing on profile switch (Elv's issue)
	E:GetModule('RaidUtility'):MoveButton()
	SLE:ChatPos()
end


function SLE:Initialize()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateThings");
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow');
	if E.db.general.loginmessage then
		print(L['SLE_LOGIN_MSG'])
	end
	E.db.datatexts.panels.Top_Center = 'Version'
	E:GetModule('DTPanels'):DashboardShow()
	E:GetModule('Layout'):EditboxPos()
	SLE:Tutorials()
	SLE:ConfigCats()
	SLE:ChatPos()
end

E:RegisterModule(SLE:GetName())