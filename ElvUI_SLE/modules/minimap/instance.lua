local E, L, V, P, G = unpack(ElvUI);
local I = E:GetModule('SLE_InstDif')
local GetInstanceInfo = GetInstanceInfo
local sub = string.sub
local IsInInstance, IsInGuild = IsInInstance, IsInGuild
local f 
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
}

function I:CreateText()
	f = CreateFrame("Frame", "MiniMapDifFrame", Minimap)
	f:Size(50, 20)
	-- f:Point("CENTER", UIParent)
	f.text = f:CreateFontString(nil, 'OVERLAY')
	f.text:SetPoint("CENTER", f, "CENTER")
	f.icon = f:CreateFontString(nil, 'OVERLAY')
	f.icon:SetPoint("LEFT", f.text, "RIGHT", 4, 0)
	self:SetFonts()
end

function I:SetFonts()
	local db = E.db.sle.minimap.instance
	f.text:SetFont(LSM:Fetch('font', db.font), db.fontSize, db.fontOutline)
	f.icon:SetFont(LSM:Fetch('font', db.font), db.fontSize, db.fontOutline)
end


local function InstanceCheck()
	local isInstance, InstanseType = IsInInstance()
	local s = false
	if isInstance and InstanseType ~= "pvp" then
		if InstanseType ~= "arena" then
			s = true
		end
	end

	return s
end

local function GuildEmblem()
	-- table
	local char = {}
	-- check if Blizzard_GuildUI is loaded
	if GuildFrameTabardEmblem then
		char.guildTexCoord = {GuildFrameTabardEmblem:GetTexCoord()}
	else
		char.guildTexCoord = false
	end
	if IsInGuild() and char.guildTexCoord then
		return "|TInterface\\GuildFrame\\GuildEmblemsLG_01:24:24:-4:1:32:32:"..(char.guildTexCoord[1]*32)..":"..(char.guildTexCoord[7]*32)..":"..(char.guildTexCoord[2]*32)..":"..(char.guildTexCoord[8]*32).."|t"
	else
		return ""
	end
end

function I:UpdateFrame()
	local db = E.db.sle.minimap.instance
	if IsInInstance() then
		if not db.flag then
			MiniMapInstanceDifficulty:Hide()
		elseif db.flag and not MiniMapInstanceDifficulty:IsShown() then
			MiniMapInstanceDifficulty:Show()
		end
	end
	f:Point("TOPLEFT", Minimap, "TOPLEFT", db.xoffset, db.yoffset)
	I:SetFonts()
	if db.enable then
		f.text:Show()
		f.icon:Show()
	else
		f.text:Hide()
		f.icon:Hide()
	end
end

function I:GetColor(dif)
	if dif and Difficulties[dif] then
		local color = E.db.sle.minimap.instance.colors[Difficulties[dif]]
		return color.r*255, color.g*255, color.b*255
	else
		return 255, 255, 255
	end
end

function I:GenerateText(event, guild, force)
	local text
	if not InstanceCheck() then 
		f.text:SetText("")
		f.icon:SetText("")
	else
		local _, _, difficulty, difficultyName, _, _, _, _, instanceGroupSize = GetInstanceInfo()
		local r, g, b = I:GetColor(difficulty)
		if (difficulty >= 3 and difficulty <= 7) or difficulty == 9 then
			text = format("|cff%02x%02x%02x%s|r", r, g, b, instanceGroupSize)
		else
			difficultyName = sub(difficultyName, 1 , 2)
			text = format(instanceGroupSize.." |cff%02x%02x%02x%s|r", r, g, b, difficultyName)
		end
		f.text:SetText(text)
		if guild or force then
			local logo = GuildEmblem()
			f.icon:SetText(logo)
		end
	end
end

function I:Initialize()
	self:CreateText()
	MiniMapInstanceDifficulty:HookScript("OnShow", function(self) if not E.db.sle.minimap.instance.flag then self:Hide() end end)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "GenerateText")
	self:RegisterEvent("GUILD_PARTY_STATE_UPDATED", "GenerateText")
	self:UpdateFrame()
end