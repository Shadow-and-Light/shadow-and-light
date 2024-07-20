local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Armory = SLE.Armory_Core
local SA = SLE.Armory_Stats
local M = E.Misc

local _G = _G
local math_min = math.min
local format = format
local GetAverageItemLevel, BreakUpLargeNumbers = GetAverageItemLevel, BreakUpLargeNumbers
local UnitClass = UnitClass
local GetCombatRatingBonus = GetCombatRatingBonus

local totalShown = 0
SA.OriginalPaperdollStats = E:CopyTable({}, PAPERDOLL_STATCATEGORIES)

local function CreateStatCategory(catName, text)
	local CharacterStatsPane = _G.CharacterStatsPane
	if CharacterStatsPane[catName] then return end

	CharacterStatsPane[catName] = CreateFrame('Frame', nil, CharacterStatsPane, 'CharacterStatFrameCategoryTemplate')
	CharacterStatsPane[catName].Title:SetText(text)
	CharacterStatsPane[catName]:StripTextures()
	CharacterStatsPane[catName]:CreateBackdrop('Transparent')
	CharacterStatsPane[catName].backdrop:ClearAllPoints()
	CharacterStatsPane[catName].backdrop:SetPoint('CENTER')
	CharacterStatsPane[catName].backdrop:SetWidth(150)
	CharacterStatsPane[catName].backdrop:SetHeight(18)
end

function SA:BuildNewStats()
	CreateStatCategory('OffenseCategory', STAT_CATEGORY_ATTACK)
	CreateStatCategory('DefenseCategory', DEFENSE)

	SA.AlteredPaperdollStats = {
		[1] = {
			categoryFrame = 'AttributesCategory',
			stats = {
				[1] = { stat = 'STRENGTH', primary = LE_UNIT_STAT_STRENGTH },
				[2] = { stat = 'AGILITY', primary = LE_UNIT_STAT_AGILITY },
				[3] = { stat = 'INTELLECT', primary = LE_UNIT_STAT_INTELLECT },
				[4] = { stat = 'STAMINA' },
				[5] = { stat = 'HEALTH', option = true },
				[6] = { stat = 'POWER', option = true },
				[7] = { stat = 'ALTERNATEMANA', option = true, classes = {'PRIEST', 'SHAMAN', 'DRUID'} },
				[8] = { stat = 'MOVESPEED', option = true },
			},
		},
		[2] = {
			categoryFrame = 'OffenseCategory',
			stats = {
				[1] = { stat = 'ATTACK_DAMAGE', option = true, hideAt = 0 },
				[2] = { stat = 'ATTACK_AP', option = true, hideAt = 0 },
				[3] = { stat = 'SPELLPOWER', option = true, hideAt = 0 },
				[4] = { stat = 'MANAREGEN', option = true, power = 'MANA' },
				[5] = { stat = 'ENERGY_REGEN', option = true, power = 'ENERGY', hideAt = 0, roles = {'TANK', 'DAMAGER'},  classes = {'ROUGE', 'DRUID', 'MONK'} },
				[6] = { stat = 'FOCUS_REGEN', option = true, power = 'FOCUS', hideAt = 0, classes = {'HUNTER'} },
				[7] = { stat = 'RUNE_REGEN', option = true, power = 'RUNIC_POWER', hideAt = 0, classes = {'DEATHKNIGHT'} },
				[8] = { stat = 'ATTACK_ATTACKSPEED', option = true, hideAt = 0 },
			},
		},
		[3] = {
			categoryFrame = 'EnhancementsCategory',
			stats = {
				[1] = { stat = 'CRITCHANCE', option = true, hideAt = 0 },
				[2] = { stat = 'HASTE', option = true, hideAt = 0 },
				[3] = { stat = 'MASTERY', option = true, hideAt = 0 },
				[4] = { stat = 'VERSATILITY', option = true, hideAt = 0 },
				[5] = { stat = 'LIFESTEAL', option = true, hideAt = 0 },
			},
		},
		[4] = {
			categoryFrame = 'DefenseCategory',
			stats = {
				[1] = { stat = 'ARMOR', option = true, },
				[2] = { stat = 'AVOIDANCE', option = true, hideAt = 0 },
				[3] = { stat = 'DODGE', option = true,},
				[4] = { stat = 'PARRY', option = true, hideAt = 0, },
				[5] = { stat = 'BLOCK', option = true, hideAt = 0, },
				[6] = { stat = 'STAGGER', hideAt = 0, roles = {'TANK'}, },
			},
		},
	}
end

local function BuildScrollBar() --Creating new scroll
	--Scrollframe Parent Frame
	local scrollFrameParent = CreateFrame('Frame', 'SL_Armory_ScrollParent', _G.CharacterFrameInsetRight)
	scrollFrameParent:SetSize(198, 352)
	scrollFrameParent:SetPoint('TOP', _G.CharacterFrameInsetRight, 'TOP', -4, -4)
	--Scrollframe
	local scrollFrame = CreateFrame('ScrollFrame', 'SL_Armory_ScrollFrame', scrollFrameParent)
	scrollFrame:SetPoint('TOP')
	scrollFrame:SetSize(scrollFrameParent:GetSize())

	--Scrollbar
	SA.Scrollbar = CreateFrame('Slider', nil, scrollFrame, 'UIPanelScrollBarTemplate')
	SA.Scrollbar:SetPoint('TOPLEFT', _G.CharacterFrameInsetRight, 'TOPRIGHT', -12, -20)
	SA.Scrollbar:SetPoint('BOTTOMLEFT', _G.CharacterFrameInsetRight, 'BOTTOMRIGHT', -12, 18)
	SA.Scrollbar:SetMinMaxValues(1, 2)
	SA.Scrollbar:SetValueStep(1)
	SA.Scrollbar.scrollStep = 1
	SA.Scrollbar:SetValue(0)
	SA.Scrollbar:SetWidth(8)
	SA.Scrollbar:SetScript('OnValueChanged', function(frame, value)
		local offset = value > 1 and frame:GetParent():GetVerticalScrollRange()/(totalShown*Armory.Constants.Stats.ScrollStepMultiplier) or 1
		frame:GetParent():SetVerticalScroll(value*offset)
	end)
	SLE.Skins:ConvertScrollBarToThin(SA.Scrollbar)
	SA.Scrollbar:Hide()

	SA.ScrollChild = CreateFrame('Frame', nil, scrollFrame)
	SA.ScrollChild:SetSize(scrollFrame:GetSize())
	scrollFrame:SetScrollChild(SA.ScrollChild)

	local CharacterStatsPane = _G.CharacterStatsPane
	CharacterStatsPane:ClearAllPoints()
	CharacterStatsPane:SetParent(SA.ScrollChild)
	CharacterStatsPane:SetSize(SA.ScrollChild:GetSize())
	CharacterStatsPane:SetPoint('TOP', SA.ScrollChild, 'TOP', 0, 0)

	CharacterStatsPane.ClassBackground:ClearAllPoints()
	CharacterStatsPane.ClassBackground:SetParent(_G.CharacterFrameInsetRight)
	CharacterStatsPane.ClassBackground:SetPoint('CENTER')

	-- Enable mousewheel scrolling
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript('OnMouseWheel', function(_, delta)
		local cur_val = SA.Scrollbar:GetValue()

		SA.Scrollbar:SetValue(cur_val - delta*totalShown) --This controls the speed of the scroll
	end)

	PaperDollSidebarTab1:HookScript('OnShow', function()
		scrollFrameParent:Show()
	end)

	PaperDollSidebarTab1:HookScript('OnClick', function()
		scrollFrameParent:Show()
	end)

	PaperDollSidebarTab2:HookScript('OnClick', function()
		scrollFrameParent:Hide()
	end)

	PaperDollSidebarTab3:HookScript('OnClick', function()
		scrollFrameParent:Hide()
	end)
end

local displayString = ''
function SA:UpdateCharacterItemLevel(frame, which)
	if (not E.private.sle.armory.stats.enable or not E.db.sle.armory.stats.itemLevel.enable or not E.private.skins.blizzard.character) or not frame or which ~= 'Character' then return end
	if not E.db.general.itemLevel.displayCharacterInfo then return end
	if not _G.CharacterFrame:IsShown() then return end

	SA:UpdateIlvlFont()

	local total, equipped = GetAverageItemLevel()
	local db = E.db.sle.armory.stats.itemLevel

	local r, g, b
	if db.EquippedBlizzColor then
		r, g, b = GetItemLevelColor()
	else
		r, g, b = E:ColorGradient((equipped / total), 1, 0, 0, 1, 1, 0, 0, 1, 0)
	end

	local AverageColor = db.AverageColor
	local EquippedColor = db.EquippedColor
	local equipColorStr = (db.EquippedBlizzColor or db.EquippedGradient) and E:RGBToHex(r, g, b) or E:RGBToHex(EquippedColor.r, EquippedColor.g, EquippedColor.b)
	local avgColorStr = (db.AverageBlizzColor and E:RGBToHex(GetItemLevelColor())) or E:RGBToHex(AverageColor.r, AverageColor.g, AverageColor.b)

	if db.IlvlFull then
		displayString = '%s%.2f|r |cffffffff/|r %s%.2f|r'
		frame.ItemLevelText:SetText(format(displayString, equipColorStr, equipped, avgColorStr, total))
	else
		displayString = '%s%.2f|r'
		frame.ItemLevelText:SetText(format(displayString, equipColorStr, equipped))
	end
end

local categoryYOffset, statYOffset = 0, 0
function SA:PaperDollFrame_UpdateStats()
	if (not E.private.sle.armory.stats.enable or not E.private.skins.blizzard.character) then return end
	if not _G.CharacterFrame:IsShown() then return end

	totalShown = 0
	local totalHeight = 0
	local CharacterStatsPane = _G.CharacterStatsPane

	SA:UpdateCharacterItemLevel(_G.CharacterFrame, 'Character')

	local ItemLevelCategory = CharacterStatsPane.ItemLevelCategory

	ItemLevelCategory:SetPoint('TOP', CharacterStatsPane, 'TOP', 0, 8)
	CharacterStatsPane.AttributesCategory:SetPoint('TOP', CharacterStatsPane.ItemLevelFrame, 'BOTTOM', 0, 2)

	categoryYOffset = 8
	statYOffset = 0

	ItemLevelCategory:Show() --! Shouldnt need to call this
	ItemLevelCategory.Title:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.statHeaders.font), E.db.sle.armory.stats.statHeaders.fontSize, E.db.sle.armory.stats.statHeaders.fontOutline)
	if ItemLevelCategory.backdrop then
		ItemLevelCategory.backdrop:SetHeight(E.db.sle.armory.stats.statHeaders.fontSize + 4)
	end
	CharacterStatsPane.ItemLevelFrame:Show()

	local _, powerType = UnitPowerType('player')
	local spec, role
	spec = GetSpecialization()
	if spec then
		role = GetSpecializationRole(spec)
	end

	CharacterStatsPane.statsFramePool:ReleaseAll()
	-- we need a stat frame to first do the math to know if we need to show the stat frame
	-- so effectively we'll always pre-allocate
	local statFrame = CharacterStatsPane.statsFramePool:Acquire()

	local lastAnchor
	local statLabels = {
		font = E.db.sle.armory.stats.statLabels.font,
		fontSize = E.db.sle.armory.stats.statLabels.fontSize,
		fontOutline = E.db.sle.armory.stats.statLabels.fontOutline,
	}
	local statHeaders = {
		font = E.db.sle.armory.stats.statHeaders.font,
		fontSize = E.db.sle.armory.stats.statHeaders.fontSize,
		fontOutline = E.db.sle.armory.stats.statHeaders.fontOutline,
	}

	totalHeight = 40 + CharacterStatsPane.ItemLevelFrame:GetHeight() - categoryYOffset --This changes depending on ilvl text size

	for catIndex = 1, #PAPERDOLL_STATCATEGORIES do
		local catFrame = _G['CharacterStatsPane'][PAPERDOLL_STATCATEGORIES[catIndex].categoryFrame]
		catFrame.Title:FontTemplate(E.LSM:Fetch('font', statHeaders.font), statHeaders.fontSize, statHeaders.fontOutline)
		catFrame.Background:SetHeight(statHeaders.fontSize + 4)

		local numStatInCat = 0

		for statIndex = 1, #PAPERDOLL_STATCATEGORIES[catIndex].stats do
			local stat = PAPERDOLL_STATCATEGORIES[catIndex].stats[statIndex]
			local showStat = true
			if stat.option and not E.db.sle.armory.stats.List[stat.stat] then showStat = false end
			if ( showStat and stat.primary ) then
				local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex('player')))
				if ( stat.primary ~= primaryStat ) and E.db.sle.armory.stats.OnlyPrimary then
					showStat = false
				end
			end
			if ( showStat and stat.roles ) then
				local foundRole = false
				for _, statRole in pairs(stat.roles) do
					if ( role == statRole ) then
						foundRole = true
						break
					end
				end
				if foundRole and stat.classes then
					for _, statClass in pairs(stat.classes) do
						if ( E.myclass == statClass ) then
							showStat = true
							break
						end
					end
				else
					showStat = foundRole
				end
			end
			if showStat and stat.power and stat.power ~= powerType then showStat = false end
			if ( showStat ) then
				statFrame.onEnterFunc = nil
				PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, 'player')
				statFrame.Label:FontTemplate(E.LSM:Fetch('font', statLabels.font), statLabels.fontSize, statLabels.fontOutline)
				statFrame.Value:FontTemplate(E.LSM:Fetch('font', statLabels.font), statLabels.fontSize, statLabels.fontOutline)

				if ( not stat.hideAt or stat.hideAt ~= statFrame.numericValue ) then
					if ( numStatInCat == 0 ) then
						if ( lastAnchor ) then
							catFrame:SetPoint('TOP', lastAnchor, 'BOTTOM', 0, categoryYOffset)
						end
						lastAnchor = catFrame
						statFrame:SetPoint('TOP', catFrame, 'BOTTOM', 0, 6)
					else
						statFrame:SetPoint('TOP', lastAnchor, 'BOTTOM', 0, statYOffset)
					end
					if statFrame:IsShown() then
						totalShown = totalShown + 1
						numStatInCat = numStatInCat + 1
						-- statFrame.Background:SetShown((numStatInCat % 2) == 0)
						statFrame.Background:SetShown(false)
						if statFrame.leftGrad then statFrame.leftGrad:Hide() end
						if statFrame.rightGrad then statFrame.rightGrad:Hide() end

						lastAnchor = statFrame
					end
					-- done with this stat frame, get the next one
					statFrame = CharacterStatsPane.statsFramePool:Acquire()
				end
			end
		end
		catFrame:SetShown(numStatInCat > 0)
		if numStatInCat > 0 then
			totalHeight = totalHeight + catFrame:GetHeight() - categoryYOffset + (statFrame:GetHeight() * numStatInCat) - 6 --6 is offset for every first stat in category
		end
	end
	-- release the current stat frame
	CharacterStatsPane.statsFramePool:Release(statFrame)
	if SA.Scrollbar then
		if (SLE._Compatibility['ElvUI_EltreumUI'] and E.db.ElvUI_EltreumUI.skins.classicarmory) or (totalHeight > (3 + CharacterStatsPane:GetHeight())) then --Show scrollbar if the total height of all the stats combined are more than panel height + a small offset of if Eltreum skins our skin
			SA.Scrollbar:SetMinMaxValues(1, totalShown*Armory.Constants.Stats.ScrollStepMultiplier)
			SA.Scrollbar:Show()
		else
			SA.Scrollbar:SetMinMaxValues(1, 1)
			SA.Scrollbar:Hide()
		end
		SA.Scrollbar:SetValue(SA.Scrollbar:GetValue())
	end
end

function SA:UpdateIlvlFont()
	if (not E.private.sle.armory.stats.enable or not E.private.skins.blizzard.character) then return end
	local db = E.db.sle.armory.stats.itemLevel
	local gradient = db.gradient

	local ItemLevelFrame = _G.CharacterStatsPane.ItemLevelFrame
	local showDefaultGrad = not db.enable or (db.enable and gradient.style == 'blizzard')
	if ItemLevelFrame.leftGrad then ItemLevelFrame.leftGrad:SetShown(showDefaultGrad) end
	if ItemLevelFrame.rightGrad then ItemLevelFrame.rightGrad:SetShown(showDefaultGrad) end
	if not db.enable then return end

	local font = E.LSM:Fetch('font', db.font)
	local fontSize = db.fontSize
	local fontOutline = db.fontOutline

	_G.CharacterFrame.ItemLevelText:FontTemplate(font, fontSize, fontOutline)
	ItemLevelFrame.Value:FontTemplate(font, fontSize, fontOutline)
	ItemLevelFrame:SetHeight(fontSize + 5)
	ItemLevelFrame.Background:SetHeight(fontSize + 5)
	ItemLevelFrame.Value:SetJustifyV('MIDDLE')

	if not E.db.general.itemLevel.displayCharacterInfo then
		_G.CharacterFrame.ItemLevelText:SetText('')
	end

	if SLE._Compatibility['ElvUI_EltreumUI'] and E.db.ElvUI_EltreumUI.skins.classicarmory then
		ItemLevelFrame.leftGrad:SetHeight(fontSize + 5)
		ItemLevelFrame.rightGrad:SetHeight(fontSize + 5)
		return
	end

	if gradient.style == 'levelupbg' then
		if not ItemLevelFrame.bg then
			ItemLevelFrame:LevelUpBG()
		end
		ItemLevelFrame.bg:ClearAllPoints()
		ItemLevelFrame.bg:SetPoint('CENTER')
		ItemLevelFrame.bg:Point('TOPLEFT', ItemLevelFrame, 0, 3)
		ItemLevelFrame.bg:Point('BOTTOMRIGHT', ItemLevelFrame, 0, -2)
	elseif gradient.style == 'blizzard' and (ItemLevelFrame.leftGrad or ItemLevelFrame.rightGrad) then
		ItemLevelFrame.leftGrad:SetHeight(fontSize + 5)
		ItemLevelFrame.rightGrad:SetHeight(fontSize + 5)
	end

	if ItemLevelFrame.bg then
		ItemLevelFrame.lineTop:SetShown(gradient.style == 'levelupbg')
		ItemLevelFrame.lineBottom:SetShown(gradient.style == 'levelupbg')
		ItemLevelFrame.bg:SetShown(gradient.style == 'levelupbg')
	end
end

function SA:ToggleArmory()
	if (not E.private.sle.armory.stats.enable or not E.private.skins.blizzard.character) then return end
	-- local isEnabled = E.private.sle.armory.stats.enable
	PAPERDOLL_STATCATEGORIES = SA.AlteredPaperdollStats
	_G.CharacterStatsPane.OffenseCategory:Show()
	_G.CharacterStatsPane.DefenseCategory:Show()
	_G.CharacterStatsPane.ItemLevelFrame:SetPoint('TOP', _G.CharacterStatsPane.ItemLevelCategory, 'BOTTOM', 0, 6)
	_G.CharacterFrame.ItemLevelText:SetText('')

	PaperDollFrame_UpdateStats()
	M:UpdateCharacterInfo()
	if not E.db.general.itemLevel.displayCharacterInfo then
		_G.CharacterFrame.ItemLevelText:SetText('')
	end
end

local function GetLabelReplacement(original)
	local statLocale = E.db.sle.armory.stats.textReplacements[original]
	local isReplaced = (statLocale and (statLocale ~= '' and statLocale ~= _G[original])) and true or false

	local label = isReplaced and statLocale or _G[original]

	return label, isReplaced
end

--* Attributes
--! Uses PaperDollFrame_SetStat (check for Str, Agi, Int, Sta)
local function PaperDollFrame_SetStat(statFrame, unit, statIndex) --! Text Replaced Done
	if not statIndex then return end -- just a precaution
	if unit ~= 'player' then statFrame:Hide() return end

	local label, isReplaced = GetLabelReplacement('SPELL_STAT'..statIndex..'_NAME')
	if not isReplaced then return end

	local _, effectiveStat, _, negBuff = UnitStat(unit, statIndex)
	local effectiveStatDisplay = BreakUpLargeNumbers(effectiveStat)
	if ( negBuff < 0 and not GetPVPGearStatRules() ) then
		effectiveStatDisplay = RED_FONT_COLOR_CODE..effectiveStatDisplay..FONT_COLOR_CODE_CLOSE
	end

	PaperDollFrame_SetLabelAndText(statFrame, label, effectiveStatDisplay, false, effectiveStat)
end

local function PaperDollFrame_SetHealth(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('HEALTH')
	if not isReplaced then return end

	if not unit then unit = 'player' end
	local health = UnitHealthMax(unit)
	local healthText = BreakUpLargeNumbers(health)

	PaperDollFrame_SetLabelAndText(statFrame, label, healthText, false, health)
end

local function PaperDollFrame_SetPower(statFrame, unit) --! Text Replaced Done (Maybe lol)
	if not unit then unit = 'player' end

	local _, powerToken = UnitPowerType(unit)
	if powerToken and _G[powerToken] then
		local label, isReplaced = GetLabelReplacement(powerToken)
		if not isReplaced then return end

		local power = UnitPowerMax(unit) or 0
		local powerText = BreakUpLargeNumbers(power)

		PaperDollFrame_SetLabelAndText(statFrame, label, powerText, false, power)
	end
end

local function PaperDollFrame_SetAlternateMana(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('MANA')
	if not isReplaced then return end

	if not unit then unit = player end
	local _, class = UnitClass(unit)
	if (class ~= 'DRUID' and (class ~= 'MONK' or GetSpecialization() ~= SPEC_MONK_MISTWEAVER)) then
		statFrame:Hide()
		return
	end
	local _, powerToken = UnitPowerType(unit)
	if powerToken == 'MANA' then
		statFrame:Hide()
		return
	end

	local power = UnitPowerMax(unit, 0)
	local powerText = BreakUpLargeNumbers(power)

	PaperDollFrame_SetLabelAndText(statFrame, label, powerText, false, power)
end

local function MovementSpeed_OnUpdate(statFrame) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_MOVEMENT_SPEED')
	if not isReplaced then return end

	local unit = statFrame.unit
	local _, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed(unit)
	runSpeed = runSpeed / BASE_MOVEMENT_SPEED * 100
	flightSpeed = flightSpeed / BASE_MOVEMENT_SPEED * 100
	swimSpeed = swimSpeed / BASE_MOVEMENT_SPEED * 100

	-- Pets seem to always actually use run speed
	if unit == 'pet' then
		swimSpeed = runSpeed
	end

	-- Determine whether to display running, flying, or swimming speed
	local speed = runSpeed
	local swimming = IsSwimming(unit)
	if swimming then
		speed = swimSpeed
	elseif IsFlying(unit) then
		speed = flightSpeed
	end

	-- Hack so that your speed doesn't appear to change when jumping out of the water
	if IsFalling(unit) and statFrame.wasSwimming then
		speed = swimSpeed
	end

	local valueText = format("%d%%", speed + 0.5)

	PaperDollFrame_SetLabelAndText(statFrame, label, valueText, false, speed)
end

--! Attack
--* Blizzard's local function for PaperDollFrame_SetDamage function
local function GetAppropriateDamage(unit)
	if IsRangedWeapon() then
		local _, minDamage, maxDamage, _, _, percent = UnitRangedDamage(unit)
		return minDamage, maxDamage, nil, nil, 0, 0, percent
	else
		return UnitDamage(unit)
	end
end
local function PaperDollFrame_SetDamage(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('DAMAGE')
	if not isReplaced then return end

	-- local speed, offhandSpeed = UnitAttackSpeed(unit)
	local minDamage, maxDamage, _, _, physicalBonusPos, physicalBonusNeg, percent = GetAppropriateDamage(unit)

	-- remove decimal points for display values
	local displayMin = max(floor(minDamage),1)
	local displayMinLarge = BreakUpLargeNumbers(displayMin)
	local displayMax = max(ceil(maxDamage),1)
	local displayMaxLarge = BreakUpLargeNumbers(displayMax)

	-- calculate base damage
	minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg
	maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg

	local baseDamage = (minDamage + maxDamage) * 0.5
	local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent
	local totalBonus = (fullDamage - baseDamage)
	-- set tooltip text with base damage
	-- local damageTooltip = BreakUpLargeNumbers(max(floor(minDamage),1)).." - "..BreakUpLargeNumbers(max(ceil(maxDamage),1))

	local colorPos = '|cff20ff20'
	local colorNeg = '|cffff2020'

	-- epsilon check
	if ( totalBonus < 0.1 and totalBonus > -0.1 ) then
		totalBonus = 0.0
	end

	local value
	if ( totalBonus == 0 ) then
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then
			value = displayMinLarge.." - "..displayMaxLarge
		else
			value = displayMinLarge.."-"..displayMaxLarge
		end
	else
		-- set bonus color and display
		local color
		if ( totalBonus > 0 ) then
			color = colorPos
		else
			color = colorNeg
		end
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then
			value = color..displayMinLarge.." - "..displayMaxLarge.."|r"
		else
			value = color..displayMinLarge.."-"..displayMaxLarge.."|r"
		end
	end

	PaperDollFrame_SetLabelAndText(statFrame, label, value, false, displayMax)
end

local function PaperDollFrame_SetAttackPower(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_ATTACK_POWER')
	if not isReplaced then
		label = STAT_ATTACK_POWER
	end

	local rangedWeapon = IsRangedWeapon()
	local base, posBuff, negBuff = (rangedWeapon and UnitRangedAttackPower or UnitAttackPower)('player')
	local totalAP = base + posBuff + negBuff

	statFrame.tooltip = strjoin(' ', rangedWeapon and RANGED_ATTACK_POWER or MELEE_ATTACK_POWER, BreakUpLargeNumbers(totalAP))
	statFrame.tooltip2 = format(rangedWeapon and RANGED_ATTACK_POWER_TOOLTIP or MELEE_ATTACK_POWER_TOOLTIP, BreakUpLargeNumbers(max(totalAP, 0) / ATTACK_POWER_MAGIC_NUMBER))

	if isHunter and ComputePetBonus then
		local petAPBonus = ComputePetBonus('PET_BONUS_RAP_TO_AP', totalAP)
		local petSpellDmgBonus = ComputePetBonus('PET_BONUS_RAP_TO_SPELLDMG', totalAP)

		if petAPBonus > 0 then
			statFrame.tooltip2 = strjoin('\n', statFrame.tooltip2, format(PET_BONUS_TOOLTIP_RANGED_ATTACK_POWER, petAPBonus))
		end

		if petSpellDmgBonus > 0 then
			statFrame.tooltip2 = strjoin('\n', statFrame.tooltip2, format(PET_BONUS_TOOLTIP_SPELLDAMAGE, petSpellDmgBonus))
		end
	end

	PaperDollFrame_SetLabelAndText(statFrame, label, BreakUpLargeNumbers(totalAP), false, totalAP)
end

local function SLPaperDollFrame_SetAttackSpeed(statFrame, unit) --! Text Replaced Done
	local label = GetLabelReplacement('WEAPON_SPEED')
	local meleeHaste = GetMeleeHaste()
	local speed, offhandSpeed = UnitAttackSpeed(unit)
	local displaySpeed = format("%.2F", speed)
	if ( offhandSpeed ) then
		offhandSpeed = format("%.2F", offhandSpeed)
	end

	displaySpeed = displaySpeed:gsub(',', '.')

	if ( offhandSpeed ) then
		displaySpeed =  BreakUpLargeNumbers(displaySpeed).." / ".. offhandSpeed
	else
		displaySpeed =  BreakUpLargeNumbers(displaySpeed)
	end

	PaperDollFrame_SetLabelAndText(statFrame, label, displaySpeed, false, speed)

	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..displaySpeed..FONT_COLOR_CODE_CLOSE
	statFrame.tooltip2 = format(STAT_ATTACK_SPEED_BASE_TOOLTIP, BreakUpLargeNumbers(meleeHaste))

	statFrame:Show()
end

local function PaperDollFrame_SetSpellPower(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_SPELLPOWER')
	if not isReplaced then return end

	local minModifier = 0
	if unit == 'player' then
		local holySchool = 2
		-- Start at 2 to skip physical damage
		minModifier = GetSpellBonusDamage(holySchool)

		if statFrame.bonusDamage then
			table.wipe(statFrame.bonusDamage)
		else
			statFrame.bonusDamage = {}
		end
		statFrame.bonusDamage[holySchool] = minModifier
		for i = (holySchool+1), MAX_SPELL_SCHOOLS do
			local bonusDamage = GetSpellBonusDamage(i)
			minModifier = min(minModifier, bonusDamage)
			statFrame.bonusDamage[i] = bonusDamage
		end
	elseif unit == 'pet' then
		minModifier = GetPetSpellBonusDamage()
		statFrame.bonusDamage = nil
	end

	PaperDollFrame_SetLabelAndText(statFrame, label, BreakUpLargeNumbers(minModifier), false, minModifier)
end

local function PaperDollFrame_SetManaRegen(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('MANA_REGEN')
	if not isReplaced then return end
	if unit ~= 'player' then statFrame:Hide() return end

	if not UnitHasMana('player') then
		PaperDollFrame_SetLabelAndText(statFrame, label, NOT_APPLICABLE, false, 0)
		return
	end

	local _, combat = GetManaRegen()
	-- All mana regen stats are displayed as mana/5 sec.
	combat = floor(combat * 5.0)
	local combatText = BreakUpLargeNumbers(combat)
	-- Combat mana regen is most important to the player, so we display it as the main value
	PaperDollFrame_SetLabelAndText(statFrame, label, combatText, false, combat)
end

local function PaperDollFrame_SetEnergyRegen(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_ENERGY_REGEN')
	if not isReplaced then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local _, powerToken = UnitPowerType(unit)
	if powerToken ~= 'ENERGY' then statFrame:Hide() return end

	local regenRate = GetPowerRegen()
	local regenRateText = BreakUpLargeNumbers(regenRate)
	PaperDollFrame_SetLabelAndText(statFrame, label, regenRateText, false, regenRate)
end

local function PaperDollFrame_SetFocusRegen(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_FOCUS_REGEN')
	if not isReplaced then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local _, powerToken = UnitPowerType(unit)
	if powerToken ~= 'FOCUS' then statFrame:Hide() return end

	local regenRate = GetPowerRegen()
	local regenRateText = BreakUpLargeNumbers(regenRate)
	PaperDollFrame_SetLabelAndText(statFrame, label, regenRateText, false, regenRate)
end

local function PaperDollFrame_SetRuneRegen(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_RUNE_REGEN')
	if not isReplaced then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local _, class = UnitClass(unit)
	if class ~= 'DEATHKNIGHT' then statFrame:Hide() return end

	local _, regenRate = GetRuneCooldown(1) -- Assuming they are all the same for now
	local regenRateText = (format(STAT_RUNE_REGEN_FORMAT, regenRate))
	PaperDollFrame_SetLabelAndText(statFrame, label, regenRateText, false, regenRate)
end

--! Enhancements
local function PaperDollFrame_SetCritChance(statFrame, unit) --! Text Replaced Done (Decimal Option Here)
	local label, isReplaced = GetLabelReplacement('STAT_CRITICAL_STRIKE')
	local useDecimals = E.db.sle.armory.stats.decimals
	if not isReplaced and not useDecimals then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local spellCrit, rangedCrit, meleeCrit, critChance

	-- Start at 2 to skip physical damage
	local holySchool = 2
	local minCrit = GetSpellCritChance(holySchool)
	statFrame.spellCrit = {}
	statFrame.spellCrit[holySchool] = minCrit

	for i=(holySchool+1), MAX_SPELL_SCHOOLS do
		spellCrit = GetSpellCritChance(i)
		minCrit = math_min(minCrit, spellCrit)
		statFrame.spellCrit[i] = spellCrit
	end

	spellCrit = minCrit
	rangedCrit = GetRangedCritChance()
	meleeCrit = GetCritChance()

	if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
		critChance = spellCrit
	elseif (rangedCrit >= meleeCrit) then
		critChance = rangedCrit
	else
		critChance = meleeCrit
	end

	if useDecimals then
		PaperDollFrame_SetLabelAndText(statFrame, label, format('%.2f%%', critChance), false, critChance)
	else
		PaperDollFrame_SetLabelAndText(statFrame, label, critChance, true, critChance)
	end
end

local function PaperDollFrame_SetHaste(statFrame, unit) --! Text Replaced Done (Decimal Option Here)
	local label, isReplaced = GetLabelReplacement('STAT_HASTE')
	local useDecimals = E.db.sle.armory.stats.decimals
	if not isReplaced and not useDecimals then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local haste = GetHaste()
	local hasteString = useDecimals and '%.2f%%' or '%d%%'
	local hasteValue = useDecimals and haste or (haste + 0.5)

	local hasteFormatString
	if (haste < 0) then
		hasteFormatString = RED_FONT_COLOR_CODE..'%s'..FONT_COLOR_CODE_CLOSE
	else
		hasteFormatString = '%s'
	end

	PaperDollFrame_SetLabelAndText(statFrame, label, format(hasteFormatString, format(hasteString, hasteValue)), false, haste)
end

local function PaperDollFrame_SetMastery(statFrame, unit) --! Text Replaced Done (Decimal Option Here)
	local label, isReplaced = GetLabelReplacement('STAT_MASTERY')
	local useDecimals = E.db.sle.armory.stats.decimals
	if not isReplaced and not useDecimals then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local mastery = GetMasteryEffect()

	PaperDollFrame_SetLabelAndText(statFrame, label, useDecimals and format('%.2f%%', mastery) or mastery, not useDecimals, mastery)
end

local function PaperDollFrame_SetVersatility(statFrame, unit) --! Text Replaced Done (Decimal Option Here)
	local label, isReplaced = GetLabelReplacement('STAT_VERSATILITY')
	local useDecimals = E.db.sle.armory.stats.decimals
	if not isReplaced and not useDecimals then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local versatilityDamageBonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
	local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN)

	PaperDollFrame_SetLabelAndText(statFrame, label, useDecimals and format('%.2f%%', versatilityDamageBonus)..'/'..format('%.2f%%', versatilityDamageTakenReduction) or versatilityDamageBonus, not useDecimals, versatilityDamageBonus)
end

local function PaperDollFrame_SetLifesteal(statFrame, unit) --! Text Replaced Done (Decimal Option Here)
	local label, isReplaced = GetLabelReplacement('STAT_LIFESTEAL')
	local useDecimals = E.db.sle.armory.stats.decimals
	if not isReplaced and not useDecimals then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local lifesteal = GetLifesteal()

	if useDecimals then
		PaperDollFrame_SetLabelAndText(statFrame, label, format('%.2f%%', lifesteal), false, lifesteal)
	else
		PaperDollFrame_SetLabelAndText(statFrame, label, lifesteal, true, lifesteal)
	end
end

local function PaperDollFrame_SetSpeed(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_SPEED')
	if not isReplaced then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local speed = GetSpeed()
	PaperDollFrame_SetLabelAndText(statFrame, label, speed, true, speed)
end

--! Defense
local function PaperDollFrame_SetArmor(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_ARMOR')
	if not isReplaced then return end

	local _, effectiveArmor = UnitArmor(unit)
	PaperDollFrame_SetLabelAndText(statFrame, label, BreakUpLargeNumbers(effectiveArmor), false, effectiveArmor)
end

local function PaperDollFrame_SetAvoidance(statFrame, unit) --! Text Replaced Done (Decimal Option Here)
	local label, isReplaced = GetLabelReplacement('STAT_AVOIDANCE')
	local useDecimals = E.db.sle.armory.stats.decimals
	if not isReplaced and not useDecimals then return end

	if (unit ~= 'player') then statFrame:Hide() return end

	local avoidance = GetAvoidance()

	if useDecimals then
		PaperDollFrame_SetLabelAndText(statFrame, label, format('%.2f%%', avoidance), false, avoidance)
	else
		PaperDollFrame_SetLabelAndText(statFrame, label, avoidance, true, avoidance)
	end
end

local function PaperDollFrame_SetDodge(statFrame, unit) --! Text Replaced Done (Decimal Option Here)
	local label, isReplaced = GetLabelReplacement('STAT_DODGE')
	local useDecimals = E.db.sle.armory.stats.decimals
	if not isReplaced and not useDecimals then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local chance = GetDodgeChance()

	if useDecimals then
		PaperDollFrame_SetLabelAndText(statFrame, label, format('%.2f%%', chance), false, chance)
	else
		PaperDollFrame_SetLabelAndText(statFrame, label, chance, true, chance)
	end
end

local function PaperDollFrame_SetParry(statFrame, unit) --! Text Replaced Done (Decimal Option Here)
	local label, isReplaced = GetLabelReplacement('STAT_PARRY')
	local useDecimals = E.db.sle.armory.stats.decimals
	if not isReplaced and not useDecimals then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local chance = GetParryChance()

	if useDecimals then
		PaperDollFrame_SetLabelAndText(statFrame, label, format('%.2f%%', chance), false, chance)
	else
		PaperDollFrame_SetLabelAndText(statFrame, label, chance, true, chance)
	end
end

local function PaperDollFrame_SetBlock(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_BLOCK')
	if not isReplaced then return end

	if unit ~= 'player' then statFrame:Hide() return end

	local chance = GetBlockChance()

	PaperDollFrame_SetLabelAndText(statFrame, label, chance, true, chance)
end

local function PaperDollFrame_SetStagger(statFrame, unit) --! Text Replaced Done
	local label, isReplaced = GetLabelReplacement('STAT_STAGGER')
	if not isReplaced then return end

	local stagger = C_PaperDollInfo.GetStaggerPercentage(unit)
	PaperDollFrame_SetLabelAndText(statFrame, label, BreakUpLargeNumbers(stagger), true, stagger)
end

local blizzFuncs = {
	--* Attributes
	PaperDollFrame_SetStat = PaperDollFrame_SetStat,					-- Strength, Agility, Stamina, Intellect (SPELL_STAT'..statIndex..'_NAME)
	PaperDollFrame_SetHealth = PaperDollFrame_SetHealth,				-- Health (HEALTH)
	PaperDollFrame_SetPower = PaperDollFrame_SetPower,					-- Select PowerTokens (MANA, RAGE, FOCUS, ENERGY, FURY)
	PaperDollFrame_SetAlternateMana = PaperDollFrame_SetAlternateMana,	-- Handles MANA text. Only appears for Druids when in shapeshift form (per blizzard comments in PaperDollFrame.lua)
	MovementSpeed_OnUpdate = MovementSpeed_OnUpdate,					-- Movement Speed (STAT_MOVEMENT_SPEED)
	--* Attack
	PaperDollFrame_SetDamage = PaperDollFrame_SetDamage,				-- Damage (DAMAGE)
	PaperDollFrame_SetAttackPower = PaperDollFrame_SetAttackPower,		-- Attack Power (STAT_ATTACK_POWER)
	PaperDollFrame_SetSpellPower = PaperDollFrame_SetSpellPower,		-- Spell Power (STAT_SPELLPOWER)
	PaperDollFrame_SetManaRegen = PaperDollFrame_SetManaRegen,			-- Mana Regen (MANA_REGEN)
	PaperDollFrame_SetEnergyRegen = PaperDollFrame_SetEnergyRegen,		-- Energy Regen (STAT_ENERGY_REGEN)
	PaperDollFrame_SetFocusRegen = PaperDollFrame_SetFocusRegen,		-- Focus Regen (STAT_FOCUS_REGEN)
	PaperDollFrame_SetRuneRegen = PaperDollFrame_SetRuneRegen,			-- Rune Speed (STAT_RUNE_REGEN)
	--* Enhancements
	PaperDollFrame_SetCritChance = PaperDollFrame_SetCritChance,		-- Critical Strike (STAT_CRITICAL_STRIKE)
	PaperDollFrame_SetHaste = PaperDollFrame_SetHaste,					-- Haste (STAT_HASTE)
	PaperDollFrame_SetMastery = PaperDollFrame_SetMastery,				-- Mastery (STAT_MASTERY)
	PaperDollFrame_SetVersatility = PaperDollFrame_SetVersatility,		-- Versatility (STAT_VERSATILITY)
	PaperDollFrame_SetLifesteal = PaperDollFrame_SetLifesteal,			-- Leech (STAT_LIFESTEAL)
	PaperDollFrame_SetSpeed = PaperDollFrame_SetSpeed,					-- Speed (STAT_SPEED)
	--* Defense
	PaperDollFrame_SetArmor = PaperDollFrame_SetArmor,					-- Armor (STAT_ARMOR)
	PaperDollFrame_SetAvoidance = PaperDollFrame_SetAvoidance,			-- Avoidance (STAT_AVOIDANCE)
	PaperDollFrame_SetDodge = PaperDollFrame_SetDodge,					-- Dodge (STAT_DODGE)
	PaperDollFrame_SetParry = PaperDollFrame_SetParry,					-- Parry (STAT_PARRY)
	PaperDollFrame_SetBlock = PaperDollFrame_SetBlock,					-- Block (STAT_BLOCK)
	PaperDollFrame_SetStagger = PaperDollFrame_SetStagger,				-- Stagger (STAT_STAGGER)
	--* Update Stats
	PaperDollFrame_UpdateStats = SA.PaperDollFrame_UpdateStats,
	--* Avg Item Level
	M = { UpdateCharacterInfo = SA.UpdateCharacterItemLevel, ToggleItemLevelInfo = SA.UpdateCharacterItemLevel, UpdateAverageString = SA.UpdateCharacterItemLevel},
}

function SA:ToggleFunctionHooks()
	if (not E.private.sle.armory.stats.enable or not E.private.skins.blizzard.character) then return end
	if E.private.sle.armory.stats.enable then
		PAPERDOLL_STATINFO['ATTACK_ATTACKSPEED'].updateFunc = function(statFrame, unit) SLPaperDollFrame_SetAttackSpeed(statFrame, unit); end
	end

	for k, v in pairs(blizzFuncs) do
		if type(v) == 'table' then
			for method, handler in pairs(v) do
				if not SA:IsHooked(M, method) and not SLE._Compatibility['DejaCharacterStats'] then
					SA:SecureHook(M, method, handler)
				elseif SA:IsHooked(M, method) then
					SA:Unhook(M, method)
				end
			end
		else
			if not SA:IsHooked(k) and not SLE._Compatibility['DejaCharacterStats'] then
				SA:SecureHook(k, v)
			elseif SA:IsHooked(k) then
				SA:Unhook(k)
			end
		end
	end
end

function SA:LoadAndSetup()
	if (not E.private.sle.armory.stats.enable or not E.private.skins.blizzard.character) or SLE._Compatibility['DejaCharacterStats'] then return end

	SA:ToggleFunctionHooks()
	BuildScrollBar()
	SA:BuildNewStats()
	SA:ToggleArmory()

	_G.CharacterFrame:HookScript('OnShow', SA.UpdateCharacterItemLevel)

	_G.CharacterFrame.ItemLevelText:SetText('')
end
