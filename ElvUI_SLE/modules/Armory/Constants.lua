if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)

Info.Armory_Constants = {
	ItemLevelKey = ITEM_LEVEL:gsub('%%d', '(.+)'),
	ItemLevelKey_Alt = ITEM_LEVEL_ALT:gsub('%%d', '.+'):gsub('%(.+%)', '%%((.+)%%)'),
	EnchantKey = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)'),
	ItemSetBonusKey = ITEM_SET_BONUS:gsub('%%s', '(.+)'),
	--TransmogrifiedKey = TRANSMOGRIFIED:gsub('%%s', '(.+)'),
	
	GearList = {
		'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
		'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
	},
	
	EnchantableSlots = {
		NeckSlot = true, BackSlot = true, Finger0Slot = true, Finger1Slot = true
	},
	
	UpgradeColor = {
		[16] = '|cffff9614',
		[12] = '|cfff88ef4',
		[8] = '|cff2eb7e4',
		[4] = '|cffceff00'
	},
	
	GemColor = {
		RED = { 1, .2, .2, },
		YELLOW = { .97, .82, .29, },
		BLUE = { .47, .67, 1, }
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
	
	ProfessionList = {},
	
	BlizzardBackdropList = {
		["Alliance-bliz"] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Alliance]],
		["Horde-bliz"] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Horde]],
		["Arena-bliz"] = [[Interface\PVPFrame\PvpBg-NagrandArena-ToastBG]]
	}
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