local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DB = SLE.DataBars
local EDB = E.DataBars

local floor, format = floor, string.format
local C_AzeriteItem_GetAzeriteItemXPInfo = C_AzeriteItem.GetAzeriteItemXPInfo
local C_AzeriteItem_GetPowerLevel = C_AzeriteItem.GetPowerLevel
local C_AzeriteItem_FindActiveAzeriteItem = C_AzeriteItem.FindActiveAzeriteItem

local function AzeriteBar_Update(self, event, unit)
	if not E.db.sle.databars.azerite.longtext then return end
	if (event == 'UNIT_INVENTORY_CHANGED' and unit ~= 'player') then return end

	local bar = EDB.StatusBars.Azerite
	local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

	if azeriteItemLocation and not AzeriteUtil.IsAzeriteItemLocationBankBag(azeriteItemLocation) and (not E.db.databars.azerite.hideInCombat or not InCombatLockdown()) then
		local text = ''
		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
		local xpToNextLevel = totalLevelXP - xp
		local currentLevel = C_AzeriteItem_GetPowerLevel(azeriteItemLocation)

		local textFormat = self.db.azerite.textFormat
		if textFormat == 'PERCENT' then
			text = format('%s%% [%s]', floor(xp / totalLevelXP * 100), currentLevel)
		elseif textFormat == 'CURMAX' then
			text = format('%s - %s [%s]', xp, totalLevelXP, currentLevel)
		elseif textFormat == 'CURPERC' then
			text = format('%s - %s%% [%s]', xp, floor(xp /totalLevelXP * 100), currentLevel)
		elseif textFormat == 'CUR' then
			text = format('%s [%s]', xp, currentLevel)
		elseif textFormat == 'REM' then
			text = format('%s [%s]', xpToNextLevel, currentLevel)
		elseif textFormat == 'CURREM' then
			text = format('%s - %s [%s]', xp, xpToNextLevel, currentLevel)
		elseif textFormat == 'CURPERCREM' then
			text = format('%s - %s%% (%s) [%s]', xp, floor(xp / totalLevelXP * 100), xpToNextLevel, currentLevel)
		end

		bar.text:SetText(text)
	end
end

function DB:AzeriteInit()
	-- DB:PopulateExpPatterns()
	hooksecurefunc(EDB, 'AzeriteBar_Update', AzeriteBar_Update)
end
