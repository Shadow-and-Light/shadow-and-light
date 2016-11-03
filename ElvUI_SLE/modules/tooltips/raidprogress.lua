local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local RP = SLE:NewModule("RaidProgress", "AceHook-3.0", "AceEvent-3.0")
local TT = E:GetModule('Tooltip');
--GLOBALS: hooksecurefunc, AchievementFrame_DisplayComparison
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL
local _G = _G
local utf8sub = string.utf8sub
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local HideUIPanel = HideUIPanel

RP.Cache = {}
RP.playerGUID = UnitGUID("player")
RP.highestKill = 0

RP.bosses = {
	{ -- Emerald Nightmare
		{ --Mythic
			10914, 10923, 10927, 10919, 10931, 10935, 10939, 
		},
		{ -- Herioc
			10913, 10922, 10926, 10917, 10930, 10934, 10938, 
		},
		{ -- Normal
			10912, 10921, 10925, 10916, 10929, 10933, 10937, 
		},
		{ -- LFR
			10911, 10920, 10924, 10915, 10928, 10932, 10936, 
		},
		"nightmare",
	},
	{ --Trial of Valor
		{ --Mythic
			11410, 11414, 11418,
		},
		{ -- Herioc
			11409, 11413, 11417,
		},
		{ -- Normal
			11408, 11412, 11416,
		},
		{ -- LFR
			11407, 11411, 11415,
		},
		"trial",
	},
	{ -- Nighthold
		{ --Mythic
			10943, 10947, 10951, 10955, 10960, 10964, 10968, 10972, 10976, 10980
		},
		{ -- Herioc
			10942, 10946, 10950, 10954, 10959, 10963, 10967, 10971, 10975, 10979
		},
		{ -- Normal
			10941, 10945, 10949, 10953, 10957, 10962, 10966, 10970, 10974, 10978
		},
		{ -- LFR
			10940, 10944, 10948, 10952, 10956, 10961, 10965, 10969, 10973, 10977
		},
		"nighthold",
	},
}
RP.Raids = {
	["LONG"] = {
		T.GetMapNameByID(1094),
		T.GetMapNameByID(1114),
		T.GetMapNameByID(1088),
	},
	["SHORT"] = {
		L["RAID_EN"],
		L["RAID_TOV"],
		L["RAID_NH"],
	},
}
RP.modes = { 
	["LONG"] = {
		PLAYER_DIFFICULTY6,
		PLAYER_DIFFICULTY2, 
		PLAYER_DIFFICULTY1,
		PLAYER_DIFFICULTY3,
	},
	["SHORT"] = {
		utf8sub(PLAYER_DIFFICULTY6, 1 , 1),
		utf8sub(PLAYER_DIFFICULTY2, 1 , 1),
		utf8sub(PLAYER_DIFFICULTY1, 1 , 1),
		utf8sub(PLAYER_DIFFICULTY3, 1 , 1),
	},
}

function RP:GetProgression(guid)
	local kills, complete, pos = 0, false, 0
	local statFunc = guid == RP.playerGUID and T.GetStatistic or T.GetComparisonStatistic
	
	for raid = 1, #RP.Raids["LONG"] do
		local option = RP.bosses[raid][5]
		if E.db.sle.tooltip.RaidProg.raids[option] then
			RP.Cache[guid].header[raid] = {}
			RP.Cache[guid].info[raid] = {}
			for level = 1, 4 do
				RP.highestKill = 0
				for statInfo = 1, #RP.bosses[raid][level] do
					local bossTable = RP.bosses[raid][level][statInfo]
					kills = T.tonumber((statFunc(bossTable)))
					if kills and kills > 0 then
						RP.highestKill = RP.highestKill + 1
					end
				end
				pos = RP.highestKill
				if (RP.highestKill > 0) then
					RP.Cache[guid].header[raid][level] = T.format("%s [%s]:", RP.Raids[E.db.sle.tooltip.RaidProg.NameStyle][raid], RP.modes[E.db.sle.tooltip.RaidProg.DifStyle][level])
					RP.Cache[guid].info[raid][level] = T.format("%d/%d", RP.highestKill, #RP.bosses[raid][level])
					if RP.highestKill == #RP.bosses[raid][level] then
						break
					end
				end
			end
		end
	end
end

function RP:UpdateProgression(guid)
	RP.Cache[guid] = RP.Cache[guid] or {}
	RP.Cache[guid].header = RP.Cache[guid].header or {}
	RP.Cache[guid].info =  RP.Cache[guid].info or {}
	RP.Cache[guid].timer = T.GetTime()

	RP:GetProgression(guid)
end

function RP:SetProgressionInfo(guid, tt)
	if RP.Cache[guid] then
		local updated = 0
		for i=1, tt:NumLines() do
			local leftTipText = _G["GameTooltipTextLeft"..i]
			for raid = 1, #RP.Raids["LONG"] do
				for level = 1, 4 do
					if (leftTipText:GetText() and leftTipText:GetText():find(RP.Raids[E.db.sle.tooltip.RaidProg.NameStyle][raid]) and leftTipText:GetText():find(RP.modes[E.db.sle.tooltip.RaidProg.DifStyle][level])) then
						-- update found tooltip text line
						local rightTipText = _G["GameTooltipTextRight"..i]
						leftTipText:SetText(RP.Cache[guid].header[raid][level])
						rightTipText:SetText(RP.Cache[guid].info[raid][level])
						updated = 1
					end
				end
			end
		end
		if updated == 1 then return end
		-- add progression tooltip line
		if RP.highestKill > 0 then tt:AddLine(" ") end
		for raid = 1, #RP.Raids["LONG"] do
			local option = RP.bosses[raid][5]
			if E.db.sle.tooltip.RaidProg.raids[option] then
				for level = 1, 4 do
					tt:AddDoubleLine(RP.Cache[guid].header[raid][level], RP.Cache[guid].info[raid][level], nil, nil, nil, 1, 1, 1)
				end
			end
		end
	end
end

local function AchieveReady(event, GUID)
	if (TT.compareGUID ~= GUID) then return end
	local unit = "mouseover"
	if T.UnitExists(unit) then
		RP:UpdateProgression(GUID)
		_G["GameTooltip"]:SetUnit(unit)
	end
	ClearAchievementComparisonUnit()
	TT:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

local function OnInspectInfo(self, tt, unit, level, r, g, b, numTries)
	if T.InCombatLockdown() then return end
	if not E.db.sle.tooltip.RaidProg.enable then return end
	if not level or level < MAX_PLAYER_LEVEL then return end
	if not (unit and T.CanInspect(unit)) then return end
	
	local guid = T.UnitGUID(unit)
	if not RP.Cache[guid] or (T.GetTime() - RP.Cache[guid].timer) > 600 then
		if guid == RP.playerGUID then
			RP:UpdateProgression(guid)
		else
			ClearAchievementComparisonUnit()
			if not self.loadedComparison and T.select(2, T.IsAddOnLoaded("Blizzard_AchievementUI")) then
				AchievementFrame_DisplayComparison(unit)
				HideUIPanel(_G["AchievementFrame"])
				ClearAchievementComparisonUnit()
				self.loadedComparison = true
			end
			self.compareGUID = guid
			if SetAchievementComparisonUnit(unit) then
				self:RegisterEvent("INSPECT_ACHIEVEMENT_READY", AchieveReady)
			end
			return
		end
	end

	RP:SetProgressionInfo(guid, tt)
end

function RP:Initialize()
	hooksecurefunc(TT, 'ShowInspectInfo', OnInspectInfo) 
end

SLE:RegisterModule(RP:GetName())