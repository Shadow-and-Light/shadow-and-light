local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SA = SLE.Armory_Stats
local M = E.Misc
local ACH = E.Libs.ACH
local C

local function GetFontOptions(groupName, order, itemLevel)
	local config = ACH:Group(groupName, nil, order, nil, function(info) return E.db.sle.armory.stats[info[#info-1]][info[#info]] end, function(info, value) E.db.sle.armory.stats[info[#info-1]][info[#info]] = value if itemLevel then SA:UpdateIlvlFont() else SA:PaperDollFrame_UpdateStats() end end)
	config.guiInline = true

	config.args.font = ACH:SharedMediaFont(L["Font"], nil, 1)
	config.args.fontSize = ACH:Range(L["Font Size"], nil, 2, C.Values.FontSize)
	config.args.fontOutline = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 3, nil, nil, nil, nil, nil)

	return config
end

local table = {}
local function getReplacementTable()
	wipe(table)
	table[''] = L["None Selected"]

	for label in pairs(E.db.sle.armory.stats.textReplacements) do
		table[label] = _G[label]
	end

	return table
end

local function getStatName(stat)
	local currentText = E.db.sle.armory.stats.textReplacements[stat]
	local displayString = '%s%s %s|r'

	local name = format(displayString, E:RGBToHex(1, 0.82, 0), (currentText and currentText ~= '') and L["Current Setting:"] or '', currentText and currentText or '')

	return name
end

local function GetTextReplacements(label)
	local config = E.Options.args.sle.args.modules.args.armory.args.stats.args.StringReplacements.args
	if not label or label == '' then config.textReplacements = nil return end

	config.textReplacements = ACH:Group(_G[label], nil, 10, nil, function(info) return E.db.sle.armory.stats[info[#info-1]][info[#info]] end, function(info, value) E.db.sle.armory.stats[info[#info-1]][info[#info]] = value PaperDollFrame_UpdateStats() end)
	config.textReplacements.guiInline = true
	config.textReplacements.args[label] = ACH:Input(function() return getStatName(label) end, nildesc, 5, nilmultiline, 'full', get, set, nildisabled, nilhidden, nilvalidate)
	config.textReplacements.args[label].textChanged = function(text) print('text', text) end
end

local function configTable()
	if not SLE.initialized then return end
	C = unpack(E.Config)
	local selectedString = ''

	E.Options.args.sle.args.modules.args.armory.args.stats = ACH:Group(L["Attributes"], nil, 30, 'tree', function(info) return E.db.sle.armory.stats[info[#info]] end, function(info, value) E.db.sle.armory.stats[info[#info]] = value PaperDollFrame_UpdateStats() M:UpdateCharacterItemLevel() end, function() return SLE._Compatibility['DejaCharacterStats'] or not E.private.sle.armory.stats.enable end, function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end)
	local Stats = E.Options.args.sle.args.modules.args.armory.args.stats.args

	Stats.OnlyPrimary = ACH:Toggle(L["Only Relevant Stats"], L["Show only those primary stats relevant to your spec."], 1)
	Stats.decimals = ACH:Toggle(L["Decimals"], L["Show stats with decimals."], 2)

	--* Stat Label Settings (Spacer)
	Stats.groupSpacer1 = ACH:Group('--- |cff00FF00'..L["Stat Label Settings"]..'|r ---', nil, 10, nil, get, set, true)

	--* Stat Font Settings
	Stats.Fonts = ACH:Group(L["Stat Font Settings"], nil, 11)
	Stats.Fonts.args.statHeaders = GetFontOptions(L["Stat Categories"], 1)
	Stats.Fonts.args.statLabels = GetFontOptions(L["Stat Labels & Value Text"], 2)

	--* String Replacement
	Stats.StringReplacements = ACH:Group(L["String Replacement"], nil, 14)
	local StringReplacements = Stats.StringReplacements.args
	StringReplacements.description = ACH:Description(format('%s%s|r', E:RGBToHex(1, 0.82, 0), L["If you found that some stat labels need to be shorten or abbreviated, select the label from the dropdown below and enter the string to be displayed instead."]), 1, 'medium', nil, nil, nil, nil, width)
	StringReplacements.spacer = ACH:Spacer(2, 'full')
	StringReplacements.labelSelect = ACH:Select(L["Select A Label"], nil, 5, getReplacementTable, nilconfirm, nilwidth, function(_) return selectedString end, function(_, value) selectedString = value GetTextReplacements(selectedString) end, nildisabled, nilhidden)
	StringReplacements.labelSelect.sortByValue = true
	GetTextReplacements(selectedString)

	--* Stats Panel (Spacer)
	Stats.groupSpacer2 = ACH:Group('--- |cff00FF00'..L["Stats Panel"]..'|r ---', nil, 15, nil, get, set, true)

	--* Item Level
	Stats.ItemLevel = ACH:Group(L["Item Level"], nil, 20)
	local ItemLevel = Stats.ItemLevel.args
	ItemLevel.IlvlFull = ACH:Toggle(L["Full Item Level"], L["Show both equipped and average item levels."], 1)
	ItemLevel.IlvlColor = ACH:Toggle(L["Item Level Coloring"], L["Color code item levels values. Equipped will be gradient, average - selected color."], 2, nil, nil, nil, nilget, nilset, function() return SLE._Compatibility['DejaCharacterStats'] or not E.db.sle.armory.stats.IlvlFull or not E.private.sle.armory.stats.enable end)
	ItemLevel.AverageColor = ACH:Color(L["Color of Average"], L["Sets the color of average item level."], 3, false, nil, function(info) local t = E.db.sle.armory.stats[info[#info]] local d = P.sle.armory.stats[info[#info]] return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a end, function(info, r, g, b, a) E.db.sle.armory.stats[info[#info]] = {} local t = E.db.sle.armory.stats[info[#info]] t.r, t.g, t.b, t.a = r, g, b, a M:UpdateCharacterItemLevel() PaperDollFrame_UpdateStats() end, function() return SLE._Compatibility['DejaCharacterStats'] or not E.db.sle.armory.stats.IlvlFull or not E.private.sle.armory.stats.enable end)
	ItemLevel.spacer = ACH:Spacer(10, 'full')
	ItemLevel.itemLevel = GetFontOptions(L["Font Group"], 11, true)
	ItemLevel.gradient = ACH:Group(L["Gradient"], nil, 15, nil, function(info) return E.db.sle.armory.stats[info[#info-1]][info[#info]] end, function(info, value) E.db.sle.armory.stats[info[#info-1]][info[#info]] = value SA:UpdateIlvlFont() end)
	ItemLevel.gradient.guiInline = true
	ItemLevel.gradient.args.style = ACH:Select(L["Style"], nil, 2, { [''] = 'Disabled', blizzard = 'Blizzard', levelupbg = L["Level-Up Background"] })

	--* Attributes
	Stats.Attributes = ACH:Group(L["Attributes"], nil, 25, nil, function(info) return E.db.sle.armory.stats.List[info[#info]] end, function(info, value) E.db.sle.armory.stats.List[info[#info]] = value PaperDollFrame_UpdateStats() end)
	local Attributes = Stats.Attributes.args
	Attributes.HEALTH = ACH:Toggle(L["Health"], nil, 1)
	Attributes.POWER = ACH:Toggle(function() local power = _G[select(2, UnitPowerType('player'))] or L["Power"] return power end, nil, 2)
	Attributes.ALTERNATEMANA = ACH:Toggle(L["Alternate Resource"], nil, 3)
	Attributes.MOVESPEED = ACH:Toggle(L["Speed"], nil, 4)

	--* Attack
	Stats.Attack = ACH:Group(L["Attack"], nil, 30, nil, function(info) return E.db.sle.armory.stats.List[info[#info]] end, function(info, value) E.db.sle.armory.stats.List[info[#info]] = value PaperDollFrame_UpdateStats() end)
	local Attack = Stats.Attack.args
	Attack.ATTACK_DAMAGE = ACH:Toggle(L["Damage"], nil, 1)
	Attack.ATTACK_AP = ACH:Toggle(L["Attack Power"], nil, 2)
	Attack.ATTACK_ATTACKSPEED = ACH:Toggle(L["Attack Speed"], nil, 3)
	Attack.SPELLPOWER = ACH:Toggle(L["Spell Power"], nil, 4)
	Attack.MANAREGEN = ACH:Toggle(L["Mana Regen"], nil, 5)
	Attack.ENERGY_REGEN = ACH:Toggle(L["Energy Regen"], nil, 6)
	Attack.RUNE_REGEN = ACH:Toggle(L["Rune Speed"], nil, 7)
	Attack.FOCUS_REGEN = ACH:Toggle(L["Focus Regen"], nil, 8)

	--* Enhancements
	Stats.Enhancements = ACH:Group(L["Enhancements"], nil, 35, nil, function(info) return E.db.sle.armory.stats.List[info[#info]] end, function(info, value) E.db.sle.armory.stats.List[info[#info]] = value PaperDollFrame_UpdateStats() end)
	local Enhancements = Stats.Enhancements.args
	Enhancements.CRITCHANCE = ACH:Toggle(L["Critical Strike"], nil, 1)
	Enhancements.HASTE = ACH:Toggle(L["Haste"], nil, 2)
	Enhancements.MASTERY = ACH:Toggle(L["Mastery"], nil, 3)
	Enhancements.VERSATILITY = ACH:Toggle(L["Versatility"], nil, 4)
	Enhancements.LIFESTEAL = ACH:Toggle(L["Leech"], nil, 5)

	--* Defense
	Stats.Defense = ACH:Group(L["Defense"], nil, 40, nil, function(info) return E.db.sle.armory.stats.List[info[#info]] end, function(info, value) E.db.sle.armory.stats.List[info[#info]] = value PaperDollFrame_UpdateStats() end)
	local Defense = Stats.Defense.args
	Defense.ARMOR = ACH:Toggle(L["Armor"], nil, 1)
	Defense.AVOIDANCE = ACH:Toggle(L["Avoidance"], nil, 2)
	Defense.DODGE = ACH:Toggle(L["Dodge"], nil, 3)
	Defense.PARRY = ACH:Toggle(L["Parry"], nil, 4)
	Defense.BLOCK = ACH:Toggle(L["Block"], nil, 5)
end

tinsert(SLE.Configs, configTable)
