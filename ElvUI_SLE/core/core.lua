local E, L, V, P, G = unpack(ElvUI);
local EP = LibStub("LibElvUIPlugin-1.0")
local AddOnName, Engine = ...;

local _G = _G

local SLE = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", 'AceTimer-3.0', 'AceHook-3.0');
SLE.callbacks = SLE.callbacks or LibStub("CallbackHandler-1.0"):New(SLE)
 
SLE.version = GetAddOnMetadata("ElvUI_SLE", "Version")

BINDING_HEADER_SLE = "|cff9482c9Shadow & Light|r"

--Creating a toolkit table
local Toolkit = {}

--localizing functions and stuff--

SLE.elvV = tonumber(E.version)
SLE.elvR = tonumber(GetAddOnMetadata("ElvUI_SLE", "X-ElvVersion"))

--Setting up table to unpack. Why? no idea
Engine[1] = SLE
Engine[2] = Toolkit
Engine[3] = E
Engine[4] = L
Engine[5] = V
Engine[6] = P
Engine[7] = G
_G[AddOnName] = Engine;

--A function to concentrate options from different modules to a single table used in plugin reg
local function GetOptions()
	for _, func in Toolkit.pairs(SLE.Configs) do
		func()
	end
end

function SLE:OnInitialize()
	--Incompatibility stuff will go here
	SLE:CheckIncompatible()
	SLE:AddTutorials()
end

local f=CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	SLE:Initialize()
end)

function SLE:ConfigCats() --Additional mover groups
	Toolkit.tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L");
	E.ConfigModeLocalizedStrings["S&L"] = L["S&L: All"]
	Toolkit.tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L DT");
	E.ConfigModeLocalizedStrings["S&L DT"] = L["S&L: Datatexts"]
	-- if E.private.sle.backgrounds then
	Toolkit.tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L BG");
	E.ConfigModeLocalizedStrings["S&L BG"] = L["S&L: Backgrounds"]
	-- end
	Toolkit.tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L MISC");
	E.ConfigModeLocalizedStrings["S&L MISC"] = L["S&L: Misc"]
end

function SLE:IncompatibleAddOn(addon, module, optiontable, value)
	E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].button1 = addon
	E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].button2 = 'S&L: '..module
	E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].addon = addon
	E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].module = module
	E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].optiontable = optiontable
	E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].value = value
	E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].showAlert = true
	E:StaticPopup_Show('SLE_INCOMPATIBLE_ADDON', addon, module)
end

function SLE:CheckIncompatible()
	if Toolkit.IsAddOnLoaded('ElvUI_Enhanced') and not E.global.ignoreEnhancedIncompatible then
		E:StaticPopup_Show('ENHANCED_SLE_INCOMPATIBLE')
	end
	if Toolkit.IsAddOnLoaded('SquareMinimapButtons') and E.private.sle.minimap.mapicons.enable then
		SLE:IncompatibleAddOn('SquareMinimapButtons', 'SquareMinimapButtons', E.private.sle.minimap.mapicons, "enable")
	end
	if Toolkit.IsAddOnLoaded('ElvUI_LocLite') and E.db.sle.minimap.locPanel.enable then
		SLE:IncompatibleAddOn('Location Lite', 'Location Panel', E.db.sle.minimap.locPanel.enable, "enable")
	end
	if Toolkit.IsAddOnLoaded('LootConfirm') then
		E:StaticPopup_Show('LOOTCONFIRM_SLE_INCOMPATIBLE')
	end
	if Toolkit.IsAddOnLoaded('ElvUITransparentActionbars') then
		E:StaticPopup_Show('TRANSAB_SLE_INCOMPATIBLE')
	end
end

local GetAddOnEnableState = GetAddOnEnableState
--Check if some stuff happens to be enable
SLE._Compatibility = {}
local _CompList = {
	"oRA3",
	"ElvUI_CustomTweaks",
	"ElvUI_MerathilisUI",
	"QuestKing",
	"ElvUI_Enhanced",
}
for i = 1, #_CompList do
	if GetAddOnEnableState(E.myname, _CompList[i]) == 0 then SLE._Compatibility[_CompList[i]] = nil else SLE._Compatibility[_CompList[i]] = true end
end

function SLE:Initialize()
	--ElvUI's version check
	if SLE.elvV < 10 then return end

	if SLE.elvV < SLE.elvR then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return --Not loading shit if version is too old, prevents shit from being broken
	end
	SLE:ConfigCats()
	self.initialized = true
	self:InitializeModules(); --Load Modules

	SLE:SetCompareItems() --Blizz cvar for item compare

	hooksecurefunc(E, "UpdateAll", SLE.UpdateAll)
	--Here goes installation script

	--Annoying message
	if E.db.general.loginmessage then
		Toolkit.print(Toolkit.format(L["SLE_LOGIN_MSG"], E["media"].hexvaluecolor, SLE.version))
	end

	SLE:BuildGameMenu()
	SLE:CyrillicsInit()

	if E.private.sle.install_complete == nil or tonumber(E.private.sle.install_complete) < 3 then
		E:GetModule("PluginInstaller"):Queue(SLE.installTable)
		-- E:GetModule("PluginInstaller"):Queue(SLE.installTable2)
	end

	LibStub("LibElvUIPlugin-1.0"):RegisterPlugin(AddOnName, GetOptions) --Registering as plugin
end