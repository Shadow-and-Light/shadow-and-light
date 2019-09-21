local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo("ElvUI_KnightFrame")) and IsAddOnLoaded("ElvUI_KnightFrame") then return end --Don't break korean code :D
local Armory = SLE:NewModule("Armory_Core", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");

Armory.Info = {}

--Cache--
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

--<<Class-to-Spec and localizing stuffs>>--
local ClassToSpec = {
	["DEATHKNIGHT"] = {
		["Blood"] = 250, ["Frost"] = 251, ["Unholy"] = 252,
	},
	["DEMONHUNTER"] = {
		["Havoc"] = 577, ["Vengeance"] = 581,
	},
	["DRUID"] = {
		["Balance"] = 102, ["Feral"] = 103, ["Guardian"] = 104, ["Restoration"] = 105,
	},
	["HUNTER"] = {
		["Beast"] = 253, ["Marksmanship"] = 254, ["Survival"] = 255,
	},
	["MAGE"] = {
		["Arcane"] = 62, ["Fire"] = 63, ["Frost"] = 64,
	},
	["MONK"] = {
		["Brewmaster"] = 268, ["Mistweaver"] = 270, ["Windwalker"] = 269,
	},
	["PALADIN"] = {
		["Holy"] = 65, ["Protection"] = 66, ["Retribution"] = 70,
	},
	["PRIEST"] = {
		["Discipline"] = 256, ["Holy"] = 257, ["Shadow"] = 258,
	},
	["ROGUE"] = {
		["Assassination"] = 259, ["Combat"] = 260, ["Subtlety"] = 261,
	},
	["SHAMAN"] = {
		["Elemental"] = 262, ["Enhancement"] = 263, ["Restoration"] = 264,
	},
	["WARLOCK"] = {
		["Affliction"] = 265, ["Demonology"] = 266, ["Destruction"] = 267,
	},
	["WARRIOR"] = {
		["Arms"] = 71, ["Fury"] = 72, ["Protection"] = 73,
	},
}
--This basically builds a list of locales for each class and spec name.
--Obviously doesn't support locale selection cause info comes from server and it doesn't give a fuck about elvui settings.
for ClassName, Spec_ID_Table in T.pairs(ClassToSpec) do
	-- L["SLE_Armory_"..ClassName] = KF:Color_Class(ClassName, LOCALIZED_CLASS_NAMES_MALE[ClassName])

	-- for SpecName, ID in T.pairs(Spec_ID_Table) do
		-- _, L["SLE_Armory_"..ClassName.."_"..SpecName] = GetSpecializationInfoByID(ID)
	-- end
end

	--Create ench replacement string DB
	if type(SLE_ArmoryDB) ~= "table" then
		SLE_ArmoryDB = {
			EnchantString = {}
		}
	end

Armory.Info.BackgroundsTextures = {
	Keys = {
		["0"] = "HIDE",
		["1"] = "CUSTOM",
		["2"] = "Space",
		["3"] = "TheEmpire",
		["4"] = "Castle",
		["5"] = "Alliance-text",
		["6"] = "Horde-text",
		["7"] = "Alliance-bliz",
		["8"] = "Horde-bliz",
		["9"] = "Arena-bliz",
		["10"] = "CLASS",
	},
	Config = {
		["0"] = HIDE,
		["1"] = CUSTOM,
		["2"] = "Space",
		["3"] = "The Empire",
		["4"] = "Castle",
		["5"] = FACTION_ALLIANCE,
		["6"] = FACTION_HORDE,
		["7"] = FACTION_ALLIANCE.." 2",
		["8"] = FACTION_HORDE.." 2",
		["9"] = ARENA,
		["10"] = CLASS,
	},
	BlizzardBackdropList = {
		["Alliance-bliz"] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Alliance]],
		["Horde-bliz"] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Horde]],
		["Arena-bliz"] = [[Interface\PVPFrame\PvpBg-NagrandArena-ToastBG]]
	},
}

Armory.Info.GearList = {
	"HeadSlot", "HandsSlot", "NeckSlot", "WaistSlot", "ShoulderSlot", "LegsSlot", "BackSlot", "FeetSlot", "ChestSlot", "Finger0Slot",
	"ShirtSlot", "Finger1Slot", "TabardSlot", "Trinket0Slot", "WristSlot", "Trinket1Slot", "SecondaryHandSlot", "MainHandSlot"
}

Armory.Info.AzeriteTraitAvailableColor = {0.95, 0.95, 0.32, 1}

function Armory:Initialize()
	-- for i = 1, #KF.Modules do
		-- KF.Modules[(KF.Modules[i])]()
	-- end
	SLE:GetModule("Armory_Character"):LoadAndSetup()
	
	function Armory:ForUpdateAll()
		-- _G["CharacterArmory"]:UpdateSettings("all")
		-- if not SLE._Compatibility["DejaCharacterStats"] then
			-- _G["CharacterArmory"]:ToggleStats()
			-- _G["CharacterArmory"]:UpdateIlvlFont()
		-- end
		-- _G["InspectArmory"]:UpdateSettings("all")
	end
end

SLE:RegisterModule(Armory:GetName())