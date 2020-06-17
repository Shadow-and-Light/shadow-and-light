local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local MM = SLE:GetModule("Minimap")

local MINIMAP_LABEL = MINIMAP_LABEL

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.minimap = {
		type = "group",
		name = MINIMAP_LABEL,
		order = 1,
		childGroups = 'tab',
		args = {
			header = ACH:Header(L["Minimap Options"], 1),
			desc = ACH:Description(L["MINIMAP_DESC"], 2),
			combat = {
				type = "toggle",
				name = L["Hide In Combat"],
				order = 3,
				desc = L["Hide minimap in combat."],
				disabled = false,
				get = function(info) return E.db.sle.minimap.combat end,
				set = function(info, value) E.db.sle.minimap.combat = value; MM:HideMinimapRegister() end,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)