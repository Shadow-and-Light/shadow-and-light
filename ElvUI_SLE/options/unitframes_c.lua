local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local UF = E.UnitFrames

local _G = _G
local wipe = wipe
local ACH, C, SharedIconOptions, SharedTextOptions, PvPIconText
local roleValues = {}

local DeathIndicatorImages = {
	SKULL = [[|TInterface\LootFrame\LootPanel-Icon:14|t]],
	SKULL1 = [[|TInterface\AddOns\ElvUI_SLE\media\textures\SKULL:16|t]],
	SKULL2 = [[|TInterface\AddOns\ElvUI_SLE\media\textures\SKULL1:16|t]],
	SKULL3 = [[|TInterface\AddOns\ElvUI_SLE\media\textures\SKULL2:16|t]],
	SKULL4 = [[|TInterface\AddOns\ElvUI_SLE\media\textures\SKULL3:16|t]],
	CUSTOM = L["CUSTOM"],
}
local OfflineIndicatorImages = {
	ALERT = [[|TInterface\DialogFrame\UI-Dialog-Icon-AlertNew:14|t]],
	ARTHAS =[[|TInterface\LFGFRAME\UI-LFR-PORTRAIT:14|t]],
	SKULL = [[|TInterface\LootFrame\LootPanel-Icon:14|t]],
	PASS = [[|TInterface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent:14|t]],
	NOTREADY = [[|TInterface\RAIDFRAME\ReadyCheck-NotReady:14|t]],
	CUSTOM = L["CUSTOM"],
}

local function GetOptionsTable_Auras(auraType, updateFunc, groupName)
	local config = ACH:Group(auraType == 'buffs' and L["Buffs"] or L["Debuffs"], nil, 1, nil, function(info) return E.db.sle.unitframe.units[groupName][auraType][info[#info]] end, function(info, value) E.db.sle.unitframe.units[groupName][auraType][info[#info]] = value; updateFunc(E, 'unitframe') end)

	-- config.guiInline = true
	config.args.enable = ACH:Toggle(L["Enable"], nil, 1)
	config.args.threshold = ACH:Range(L["Low Threshold"], L["Threshold before text turns red and is in decimal form. Set to -1 for it to never turn red"], 2, { min = -1, max = 20, step = 1 }, nil, nil, nil, function(info) return not E.db.sle.unitframe.units[groupName][auraType][info[#info]] end)

	return config
end

local function GetOptionsTable_DeathIndicator(updateFunc, groupName, numGroup)
	local db = E.db.sle.unitframe.units[groupName].deathIndicator
	local config = ACH:Group(L["Death Indicator"], nil, 50, nil, function(info) return db[info[#info]] end, function(info, value) db[info[#info]] = value; updateFunc(UF, groupName, numGroup) end)
	-- config.guiInline = true

	config.args = CopyTable(SharedIconOptions)
	config.args.size.args.size.name = function() return db.keepSizeRatio and L["Size"] or L["Width"] end
	config.args.size.args.height.hidden = function() return db.keepSizeRatio end

	config.args.texturespacer = ACH:Spacer(49, 'full')

	local Texture = ACH:Select(L["Texture"], nil, 50, DeathIndicatorImages)
	config.args.texture = Texture

	local Custom = ACH:Input(L["Custom Texture"], nil, 51, nil, 'full', nil, nil, function() return db.texture ~= 'CUSTOM' end)
	config.args.custom = Custom

	return config
end

local function GetOptionsTable_OfflineIndicator(updateFunc, groupName, numGroup)
	local db = E.db.sle.unitframe.units[groupName].offlineIndicator
	local config = ACH:Group(L["Offline Indicator"], nil, 50, nil, function(info) return db[info[#info]] end, function(info, value) db[info[#info]] = value; updateFunc(UF, groupName, numGroup) end)
	-- config.guiInline = true

	config.args = CopyTable(SharedIconOptions)
	config.args.size.args.size.name = function() return db.keepSizeRatio and L["Size"] or L["Width"] end
	config.args.size.args.height.hidden = function() return db.keepSizeRatio end

	config.args.texturespacer = ACH:Spacer(49, 'full')

	local Texture = ACH:Select(L["Texture"], nil, 50, OfflineIndicatorImages)
	config.args.texture = Texture

	local Custom = ACH:Input(L["Custom Texture"], nil, 51, nil, 'full', nil, nil, function() return db.texture ~= 'CUSTOM' end)
	config.args.custom = Custom

	return config
end

local function GetOptionsTable_FontGroup(unit, updateFunc, numGroup)
	local config = ACH:Group(L["Font Group"], nil, 20, nil, function(info) return E.db.sle.unitframe.units[unit].pvpicontext[info[#info-2]][info[#info]] end, function(info, value) E.db.sle.unitframe.units[unit].pvpicontext[info[#info-2]][info[#info]] = value; updateFunc(UF, unit, numGroup) end)
	-- config.guiInline = true

	config.args.font = ACH:SharedMediaFont(L["Font"], nil, 1)
	config.args.fontOutline = ACH:FontFlags(L["Font Outline"], L["Set the font outline."], 2)
	config.args.fontSize = ACH:Range(L["Font Size"], nil, 3, C.Values.FontSize)

	return config
end

local function GetOptionsTable_PvPIconText(name, unit, updateFunc, numGroup)
	local config = ACH:Group(name, nil, 50, nil, function(info) return E.db.sle.unitframe.units[unit].pvpicontext[info[#info-1]][info[#info]] end, function(info, value) E.db.sle.unitframe.units[unit].pvpicontext[info[#info-1]][info[#info]] = value; updateFunc(UF, unit, numGroup) end)
	-- config.guiInline = true

	local Level = ACH:Group(L["Level"], nil, 1, nil, nil)
	config.args.level = Level
	Level.guiInline = true
	Level.args = CopyTable(SharedTextOptions)

	Level.args.fontGroup = GetOptionsTable_FontGroup(unit, updateFunc, numGroup)

	local Timer = ACH:Group(L["Timer"], nil, 1, nil, nil)
	config.args.timer = Timer
	Timer.guiInline = true
	Timer.args = CopyTable(SharedTextOptions)

	Timer.args.fontGroup = GetOptionsTable_FontGroup(unit, updateFunc, numGroup)

	return config
end

local function GetSharedUnitFrameOptions(name, unit, updateFunc, numGroup)
	local config = ACH:Group(name, nil, 100, nil)

	config.args.buffs = GetOptionsTable_Auras('buffs', E.UpdateCooldownSettings, unit)
	config.args.debuffs = GetOptionsTable_Auras('debuffs', E.UpdateCooldownSettings, unit)
	config.args.deathIndicator = GetOptionsTable_DeathIndicator(updateFunc, unit, numGroup)

	return config
end

local function RoleIconValues()
	wipe(roleValues)
	for name, path in pairs(SLE.rolePaths) do
		roleValues[name] = name..' |T'..path['TANK']..':15:15:0:0:64:64:2:56:2:56|t '..'|T'..path['HEALER']..':15:15:0:0:64:64:2:56:2:56|t '..'|T'..path['DAMAGER']..':15:15:0:0:64:64:2:56:2:56|t '
	end

	return roleValues
end

local function UpdateAuraBars()
	_G.ElvUF_Player:UpdateAllElements('ElvUI_UpdateAllElements')
	_G.ElvUF_Target:UpdateAllElements('ElvUI_UpdateAllElements')
	_G.ElvUF_Focus:UpdateAllElements('ElvUI_UpdateAllElements')
	_G.ElvUF_Pet:UpdateAllElements('ElvUI_UpdateAllElements')
end

local function configTable()
	if not SLE.initialized then return end
	C = unpack(E.Config)
	ACH = E.Libs.ACH

	SharedIconOptions = {
		enable = ACH:Toggle(L["Enable"], nil, 0),
		spacer = ACH:Spacer(1, 'full'),
		anchorPoint = ACH:Select(L["Anchor Point"], nil, 5, C.Values.AllPoints),
		xOffset = ACH:Range(L["X-Offset"], nil, 6, { min = -300, max = 300, step = 1 }),
		yOffset = ACH:Range(L["Y-Offset"], nil, 6, { min = -300, max = 300, step = 1 }),
		sizespacer = ACH:Spacer(99, 'full'),
		size = ACH:Group(L["Size"], nil, 100),
	}
	SharedIconOptions.size.inline = true
	SharedIconOptions.size.args.keepSizeRatio = ACH:Toggle(L["Keep Size Ratio"], nil, 0)
	SharedIconOptions.size.args.size = ACH:Range('', nil, 4, { softMin = 14, softMax = 64, min = 12, max = 128, step = 1 })
	SharedIconOptions.size.args.height = ACH:Range(L["Height"], nil, 5, { softMin = 14, softMax = 64, min = 12, max = 128, step = 1 })

	SharedTextOptions = {
		enable = ACH:Toggle(L["Enable"], nil, 0),
		spacer = ACH:Spacer(1, 'full'),
		anchorPoint = ACH:Select(L["Anchor Point"], nil, 5, C.Values.AllPoints),
		xOffset = ACH:Range(L["X-Offset"], nil, 6, { min = -300, max = 300, step = 1 }),
		yOffset = ACH:Range(L["Y-Offset"], nil, 6, { min = -300, max = 300, step = 1 }),
		fontspacer = ACH:Spacer(10, 'full'),
	}

	local UnitFrames = ACH:Group(L["UnitFrames"], nil, 1, 'tab', nil, nil, function() return not E.private.unitframe.enable end)
	E.Options.args.sle.args.modules.args.unitframes = UnitFrames
	UnitFrames.args.desc = ACH:Description(L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."], 1)
	-- UnitFrames.args.Reset = ACH:Execute(L["Restore Defaults"], nil, 2, function() SLE:Reset('unitframes') end)

	local General = ACH:Group(L["General"], nil, 10, 'tab')
	UnitFrames.args.general = General

	local RoleIcons = ACH:Group(L["Role Icon"], nil, 1, nil, function(info) return E.db.sle.unitframes[info[#info-1]][info[#info]] end, function(info, value) E.db.sle.unitframes[info[#info-1]][info[#info]] = value end)
	General.args.roleIcons = RoleIcons
	RoleIcons.inline = true
	RoleIcons.args.enable = ACH:Toggle(L["Enable"], nil, 1, nil, nil, nil, nil, nil, false)
	-- previous desc need to check if chat role icons works still  **it doesnt, test to see about changing that :P **
	-- L["Choose what icon set will unitframes and chat use."]
	RoleIcons.args.icons = ACH:Select(L["LFG Icons"], nil, 2, RoleIconValues)

	local StatusBarTextures = ACH:Group(L["StatusBar Texture"], nil, 5, nil, function(info) return E.db.sle.unitframe.statusbarTextures[info[#info-1]][info[#info]] end, function(info, value) E.db.sle.unitframe.statusbarTextures[info[#info-1]][info[#info]] = value; UF:Update_StatusBars(); UpdateAuraBars() end)
	General.args.statusTextures = StatusBarTextures

	StatusBarTextures.args.aurabar = ACH:Group(L["Aura Bars"], nil, 1)
	StatusBarTextures.args.aurabar.guiInline = true
	StatusBarTextures.args.aurabar.args.enable = ACH:Toggle(L["Enable"], nil, 1, nil, nil, nil, nil, nil, false)
	StatusBarTextures.args.aurabar.args.texture = ACH:SharedMediaStatusbar(L["Texture"], nil, 2, nil, nil, nil, function(info) return not E.db.sle.unitframe.statusbarTextures[info[#info-1]].enable end)

	StatusBarTextures.args.castbar = ACH:Group(L["Castbar"], nil, 1)
	StatusBarTextures.args.castbar.guiInline = true
	StatusBarTextures.args.castbar.args.enable = ACH:Toggle(L["Enable"], nil, 1, nil, nil, nil, nil, nil, false)
	StatusBarTextures.args.castbar.args.texture = ACH:SharedMediaStatusbar(L["Texture"], nil, 2, nil, nil, nil, function(info) return not E.db.sle.unitframe.statusbarTextures[info[#info-1]].enable end)

	StatusBarTextures.args.classbar = ACH:Group(L["Classbar"], nil, 1)
	StatusBarTextures.args.classbar.guiInline = true
	StatusBarTextures.args.classbar.args.enable = ACH:Toggle(L["Enable"], nil, 1, nil, nil, nil, nil, nil, false)
	StatusBarTextures.args.classbar.args.texture = ACH:SharedMediaStatusbar(L["Texture"], nil, 2, nil, nil, nil, function(info) return not E.db.sle.unitframe.statusbarTextures[info[#info-1]].enable end)

	StatusBarTextures.args.powerbar = ACH:Group(L["Power"], nil, 1)
	StatusBarTextures.args.powerbar.guiInline = true
	StatusBarTextures.args.powerbar.args.enable = ACH:Toggle(L["Enable"], nil, 1, nil, nil, nil, nil, nil, false)
	StatusBarTextures.args.powerbar.args.texture = ACH:SharedMediaStatusbar(L["Texture"], nil, 2, nil, nil, nil, function(info) return not E.db.sle.unitframe.statusbarTextures[info[#info-1]].enable end)

	--! Individual Units
	local IndividualUnits = ACH:Group(L["Individual Units"], nil, 15, "tab")
	UnitFrames.args.individualUnits = IndividualUnits

	--* Player Frame
	local Player = GetSharedUnitFrameOptions(L["Player"], 'player', UF.CreateAndUpdateUF)
	IndividualUnits.args.player = Player
	Player.order = 3

	PvPIconText = GetOptionsTable_PvPIconText(L["PvP & Prestige Icon"], 'player', UF.CreateAndUpdateUF)
	Player.args.pvpicontext = PvPIconText

	--* Target Frame
	local Target = GetSharedUnitFrameOptions(L["Target"], 'target', UF.CreateAndUpdateUF)
	IndividualUnits.args.target = Target
	Target.order = 4
	Target.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateUF, 'target')

	PvPIconText = GetOptionsTable_PvPIconText(L["PvP & Prestige Icon"], 'target', UF.CreateAndUpdateUF)
	Target.args.pvpicontext = PvPIconText

	--* TargetTarget Frame
	local TargetTarget = GetSharedUnitFrameOptions(L["TargetTarget"], 'targettarget', UF.CreateAndUpdateUF)
	IndividualUnits.args.targettarget = TargetTarget
	TargetTarget.order = 5
	TargetTarget.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateUF, 'targettarget')

	--* TargetTargetTarget Frame
	local TargetTargetTarget = GetSharedUnitFrameOptions(L["TargetTargetTarget"], 'targettargettarget', UF.CreateAndUpdateUF)
	IndividualUnits.args.targettargettarget = TargetTargetTarget
	TargetTargetTarget.order = 6
	TargetTargetTarget.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateUF, 'targettargettarget')

	--* Focus Frame
	local Focus = GetSharedUnitFrameOptions(L["Focus"], 'focus', UF.CreateAndUpdateUF)
	IndividualUnits.args.focus = Focus
	Focus.order = 7
	Focus.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateUF, 'focus')

	--* FocusTarget Frame
	local FocusTarget = GetSharedUnitFrameOptions(L["FocusTarget"], 'focustarget', UF.CreateAndUpdateUF)
	IndividualUnits.args.focustarget = FocusTarget
	FocusTarget.order = 8
	FocusTarget.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateUF, 'focustarget')

	--* Pet Frame
	-- local Pet = ACH:Group(L["Pet"], nil, 9, 'tab')
	local Pet = GetSharedUnitFrameOptions(L["Pet"], 'pet', UF.CreateAndUpdateUF)
	IndividualUnits.args.pet = Pet
	Pet.order = 9

	--! Don't think Pet needs DeathIndicator as I think the frame just despawns when they die
	-- Pet.args.buffs = GetOptionsTable_Auras('buffs', E.UpdateCooldownSettings, 'pet')
	-- Pet.args.debuffs = GetOptionsTable_Auras('debuffs', E.UpdateCooldownSettings, 'pet')

	--* PetTarget Frame
	local PetTarget = ACH:Group(L["PetTarget"], nil, 10, 'tab')
	IndividualUnits.args.pettarget = PetTarget
	PetTarget.args.buffs = GetOptionsTable_Auras('buffs', E.UpdateCooldownSettings, 'pettarget')
	PetTarget.args.debuffs = GetOptionsTable_Auras('debuffs', E.UpdateCooldownSettings, 'pettarget')

	--! Group Units
	local GroupUnits = ACH:Group(L["Group Units"], nil, 16, 'tab')
	UnitFrames.args.groupUnits = GroupUnits

	--* Party Frame
	local Party = GetSharedUnitFrameOptions(L["Party"], 'party', UF.CreateAndUpdateHeaderGroup)
	GroupUnits.args.party = Party
	Party.order = 3
	Party.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateHeaderGroup, 'party')

	--* Raid1 Frame
	local Raid1 = GetSharedUnitFrameOptions(L["Raid 1"], 'raid1', UF.CreateAndUpdateHeaderGroup)
	GroupUnits.args.raid1 = Raid1
	Raid1.order = 4
	Raid1.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateHeaderGroup, 'raid1')

	--* Raid2 Frame
	local Raid2 = GetSharedUnitFrameOptions(L["Raid 2"], 'raid2', UF.CreateAndUpdateHeaderGroup)
	GroupUnits.args.raid = Raid2
	Raid2.order = 4
	Raid2.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateHeaderGroup, 'raid2')

	--* Raid3 Frame
	local Raid3 = GetSharedUnitFrameOptions(L["Raid 3"], 'raid3', UF.CreateAndUpdateHeaderGroup)
	GroupUnits.args.raid3 = Raid3
	Raid3.order = 5
	Raid3.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateHeaderGroup, 'raid3')

	--* Raid Pet Frame
	local RaidPet = ACH:Group(L["Raid Pet"], nil, 6, 'tab')
	GroupUnits.args.raidpet = RaidPet
	RaidPet.args.buffs = GetOptionsTable_Auras('buffs', E.UpdateCooldownSettings, 'raidpet')
	RaidPet.args.debuffs = GetOptionsTable_Auras('debuffs', E.UpdateCooldownSettings, 'raidpet')

	--* Tank Frame
	local Tank = GetSharedUnitFrameOptions(L["Tank"], 'tank', UF.CreateAndUpdateHeaderGroup)
	GroupUnits.args.tank = Tank
	Tank.order = 7
	Tank.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateHeaderGroup, 'tank')

	--* Assist Frame
	local Assist = GetSharedUnitFrameOptions(L["Assist"], 'assist', UF.CreateAndUpdateHeaderGroup)
	GroupUnits.args.assist = Assist
	Assist.order = 8
	Assist.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateHeaderGroup, 'assist')

	--* Arena Frame
	local Arena = GetSharedUnitFrameOptions(L["Arena"], 'arena', UF.CreateAndUpdateUFGroup, 5)
	GroupUnits.args.arena = Arena
	Arena.order = 9
	Arena.args.offlineIndicator = GetOptionsTable_OfflineIndicator(UF.CreateAndUpdateUFGroup, 'arena', 5)

	--* Boss Frame
	local Boss = ACH:Group(L["Boss"], nil, 10, 'tab')
	GroupUnits.args.boss = Boss
	Boss.args.buffs = GetOptionsTable_Auras('buffs', E.UpdateCooldownSettings, 'boss')
	Boss.args.debuffs = GetOptionsTable_Auras('debuffs', E.UpdateCooldownSettings, 'boss')

	-- 				party = {
	-- 					order = 1,
	-- 					type = 'group',
	-- 					name = L["Party Frames"],
	-- 					args = {
	-- 						configureToggle = {
	-- 							order = -10,
	-- 							type = 'execute',
	-- 							name = L["Display Frames"],
	-- 							func = function()
	-- 								UF:HeaderConfig(_G.ElvUF_Party, _G.ElvUF_Party.forceShow ~= true or nil)
	-- 							end,
	-- 						},
	-- 					},
	-- 				},
	-- 				raid = {
	-- 					order = 2,
	-- 					type = 'group',
	-- 					name = L["Raid Frames"],
	-- 					args = {
	-- 						configureToggle = {
	-- 							order = -10,
	-- 							type = 'execute',
	-- 							name = L["Display Frames"],
	-- 							func = function()
	-- 								UF:HeaderConfig(_G.ElvUF_Raid, _G.ElvUF_Raid.forceShow ~= true or nil)
	-- 							end,
	-- 						},
	-- 					},
	-- 				},
end

tinsert(SLE.Configs, configTable)
