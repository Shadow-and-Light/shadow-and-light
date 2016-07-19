local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DB = SLE:GetModule("DataBars")

--strings and shit
local COMBATLOG_XPGAIN_FIRSTPERSON, COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED = COMBATLOG_XPGAIN_FIRSTPERSON, COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED
local COMBATLOG_XPGAIN_EXHAUSTION1, COMBATLOG_XPGAIN_EXHAUSTION2, COMBATLOG_XPGAIN_EXHAUSTION4, COMBATLOG_XPGAIN_EXHAUSTION5 = COMBATLOG_XPGAIN_EXHAUSTION1, COMBATLOG_XPGAIN_EXHAUSTION2, COMBATLOG_XPGAIN_EXHAUSTION4, COMBATLOG_XPGAIN_EXHAUSTION5
local COMBATLOG_XPGAIN_EXHAUSTION1_GROUP, COMBATLOG_XPGAIN_EXHAUSTION2_GROUP, COMBATLOG_XPGAIN_EXHAUSTION4_GROUP, COMBATLOG_XPGAIN_EXHAUSTION5_GROUP = COMBATLOG_XPGAIN_EXHAUSTION1_GROUP, COMBATLOG_XPGAIN_EXHAUSTION2_GROUP, COMBATLOG_XPGAIN_EXHAUSTION4_GROUP, COMBATLOG_XPGAIN_EXHAUSTION5_GROUP
local COMBATLOG_XPGAIN_EXHAUSTION1_RAID, COMBATLOG_XPGAIN_EXHAUSTION2_RAID, COMBATLOG_XPGAIN_EXHAUSTION4_RAID, COMBATLOG_XPGAIN_EXHAUSTION5_RAID = COMBATLOG_XPGAIN_EXHAUSTION1_RAID, COMBATLOG_XPGAIN_EXHAUSTION2_RAID, COMBATLOG_XPGAIN_EXHAUSTION4_RAID, COMBATLOG_XPGAIN_EXHAUSTION5_RAID
local COMBATLOG_XPGAIN_FIRSTPERSON_GROUP, COMBATLOG_XPGAIN_FIRSTPERSON_RAID = COMBATLOG_XPGAIN_FIRSTPERSON_GROUP, COMBATLOG_XPGAIN_FIRSTPERSON_RAID
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL

DB.Exp = {
	Strings = {
		["NoName"] = {},
		["Normal"] = {},
		["Bonus"] = {},
		["BonusGroup"] = {},
		["BonusRaid"] = {},
		["Penalty"] = {},
		["PenaltyGroup"] = {},
		["PenaltyRaid"] = {},
		["FirstBonus"] = {},
		["FirstPenalty"] = {},
	},
	Styles = {
		["STYLE1"] = {
			["NoName"] = "|T"..DB.Icons.XP..":%s|t +%s",
			["Normal"] = "|T"..DB.Icons.XP..":%s|t %s: +%s",
			["Bonus"] = "|T"..DB.Icons.XP..":%s|t %s: +%s (%s %s)",
			["BonusGroup"] = "|T"..DB.Icons.XP..":%s|t %s: +%s (%s %s, +%s "..GROUP..")",
			["BonusRaid"] = "|T"..DB.Icons.XP..":%s|t %s: +%s (%s %s, -%s "..RAID..")",
			["Penalty"] = "|T"..DB.Icons.XP..":%s|t %s: +%s (-%s %s)",
			["PenaltyGroup"] = "|T"..DB.Icons.XP..":%s|t %s: +%s (-%s %s, +%s "..GROUP..")",
			["PenaltyRaid"] = "|T"..DB.Icons.XP..":%s|t %s: +%s (-%s %s, -%s "..RAID..")",
			["FirstBonus"] = "|T"..DB.Icons.XP..":%s|t %s: +%s (%s "..GROUP..")",
			["FirstPenalty"] = "|T"..DB.Icons.XP..":%s|t %s: +%s (-%s "..RAID..")",
		},
		["STYLE2"] = {
			["NoName"] = "|T"..DB.Icons.XP..":%s|t |cff0CD809+%s|r ",
			["Normal"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r",
			["Bonus"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r (|cff0CD809%s|r %s)",
			["BonusGroup"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r (|cff0CD809%s|r %s, +%s "..GROUP..")",
			["BonusRaid"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r (|cff0CD809%s|r %s, -%s "..RAID..")",
			["Penalty"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r (-%s %s)",
			["PenaltyGroup"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r (-%s %s, +%s "..GROUP..")",
			["PenaltyRaid"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r (-%s %s, -%s "..RAID..")",
			["FirstBonus"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r (%s "..GROUP..")",
			["FirstPenalty"] = "|T"..DB.Icons.XP..":%s|t %s: |cff0CD809+%s|r (-%s "..RAID..")",
		},
	}
}

local function UpdateExperience(self, event)
	if not E.db.sle.databars.exp.longtext then return end
	local bar = self.expBar

	if not T.UnitLevel('player') == MAX_PLAYER_LEVEL or not T.IsXPUserDisabled() then
		local cur, max = self:GetXP('player')
		local rested = T.GetXPExhaustion()
		local text = ''
		local textFormat = E.db.databars.experience.textFormat

		if rested and rested > 0 then
				if textFormat == 'PERCENT' then
					text = T.format('%d%%  '..L["Rested:"]..' %d%%', cur / max * 100, rested / max * 100)
				elseif textFormat == 'CURMAX' then
					text = T.format('%s - %s  '..L["Rested:"]..' %s', cur, max, rested)
				elseif textFormat == 'CURPERC' then
					text = T.format('%s - %d%%  '..L["Rested:"]..' %s [%d%%]', cur, cur / max * 100, rested, rested / max * 100)
				end
		else
				if textFormat == 'PERCENT' then
					text = T.format('%d%%', cur / max * 100)
				elseif textFormat == 'CURMAX' then
					text = T.format('%s - %s', cur, max)
				elseif textFormat == 'CURPERC' then
					text = T.format('%s - %d%%', cur, cur / max * 100)
				end
		end

		bar.text:SetText(text)
	end
end

function DB:PopulateExpPatterns()
	local symbols = {'%(','%)','%.','([-+])','|4.-;','%%[sd]','%%%d%$[sd]','%%(','%%)','%%.','%%%1','.-','(.-)','(.-)'}
	local pattern
	pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED, T.unpack(symbols));
	T.tinsert(DB.Exp.Strings.NoName, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.Normal, pattern)
	
	-- pattern = T.rgsub(COMBATLOG_XPGAIN_QUEST,T.unpack(symbols))
	-- T.tinsert(DB.Exp.Strings, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION1,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.Bonus, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION2,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.Bonus, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION4,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.Penalty, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION5,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.Penalty, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION1_GROUP,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.BonusGroup, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION2_GROUP,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.BonusGroup, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION4_GROUP,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.PenaltyGroup, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION5_GROUP,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.PenaltyGroup, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION1_RAID,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.BonusRaid, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION2_RAID,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.BonusRaid, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION4_RAID,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.PenaltyRaid, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION5_RAID,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.PenaltyRaid, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON_GROUP,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.FirstBonus, pattern)
	
	pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON_RAID,T.unpack(symbols))
	T.tinsert(DB.Exp.Strings.FirstPenalty, pattern)
	
	-- pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED_GROUP,T.unpack(symbols))
	-- T.tinsert(DB.Exp.Strings, pattern)
	
	-- pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED_RAID,T.unpack(symbols))
	-- T.tinsert(DB.Exp.Strings, pattern)
end

function DB:FilterExperience(event, message, ...)
	local name, exp, bonus, reason, addbonus
	if DB.db.exp.chatfilter.enable then
		for type, patterns in T.pairs(DB.Exp.Strings) do
			for i = 1, #patterns do
				name, exp, bonus, reason, addbonus = T.match(message, "^"..DB.Exp.Strings[type][i].."$")
				if name then
					message = T.format(DB.Exp.Styles[DB.db.exp.chatfilter.style][type] , DB.db.exp.chatfilter.iconsize, name, exp, SLE.Russian and reason or bonus, SLE.Russian and bonus or reason, addbonus)
					return false, message, ...
				end
			end
		end
		return false, message, ...
	end
	return false, message, ...
end

function DB:ExpInit()
	DB:PopulateExpPatterns()
	hooksecurefunc(E:GetModule('DataBars'), "UpdateExperience", UpdateExperience)
end