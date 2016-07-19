local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local PVP = PVP
local HONORABLE_KILLS = HONORABLE_KILLS
local RANK = RANK
local DUEL, PET_BATTLE_PVP_DUEL = DUEL, PET_BATTLE_PVP_DUEL
local PvP = SLE:GetModule("PVP")
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.pvp = {
		type = "group",
		name = PVP,
		order = 16,
		args = {
			header = {
				order = 1,
				type = "header",
				name = PVP,
			},
			intro = {
				order = 2,
				type = "description",
				name = L["Functions dedicated to player versus player modes."],
			},
			autorelease = {
				type = "group",
				name = L["PvP Auto Release"],
				order = 9,
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Automatically release body when killed inside a battleground."],
						get = function(info) return E.db.sle.pvp.autorelease end,
						set = function(info, value) E.db.sle.pvp.autorelease = value; end
					},
					rebirth = {
						order = 2,
						type = "toggle",
						name = L["Check for rebirth mechanics"],
						desc = L["Do not release if reincarnation or soulstone is up."],
						disabled = function() return not E.db.sle.pvp.autorelease end,
						get = function(info) return E.db.sle.pvp.rebirth end,
						set = function(info, value) E.db.sle.pvp.rebirth = value; end
					},
				},
			},
			duels = {
				order = 4,
				type = "group",
				name = DUEL,
				guiInline = true,
				get = function(info) return E.db.sle.pvp.duels[ info[#info] ] end,
				set = function(info, value) E.db.sle.pvp.duels[ info[#info] ] = value end,
				args = {
					regular = {
						order = 1,
						type = "toggle",
						name = PVP,
						desc = L["Automatically cancel PvP duel requests."],
					},
					pet = {
						order = 2,
						type = "toggle",
						name = PET_BATTLE_PVP_DUEL,
						desc = L["Automatically cancel pet battles duel requests."],
					},
					announce = {
						order = 3,
						type = "toggle",
						name = L["Announce"],
						desc = L["Announce in chat if duel was rejected."],
					},
				},
			},
			BossBanner = {
				order = 5,
				type = "group",
				name = KILLING_BLOWS,
				guiInline = true,
				get = function(info) return E.private.sle.pvp.KBbanner[ info[#info] ] end,
				set = function(info, value) E.private.sle.pvp.KBbanner[ info[#info] ] = value end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Show your PvP killing blows as a popup."],
						set = function(info, value) E.private.sle.pvp.KBbanner[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					sound = {
						order = 2,
						type = "toggle",
						name = L["KB Sound"],
						desc = L["Play sound when Kkilling blows popup is shown."],
						disabled = function() return not E.private.sle.pvp.KBbanner.enable end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)