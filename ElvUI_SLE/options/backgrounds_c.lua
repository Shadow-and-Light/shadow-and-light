local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local BG = SLE:GetModule('Backgrounds')

local function configTable()
	if not SLE.initialized then return end
	local function CreateEnable(i)
		local config = {
			order = i+5,
			type = "toggle",
			name = L["SLE_BG_"..i],
			desc = L["Show/Hide this frame."],
			get = function(info) return E.db.sle.backgrounds["bg"..i].enabled end,
			set = function(info, value) E.db.sle.backgrounds["bg"..i].enabled = value; BG:FramesVisibility(i) end
		}
		return config
	end

	local function CreateGroup(i)
		local config = {
			type = "group",
			name = L["SLE_BG_"..i],
			order = i,
			get = function(info) return E.db.sle.backgrounds["bg"..i][ info[#info] ] end,
			disabled = function() return not E.db.sle.backgrounds["bg"..i].enabled end, --or not E.private.sle.backgrounds end,
			args = {
				width = {
					order = 1,
					type = "range",
					name = L["Width"],
					desc = L["Sets width of the frame"],
					min = 50, max = E.screenwidth, step = 1,
					set = function(info, value) E.db.sle.backgrounds["bg"..i].width = value; BG:FramesSize(i) end,
				},
				height = {
					order = 2,
					type = "range",
					name = L["Height"],
					desc = L["Sets height of the frame"],
					min = 30, max = E.screenheight/2, step = 1,
					set = function(info, value) E.db.sle.backgrounds["bg"..i].height = value; BG:FramesSize(i) end,
				},
				spacer = {
					order = 3,
					type = "description",
					name = "",
				},
				texture = {
					order = 6,
					type = 'input',
					width = 'full',
					name = L["Texture"],
					desc = L["Set the texture to use in this frame. Requirements are the same as the chat textures."],
					set = function(info, value) 
						E.db.sle.backgrounds["bg"..i].texture = value
						E:UpdateMedia()
						BG:UpdateTexture(i)
					end,
				},
				template = {
					order = 7,
					type = "select",
					name = L["Backdrop Template"],
					desc = L["Change the template used for this backdrop."],
					get = function(info) return E.db.sle.backgrounds["bg"..i].template end,
					set = function(info, value) E.db.sle.backgrounds["bg"..i].template = value; BG:FrameTemplate(i) end,
					values = {
						["Default"] = DEFAULT,
						["Transparent"] = L["Transparent"],
					},
				},
				pethide = {
					order = 8,
					type = "toggle",
					name = L["Hide in Pet Batlle"],
					desc = L["Show/Hide this frame during Pet Battles."],
					set = function(info, value) E.db.sle.backgrounds["bg"..i].pethide = value; BG:RegisterHide(i) end
				},
				clickthrough = {
					order = 9,
					type = "toggle",
					name = L["Click Through"],
					set = function(info, value) E.db.sle.backgrounds["bg"..i].clickthrough = value; BG:MouseCatching(i) end
				},
				alpha = {
					order = 12,
					type = 'range',
					name = L["Alpha"],
					isPercent = true,
					min = 0, max = 1, step = 0.01,
					get = function(info) return E.db.sle.backgrounds["bg"..i].alpha end,
					set = function(info, value) E.db.sle.backgrounds["bg"..i].alpha = value; BG:Alpha(i) end,
				},
			},
		}
		return config
	end

	E.Options.args.sle.args.modules.args.backgrounds = {
		type = "group",
		name = L["Backgrounds"],
		order = 5,
		childGroups = 'select',
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Additional Background Panels"],
			},
			intro = {
				order = 2,
				type = "description",
				name = L["BG_DESC"]
			},
			-- Reset = {
				-- order = 4,
				-- type = 'execute',
				-- name = L["Restore Defaults"],
				-- desc = L["Reset these options to defaults"],
				-- func = function() E:GetModule('SLE'):Reset("backgrounds") end,
			-- },
			spacerreset = {
				order = 5,
				type = 'description',
				name = "",
			},
			bg1 = CreateEnable(1),
			bg2 = CreateEnable(2),
			spacer = {
				order = 8,
				type = "description",
				name = "",
			},
			bg3 = CreateEnable(3),
			bg4 = CreateEnable(4),
			bg1gr = CreateGroup(1),
			bg2gr = CreateGroup(2),
			bg3gr = CreateGroup(3),
			bg4gr = CreateGroup(4),
		},
	}

end

T.tinsert(SLE.Configs, configTable)