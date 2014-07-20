local E, L, V, P, G, _ = unpack(ElvUI);
local I = E:GetModule('SLE_InstDif')
local GetInstanceInfo = GetInstanceInfo
local sub = string.sub
local IsInInstance, IsInGuild = IsInInstance, IsInGuild
local f 

local function CreateText()
f = CreateFrame("Frame", "MiniMapDifFrame", Minimap)
f:Size(50, 20)

-- f:Point("CENTER", UIParent)

f.text = f:CreateFontString(nil, 'OVERLAY')
f.text:SetFont(E["media"].normFont, 12)
f.text:SetPoint("CENTER", f, "CENTER")
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
		if db.flag then
			MiniMapInstanceDifficulty:Show()
		else
			MiniMapInstanceDifficulty:Hide()
		end
	end
	f:Point("TOPLEFT", MiniMapInstanceDifficulty, "TOPLEFT", db.xoffset, db.yoffset)
	if db.enable then
		f.text:Show()
	else
		f.text:Hide()
	end
end

local function GenerateText(self, event, guild)
	if not InstanceCheck() then 
		f.text:SetText("")
	else
		local _, _, _, difficultyName, _, _, _, _, instanceGroupSize = GetInstanceInfo()
		difficultyName = sub(difficultyName, 1 , 2)
		f.text:SetText(instanceGroupSize.." ("..difficultyName..")")
		if guild then
			local logo = GuildEmblem()
			f.text:SetText(instanceGroupSize.." ("..difficultyName..")"..logo)
		end
	end
end

function I:Initialize()
	CreateText()
	MiniMapInstanceDifficulty:HookScript("OnShow", function(self) if not E.db.sle.minimap.instance.flag then self:Hide() end end)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", GenerateText)
	self:RegisterEvent("GUILD_PARTY_STATE_UPDATED", GenerateText)
	I:UpdateFrame()
end