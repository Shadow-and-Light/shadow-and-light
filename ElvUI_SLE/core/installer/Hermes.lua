local E, L, V, P, G = unpack(ElvUI);
local AI = E:GetModule('SLE_AddonInstaller')

local ace3   = true               -- whether or not this database is a Ace3 profile
local name   = 'Hermes'           -- the name of the addon
local dbname = 'HermesDB2'        -- name of the addon database

local function OnDemand(profile)  -- function that creates the "load on demand" database
	local database
	if profile == "Affinitii" then
		database = {
			["configMode"] = false,
			["pluginState"] = {
				["UI"] = true,
			},
			["spells"] = {
				{
					["enabled"] = false,
					["name"] = "Ancestral Guidance",
					["id"] = 108281,
					["class"] = "SHAMAN",
					["icon"] = "Interface\\Icons\\ability_shaman_ancestralguidance",
				}, -- [1]
				{
					["enabled"] = false,
					["name"] = "Anti-Magic Shell",
					["id"] = 48707,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_Shadow_AntiMagicShell",
				}, -- [2]
				{
					["enabled"] = false,
					["name"] = "Anti-Magic Zone",
					["id"] = 51052,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_DeathKnight_AntiMagicZone",
				}, -- [3]
				{
					["enabled"] = false,
					["name"] = "Ardent Defender",
					["id"] = 31850,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_ArdentDefender",
				}, -- [4]
				{
					["enabled"] = false,
					["name"] = "Army of the Dead",
					["id"] = 42650,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_DeathKnight_ArmyOfTheDead",
				}, -- [5]
				{
					["enabled"] = false,
					["name"] = "Barkskin",
					["id"] = 22812,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Spell_Nature_StoneClawTotem",
				}, -- [6]
				{
					["enabled"] = false,
					["name"] = "Blind",
					["id"] = 2094,
					["class"] = "ROGUE",
					["icon"] = "Interface\\Icons\\Spell_Shadow_MindSteal",
				}, -- [7]
				{
					["enabled"] = false,
					["name"] = "Bloodlust",
					["id"] = 2825,
					["class"] = "SHAMAN",
					["icon"] = "Interface\\Icons\\Spell_Nature_BloodLust",
				}, -- [8]
				{
					["enabled"] = false,
					["name"] = "Bone Shield",
					["id"] = 49222,
					["class"] = "DEATHKNIGHT",
					["icon"] = "INTERFACE\\ICONS\\ability_deathknight_boneshield",
				}, -- [9]
				{
					["enabled"] = false,
					["name"] = "Cenarion Ward",
					["id"] = 102351,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Ability_Druid_NaturalPerfection",
				}, -- [10]
				{
					["enabled"] = false,
					["name"] = "Cloak of Shadows",
					["id"] = 31224,
					["class"] = "ROGUE",
					["icon"] = "Interface\\Icons\\Spell_Shadow_NetherCloak",
				}, -- [11]
				{
					["enabled"] = false,
					["name"] = "Counterspell",
					["id"] = 2139,
					["class"] = "MAGE",
					["icon"] = "Interface\\Icons\\Spell_Frost_IceShock",
				}, -- [12]
				{
					["enabled"] = false,
					["name"] = "Create Soulwell",
					["id"] = 29893,
					["class"] = "WARLOCK",
					["icon"] = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness",
				}, -- [13]
				{
					["enabled"] = false,
					["name"] = "Dancing Rune Weapon",
					["id"] = 49028,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\INV_Sword_07",
				}, -- [14]
				{
					["enabled"] = false,
					["name"] = "Death Grip",
					["id"] = 49576,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_DeathKnight_Strangulate",
				}, -- [15]
				{
					["enabled"] = false,
					["name"] = "Death Pact",
					["id"] = 48743,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_Shadow_DeathPact",
				}, -- [16]
				{
					["enabled"] = false,
					["name"] = "Demoralizing Banner",
					["id"] = 114203,
					["class"] = "WARRIOR",
					["icon"] = "Interface\\Icons\\demoralizing_banner",
				}, -- [17]
				{
					["enabled"] = true,
					["name"] = "Devotion Aura",
					["id"] = 31821,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_AuraMastery",
				}, -- [18]
				{
					["enabled"] = false,
					["name"] = "Disrupting Shout",
					["id"] = 102060,
					["class"] = "WARRIOR",
					["icon"] = "Interface\\Icons\\warrior_disruptingshout",
				}, -- [19]
				{
					["enabled"] = true,
					["name"] = "Divine Hymn",
					["id"] = 64843,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\Spell_Holy_DivineHymn",
				}, -- [20]
				{
					["enabled"] = false,
					["name"] = "Divine Protection",
					["id"] = 498,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\spell_holy_divineprotection",
				}, -- [21]
				{
					["enabled"] = false,
					["name"] = "Divine Shield",
					["id"] = 642,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\spell_holy_divineshield",
				}, -- [22]
				{
					["enabled"] = false,
					["name"] = "Every Man for Himself",
					["id"] = 59752,
					["class"] = "ANY",
					["icon"] = "Interface\\Icons\\Spell_Shadow_Charm",
				}, -- [23]
				{
					["enabled"] = false,
					["name"] = "Fist of Justice",
					["id"] = 105593,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_FistOfJustice",
				}, -- [24]
				{
					["enabled"] = false,
					["name"] = "Frenzied Regeneration",
					["id"] = 22842,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Ability_BullRush",
				}, -- [25]
				{
					["enabled"] = false,
					["name"] = "Guardian Spirit",
					["id"] = 47788,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
				}, -- [26]
				{
					["enabled"] = false,
					["name"] = "Guardian of Ancient Kings",
					["id"] = 86659,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_Heroism",
				}, -- [27]
				{
					["enabled"] = false,
					["name"] = "Hammer of Justice",
					["id"] = 853,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_SealOfMight",
				}, -- [28]
				{
					["enabled"] = false,
					["name"] = "Hand of Freedom",
					["id"] = 1044,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_SealOfValor",
				}, -- [29]
				{
					["enabled"] = false,
					["name"] = "Hand of Protection",
					["id"] = 1022,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_SealOfProtection",
				}, -- [30]
				{
					["enabled"] = false,
					["name"] = "Hand of Purity",
					["id"] = 114039,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_SealOfWisdom",
				}, -- [31]
				{
					["enabled"] = false,
					["name"] = "Hand of Sacrifice",
					["id"] = 6940,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_SealOfSacrifice",
				}, -- [32]
				{
					["enabled"] = false,
					["name"] = "Hand of Salvation",
					["id"] = 1038,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_SealOfSalvation",
				}, -- [33]
				{
					["enabled"] = false,
					["name"] = "Healing Stream Totem",
					["id"] = 5394,
					["class"] = "SHAMAN",
					["icon"] = "Interface\\Icons\\INV_Spear_04",
				}, -- [34]
				{
					["enabled"] = false,
					["name"] = "Healing Tide Totem",
					["id"] = 108280,
					["class"] = "SHAMAN",
					["icon"] = "Interface\\Icons\\ability_shaman_healingtide",
				}, -- [35]
				{
					["enabled"] = true,
					["name"] = "Hymn of Hope",
					["id"] = 64901,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\Spell_Holy_SymbolOfHope",
				}, -- [36]
				{
					["enabled"] = false,
					["name"] = "Ice Block",
					["id"] = 45438,
					["class"] = "MAGE",
					["icon"] = "Interface\\Icons\\Spell_Frost_Frost",
				}, -- [37]
				{
					["enabled"] = false,
					["name"] = "Icebound Fortitude",
					["id"] = 48792,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_DeathKnight_IceBoundFortitude",
				}, -- [38]
				{
					["enabled"] = false,
					["name"] = "Incarnation: Tree of Life",
					["id"] = 33891,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Ability_Druid_ImprovedTreeForm",
				}, -- [39]
				{
					["enabled"] = false,
					["name"] = "Innervate",
					["id"] = 29166,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Spell_Nature_Lightning",
				}, -- [40]
				{
					["enabled"] = false,
					["name"] = "Ironbark",
					["id"] = 102342,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\spell_druid_ironbark",
				}, -- [41]
				{
					["enabled"] = false,
					["name"] = "Kick",
					["id"] = 1766,
					["class"] = "ROGUE",
					["icon"] = "Interface\\Icons\\Ability_Kick",
				}, -- [42]
				{
					["enabled"] = false,
					["name"] = "Last Stand",
					["id"] = 12975,
					["class"] = "WARRIOR",
					["icon"] = "Interface\\Icons\\Spell_Holy_AshesToAshes",
				}, -- [43]
				{
					["enabled"] = false,
					["name"] = "Lay on Hands",
					["id"] = 633,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_LayOnHands",
				}, -- [44]
				{
					["enabled"] = false,
					["name"] = "Leap of Faith",
					["id"] = 73325,
					["class"] = "PRIEST",
					["icon"] = "INTERFACE\\ICONS\\priest_spell_leapoffaith_a",
				}, -- [45]
				{
					["enabled"] = false,
					["name"] = "Lichborne",
					["id"] = 49039,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_Shadow_RaiseDead",
				}, -- [46]
				{
					["enabled"] = false,
					["name"] = "Life Cocoon",
					["id"] = 116849,
					["class"] = "MONK",
					["icon"] = "Interface\\Icons\\ability_monk_chicocoon",
				}, -- [47]
				{
					["enabled"] = true,
					["name"] = "Mana Tide Totem",
					["id"] = 16190,
					["class"] = "SHAMAN",
					["icon"] = "Interface\\Icons\\Spell_Frost_SummonWaterElemental",
				}, -- [48]
				{
					["enabled"] = false,
					["name"] = "Mass Spell Reflection",
					["id"] = 114028,
					["class"] = "WARRIOR",
					["icon"] = "Interface\\Icons\\Ability_Warrior_ShieldBreak",
				}, -- [49]
				{
					["enabled"] = false,
					["name"] = "Mighty Bash",
					["id"] = 5211,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Ability_Druid_Bash",
				}, -- [50]
				{
					["enabled"] = false,
					["name"] = "Mind Freeze",
					["id"] = 47528,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_DeathKnight_MindFreeze",
				}, -- [51]
				{
					["enabled"] = false,
					["name"] = "Misdirection",
					["id"] = 34477,
					["class"] = "HUNTER",
					["icon"] = "Interface\\Icons\\Ability_Hunter_Misdirection",
				}, -- [52]
				{
					["enabled"] = false,
					["name"] = "Nature's Vigil",
					["id"] = 124974,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Achievement_Zone_Feralas",
				}, -- [53]
				{
					["enabled"] = false,
					["name"] = "Pain Suppression",
					["id"] = 33206,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\Spell_Holy_PainSupression",
				}, -- [54]
				{
					["enabled"] = true,
					["name"] = "Power Word: Barrier",
					["id"] = 62618,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\spell_holy_powerwordbarrier",
				}, -- [55]
				{
					["enabled"] = false,
					["name"] = "Pummel",
					["id"] = 6552,
					["class"] = "WARRIOR",
					["icon"] = "Interface\\Icons\\INV_Gauntlets_04",
				}, -- [56]
				{
					["enabled"] = true,
					["name"] = "Raise Ally",
					["id"] = 61999,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_Shadow_DeadofNight",
				}, -- [57]
				{
					["enabled"] = false,
					["name"] = "Raise Dead",
					["id"] = 46584,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_Shadow_AnimateDead",
				}, -- [58]
				{
					["enabled"] = true,
					["name"] = "Rallying Cry",
					["id"] = 97462,
					["class"] = "WARRIOR",
					["icon"] = "INTERFACE\\ICONS\\ability_toughness",
				}, -- [59]
				{
					["enabled"] = true,
					["name"] = "Rebirth",
					["id"] = 20484,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Spell_Nature_Reincarnation",
				}, -- [60]
				{
					["enabled"] = false,
					["name"] = "Rebuke",
					["id"] = 96231,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\spell_holy_rebuke",
				}, -- [61]
				{
					["enabled"] = false,
					["name"] = "Reincarnation",
					["id"] = 20608,
					["class"] = "SHAMAN",
					["icon"] = "INTERFACE\\ICONS\\spell_shaman_improvedreincarnation",
				}, -- [62]
				{
					["enabled"] = false,
					["name"] = "Repentance",
					["id"] = 20066,
					["class"] = "PALADIN",
					["icon"] = "Interface\\Icons\\Spell_Holy_PrayerOfHealing",
				}, -- [63]
				{
					["enabled"] = true,
					["name"] = "Revival",
					["id"] = 115310,
					["class"] = "MONK",
					["icon"] = "Interface\\Icons\\Spell_Shaman_BlessingOfEternals",
				}, -- [64]
				{
					["enabled"] = false,
					["name"] = "Ritual of Summoning",
					["id"] = 698,
					["class"] = "WARLOCK",
					["icon"] = "Interface\\Icons\\Spell_Shadow_Twilight",
				}, -- [65]
				{
					["enabled"] = false,
					["name"] = "Shattering Throw",
					["id"] = 64382,
					["class"] = "WARRIOR",
					["icon"] = "Interface\\Icons\\Ability_Warrior_ShatteringThrow",
				}, -- [66]
				{
					["enabled"] = false,
					["name"] = "Shield Wall",
					["id"] = 871,
					["class"] = "WARRIOR",
					["icon"] = "Interface\\Icons\\Ability_Warrior_ShieldWall",
				}, -- [67]
				{
					["enabled"] = false,
					["name"] = "Shroud of Concealment",
					["id"] = 114018,
					["class"] = "ROGUE",
					["icon"] = "Interface\\Icons\\ability_rogue_shroudofconcealment",
				}, -- [68]
				{
					["enabled"] = false,
					["name"] = "Skull Banner",
					["id"] = 114207,
					["class"] = "WARRIOR",
					["icon"] = "Interface\\Icons\\warrior_skullbanner",
				}, -- [69]
				{
					["enabled"] = true,
					["name"] = "Soulstone",
					["id"] = 20707,
					["class"] = "WARLOCK",
					["icon"] = "Interface\\Icons\\Spell_Shadow_SoulGem",
				}, -- [70]
				{
					["enabled"] = true,
					["name"] = "Spirit Link Totem",
					["id"] = 98008,
					["class"] = "SHAMAN",
					["icon"] = "Interface\\Icons\\Spell_Shaman_SpiritLink",
				}, -- [71]
				{
					["enabled"] = false,
					["name"] = "Spirit Shell",
					["id"] = 109964,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\ability_shaman_astralshift",
				}, -- [72]
				{
					["enabled"] = false,
					["name"] = "Stoneform",
					["id"] = 20594,
					["class"] = "ANY",
					["icon"] = "Interface\\Icons\\Spell_Shadow_UnholyStrength",
				}, -- [73]
				{
					["enabled"] = false,
					["name"] = "Strangulate",
					["id"] = 47476,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_Shadow_SoulLeech_3",
				}, -- [74]
				{
					["enabled"] = false,
					["name"] = "Summon Water Elemental",
					["id"] = 31687,
					["class"] = "MAGE",
					["icon"] = "Interface\\Icons\\Spell_Frost_SummonWaterElemental_2",
				}, -- [75]
				{
					["enabled"] = false,
					["name"] = "Survival Instincts",
					["id"] = 61336,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Ability_Druid_TigersRoar",
				}, -- [76]
				{
					["enabled"] = false,
					["name"] = "Time Warp",
					["id"] = 80353,
					["class"] = "MAGE",
					["icon"] = "INTERFACE\\ICONS\\ability_mage_timewarp",
				}, -- [77]
				{
					["enabled"] = true,
					["name"] = "Tranquility",
					["id"] = 113277,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\Spell_Nature_Tranquility",
				}, -- [78]
				{
					["enabled"] = true,
					["name"] = "Tranquility",
					["id"] = 740,
					["class"] = "DRUID",
					["icon"] = "Interface\\Icons\\Spell_Nature_Tranquility",
				}, -- [79]
				{
					["enabled"] = false,
					["name"] = "Tricks of the Trade",
					["id"] = 57934,
					["class"] = "ROGUE",
					["icon"] = "Interface\\Icons\\Ability_Rogue_TricksOftheTrade",
				}, -- [80]
				{
					["enabled"] = false,
					["name"] = "Vampiric Blood",
					["id"] = 55233,
					["class"] = "DEATHKNIGHT",
					["icon"] = "Interface\\Icons\\Spell_Shadow_LifeDrain",
				}, -- [81]
				{
					["enabled"] = false,
					["name"] = "Vampiric Embrace",
					["id"] = 15286,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\Spell_Shadow_UnsummonBuilding",
				}, -- [82]
				{
					["enabled"] = false,
					["name"] = "Void Shift",
					["id"] = 108968,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\spell_priest_voidshift",
				}, -- [83]
				{
					["enabled"] = false,
					["name"] = "Void Tendrils",
					["id"] = 108920,
					["class"] = "PRIEST",
					["icon"] = "Interface\\Icons\\spell_priest_voidtendrils",
				}, -- [84]
				{
					["enabled"] = false,
					["name"] = "Wind Shear",
					["id"] = 57994,
					["class"] = "SHAMAN",
					["icon"] = "Interface\\Icons\\Spell_Nature_Cyclone",
				}, -- [85]
				{
					["enabled"] = false,
					["name"] = "Zen Meditation",
					["id"] = 115176,
					["class"] = "MONK",
					["icon"] = "Interface\\Icons\\ability_monk_zenmeditation",
				}, -- [86]
			},
			["items"] = {
				{
					["enabled"] = false,
					["name"] = "Mirror of Broken Images",
					["id"] = -62466,
					["class"] = "ANY",
					["icon"] = "Interface\\Icons\\INV_Misc_Platnumdisks",
				}, -- [1]
			},
			["welcome"] = true,
			["plugins"] = {
				["Hermes-UI"] = {
					["views"] = {
						{
							["module"] = "GridButtons",
							["filterrange"] = false,
							["filter10man"] = true,
							["filterself"] = false,
							["enabled"] = true,
							["profiles"] = {
								["GridBars"] = {
									["barShowTime"] = true,
									["npCCFont"] = true,
									["barShowPlayerName"] = true,
									["h"] = 838.6666870117188,
									["hideNoAvailSender"] = false,
									["barColorC"] = {
										["a"] = 0.74,
										["r"] = 0.55,
										["g"] = 0.55,
										["b"] = 0.55,
									},
									["locked"] = false,
									["barFont"] = "Friz Quadrata TT",
									["barBGColorU"] = {
										["a"] = 0.16,
										["r"] = 0,
										["g"] = 0,
										["b"] = 0,
									},
									["hideNoSender"] = true,
									["barTexture"] = "Blizzard",
									["osCooldownStyle"] = "empty",
									["barColorU"] = {
										["a"] = 0.23,
										["r"] = 0,
										["g"] = 0,
										["b"] = 0,
									},
									["y"] = 1175.333374023438,
									["x"] = 7.833518028259277,
									["barPadding"] = 1,
									["scale"] = 1,
									["npTexture"] = "Blizzard",
									["barCooldownDirection"] = "right",
									["barThickFont"] = false,
									["barBGCCU"] = false,
									["barColorCFont"] = {
										["a"] = 1,
										["r"] = 1,
										["g"] = 1,
										["b"] = 1,
									},
									["barCCAFont"] = false,
									["barTextRatio"] = 65,
									["cellAnchor"] = "TOPLEFT",
									["padding"] = 0,
									["barW"] = 150,
									["barIcon"] = "left",
									["npShowLabel"] = true,
									["barCCA"] = true,
									["barIconMerged"] = "left",
									["osFGColor"] = {
										["a"] = 1,
										["r"] = 0,
										["g"] = 1,
										["b"] = 0,
									},
									["barColorUFont"] = {
										["a"] = 0.3,
										["r"] = 1,
										["g"] = 1,
										["b"] = 1,
									},
									["barCooldownStyle"] = "empty",
									["barBGColorC"] = {
										["a"] = 0.16,
										["r"] = 0,
										["g"] = 0,
										["b"] = 0,
									},
									["osCooldownDirection"] = "right",
									["npThickFont"] = false,
									["barColorA"] = {
										["a"] = 1,
										["r"] = 0.94,
										["g"] = 0.94,
										["b"] = 0.94,
									},
									["npFontColor"] = {
										["a"] = 0.76,
										["r"] = 0.92,
										["g"] = 0.92,
										["b"] = 0.92,
									},
									["barCCU"] = false,
									["barCCC"] = true,
									["npUseNameplate"] = true,
									["barCCCFont"] = true,
									["cellSide"] = false,
									["npFont"] = "Friz Quadrata TT",
									["w"] = 158.6666564941406,
									["barTextSide"] = "left",
									["barCCUFont"] = false,
									["npOutlineFont"] = true,
									["osEnabled"] = false,
									["cellDir"] = false,
									["barShowSpellName"] = false,
									["barFontSize"] = 12,
									["barH"] = 14,
									["enableTooltip"] = true,
									["barGap"] = 2,
									["npCCBar"] = false,
									["npW"] = 120,
									["merged"] = false,
									["npUseIcon"] = true,
									["barColorAFont"] = {
										["a"] = 1,
										["r"] = 0.94,
										["g"] = 0.94,
										["b"] = 0.94,
									},
									["barBGCCC"] = true,
									["npIcon"] = "right",
									["cellMax"] = 3,
									["npFontSize"] = 12,
									["npTexColor"] = {
										["a"] = 0.5,
										["r"] = 0,
										["g"] = 0,
										["b"] = 0,
									},
									["npH"] = 15,
									["cellBGColor"] = {
										["a"] = 0,
										["r"] = 0,
										["g"] = 0,
										["b"] = 0,
									},
									["npTextSide"] = "right",
									["barOutlineFont"] = true,
								},
								["GridButtons"] = {
								["scale"] = 1,
								["hideNoSender"] = true,
								["merged"] = false,
								["coloredBorders"] = true,
								["w"] = 78.49994614504892,
								["mergedicon"] = "Interface\\ICONS\\INV_Misc_QuestionMark",
								["y"] = 1040.833318755454,
								["h"] = 621.6666788167995,
								["locked"] = true,
								["cellAnchor"] = "TOPLEFT",
								["colorNS"] = {
									["a"] = 0.75,
									["r"] = 0.5,
									["g"] = 0.5,
									["b"] = 0.5,
								},
								["padding"] = 5,
								["x"] = 3.333442160227062,
								["colorU"] = {
									["a"] = 1,
									["r"] = 0.5,
									["g"] = 0.5,
									["b"] = 0.5,
								},
							},
							["CooldownBars"] = {
								["barheight"] = 14,
								["scale"] = 1,
								["barTextSide"] = "left",
								["fontsize"] = 12,
								["locked"] = false,
								["barCooldownDirection"] = "right",
								["hideSelf"] = false,
								["textratio"] = 60,
								["osFGColor"] = {
									["a"] = 1,
									["r"] = 0,
									["g"] = 1,
									["b"] = 0,
								},
								["barwidth"] = 180,
								["bartexture"] = "Blizzard",
								["growup"] = false,
								["osCooldownDirection"] = "right",
								["alpha"] = 1,
								["barIcon"] = "left",
								["y"] = 1022.333312988281,
								["font"] = "Friz Quadrata TT",
								["barCooldownStyle"] = "full",
								["osEnabled"] = false,
								["osCooldownStyle"] = "full",
								["barShowSpellName"] = false,
								["x"] = 71.66675567626953,
								["barGap"] = 1,
							},
							["Bars"] = {
								["barIcon"] = "none",
								["npCCFont"] = true,
								["barW"] = 150,
								["barTextSide"] = "left",
								["barShowPlayerName"] = true,
								["barBGColorC"] = {
									["a"] = 0.16,
									["r"] = 0,
									["g"] = 0,
									["b"] = 0,
								},
								["barFontSize"] = 12,
								["locked"] = false,
								["barCCCFont"] = true,
								["barColorC"] = {
									["a"] = 0.74,
									["r"] = 0.55,
									["g"] = 0.55,
									["b"] = 0.55,
								},
								["barCCA"] = true,
								["barTextRatio"] = 65,
								["barLocation"] = "BOTTOM",
								["barCCC"] = true,
								["barColorAFont"] = {
									["a"] = 1,
									["r"] = 0.94,
									["g"] = 0.94,
									["b"] = 0.94,
								},
								["osFGColor"] = {
									["a"] = 1,
									["r"] = 0,
									["g"] = 1,
									["b"] = 0,
								},
								["barBGColorU"] = {
									["a"] = 0.16,
									["r"] = 0,
									["g"] = 0,
									["b"] = 0,
								},
								["hideNoSender"] = true,
								["barColorCFont"] = {
									["a"] = 1,
									["r"] = 1,
									["g"] = 1,
									["b"] = 1,
								},
								["barColorUFont"] = {
									["a"] = 0.3,
									["r"] = 1,
									["g"] = 1,
									["b"] = 1,
								},
								["osCooldownStyle"] = "empty",
								["barColorU"] = {
									["a"] = 0.23,
									["r"] = 0,
									["g"] = 0,
									["b"] = 0,
								},
								["y"] = 609,
								["x"] = 1016.666687011719,
								["barCooldownStyle"] = "empty",
								["npShowLabel"] = true,
								["scale"] = 1,
								["barPadding"] = 10,
								["npThickFont"] = false,
								["npUseNameplate"] = true,
								["npFontColor"] = {
									["a"] = 0.76,
									["r"] = 0.92,
									["g"] = 0.92,
									["b"] = 0.92,
								},
								["barCCU"] = false,
								["npOutlineFont"] = true,
								["barBGCCU"] = false,
								["npFontSize"] = 12,
								["barShowTime"] = true,
								["npFont"] = "Friz Quadrata TT",
								["osCooldownDirection"] = "right",
								["npTextSide"] = "right",
								["barCCUFont"] = false,
								["barH"] = 14,
								["barThickFont"] = false,
								["npTexture"] = "Blizzard",
								["barIconMerged"] = "left",
								["barCooldownDirection"] = "right",
								["npIcon"] = "right",
								["barShowSpellName"] = false,
								["barGap"] = 1,
								["npCCBar"] = false,
								["npH"] = 15,
								["merged"] = false,
								["npUseIcon"] = true,
								["barColorA"] = {
									["a"] = 1,
									["r"] = 0.94,
									["g"] = 0.94,
									["b"] = 0.94,
								},
								["barBGCCC"] = true,
								["barCCAFont"] = false,
								["growUp"] = false,
								["osEnabled"] = false,
								["barFont"] = "Friz Quadrata TT",
								["npW"] = 120,
								["npTexColor"] = {
									["a"] = 0.5,
									["r"] = 0,
									["g"] = 0,
									["b"] = 0,
								},
								["barTexture"] = "Blizzard",
								["barOutlineFont"] = true,
							},
						},
						["includeAll"] = true,
						["filterdead"] = true,
						["name"] = "Default",
						["filterconnection"] = true,
						["filterplayertype"] = "disabled",
						["playerfilters"] = {
						},
						["filter25man"] = true,
						["abilities"] = {
							{
								["id"] = 61999,
								["enabled"] = false,
							}, -- [1]
							{
								["id"] = 46584,
								["enabled"] = false,
							}, -- [2]
							{
								["id"] = 20484,
								["enabled"] = false,
							}, -- [3]
							{
								["id"] = 740,
								["enabled"] = false,
							}, -- [4]
							{
								["id"] = 115310,
								["enabled"] = false,
							}, -- [5]
							{
								["id"] = 31821,
								["enabled"] = false,
							}, -- [6]
							{
								["id"] = 64843,
								["enabled"] = false,
							}, -- [7]
							{
								["id"] = 64901,
								["enabled"] = false,
							}, -- [8]
							{
								["id"] = 62618,
								["enabled"] = false,
							}, -- [9]
							{
								["id"] = 113277,
								["enabled"] = false,
							}, -- [10]
							{
								["id"] = 16190,
								["enabled"] = false,
							}, -- [11]
							{
								["id"] = 108280,
								["enabled"] = false,
							}, -- [12]
							{
								["id"] = 98008,
								["enabled"] = false,
							}, -- [13]
							{
								["id"] = 20707,
								["enabled"] = false,
							}, -- [14]
							{
								["id"] = 97462,
								["enabled"] = false,
							}, -- [15]
							{
								["id"] = 115176,
								["enabled"] = false,
							}, -- [16]
							{
								["id"] = 116849,
								["enabled"] = false,
							}, -- [17]
						},
					}, -- [1]
				},
			},
		},
		["enableparty"] = true,
	}
end
  
	if profile == "Repooc" then
		-- No Settings
	end
  
	if profile == "Darth" then
		-- No Settings
	end

	return database
end

-- register the profile with the engine
AI:RegisterAddonProfile(name, ace3, dbname, OnDemand)