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
		GameTooltip:AddLine(L["Bosses killed: "]..killNum.."/4", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		GameTooltip:AddLine(L["Bosses killed: "]..killNum.."/4", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function DT:FourShift(id)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id, i);
		if ( isKilled ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
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
		GameTooltip:AddLine(L["Bosses killed: "]..killNum.."/6", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		GameTooltip:AddLine(L["Bosses killed: "]..killNum.."/6", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function DT:SixShift(id1, id2)
	for i =1,3 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if ( isKilled ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =4,6 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if ( isKilled ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
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
		GameTooltip:AddLine(L["Bosses killed: "]..killNum.."/8", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		GameTooltip:AddLine(L["Bosses killed: "]..killNum.."/8", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
end

function DT:EightShift(id1, id2)
	for i =1,4 do --1st part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id1, i);
		if ( isKilled ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
	for i =5,8 do --2nd part
		bossName, _, isKilled, isIneligible = GetLFGDungeonEncounterInfo(id2, i);
		if ( isKilled ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( isIneligible ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE_INELIGIBLE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
			GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
	end
end

function DT:DragonSoul(id1, id2)
	GameTooltip:AddLine(L["LFR Dragon Soul"]) --Instance name
	if IsShiftKeyDown() then
		DT:EightShift(id1, id2)
	else
		DT:EightKill(id1, id2)
	end
end

function DT:Mogushan(id1, id2)
	GameTooltip:AddLine(L["LFR Mogu'shan Vaults"]) --Instance name
	if IsShiftKeyDown() then
		DT:SixShift(id1, id2)
	else
		DT:SixKill(id1, id2)
	end
end

function DT:HoF(id1, id2)
	GameTooltip:AddLine(L["LFR Heart of Fear"]) --Instance name
	if IsShiftKeyDown() then
		DT:SixShift(id1, id2)
	else
		DT:SixKill(id1, id2)
	end
end

function DT:ToES(id)
	GameTooltip:AddLine(L["LFR Terrace of Endless Spring"]) --Instance name
	if IsShiftKeyDown() then
		DT:FourShift(id)
	else
		DT:FourKill(id)
	end
end