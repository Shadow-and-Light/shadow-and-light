local SLE, T, E, L = unpack(ElvUI_SLE)
local S = E.Skins
local module = SLE.ObjectiveTracker

module.objectiveFrames = {
	mainHeader = ObjectiveTrackerFrame,
	achievement = AchievementObjectiveTracker,
	adventure = AdventureObjectiveTracker,
	bonus = BonusObjectiveTracker,
	campaign = CampaignQuestObjectiveTracker,
	monthlyActivities = MonthlyActivitiesObjectiveTracker,
	professionsReceipe = ProfessionsRecipeTracker,
	quest = QuestObjectiveTracker,
	scenario = ScenarioObjectiveTracker,
	uiWidgets = UIWidgetObjectiveTracker, -- Maybe
	worldQuest = WorldQuestObjectiveTracker,
}
module.objectiveFramesNames = {
	mainHeader = L["All Objectives"],
	achievement = L["Achievement"],
	adventure = L["Adventure"],
	bonus = L["Bonus"],
	campaign = L["Campaign"],
	monthlyActivities = L["Monthly Activities"],
	professionsReceipe = L["Professions"],
	quest = L["Quest"],
	scenario = L["Scenario"],
	uiWidgets = L["UI Widgets"], -- Maybe
	worldQuest = L["World Quest"],
}
module.objectiveFramesReversedKeyed = {}

local function GetProgressBar(frame, key, a, b, c)
	local progressBar = frame.usedProgressBars[key]
	local bar = progressBar and progressBar.Bar
	if not bar then return end

	local dbKey = module.objectiveFramesReversedKeyed[frame]
	if not dbKey then return end

	local db = E.db.sle.objectiveTracker[dbKey]
	if not db then return end

	if not db.progressBar or not db.progressBar.text.enable then return end

	local label = bar.Label
	if label then
		label:FontTemplate(E.LSM:Fetch('font', db.progressBar.text.font), db.progressBar.text.fontSize, db.progressBar.text.fontOutline)
		label:SetTextColor(db.progressBar.text.color.r, db.progressBar.text.color.g, db.progressBar.text.color.b)
	end
end

function module:UpdateFont(dbKey, updateHeader, updateHeaderText)
	if not E.private.sle.objectiveTracker.enable then return end
	local db = E.db.sle.objectiveTracker
	if not dbKey or not module.objectiveFrames[dbKey] or not db[dbKey] then return end

	local updateAll = not updateHeader and not updateHeaderText
	local frame = module.objectiveFrames[dbKey]

	if updateHeader or updateAll then
		local text = db[dbKey].header.text
		if frame.Header and frame.Header.Text and text.enable then
			if text.fontOutline and text.fontOutline == 'SHADOW' then
				frame.Header.Text:FontTemplate(E.LSM:Fetch('font', text.font), text.fontSize, '') --! Has to be called before setting outline to 'SHADOW' so it takes effect
			end

			frame.Header.Text:FontTemplate(E.LSM:Fetch('font', text.font), text.fontSize, text.fontOutline)
			frame.Header.Text:SetTextColor(text.color.r, text.color.g, text.color.b)
		end
	end

	local headerText = db[dbKey].headerText
	if updateHeaderText or updateAll then
		if frame.usedBlocks then
			for _, v in pairs(frame.usedBlocks) do
				for _, block in pairs(v) do
					if block.HeaderText and headerText and headerText.text.enable then
						block.HeaderText:FontTemplate(E.LSM:Fetch('font', headerText.text.font), headerText.text.fontSize, headerText.text.fontOutline)
						block.HeaderText:SetTextColor(headerText.text.color.r, headerText.text.color.g, headerText.text.color.b)
					end

					local entryText = db[dbKey].entryText
					if entryText and entryText.text.enable then
						for _, entry in next, block.usedLines do
							if entry.Dash then
								entry.Dash:FontTemplate(E.LSM:Fetch('font', entryText.text.font), entryText.text.fontSize, entryText.text.fontOutline)
							end

							if entry.Text then
								entry.Text:FontTemplate(E.LSM:Fetch('font', entryText.text.font), entryText.text.fontSize, entryText.text.fontOutline)
							end
						end
					end
				end
			end
		end
	end
end

local function SetHeader(block, objectiveKey, optTemplate)
	if not block then return end

	local frame = block.parentModule
	local dbKey = module.objectiveFramesReversedKeyed[frame]
	if not dbKey then return end
	local db = E.db.sle.objectiveTracker[dbKey]
	if not db or not db.headerText or not db.headerText.text or not db.headerText.text.enable then return end

	local color = db.headerText.text.color
	block.HeaderText:SetTextColor(color.r, color.g, color.b)
end

local function GetContrastColor(color)
    -- Calculate the luminance of the input color
    local luminance = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b

    -- Define complementary color shift (slightly tinted toward a pleasant contrast)
    local shift = 0.5

    -- Adjust the contrast color based on luminance
    local contrastColor
    if luminance > 0.5 then
        -- For lighter colors, create a darker, slightly shifted contrast color
        contrastColor = {
            r = math.max(0, color.r - shift),
            g = math.max(0, color.g - shift),
            b = math.max(0, color.b - shift)
        }
    else
        -- For darker colors, create a lighter, slightly shifted contrast color
        contrastColor = {
            r = math.min(1, color.r + shift),
            g = math.min(1, color.g + shift),
            b = math.min(1, color.b + shift)
        }
    end

    return contrastColor
end

local function UpdateHighlight(block)
	if not block or not block.usedLines then return end

	local frame = block.parentModule
	local dbKey = module.objectiveFramesReversedKeyed[frame]
	if not dbKey then return end
	local db = E.db.sle.objectiveTracker[dbKey]
	if not db then return end

	local headerDefaultColor = db.headerText.text.color
	local headerHighlightColor = db.headerText.text.useBlizzardHighlight and OBJECTIVE_TRACKER_COLOR['HeaderHighlight'] or GetContrastColor(headerDefaultColor)

	if block.isHighlighted then
		headerColor = headerHighlightColor
	else
		headerColor = headerDefaultColor
	end

	if block.HeaderText and db.headerText and db.headerText.text.enable then
		block.HeaderText:SetTextColor(headerColor.r, headerColor.g, headerColor.b)
	end
end

local function GetPOIButton(block, style)
	local button = block.poiButton
	if not button then return end

	local frame = block.parentModule
	if not frame then return end

	local dbKey = module.objectiveFramesReversedKeyed[frame]
	if not dbKey then return end

	local db = E.db.sle.objectiveTracker[dbKey]
	if not db or not db.headerText then return end
	if not db.headerText.icon then return end
	local scale = db.headerText.icon.enable and db.headerText.icon.scale or 1

	button:SetScale(scale)
end

local function GetLine(block, objectiveKey, optTemplate)
	local template = optTemplate or block.parentModule.lineTemplate
	local line = block:GetExistingLine(objectiveKey)
	local frame = block.parentModule

	local dbKey = module.objectiveFramesReversedKeyed[frame]
	if not dbKey then return end

	local db = E.db.sle.objectiveTracker[dbKey]

	if line.Dash and db.entryText and db.entryText.text.enable then
		line.Dash:FontTemplate(E.LSM:Fetch('font', db.entryText.text.font), db.entryText.text.fontSize, db.entryText.text.fontOutline)
	end

	if line.Text and db.entryText and db.entryText.text.enable then
		line.Text:FontTemplate(E.LSM:Fetch('font', db.entryText.text.font), db.entryText.text.fontSize, db.entryText.text.fontOutline)
	end
end

local function GetBlock(frame, id, optTemplate)
	local template = optTemplate or frame.blockTemplate
	if not template then return end

	local block = frame.usedBlocks[template][id]
	if not block then return end

	local dbKey = module.objectiveFramesReversedKeyed[frame]
	if not dbKey then return end

	local db = E.db.sle.objectiveTracker[dbKey]
	if not db then return end

	if block.UpdateHighlight and not module:IsHooked(block, 'UpdateHighlight') then
		module:SecureHook(block, 'UpdateHighlight', UpdateHighlight)
	end

	if block.SetHeader and not module:IsHooked(block, 'SetHeader') then
		module:SecureHook(block, 'SetHeader', SetHeader)
	end

	if frame.Header and frame.Header.Text and db.header then
		if db.header.text.enable then
			frame.Header.Text:FontTemplate(E.LSM:Fetch('font', db.header.text.font), db.header.text.fontSize, db.header.text.fontOutline)
			frame.Header.Text:SetTextColor(db.header.text.color.r, db.header.text.color.g, db.header.text.color.b)
		end
	end

	if block.HeaderText and db.headerText and db.headerText.text.enable then
		block.HeaderText:FontTemplate(E.LSM:Fetch('font', db.headerText.text.font), db.headerText.text.fontSize, db.headerText.text.fontOutline)
		block.HeaderText:SetTextColor(db.headerText.text.color.r, db.headerText.text.color.g, db.headerText.text.color.b)
	end

	if block.GetPOIButton and not module:IsHooked(block, 'GetPOIButton') then
		module:SecureHook(block, 'GetPOIButton', GetPOIButton)
	end

	if block.GetLine and not module:IsHooked(block, 'GetLine') then
		module:SecureHook(block, 'GetLine', GetLine)
	end
end

function module:Initialize()
	if not E.private.sle.objectiveTracker.enable then return end

	for dbKey, frame in pairs(module.objectiveFrames) do
		module.objectiveFramesReversedKeyed[frame] = dbKey
		module:UpdateFont(dbKey)

		if frame.GetProgressBar then
			module:SecureHook(frame, 'GetProgressBar', GetProgressBar)
		end

		if frame.GetBlock then
			module:SecureHook(frame, 'GetBlock', GetBlock)
		end
	end
end

SLE:RegisterModule(module:GetName())
