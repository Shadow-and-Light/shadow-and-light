local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local BI = SLE.BagInfo
local B = E.Bags

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.bags = {
		type = 'group',
		order = 1,
		name = L["Bags"],
		args = {
			equipmentmanager = {
				order = 1,
				type = 'group',
				name = L["Equipment Manager"],
				guiInline = true,
				get = function(info) return E.db.sle.bags.equipmentmanager[info[#info]] end,
				-- set = function(info, value) E.db.sle.bags.equipmentmanager[info[#info]] = value; BI:UpdateBagSettings() end,
				set = function(info, value)
					E.db.sle.bags.equipmentmanager[info[#info]] = value
					-- B:UpdateLayouts()
					-- B:UpdateAllBagSlots()
					BI:UpdateItemDisplay()
				end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Enables an indicator on equipment icons located in your bags to show if they are part of an equipment set."],
						set = function(info, value)
							E.db.sle.bags.equipmentmanager[info[#info]] = value
							-- BI:ToggleSettings()
							B:UpdateLayouts()
							B:UpdateAllBagSlots(true)
						end,
					},
					size = {
						order = 2,
						type = 'range',
						name = L["Size"],
						min = 8, max = 64, step = 1,
					},
					point = {
						order = 3,
						type = 'select',
						name = L["Anchor Point"],
						values = T.Values.positionValues,
					},
					xOffset = {
						order = 4,
						type = 'range',
						name = L["X-Offset"],
						min = -64, max = 64, step = 1,
					},
					yOffset = {
						order = 5,
						type = 'range',
						name = L["Y-Offset"],
						min = -64, max = 64, step = 1,
					},
					icon = {
						order = 6,
						type = 'select',
						name = L["Icon"],
						values = function() return BI.equipmentmanager.icons end,
					},
					customTexture = {
						order = 7,
						type = 'input',
						name = L["Custom Texture"],
						desc = L["You can use a file id or path.\nFile id as an example.\niconFileID: 3547163\n\nAlready an option but showing as a path example.\nPath: Interface\\AddOns\\ElvUI_SLE\\media\\textures\\lock"],
						width = 'double',
						hidden = function() return E.db.sle.bags.equipmentmanager.icon ~= 'CUSTOM' end
					},
					color = {
						order = 8,
						type = 'color',
						name = COLOR,
						hasAlpha = true,
						get = function(info)
							local t = E.db.sle.bags.equipmentmanager[info[#info]]
							local d = P.sle.bags.equipmentmanager[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							local t = E.db.sle.bags.equipmentmanager[info[#info]]
							t.r, t.g, t.b, t.a = r, g, b, a
							-- B:UpdateLayouts()
							-- B:UpdateAllBagSlots()
							BI:UpdateItemDisplay()
						end,
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
