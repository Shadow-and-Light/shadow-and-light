if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)

P.sle.Armory = P.sle.Armory or {}
	
P.sle.Armory.Character = {
	Enable = true,
	
	NoticeMissing = true,
	MissingIcon = true,
	
	Backdrop = {
		SelectedBG = 'Space',
		CustomAddress = ''
	},
	
	Gradation = {
		Display = true,
		Color = { .41, .83, 1 }
	},
	
	Level = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		ShowUpgradeLevel = false,
		Font = "ElvUI Font",
		FontSize = 10,
		FontStyle = "OUTLINE",
	},
	
	Enchant = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		WarningSize = 12,
		WarningIconOnly = false,
		Font = "ElvUI Font",
		FontSize = 8,
		FontStyle = "OUTLINE",
	},
	
	Durability = {
		Display = 'Always', -- Always, MouseoverOnly, DamagedOnly, Hide
		Font = "ElvUI Font",
		FontSize = 9,
		FontStyle = "OUTLINE",
	},
	
	Gem = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		SocketSize = 10,
		WarningSize = 12
	}
}