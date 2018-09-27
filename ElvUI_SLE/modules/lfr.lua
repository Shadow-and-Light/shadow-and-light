local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
--LFR boss status calculations--
local DT = E:GetModule('DataTexts')
local LFR = SLE:NewModule("LFR")
local _G = _G
--strings
local RAID_FINDER = RAID_FINDER
local BOSS_DEAD = BOSS_DEAD
local BOSS_ALIVE_INELIGIBLE = BOSS_ALIVE_INELIGIBLE
local BOSS_ALIVE = BOSS_ALIVE
--stuff
local RED_FONT_COLOR = RED_FONT_COLOR
local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local IsShiftKeyDown = IsShiftKeyDown

local bossName, _, isKilled, isIneligible
local ExpackColor = "|cff9482c9"
--[[
--For 3 boss raid
local function ThreeKill(id)
	local killNum = 0
	for i =1,3 do
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id, i);
		if (isKilled) then killNum = killNum + 1 end
	end

	LFR:BossCount(killNum, 3)
end

local function ThreeShift(id)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
end

--For 4 boss raid
local function FourKill(id)
	local killNum = 0
	for i =1,4 do
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id, i);
		if (isKilled) then killNum = killNum + 1 end
	end

	LFR:BossCount(killNum, 4)
end

local function FourShift(id)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
end

--For 6 boss raid
local function SixKill(id1, id2)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then killNum = killNum + 1 end
	end

	LFR:BossCount(killNum, 6)
end

local function SixShift(id1, id2)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
end

--For 7 boss raid
local function SevenKill(id1, id2, id3)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then killNum = killNum + 1 end
	end

	-- 3rd part
	_, _, isKilled = T.GetLFGDungeonEncounterInfo(id3, 7);
	if (isKilled) then killNum = killNum + 1 end

	LFR:BossCount(killNum, 7)
end

local function SevenShift(id1, id2, id3)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	-- 3rd part
	bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id3, 7);
	LFR:BossStatus(bossName, isKilled, isIneligible)
end

-- For Emarald Nightmare
-- What the actual fuck, Blizz? What the fuck is this shit? You can't fucking make all your LFR following the same fucking pattern?
-- Do I need to make an exclusive function or every raid in existence now?
local function NightmareKill(id1, id2, id3)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =1,3 do --2nd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	-- 3rd part
	_, _, isKilled = T.GetLFGDungeonEncounterInfo(id3, 1);
	if (isKilled) then killNum = killNum + 1 end
	LFR:BossCount(killNum, 7)
end

local function NightmareShift(id1, id2, id3)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =1,3 do --2nd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	-- 3rd part
	bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id3, 1);
	LFR:BossStatus(bossName, isKilled, isIneligible)
end

--For 8 boss raid
local function EightKill(id1, id2)
	local killNum = 0
	for i =1,4 do --1st part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =5,8 do --2nd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then killNum = killNum + 1 end
	end

	LFR:BossCount(killNum, 8)
end

local function EightShift(id1, id2)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =5,8 do --2nd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
end

--For 9 boss raid
local function NineKill(id1, id2, id3, id4)
	local killNum = 0
	local bosses = {} --cause fuck blizz ordering
	--1st part
	bosses = {1, 3, 5}
	for i =1, #bosses do
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, bosses[i]);
		if (isKilled) then killNum = killNum + 1 end
	end
	T.twipe(bosses)
	--2nd part
	bosses = {2, 4, 6}
	for i =1, #bosses do 
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, bosses[i]);
		if (isKilled) then killNum = killNum + 1 end
	end
	T.twipe(bosses)
	--3nd part
	for i =7,8 do 
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	-- 4th part
	_, _, isKilled = T.GetLFGDungeonEncounterInfo(id4, 9);
	if (isKilled) then killNum = killNum + 1 end

	LFR:BossCount(killNum, 9)
end

local function NineShift(id1, id2, id3, id4)
	local bosses = {} --cause fuck blizz ordering
	-- 1st part
	bosses = {1, 3, 5}
	for i =1, #bosses do 
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, bosses[i]);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	T.twipe(bosses)
	--2nd part
	bosses = {2, 4, 6}
	for i =1, #bosses do  
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, bosses[i]);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	T.twipe(bosses)
	for i =7,8 do --3nd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id3, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	-- 4rd part
	bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id4, 9);
	LFR:BossStatus(bossName, isKilled, isIneligible)
end

--For 10 boss raid
local function TenKill(id1, id2, id3, id4)
	local killNum = 0
	local bosses = {} --cause fuck blizz ordering
	--1st part
	bosses = {1, 2, 7}
	for i =1, #bosses do
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, bosses[i]);
		if (isKilled) then killNum = killNum + 1 end
	end
	T.twipe(bosses)
	--2nd part
	bosses = {3, 5, 8}
	for i =1, #bosses do 
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, bosses[i]);
		if (isKilled) then killNum = killNum + 1 end
	end
	T.twipe(bosses)
	--3rd part
	bosses = {4, 6, 9}
	for i =1, #bosses do
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id3, bosses[i]);
		if (isKilled) then killNum = killNum + 1 end
	end

	-- 4th part
	_, _, isKilled = T.GetLFGDungeonEncounterInfo(id4, 10);
	if (isKilled) then killNum = killNum + 1 end

	LFR:BossCount(killNum, 10)
end

local function TenShift(id1, id2, id3, id4)
	
	local bosses = {} --cause fuck blizz ordering
	--1st part
	bosses = {1, 2, 7}
	for i =1, #bosses do 
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, bosses[i]);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	T.twipe(bosses)
	--2nd part
	bosses = {3, 5, 8}
	for i =1, #bosses do  
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, bosses[i]);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	T.twipe(bosses)
	--3rd part
	bosses = {4, 6, 9}
	for i =1, #bosses do   
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id3, bosses[i]);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	--4th part
	bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id4, 10);
	LFR:BossStatus(bossName, isKilled, isIneligible)
end

--For 11 boss raid
local function ElevenKill(id1, id2, id3, id4)
	local killNum = 0
	--1st part
	for i =1, 3 do
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	--2nd part
	for i =4, 6 do 
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	--3rd part
	for i =7, 9 do
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	-- 4th part
	for i =10, 11 do
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id4, i);
		if (isKilled) then killNum = killNum + 1 end
	end

	LFR:BossCount(killNum, 10)
end

local function ElevenShift(id1, id2, id3, id4)
	--1st part
	for i =1, 3 do 
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	--2nd part
	-- bosses = {3, 5, 8}
	for i =4, 6 do  
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	--3rd part
	-- bosses = {4, 6, 9}
	for i =7, 9 do   
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id3, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	--4th part
	for i =10, 11 do   
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id4, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
end

--For 12 boss raid
local function TwelveKill(id1, id2, id3, id4)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =7,9 do --3rd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =10,12 do --4th part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id4, i);
		if (isKilled) then killNum = killNum + 1 end
	end

	LFR:BossCount(killNum, 12)
end

local function TwelveShift(id1, id2, id3, id4)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =7,9 do --3rd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id3, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =10,12 do --4th part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id4, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
end

--For 13 boss raid (HFC)
local function HFCKill(id1, id2, id3, id4, id5)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =7,9 do --3rd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =10,12 do --4th part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id4, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	_, _, isKilled = T.GetLFGDungeonEncounterInfo(id5, 13);
	if (isKilled) then killNum = killNum + 1 end

	LFR:BossCount(killNum, 13)
end

local function HFCShift(id1, id2, id3, id4, id5)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =7,9 do --3rd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id3, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =10,12 do --4th part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id4, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id5, 13);
	LFR:BossStatus(bossName, isKilled, isIneligible)
end

--For 14 boss raid
local function FourteenKill(id1, id2, id3, id4)
	local killNum = 0
	for i =1,4 do --1st part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =5,8 do --2nd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =9,11 do --3rd part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	for i =12,14 do --4th part
		_, _, isKilled = T.GetLFGDungeonEncounterInfo(id4, i);
		if (isKilled) then killNum = killNum + 1 end
	end
	LFR:BossCount(killNum, 14)
end

local function FourteenShift(id1, id2, id3, id4)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id1, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =5,8 do --2nd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id2, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =9,11 do --3rd part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id3, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
	for i =12,14 do --4th part
		bossName, _, isKilled, isIneligible = T.GetLFGDungeonEncounterInfo(id4, i);
		LFR:BossStatus(bossName, isKilled, isIneligible)
	end
end]]

--[[local function DragonSoul()
	if IsShiftKeyDown() then
		EightShift(416, 417)
	else
		EightKill(416, 417)
	end
end

local function Mogushan()
	if IsShiftKeyDown() then
		SixShift(527, 528)
	else
		SixKill(527, 528)
	end
end

local function HoF()
	if IsShiftKeyDown() then
		SixShift(529, 530)
	else
		SixKill(529, 530)
	end
end

local function ToES()
	if IsShiftKeyDown() then
		FourShift(526)
	else
		FourKill(526)
	end
end

local function ToT()
	if IsShiftKeyDown() then
		TwelveShift(610, 611, 612, 613)
	else
		TwelveKill(610, 611, 612, 613)
	end
end

local function SoO()
	if IsShiftKeyDown() then
		FourteenShift(716, 717, 724, 725)
	else
		FourteenKill(716, 717, 724, 725)
	end
end

local function HM()
	if IsShiftKeyDown() then
		SevenShift(849, 850, 851);
	else
		SevenKill(849, 850, 851);
	end
end

local function BRF()
	if IsShiftKeyDown() then
		TenShift(847, 846, 848, 823);
	else
		TenKill(847, 846, 848, 823);
	end
end

local function HFC()
	if IsShiftKeyDown() then
		HFCShift(982, 983, 984, 985, 986);
	else
		HFCKill(982, 983, 984, 985, 986);
	end
end]]

--Da grand table of every bit of info used by everything else
LFR.InstanceData = {
	["ExpackData"] = {
		["Cata"] = { ["index"] = 3, ["maxLevel"] = 85},
		["MoP"] = { ["index"] = 4, ["maxLevel"] = 90},
		["WoD"] = { ["index"] = 5, ["maxLevel"] = 100},
		["Legion"] = { ["index"] = 6, ["maxLevel"] = 110},
		["BFA"] = { ["index"] = 7, ["maxLevel"] = 120},
	},
	["Raids"] = { --Using numbers cause this way I can use for i = 1,# to order instances correctly
		["Cata"] = {
			[1] = {
				["name"] = 'ds',
				["ilevel"] = 108,
				["map"] = 409,
				["func"] = DragonSoul,
				-- ["dungeonIDs"] = {},
			},
		},
		["MoP"] = {
			[1] = {
				["name"] = 'mv',
				["ilevel"] = 116,
				["map"] = 471,
				-- ["dungeonIDs"] = {},
			},
			[2] = {
				["name"] = 'hof',
				["ilevel"] = 116,
				["map"] = 897,
				-- ["dungeonIDs"] = {},
			},
			[3] = {
				["name"] = 'toes',
				["ilevel"] = 116,
				["map"] = 886,
				-- ["dungeonIDs"] = {},
			},
			[4] = {
				["name"] = 'tot',
				["ilevel"] = 116,
				["map"] = 930,
				-- ["dungeonIDs"] = {},
			},
			[5] = {
				["name"] = 'soo',
				["ilevel"] = 116,
				["map"] = 953,
				-- ["dungeonIDs"] = {},
			},
		},
		["WoD"] = {
			[1] = {
				["name"] = 'hm',
				["ilevel"] = 136,
				["map"] = 610,
				-- ["dungeonIDs"] = {},
			},
			[2] = {
				["name"] = 'brf',
				["ilevel"] = 136,
				["map"] = 596,
				-- ["dungeonIDs"] = {},
			},
			[3] = {
				["name"] = 'hfc',
				["ilevel"] = 138,
				["map"] = 661,
				-- ["dungeonIDs"] = {},
			},
		},
		["Legion"] = {
			[1] = {
				["name"] = 'nightmare',
				["ilevel"] = 160,
				["map"] = 777,
				["dungeonIDs"] = {1287,1288,1289},
			},
			[2] = {
				["name"] = 'trial',
				["ilevel"] = 160,
				["map"] = 806,
				["dungeonIDs"] = {1411},
			},
			[3] = {
				["name"] = 'palace',
				["ilevel"] = 162,
				["map"] = 764,
				["dungeonIDs"] = {1290,1291,1292,1293},
			},
			[4] = {
				["name"] = "tomb",
				["ilevel"] = 172,
				["map"] = 850,
				["dungeonIDs"] = {1494,1495,1496,1497},
			},
			[5] = {
				["name"] = "antorus",
				["ilevel"] = 184,
				["map"] = 909,
				["dungeonIDs"] = {1610,1611,1612,1613},
			},
		},
		["BFA"] = {
			[1] = {
				["name"] = "uldir",
				["ilevel"] = 300,
				["map"] = 1148,
				["dungeonIDs"] = {1731,1732,1733},
			},
		},
	},
}

--Chacking if tracking of an expack dungeons is enabled
function LFR:CheckOptions()
	if LFR:CheckLegion() or LFR:CheckBFA() then return true end
	return false
end
--[[function LFR:CheckCata()
	if LFR.db.cata.ds then return true else return false end
end
function LFR:CheckMoP()
	for k, v in T.pairs(LFR.db.mop) do
		if v == true then
			return v
		end
	end
	return false
end
function LFR:CheckWoD()
	for k, v in T.pairs(LFR.db.wod) do
		if v == true then
			return v
		end
	end
	return false
end]]
function LFR:CheckLegion()
	for k, v in T.pairs(LFR.db.legion) do
		if v == true then
			return v
		end
	end
	return false
end
function LFR:CheckBFA()
	for k, v in T.pairs(LFR.db.bfa) do
		if v == true then
			return v
		end
	end
	return false
end

--Creating a group of info for dungeons of expack passed. Also player level and ilvl are passed
function LFR:BuildGroup(expack, lvl, ilvl)
	if not LFR["Check"..expack]() then return end --If nothing in this expack is selected to be tracked then our work is done
	local small = T.strlower(expack) --making lower case version of expack name for checking options
	DT.tooltip:AddLine(ExpackColor.."< ".._G["EXPANSION_NAME"..LFR.InstanceData["ExpackData"][expack].index].." >|r") --Da title!
	for i = 1, #(LFR.InstanceData["Raids"][expack]) do
		local instanceInfo = LFR.InstanceData["Raids"][expack][i]
		if LFR.db[small][instanceInfo.name] then
			DT.tooltip:AddLine(" "..SLE:GetMapInfo(instanceInfo.map, "name"))
			--Check for dungeon requirements
			if lvl >= LFR.InstanceData["ExpackData"][expack].maxLevel and ilvl >= instanceInfo.ilevel then
				LFR:GetRaidLockInfo(T.unpack(instanceInfo.dungeonIDs)) --Adding info about bosses to the tooltip for this dungeon
			else
				DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
			end
		end
	end
	--Add a separator from any possible following info
	DT.tooltip:AddLine(" ")
end

--Info about passed dungeon IDs. Don't feed map IDs, those are different.
function LFR:GetRaidLockInfo(...)
	local dungeonIDs = {...} --All provided IDs
	local numBosses = 0 --Total number of bosses in the dungeon
	local killNum = 0 --How many were already killed
	for i = 1, #dungeonIDs do
		local numEncounters = T.GetLFGDungeonNumEncounters(dungeonIDs[i])
		numBosses = numBosses + numEncounters
		for j = 1, numEncounters do
			local bossName, _, isKilled = T.GetLFGDungeonEncounterInfo(dungeonIDs[i], j);
			if IsShiftKeyDown() then --Show detailed info
				LFR:BossStatus(bossName, isKilled, isIneligible)
			else
				if (isKilled) then killNum = killNum + 1 end
			end
		end
	end
	if not IsShiftKeyDown() then --Show just killed/total
		LFR:BossCount(killNum, numBosses)
	end
end

--Injecting into tooltip
function LFR:Show()
	local lvl = T.UnitLevel("player")
	local ilvl = T.GetAverageItemLevel()
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(RAID_FINDER)
	if not LFR:CheckOptions() then
		DT.tooltip:AddLine(" "..L["You didn't select any instance to track."])
		return
	end

	--Building dungeons info
	LFR:BuildGroup("BFA", lvl, ilvl)
	LFR:BuildGroup("Legion", lvl, ilvl)
	-- LFR:BuildGroup("WoD", lvl, ilvl)
	-- LFR:BuildGroup("MoP", lvl, ilvl)
	-- LFR:BuildGroup("Cata", lvl, ilvl)
end

--Detailed info about bosses in the wing
function LFR:BossStatus(bossName, isKilled, isIneligible)
	if not bossName then return end
	if (isKilled) then
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
	elseif (isIneligible) then
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	else
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	end
end

--Da line "kill/total"
function LFR:BossCount(killNum, numBosses)
	if killNum == numBosses then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/"..numBosses, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/"..numBosses, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
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