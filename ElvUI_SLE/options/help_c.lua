local E, L, V, P, G =  unpack(ElvUI);
local SLE = E:GetModule('SLE')

local function configTable()
	--Main options group
	E.Options.args.sle.args.links = {
		type = 'group',
		name = 'About/Help',
		order = -2,
		args = {
			desc = {
				order = 1,
				type = 'description',
				fontSize = 'medium',
				name = 'Da LinkZ!!!!',
			},
			tukuilink = {
				type = 'input',
				width = 'full',
				name = 'On TukUI.org',
				get = function(info) return 'http://www.tukui.org/addons/index.php?act=view&id=42' end,
				order = 2,
			},
			wowilink = {
				type = 'input',
				width = 'full',
				name = 'On WoWI',
				get = function(info) return 'http://www.wowinterface.com/downloads/info20927-ElvUIShadowLight.html' end,
				order = 3,
			},
			curselink= {
				type = 'input',
				width = 'full',
				name = 'On Curse',
				get = function(info) return 'http://www.curse.com/addons/wow/shadow-and-light-edit' end,
				order = 4,
			},
			gitlablink = {
				type = 'input',
				width = 'full',
				name = 'GitLab Link / Report Errors',
				get = function(info) return 'http://git.tukui.org/repooc/elvui-shadowandlight' end,
				order = 5,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)