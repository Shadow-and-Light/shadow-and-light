local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DB = SLE:GetModule("DataBars")

local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL
local PVP_HONOR_PRESTIGE_AVAILABLE = PVP_HONOR_PRESTIGE_AVAILABLE
local MAX_HONOR_LEVEL = MAX_HONOR_LEVEL
local faction = UnitFactionGroup('player')
DB.Honor ={
	Styles = {
		["STYLE1"] = "%s <%s>: +%s|T%s:%s|t",
		["STYLE2"] = "%s <%s>: +"..E["media"].hexvaluecolor.."%s|r|T%s:%s|t",
		["STYLE3"] = E["media"].hexvaluecolor.."%s|r <%s>: +"..E["media"].hexvaluecolor.."%s|r|T%s:%s|t",
		["STYLE4"] = "%s <%s> +%s|T%s:%s|t",
		["STYLE5"] = "%s <%s> +"..E["media"].hexvaluecolor.."%s|r|T%s:%s|t",
		["STYLE6"] = E["media"].hexvaluecolor.."%s|r <%s> +"..E["media"].hexvaluecolor.."%s|r|T%s:%s|t",
		["STYLE7"] = "%s <%s> (%s|T%s:%s|t)",
		["STYLE8"] = "%s <%s> ("..E["media"].hexvaluecolor.."%s|r|T%s:%s|t)",
		["STYLE9"] = E["media"].hexvaluecolor.."%s|r <%s> ("..E["media"].hexvaluecolor.."%s|r|T%s:%s|t)",
	},
	AwardStyles = {
		["STYLE1"] = L["Award"]..": %s|T%s:%s|t",
		["STYLE2"] = L["Award"]..": "..E["media"].hexvaluecolor.."%s|r|T%s:%s|t",
		["STYLE3"] = "|TInterface\\Icons\\Achievement_PVP_O_15:14:14|t: %s|T%s:%s|t",
		["STYLE4"] = "|TInterface\\Icons\\Achievement_PVP_O_15:14:14|t: "..E["media"].hexvaluecolor.."%s|r|T%s:%s|t",
		["STYLE5"] = "|TInterface\\Icons\\ACHIEVEMENT_GUILDPERK_MRPOPULARITY_RANK2:14:14|t: %s|T%s:%s|t",
		["STYLE6"] = "|TInterface\\Icons\\ACHIEVEMENT_GUILDPERK_MRPOPULARITY_RANK2:14:14|t: "..E["media"].hexvaluecolor.."%s|r|T%s:%s|t",
	},
	Strings = {},
	Icon = [[Interface\AddOns\ElvUI_SLE\media\textures\]]..faction,
}

local function UpdateHonor(self, event, unit)
	if not E.db.sle.databars.honor.longtext then return end
	if event == "HONOR_PRESTIGE_UPDATE"  and unit ~= "player" then return end
	local bar = self.honorBar
	local showHonor = T.UnitLevel("player") >= MAX_PLAYER_LEVEL
	if not showHonor then
		bar:Hide()
	else
		bar:Show()

		local current = T.UnitHonor("player");
		local max = T.UnitHonorMax("player");
		local level = T.UnitHonorLevel("player");
        local levelmax = T.GetMaxPlayerHonorLevel();

		
        if (level == levelmax) then
			-- Force the bar to full for the max level
			bar.statusBar:SetMinMaxValues(0, 1)
			bar.statusBar:SetValue(1)
		else
			bar.statusBar:SetMinMaxValues(0, max)
			bar.statusBar:SetValue(current)
		end

		if self.db.honor.hideInVehicle then
			E:RegisterObjectForVehicleLock(bar, E.UIParent)
		else
			E:UnregisterObjectForVehicleLock(bar)
		end

		local text = ''
		local textFormat = self.db.honor.textFormat

		if textFormat == 'PERCENT' then
			if (T.CanPrestige()) then
				text = PVP_HONOR_PRESTIGE_AVAILABLE
			elseif (level == levelmax) then
				text = MAX_HONOR_LEVEL
			else
				text = T.format('%d%%', current / max * 100)
			end
		elseif textFormat == 'CURMAX' then
			if (T.CanPrestige()) then
				text = PVP_HONOR_PRESTIGE_AVAILABLE
			elseif (level == levelmax) then
				text = MAX_HONOR_LEVEL
			else
				text = T.format('%s - %s', current, max)
			end
		elseif textFormat == 'CURPERC' then
			if (T.CanPrestige()) then
				text = PVP_HONOR_PRESTIGE_AVAILABLE
			elseif (level == levelmax) then
				text = MAX_HONOR_LEVEL
			else
				text = T.format('%s - %d%%', current, current / max * 100)
			end
		end

		bar.text:SetText(text)
	end
end

local AwardPattern
function DB:PopulateHonorStrings()
	local symbols = {'%(','%)','%.','([-+])','|4.-;','%%[sd]','%%%d%$[sd]','%%(','%%)','%%.','%%%1','.-','(.-)','(.-)'}

	local pattern
	pattern = T.rgsub(COMBATLOG_HONORGAIN, T.unpack(symbols))
	T.tinsert(DB.Honor.Strings, pattern)

	pattern = T.rgsub(COMBATLOG_HONORGAIN_NO_RANK, T.unpack(symbols))
	T.tinsert(DB.Honor.Strings, pattern)

	AwardPattern = T.rgsub(COMBATLOG_HONORAWARD, T.unpack(symbols))
end

function DB:FilterHonor(event, message, ...)
	local name, rank, honor
	if DB.db.honor.chatfilter.enable then
		for i, v in T.ipairs(DB.Honor.Strings) do
			name, rank, honor = T.match(message,DB.Honor.Strings[i])
			if name then
				if not honor then
					honor = rank
					rank = PVP_RANK_0_0
				end
				message = T.format(DB.Honor.Styles[DB.db.honor.chatfilter.style or "STYLE1"], name, rank, honor, DB.Honor.Icon, DB.db.honor.chatfilter.iconsize)
				return false, message, ...
			end
		end
	end
	honor = T.match(message,AwardPattern)
	if honor then
		message = T.format(DB.Honor.AwardStyles[DB.db.honor.chatfilter.awardStyle or "STYLE1"], honor, DB.Honor.Icon, DB.db.honor.chatfilter.iconsize)
		return false, message, ...
	end
end

function DB:HonorInit()
	DB:PopulateHonorStrings()
	hooksecurefunc(E:GetModule('DataBars'), "UpdateHonor", UpdateHonor)
end