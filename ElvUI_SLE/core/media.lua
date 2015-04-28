local E, L, V, P, G = unpack(ElvUI);
local M = E:GetModule('SLE_Media')
local LSM = LibStub("LibSharedMedia-3.0")

local Zones = {
	"Washington",
	"Moscow",
	"Moon Base",
	"Goblin Spa Resort",
	"Illuminaty Headquaters",
	"Elv's Closet",
	"Pat's Cage",
}

local PvPInfo = {
	"(Horde Territory)",
	"(Alliance Territory)",
	"(Contested Territory)",
	"(Russian Territory)",
	"(Aliens Territory)",
	"(Cats Territory)",
	"(Japanese Territory)",
	"(EA Territory)",
}

local Subzones = {
	"Administration",
	"Hellhole",
	"Alley of Bullshit",
	"Dr. Pepper Storage",
	"Vodka Storage",
	"Last National Bank",
}

local PVPArena = {
	"(PvP)",
	"No Smoking!",
	"Only 5% Taxes",
	"Free For All",
	"Self destruction is in process",
}

local Colors = {
	[1] = {0.41, 0.8, 0.94}, -- sanctuary
	[2] = {1.0, 0.1, 0.1}, -- hostile
	[3] = {0.1, 1.0, 0.1}, --friendly
	[4] = {1.0, 0.7, 0}, --contested
	[5] = {1.0, 0.9294, 0.7607}, --white
}

local function ZoneTextPos()
	if ( PVPInfoTextString:GetText() == "" ) then
		SubZoneTextString:SetPoint("TOP", "ZoneTextString", "BOTTOM", 0, -E.db.sle.media.fonts.subzone.offset);
	else
		SubZoneTextString:SetPoint("TOP", "PVPInfoTextString", "BOTTOM", 0, -E.db.sle.media.fonts.subzone.offset);
	end
end

local function SetFonts()
	if E.private.general.replaceBlizzFonts then
		local db = E.db.sle.media.fonts

		ZoneTextString:SetFont(LSM:Fetch('font', db.zone.font), db.zone.size, db.zone.outline) -- Main zone name
		PVPInfoTextString:SetFont(LSM:Fetch('font', db.pvp.font), db.pvp.size, db.pvp.outline) -- PvP status for main zone
		PVPArenaTextString:SetFont(LSM:Fetch('font', db.pvp.font), db.pvp.size, db.pvp.outline) -- PvP status for subzone
		SubZoneTextString:SetFont(LSM:Fetch('font', db.subzone.font), db.subzone.size, db.subzone.outline) -- Subzone name
		
		SendMailBodyEditBox:SetFont(LSM:Fetch('font', db.mail.font), db.mail.size, db.mail.outline) --Writing letter text
		OpenMailBodyText:SetFont(LSM:Fetch('font', db.mail.font), db.mail.size, db.mail.outline) --Received letter text
		QuestFont:SetFont(LSM:Fetch('font', db.gossip.font), db.gossip.size, db.gossip.outline) -- Font in Quest Log/Petitions and shit. It's fucking hedious with any outline so fuck it.
		--QuestFont_Large:SetFont(LSM:Fetch('font', "ElvUI Pixel"), 12, "") -- No idea what that is for
		NumberFont_Shadow_Med:SetFont(LSM:Fetch('font', db.editbox.font), db.editbox.size, db.editbox.outline) --Chat editbox
	end
end

function M:TextWidth()
	local db = E.db.sle.media.fonts
	ZoneTextString:SetWidth(db.zone.width)
	PVPInfoTextString:SetWidth(db.pvp.width)
	PVPArenaTextString:SetWidth(db.pvp.width)
	SubZoneTextString:SetWidth(db.subzone.width)
end

function M:TextShow()
	local z, i, a, s, c = random(1, #Zones), random(1, #PvPInfo), random(1, #PVPArena), random(1, #Subzones), random(1, #Colors)
	local red, green, blue = unpack(Colors[c])

	--Setting texts--
	ZoneTextString:SetText(Zones[z])
	PVPInfoTextString:SetText(PvPInfo[i])
	PVPArenaTextString:SetText(PVPArena[a])
	SubZoneTextString:SetText(Subzones[s])
	
	ZoneTextPos()--nil, true)
	
	--Applying colors--
	ZoneTextString:SetTextColor(red, green, blue)
	PVPInfoTextString:SetTextColor(red, green, blue)
	PVPArenaTextString:SetTextColor(red, green, blue)
	SubZoneTextString:SetTextColor(red, green, blue)
	
	FadingFrame_Show(ZoneTextFrame)
	FadingFrame_Show(SubZoneTextFrame)
end

function M:Update()
	M:TextWidth()
end

function M:Initialize()
	M:TextWidth()
	hooksecurefunc(E, "UpdateBlizzardFonts", SetFonts)
	hooksecurefunc("SetZoneText", ZoneTextPos)
	--E:CreateMover(ZoneTextFrame, "ZoneTextMover", "ZoneTextMover", nil, nil, nil, "S&L,S&L MISC")
end