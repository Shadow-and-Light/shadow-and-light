local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SA = SLE.Armory_Stats
local M = E.Misc

local _G = _G
local STAT_CATEGORY_ATTRIBUTES = STAT_CATEGORY_ATTRIBUTES

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.armory = {
		type = 'group',
		name = L["Armory Mode"],
		order = 1,
		childGroups = 'tab',
		-- hidden = function() return not E.private.skins.blizzard.enable end,
		args = {
			desc = ACH:Description(L["SLE_Armory_Info"]..'\n', 1, nil, nil, nil, nil, nil, nil,  function() return not E.private.skins.blizzard.enable or (not E.private.skins.blizzard.character and not E.private.skins.blizzard.inspect) end),
			CA_enable = {
				type = 'toggle',
				name = L["Character Armory"],
				order = 10,
				desc = '',
				hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
				get = function() return E.db.sle.armory.character.enable end,
				set = function(_, value)
					E.db.sle.armory.character.enable = value
					E:StaticPopup_Show('PRIVATE_RL')
				end,
			},
			IA_enable = {
				type = 'toggle',
				name = L["Inspect Armory"],
				order = 11,
				desc = '',
				hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect end,
				get = function() return E.db.sle.armory.inspect.enable end,
				set = function(_, value)
					E.db.sle.armory.inspect.enable = value
					E:StaticPopup_Show('PRIVATE_RL')
				end,
			},
			SA_enable = {
				type = 'toggle',
				name = STAT_CATEGORY_ATTRIBUTES,
				order = 12,
				desc = '',
				hidden = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
				disabled = function() return (SLE._Compatibility['DejaCharacterStats'] or not E.private.skins.blizzard.enable) end,
				get = function() return E.private.sle.armory.stats.enable end,
				set = function(_, value) E.private.sle.armory.stats.enable = value E:StaticPopup_Show('PRIVATE_RL') end
			},
			GoToElv = {
				order = 100,
				type = 'execute',
				name = 'ElvUI: '..L["Item Level"],
				func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'general', 'blizzUIImprovements') end,
				hidden = function()
					if not E.private.skins.blizzard.enable then return true end
					return not (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect)
				end,
			},
			--In case some fucker disabled all the skins
			SkinsDisabled = ACH:Description('|cffff0000 !!!|r '..L["SLE_Armory_SkinDisabled"]..' |cffff0000 !!!|r', 500, 'medium', nil, nil, nil, nil, nil, function() if not E.private.skins.blizzard.enable then return false end return (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect) end),
			GoToElv_Skins = {
				order = 501,
				type = 'execute',
				name = 'ElvUI: '..L["Skins"],
				func = function() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'skins') end,
				hidden = function()
					if not E.private.skins.blizzard.enable then return false end
					return (E.private.skins.blizzard.character or E.private.skins.blizzard.inspect)
				end,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
