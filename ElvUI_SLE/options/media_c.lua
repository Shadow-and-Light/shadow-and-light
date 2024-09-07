local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local M = SLE.Media
local ACH = E.Libs.ACH
local C

local ApplyAllDefaults = {
	font = 'PT Sans Narrow',
	fontSize = 12,
	fontOutline = 'OUTLINE'
}

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

	--* Apply To All
	local ApplyToAll = ACH:Group(L["Apply Font To All"], nil, 20, nil, function(info) return ApplyAllDefaults[info[#info]] end, function(info, value) ApplyAllDefaults[info[#info]] = value end, function() return not E.private.general.replaceBlizzFonts end)
	Media.applyAll = ApplyToAll
	ApplyToAll.args.font = ACH:SharedMediaFont(L["Font"], nil, 1, nil, nil, nil)
	ApplyToAll.args.fontSize = ACH:Range(L["Font Size"], nil, 2, C.Values.FontSize)
	ApplyToAll.args.fontOutline = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 3)
	ApplyToAll.args.apply = ACH:Execute(L["Apply Font To All"], nildesc, 4, function() ApplyAll() end)
end

tinsert(SLE.Configs, configTable)
