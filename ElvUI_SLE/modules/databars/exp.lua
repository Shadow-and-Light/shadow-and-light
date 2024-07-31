local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DB = SLE.DataBars
local EDB = E.DataBars

--GLOBALS: unpack, select, hooksecurefunc
local format = format

local COMBATLOG_XPGAIN_FIRSTPERSON, COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED = COMBATLOG_XPGAIN_FIRSTPERSON, COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED
local COMBATLOG_XPGAIN_EXHAUSTION1, COMBATLOG_XPGAIN_EXHAUSTION2, COMBATLOG_XPGAIN_EXHAUSTION4, COMBATLOG_XPGAIN_EXHAUSTION5 = COMBATLOG_XPGAIN_EXHAUSTION1, COMBATLOG_XPGAIN_EXHAUSTION2, COMBATLOG_XPGAIN_EXHAUSTION4, COMBATLOG_XPGAIN_EXHAUSTION5
local COMBATLOG_XPGAIN_EXHAUSTION1_GROUP, COMBATLOG_XPGAIN_EXHAUSTION2_GROUP, COMBATLOG_XPGAIN_EXHAUSTION4_GROUP, COMBATLOG_XPGAIN_EXHAUSTION5_GROUP = COMBATLOG_XPGAIN_EXHAUSTION1_GROUP, COMBATLOG_XPGAIN_EXHAUSTION2_GROUP, COMBATLOG_XPGAIN_EXHAUSTION4_GROUP, COMBATLOG_XPGAIN_EXHAUSTION5_GROUP
local COMBATLOG_XPGAIN_EXHAUSTION1_RAID, COMBATLOG_XPGAIN_EXHAUSTION2_RAID, COMBATLOG_XPGAIN_EXHAUSTION4_RAID, COMBATLOG_XPGAIN_EXHAUSTION5_RAID = COMBATLOG_XPGAIN_EXHAUSTION1_RAID, COMBATLOG_XPGAIN_EXHAUSTION2_RAID, COMBATLOG_XPGAIN_EXHAUSTION4_RAID, COMBATLOG_XPGAIN_EXHAUSTION5_RAID
local COMBATLOG_XPGAIN_FIRSTPERSON_GROUP, COMBATLOG_XPGAIN_FIRSTPERSON_RAID = COMBATLOG_XPGAIN_FIRSTPERSON_GROUP, COMBATLOG_XPGAIN_FIRSTPERSON_RAID
local UnitXP, UnitXPMax, GetXPExhaustion = UnitXP, UnitXPMax, GetXPExhaustion
local GROUP, RAID = GROUP, RAID

DB.Exp = {
	Strings = {
		NoName = {},
		Normal = {},
		Bonus = {},
		BonusGroup = {},
		BonusRaid = {},
		Penalty = {},
		PenaltyGroup = {},
		PenaltyRaid = {},
		FirstBonus = {},
		FirstPenalty = {},
	},
	Styles = {
		STYLE1 = {
			NoName = '|T'..DB.Icons.XP..':%s|t +%s',
			Normal = '|T'..DB.Icons.XP..':%s|t %s: +%s',
			Bonus = '|T'..DB.Icons.XP..':%s|t %s: +%s (%s %s)',
			BonusGroup = '|T'..DB.Icons.XP..':%s|t %s: +%s (%s %s, +%s '..GROUP..')',
			BonusRaid = '|T'..DB.Icons.XP..':%s|t %s: +%s (%s %s, -%s '..RAID..')',
			Penalty = '|T'..DB.Icons.XP..':%s|t %s: +%s (-%s %s)',
			PenaltyGroup = '|T'..DB.Icons.XP..':%s|t %s: +%s (-%s %s, +%s '..GROUP..')',
			PenaltyRaid = '|T'..DB.Icons.XP..':%s|t %s: +%s (-%s %s, -%s '..RAID..')',
			FirstBonus = '|T'..DB.Icons.XP..':%s|t %s: +%s (%s '..GROUP..')',
			FirstPenalty = '|T'..DB.Icons.XP..':%s|t %s: +%s (-%s '..RAID..')',
		},
		STYLE2 = {
			NoName = '|T'..DB.Icons.XP..':%s|t |cff0CD809+%s|r ',
			Normal = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r',
			Bonus = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r (|cff0CD809%s|r %s)',
			BonusGroup = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r (|cff0CD809%s|r %s, +%s '..GROUP..')',
			BonusRaid = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r (|cff0CD809%s|r %s, -%s '..RAID..')',
			Penalty = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r (-%s %s)',
			PenaltyGroup = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r (-%s %s, +%s '..GROUP..')',
			PenaltyRaid = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r (-%s %s, -%s '..RAID..')',
			FirstBonus = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r (%s '..GROUP..')',
			FirstPenalty = '|T'..DB.Icons.XP..':%s|t %s: |cff0CD809+%s|r (-%s '..RAID..')',
		},
	}
}

local function UpdateExperience()
	if not E.db.sle.databars.experience.longtext then return end
	local bar = EDB.StatusBars.Experience
	if not bar.db.enable or bar:ShouldHide() then return end

	local CurrentXP, XPToLevel, RestedXP = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
	local textFormat = E.db.databars.experience.textFormat
	local text = ''

	if RestedXP and RestedXP > 0 then
		if textFormat == 'PERCENT' then
			text = format('%d%% R:%d%%', CurrentXP / XPToLevel * 100, RestedXP / XPToLevel * 100)
		elseif textFormat == 'CURMAX' then
			text = format('%s - %s R:%s', CurrentXP, XPToLevel, RestedXP)
		elseif textFormat == 'CURPERC' then
			text = format('%s - %d%% R:%s [%d%%]', CurrentXP, CurrentXP / XPToLevel * 100, RestedXP, RestedXP / XPToLevel * 100)
		elseif textFormat == 'CUR' then
			text = format('%s R:%s', CurrentXP, RestedXP)
		elseif textFormat == 'REM' then
			text = format('%s R:%s', XPToLevel - CurrentXP, RestedXP)
		elseif textFormat == 'CURREM' then
			text = format('%s - %s R:%s', CurrentXP, XPToLevel - CurrentXP, RestedXP)
		elseif textFormat == 'CURPERCREM' then
			text = format('%s - %d%% (%s) R:%s', CurrentXP, CurrentXP / XPToLevel * 100, XPToLevel - CurrentXP, RestedXP)
		end
	else
		if textFormat == 'PERCENT' then
			text = format('%d%%', CurrentXP / XPToLevel * 100)
		elseif textFormat == 'CURMAX' then
			text = format('%s - %s', CurrentXP, XPToLevel)
		elseif textFormat == 'CURPERC' then
			text = format('%s - %d%%', CurrentXP, CurrentXP / XPToLevel * 100)
		elseif textFormat == 'CUR' then
			text = format('%s', CurrentXP)
		elseif textFormat == 'REM' then
			text = format('%s', XPToLevel - CurrentXP)
		elseif textFormat == 'CURREM' then
			text = format('%s - %s', CurrentXP, XPToLevel - CurrentXP)
		elseif textFormat == 'CURPERCREM' then
			text = format('%s - %d%% (%s)', CurrentXP, CurrentXP / XPToLevel * 100, XPToLevel - CurrentXP)
		end
	end

	bar.text:SetText(text)
end
hooksecurefunc(EDB, 'ExperienceBar_Update', UpdateExperience)

function DB:PopulateExpPatterns()
	local symbols = {'%(', '%%(', '%)', '%%)', '%.', '%%.', '([-+])', '%%%1', '|4.-;', '.-', '%%[sd]', '(.-)', '%%%d%$[sd]', '(.-)' }
	local pattern

	pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED, unpack(symbols))
	tinsert(DB.Exp.Strings.NoName, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON, unpack(symbols))
	tinsert(DB.Exp.Strings.Normal, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION1, unpack(symbols))
	tinsert(DB.Exp.Strings.Bonus, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION2, unpack(symbols))
	tinsert(DB.Exp.Strings.Bonus, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION4, unpack(symbols))
	tinsert(DB.Exp.Strings.Penalty, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION5, unpack(symbols))
	tinsert(DB.Exp.Strings.Penalty, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION1_GROUP, unpack(symbols))
	tinsert(DB.Exp.Strings.BonusGroup, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION2_GROUP, unpack(symbols))
	tinsert(DB.Exp.Strings.BonusGroup, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION4_GROUP, unpack(symbols))
	tinsert(DB.Exp.Strings.PenaltyGroup, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION5_GROUP, unpack(symbols))
	tinsert(DB.Exp.Strings.PenaltyGroup, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION1_RAID, unpack(symbols))
	tinsert(DB.Exp.Strings.BonusRaid, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION2_RAID, unpack(symbols))
	tinsert(DB.Exp.Strings.BonusRaid, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION4_RAID, unpack(symbols))
	tinsert(DB.Exp.Strings.PenaltyRaid, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_EXHAUSTION5_RAID, unpack(symbols))
	tinsert(DB.Exp.Strings.PenaltyRaid, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON_GROUP, unpack(symbols))
	tinsert(DB.Exp.Strings.FirstBonus, pattern)

	pattern = T.rgsub(COMBATLOG_XPGAIN_FIRSTPERSON_RAID, unpack(symbols))
	tinsert(DB.Exp.Strings.FirstPenalty, pattern)
end

function DB:FilterExperience(_, message, ...)
	local name, exp, bonus, reason, addbonus
	if E.db.sle.databars.experience.chatfilter.enable then
		for type, patterns in pairs(DB.Exp.Strings) do
			for i = 1, #patterns do
				name, exp, bonus, reason, addbonus = strmatch(message, '^'..DB.Exp.Strings[type][i]..'$')
				if name then
					message = format(DB.Exp.Styles[E.db.sle.databars.experience.chatfilter.style][type], E.db.sle.databars.experience.chatfilter.iconsize, name, exp, SLE.Russian and reason or bonus, SLE.Russian and bonus or reason, addbonus)
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
end
