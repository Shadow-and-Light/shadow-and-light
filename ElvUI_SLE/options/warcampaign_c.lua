local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local WAR_CAMPAIGN = WAR_CAMPAIGN

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.warcampaign = {
		type = 'group',
		name = WAR_CAMPAIGN,
		order = 1,
		args = {
			header = E.Libs.ACH:Header(WAR_CAMPAIGN, 1),
			autoOrder = {
				order = 2,
				type = 'group',
				name = L["Auto Work Orders"],
				guiInline = true,
				get = function(info) return E.db.sle.legacy.warwampaign.autoOrder[info[#info]] end,
				set = function(info, value) E.db.sle.legacy.warwampaign.autoOrder[info[#info]] = value end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Automatically queue maximum number of work orders available when visiting respected NPC."],
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
