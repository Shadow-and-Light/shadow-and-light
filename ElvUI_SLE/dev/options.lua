local E, L, V, P, G, _ = unpack(ElvUI);
local SLE = E:GetModule('SLE');

if SLE:CheckFlag(nil, 'SLEAUTHOR') then
	local function configTable()
		E.Options.args.sle.args.developer = {
			order = 999,
			type = 'group',
			name = "Developer",
			args = {
				header = {
					order = 1,
					type = "header",
					name = "Developer Header",
				},
				userlist = {
					order = 2,
					type = "group",
					name = "User List",
					args = {
						subgroup = {
							order = 1,
							type = "header",
							name = "User List",
						},
					},
				},
				devgroupone = {
					order = 3,
					type = "group",
					name = "Test Group",
					args = {
						subgroup = {
							order = 1,
							type = "header",
							name = "Sub Group 2",
						},
					},
				},
			},
		}
	end

	table.insert(E.SLEConfigs, configTable)
end