if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)

P.sle.Armory = P.sle.Armory or {}
	
P.sle.Armory.Character = {
	Enable = true,
	
	NoticeMissing = true,
	
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
		Font = nil,
		FontSize = 10,
		FontStyle = nil
	},
	
	Enchant = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		WarningSize = 12,
		WarningIconOnly = false,
		Font = nil,
		FontSize = 8,
		FontStyle = nil
	},
	
	Durability = {
		Display = 'Always', -- Always, MouseoverOnly, DamagedOnly, Hide
		Font = nil,
		FontSize = 9,
		FontStyle = nil
	},
	
	Gem = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		SocketSize = 10,
		WarningSize = 12
	}
}