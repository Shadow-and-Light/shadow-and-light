local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local RAID_FINDER = RAID_FINDER
local RAIDS = RAIDS
local EXPANSION_NAME3, EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6, EXPANSION_NAME7 = EXPANSION_NAME3, EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6, EXPANSION_NAME7

local function configTable()
	if not SLE.initialized then return end
	local expackNum = 5
	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.timedt = {
		type = 'group',
		name = RAID_FINDER,
		order = 1,
		args = {
			lfrshow = {
				order = 1, type = 'toggle',
				name = L["LFR Lockout"],
				desc = L["Show/Hide LFR lockout info in time datatext's tooltip."],
				get = function(info) return E.db.sle.lfr.enabled end,
				set = function(info, value) E.db.sle.lfr.enabled = value end,
			},
			raids = {
				order = 2, type = 'group',
				name = RAIDS,
				guiInline = true,
				get = function(info) return E.db.sle.lfr[ info[#info] ] end,
				set = function(info, value) E.db.sle.lfr[ info[#info] ] = value end,
				args = {
					-- Cata = {
						-- order = expackNum, type = 'group',
						-- name = EXPANSION_NAME3,
						-- guiInline = true,
						-- get = function(info) return E.db.sle.lfr.cata[ info[#info] ] end,
						-- set = function(info, value) E.db.sle.lfr.cata[ info[#info] ] = value end,
						-- args = {
							-- ds = { order = 1, type = 'toggle', name = SLE:GetMapInfo(409, 'name') },
						-- },
					-- },
					-- MoP = {
						-- order = expackNum-1, type = 'group',
						-- name = EXPANSION_NAME4,
						-- guiInline = true,
						-- get = function(info) return E.db.sle.lfr.mop[ info[#info] ] end,
						-- set = function(info, value) E.db.sle.lfr.mop[ info[#info] ] = value end,
						-- args = {
							-- mv = { order = 1, type = 'toggle', name = SLE:GetMapInfo(471, 'name') },
							-- hof = { order = 2, type = 'toggle', name = SLE:GetMapInfo(474, 'name') },
							-- toes = { order = 3, type = 'toggle', name = SLE:GetMapInfo(456, 'name') },
							-- tot = { order = 4, type = 'toggle', name = SLE:GetMapInfo(508, 'name') },
							-- soo = { order = 5, type = 'toggle', name = SLE:GetMapInfo(556, 'name') },
						-- },
					-- },
					-- WoD = {
						-- order = expackNum-2, type = 'group',
						-- name = EXPANSION_NAME5,
						-- guiInline = true,
						-- get = function(info) return E.db.sle.lfr.wod[ info[#info] ] end,
						-- set = function(info, value) E.db.sle.lfr.wod[ info[#info] ] = value end,
						-- args = {
							-- hm = { order = 1, type = 'toggle', name = SLE:GetMapInfo(610, 'name') },
							-- brf = { order = 2, type = 'toggle', name = SLE:GetMapInfo(596, 'name')},
							-- hfc = { order = 3, type = 'toggle', name = SLE:GetMapInfo(661, 'name') },
						-- },
					-- },
					Legion = {
						order = expackNum-3, type = 'group',
						name = EXPANSION_NAME6,
						guiInline = true,
						get = function(info) return E.db.sle.lfr.legion[ info[#info] ] end,
						set = function(info, value) E.db.sle.lfr.legion[ info[#info] ] = value end,
						args = {
							nightmare = { order = 1, type = 'toggle', name = SLE:GetMapInfo(777 , 'name') },
							trial = { order = 2, type = 'toggle', name = SLE:GetMapInfo(806, 'name') },
							palace = { order = 3, type = 'toggle', name = SLE:GetMapInfo(764, 'name') },
							tomb = { order = 4, type = 'toggle', name = SLE:GetMapInfo(850 , 'name') },
							antorus = { order = 5, type = 'toggle', name = SLE:GetMapInfo(909, 'name') },
						},
					},
					BFA = {
						order = expackNum-4, type = 'group',
						name = EXPANSION_NAME7,
						guiInline = true,
						get = function(info) return E.db.sle.lfr.bfa[ info[#info] ] end,
						set = function(info, value) E.db.sle.lfr.bfa[ info[#info] ] = value end,
						args = {
							uldir = { order = 1, type = 'toggle', name = SLE:GetMapInfo(1148, 'name') },
							daz = { order = 2, type = 'toggle', name = SLE:GetMapInfo(1358, 'name') },
							sc = { order = 3, type = 'toggle', name = SLE:GetMapInfo(1345, 'name') },
							ep = { order = 4, type = 'toggle', name = SLE:GetMapInfo(1512, 'name') },
							nzoth = { order = 5, type = 'toggle', name = SLE:GetMapInfo(1580, 'name') },
						},
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
