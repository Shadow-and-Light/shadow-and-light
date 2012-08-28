local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BG = E:GetModule('BackGrounds')

--Options for additional background frames. Main group
E.Options.args.sle.args.backgrounds = {
	type = "group",
	name = L["Backgrounds"],
	order = 9,
	childGroups = "select",
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
		bottom_enabled = {
			order = 3,
			type = "toggle",
			name = L["Bottom BG"],
			desc = L["Show/Hide this frame."],
			get = function(info) return E.db.sle.backgrounds.bottom.enabled end,
			set = function(info, value) E.db.sle.backgrounds.bottom.enabled = value; BG:FramesVisibility() end
		},
		left_enabled = {
			order = 4,
			type = "toggle",
			name = L["Left BG"],
			desc = L["Show/Hide this frame."],
			get = function(info) return E.db.sle.backgrounds.left.enabled end,
			set = function(info, value) E.db.sle.backgrounds.left.enabled = value; BG:FramesVisibility() end
		},
		spacer = {
			order = 5,
			type = "description",
			name = "",
		},
		right_enabled = {
			order = 6,
			type = "toggle",
			name = L["Right BG"],
			desc = L["Show/Hide this frame."],
			get = function(info) return E.db.sle.backgrounds.right.enabled end,
			set = function(info, value) E.db.sle.backgrounds.right.enabled = value; BG:FramesVisibility() end
		},
		action_enabled = {
			order = 7,
			type = "toggle",
			name = L["Actionbar BG"],
			desc = L["Show/Hide this frame."],
			get = function(info) return E.db.sle.backgrounds.action.enabled end,
			set = function(info, value) E.db.sle.backgrounds.action.enabled = value; BG:FramesVisibility() end
		},
	}
}
--Subgroup for 1st frame. They are based on the same pattern
E.Options.args.sle.args.backgrounds.args.bottom = {
	type = "group",
	name = L["Bottom BG"],
	order = 1,
	disabled = function() return not E.db.sle.backgrounds.bottom.enabled end,
	args = {
		width = { --setting width (obviously)
			order = 3,
			type = "range",
			name = L['Width'],
			desc = L["Sets width of the frame"],
			min = 200, max = E.screenwidth, step = 1,
			get = function(info) return E.db.sle.backgrounds.bottom.width end,
			set = function(info, value) E.db.sle.backgrounds.bottom.width = value; BG:FramesSize() end,
		},
		height = {
			order = 4,
			type = "range",
			name = L['Height'],
			desc = L["Sets height of the frame"],
			min = 50, max = E.screenheight/2, step = 1,
			get = function(info) return E.db.sle.backgrounds.bottom.height end,
			set = function(info, value) E.db.sle.backgrounds.bottom.height = value; BG:FramesSize() end,
		},
		spacer = { --Empty slot for making sliders move to next line
			order = 5,
			type = "description",
			name = "",
		},
		--Main means of moving frames. To create actual mover for them is veeeeeeeeeeery crapy idea.
		xoffset = {
			order = 6,
			type = "range",
			name = L['X Offset'],
			desc = L["Sets X offset of the frame"],
			min = -E.screenwidth/2, max = E.screenwidth/2, step = 1,
			get = function(info) return E.db.sle.backgrounds.bottom.xoffset end,
			set = function(info, value) E.db.sle.backgrounds.bottom.xoffset = value; BG:FramesPositions() end,
		},
		yoffset = {
			order = 7,
			type = "range",
			name = L['Y Offset'],
			desc = L["Sets Y offset of the frame"],
			min = -21, max = E.screenheight, step = 1,
			get = function(info) return E.db.sle.backgrounds.bottom.yoffset end,
			set = function(info, value) E.db.sle.backgrounds.bottom.yoffset = value; BG:FramesPositions() end,
		},
		--Setting custom texture for those who like it
		texture = {
			order = 8,
			type = 'input',
			width = 'full',
			name = L["Texture"],
			desc = L["Set the texture to use in this frame.  Requirements are the same as the chat textures."],
			get = function(info) return E.db.sle.backgrounds.bottom.texture end,
			set = function(info, value) 
				E.db.sle.backgrounds.bottom.texture = value
				E:UpdateMedia()
				BG:UpdateTex()
			end,
		},
		template = {
			order = 9,
			type = "select",
			name = L["Backdrop Template"],
			desc = L["Change the template used for this backdrop."],
			get = function(info) return E.private.sle.backgrounds.bottom.template end,
			set = function(info, value) E.private.sle.backgrounds.bottom.template = value; E:StaticPopup_Show("PRIVATE_RL") end,
			values = {
				['Default'] = L["Default"],
				['Transparent'] = L["Transparent"],
			},
		},
	},
}
--Subgroup for 2nd frame
E.Options.args.sle.args.backgrounds.args.left = {
	order = 2,
	type = "group",
	name = L["Left BG"],
	disabled = function() return not E.db.sle.backgrounds.left.enabled end,
	args = {
		width = {
			order = 3,
			type = "range",
			name = L['Width'],
			desc = L["Sets width of the frame"],
			min = 150, max = E.screenwidth, step = 1,
			get = function(info) return E.db.sle.backgrounds.left.width end,
			set = function(info, value) E.db.sle.backgrounds.left.width = value; BG:FramesSize() end,
		},
		height = {
			order = 4,
			type = "range",
			name = L['Height'],
			desc = L["Sets height of the frame"],
			min = 50, max = E.screenheight/2, step = 1,
			get = function(info) return E.db.sle.backgrounds.left.height end,
			set = function(info, value) E.db.sle.backgrounds.left.height = value; BG:FramesSize() end,
		},
		spacer = {
			order = 5,
			type = "description",
			name = "",
		},
		xoffset = {
			order = 6,
			type = "range",
			name = L['X Offset'],
			desc = L["Sets X offset of the frame"],
			min = -E.screenwidth/2, max = E.screenwidth/2, step = 1,
			get = function(info) return E.db.sle.backgrounds.left.xoffset end,
			set = function(info, value) E.db.sle.backgrounds.left.xoffset = value; BG:FramesPositions() end,
		},
		yoffset = {
			order = 7,
			type = "range",
			name = L['Y Offset'],
			desc = L["Sets Y offset of the frame"],
			min = -21, max = E.screenheight, step = 1,
			get = function(info) return E.db.sle.backgrounds.left.yoffset end,
			set = function(info, value) E.db.sle.backgrounds.left.yoffset = value; BG:FramesPositions() end,
		},
		texture = {
			order = 8,
			type = 'input',
			width = 'full',
			name = L["Texture"],
			desc = L["Set the texture to use in this frame.  Requirements are the same as the chat textures."],
			get = function(info) return E.db.sle.backgrounds.left.texture end,
			set = function(info, value) 
				E.db.sle.backgrounds.left.texture = value
				E:UpdateMedia()
				BG:UpdateTex()
			end,
		},
		template = {
			order = 9,
			type = "select",
			name = L["Backdrop Template"],
			desc = L["Change the template used for this backdrop."],
			get = function(info) return E.private.sle.backgrounds.left.template end,
			set = function(info, value) E.private.sle.backgrounds.left.template = value; E:StaticPopup_Show("PRIVATE_RL") end,
			values = {
				['Default'] = L["Default"],
				['Transparent'] = L["Transparent"],
			},
		},
	},
}
--Subgroup for 3rd frame
E.Options.args.sle.args.backgrounds.args.right = {
	order = 2,
	type = "group",
	name = L["Right BG"],
	disabled = function() return not E.db.sle.backgrounds.right.enabled end,
	args = {
		width = {
			order = 3,
			type = "range",
			name = L['Width'],
			desc = L["Sets width of the frame"],
			min = 150, max = E.screenwidth, step = 1,
			get = function(info) return E.db.sle.backgrounds.right.width end,
			set = function(info, value) E.db.sle.backgrounds.right.width = value; BG:FramesSize() end,
		},
		height = {
			order = 4,
			type = "range",
			name = L['Height'],
			desc = L["Sets height of the frame"],
			min = 50, max = E.screenheight/2, step = 1,
			get = function(info) return E.db.sle.backgrounds.right.height end,
			set = function(info, value) E.db.sle.backgrounds.right.height = value; BG:FramesSize() end,
		},
		spacer = {
			order = 5,
			type = "description",
			name = "",
		},
		xoffset = {
			order = 6,
			type = "range",
			name = L['X Offset'],
			desc = L["Sets X offset of the frame"],
			min = -E.screenwidth/2, max = E.screenwidth/2, step = 1,
			get = function(info) return E.db.sle.backgrounds.right.xoffset end,
			set = function(info, value) E.db.sle.backgrounds.right.xoffset = value; BG:FramesPositions() end,
		},
		yoffset = {
			order = 7,
			type = "range",
			name = L['Y Offset'],
			desc = L["Sets Y offset of the frame"],
			min = -21, max = E.screenheight, step = 1,
			get = function(info) return E.db.sle.backgrounds.right.yoffset end,
			set = function(info, value) E.db.sle.backgrounds.right.yoffset = value; BG:FramesPositions() end,
		},
		texture = {
			order = 8,
			type = 'input',
			width = 'full',
			name = L["Texture"],
			desc = L["Set the texture to use in this frame.  Requirements are the same as the chat textures."],
			get = function(info) return E.db.sle.backgrounds.right.texture end,
			set = function(info, value) 
				E.db.sle.backgrounds.right.texture = value
				E:UpdateMedia()
				BG:UpdateTex()
			end,
		},
		template = {
			order = 9,
			type = "select",
			name = L["Backdrop Template"],
			desc = L["Change the template used for this backdrop."],
			get = function(info) return E.private.sle.backgrounds.right.template end,
			set = function(info, value) E.private.sle.backgrounds.right.template = value; E:StaticPopup_Show("PRIVATE_RL") end,
			values = {
				['Default'] = L["Default"],
				['Transparent'] = L["Transparent"],
			},
		},
	},
}
--Subgroup for 4th frame
E.Options.args.sle.args.backgrounds.args.action = {
	order = 4,
	type = "group",
	name = L["Actionbar BG"],
	disabled = function() return not E.db.sle.backgrounds.action.enabled end,
	args = {
		width = {
			order = 3,
			type = "range",
			name = L['Width'],
			desc = L["Sets width of the frame"],
			min = 200, max = E.screenwidth, step = 1,
			get = function(info) return E.db.sle.backgrounds.action.width end,
			set = function(info, value) E.db.sle.backgrounds.action.width = value; BG:FramesSize() end,
		},
		height = {
			order = 4,
			type = "range",
			name = L['Height'],
			desc = L["Sets height of the frame"],
			min = 50, max = E.screenheight/2, step = 1,
			get = function(info) return E.db.sle.backgrounds.action.height end,
			set = function(info, value) E.db.sle.backgrounds.action.height = value; BG:FramesSize() end,
		},
		spacer = {
			order = 5,
			type = "description",
			name = "",
		},
		xoffset = {
			order = 6,
			type = "range",
			name = L['X Offset'],
			desc = L["Sets X offset of the frame"],
			min = -E.screenwidth/2, max = E.screenwidth/2, step = 1,
			get = function(info) return E.db.sle.backgrounds.action.xoffset end,
			set = function(info, value) E.db.sle.backgrounds.action.xoffset = value; BG:FramesPositions() end,
		},
		yoffset = {
			order = 7,
			type = "range",
			name = L['Y Offset'],
			desc = L["Sets Y offset of the frame"],
			min = -21, max = E.screenheight, step = 1,
			get = function(info) return E.db.sle.backgrounds.action.yoffset end,
			set = function(info, value) E.db.sle.backgrounds.action.yoffset = value; BG:FramesPositions() end,
		},
		texture = {
			order = 8,
			type = 'input',
			width = 'full',
			name = L["Texture"],
			desc = L["Set the texture to use in this frame.  Requirements are the same as the chat textures."],
			get = function(info) return E.db.sle.backgrounds.action.texture end,
			set = function(info, value) 
				E.db.sle.backgrounds.action.texture = value
				E:UpdateMedia()
				BG:UpdateTex()
			end,
		},
		template = {
			order = 9,
			type = "select",
			name = L["Backdrop Template"],
			desc = L["Change the template used for this backdrop."],
			get = function(info) return E.private.sle.backgrounds.action.template end,
			set = function(info, value) E.private.sle.backgrounds.action.template = value; E:StaticPopup_Show("PRIVATE_RL") end,
			values = {
				['Default'] = L["Default"],
				['Transparent'] = L["Transparent"],
			},
		},
	},
}

