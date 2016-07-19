local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DB = SLE:GetModule("DataBars")

local HasArtifactEquipped = HasArtifactEquipped
local MainMenuBar_GetNumArtifactTraitsPurchasableFromXP = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP
local C_ArtifactUIGetEquippedArtifactInfo = C_ArtifactUI.GetEquippedArtifactInfo

local ARTIFACT_XP_GAIN = ARTIFACT_XP_GAIN

DB.Art = {
	Strings = {},
	Styles = {
		["STYLE1"] = "|T%s:%s|t|cffe6cc80%s|r +%s.",
		["STYLE2"] = "|T%s:%s|t|cffe6cc80%s|r |cff0CD809+%s|r.",
	},
}

local function UpdateArtifact(self, event)
	if not E.db.sle.databars.artifact.longtext then return end
	local bar = self.artifactBar
	local showArtifact = HasArtifactEquipped();
	if not showArtifact then
		bar:Hide()
	else
		bar:Show()

		if self.db.artifact.hideInVehicle then
			E:RegisterObjectForVehicleLock(bar, E.UIParent)
		else
			E:UnregisterObjectForVehicleLock(bar)
		end

		local text = ''
		local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUIGetEquippedArtifactInfo();
		local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP);
		bar.statusBar:SetMinMaxValues(0, xpForNextPoint)
		bar.statusBar:SetValue(xp)

		local textFormat = self.db.artifact.textFormat
		if textFormat == 'PERCENT' then
			text = T.format(numPointsAvailableToSpend > 0 and '%d%% (%s)' or '%d%%', xp / xpForNextPoint * 100, numPointsAvailableToSpend)
		elseif textFormat == 'CURMAX' then
			text = T.format(numPointsAvailableToSpend > 0 and '%s - %s (%s)' or '%s - %s', xp, xpForNextPoint, numPointsAvailableToSpend)
		elseif textFormat == 'CURPERC' then
			text = T.format(numPointsAvailableToSpend > 0 and '%s - %d%% (%s)' or '%s - %d%%',xp, xp / xpForNextPoint * 100, numPointsAvailableToSpend)
		end

		bar.text:SetText(text)
	end
end

function DB:PopulateArtPatterns()
	local symbols = {'%(','%)','%.','([-+])','|4.-;','%%[sd]','%%%d%$[sd]','%%(','%%)','%%.','%%%1','.-','(.-)','(.-)'}
	local pattern

	pattern = T.rgsub(ARTIFACT_XP_GAIN,T.unpack(symbols))
	T.tinsert(DB.Art.Strings, pattern)
end

function DB:FilterArtExperience(event, message, ...)
	local name, exp
	if DB.db.artifact.chatfilter.enable then
			for i = 1, #DB.Art.Strings do
				name, exp = T.match(message, DB.Art.Strings[i])
				local _, _, _, icon = C_ArtifactUIGetEquippedArtifactInfo()
				if name then
					message = T.format(DB.Art.Styles[DB.db.artifact.chatfilter.style], icon, DB.db.artifact.chatfilter.iconsize, name, exp)
					return false, message, ...
				end
			end
		return false, message, ...
	end
	return false, message, ...
end

function DB:ArtInit()
	DB:PopulateArtPatterns()
	hooksecurefunc(E:GetModule('DataBars'), "UpdateArtifact", UpdateArtifact)
end