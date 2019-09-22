local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Armory = SLE:GetModule("Armory_Core")
local CA = SLE:GetModule("Armory_Character")

local function configTable()
	if not SLE.initialized then return end
	
	E.Options.args.sle.args.modules.args.armory.args.character = {
		type = 'group',
		name = L["Character Armory"],
		order = 400,
		disabled = function() return E.db.sle.armory.character.enable == false end,
		args = {
			background = {
				type = 'group',
				name = L["Backdrop"],
				order = 4,
				args = {
					selectedBG = {
						type = 'select',
						name = L["Select Image"],
						order = 1,
						get = function() return E.db.sle.armory.character.background.selectedBG end,
						set = function(_, value) E.db.sle.armory.character.background.selectedBG = value; CA:Update_BG() end,
						values = function() return SLE.ArmoryConfigBackgroundValues.BackgroundValues end,
					},
					CustomAddress = {
						type = 'input',
						name = L["Custom Image Path"],
						order = 2,
						get = function() return E.db.sle.Armory.Character.Backdrop.CustomAddress end,
						set = function(_, value) E.db.sle.Armory.Character.Backdrop.CustomAddress = value; CA:Update_BG() end,
						width = 'double',
						hidden = function() return E.db.sle.armory.character.background.selectedBG ~= 'CUSTOM' end
					},
					Overlay = {
						type = "toggle",
						order = 3,
						name = L["Overlay"],
						desc = L["Show ElvUI skin's backdrop overlay"],
						get = function() return E.db.sle.armory.character.background.overlay end,
						set = function(_, value) E.db.sle.armory.character.background.overlay = value; CA:ElvOverlayToggle() end
					},
				}
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
