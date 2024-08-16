local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local M = SLE.Media

local _G = _G
local random = random
local FadingFrame_Show = FadingFrame_Show

M.Zones = L["SLE_MEDIA_ZONES"]
M.PvPInfo = L["SLE_MEDIA_PVP"]
M.Subzones = L["SLE_MEDIA_SUBZONES"]
M.PVPArena = L["SLE_MEDIA_PVPARENA"]

local Colors = {
	[1] = {0.41, 0.8, 0.94}, -- sanctuary
	[2] = {1.0, 0.1, 0.1}, -- hostile
	[3] = {0.1, 1.0, 0.1}, --friendly
	[4] = {1.0, 0.7, 0}, --contested
	[5] = {1.0, 0.9294, 0.7607}, --white
}

local fontFrames = {
	-- ZoneTextString = 'zone', -- Zone Name
	-- SubZoneTextString = 'subzone', -- SubZone Name
	-- PVPInfoTextString = 'pvp', -- PvP status for main zone
	-- PVPArenaTextString = 'pvp', -- PvP status for subzone
	SendMailBodyEditBox = 'mail', --Writing letter text
	-- OpenMailBodyText = 'mail',  -- Received letter text --! Seems to be bugged atm
	-- QuestFont = 'gossip', -- Quest Log/Petitions --! Looks terrible with an outline set, so it is skipped in M:SetBLizzFonts()
	QuestFont_Super_Huge = 'questFontSuperHuge', -- Not Sure Which One This Is
	QuestFont_Enormous = 'questFontSuperHuge', -- Not Sure Which One This Is
}

function M:SetBlizzFonts()
	if not E.private.general.replaceBlizzFonts then return end
	local db = E.db.sle.media.fonts

	for frame, option in pairs(fontFrames) do
		if _G[frame] then
			_G[frame]:FontTemplate(E.LSM:Fetch('font', db[option].font), db[option].fontSize, db[option].fontOutline)
		end
	end
end

function M:TextShow()
	local z, i, a, s, c = random(1, #M.Zones), random(1, #M.PvPInfo), random(1, #M.PVPArena), random(1, #M.Subzones), random(1, #Colors)
	local red, green, blue = unpack(Colors[c])

	--Applying colors--
	-- _G.ZoneTextString:SetTextColor(red, green, blue)
	-- _G.PVPInfoTextString:SetTextColor(red, green, blue)
	-- _G.PVPArenaTextString:SetTextColor(red, green, blue)
	-- _G.SubZoneTextString:SetTextColor(red, green, blue)

	FadingFrame_Show(_G.ZoneTextFrame)
	FadingFrame_Show(_G.SubZoneTextFrame)
end

function M:Initialize()
	if not SLE.initialized or not E.private.sle.media.enable then return end
	hooksecurefunc(E, 'UpdateBlizzardFonts', M.SetBlizzFonts)
	M.SetBlizzFonts()
end

SLE:RegisterModule(M:GetName())
