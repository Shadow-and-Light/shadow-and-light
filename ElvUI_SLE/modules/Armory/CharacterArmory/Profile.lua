local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)

KF.db.Modules.Armory = KF.db.Modules.Armory or {}
	
KF.db.Modules.Armory.Character = {
	Enable = true,
	NoticeMissing = true,
	
	GradationColor = { .41, .83, 1 },
	BackgroundImage = 'Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Space'
}