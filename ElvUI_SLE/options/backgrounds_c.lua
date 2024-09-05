local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local BG = SLE.Backgrounds

local ceil = ceil
local tinsert = tinsert
local DEFAULT = DEFAULT

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	local function CreateEnable(i)
		local config = {
			order = i+5,
			type = "toggle",
			name = L["SLE_BG_"..i],
			desc = L["Show/Hide this frame."],
			get = function() return E.db.sle.backgrounds["bg"..i].enabled end,
			set = function(_, value) E.db.sle.backgrounds["bg"..i].enabled = value; BG:FramesVisibility(i) end
		}
		return config
	end

	local screenWidth = ceil(E.screenWidth)
	local screenHeight = ceil(E.screenHeight)
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
					min = 50, max = screenWidth, step = 1,
					set = function(_, value) E.db.sle.backgrounds["bg"..i].width = value; BG:FramesSize(i) end,
				},
				height = {
					order = 2,
					type = "range",
					name = L["Height"],
					desc = L["Sets height of the frame"],
					min = 20, max = screenHeight, step = 1,
					set = function(_, value) E.db.sle.backgrounds["bg"..i].height = value; BG:FramesSize(i) end,
				},
				spacer = ACH:Spacer(3),
				texture = {
					order = 6,
					type = 'input',
					width = 'full',
					name = L["Texture"],
					desc = L["Set the texture to use in this frame. Requirements are the same as the chat textures."],
					set = function(_, value)
						E.db.sle.backgrounds["bg"..i].texture = value
						E:UpdateMedia()
						BG:UpdateTexture(i)
					end,
				},
				template = {
					order = 7,
					type = "select",
					name = L["Backdrop Template"],
					get = function() return E.db.sle.backgrounds["bg"..i].template end,
					set = function(_, value) E.db.sle.backgrounds["bg"..i].template = value; BG:FrameTemplate(i) end,
					values = {
						["Default"] = DEFAULT,
						["Transparent"] = L["Transparent"],
					},
				},
				pethide = {
					order = 8,
					type = "toggle",
					name = L["Hide in Pet Battle"],
					desc = L["Show/Hide this frame during Pet Battles."],
					set = function(_, value) E.db.sle.backgrounds["bg"..i].pethide = value; BG:RegisterHide(i) end
				},
				clickthrough = {
					order = 9,
					type = "toggle",
					name = L["Click Through"],
					set = function(_, value) E.db.sle.backgrounds["bg"..i].clickthrough = value; BG:MouseCatching(i) end
				},
				alpha = {
					order = 12,
					type = 'range',
					name = L["Alpha"],
					isPercent = true,
					min = 0, max = 1, step = 0.01,
					get = function() return E.db.sle.backgrounds["bg"..i].alpha end,
					set = function(_, value) E.db.sle.backgrounds["bg"..i].alpha = value; BG:Alpha(i) end,
				},
				visibility = {
					order = 13,
					type = 'input',
					width = 'full',
					name = L["Visibility State"],
					get = function() return E.db.sle.backgrounds["bg"..i].visibility end,
					set = function(_, value) E.db.sle.backgrounds["bg"..i].visibility = value; BG:FramesVisibility(i) end,
				},
			},
		}
		return config
	end

	E.Options.args.sle.args.modules.args.backgrounds = {
		type = "group",
		name = L["Backgrounds"],
		order = 1,
		childGroups = 'tab',
		args = {
			header = ACH:Header(L["Additional Background Panels"], 1),
			intro = ACH:Description(L["BG_DESC"], 2),
			-- Reset = {
				-- order = 4,
				-- type = 'execute',
				-- name = L["Restore Defaults"],
				-- func = function() E.SLE:Reset("backgrounds") end,
			-- },
			spacer1 = ACH:Spacer(5),
			bg1 = CreateEnable(1),
			bg2 = CreateEnable(2),
			spacer2 = ACH:Spacer(8),
			bg3 = CreateEnable(3),
			bg4 = CreateEnable(4),
			bg1gr = CreateGroup(1),
			bg2gr = CreateGroup(2),
			bg3gr = CreateGroup(3),
			bg4gr = CreateGroup(4),
		},
	}
end

tinsert(SLE.Configs, configTable)
