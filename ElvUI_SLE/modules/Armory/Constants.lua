if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local gsub = gsub

--WoW API . Variables
local GetSpellInfo = GetSpellInfo
local ITEM_LEVEL = ITEM_LEVEL
local ITEM_LEVEL_ALT = ITEM_LEVEL_ALT
local ENCHANTED_TOOLTIP_LINE = ENCHANTED_TOOLTIP_LINE
local ITEM_SET_BONUS = ITEM_SET_BONUS
local ITEM_UPGRADE_TOOLTIP_FORMAT = ITEM_UPGRADE_TOOLTIP_FORMAT
local HONOR_LEVEL_LABEL = HONOR_LEVEL_LABEL
local EMPTY_SOCKET_BLUE = EMPTY_SOCKET_BLUE
local EMPTY_SOCKET_COGWHEEL = EMPTY_SOCKET_COGWHEEL
local EMPTY_SOCKET_HYDRAULIC = EMPTY_SOCKET_HYDRAULIC
local EMPTY_SOCKET_META = EMPTY_SOCKET_META
local EMPTY_SOCKET_NO_COLOR = EMPTY_SOCKET_NO_COLOR
local EMPTY_SOCKET_PRISMATIC = EMPTY_SOCKET_PRISMATIC
local EMPTY_SOCKET_RED = EMPTY_SOCKET_RED
local EMPTY_SOCKET_YELLOW = EMPTY_SOCKET_YELLOW
local ITEM_BIND_ON_EQUIP = ITEM_BIND_ON_EQUIP
local ITEM_BIND_ON_PICKUP = ITEM_BIND_ON_PICKUP
local ITEM_BIND_TO_ACCOUNT = ITEM_BIND_TO_ACCOUNT
local ITEM_BIND_TO_BNETACCOUNT = ITEM_BIND_TO_BNETACCOUNT

Info.BackgroundsTextures = {
	Keys = {
		["0"] = 'HIDE',
		["1"] = 'CUSTOM',
		["2"] = 'Space',
		["3"] = 'TheEmpire',
		["4"] = 'Castle',
		["5"] = 'Alliance-text',
		["6"] = 'Horde-text',
		["7"] = 'Alliance-bliz',
		["8"] = 'Horde-bliz',
		["9"] = 'Arena-bliz',
		["10"] = 'CLASS',
	},
	Config = {
		["0"] = HIDE,
		["1"] = CUSTOM,
		["2"] = "Space",
		["3"] = "The Empire",
		["4"] = "Castle",
		["5"] = FACTION_ALLIANCE,
		["6"] = FACTION_HORDE,
		["7"] = FACTION_ALLIANCE..' 2',
		["8"] = FACTION_HORDE..' 2',
		["9"] = ARENA,
		["10"] = CLASS,
	},
}

Info.Armory_Constants = {
	ItemLevelKey = ITEM_LEVEL:gsub('%%d', '(.+)'),
	ItemLevelKey_Alt = ITEM_LEVEL_ALT:gsub('%%d', '.+'):gsub('%(.+%)', '%%((.+)%%)'),
	EnchantKey = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)'),
	ItemSetBonusKey = ITEM_SET_BONUS:gsub('%%s', '(.+)'),
	ItemUpgradeKey = ITEM_UPGRADE_TOOLTIP_FORMAT:gsub('%%d', '(.+)'),
	HonorLevel = HONOR_LEVEL_LABEL:gsub('%%d', '%%s'),
	HonorKills = INSPECT_HONORABLE_KILLS:gsub('%%d', '%%s'):gsub("|cffffd200", ""),
	--TransmogrifiedKey = TRANSMOGRIFIED:gsub('%%s', '(.+)'),
	
	GearList = {
		'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
		'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
	},

	EnchantableSlots = {
		Finger0Slot = true, Finger1Slot = true, MainHandSlot = true, SecondaryHandSlot = true,
	},

	--Most Likely removing this block of code, will remove when effected functions are updated
	WeaponTypes = {
		["INVTYPE_WEAPON"] = true,
		["INVTYPE_2HWEAPON"] = true,
		["INVTYPE_WEAPONMAINHAND"] = true,
		["INVTYPE_WEAPONOFFHAND"] = true,
		["INVTYPE_RANGEDRIGHT"] = true,
		["INVTYPE_RANGED"] = true,
		["INVTYPE_THROWN"] = true,
	},
	
	UpgradeColor = {
		[16] = '|cffff9614',
		[12] = '|cfff88ef4',
		[10] = '|cffff9614',
		[8] = '|cff2eb7e4',
		[5] = '|cfff88ef4',
		[4] = '|cffceff00'
	},
	
	GemColor = {
		RED =	{   1,	.2,  .2 },
		YELLOW = { .97, .82, .29 },
		BLUE =	 { .47, .67,   1 },
		ARCANE = { .85, .75, .93 },
		BLOOD =  {   1,   0,   0 },
		FEL =    {   0,   1, .16 },
		FIRE =   {   1, .24,   0 },
		FROST =  { .35, .75,   1 },
		HOLY =   {   1, .91, .58 },
		IRON =   { .76, .76, .76 },
		LIFE =   { .07, .74,   0 },
		SHADOW = {  .7, .48, .88 },
		WIND =  { .67, .84,   1 }
	},
	
	EmptySocketString = {
		[EMPTY_SOCKET_BLUE] = true,
		[EMPTY_SOCKET_COGWHEEL] = true,
		[EMPTY_SOCKET_HYDRAULIC] = true,
		[EMPTY_SOCKET_META] = true,
		[EMPTY_SOCKET_NO_COLOR] = true,
		[EMPTY_SOCKET_PRISMATIC] = true,
		[EMPTY_SOCKET_RED] = true,
		[EMPTY_SOCKET_YELLOW] = true
	},
	
	ItemBindString = { -- Usually transmogrify string is located upper than bind string so we need to check this string for adding a transmogrify string in tooltip.
		[ITEM_BIND_ON_EQUIP] = true,
		[ITEM_BIND_ON_PICKUP] = true,
		[ITEM_BIND_TO_ACCOUNT] = true,
		[ITEM_BIND_TO_BNETACCOUNT] = true
	},
	
	CanTransmogrifySlot = {
		HeadSlot = true, ShoulderSlot = true, BackSlot = true, ChestSlot = true, WristSlot = true,
		HandsSlot = true, WaistSlot = true, LegsSlot = true, FeetSlot = true, MainHandSlot = true, SecondaryHandSlot = true
	},

	CanIllusionSlot = {
		MainHandSlot = true, SecondaryHandSlot = true
	},

	ProfessionList = {},
	
	PvPTalentRequireLevel = { 1, 13, 31, 2, 16, 34, 4, 19, 37, 6, 22, 40, 8, 25, 43, 10, 28, 46 },

	BlizzardBackdropList = {
		['Alliance-bliz'] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Alliance]],
		['Horde-bliz'] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Horde]],
		['Arena-bliz'] = [[Interface\PVPFrame\PvpBg-NagrandArena-ToastBG]]
	},

	AzeriteTraitAvailableColor = {0.95, 0.95, 0.32, 1},
}
	
for ProfessionID, ProfessionKey in pairs({
	[105206] = 'Alchemy',
	[110396] = 'BlackSmithing',
	[110400] = 'Enchanting',
	[110403] = 'Engineering',
	[110417] = 'Inscription',
	[110420] = 'JewelCrafting',
	[110423] = 'LeatherWorking',
	[110426] = 'Tailoring',
	
	[110413] = 'Herbalism',
	[102161] = 'Mining',
	[102216] = 'Skinning'
}) do
	local ProfessionName, _, ProfessionTexture = GetSpellInfo(ProfessionID)
	
	Info.Armory_Constants.ProfessionList[ProfessionName] = {
		Key = ProfessionKey,
		Texture = ProfessionTexture
	}
end