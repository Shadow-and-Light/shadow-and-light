local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local I = SLE:NewModule("InstDif",'AceHook-3.0', 'AceEvent-3.0')
local sub = string.utf8sub
local LSM = LibStub("LibSharedMedia-3.0")

local Difficulties = {
	[1] = 'normal', --5ppl normal
	[2] = 'heroic', --5ppl heroic
	[3] = 'normal', --10ppl raid
	[4] = 'normal', --25ppl raid
	[5] = 'heroic', --10ppl heroic raid
	[6] = 'heroic', --25ppl heroic raid
	[7] = 'lfr', --25ppl LFR
	[8] = 'challenge', --5ppl challenge
	[9] = 'normal', --40ppl raid
	[11] = 'heroic', --Heroic scenario
	[12] = 'normal', --Normal scenario
	[14] = 'normal', --10-30ppl normal
	[15] = 'heroic', --13-30ppl heroic
	[16] = 'mythic', --20ppl mythic
	[17] = 'lfr', --10-30 LFR
	[23] = 'mythic', --5ppl mythic
	[24] = 'time', --Timewalking
}

function I:CreateText()
	I.frame = CreateFrame("Frame", "MiniMapDifFrame", Minimap)
	I.frame:Size(50, 20)
	-- I.frame:Point("CENTER", UIParent)
	I.frame.text = I.frame:CreateFontString(nil, 'OVERLAY')
	I.frame.text:SetPoint("CENTER", I.frame, "CENTER")
	I.frame.icon = I.frame:CreateFontString(nil, 'OVERLAY')
	I.frame.icon:SetPoint("LEFT", I.frame.text, "RIGHT", 4, 0)
	self:SetFonts()
end

function I:SetFonts()
	I.frame.text:SetFont(LSM:Fetch('font', I.db.font), I.db.fontSize, I.db.fontOutline)
	I.frame.icon:SetFont(LSM:Fetch('font', I.db.font), I.db.fontSize, I.db.fontOutline)
end


function I:InstanceCheck()
	local isInstance, InstanseType = T.IsInInstance()
	local s = false
	if isInstance and InstanseType ~= "pvp" then
		if InstanseType ~= "arena" then
			s = true
		end
	end

	return s
end

function I:GuildEmblem()
	-- table
	local char = {}
	-- check if Blizzard_GuildUI is loaded
	if GuildFrameTabardEmblem then
		char.guildTexCoord = {GuildFrameTabardEmblem:GetTexCoord()}
	else
		char.guildTexCoord = false
	end
	if T.IsInGuild() and char.guildTexCoord then
		return "|TInterface\\GuildFrame\\GuildEmblemsLG_01:24:24:-4:1:32:32:"..(char.guildTexCoord[1]*32)..":"..(char.guildTexCoord[7]*32)..":"..(char.guildTexCoord[2]*32)..":"..(char.guildTexCoord[8]*32).."|t"
	else
		return ""
	end
end

function I:UpdateFrame()
	local db = I.db
	if T.IsInInstance() then
		if not db.flag then
			MiniMapInstanceDifficulty:Hide()
		elseif db.flag and not MiniMapInstanceDifficulty:IsShown() then
			MiniMapInstanceDifficulty:Show()
		end
	end
	I.frame:Point("TOPLEFT", Minimap, "TOPLEFT", db.xoffset, db.yoffset)
	I:SetFonts()
	if db.enable then
		I.frame.text:Show()
		I.frame.icon:Show()
	else
		I.frame.text:Hide()
		I.frame.icon:Hide()
	end
end

function I:GetColor(dif)
	if dif and Difficulties[dif] then
		local color = I.db.colors[Difficulties[dif]]
		return color.r*255, color.g*255, color.b*255
	else
		return 255, 255, 255
	end
end

function I:GenerateText(event, guild, force)
	local text
	if not I:InstanceCheck() then 
		I.frame.text:SetText("")
		I.frame.icon:SetText("")
	else
		local _, _, difficulty, difficultyName, _, _, _, _, instanceGroupSize = T.GetInstanceInfo()
		local r, g, b = I:GetColor(difficulty)
		if (difficulty >= 3 and difficulty <= 7) or difficulty == 9 then
			text = T.format("|cff%02x%02x%02x%s|r", r, g, b, instanceGroupSize)
		else
			difficultyName = sub(difficultyName, 1 , 1)
			text = T.format(instanceGroupSize.." |cff%02x%02x%02x%s|r", r, g, b, difficultyName)
		end
		I.frame.text:SetText(text)
		if guild or force then
			local logo = I:GuildEmblem()
			I.frame.icon:SetText(logo)
		end
	end
end

function I:Initialize()
	if not SLE.initialized then return end
	I.db = E.db.sle.minimap.instance
	self:CreateText()
	MiniMapInstanceDifficulty:HookScript("OnShow", function(self) if not I.db.flag then self:Hide() end end)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "GenerateText")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "GenerateText")
	self:RegisterEvent("GUILD_PARTY_STATE_UPDATED", "GenerateText")
	self:UpdateFrame()

	function I:ForUpdateAll()
		I.db = E.db.sle.minimap.instance
		I:UpdateFrame()
	end
end

SLE:RegisterModule(I:GetName())