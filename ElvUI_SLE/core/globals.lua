local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE')

--Chat icon paths
local adapt = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\adapt:0:2|t"
local repooc = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_Logo:0:2|t "
local darth = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\SLE_Chat_LogoD:0:2|t "
--"|TInterface\\Icons\\inv_helmet_131:12:12:0:0:64:64:4:60:4:60|t"
local friend = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_Friend:16:16|t "
-- local test = "|TInterface\\Icons\\Achievement_PVP_H_03:16:16|t "
local test = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_Test:16:16|t "
local rpg = "|TInterface\\AddOns\\ElvUI_SLE\\media\\textures\\Chat_RPG:13:35|t"
local kitalie = "|TInterface\\Icons\\%s:12:12:0:0:64:64:4:60:4:60|t"
local orc = "|TInterface\\Icons\\Achievement_Character_Orc_Male:16:16|t"
local goldicon = "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12|t"

E.SLEConfigs = {}

SLE.version = GetAddOnMetadata("ElvUI_SLE", "Version")

SLE.SpecialChatIcons = {
	["EU"] = {
		['Sylvanas'] = {
			["Neeka"] = darth,
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
			["Шензори"] = friend,
			--Some people
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
			["Mobius"] = adapt,
			["Urgfelstorm"] = adapt,
			["Kilashandra"] = adapt,
			["Lavathing"] = adapt,
			["Finkle"] = adapt,
			["Chopsti"] = adapt,
			["Loosh"] = goldicon
		},
		["Illidan"] = {
			--Darth's toon
			["Darthpred"] = darth,
			--Repooc's Toon
			["Repooc"] = repooc,
			["Repooc"] = repooc
		},
		["WyrmrestAccord"] = {
			["Kalinix"] = kitalie:format("inv_cloth_challengewarlock_d_01helm"),
			["Sagome"] = kitalie:format("inv_helm_leather_challengemonk_d_01"),
			["Sortokk"] = kitalie:format("inv_helm_plate_challengedeathknight_d_01"),
			["Norinael"] = kitalie:format("inv_helmet_plate_challengepaladin_d_01"),
			["Shalerie"] = kitalie:format("inv_helm_cloth_challengemage_d_01"),
			["Myun"] = kitalie:format("inv_helmet_mail_challengeshaman_d_01"),
			["Nevaleigh"] = kitalie:format("inv_helmet_leather_challengerogue_d_01"),
			["Celenii"] = kitalie:format("inv_helmet_cloth_challengepriest_d_01"),
			["Varysa"] = kitalie:format("inv_helmet_mail_challengehunter_d_01"),
			["Caylasena"] = kitalie:format("inv_helm_plate_challengewarrior_d_01"),
			["Arillora"] = kitalie:format("inv_helmet_challengedruid_d_01"),
			["Dapooc"] = repooc,
		},
		["Andorhal"] = {
			["Dapooc"] = repooc,
			["Rovert"] = repooc,
			["Sliceoflife"] = repooc
		},
	},
	["CN"] = {},
	["KR"] = {},
	["TW"] = {},
}