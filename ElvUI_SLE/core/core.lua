local E, _, V, P, G = unpack(ElvUI)
-- local locale = (E.global.general.locale and E.global.general.locale ~= "auto") and E.global.general.locale or GetLocale()

-- local L = E.Libs.ACL:GetLocale('ElvUI', locale)
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale)
local EP = LibStub('LibElvUIPlugin-1.0')
local AddOnName, Engine = ...

local _G = _G
local format, tonumber = format, tonumber

--GLOBALS: hooksecurefunc, LibStub, GetAddOnMetadata, CreateFrame, GetAddOnEnableState, BINDING_HEADER_SLE

local SLE = LibStub('AceAddon-3.0'):NewAddon(AddOnName, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')
SLE.callbacks = SLE.callbacks or LibStub('CallbackHandler-1.0'):New(SLE)

SLE.version = GetAddOnMetadata('ElvUI_SLE', 'Version')
SLE.DBversion = '4.24'
SLE.Title = format('|cff9482c9%s |r', 'Shadow & Light')

BINDING_HEADER_SLE = '|cff9482c9Shadow & Light|r'

--Creating a toolkit table
local Toolkit = {}

--localizing functions and stuff--

SLE.elvV = tonumber(E.version)
SLE.elvR = tonumber(GetAddOnMetadata('ElvUI_SLE', 'X-ElvVersion'))

--Setting up table to unpack. Why? no idea
Engine[1] = SLE
Engine[2] = Toolkit
Engine[3] = E
Engine[4] = L
Engine[5] = V
Engine[6] = P
Engine[7] = G
_G[AddOnName] = Engine

SLE.Dropdowns = SLE:NewModule('Dropdowns', 'AceEvent-3.0')
SLE.Media = SLE:NewModule('Media', 'AceHook-3.0')
SLE.Actionbars = SLE:NewModule('Actionbars', 'AceHook-3.0', 'AceEvent-3.0')
SLE.Screensaver = SLE:NewModule('Screensaver', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
SLE.Armory_Character = SLE:NewModule('Armory_Character', 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0')
SLE.Armory_Inspect = SLE:NewModule('Armory_Inspect', 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0')
SLE.Armory_Stats = SLE:NewModule('Armory_Stats')
SLE.Armory_Core = SLE:NewModule('Armory_Core', 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0')
SLE.Backgrounds = SLE:NewModule('Backgrounds', 'AceHook-3.0')
SLE.BagInfo = SLE:NewModule('BagInfo', 'AceHook-3.0', 'AceEvent-3.0')
SLE.Bags = SLE:NewModule('Bags', 'AceHook-3.0')
SLE.Blizzard = SLE:NewModule('Blizzard', 'AceHook-3.0', 'AceEvent-3.0')
SLE.Chat = SLE:NewModule('Chat',  'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
SLE.DataBars = SLE:NewModule('DataBars', 'AceHook-3.0', 'AceEvent-3.0')
SLE.Datatexts = SLE:NewModule('Datatexts', 'AceHook-3.0', 'AceEvent-3.0')
SLE.EnhancedShadows = SLE:NewModule('EnhancedShadows', 'AceEvent-3.0')
SLE.EquipManager = SLE:NewModule('EquipManager', 'AceHook-3.0', 'AceEvent-3.0')
SLE.Garrison = SLE:NewModule('Garrison', 'AceEvent-3.0')
SLE.OrderHall = SLE:NewModule('OrderHall', 'AceEvent-3.0')
SLE.LFR = SLE:NewModule('LFR')
SLE.Loot = SLE:NewModule('Loot','AceHook-3.0', 'AceEvent-3.0')
SLE.InstDif = SLE:NewModule('InstDif','AceHook-3.0', 'AceEvent-3.0')
SLE.LocationPanel = SLE:NewModule('LocationPanel', 'AceTimer-3.0', 'AceEvent-3.0')
SLE.Minimap = SLE:NewModule('Minimap', 'AceHook-3.0', 'AceEvent-3.0')
SLE.RectangleMinimap = SLE:NewModule('RectangleMinimap', 'AceHook-3.0', 'AceEvent-3.0')
SLE.Misc = SLE:NewModule('Misc', 'AceHook-3.0', 'AceEvent-3.0')
SLE.Nameplates = SLE:NewModule('Nameplates', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
SLE.Professions = SLE:NewModule('Professions', 'AceHook-3.0', 'AceEvent-3.0')
SLE.PVP = SLE:NewModule('PVP','AceHook-3.0', 'AceEvent-3.0')
SLE.Quests = SLE:NewModule('Quests', 'AceEvent-3.0')
SLE.BlizzRaid = SLE:NewModule('BlizzRaid', 'AceEvent-3.0')
SLE.Toolbars = SLE:NewModule('Toolbars', 'AceHook-3.0', 'AceEvent-3.0')
SLE.RaidProgress = SLE:NewModule('RaidProgress', 'AceHook-3.0', 'AceEvent-3.0')
SLE.UIButtons = SLE:NewModule('UIButtons', 'AceHook-3.0')
SLE.UnitFrames = SLE:NewModule('UnitFrames', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
SLE.EnhancedVehicleBar = SLE:NewModule('EnhancedVehicleBar')
SLE.WarCampaign = SLE:NewModule('WarCampaign','AceHook-3.0', 'AceEvent-3.0')
SLE.ElvConfig = SLE:NewModule('ElvConfig', 'AceEvent-3.0')
SLE.RaidMarkers = SLE:NewModule('RaidMarkers', 'AceHook-3.0')
SLE.Skins = SLE:NewModule('Skins')

--A function to concentrate options from different modules to a single table used in plugin reg
local function GetOptions()
	for _, func in pairs(SLE.Configs) do
		func()
	end
end

function SLE:OnInitialize()
	--Incompatibility stuff will go here
	SLE:AddTutorials()
end

function SLE:ConfigCats() --Additional mover groups
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, 'S&L')
	E.ConfigModeLocalizedStrings['S&L'] = L["S&L: All"]
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, 'S&L BG')
	E.ConfigModeLocalizedStrings['S&L BG'] = L["S&L: Backgrounds"]
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, 'S&L MISC')
	E.ConfigModeLocalizedStrings['S&L MISC'] = L["S&L: Misc"]
end

--ElvUI's version check
if SLE.elvV < 11 or (SLE.elvV < SLE.elvR) then
	E:Delay(2, function() E:StaticPopup_Show('VERSION_MISMATCH') end) --Delay cause if I try to show it right away, then it wouldn't really show up
	return --Not loading shit if version is too old, prevents shit from being broken
end

function SLE:UpdateMedia()
	--Might be a better way, working though
	local shadowColor = E.db.sle.shadows.shadowcolor
	if E:CheckClassColor(shadowColor.r, shadowColor.g, shadowColor.b) then
		shadowColor = E:ClassColor(E.myclass, true)
		E.db.sle.shadows.shadowcolor.r = shadowColor.r
		E.db.sle.shadows.shadowcolor.g = shadowColor.g
		E.db.sle.shadows.shadowcolor.b = shadowColor.b
	end

	local iconColor = E.db.sle.bags.equipmentmanager.color
	if E:CheckClassColor(iconColor.r, iconColor.g, iconColor.b) then
		iconColor = E:ClassColor(E.myclass, true)
		E.db.sle.bags.equipmentmanager.color.r = iconColor.r
		E.db.sle.bags.equipmentmanager.color.g = iconColor.g
		E.db.sle.bags.equipmentmanager.color.b = iconColor.b
	end
end

function SLE:Initialize()
	if SLE:CheckIncompatible() then return end
	SLE:DatabaseConversions()
	SLE:ConfigCats()
	SLE.initialized = true
	SLE:InitializeModules()

	hooksecurefunc(E, 'UpdateAll', SLE.UpdateAll)
	hooksecurefunc(E, 'UpdateMedia', SLE.UpdateMedia)
	--Here goes installation script

	--Annoying message
	if E.db.general.loginmessage then
		SLE:Print(format(L["SLE_LOGIN_MSG"], E['media'].hexvaluecolor, SLE.version), 'info')
	end

	hooksecurefunc(E, 'PLAYER_ENTERING_WORLD', function(self, _, initLogin)
		if initLogin or not ElvDB.SLErrorDisabledAddOns then
			ElvDB.SLErrorDisabledAddOns = {}
		end
	end)

	SLE:BuildGameMenu()
	SLE:CyrillicsInit()
	SLE:LoadCommands()

	if E.private.sle.install_complete == 'BETA' then E.private.sle.install_complete = nil end
	if not E.private.sle.install_complete or (tonumber(E.private.sle.install_complete) < 3) then
		E.PluginInstaller:Queue(SLE.installTable)
	end
	if not E.private.sle.characterGoldsSorting[E.myrealm] then E.private.sle.characterGoldsSorting[E.myrealm] = {} end

	EP:RegisterPlugin(AddOnName, GetOptions) --Registering as plugin
end

E.Libs.EP:HookInitialize(SLE, SLE.Initialize)
