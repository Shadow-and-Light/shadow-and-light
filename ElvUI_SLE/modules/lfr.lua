local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DT = E.DataTexts
local LFR = SLE.LFR

local _G = _G
local strlower = strlower
local GetAverageItemLevel = GetAverageItemLevel
local RAID_FINDER = RAID_FINDER
local BOSS_DEAD = BOSS_DEAD
local BOSS_ALIVE = BOSS_ALIVE
local RED_FONT_COLOR = RED_FONT_COLOR
local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local IsShiftKeyDown = IsShiftKeyDown

local ExpackColor = '|cff9482c9'

--Da grand table of every bit of info used by everything else
LFR.InstanceData = {
	ExpackData = {
		Legion = {
			index = 6,
			maxLevel = 110
		},
		BFA = {
			index = 7,
			maxLevel = 120
		},
	},
	Raids = { --Using numbers cause this way I can use for i = 1,# to order instances correctly
		Legion = {
			[1] = {
				name = 'nightmare',
				ilevel = 160,
				map = 777,
				dungeonIDs = { 1287,1288,1289 },
			},
			[2] = {
				name = 'trial',
				ilevel = 160,
				map = 806,
				dungeonIDs = { 1411 },
			},
			[3] = {
				name = 'palace',
				ilevel = 162,
				map = 764,
				dungeonIDs = { 1290,1291,1292,1293 },
			},
			[4] = {
				name = 'tomb',
				ilevel = 172,
				map = 850,
				dungeonIDs = { 1494,1495,1496,1497 },
			},
			[5] = {
				name = 'antorus',
				ilevel = 184,
				map = 909,
				dungeonIDs = { 1610,1611,1612,1613 },
			},
		},
		BFA = {
			[1] = {
				name = 'uldir',
				ilevel = 300,
				map = 1148,
				dungeonIDs = { 1731,1732,1733 },
			},
			[3] = {
				name = 'sc',
				ilevel = 350,
				map = 1345,
				dungeonIDs = { 1951 },
			},
			[4] = {
				name = 'ep',
				ilevel = 380,
				map = 1512,
				dungeonIDs = { 2009,2010,2011 },
			},
			[5] = {
				name = 'nzoth',
				ilevel = 410,
				map = 1580,
				dungeonIDs = { 2036,2037,2038,2039 },
			},
		},
	},
}

if E.myfaction == 'Horde' then
	LFR.InstanceData['Raids']['BFA'][2] = {
		name = "daz",
		ilevel = 350,
		map = 1358,
		dungeonIDs = { 1948, 1949, 1950 },
	}
else
	LFR.InstanceData['Raids']['BFA'][2] = {
		name = 'daz',
		ilevel = 350,
		map = 1358,
		dungeonIDs = { 1945, 1946, 1947 },
	}
end

--Checking if tracking of an expack dungeons is enabled
function LFR:CheckOptions()
	if LFR:CheckLegion() or LFR:CheckBFA() then return true end
	return false
end

function LFR:CheckLegion()
	for _, v in pairs(LFR.db.legion) do
		if v == true then
			return v
		end
	end
	return false
end

function LFR:CheckBFA()
	for _, v in pairs(LFR.db.bfa) do
		if v == true then
			return v
		end
	end
	return false
end

--Creating a group of info for dungeons of expack passed. Also player level and ilvl are passed
function LFR:BuildGroup(expack, lvl, ilvl)
	if not LFR['Check'..expack]() then return end --If nothing in this expack is selected to be tracked then our work is done
	local small = strlower(expack) --making lower case version of expack name for checking options
	DT.tooltip:AddLine(ExpackColor..'< '.._G['EXPANSION_NAME'..LFR.InstanceData['ExpackData'][expack].index]..' >|r') --Da title!
	for i = 1, #(LFR.InstanceData['Raids'][expack]) do
		local instanceInfo = LFR.InstanceData['Raids'][expack][i]
		if LFR.db[small][instanceInfo.name] then
			DT.tooltip:AddLine(' '..SLE:GetMapInfo(instanceInfo.map, 'name'))
			--Check for dungeon requirements
			if lvl == LFR.InstanceData['ExpackData'][expack].maxLevel and ilvl >= instanceInfo.ilevel then
				LFR:GetRaidLockInfo(unpack(instanceInfo.dungeonIDs)) --Adding info about bosses to the tooltip for this dungeon
			else
				DT.tooltip:AddLine(' '..L["This LFR isn't available for your level/gear."])
			end
		end
	end
	--Add a separator from any possible following info
	DT.tooltip:AddLine(' ')
end

--Info about passed dungeon IDs. Don't feed map IDs, those are different.
function LFR:GetRaidLockInfo(...)
	local dungeonIDs = {...} --All provided IDs
	local numBosses = 0 --Total number of bosses in the dungeon
	local killNum = 0 --How many were already killed
	for i = 1, #dungeonIDs do
		local isAvailable, isAvailableToPlayer = IsLFGDungeonJoinable(dungeonIDs[i])
		--Only count this wing if it is actually available
		if isAvailable or isAvailableToPlayer then
			local numEncounters = GetLFGDungeonNumEncounters(dungeonIDs[i])
			numBosses = numBosses + numEncounters
			for j = 1, numEncounters do
				local bossName, _, isKilled = GetLFGDungeonEncounterInfo(dungeonIDs[i], j)
				if IsShiftKeyDown() then --Show detailed info
					LFR:BossStatus(bossName, isKilled)
				else
					if (isKilled) then killNum = killNum + 1 end
				end
			end
		end
	end
	if not IsShiftKeyDown() then --Show just killed/total
		LFR:BossCount(killNum, numBosses)
	end
end

--Injecting into tooltip
function LFR:Show()
	local lvl = E.mylevel
	local ilvl = GetAverageItemLevel()
	DT.tooltip:AddLine(' ')
	DT.tooltip:AddLine(RAID_FINDER)
	if not LFR:CheckOptions() then
		DT.tooltip:AddLine(' '..L["You didn't select any instance to track."])
		return
	end

	--Building dungeons info
	LFR:BuildGroup('BFA', lvl, ilvl)
	LFR:BuildGroup('Legion', lvl, ilvl)
end

--Detailed info about bosses in the wing
function LFR:BossStatus(bossName, isKilled)
	if not bossName then return end
	if (isKilled) then
		DT.tooltip:AddDoubleLine(' '..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

--Da line "kill/total"
function LFR:BossCount(killNum, numBosses)
	if killNum == numBosses then
		DT.tooltip:AddLine(' '..L["Bosses killed: "]..killNum..'/'..numBosses, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(' '..L["Bosses killed: "]..killNum..'/'..numBosses, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function LFR:Initialize()
	if not SLE.initialized then return end
	--DB conversions
	if E.db.sle.lfr.cata then E.db.sle.lfr.cata = nil end
	if E.db.sle.lfr.mop then E.db.sle.lfr.mop = nil end
	if E.db.sle.lfr.wod then E.db.sle.lfr.wod = nil end
	LFR.db = E.db.sle.lfr

	function LFR:ForUpdateAll()
		if E.db.sle.lfr.cata then E.db.sle.lfr.cata = nil end
		if E.db.sle.lfr.mop then E.db.sle.lfr.mop = nil end
		if E.db.sle.lfr.wod then E.db.sle.lfr.wod = nil end
		LFR.db = E.db.sle.lfr
	end
end

SLE:RegisterModule(LFR:GetName())
