local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Pr = SLE.Professions
local Fishing = SLE.Fishing

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.professions = ACH:Group(L["Professions"], nil, 1, 'tab')
	local Professions = E.Options.args.sle.args.modules.args.professions.args
	Professions.header = ACH:Header(L["Professions"], 1)

	--* Deconstruction Mode
	Professions.deconButton = ACH:Group(L["Deconstruction Mode"], nil, 2)
	local DeconButton = Professions.deconButton.args
	DeconButton.enable = ACH:Toggle(L["Enable"], L["Create a button in your bag frame to switch to deconstruction mode allowing you to easily disenchant/mill/prospect and pick locks."], 1, nil, nil, nil, function(info) return E.private.sle.professions.deconButton[info[#info]] end, function(info, value) E.private.sle.professions.deconButton[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end)
	DeconButton.style = ACH:Select(L["Style"], nil, 2, {BIG = L["Actionbar Proc"], SMALL = L["Actionbar Autocast"], PIXEL = L["Pixel"], NO = NONE}, nil, nil, function(info) return E.private.sle.professions.deconButton[info[#info]] end, function(info, value) E.private.sle.professions.deconButton[info[#info]] = value end)
	DeconButton.buttonGlow = ACH:Toggle(L["Show glow on bag button"], L["Show glow on the deconstruction button in bag when deconstruction mode is enabled.\nApplies on next mode toggle."], 3, nil, nil, nil, function(info) return E.private.sle.professions.deconButton[info[#info]] end, function(info, value) E.private.sle.professions.deconButton[info[#info]] = value end, function() return not E.private.sle.professions.deconButton.enable end)

	--* Enchanting
	Professions.enchant = ACH:Group(L["Enchanting"], nil, 3)
	local Enchant = Professions.enchant.args
	Enchant.desc = ACH:Description(L["Following options are global and will be applied to all characters on account."], 2)
	Enchant.ignoreItems = ACH:Input(L["Deconstruction ignore"], L["Items listed here will be ignored in deconstruction mode. Add names or item links, entries must be separated by comma."], 3, true, 'full', function() return E.global.sle.DE.Blacklist end, function(_, value) E.global.sle.DE.Blacklist = value Pr:Blacklisting('DE') end, function() return not E.private.sle.professions.deconButton.enable end)
	Enchant.IgnoreTabards = ACH:Toggle(L["Ignore tabards"], L["Deconstruction mode will ignore tabards."], 4, nil, nil, nil, function(info) return E.global.sle.DE[info[#info]] end, function(info, value) E.global.sle.DE[info[#info]] = value end, function() return not E.private.sle.professions.deconButton.enable end, function() return not E.global.sle.advanced.general end)
	Enchant.IgnorePanda = ACH:Toggle(L["Ignore Pandaria BoA"], L["Deconstruction mode will ignore BoA weapons from Pandaria."], 5, nil, nil, nil, function(info) return E.global.sle.DE[info[#info]] end, function(info, value) E.global.sle.DE[info[#info]] = value end, function() return not E.private.sle.professions.deconButton.enable end, function() return not E.global.sle.advanced.general end)
	Enchant.IgnoreCooking = ACH:Toggle(L["Ignore Cooking"], L["Deconstruction mode will ignore cooking specific items."], 6, nil, nil, nil, function(info) return E.global.sle.DE[info[#info]] end, function(info, value) E.global.sle.DE[info[#info]] = value end, function() return not E.private.sle.professions.deconButton.enable end, function() return not E.global.sle.advanced.general end)
	Enchant.IgnoreFishing = ACH:Toggle(L["Ignore Fishing"], L["Deconstruction mode will ignore fishing specific items."], 7, nil, nil, nil, function(info) return E.global.sle.DE[info[#info]] end, function(info, value) E.global.sle.DE[info[#info]] = value end, function() return not E.private.sle.professions.deconButton.enable end, function() return not E.global.sle.advanced.general end)

	--* Lock Picking
	Professions.lockpick = ACH:Group(L["Lock Picking"], nil, 4)
	local LockPick = Professions.lockpick.args
	LockPick.desc = ACH:Description(L["Following options are global and will be applied to all characters on account."], 1)
	LockPick.ignoreItems = ACH:Input(L["Deconstruction ignore"], L["Items listed here will be ignored in deconstruction mode. Add names or item links, entries must be separated by comma."], 2, true, 'full', function() return E.global.sle.LOCK.Blacklist end, function(_, value) E.global.sle.LOCK.Blacklist = value Pr:Blacklisting('LOCK') end, function() return not E.private.sle.professions.deconButton.enable end)
	LockPick.TradeOpen = ACH:Toggle(L["Unlock in trade"], L["Apply unlocking skills in trade window the same way as in deconstruction mode for bags."], 3, nil, nil, nil, function(info) return E.global.sle.LOCK[info[#info]] end, function(info, value) E.global.sle.LOCK[info[#info]] = value end, function() return not E.private.sle.professions.deconButton.enable end)

	--* Fishing
	Professions.fishing = ACH:Group(L["Fishing"], nil, 5, nil, function(info) return E.db.sle.professions.fishing[info[#info]] end, function(info, value) E.db.sle.professions.fishing[info[#info]] = value end)
	local Fish = Professions.fishing.args
	Fish.easyCast = ACH:Toggle(L["Easy Cast"], L["Allow to fish with double right-click."], 1, nil, nil, nil, nil, function(info, value) E.db.sle.professions.fishing[info[#info]] = value Fishing:ToggleOptions() end)
	Fish.fromMount = ACH:Toggle(L["While Mounted"], L["Start fishing even if you are mounted."], 2, nil, nil, nil, nil, function(info) return not E.db.sle.professions.fishing[info[#info]] end)
	Fish.autoLoot = ACH:Toggle(L["Auto Loot"], L["This will turn on Auto Loot while fishing if it is not on already."], 3, nil, nil, nil, nil, function(info) return not E.db.sle.professions.fishing[info[#info]] end)
	Fish.useLure = ACH:Toggle(L["Apply Lures"], L["Automatically apply lures."], 3, nil, nil, nil, nil, function(info) return not E.db.sle.professions.fishing[info[#info]] end)
	Fish.castKey = ACH:Select(L["Cast Key"], L["Hold this button while clicking to allow fishing action."], 6, {shift = SHIFT_KEY, alt = ALT_KEY, control = CTRL_KEY}, nil, nil, nil, function(info, value) E.db.sle.professions.fishing[info[#info]] = value end, function() return not E.db.sle.professions.fishing.easyCast end)
	Fish.mouseButton = ACH:Select(L["Mouse Button"], L["Double Click this mouse button to start fishing."], 6, {right = L["Right"], button4 = L["Button 4"], button5 = L["Button 5"]}, nil, nil, nil, function(info, value) E.db.sle.professions.fishing[info[#info]] = value end, function() return not E.db.sle.professions.fishing.easyCast end)
end

tinsert(SLE.Configs, configTable)
