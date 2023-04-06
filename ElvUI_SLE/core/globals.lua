local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

--Chat icon paths--
local slePath = [[|TInterface\AddOns\ElvUI_SLE\media\textures\chat\]]
local blizzPath = [[|TInterface\ICONS\]]
local repooc = slePath..[[SLE_Chat_Logo:12:24|t ]]
local sllogo = slePath..[[Logo:14:14|t ]]
local darth = slePath..[[SLE_Chat_Logo:12:24|t ]]
local friend = slePath..[[Chat_Friend:16:16|t ]]
local test = slePath..[[Chat_Test:16:16|t ]]
local blizzicon = blizzPath..[[%s:12:12:0:0:64:64:4:60:4:60|t]]
-- local rpg = slePath..[[Chat_RPG:13:35|t]]

-- TTV Chat Icon
local ttvicon = slePath..[[Daveedium:11:21|t ]]

local orc = blizzPath..[[Achievement_Character_Orc_Male:16:16|t ]]
--local coppericon = [[|TInterface\MONEYFRAME\UI-CopperIcon:12:12|t]]
--local silvericon = [[|TInterface\MONEYFRAME\UI-SilverIcon:12:12|t]]
local goldicon = [[|TInterface\MONEYFRAME\UI-GoldIcon:12:12|t]]

SLE.ArmoryConfigBackgroundValues = {
	BackgroundValues = {
		['HIDE'] = HIDE,
		['CUSTOM'] = CUSTOM,
		['Space'] = 'Space',
		['TheEmpire'] = 'The Empire',
		['Castle'] = 'Castle',
		['Alliance-text'] = FACTION_ALLIANCE,
		['Horde-text'] = FACTION_HORDE,
		['Arena-bliz'] = ARENA,
		['CLASS'] = CLASS,
		['Covenant'] = L["Covenant"],
		['Covenant2'] = L["Covenant"]..' 2',
	},
	BlizzardBackdropList = {
		['Arena-bliz'] = [[Interface\PVPFrame\PvpBg-NagrandArena-ToastBG]]
	},
	Covenants = {
		[0] = 'None',
		[1] = 'Kyrian',
		[2] = 'Venthyr',
		[3] = 'NightFae',
		[4] = 'Necrolord',
	},
}

local classTable = {
	deathknight = blizzPath..[[ClassIcon_DeathKnight:16:16|t ]],
	demonhunter = blizzPath..[[ClassIcon_DemonHunter:16:16|t ]],
	druid = blizzPath..[[ClassIcon_Druid:16:16|t ]],
	hunter = blizzPath..[[ClassIcon_Hunter:16:16|t ]],
	mage = blizzPath..[[ClassIcon_Mage:16:16|t ]],
	monk = blizzPath..[[ClassIcon_Monk:16:16|t ]],
	paladin = blizzPath..[[ClassIcon_Paladin:16:16|t ]],
	priest = blizzPath..[[ClassIcon_Priest:16:16|t ]],
	rogue = blizzPath..[[ClassIcon_Rogue:16:16|t ]],
	shaman = blizzPath..[[ClassIcon_Shaman:16:16|t ]],
	warlock = blizzPath..[[ClassIcon_Warlock:16:16|t ]],
	warrior = blizzPath..[[ClassIcon_Warrior:16:16|t ]],
}

--Role icons
SLE.rolePaths = {
	['ElvUI'] = {
		TANK = [[Interface\AddOns\ElvUI\Core\Media\Textures\Tank]],
		HEALER = [[Interface\AddOns\ElvUI\Core\Media\Textures\Healer]],
		DAMAGER = [[Interface\AddOns\ElvUI\Core\Media\Textures\DPS]]
	},
	['SupervillainUI'] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-dps]]
	},
	['Blizzard'] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-dps]]
	},
	['BlizzardCircle'] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-tank-circle]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-healer-circle]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-dps-circle]]
	},
	['MiirGui'] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-dps]]
	},
	['Lyn'] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-dps]]
	},
	['Philmod'] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\philmod-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\philmod-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\philmod-dps]]
	},
	['ReleafUI'] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\releaf-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\releaf-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\releaf-dps]]
	},
	['LynOutline'] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-outline-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-outline-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-outline-dps]]
	},
}

SLE.ScenarioBlockLogos = {
	['NONE'] = '',
	['SLE'] = [[Interface\AddOns\ElvUI_SLE\media\textures\chat\Logo]],
}

--Epty Tables
SLE.Configs = {}

--Variables
SLE.region = false

--Toonlists
SLE.SpecialChatIcons = {
	['EU'] = {
		['DarkmoonFaire'] = {
			['Shaylith'] = darth,
			['Yandria'] = darth,
			['Ardon'] = darth,
			['Lelora'] = darth,
			['Illia'] = darth,
			['Jumahko'] = darth,
			['Jilti'] = darth,
			['Hweiru'] = darth,
			['Maggas'] = darth,
			['Faanna'] = darth,
			['Naliss'] = darth,
			['Ahkara'] = darth,
		},
		["TheSha'tar"] = {
			['Lelora'] = darth,
			['Alamira'] = darth,
		},
		['ВечнаяПесня'] = {
			--Darth's toons
			['Дартпредатор'] = darth,
			['Алея'] = darth,
			['Ваззули'] = darth,
			['Сиаранна'] = darth,
			['Джатон'] = darth,
			['Фикстер'] = darth,
			['Киландра'] = darth,
			['Нарджо'] = darth,
			['Келинира'] = darth,
			['Крениг'] = darth,
			['Мейжи'] = darth,
			['Тисандри'] = darth,
			['Мемри'] = darth,
			--Darth's friends
			['Леани'] = friend,
			['Кайрия'] = friend,
			['Дендрин'] = friend,
			['Аргрут'] = friend,
			--Da tester lol
			['Харореанн'] = test,
			['Нерререанн'] = test,
			['Аргусил'] = orc
		},
		['Пиратскаябухта'] = {
			['Брэгари'] = test
		},
		['Ревущийфьорд'] = {
			['Рыжая'] = friend,
			['Рыжа'] = friend,
			['Шензо'] = classTable.hunter,
			--Some people
			['Маразм'] = classTable.shaman,
			['Брэгар'] = test
		},
		['ЧерныйШрам'] = {
			['Емалия'] = friend,
		},
        ['Blackrock'] = {
			['Roxanne'] = blizzicon:format('ability_mage_glacialspike'), -- Annoying Feature requester
		},
	},
	['US'] = {
		['Andorhal'] = {
			['Dapooc'] = repooc,
			['Rovert'] = repooc,
			['Sliceoflife'] = repooc,
		},
		['Illidan'] = {
			--Darth's toon
			['Darthpred'] = darth,
			--Repooc's Toon
			['Repooc'] = repooc,
			['Desertdragon'] = gold,
		},
		['Spirestone'] = {
			['Lapooc'] = test,
			['Warpooc'] = repooc,
			['Cursewordz'] = repooc,
		},
		['Stormrage'] = {
			['Urgfelstorm'] = blizzicon:format('inv_misc_bomb_02'),	-- Urg & Repooc's Guild Mate
			['Vaxum']		= goldicon,	-- Vax & Repooc's Guild Mate
			['Lloosh']		= goldicon,	-- Lloosh & Repooc's Guild Mate
			['Marshmeela']	= goldicon,	-- Lloosh & Repooc's Guild Mate
			['Looshana']	= goldicon,	-- Lloosh & Repooc's Guild Mate
			['Looshaina']	= goldicon, -- Lloosh & Repooc's Guild Mate
			['Looshally']	= goldicon, -- Lloosh & Repooc's Guild Mate
			['Looshella']	= goldicon, -- Lloosh & Repooc's Guild Mate
		},
		["Kel'Thuzad"] = {
			['Daveedium'] = ttvicon, -- Twitch streamer I been doing HSire kills with
		},
		['WyrmrestAccord'] = {
			['Dapooc'] = repooc,
		},
		['BleedingHollow'] = {
			['Evolutious'] = sllogo, --Patreon (Evolutious in discord)
			['Poocer'] = sllogo, --random toon of repooc
		},
	},
	['CN'] = {},
	['KR'] = {},
	['TW'] = {},
	['PTR'] = {
		['Brill(EU)'] = {
			['Дартпредатор'] = darth,
			['Киландра'] = darth,
		},
	},
}
