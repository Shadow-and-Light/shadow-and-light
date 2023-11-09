local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local M = SLE.Media
local ACH = E.Libs.ACH
local C

local ApplyAllDefaults = {
	font = 'PT Sans Narrow',
	fontSize = 12,
	fontOutline = 'OUTLINE'
}

local function getFont(info)
	local db = info[#info-2] == 'scenarioStage' and E.db.sle.media.fonts[info[#info-2]][info[#info-1]][info[#info]] or E.db.sle.media.fonts[info[#info-1]][info[#info]]
	return db
end

local function setFont(info, value)
	if info[#info-2] == 'scenarioStage' then
		E.db.sle.media.fonts[info[#info-2]][info[#info-1]][info[#info]] = value
	else
		E.db.sle.media.fonts[info[#info-1]][info[#info]] = value
	end
	E:UpdateMedia()
end

local function GetFontOptions(groupName, order, hideOutline)
	local config = ACH:Group(groupName, nil, order, nil, function(info) return getFont(info) end, function(info, value) setFont(info, value) end, function() return not E.private.general.replaceBlizzFonts end)
	config.guiInline = true

	config.args.font = ACH:SharedMediaFont(L["Font"], nil, 1)
	config.args.fontSize = ACH:Range(L["Font Size"], nil, 2, C.Values.FontSize)
	config.args.fontOutline = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 3, nil, nil, nil, nil, function() return hideOutline and hideOutline or false end)
	-- config.args.fontOutlineWarning = ACH:Description(L["|cffFF0000Warning: "], 4, nil, nil, nil, nil, nil, width, function() return not hideOutline and true or false end) --* Maybe add this again for gossip text but under advanced option selected?

	return config
end

local function ApplyAll()
	E.PopupDialogs["SLE_APPLY_FONT_WARNING"].font = ApplyAllDefaults.font
	E.PopupDialogs["SLE_APPLY_FONT_WARNING"].fontSize = ApplyAllDefaults.fontSize
	E.PopupDialogs["SLE_APPLY_FONT_WARNING"].fontOutline = ApplyAllDefaults.fontOutline
	E:StaticPopup_Show("SLE_APPLY_FONT_WARNING")
end

local function configTable()
	if not SLE.initialized then return end
	C = unpack(E.Config)

	E.Options.args.sle.args.media = ACH:Group(L["Media"], nil, 20, 'tab', nil, nil)
	local Media = E.Options.args.sle.args.media.args
	Media.enable = ACH:Toggle(L["Enable"], nil, 1,nil, nil, nil, function(info) return E.private.sle.media[info[#info]] end, function(info, value) E.private.sle.media[info[#info]] = value E:StaticPopup_Show('PRIVATE_RL') end)

	--* Objective Tracker Tab
	local ObjectiveTracker = ACH:Group(L["Objective Tracker"], nil, 10, nil, nil, nil, function() return not E.private.sle.media.enable or not E.private.general.replaceBlizzFonts end)
	Media.objectiveTracker = ObjectiveTracker
	ObjectiveTracker.args.objectiveHeader = GetFontOptions(L["Category Headers"], 1)
	ObjectiveTracker.args.objectiveHeader.args.description = ACH:Description(format('%s%s|r', E:RGBToHex(1, 0.82, 0), L["The header text of each block/section of the objective tracker. For example, \"Campaign\" & \"Quests\" that break the tracker into a sections."]), 5)
	ObjectiveTracker.args.objective = GetFontOptions(L["Tracker Entries"], 2)
	ObjectiveTracker.args.scenarioStage = ACH:Group(L["Scenario Stage Block"], nil, 10, nil)
	ObjectiveTracker.args.scenarioStage.guiInline = true
	ObjectiveTracker.args.scenarioStage.args.HeaderText = GetFontOptions(L["Header"], 1)
	ObjectiveTracker.args.scenarioStage.args.TimerText = GetFontOptions(L["Timer"], 2)
	ObjectiveTracker.args.example = ACH:Description(nil, 20, nilfontSize, [[Interface\AddOns\ElvUI_SLE\media\options\ObjectiveTracker]], nil, 256, 256, 256)

	--* Misc Tab
	local MiscTexts = ACH:Group(L["Misc Texts"], nil, 15, nil, nil, nil, function() return not E.private.sle.media.enable or not E.private.general.replaceBlizzFonts end)
	Media.misc = MiscTexts
	MiscTexts.args.mail = GetFontOptions(L["Mail Text"], 1)
	MiscTexts.args.questFontSuperHuge = GetFontOptions(L["Banner Big Text"], 3)

	--* Apply To All
	local ApplyToAll = ACH:Group(L["Apply Font To All"], nil, 20, nil, function(info) return ApplyAllDefaults[info[#info]] end, function(info, value) ApplyAllDefaults[info[#info]] = value end, function() return not E.private.sle.media.enable or not E.private.general.replaceBlizzFonts end)
	Media.applyAll = ApplyToAll
	ApplyToAll.args.font = ACH:SharedMediaFont(L["Font"], nil, 1, nil, nil, nil)
	ApplyToAll.args.fontSize = ACH:Range(L["Font Size"], nil, 2, C.Values.FontSize)
	ApplyToAll.args.fontOutline = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 3)
	ApplyToAll.args.apply = ACH:Execute(L["Apply Font To All"], nildesc, 4, function() ApplyAll() end)
end

tinsert(SLE.Configs, configTable)
