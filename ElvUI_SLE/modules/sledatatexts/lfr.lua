local E, L, V, P, G = unpack(ElvUI);
--LFR boss status calculations--
local DT = E:GetModule('DataTexts')

local GetLFGDungeonEncounterInfo = GetLFGDungeonEncounterInfo
local AddLine = AddLine
local AddDoubleLine = AddDoubleLine
local GetMapNameByID = GetMapNameByID
local bossName, _, isKilled, isIneligible
local twipe = table.wipe

--For 4 boss raid
local function FourKill(id)
	local killNum = 0
	for i =1,4 do
		_, _, isKilled = GetLFGDungeonEncounterInfo(id, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	if killNum == 4 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/4", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/4", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

local function FourShift(id)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

--For 6 boss raid
local function SixKill(id1, id2)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	if killNum == 6 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/6", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/6", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

local function SixShift(id1, id2)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

--For 7 boss raid
local function SevenKill(id1, id2, id3)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end

	-- 3rd part
	_, _, isKilled = GetLFGDungeonEncounterInfo(id3, 7);
	if (isKilled) then
		killNum = killNum+1;
	end

	if killNum == 7 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/7", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/7", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

local function SevenShift(id1, id2, id3)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	-- 3rd part
	bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id3, 7);
	if (isKilled) then
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
	elseif ( isIneligible ) then
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	else
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	end
end

--For 8 boss raid
local function EightKill(id1, id2)
	local killNum = 0
	for i =1,4 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =5,8 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	if killNum == 8 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/8", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/8", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

local function EightShift(id1, id2)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =5,8 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

--For 10 boss raid
local function TenKill(id1, id2, id3, id4)
	local killNum = 0
	local bosses = {} --cause fuck blizz ordering
	--1st part
	bosses = {1, 2, 7}
	for i =1, #bosses do
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, bosses[i]);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	twipe(bosses)
	--2nd part
	bosses = {3, 5, 8}
	for i =1, #bosses do 
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, bosses[i]);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	twipe(bosses)
	--3rd part
	bosses = {4, 6, 9}
	for i =1, #bosses do
		_, _, isKilled = GetLFGDungeonEncounterInfo(id3, bosses[i]);
		if (isKilled) then
			killNum = killNum + 1
		end
	end

	-- 4th part
	_, _, isKilled = GetLFGDungeonEncounterInfo(id4, 10);
	if (isKilled) then
		killNum = killNum + 1
	end
	if killNum == 10 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/10", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/10", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

local function TenShift(id1, id2, id3, id4)
	
	local bosses = {} --cause fuck blizz ordering
	--1st part
	bosses = {1, 2, 7}
	for i =1, #bosses do 
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, bosses[i]);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	twipe(bosses)
	--2nd part
	bosses = {3, 5, 8}
	for i =1, #bosses do  
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, bosses[i]);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	twipe(bosses)
	--3rd part
	bosses = {4, 6, 9}
	for i =1, #bosses do   
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id3, bosses[i]);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	--4th part
	bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id4, 10);
	if (isKilled) then
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
	elseif (isIneligible) then
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	else
		DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	end
end

--For 12 boss raid
local function TwelveKill(id1, id2, id3, id4)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =7,9 do --3rd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =10,12 do --4th part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id4, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	if killNum == 12 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/12", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/12", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

local function TwelveShift(id1, id2, id3, id4)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =7,9 do --3rd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =10,12 do --4th part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id4, i);
		if bossName then
			if (isKilled) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
			elseif (isIneligible) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
			else
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
			end
		end
	end
end

--For 13 boss raid (HFC)
local function HFCKill(id1, id2, id3, id4, id5)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =7,9 do --3rd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =10,12 do --4th part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id4, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	_, _, isKilled = GetLFGDungeonEncounterInfo(id5, 13);
	if (isKilled) then
		killNum = killNum + 1
	end
	if killNum == 13 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/13", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/13", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

local function HFCShift(id1, id2, id3, id4, id5)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =7,9 do --3rd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =10,12 do --4th part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id4, i);
		if bossName then
			if (isKilled) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
			elseif (isIneligible) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
			else
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
			end
		end
	end
	bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id5, 13);
		if bossName then
			if (isKilled) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
			elseif (isIneligible) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
			else
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
			end
		end
end

--For 14 boss raid
local function FourteenKill(id1, id2, id3, id4)
	local killNum = 0
	for i =1,4 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =5,8 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =9,11 do --3rd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	for i =12,14 do --4th part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id4, i);
		if (isKilled) then
			killNum = killNum + 1
		end
	end
	if killNum == 14 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/14", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/14", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

local function FourteenShift(id1, id2, id3, id4)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =5,8 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =9,11 do --3rd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id3, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =12,14 do --4th part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id4, i);
		if (isKilled) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif (isIneligible) then
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

local function DragonSoul(id1, id2)
	if IsShiftKeyDown() then
		EightShift(id1, id2)
	else
		EightKill(id1, id2)
	end
end

local function Mogushan(id1, id2)
	if IsShiftKeyDown() then
		SixShift(id1, id2)
	else
		SixKill(id1, id2)
	end
end

local function HoF(id1, id2)
	if IsShiftKeyDown() then
		SixShift(id1, id2)
	else
		SixKill(id1, id2)
	end
end

local function ToES(id)
	if IsShiftKeyDown() then
		FourShift(id)
	else
		FourKill(id)
	end
end

local function ToT(id1, id2, id3, id4)
	if IsShiftKeyDown() then
		TwelveShift(id1, id2, id3, id4)
	else
		TwelveKill(id1, id2, id3, id4)
	end
end

local function SoO(id1, id2, id3, id4)
	if IsShiftKeyDown() then
		FourteenShift(id1, id2, id3, id4)
	else
		FourteenKill(id1, id2, id3, id4)
	end
end

local function HM(id1, id2, id3)
	if IsShiftKeyDown() then
		SevenShift(id1, id2, id3);
	else
		SevenKill(id1, id2, id3);
	end
end

local function BRF(id1, id2, id3, id4)
	if IsShiftKeyDown() then
		TenShift(id1, id2, id3, id4);
	else
		TenKill(id1, id2, id3, id4);
	end
end

local function HFC(id1, id2, id3, id4, id5)
	if IsShiftKeyDown() then
		HFCShift(id1, id2, id3, id4, id5);
	else
		HFCKill(id1, id2, id3, id4, id5);
	end
end

function DT:LFRShow()
	local lvl = UnitLevel("player")
	local ilvl = GetAverageItemLevel()
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(RAID_FINDER.." / "..L["Raid Saves"])
	if E.db.sle.lfrshow.ds then
		DT.tooltip:AddLine(" "..GetMapNameByID(824))
		if lvl == 85 and ilvl >= 372 then
			DragonSoul(416, 417)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
		if E.db.sle.lfrshow.mv then
		DT.tooltip:AddLine(" "..GetMapNameByID(896))
		if lvl == 90 and ilvl >= 460 then
			Mogushan(527, 528)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.sle.lfrshow.hof then
			DT.tooltip:AddLine(" "..GetMapNameByID(897))
		if lvl == 90 and ilvl >= 470 then
			HoF(529, 530)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.sle.lfrshow.toes then
		DT.tooltip:AddLine(" "..GetMapNameByID(886))
		if lvl == 90 and ilvl >= 470 then
			ToES(526)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.sle.lfrshow.tot then
		DT.tooltip:AddLine(" "..GetMapNameByID(930))
		if lvl == 90 and ilvl >= 480 then
			ToT(610, 611, 612, 613)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.sle.lfrshow.soo then
		DT.tooltip:AddLine(" "..GetMapNameByID(953))
		if lvl == 90 and ilvl >= 496 then
			SoO(716, 717, 724, 725)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end

	if E.db.sle.lfrshow.hm then
		DT.tooltip:AddLine(" "..GetMapNameByID(994))
		if lvl == 100 and ilvl >= 615 then
			HM(849, 850, 851);
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
	end
	
	if E.db.sle.lfrshow.brf then
		DT.tooltip:AddLine(" "..GetMapNameByID(988))
		if lvl == 100 and ilvl >= 635 then
			BRF(847, 846, 848, 823)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
	end
	
	if E.db.sle.lfrshow.hfc then
		DT.tooltip:AddLine(" "..GetMapNameByID(1026))
		if lvl == 100 and ilvl >= 650 then
			HFC(982, 983, 984, 985, 986)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
	end

	if not E.db.sle.lfrshow.ds and not E.db.sle.lfrshow.mv and not E.db.sle.lfrshow.hof and not E.db.sle.lfrshow.toes and not E.db.sle.lfrshow.tot and not E.db.sle.lfrshow.soo and not E.db.sle.lfrshow.hm and not E.db.sle.lfrshow.brf and not E.db.sle.lfrshow.hfc then
		DT.tooltip:AddLine(" "..L["You didn't select any instance to track."])
	end
end