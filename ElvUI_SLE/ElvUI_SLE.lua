local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SLE = E:NewModule('SLE', 'AceHook-3.0', 'AceEvent-3.0');
local UF = E:GetModule('UnitFrames');
local DTP

SLE.version = GetAddOnMetadata("ElvUI_SLE", "Version")

function SLE:Tutorials() --Additional tutorials
	table.insert(E.TutorialList, #(E.TutorialList)+1, L["To enable full values of health/power on unitframes in Shadow & Light add \":sl\" to the end of the health/power tag.\nExample: [health:current:sl]."]);
end

function SLE:ConfigCats() --Additional mover groups
	table.insert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L");
	E.ConfigModeLocalizedStrings["S&L"] = L["S&L: All"]
	table.insert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L DT");
	E.ConfigModeLocalizedStrings["S&L DT"] = L["S&L: Datatexts"]
	table.insert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L BG");
	E.ConfigModeLocalizedStrings["S&L BG"] = L["S&L: Backgrounds"]
	table.insert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L M");
	E.ConfigModeLocalizedStrings["S&L M"] = L["S&L: Misc"]
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
		if E.PixelMode then
			E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT019"
		else
			E.db.movers.LeftChatMover = "BOTTOMLEFTUIParentBOTTOMLEFT021"
		end
		E:SetMoversPositions()
	end
	
	if not E:HasMoverBeenMoved("RightChatMover") and E.db.datatexts.rightChatPanel then
		if not E.db.movers then E.db.movers = {}; end
		if E.PixelMode then
			E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT019"
		else
			E.db.movers.RightChatMover = "BOTTOMRIGHTUIParentBOTTOMRIGHT021"
		end
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
E.PopupDialogs["ELVUI_SLE_REPOOC"] = {
	text = L["Repooc configuration requires PixelPerfect to be enabled. Hit accept to enable Pixel Perfect, hit cancel to not use Repooc's Config."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		E:SetupPixelPerfect(true)
		E:RepoocSetup()
	end,
	timeout = 0,
	whileDead = 1,
}
--Showing warning message about too old versions of ElvUI
if tonumber(E.version) < 5.26 then
	E:StaticPopup_Show("VERSION_MISMATCH")
end

E.UpdateAllSLE = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllSLE(self)
	E:GetModule('BackGrounds'):UpdateFrames()
	E:GetModule('BackGrounds'):RegisterHide()
	DTP:Update()
	DTP:DashboardShow()
	DTP:DashWidth()
	if E.private.unitframe.enable then
		UF:Update_CombatIndicator()
	end
	E:GetModule('UIButtons'):UpdateAll()
	E.db.datatexts.panels.Top_Center = 'Version'
	SLE:ChatPos()
end

function SLE:Reset(all, uf, dt, bg, mark)
	if all then --Reset All button
		E:CopyTable(E.db.sle, P.sle)
		E:ResetMovers(L["DP_1"])
		E:ResetMovers(L["DP_2"])
		E:ResetMovers(L["DP_3"])
		E:ResetMovers(L["DP_4"])
		E:ResetMovers(L["DP_5"])
		E:ResetMovers(L["DP_6"])
		E:ResetMovers(L["Top_Center"])
		E:ResetMovers(L["Bottom_Panel"])
		E:ResetMovers(L["Dashboard"])
		E:ResetMovers(L["Pet Battle AB"])
		E:ResetMovers("PvP")
		E:ResetMovers('RM')
		E:ResetMovers(L["UI Buttons"])
		E:ResetMovers(L["Bottom BG"])
		E:ResetMovers(L["Left BG"])
		E:ResetMovers(L["Right BG"])
		E:ResetMovers(L["Actionbar BG"])
	end
	if uf then
		E.db.sle.combatico.pos = 'TOP'
		E:CopyTable(E.db.unitframe.units.player.classbar, P.unitframe.units.player.classbar)
		E.db.unitframe.units.player.fixTo = "health"
		E.db.unitframe.units.target.fixTo = "health"
		E.db.unitframe.units.targettarget.fixTo = "health"
		E.db.unitframe.units.focus.fixTo = "health"
		E.db.unitframe.units.arena.fixTo = "health"
		E.db.unitframe.units.boss.fixTo = "health"
		E.db.sle.powtext = false
	end
	if dt then
		E:CopyTable(E.db.sle.datatext, P.sle.datatext)
		E:ResetMovers(L["DP_1"])
		E:ResetMovers(L["DP_2"])
		E:ResetMovers(L["DP_3"])
		E:ResetMovers(L["DP_4"])
		E:ResetMovers(L["DP_5"])
		E:ResetMovers(L["DP_6"])
		E:ResetMovers(L["Top_Center"])
		E:ResetMovers(L["Bottom_Panel"])
		E:ResetMovers(L["Dashboard"])
	end
	if bg then
		E:CopyTable(E.db.sle.backgrounds, P.sle.backgrounds)
		E:ResetMovers(L["Bottom BG"])
		E:ResetMovers(L["Left BG"])
		E:ResetMovers(L["Right BG"])
		E:ResetMovers(L["Actionbar BG"])
	end
	if mark then
		E:CopyTable(E.db.sle.marks, P.sle.marks)
		E:ResetMovers('RM')
	end
	E:UpdateAll()
end

function SLE:Initialize()
	DTP = E:GetModule('DTPanels')
	if E.private.unitframe.enable then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", UF.Update_CombatIndicator);
	end
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow');
	if E.db.general.loginmessage then
		print(format(L['SLE_LOGIN_MSG'], E["media"].hexvaluecolor, SLE.version))
	end
	E.db.datatexts.panels.Top_Center = 'Version'
	DTP:DashboardShow()
	SLE:Tutorials()
	SLE:ConfigCats()
	SLE:ChatPos()
end

E:RegisterModule(SLE:GetName())