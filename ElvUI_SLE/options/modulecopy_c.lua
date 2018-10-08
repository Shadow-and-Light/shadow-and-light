local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local CP
local function CreateActionbars()
	local config = CP:CreateModuleConfigGroup(L["ActionBars"], "actionbars", "sle")

	return config
end
local function CreateAuras()
	local config = CP:CreateModuleConfigGroup(L["Auras"], "auras", "sle")

	return config
end
local function CreateBackgrounds()
	local config = CP:CreateModuleConfigGroup(L["Backgrounds"], "backgrounds", "sle")
	for i = 1, 4 do
		config.args["bg"..i] = {
			order = 1+i,
			type = "toggle",
			name = L["SLE_BG_"..i],
			get = function(info) return E.global.profileCopy.sle.backgrounds[ info[#info] ] end,
			set = function(info, value) E.global.profileCopy.backgrounds[ info[#info] ] = value; end
		}
	end

	return config
end
local function CreateBags()
	local config = CP:CreateModuleConfigGroup(L["Bags"], "bags", "sle")
	config.args.petLevel = {
		order = 2,
		type = "toggle",
		name = AUCTION_CATEGORY_BATTLE_PETS,
		get = function(info) return E.global.profileCopy.sle.bags[ info[#info] ] end,
		set = function(info, value) E.global.profileCopy.sle.bags[ info[#info] ] = value; end
	}

	return config
end

local function configTable()
	if not E.Options.args.modulecontrol then return end
	CP = E:GetModule('CopyProfile')
	E.Options.args.modulecontrol.args.modulecopy.args.sle = {
		order = 11,
		type = 'group',
		name = SLE.Title,
		childGroups = "tab",
		disabled = E.Options.args.profiles.args.copyfrom.disabled,
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["|cff9482c9Shadow & Light|r options"],
			},
			actionbar = CreateActionbars(),
			auras = CreateAuras(),
			backgrounds = CreateBackgrounds(),
			bags = CreateBags(),
			-- chat = CP:CreateModuleConfigGroup(L["Chat"], "chat"),
			-- cooldown = CP:CreateModuleConfigGroup(L["Cooldown Text"], "cooldown"),
			-- databars = CP:CreateModuleConfigGroup(L["DataBars"], "databars"),
			-- datatexts = CP:CreateModuleConfigGroup(L["DataTexts"], "datatexts"),
			-- nameplates = CP:CreateModuleConfigGroup(L["NamePlates"], "nameplates"),
			-- tooltip = CP:CreateModuleConfigGroup(L["Tooltip"], "tooltip"),
			-- uniframes = CP:CreateModuleConfigGroup(L["UnitFrames"], "uniframes"),
		},
	}
end

T.tinsert(SLE.Configs, configTable)