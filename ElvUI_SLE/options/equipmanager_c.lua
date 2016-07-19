local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local EM = SLE:GetModule('EquipManager')
local NONE = NONE
local PAPERDOLL_EQUIPMENTMANAGER = PAPERDOLL_EQUIPMENTMANAGER
local SPECIALIZATION_PRIMARY = SPECIALIZATION_PRIMARY
local SPECIALIZATION_SECONDARY = SPECIALIZATION_SECONDARY
local PVP = PVP
local DUNGEONS = DUNGEONS

local sets = {}

local function FillTable()
	sets = {}
	sets["NONE"] = NONE
	for i = 1, T.GetNumEquipmentSets() do
		local name, icon, lessIndex = T.GetEquipmentSetInfo(i)
		if name then
			sets[name] = name
		end
	end
	return sets
end

local function configTable()
	if not SLE.initialized then return end
	
	local function ConstructSpecOption(ORDER, ID, OPTION)
		local SpecID, SpecName = GetSpecializationInfo(ID)
		if not SpecID then return nil end
		local config = {
			order = ORDER,
			type = "group",
			guiInline = true,
			name = SpecName,
			get = function(info) return EM.db[OPTION][ info[#info] ] end,
			set = function(info, value) EM.db[OPTION][ info[#info] ] = value; end,
			args = {
				infoz = {
					order = 1,
					type = "description",
					name =  T.format(L["Equip this set when switching to specialization %s."], SpecName),
				},
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
				pvp = {
					order = 4,
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
		order = 9,
		name = L["Equipment Manager"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Equipment Manager"],
			},
			intro = {
				order = 2,
				type = 'description',
				name = L["EM_DESC"],
			},
			enable = {
				type = "toggle",
				order = 3,
				name = L["Enable"],
				get = function(info) return EM.db.enable end,
				set = function(info, value) EM.db.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
			},
			setoverlay = {
				type = "toggle",
				order = 5,
				name = L["Equipment Set Overlay"],	
				desc = L["Show the associated equipment sets for the items in your bags (or bank)."],
				disabled = function() return not E.private.bags.enable end,
				get = function(info) return EM.db.setoverlay end,
				set = function(info, value) EM.db.setoverlay = value; SLE:GetModule('BagInfo'):ToggleSettings(); end,
			},
			spacer = {
				order = 6,
				type = "description",
				name = "",
			},
			instanceSet = {
				type = "toggle",
				order = 7,
				name = L["Use Instanse Set"],
				desc = L["Use a dedicated set for instances and raids."],
				disabled = function() return not EM.db.enable end,
				get = function(info) return EM.db.instanceSet end,
				set = function(info, value) EM.db.instanceSet = value; end
			},
			pvpSet = {
				type = "toggle",
				order = 8,
				name = L["Use PvP Set"],
				desc = L["Use a dedicated set for PvP situations."],
				disabled = function() return not EM.db.enable end,
				get = function(info) return EM.db.pvpSet end,
				set = function(info, value) EM.db.pvpSet = value; end
			},
			equipsets = {
				type = "group",
				name = PAPERDOLL_EQUIPMENTMANAGER,
				order = 9,
				disabled = function() return not EM.db.enable end,
				guiInline = true,
				args = {
					intro = {
						order = 1,
						type = 'description',
						name = L["Here you can choose what equipment sets to use in different situations."],
					},
					firstSpec = ConstructSpecOption(1, 1, "firstSpec"),
					secondSpec = ConstructSpecOption(2, 2, "secondSpec"),
					thirdSpec = ConstructSpecOption(3, 3, "thirdSpec"),
					forthSpec = ConstructSpecOption(4, 4, "forthSpec"),
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)