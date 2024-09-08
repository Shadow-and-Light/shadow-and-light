local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local module = SLE:GetModule('ObjectiveTracker')

local ACH = E.Libs.ACH
local C

local ApplyAllDefaults = {
	font = 'PT Sans Narrow',
	fontSize = 12,
	fontOutline = 'OUTLINE'
}
local currentSelection = {}

local getTextColor = function(info)
	local t = E.db.sle.objectiveTracker[info[#info-3]][info[#info-2]][info[#info-1]][info[#info]]
	local d = P.sle.objectiveTracker[info[#info-3]][info[#info-2]][info[#info-1]][info[#info]]
	return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
end

local setTextColor = function(info, r, g, b, a)
	local t = E.db.sle.objectiveTracker[info[#info-3]][info[#info-2]][info[#info-1]][info[#info]]
	t.r, t.g, t.b, t.a = r, g, b, a
	module:UpdateFont(info[#info-3])
	if info[#info-2] == 'progressBar' then
		ObjectiveTrackerFrame:Update()
	end
end

local function GetOptions_Icon(dbKey, element)
	local db = E.db.sle.objectiveTracker[dbKey][element].icon

	local options = ACH:Group(L["Icon"], nil, 1, nil, function(info) return db[info[#info]] end, function(info, value) db[info[#info]] = value ObjectiveTrackerFrame:Update() end)
	options.inline = true
	options.args.enable = ACH:Toggle(L["Enable"], nil, 1)
	options.args.spacer1 = ACH:Spacer(2, 'full')
	options.args.scale = ACH:Range(L["Scale"], nil, 3, {min = 0.1, max = 1, step = 0.01}, nil, nil, nil, function() return not db.enable end)

	return options
end

local function GetOptions_Text(dbKey, element)
	local db = E.db.sle.objectiveTracker[dbKey][element].text

	local options = ACH:Group(L["Text"], nil, 1, nil, function(info) return db[info[#info]] end, function(info, value) db[info[#info]] = value module:UpdateFont(dbKey) if element == 'progressBar' then ObjectiveTrackerFrame:Update() end end)
	options.inline = true
	options.args.enable = ACH:Toggle(L["Enable"], nil, 1)
	options.args.spacer1 = ACH:Spacer(2, 'full')
	options.args.font = ACH:SharedMediaFont(L["Font"], nil, 3)
	options.args.fontOutline = ACH:FontFlags(L["Font Outline"], nil, 4)
	options.args.fontSize = ACH:Range(L["Font Size"], nil, 5, C.Values.FontSize)
	options.args.spacer2 = ACH:Spacer(6, 'full')

	if element ~= 'entryText' then
		options.args.color = ACH:Color(L["Color"], nil, 7, nil, nil, getTextColor, setTextColor)
	end

	if element == 'headerText' then
		options.args.spacer3 = ACH:Spacer(10, 'full')
		options.args.useBlizzardHighlight = ACH:Toggle(L["Use Blizzard Highlight Colors"], nil, 11, nil, nil, nil, nil, function(info, value) db[info[#info]] = value end)
	end

	return options
end

local function GetOptions_ObjectiveSections(dbKey, keyData)
	if not dbKey or not keyData then return end
	local db = E.db.sle.objectiveTracker[dbKey]
	if not db then return end

	local sectionName = module.objectiveFramesNames[dbKey]
	local options = ACH:Group(sectionName or L["Invalid Name"], nil, dbKey == 'mainHeader' and 1 or 10, 'tab')

	for element, elementData in next, keyData do
		local name = (element == 'header' and L["Main Header"]) or (element == 'headerText' and L["Quest Entry Header"]) or (element == 'entryText' and L["Quest Entry Text"]) or (element == 'progressBar' and L["Progress Bar"]) or 'N/A'
		local order = (element == 'header' and 1) or (element == 'headerText' and 2) or 5

		--* Create Text Type Tab (Main Category Header, Quest Entry Header, Quest Entry *nyi*)
		options.args[element] = ACH:Group(name, nil, order)

		-- for key in next, elementData do
		for key in next, db[element] do
			if key == 'text' then
				--* Create Text Options
				options.args[element].args[key] = GetOptions_Text(dbKey, element)
			elseif key == 'icon' then
				--* Create Icon Options
				options.args[element].args[key] = GetOptions_Icon(dbKey, element)
			end
		end
	end

	return options
end

local function ApplyAll(option)
	local db
	for dbKey, keyData in pairs(P.sle.objectiveTracker) do

		for element, data in next, keyData do
			db = E.db.sle.objectiveTracker[dbKey][element].text
			if db and db.enable then
				if option == 'font' and db.font and data.text.font then db.font = currentSelection.font end
				if option == 'fontSize' and db.fontSize and data.text.fontSize then db.fontSize = currentSelection.fontSize end
				if option == 'fontOutline' and db.fontOutline and data.text.fontOutline then db.fontOutline = currentSelection.fontOutline end
			end
		end
		module:UpdateFont(dbKey)
	end
	if option == 'font' then currentSelection.font = nil end
	if option == 'fontSize' then currentSelection.fontSize = nil end
	if option == 'fontOutline' then currentSelection.fontOutline = nil end
end

local function configTable()
	C = unpack(E.Config)
	local Options = ACH:Group(L["Objective Tracker"], nil, 1, 'tab')
	E.Options.args.sle.args.modules.args.objectiveTracker = Options
	Options.args.enable = ACH:Toggle(L["Enable"], nil, 1, nil, nil, nil, function(info) return E.private.sle.objectiveTracker[info[#info]] end, function(info, value) E.private.sle.objectiveTracker[info[#info]] = value E:StaticPopup_Show('PRIVATE_RL') end)

	local SelectSection = ACH:Group(L["Objective Tracker Sections"], nil, 10, 'tree')
	Options.args.selectSection = SelectSection
	for dbKey, keyData in pairs(P.sle.objectiveTracker) do
		--* Creates Objective Section on the left side
		SelectSection.args[dbKey] = GetOptions_ObjectiveSections(dbKey, keyData)
	end

	--! Apply To All Section
	local ApplyToAll = ACH:Group(L["Apply To All"], nil, 99, nil, function(info) return currentSelection[info[#info]] or ApplyAllDefaults[info[#info]] end, function(info, value) currentSelection[info[#info]] = value end, function() return not E.private.general.replaceBlizzFonts end)
	Options.args.applyToAll = ApplyToAll

	local Font = ACH:Group(L["Font"], nil, 1, nil, nil, nil)
	Font.inline = true
	ApplyToAll.args.font = Font
	Font.args.font = ACH:SharedMediaFont('', nil, 1)
	Font.args.applyFont = ACH:Execute(L["Apply To All"], nil, 2, function() ApplyAll('font') end)
	ApplyToAll.args.spacer1 = ACH:Spacer(2, 'full')

	local FontSize = ACH:Group(L["Font Size"], nil, 3, nil, nil, nil)
	FontSize.inline = true
	ApplyToAll.args.fontSize = FontSize
	FontSize.args.fontSize = ACH:Range('', nil, 5, C.Values.FontSize)
	FontSize.args.applyFontSize = ACH:Execute(L["Apply To All"], nil, 6, function() ApplyAll('fontSize') end)
	ApplyToAll.args.spacer2 = ACH:Spacer(4, 'full')

	local FontOutline = ACH:Group(L["Font Outline"], nil, 5, nil, nil, nil)
	FontOutline.inline = true
	ApplyToAll.args.fontOutline = FontOutline
	FontOutline.args.fontOutline = ACH:FontFlags('', nil, 10)
	FontOutline.args.applyFontOutline = ACH:Execute(L["Apply To All"], nil, 11, function() ApplyAll('fontOutline') end)
end

tinsert(SLE.Configs, configTable)
