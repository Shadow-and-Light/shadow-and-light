local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local EM = SLE.EquipManager

local format = format
local NONE = NONE
local PAPERDOLL_EQUIPMENTMANAGER = PAPERDOLL_EQUIPMENTMANAGER
local SPECIALIZATION_PRIMARY = SPECIALIZATION_PRIMARY
local SPECIALIZATION_SECONDARY = SPECIALIZATION_SECONDARY
local PVP = PVP
local DUNGEONS = DUNGEONS
local GENERAL = GENERAL
local TIMEWALKING = L["Timewalking"]

local sets = {}
local C_EquipmentSet = C_EquipmentSet

local function FillTable()

	wipe(sets)
	sets["NONE"] = NONE
	local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()
	for index = 1, C_EquipmentSet.GetNumEquipmentSets() do
		local name, icon, lessIndex = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[index])
		if name then
			sets[name] = name
		end
	end
	return sets
end

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	local function ConstructSpecOption(ORDER, ID, OPTION)
		local SpecID, SpecName = GetSpecializationInfo(ID)
		if not SpecID then return nil end
		local config = {
			order = ORDER,
			type = "group",
			guiInline = true,
			name = SpecName,
			get = function(info) return EM.db[OPTION][ info[#info] ] end,
			set = function(info, value) EM.db[OPTION][ info[#info] ] = value end,
			args = {
				info = ACH:Description(L["Equip this set when switching to specialization %s."], 1),
				general = {
					order = 2,
					type = "select",
					name = GENERAL,
					desc = L["Equip this set for open world/general use."],
					values = function()
						FillTable()
						return sets
					end,
				},
				instance = {
					order = 3,
					type = "select",
					name = DUNGEONS,
					disabled = function() return not EM.db.instanceSet end,
					desc = L["Equip this set after entering dungeons or raids."],
					values = function()
						FillTable()
						return sets
					end,
				},
				timewalking = {
					order = 4,
					type = "select",
					name = TIMEWALKING,
					disabled = function() return not EM.db.timewalkingSet end,
					desc = L["Equip this set after enetering a timewalking dungeon."],
					values = function()
						FillTable()
						return sets
					end,
				},
				pvp = {
					order = 5,
					type = "select",
					name = PVP,
					disabled = function() return not EM.db.pvpSet end,
					desc = L["Equip this set after entering battlegrounds or arens."],
					values = function()
						FillTable()
						return sets
					end,
				},
			},
		}
		return config
	end

	E.Options.args.sle.args.modules.args.equipmanager = {
		type = 'group',
		order = 1,
		name = L["Equipment Manager"],
		args = {
			header = ACH:Header(L["Equipment Manager"], 1),
			intro = ACH:Description(L["EM_DESC"], 2),
			enable = {
				type = "toggle",
				order = 3,
				name = L["Enable"],
				get = function(info) return EM.db.enable end,
				set = function(info, value) EM.db.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
			},
			lockbutton = {
				order = 6,
				type = "toggle",
				name = L["Block button"],
				desc = L["Create a button in character frame to allow temp blocking of auto set swap."],
				get = function(info) return EM.db.lockbutton end,
				set = function(info, value) EM.db.lockbutton = value; E:StaticPopup_Show("PRIVATE_RL") end
			},
			equipsets = {
				type = "group",
				name = PAPERDOLL_EQUIPMENTMANAGER,
				order = 11,
				disabled = function() return not EM.db.enable end,
				guiInline = true,
				args = {
					conditions = {
						order = 1,
						type = "input",
						width = "full",
						name = L["Equipment conditions"],
						desc = L["SLE_EM_CONDITIONS_DESC"],
						get = function(info) return EM.db.conditions end,
						set = function(info, value) EM.db.conditions = value; EM:UpdateTags() end
					},
					help = ACH:Description(L["SLE_EM_TAGS_HELP"], 2),
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
