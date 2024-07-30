local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local I = SLE.InstDif

local _G = _G
local format = format
local sub = string.utf8sub
local GetInstanceInfo, GetDifficultyInfo = GetInstanceInfo, GetDifficultyInfo
local IsInGuild, IsInInstance = IsInGuild, IsInInstance
local InstanceDifficulty = _G.MinimapCluster.InstanceDifficulty
local ChallengeMode = InstanceDifficulty.ChallengeMode
local Guild = InstanceDifficulty.Guild

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
	I.frame = CreateFrame('Frame', 'SL_MinimapDifficultyFrame', _G.Minimap)
	I.frame:Size(50, 20)
	I.frame.text = I.frame:CreateFontString(nil, 'OVERLAY')
	I.frame.text:SetPoint('CENTER', I.frame, 'CENTER')
	I.frame.icon = I.frame:CreateFontString(nil, 'OVERLAY')
	I.frame.icon:SetPoint('LEFT', I.frame.text, 'RIGHT', 4, 0)

	I:SetFonts()
end

function I:SetFonts()
	I.frame.text:FontTemplate(E.LSM:Fetch('font', E.db.sle.minimap.instance.font), E.db.sle.minimap.instance.fontSize, E.db.sle.minimap.instance.fontOutline)
	I.frame.icon:FontTemplate(E.LSM:Fetch('font', E.db.sle.minimap.instance.font), E.db.sle.minimap.instance.fontSize, E.db.sle.minimap.instance.fontOutline)
end


function I:InstanceCheck()
	local isInstance, InstanseType = IsInInstance()
	local show = false
	if isInstance and InstanseType ~= 'pvp' and InstanseType ~= 'arena' then show = true end
	return show
end

function I:GuildEmblem()
	-- table
	local char = {}

	if Guild then
		char.guildTexCoord = {Guild.Emblem:GetTexCoord()}
	else
		char.guildTexCoord = false
	end
	if char.guildTexCoord and IsInGuild() then
		-- return '|TInterface\\GuildFrame\\GuildEmblemsLG_01:24:24:-4:1:32:32:'..(char.guildTexCoord[1]*32)..':'..(char.guildTexCoord[7]*32)..':'..(char.guildTexCoord[2]*32)..':'..(char.guildTexCoord[8]*32)..'|t'
		-- 0.91796875, 0.00390625, 0.91796875, 0.06640625, 0.98046875, 0.00390625, 0.98046875, 0.06640625
		-- 	   ULx,		   ULy,		   LLx,		   LLy,		   URx,		   URy,		   LRx,		   LRy

		-- 	   "|TInterface\\ChatFUI-ChatIcon-ArmoryChat:14:14:0:0:16:16:0:16:0:16:73:177:73|t Reckful"
		return '|TInterface\\GuildFrame\\GuildEmblems_01:16:16:0:0:32:32:'..(char.guildTexCoord[1]*32)..':'..(char.guildTexCoord[7]*32)..':'..(char.guildTexCoord[2]*32)..':'..(char.guildTexCoord[8]*32)..'|t'
	else
		return ''
	end
end

function I:UpdateFrame()
	local db = I.db
	I.frame:Point('TOPLEFT', _G.Minimap, 'TOPLEFT', db.xoffset, db.yoffset)
	I:SetFonts()
	I.frame.text:SetShown(db.enable)
	I.frame.icon:SetShown(db.enable)
end

function I:GetColor(dif)
	if dif and Difficulties[dif] then
		local color = E.db.sle.minimap.instance.colors[Difficulties[dif]]
		return color.r*255, color.g*255, color.b*255
	else
		return 255, 255, 255
	end
end

function I:GenerateText(_, guild)
	if not I.db.enable then return end
	I.frame.icon:SetText('')

	if not I:InstanceCheck() then
		I.frame.text:SetText('')
	else
		local text, isChallengeMode
		local _, difficulty, difficultyName, _, _, _, _, instanceGroupSize = select(2, GetInstanceInfo())
		_, isChallengeMode = select(3, GetDifficultyInfo(difficulty))
		local r, g, b = I:GetColor(difficulty)

		if (difficulty >= 3 and difficulty <= 7) or difficulty == 9 or E.db.sle.minimap.instance.onlyNumber then
			text = format('|cff%02x%02x%02x%s|r', r, g, b, instanceGroupSize)
		else
			difficultyName = sub(difficultyName, 1 , 1)
			text = format(instanceGroupSize..' |cff%02x%02x%02x%s|r', r, g, b, difficultyName)
		end

		I.frame.text:SetText(text)

		if (guild) and not isChallengeMode then
			local logo = I:GuildEmblem()
			I.frame.icon:SetText(logo)
		end
		InstanceDifficulty:Hide()
		ChallengeMode:Hide()
		Guild:Hide()
	end
	I:UpdateFrame()
end

function I:Initialize()
	if not SLE.initialized or not E.private.general.minimap.enable then return end

	I.db = E.db.sle.minimap.instance
	I:CreateText()

	InstanceDifficulty:HookScript('OnShow', function(frame) if I.db.enable then frame:Hide() end end)
	Guild:HookScript('OnShow', function(frame) if I.db.enable then frame:Hide() end end)
	ChallengeMode:HookScript('OnShow', function(frame) if I.db.enable then frame:Hide() end end)

	I:RegisterEvent('LOADING_SCREEN_DISABLED', 'GenerateText')
	I:RegisterEvent('GROUP_ROSTER_UPDATE', 'GenerateText')
	I:RegisterEvent('GUILD_PARTY_STATE_UPDATED', 'GenerateText')
	I:UpdateFrame()

	hooksecurefunc(MinimapCluster.InstanceDifficulty, 'Update', I.GenerateText)

	function I:ForUpdateAll()
		I.db = E.db.sle.minimap.instance
		I:UpdateFrame()
	end
end

SLE:RegisterModule(I:GetName())
