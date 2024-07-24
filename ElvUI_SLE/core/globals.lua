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
		--Darth's toons
		['Player-1925-05F494A6'] = darth, --Дартпредатор
		['Player-1925-05F495A1'] = darth, --Алея
		['Player-1925-068597D7'] = darth, --Келинира
		['Player-1925-0F7CD263'] = darth, --Ночаки
		['Player-1925-0F8A606A'] = darth, --Найлиа
		['Player-1925-0F8AC636'] = darth, --Згук
		['Player-1925-0F909792'] = darth, --Твеша
		['Player-1925-0F8ACC5D'] = darth, --Тамзун
		['Player-1925-0F8ACD8A'] = darth, --Дурвальд
		['Player-1925-0F8ACD72'] = darth, --Юнва
		['Player-1925-0F88F94F'] = darth, --Акуштабал
		['Player-1925-0F8A98CD'] = darth, --Кхиму
		['Player-1925-0F7CD0B8'] = darth, --Эрелэйн
		['Player-1925-05E1AB61'] = darth, --Мейжи
		['Player-1925-0F7CD09C'] = darth, --Айтарин
		['Player-1925-0F7CE7C1'] = darth, --Алайа
		['Player-1925-0AD94DDC'] = darth, --Козгроб
		['Player-1925-0F45592E'] = darth, --Тутумба
		['Player-1925-0A737D2F'] = darth, --Авелена
		['Player-1925-0F5E51F8'] = darth, --Акаара
		['Player-1925-0A737D64'] = darth, --Болан
		['Player-1925-05F4B46B'] = darth, --Ваззули
		['Player-1925-06F2597E'] = darth, --Джатон
		['Player-1925-05F494E5'] = darth, --Киландра
		['Player-1925-06859B82'] = darth, --Крениг
		['Player-1925-0A736FAF'] = darth, --Мемри
		['Player-1925-0A737D9C'] = darth, --Миора
		['Player-1925-06F2599E'] = darth, --Нарджо
		['Player-1925-0F7CCF6D'] = darth, --Нонлари
		['Player-1925-06A12E75'] = darth, --Сиаранна
		['Player-1925-0986E52C'] = darth, --Тисандри
		['Player-1925-06017C92'] = darth, --Фикстер
		['Player-1925-0F5E51F7'] = darth, --Шалиин
		['Player-1925-0F5E471A'] = darth, --Яндриа
		['Player-1925-0F87FDD4'] = darth, --Зуксу
		['Player-1925-0F9120ED'] = darth, --Тухэви
		['Player-1925-0F912B6D'] = darth, --Занталис
		['Player-1925-0F916E94'] = darth, --Мирридель
		['Player-1925-0F916F98'] = darth, --Олиталис
		['Player-1925-0F9171D2'] = darth, --Феали
		['Player-1925-0F917643'] = darth, --Танзия
		
		-- ['Фикстер-ВечнаяПесня'] = darth,
		['Player-1925-06C8A78E'] = friend, --Кайрия-ВечнаяПесня
		['Дендрин-ВечнаяПесня'] = friend,
		['Аргрут-ВечнаяПесня'] = friend,
		['Шензо-Ревущийфьорд'] = classTable.hunter,
		['Маразм-Ревущийфьорд'] = classTable.shaman,
		['Емалия-ЧерныйШрам'] = friend,
		['Roxanne-Blackrock'] = blizzicon:format('ability_mage_glacialspike'), -- Annoying Feature requester
	},
	['US'] = {
		['Dapooc-Andorhal'] = repooc,
		['Rovert-Andorhal'] = repooc,
		['Sliceoflife-Andorhal'] = repooc,
		['Darthpred-Illidan'] = darth,--Darth's toon
		['Repooc-Illidan'] = repooc,
		['Desertdragon-Illidan'] = gold,
		['Lapooc-Spirestone'] = test,
		['Warpooc-Spirestone'] = repooc,
		['Cursewordz-Spirestone'] = repooc,
		['Urgfelstorm-Stormrage'] = blizzicon:format('inv_misc_bomb_02'),	-- Urg & Repooc's Guild Mate
		['Vaxum-Stormrage']	= goldicon,	-- Vax & Repooc's Guild Mate
		['Lloosh-Stormrage'] = goldicon,	-- Lloosh & Repooc's Guild Mate
		['Marshmeela-Stormrage'] = goldicon,	-- Lloosh & Repooc's Guild Mate
		['Looshana-Stormrage'] = goldicon,	-- Lloosh & Repooc's Guild Mate
		['Looshaina-Stormrage']	= goldicon, -- Lloosh & Repooc's Guild Mate
		['Looshally-Stormrage']	= goldicon, -- Lloosh & Repooc's Guild Mate
		['Looshella-Stormrage']	= goldicon, -- Lloosh & Repooc's Guild Mate
		["Daveedium-Kel'Thuzad"] = ttvicon, -- Twitch streamer I been doing HSire kills with
		['Dapooc-WyrmrestAccord'] = repooc,
		['Evolutious-BleedingHollow'] = sllogo, --Patreon (Evolutious in discord)
		['Poocer-BleedingHollow'] = sllogo, --random toon of repooc
	},
}
