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
end

local function DragonSoul()
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
end

local function Nightmare()
	if IsShiftKeyDown() then
		SevenShift(1287,1288,1289);
	else
		SevenKill(1287,1288,1289);
	end
end

local function Suramar()
	if IsShiftKeyDown() then
		TenShift(1290,1291,1292,1293);
	else
		TenKill(1290,1291,1292,1293);
	end
end

LFR.Req = {
	["Cata"] = {3, 85},
	["MoP"] = {4, 90},
	["WoD"] = {5, 100},
	["Legion"] = {6, 110},
}
LFR.Cata = {
	[1] = {
		["name"] = 'ds',
		["ilevel"] = 372,
		["map"] = 824,
		["func"] = DragonSoul,
	},
}
LFR.MoP = {
	[1] = {
		["name"] = 'mv',
		["ilevel"] = 460,
		["map"] = 896,
		["func"] = Mogushan,
	},
	[2] = {
		["name"] = 'hof',
		["ilevel"] = 470,
		["map"] = 897,
		["func"] = HoF,
	},
	[3] = {
		["name"] = 'toes',
		["ilevel"] = 470,
		["map"] = 886,
		["func"] = ToES,
	},
	[4] = {
		["name"] = 'tot',
		["ilevel"] = 480,
		["map"] = 930,
		["func"] = ToT,
	},
	[5] = {
		["name"] = 'soo',
		["ilevel"] = 496,
		["map"] = 953,
		["func"] = SoO,
	},
}
LFR.WoD = {
	[1] = {
		["name"] = 'hm',
		["ilevel"] = 615,
		["map"] = 994,
		["func"] = HM,
	},
	[2] = {
		["name"] = 'brf',
		["ilevel"] = 635,
		["map"] = 988,
		["func"] = BRF,
	},
	[3] = {
		["name"] = 'hfc',
		["ilevel"] = 650,
		["map"] = 1026,
		["func"] = HFC,
	},
}
LFR.Legion = {
	[1] = {
		["name"] = 'nightmare',
		["ilevel"] = 825,
		["map"] = 1094,
		["func"] = Nightmare,
	},
	[2] = {
		["name"] = 'palace',
		["ilevel"] = 835,
		["map"] = 1088,
		["func"] = Suramar,
	},
}

function LFR:CheckOptions()
	if LFR.db.cata.ds or LFR:CheckMoP() or LFR:CheckWoD() or LFR:CheckLegion() then return true end
	return false
end

function LFR:CheckCata()
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
end

function LFR:BuildGroup(lvl, ilvl, expack)
	local n, req = T.unpack(LFR.Req[expack])
	local small = T.strlower(expack)
	if not LFR["Check"..expack]() then return end
	DT.tooltip:AddLine(ExpackColor.."< ".._G["EXPANSION_NAME"..n].." >|r")
	for i = 1, #(LFR[expack]) do
		local db = LFR[expack][i]
		if LFR.db[small][db.name] then
			DT.tooltip:AddLine(" "..T.GetMapNameByID(db.map))
			if lvl >= req and ilvl >= db.ilevel then
				db.func()
			else
				DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
			end
		end
	end
	DT.tooltip:AddLine(" ")
end

function LFR:CheckLegion()
	for k, v in T.pairs(LFR.db.legion) do
		if v == true then
			return v
      end
	end
	return false
end

function LFR:Show()
	local lvl = T.UnitLevel("player")
	local ilvl = T.GetAverageItemLevel()
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(RAID_FINDER)
	if not LFR:CheckOptions() then
		DT.tooltip:AddLine(" "..L["You didn't select any instance to track."])
		return
	end
	LFR:BuildGroup(lvl, ilvl, "Cata")
	LFR:BuildGroup(lvl, ilvl, "MoP")
	LFR:BuildGroup(lvl, ilvl, "WoD")
	LFR:BuildGroup(lvl, ilvl, "Legion")
end

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

function LFR:BossCount(killNum, count)
	if killNum == count then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/"..count, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/"..count, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function LFR:Initialize()
	if not SLE.initialized then return end
	LFR.db = E.db.sle.lfr

	function LFR:ForUpdateAll()
		LFR.db = E.db.sle.lfr
	end
end

SLE:RegisterModule(LFR:GetName())