local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo("ElvUI_KnightFrame")) and IsAddOnLoaded("ElvUI_KnightFrame") then return end --Don't break korean code :D
local Armory = SLE:NewModule("Armory_Core", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");

Armory.Constants = {}

--Cache--
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

--<<Class-to-Spec and localizing stuffs>>--
--[[local ClassToSpec = {
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
end]]

	--Create ench replacement string DB
	if type(SLE_ArmoryDB) ~= "table" then
		SLE_ArmoryDB = {
			EnchantString = {}
		}
	end

Armory.Constants.GearList = {
	"HeadSlot", "HandsSlot", "NeckSlot", "WaistSlot", "ShoulderSlot", "LegsSlot", "BackSlot", "FeetSlot", "ChestSlot", "Finger0Slot",
	"ShirtSlot", "Finger1Slot", "TabardSlot", "Trinket0Slot", "WristSlot", "Trinket1Slot", "SecondaryHandSlot", "MainHandSlot"
}
Armory.Constants.ReverseGemPosition = {
	["SecondaryHandSlot"] = "RIGHT",
	["MainHandSlot"] = "LEFT",
}

Armory.Constants.AzeriteTraitAvailableColor = {0.95, 0.95, 0.32, 1}

function Armory:BuildCharacterDefaultsCache()
	Armory.Constants.CA_Defaults = {}
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		Armory.Constants.CA_Defaults[SlotName] = {}
		local Slot = _G["Character"..SlotName]
		Slot.Direction = i%2 == 1 and "LEFT" or "RIGHT"
		if Armory.Constants.ReverseGemPosition[SlotName] then Slot.Direction = Armory.Constants.ReverseGemPosition[SlotName] end
		if Slot.iLvlText then
			Armory.Constants.CA_Defaults[SlotName]["iLvlText"] = { Slot.iLvlText:GetPoint() } 
			Armory.Constants.CA_Defaults[SlotName]["textureSlot1"] = { Slot.textureSlot1:GetPoint() }
			for i = 2, 10 do
				if Slot["textureSlot"..i] then Slot["textureSlot"..i]:ClearAllPoints(); Slot["textureSlot"..i]:Point(Slot.Direction, Slot["textureSlot"..(i-1)], Slot.Direction == "LEFT" and "RIGHT" or "LEFT", 0,0) end
			end
			Armory.Constants.CA_Defaults[SlotName]["enchantText"] = { Slot.enchantText:GetPoint() }
		end
		if SlotName == "NeckSlot" then
			Armory.Constants.CA_Defaults[SlotName]["RankFrame"] = { Slot.RankFrame:GetPoint() }
		end
	end
end

function Armory:Initialize()
	-- for i = 1, #KF.Modules do
		-- KF.Modules[(KF.Modules[i])]()
	-- end
	Armory:BuildCharacterDefaultsCache()
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