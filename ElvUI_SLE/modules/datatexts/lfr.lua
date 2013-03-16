--LFR boss status calculations--
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')

--For 4 boss raid
function DT:FourKill(id)
	local killNum = 0
	for i =1,4 do
		_, _, isKilled = GetLFGDungeonEncounterInfo(id, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	if killNum == 4 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/4", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/4", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function DT:FourShift(id)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

--For 6 boss raid
function DT:SixKill(id1, id2)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	if killNum == 6 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/6", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/6", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function DT:SixShift(id1, id2)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

--For 8 boss raid
function DT:EightKill(id1, id2)
	local killNum = 0
	for i =1,4 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	for i =5,8 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	if killNum == 8 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/8", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/8", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function DT:EightShift(id1, id2)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =5,8 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

--For 12 boss raid
function DT:TwelveKill(id1, id2, id3, id4)
	local killNum = 0
	for i =1,3 do --1st part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id1, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	for i =4,6 do --2nd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id2, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	for i =7,9 do --3rd part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id3, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	for i =10,12 do --4th part
		_, _, isKilled = GetLFGDungeonEncounterInfo(id4, i);
		if ( isKilled ) then
			killNum = killNum + 1
		end
	end
	if killNum == 12 then
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/12", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		DT.tooltip:AddLine(" "..L["Bosses killed: "]..killNum.."/12", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function DT:TwelveShift(id1, id2, id3, id4)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =7,9 do --3rd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id3, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =10,12 do --4th part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id4, i);
		if ( isKilled ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			DT.tooltip:AddDoubleLine(" "..bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

function DT:DragonSoul(id1, id2)
	if IsShiftKeyDown() then
		DT:EightShift(id1, id2)
	else
		DT:EightKill(id1, id2)
	end
end

function DT:Mogushan(id1, id2)
	if IsShiftKeyDown() then
		DT:SixShift(id1, id2)
	else
		DT:SixKill(id1, id2)
	end
end

function DT:HoF(id1, id2)
	if IsShiftKeyDown() then
		DT:SixShift(id1, id2)
	else
		DT:SixKill(id1, id2)
	end
end

function DT:ToES(id)
	if IsShiftKeyDown() then
		DT:FourShift(id)
	else
		DT:FourKill(id)
	end
end

function DT:ToT(id1, id2, id3, id4)
	if IsShiftKeyDown() then
		DT:TwelveShift(id1, id2, id3, id4)
	else
		DT:TwelveKill(id1, id2, id3, id4)
	end
end

function DT:LFRShow()
	local lvl = UnitLevel("player")
	local ilvl = GetAverageItemLevel()
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(RAID_FINDER)
	if E.db.sle.lfrshow.ds then
		DT.tooltip:AddLine(" "..GetMapNameByID(824))
		if lvl == 85 and ilvl >= 372 then
			DT:DragonSoul(416, 417)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
		if E.db.sle.lfrshow.mv then
		DT.tooltip:AddLine(" "..GetMapNameByID(896))
		if lvl == 90 and ilvl >= 460 then
			DT:Mogushan(527, 528)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.sle.lfrshow.hof then
			DT.tooltip:AddLine(" "..GetMapNameByID(897))
		if lvl == 90 and ilvl >= 470 then
			DT:HoF(529, 530)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.sle.lfrshow.toes then
		DT.tooltip:AddLine(" "..GetMapNameByID(886))
		if lvl == 90 and ilvl >= 470 then
			DT:ToES(526)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.sle.lfrshow.tot then
		DT.tooltip:AddLine(" "..GetMapNameByID(930))
		if lvl == 90 and ilvl >= 480 then
			DT:ToT(610, 611, 612, 613)
		else
			DT.tooltip:AddLine(" "..L["This LFR isn't available for your level/gear."])
		end
		DT.tooltip:AddLine(" ")
	end
	if not E.db.sle.lfrshow.ds and not E.db.sle.lfrshow.mv and not E.db.sle.lfrshow.hof and not E.db.sle.lfrshow.toes and not E.db.sle.lfrshow.tot then
		DT.tooltip:AddLine(" "..L["You didn't select any instance to track."])
	end
end
