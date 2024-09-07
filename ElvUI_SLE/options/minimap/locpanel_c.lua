local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local LP = SLE.LocationPanel
local ACH = E.Libs.ACH

local DEFAULT, CUSTOM, CLASS = DEFAULT, CUSTOM, CLASS
local ceil = ceil
local screenWidth = ceil(E.screenWidth)

local function configTable()
	if not SLE.initialized then return end
	local C = unpack(E.Config)

	local Options = ACH:Group(L["Location Panel"], nil, 1, 'tab', function(info) return E.db.sle.minimap.locPanel[info[#info]] end, nil, function(info) if info[#info] == 'locPanel' then return false else return not E.db.sle.minimap.locPanel.enable end end)
	E.Options.args.sle.args.modules.args.locPanel = Options

	Options.args.enable = ACH:Toggle(L["Enable"], nil, 1, nil, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value LP:Toggle() end, function() return false end)
	Options.args.spacer1 = ACH:Spacer(2, 'full')
	Options.args.combathide = ACH:Toggle(L["Hide In Combat"], nil, 3, nil, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value end)
	Options.args.orderhallhide = ACH:Toggle(L["Hide In Class Hall"], nil, 4, nil, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value end)
	Options.args.spacer2 = ACH:Spacer(6, 'full')
	Options.args.template = ACH:Select(L["Template"], nil, 5, { Default = DEFAULT, Transparent = L["Transparent"], NoBackdrop = L["NoBackdrop"] }, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value LP:Template() end, function() return not E.db.sle.minimap.locPanel.enable end)
	Options.args.autowidth = ACH:Toggle(L["Automatic Width"], L["Change width based on the zone name length."], 7, nil, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value LP:Resize() end)
	Options.args.width = ACH:Range(L["Width"], nil, 8, {min = 100, max = screenWidth/2, step = 1}, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value LP:Resize() end, function() return not E.db.sle.minimap.locPanel.enable or E.db.sle.minimap.locPanel.autowidth end)
	Options.args.height = ACH:Range(L["Height"], nil, 9, {min = 10, max = 50, step = 1}, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value LP:Resize() end)
	Options.args.throttle = ACH:Range(L["Update Throttle"], L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."], 10, {min = 0.1, max = 2, step = 0.1}, nil, nil, function(info, value) E.db.sle.minimap.locPanel[ info[#info] ] = value end)

	--* Location Panel Section
	local Location = ACH:Group(L["Location Panel"], nil, 20, 'tab')
	Location.inline = true
	Options.args.location = Location
	Location.args.zoneText = ACH:Toggle(L["Full Location"], nil, 1, nil, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value end, function() return not E.db.sle.minimap.locPanel.enable end)
	Location.args.linkcoords = ACH:Toggle(L["Link Position"], L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."], 2, nil, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value end)
	Location.args.colorType = ACH:Select(L["Color Type"], nil, 3, { REACTION = L["Reaction"], DEFAULT = DEFAULT, CLASS = CLASS, CUSTOM = CUSTOM }, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[ info[#info] ] = value end)
	Location.args.customColor = ACH:Color(L["Custom Color"], nil, 4, nil, nil, function(info) local t = E.db.sle.minimap.locPanel[ info[#info] ] local d = P.sle.minimap.locPanel[info[#info]] return t.r, t.g, t.b, d.r, d.g, d.b end, function(info, r, g, b) E.db.sle.minimap.locPanel[info[#info]] = {} local t = E.db.sle.minimap.locPanel[info[#info]] t.r, t.g, t.b = r, g, b end, function() return not E.db.sle.minimap.locPanel.enable or E.db.sle.minimap.locPanel.colorType ~= 'CUSTOM' end)

	--* Coords Section
	local Coords = ACH:Group(L["Coordinates"], nil, 21, 'tab', nil, nil, function(info) return not E.db.sle.minimap.locPanel.enable or not E.db.sle.minimap.locPanel.coords.enable end)
	Coords.inline = true
	Options.args.coords = Coords
	Coords.args.enable = ACH:Toggle(L["Enable"], nil, 1, nil, nil, nil, function(info) return E.db.sle.minimap.locPanel[info[#info-1]][info[#info]] end, function(info, value) E.db.sle.minimap.locPanel[info[#info-1]][info[#info]] = value LP:Resize() end, function() if E.db.sle.minimap.locPanel.enable then return false else return not E.db.sle.minimap.locPanel.enable end end)
	Coords.args.spacer1 = ACH:Spacer(2, 'full')
	Coords.args.format = ACH:Select(L["Format"], nil, 3, { ["%.0f"] = DEFAULT, ["%.1f"] = "45.3", ["%.2f"] = "45.34" }, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[ info[#info] ] = value end)
	Coords.args.colorType = ACH:Select(L["Color Type"], nil, 4, { REACTION = L["Reaction"], DEFAULT = DEFAULT, CLASS = CLASS, CUSTOM = CUSTOM }, nil, nil, nil, function(info, value) E.db.sle.minimap.locPanel[info[#info-1]][info[#info]] = value end)
	Coords.args.customColor = ACH:Color(L["Custom Color"], nil, 5, nil, nil, function(info) local t = E.db.sle.minimap.locPanel[info[#info-1]][info[#info]] local d = P.sle.minimap.locPanel[info[#info-1]][info[#info]] return t.r, t.g, t.b, d.r, d.g, d.b end, function(info, r, g, b) E.db.sle.minimap.locPanel[info[#info-1]][info[#info]] = {} local t = E.db.sle.minimap.locPanel[info[#info-1]][info[#info]] t.r, t.g, t.b = r, g, b end)

	--* Portals Section
	local Portals = ACH:Group(L["Relocation Menu"], nil, 22, nil, function(info) return E.db.sle.minimap.locPanel.portals[info[#info]] end, function(info, value) E.db.sle.minimap.locPanel.portals[info[#info]] = value end, function(info) return not E.db.sle.minimap.locPanel.enable or not E.db.sle.minimap.locPanel.portals.enable end)
	Portals.inline = true
	Options.args.portals = Portals
	Portals.args.enable = ACH:Toggle(L["Enable"], L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."], 1, nil, nil, nil, nil, nil, function() if E.db.sle.minimap.locPanel.enable then return false else return not E.db.sle.minimap.locPanel.enable end end)
	Portals.args.spacer1 = ACH:Spacer(2, 'full')
	Portals.args.customWidth = ACH:Toggle(L["Custom Width"], L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."], 3)
	Portals.args.customWidthValue = ACH:Range(L["Width"], nil, 4, { min = 100, max = screenWidth, step = 1 }, nil, nil, nil, function() return not E.db.sle.minimap.locPanel.enable or not E.db.sle.minimap.locPanel.portals.enable or not E.db.sle.minimap.locPanel.portals.customWidth end)
	Portals.args.justify = ACH:Select(L["Justify Text"], nil, 5, { LEFT = L["Left"], CENTER = L["Middle"], RIGHT = L["Right"] })
	Portals.args.cdFormat = ACH:Select(L["Cooldown Format"], nil, 6, { DEFAULT = [[(10m |TInterface\FriendsFrame\StatusIcon-Away:16|t)]], DEFAULT_ICONFIRST = [[( |TInterface\FriendsFrame\StatusIcon-Away:16|t10m)]] })
	Portals.args.HSplace = ACH:Toggle(L["Hearthstone Location"], L["Show the name on location your Hearthstone is bound to."], 7)
	Portals.args.showHearthstones = ACH:Toggle(L["Show hearthstones"], L["Show hearthstone type items in the list."], 8)
	Portals.args.hsProprity = SLE:CreateMovableButtons(22, L["HS Toys Order"], false, E.db.sle.minimap.locPanel.portals, "hsPrio")
	Portals.args.showToys = ACH:Toggle(L["Show Toys"], L["Show toys in the list. This option will affect all other display options as well."], 20)
	Portals.args.showSpells = ACH:Toggle(L["Show spells"], L["Show relocation spells in the list."], 21)
	Portals.args.showEngineer = ACH:Toggle(L["Show engineer gadgets"], L["Show items used only by engineers when the profession is learned."], 22)
	Portals.args.ignoreMissingInfo = ACH:Toggle(L["Ignore missing info"], L["SLE_LOCPANEL_IGNOREMISSINGINFO"], 23)

	--* Font Section
	local FontGroup = ACH:Group(L["Font Group"], nil, 23, nil, function(info) return E.db.sle.minimap.locPanel[info[#info]] end, function(info, value) E.db.sle.minimap.locPanel[info[#info]] = value LP:Fonts() end, function() return not E.db.sle.minimap.locPanel.enable end)
	FontGroup.inline = true
	Options.args.fontGroup = FontGroup
	FontGroup.args.font = ACH:SharedMediaFont(L["Font"], nil, 1)
	FontGroup.args.fontSize = ACH:Range(L["Font Size"], nil, 2, C.Values.FontSize)
	FontGroup.args.fontOutline = ACH:FontFlags(L["Font Outline"], nil, 3)
end

tinsert(SLE.Configs, configTable)
