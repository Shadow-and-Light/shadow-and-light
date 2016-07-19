local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local format = format

--Chat icon paths--
local slePath = [[|TInterface\AddOns\ElvUI_SLE\media\textures\]]
local blizzPath = [[|TInterface\ICONS\]]
local repooc = slePath..[[SLE_Chat_Logo:0:2|t ]]
local darth = slePath..[[SLE_Chat_LogoD:0:2|t ]]
local friend = slePath..[[Chat_Friend:16:16|t ]]
local test = slePath..[[Chat_Test:16:16|t ]]
-- local rpg = slePath..[[Chat_RPG:13:35|t]]

local orc = blizzPath..[[Achievement_Character_Orc_Male:16:16|t ]]
local goldicon = blizzPath..[[rame\UI-GoldIcon:12:12|t]]
local classTable = {
	deathknight = blizzPath..[[ClassIcon_DeathKnight:16:16|t ]],
	-- demonhunter = blizzPath..[[ClassIcon_DemonHunter:16:16|t ]],
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
	["ElvUI"] = {
		TANK = [[Interface\AddOns\ElvUI\media\textures\tank]],
		HEALER = [[Interface\AddOns\ElvUI\media\textures\healer]],
		DAMAGER = [[Interface\AddOns\ElvUI\media\textures\dps]]
	},
	["SupervillainUI"] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-dps]]
	},
	["Blizzard"] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-dps]]
	},
	["MiirGui"] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-dps]]
	},
}

--Epty Tables
SLE.Configs = {}

--Variables
SLE.region = false

--Toonlists
SLE.SpecialChatIcons = {
	["EU"] = {
		["Sylvanas"] = {
			["Neeka"] = darth,
		},
		["DarkmoonFaire"] = {
			["Shaylith"] = darth,
			["Yandria"] = darth,
			["Ardon"] = darth,
		},
		["TheSha'tar"] = {
			["Lelora"] = darth,
			["Alamira"] = darth,
		},
		["СвежевательДуш"] = {
			--Darth's toons
			["Большойгном"] = test, --Testing toon
			["Фергесон"] = friend
		},
		["ВечнаяПесня"] = {
			--Darth's toons
			["Дартпредатор"] = darth,
			["Алея"] = darth,
			["Ваззули"] = darth,
			["Сиаранна"] = darth,
			["Джатон"] = darth,
			["Фикстер"] = darth,
			["Киландра"] = darth,
			["Нарджо"] = darth,
			["Келинира"] = darth,
			["Крениг"] = darth,
			["Мейжи"] = darth,
			--Darth's friends
			["Леани"] = friend,
			["Кайрия"] = friend,
			["Дендрин"] = frined,
			["Аргрут"] = friend,
			--Da tester lol
			["Харореанн"] = test,
			["Нерререанн"] = test,
			["Аргусил"] = orc
		},
		["Ревущийфьорд"] = {
			["Рыжая"] = friend,
			["Рыжа"] = friend,
			["Шензори"] = classTable.hunter,
			--Some people
			["Маразм"] = classTable.shaman,
			["Брэгар"] = test
		},
		["Пиратскаябухта"] = {
			["Брэгари"] = test
		},
		["ЧерныйШрам"] = {
			["Емалия"] = friend,
		},
	},
	["US"] = {
		["Spirestone"] = {
			["Sifupooc"] = repooc,
			["Dapooc"] = repooc,
			["Lapooc"] = repooc,
			["Warpooc"] = repooc,
			["Repooc"] = repooc,
			["Cursewordz"] = repooc,
			--Adapt Roster
			["Loosh"] = goldicon,
			["Alooshy"] = goldicon,
			["Aloosh"] = goldicon
		},
		["Illidan"] = {
			--Darth's toon
			["Darthpred"] = darth,
			--Repooc's Toon
			["Repooc"] = repooc,
			["Repooc"] = repooc
		},
		["WyrmrestAccord"] = {
			["Dapooc"] = repooc,
		},
		["Andorhal"] = {
			["Dapooc"] = repooc,
			["Rovert"] = repooc,
			["Sliceoflife"] = repooc
		},
		--Teh PTR
		["Brill(EU)"] = {
			["Дартпредатор"] = darth,
			["Киландра"] = darth,
		},
	},
	["CN"] = {},
	["KR"] = {},
	["TW"] = {},
}