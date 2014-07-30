local E, L, V, P, G, _ = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local EP = LibStub("LibElvUIPlugin-1.0")
local UF = E:GetModule('UnitFrames')
local addon = ...

--localizing functions--
local IsInInstance = IsInInstance
local tinsert = tinsert

SLE.version = GetAddOnMetadata("ElvUI_SLE", "Version")
local elvV = tonumber(E.version)
local elvR = tonumber(GetAddOnMetadata("ElvUI_SLE", "X-ElvVersion"))
E.SLEConfigs = {}
--SLE['media'] = {}

--[[function SLE:MismatchText()
	local text = format(L['MSG_OUTDATED'],elvV,elvR)
	return text
end]]

local function AddTutorials() --Additional tutorials
	tinsert(E.TutorialList, #(E.TutorialList)+1, L["To enable full values of health/power on unitframes in Shadow & Light add \":sl\" to the end of the health/power tag.\nExample: [health:current:sl]."]);
end

local function ConfigCats() --Additional mover groups
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L");
	E.ConfigModeLocalizedStrings["S&L"] = L["S&L: All"]
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L DT");
	E.ConfigModeLocalizedStrings["S&L DT"] = L["S&L: Datatexts"]
	if E.private.sle.backgrounds then
		tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L BG");
		E.ConfigModeLocalizedStrings["S&L BG"] = L["S&L: Backgrounds"]
	end
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L MISC");
	E.ConfigModeLocalizedStrings["S&L MISC"] = L["S&L: Misc"]
end

local function GetOptions()
	for _, func in pairs(E.SLEConfigs) do
		func()
	end
end

local function IncompatibleAddOn(addon, module, optiontable, value)
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].button1 = addon
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].button2 = 'S&L: '..module
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].addon = addon
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].module = module
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].optiontable = optiontable
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].value = value
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].showAlert = true
	E:StaticPopup_Show('SLE_INCOMPATIBLE_ADDON', addon, module)
end

local function CheckIncompatible()
	if IsAddOnLoaded('ElvUI_Enhanced') and not E.global.ignoreEnhancedIncompatible then
		E:StaticPopup_Show('ENHANCED_SLE_INCOMPATIBLE')
	end
	if IsAddOnLoaded('SquareMinimapButtons') and E.private.sle.minimap.mapicons.enable then
		IncompatibleAddOn('SquareMinimapButtons', 'SquareMinimapButtons', E.private.sle.minimap.mapicons, "enable")
	end
end

function SLE:Initialize()
	--ElvUI's version check
	--[[if elvV < elvR then
		E:StaticPopup_Show("VERSION_MISMATCH")
	end]]
	EP:RegisterPlugin(addon, GetOptions)
	if E.private.unitframe.enable then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", UF.Update_CombatIndicator);
	end
	--if E.private.install_complete == E.version and E.private.sle.install_complete == nil then SLE:Install() end
	if E.db.general.loginmessage then
        SLE:Print(format(L['SLE_LOGIN_MSG'], E["media"].hexvaluecolor, SLE.version))
	end
	E:GetModule('SLE_DTPanels'):DashboardShow()
	AddTutorials()
	ConfigCats()
	SLE:RegisterCommands()
	CheckIncompatible()
end