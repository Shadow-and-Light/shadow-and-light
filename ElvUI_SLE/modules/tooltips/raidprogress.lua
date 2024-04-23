local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local RP = SLE.RaidProgress
local TT = E.Tooltip

--GLOBALS: select, unpack, hooksecurefunc, AchievementFrame_DisplayComparison
local _G = _G
local format = format
local GetTime = GetTime
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local UnitExists, UnitGUID = UnitExists, UnitGUID
local utf8sub = string.utf8sub
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local HideUIPanel = HideUIPanel

RP.Cache = {}
RP.playerGUID = UnitGUID('player')
RP.highestKill = 0

RP.encounters = {
	{ -- Emerald Nightmare
		option = 'nightmare',
		statIDs = {
			--Mythic
			{ 10914, 10923, 10927, 10919, 10931, 10935, 10939 },
			-- Herioc
			{ 10913, 10922, 10926, 10917, 10930, 10934, 10938 },
			-- Normal
			{ 10912, 10921, 10925, 10916, 10929, 10933, 10937 },
			-- LFR
			{ 10911, 10920, 10924, 10915, 10928, 10932, 10936 },
		},
	},
	{ --Trial of Valor
		option = 'trial',
		statIDs = {
			--Mythic
			{ 11410, 11414, 11418 },
			-- Heroic
			{ 11409, 11413, 11417 },
			-- Normal
			{ 11408, 11412, 11416 },
			-- LFR
			{ 11407, 11411, 11415 },
		},
	},
	{ -- Nighthold
		option = 'nighthold',
		statIDs = {
			--Mythic
			{ 10943, 10947, 10951, 10955, 10960, 10964, 10968, 10972, 10976, 10980 },
			-- Heroic
			{ 10942, 10946, 10950, 10954, 10959, 10963, 10967, 10971, 10975, 10979 },
			-- Normal
			{ 10941, 10945, 10949, 10953, 10957, 10962, 10966, 10970, 10974, 10978 },
			-- LFR
			{ 10940, 10944, 10948, 10952, 10956, 10961, 10965, 10969, 10973, 10977 },
		},
	},
	{ -- Tomb of Sargeras
		option = 'sargeras',
		statIDs = {
			-- Mythic
			{ 11880, 11884, 11888, 11892, 11896, 11900, 11904, 11908, 11912 },
			-- Heroic
			{ 11879, 11883, 11887, 11891, 11895, 11899, 11903, 11907, 11911 },
			-- Normal
			{ 11878, 11882, 11886, 11890, 11894, 11898, 11902, 11906, 11910 },
			-- LFR
			{ 11877, 11881, 11885, 11889, 11893, 11897, 11901, 11905, 11909 },
		},
	},
	{ -- Antorus, the Burning Throne

		option = 'antorus',
		statIDs = {
			-- Mythic
			{ 11956, 11959, 11962, 11965, 11968, 11971, 11974, 11977, 11980, 11983, 11986 },
			-- Heroic
			{ 11955, 11958, 11961, 11964, 11967, 11970, 11973, 11976, 11979, 11982, 11985 },
			-- Normal
			{ 11954, 11957, 11960, 11963, 11966, 11969, 11972, 11975, 11978, 11981, 11984 },
			-- LFR
			{ 12117, 12118, 12119, 12120, 12121, 12122, 12123, 12124, 12125, 12126, 12127 },
		},
	},
	{ -- Uldir
		option = 'uldir',
		statIDs = {
			-- Mythic
			{ 12789, 12793, 12797, 12801, 12805, 12811, 12816, 12820 },
			-- Heroic
			{ 12788, 12792, 12796, 12800, 12804, 12810, 12815, 12819 },
			-- Normal
			{ 12787, 12791, 12795, 12799, 12803, 12809, 12814, 12818 },
			-- LFR
			{ 12786, 12790, 12794, 12798, 12802, 12808, 12813, 12817 },
		},

	},
	{ -- Dazar'Alor
		option = 'daz',
		Alliance = {
			-- Mythic
			{ 13331, 13348, 13353, 13362, 13366, 13370, 13374, 13378, 13382 },
			-- Heroic
			{ 13330, 13347, 13351, 13361, 13365, 13369, 13373, 13377, 13381 },
			-- Normal
			{ 13329, 13346, 13350, 13359, 13364, 13368, 13372, 13376, 13380 },
			-- LFR
			{ 13328, 13344, 13349, 13358, 13363, 13367, 13371, 13375, 13379 },
		},
		Horde = {
			-- Mythic
			{ 13331, 13336, 13357, 13362, 13366, 13370, 13374, 13378, 13382 },
			-- Heroic
			{ 13330, 13334, 13356, 13361, 13365, 13369, 13373, 13377, 13381 },
			-- Normal
			{ 13329, 13333, 13355, 13359, 13364, 13368, 13372, 13376, 13380 },
			-- LFR
			{ 13328, 13332, 13354, 13358, 13363, 13367, 13371, 13375, 13379 },
		},
		true,
	},
	{ -- Storm Crucible
		option = 'sc',
		statIDs = {
			-- Mythic
			{ 13407, 13413 },
			-- Heroic
			{ 13406, 13412 },
			-- Normal
			{ 13405, 13411 },
			-- LFR
			{ 13404, 13408 },
		},
	},
	{ -- Eternal Palace
		option = 'ep',
		statIDs = {
			-- Mythic
			{13590, 13594, 13598, 13603, 13607, 13611, 13615, 13619 },
			-- Heroic
			{ 13589, 13593, 13597, 13602, 13606, 13610, 13614, 13618 },
			-- Normal
			{ 13588, 13592, 13596, 13601, 13605, 13609, 13613, 13617 },
			-- LFR
			{ 13587, 13591, 13595, 13600, 13604, 13608, 13612, 13616 },
		},
	},
	{ -- Ni'alotha
		option = 'nzoth',
		statIDs = {
			-- Mythic
			{ 14082, 14094, 14098, 14105, 14110, 14115, 14120, 14211, 14126, 14130, 14134, 14138 },
			-- Heroic
			{ 14080, 14093, 14097, 14104, 14109, 14114, 14119, 14210, 14125, 14129, 14133, 14137 },
			-- Normal
			{ 14079, 14091, 14096, 14102, 14108, 14112, 14118, 14208, 14124, 14128, 14132, 14136 },
			-- LFR
			{ 14078, 14089, 14095, 14101, 14107, 14111, 14117, 14207, 14123, 14127, 14131, 14135 },
		},
	},
	{ -- CastleNathria
		option = 'nathria',
		statIDs = {
			-- Mythic
			{ 14421, 14425, 14429, 14433, 14437, 14441, 14445, 14449, 14453, 14457 },
			-- Heroic
			{ 14420, 14424, 14428, 14432, 14436, 14440, 14444, 14448, 14452, 14456 },
			-- Normal
			{ 14419, 14423, 14427, 14431, 14435, 14439, 14443, 14447, 14451, 14455 },
			-- LFR
			{ 14422, 14426, 14430, 14434, 14438, 14442, 14446, 14450, 14454, 14458 },
		},
	},
	{ -- Sanctum of Domination
		option = 'sod',
		statIDs = {
			-- Mythic
			{ 15139, 15143, 15147, 15151, 15155, 15159, 15163, 15167, 15172, 15176 },
			-- Heroic
			{ 15138, 15142, 15146, 15150, 15154, 15158, 15162, 15166, 15171, 15175 },
			-- Normal
			{ 15137, 15141, 15145, 15149, 15153, 15157, 15161, 15165, 15170, 15174 },
			-- LFR
			{ 15136, 15140, 15144, 15148, 15152, 15156, 15160, 15164, 15169, 15173 },
		}
	},
	{ -- Vault of the Incarnates
		option = 'voti',
		statIDs = {
			--* Mythic
			{ 16387, 16389, 16391, 16388, 16390, 16392, 16393, 16394 },
			--* Heroic
			{ 16379, 16381, 16383, 16380, 16382, 16384, 16385, 16386 },
			--* Normal
			{ 16371, 16373, 16375, 16372, 16374, 16376, 16377, 16378 },
			--* LFR
			{ 16359, 16362, 16367, 16361, 16366, 16368, 16369, 16370 },
		}
	},
	{ -- Aberrus, the Shadowed Crucible
		option = 'atsc',
		statIDs = {
			--* Mythic
			{ 18219, 18220, 18121, 18222, 18223, 18224, 18225, 18226, 18227 },
			--* Heroic
			{ 18210, 18211, 18212, 18213, 18214, 18215, 18216, 18217, 18218 },
			--* Normal
			{ 18189, 18190, 18191, 18192, 18194, 18195, 18196, 18197, 18198 },
			--* LFR
			{ 18180, 18181, 18182, 18183, 18184, 18185, 18186, 18188, 18187 },
		}
	},
	{ -- Amirdrassil, the Dream's Hope
		option = 'atdh',
		statIDs = {
			--* Mythic
			{ 19378, 19379, 19380, 19381, 19382, 19383, 19384, 19385, 19386 },
			--* Heroic
			{ 19369, 19370, 19371, 19372, 19373, 19374, 19375, 19376, 19377 },
			--* Normal
			{ 19360, 19361, 19362, 19363, 19364, 19365, 19366, 19367, 19368 },
			--* LFR
			{ 19348, 19352, 19353, 19354, 19355, 19356, 19357, 19358, 19359 },
		}
	},
}
RP.Raids = {}
RP.modes = {
	LONG = {
		PLAYER_DIFFICULTY6,
		PLAYER_DIFFICULTY2,
		PLAYER_DIFFICULTY1,
		PLAYER_DIFFICULTY3,
	},
	SHORT = {
		utf8sub(PLAYER_DIFFICULTY6, 1 , 1),
		utf8sub(PLAYER_DIFFICULTY2, 1 , 1),
		utf8sub(PLAYER_DIFFICULTY1, 1 , 1),
		utf8sub(PLAYER_DIFFICULTY3, 1 , 1),
	},
}

local function PopulateRaidsTable()
	RP.Raids['LONG'] = {
		SLE:GetMapInfo(777 , 'name'),
		SLE:GetMapInfo(806, 'name'),
		SLE:GetMapInfo(764, 'name'),
		SLE:GetMapInfo(850 , 'name'),
		SLE:GetMapInfo(909, 'name'),
		SLE:GetMapInfo(1148, 'name'),
		SLE:GetMapInfo(1358, 'name'),
		SLE:GetMapInfo(1345, 'name'),
		SLE:GetMapInfo(1512, 'name'),
		SLE:GetMapInfo(1580, 'name'),
		SLE:GetMapInfo(1735, 'name'),
		SLE:GetMapInfo(1998, 'name'),
		SLE:GetMapInfo(2119, 'name'),
		SLE:GetMapInfo(2166, 'name'),
		SLE:GetMapInfo(2232, 'name'),
	}
	RP.Raids['SHORT'] = {
		L["RAID_EN"],
		L["RAID_TOV"],
		L["RAID_NH"],
		L["RAID_TOS"],
		L["RAID_ANTO"],
		SLE:GetMapInfo(1148, 'name'),
		L["RAID_DAZALOR"],
		L["RAID_STORMCRUS"],
		L["RAID_ETERNALPALACE"],
		SLE:GetMapInfo(1580, 'name'),
		SLE:GetMapInfo(1735, 'name'),
		'SoD',
		'VotI',
		'ATSC',
		'ATDH',
	}
end

local kills
function RP:GetProgression(guid)

	local statFunc = guid == RP.playerGUID and GetStatistic or GetComparisonStatistic

	for raid = 1, #RP.Raids['LONG'] do
		local option = RP.encounters[raid].option
		if E.db.sle.tooltip.RaidProg.raids[option] then
			RP.Cache[guid].header[raid] = {}
			RP.Cache[guid].info[raid] = {}
			local statTable = RP.encounters[raid][E.myfaction] or RP.encounters[raid].statIDs
			for level = 1, #statTable do
				RP.highestKill = 0
				for statInfo = 1, #statTable[level] do
					kills = tonumber((statFunc(statTable[level][statInfo])))
					if kills and kills > 0 then
						RP.highestKill = RP.highestKill + 1
					end
				end
				if RP.highestKill > 0 or RP.ShowZeroesMode then
					RP.Cache[guid].header[raid][level] = format('%s [%s]:', RP.Raids[E.db.sle.tooltip.RaidProg.NameStyle][raid], RP.modes[E.db.sle.tooltip.RaidProg.DifStyle][level])
					RP.Cache[guid].info[raid][level] = format('%d/%d', RP.highestKill, #statTable[level])
					if RP.highestKill == #statTable[level] then
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
	RP.Cache[guid].timer = GetTime()

	RP:GetProgression(guid)
end

function RP:SetProgressionInfo(guid, tt)
	if RP.Cache[guid] and RP.Cache[guid].header then
		local updated = 0
		for i=1, tt:NumLines() do
			local leftTipText = _G['GameTooltipTextLeft'..i]
			for raid = 1, #RP.Raids['LONG'] do
				for level = 1, 4 do
					if (leftTipText:GetText() and leftTipText:GetText():find(RP.Raids[E.db.sle.tooltip.RaidProg.NameStyle][raid]) and leftTipText:GetText():find(RP.modes[E.db.sle.tooltip.RaidProg.DifStyle][level]) and (RP.Cache[guid].header[raid][level] and RP.Cache[guid].info[raid][level])) then
						-- update found tooltip text line
						local rightTipText = _G['GameTooltipTextRight'..i]
						leftTipText:SetText(RP.Cache[guid].header[raid][level])
						rightTipText:SetText(RP.Cache[guid].info[raid][level])
						updated = 1
					end
				end
			end
		end
		if updated == 1 then return end
		-- add progression tooltip line
		if RP.highestKill > 0 then tt:AddLine(' ') end
		for raid = 1, #RP.Raids['LONG'] do
			local option = RP.encounters[raid].option
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
	local unit = 'mouseover'
	if UnitExists(unit) then
		RP:UpdateProgression(GUID)
		_G.GameTooltip:SetUnit(unit)
	end
	ClearAchievementComparisonUnit()
	TT:UnregisterEvent('INSPECT_ACHIEVEMENT_READY')
end

local function OnInspectInfo(self, tt, unit, numTries, r, g, b)
	if InCombatLockdown() then return end
	if not E.db.sle.tooltip.RaidProg.enable then return end
	if not (unit and CanInspect(unit)) then return end

	local guid = UnitGUID(unit)
	if not RP.Cache[guid] or (GetTime() - RP.Cache[guid].timer) > 600 then
		if guid == RP.playerGUID then
			RP:UpdateProgression(guid)
		else
			ClearAchievementComparisonUnit()
			if not self.loadedComparison and select(2, C_AddOns_IsAddOnLoaded('Blizzard_AchievementUI')) then
				AchievementFrame_DisplayComparison(unit)
				HideUIPanel(_G.AchievementFrame)
				ClearAchievementComparisonUnit()
				self.loadedComparison = true
			end
			self.compareGUID = guid
			if SetAchievementComparisonUnit(unit) then
				self:RegisterEvent('INSPECT_ACHIEVEMENT_READY', AchieveReady)
			end
			return
		end
	end

	RP:SetProgressionInfo(guid, tt)
end

function RP:Initialize()
	PopulateRaidsTable()
	hooksecurefunc(TT, 'AddInspectInfo', OnInspectInfo)
end

SLE:RegisterModule(RP:GetName())
