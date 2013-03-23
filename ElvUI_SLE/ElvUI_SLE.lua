local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SLE = E:NewModule('SLE', 'AceHook-3.0', 'AceEvent-3.0');
local UF = E:GetModule('UnitFrames');
local DTP
local EP = LibStub("LibElvUIPlugin-1.0")
local addon = ...

SLE.version = GetAddOnMetadata("ElvUI_SLE", "Version")
E.SLEConfigs = {}

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
	table.insert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L MISC");
	E.ConfigModeLocalizedStrings["S&L MISC"] = L["S&L: Misc"]
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
	E:GetModule('RaidMarks'):Update()
	E:GetModule('Farm'):UpdateLayout()
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

function SLE:BagSearch(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

function SLE:Print(msg)
	print(E["media"].hexvaluecolor..'S&L:|r', msg)
end

function SLE:GetOptions()
	for _, func in pairs(E.SLEConfigs) do
		func()
	end	
end

function SLE:Initialize()
	--Showing warning message about too old versions of ElvUI
	if tonumber(E.version) < 5.8 then
		E:StaticPopup_Show("VERSION_MISMATCH")
	end
	EP:RegisterPlugin(addon,SLE.GetOptions)
	DTP = E:GetModule('DTPanels')
	if E.private.unitframe.enable then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", UF.Update_CombatIndicator);
	end
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow');
	if E.db.general.loginmessage then
		print(format(L['SLE_LOGIN_MSG'], E["media"].hexvaluecolor, SLE.version))
	end
	DTP:DashboardShow()
	SLE:Tutorials()
	SLE:ConfigCats()
	SLE:ChatPos()
	SLE:RegisterCommands()
end

E:RegisterModule(SLE:GetName())