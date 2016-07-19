local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local RP = SLE:NewModule("RaidProgress", "AceHook-3.0", "AceEvent-3.0")
local TT = E:GetModule('Tooltip');
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL
local _G = _G
local sub = string.sub

RP.Cache = {}
RP.playerGUID = UnitGUID("player")
RP.highestKill = 0

local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit


RP.bosses = {
	{ -- HFC
		{ --Mythic
			10204, 10208, 10212, 10216, 10220, 10224, 10228, 10232, 10236, 10240, 10244, 10248, 10252,
		},
		{ -- Herioc
			10203, 10207, 10211, 10215, 10219, 10223, 10227, 10231, 10235, 10239, 10243, 10247, 10251,
		},
		{ -- Normal
			10202, 10206, 10210, 10214, 10218, 10222, 10226, 10230, 10234, 10238, 10242, 10246, 10250,
		},
		{ -- LFR
			10201, 10205, 10209, 10213, 10217, 10221, 10225, 10229, 10233, 10237, 10241, 10245, 10249,
		},
	},
	{ -- Blackrock Foundry
		{ --Mythic
			9319, 9323, 9329, 9333, 9338, 9342, 9353, 9357, 9361, 9365, 
		},
		{ -- Herioc
			9318, 9322, 9328, 9332, 9337, 9341, 9351, 9356, 9360, 9364, 
		},
		{ -- Normal
			9317, 9321, 9327, 9331, 9336, 9340, 9349, 9355, 9359, 9363, 
		},
		{ -- LFR
			9316, 9320, 9324, 9330, 9334, 9339, 9343, 9354, 9358, 9362, 
		},
	},
	{ -- HighMaul
		{ -- Mythic
			9285, 9289, 9294, 9300, 9304, 9311, 9315,
		},
		{ -- Herioc
			9284, 9288, 9293, 9298, 9303, 9310, 9314,
		},
		{ --Normal
			9282, 9287, 9292, 9297, 9302, 9308, 9313,
		},
		{ --LFR
			9280, 9286, 9290, 9295, 9301, 9306, 9312,
		},
	},
}
RP.Raids = {
	["LONG"] = {
		T.GetMapNameByID(1026),
		T.GetMapNameByID(988),
		T.GetMapNameByID(994)
	},
	["SHORT"] = {
		L["RAID_HFC"],
		L["RAID_BRF"],
		L["RAID_HM"],
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
		sub(PLAYER_DIFFICULTY6, 1 , 1),
		sub(PLAYER_DIFFICULTY2, 1 , 1),
		sub(PLAYER_DIFFICULTY1, 1 , 1),
		sub(PLAYER_DIFFICULTY3, 1 , 1),
	},
}

function RP:GetProgression(guid)
	local kills, complete, pos = 0, false, 0
	local statFunc = guid == RP.playerGUID and T.GetStatistic or T.GetComparisonStatistic
	
	for raid = 1, #RP.Raids["LONG"] do
		RP.Cache[guid].header[raid] = {}
		RP.Cache[guid].info[raid] = {}
		for level = 1, 4 do
			RP.highestKill = 0
			for statInfo = 1, #RP.bosses[raid][level] do
				kills = T.tonumber((statFunc(RP.bosses[raid][level][statInfo])))
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
			for level = 1, 4 do
				tt:AddDoubleLine(RP.Cache[guid].header[raid][level], RP.Cache[guid].info[raid][level], nil, nil, nil, 1, 1, 1)
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
				HideUIPanel(AchievementFrame)
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