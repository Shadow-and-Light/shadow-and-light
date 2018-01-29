if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)

P.sle.Armory = P.sle.Armory or {}

P.sle.Armory.Inspect = {
	Enable = true,
	
	NoticeMissing = true,
	MissingIcon = true,
	InspectMessage = true,
	
	Backdrop = {
		SelectedBG = 'Space',
		CustomAddress = '',
		Overlay = false,
		OverlayAlpha = 0.3,
	},
	
	Gradation = {
		Display = true,
		Color = { .41, .83, 1 },
		CurrentClassColor = false
	},
	
	Level = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		ShowUpgradeLevel = false,
		Font = "PT Sans Narrow",
		FontSize = 10,
		FontStyle = "OUTLINE"
	},
	
	Enchant = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		WarningSize = 12,
		WarningIconOnly = false,
		Font = "PT Sans Narrow",
		FontSize = 8,
		FontStyle = "OUTLINE"
	},
	
	Gem = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		SocketSize = 10,
		WarningSize = 12
	},
	--Fonts--
	--Tabs
	tabsText = {
		Font = "PT Sans Narrow",
		FontSize = 9,
		FontStyle = "OUTLINE",
	},
	--Model
	Name = {
		Font = "PT Sans Narrow",
		FontSize = 22,
		FontStyle = "OUTLINE",
	},
	Title = {
		Font = "PT Sans Narrow",
		FontSize = 9,
		FontStyle = "OUTLINE",
	},
	LevelRace = {
		Font = "PT Sans Narrow",
		FontSize = 10,
		FontStyle = "OUTLINE",
	},
	Guild = {
		Font = "PT Sans Narrow",
		FontSize = 10,
		FontStyle = "OUTLINE",
	},
	--Info
	infoTabs = {
		Font = "PT Sans Narrow",
		FontSize = 10,
		FontStyle = "OUTLINE",
	},
	pvpText = {
		Font = "PT Sans Narrow",
		FontSize = 10,
		FontStyle = "OUTLINE",
	},
	pvpType = {
		Font = "PT Sans Narrow",
		FontSize = 10,
		FontStyle = "OUTLINE",
	},
	pvpRating = {
		Font = "PT Sans Narrow",
		FontSize = 22,
		FontStyle = "OUTLINE",
	},
	pvpRecord = {
		Font = "PT Sans Narrow",
		FontSize = 10,
		FontStyle = "OUTLINE",
	},
	guildName = {
		Font = "PT Sans Narrow",
		FontSize = 14,
		FontStyle = "OUTLINE",
	},
	guildMembers = {
		Font = "PT Sans Narrow",
		FontSize = 9,
		FontStyle = "OUTLINE",
	},
	--Spec
	Spec = {
		Font = "PT Sans Narrow",
		FontSize = 10,
		FontStyle = "OUTLINE",
	},
}