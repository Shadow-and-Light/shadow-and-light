local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end --Don't break korean code :D
local Armory = SLE:GetModule("Armory_Core")
local SA = SLE:NewModule("Armory_Stats") --, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
local M = E:GetModule("Misc")

local _G = _G
local math_min, math_max = math.min, math.max
local format = format
local UnitLevel, GetAverageItemLevel = UnitLevel, GetAverageItemLevel

SA.totalShown = 0
SA.OriginalPaperdollStats = PAPERDOLL_STATCATEGORIES

function SA:BuildNewStats()
	SA:CreateStatCategory("OffenseCategory", STAT_CATEGORY_ATTACK)
	SA:CreateStatCategory("DefenceCategory", DEFENSE)

	SA.AlteredPaperdollStats = {
		[1] = {
			categoryFrame = "AttributesCategory",
			stats = {
				[1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH },
				[2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY },
				[3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT },
				[4] = { stat = "STAMINA" },
				[5] = { stat = "HEALTH", option = true },
				[6] = { stat = "POWER", option = true },
				[7] = { stat = "ALTERNATEMANA", option = true, classes = {"PRIEST", "SHAMAN", "DRUID"} },
				[8] = { stat = "MOVESPEED", option = true },
			},
		},
		[2] = {
			categoryFrame = "OffenseCategory",
			stats = {
				[1] = { stat = "ATTACK_DAMAGE", option = true, hideAt = 0 },
				[2] = { stat = "ATTACK_AP", option = true, hideAt = 0 },
				[3] = { stat = "ATTACK_ATTACKSPEED", option = true, hideAt = 0 },
				[4] = { stat = "SPELLPOWER", option = true, hideAt = 0 },
				[5] = { stat = "MANAREGEN", option = true, power = "MANA" },
				[6] = { stat = "ENERGY_REGEN", option = true, power = "ENERGY", hideAt = 0, roles = {"TANK", "DAMAGER"},  classes = {"ROUGE", "DRUID", "MONK"} },
				[7] = { stat = "FOCUS_REGEN", option = true, power = "FOCUS", hideAt = 0, classes = {"HUNTER"} },
				[8] = { stat = "RUNE_REGEN", option = true, power = "RUNIC_POWER", hideAt = 0, classes = {"DEATHKNIGHT"} },
			},
		},
		[3] = {
			categoryFrame = "EnhancementsCategory",
			stats = {
				[1] = { stat = "CRITCHANCE", option = true, hideAt = 0 },
				[2] = { stat = "HASTE", option = true, hideAt = 0 },
				[3] = { stat = "MASTERY", option = true, hideAt = 0 },
				[4] = { stat = "VERSATILITY", option = true, hideAt = 0 },
				[5] = { stat = "LIFESTEAL", option = true, hideAt = 0 },
			},
		},
		[4] = {
			categoryFrame = "DefenceCategory",
			stats = {
				[1] = { stat = "ARMOR", option = true, },
				[2] = { stat = "AVOIDANCE", option = true, hideAt = 0 },
				[3] = { stat = "DODGE", option = true,},
				[4] = { stat = "PARRY", option = true, hideAt = 0, },
				[5] = { stat = "BLOCK", option = true, hideAt = 0, },
				[6] = { stat = "STAGGER", hideAt = 0, roles = {"TANK"}, classes = {"MONK"} },
			},
		},
	}
end

function SA:CreateStatCategory(catName, text, noop)
	if not _G["CharacterStatsPane"][catName] then
		_G["CharacterStatsPane"][catName] = CreateFrame("Frame", nil, _G["CharacterStatsPane"], "CharacterStatFrameCategoryTemplate")
		_G["CharacterStatsPane"][catName].Title:SetText(text)
		_G["CharacterStatsPane"][catName]:StripTextures()
		_G["CharacterStatsPane"][catName]:CreateBackdrop("Transparent")
		_G["CharacterStatsPane"][catName].backdrop:ClearAllPoints()
		_G["CharacterStatsPane"][catName].backdrop:SetPoint("CENTER")
		_G["CharacterStatsPane"][catName].backdrop:SetWidth(150)
		_G["CharacterStatsPane"][catName].backdrop:SetHeight(18)
	end
	return catName
end

function SA:BuildScrollBar() --Creating new scroll
	--Scrollframe Parent Frame
	SA.ScrollframeParentFrame = CreateFrame("Frame", nil, _G["CharacterFrameInsetRight"])
	SA.ScrollframeParentFrame:SetSize(198, 352)
	SA.ScrollframeParentFrame:SetPoint("TOP",  _G["CharacterFrameInsetRight"], "TOP", 0, -4)

	--Scrollframe
	SA.ScrollFrame = CreateFrame("ScrollFrame", "SLE_Armory_Scroll", SA.ScrollframeParentFrame)
	SA.ScrollFrame:SetPoint("TOP")
	SA.ScrollFrame:SetSize(SA.ScrollframeParentFrame:GetSize())

	--Scrollbar
	SA.Scrollbar = CreateFrame("Slider", nil, SA.ScrollFrame, "UIPanelScrollBarTemplate")
	SA.Scrollbar:SetPoint("TOPLEFT",  _G["CharacterFrameInsetRight"], "TOPRIGHT", -12, -20)
	SA.Scrollbar:SetPoint("BOTTOMLEFT",  _G["CharacterFrameInsetRight"], "BOTTOMRIGHT", -12, 18)
	SA.Scrollbar:SetMinMaxValues(1, 2)
	SA.Scrollbar:SetValueStep(1)
	SA.Scrollbar.scrollStep = 1
	SA.Scrollbar:SetValue(0)
	SA.Scrollbar:SetWidth(8)
	SA.Scrollbar:SetScript("OnValueChanged", function (self, value)
		local offset = value > 1 and self:GetParent():GetVerticalScrollRange()/(SA.totalShown*Armory.Constants.Stats.ScrollStepMultiplier) or 1
		self:GetParent():SetVerticalScroll(value*offset)
	end)
	E:GetModule("Skins"):HandleScrollBar(SA.Scrollbar)
	SA.Scrollbar:Hide()

	--SA.ScrollChild Frame
	SA.ScrollChild = CreateFrame("Frame", nil, SA.ScrollFrame)
	SA.ScrollChild:SetSize(SA.ScrollFrame:GetSize())
	SA.ScrollFrame:SetScrollChild(SA.ScrollChild)

	CharacterStatsPane:ClearAllPoints()
	CharacterStatsPane:SetParent(SA.ScrollChild)
	CharacterStatsPane:SetSize(SA.ScrollChild:GetSize())
	CharacterStatsPane:SetPoint("TOP", SA.ScrollChild, "TOP", 0, 0)

	CharacterStatsPane.ClassBackground:ClearAllPoints()
	CharacterStatsPane.ClassBackground:SetParent( _G["CharacterFrameInsetRight"])
	CharacterStatsPane.ClassBackground:SetPoint("CENTER")

	-- Enable mousewheel scrolling
	SA.ScrollFrame:EnableMouseWheel(true)
	SA.ScrollFrame:SetScript("OnMouseWheel", function(self, delta)
		local cur_val = SA.Scrollbar:GetValue()

		SA.Scrollbar:SetValue(cur_val - delta*SA.totalShown) --This controls the speed of the scroll
	end)

	PaperDollSidebarTab1:HookScript("OnShow", function(self,event)
		SA.ScrollframeParentFrame:Show()
	end)

	PaperDollSidebarTab1:HookScript("OnClick", function(self,event)
		SA.ScrollframeParentFrame:Show()
	end)

	PaperDollSidebarTab2:HookScript("OnClick", function(self,event)
		SA.ScrollframeParentFrame:Hide()
	end)

	PaperDollSidebarTab3:HookScript("OnClick", function(self,event)
		SA.ScrollframeParentFrame:Hide()
	end)
end

function SA:UpdateCharacterItemLevel()
	SA:UpdateIlvlFont()
	if not E.db.sle.armory.stats.enable then return end
	local total, equipped = GetAverageItemLevel()
	if E.db.sle.armory.stats.IlvlFull then
		if E.db.sle.armory.stats.IlvlColor then
			local R, G, B = E:ColorGradient((equipped / total), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			local avColor = E.db.sle.armory.stats.AverageColor
			_G["CharacterFrame"].ItemLevelText:SetFormattedText("%s%.2f|r |cffffffff/|r %s%.2f|r", E:RGBToHex(R, G, B), equipped, E:RGBToHex(avColor.r, avColor.g, avColor.b), total)
		else
			_G["CharacterFrame"].ItemLevelText:SetFormattedText("%.2f / %.2f", equipped, total)
		end
	end
end

function SA:PaperDollFrame_UpdateStats()
	SA.totalShown = 0
	if E.db.sle.armory.stats.enable then
		local total, equipped = GetAverageItemLevel()
		if E.db.sle.armory.stats.IlvlFull then
			if E.db.sle.armory.stats.IlvlColor then
				local R, G, B = E:ColorGradient((equipped / total), 1, 0, 0, 1, 1, 0, 0, 1, 0)
				local avColor = E.db.sle.armory.stats.AverageColor
				_G["CharacterStatsPane"].ItemLevelFrame.Value:SetFormattedText("%s%.2f|r |cffffffff/|r %s%.2f|r", E:RGBToHex(R, G, B), equipped, E:RGBToHex(avColor.r, avColor.g, avColor.b), total)
			else
				_G["CharacterStatsPane"].ItemLevelFrame.Value:SetFormattedText("%.2f / %.2f", equipped, total)
			end
		else
			_G["CharacterStatsPane"].ItemLevelFrame.Value:SetTextColor(GetItemLevelColor())
			PaperDollFrame_SetItemLevel(_G["CharacterStatsPane"].ItemLevelFrame, "player");
		end

		_G["CharacterStatsPane"].ItemLevelCategory:SetPoint("TOP", _G["CharacterStatsPane"], "TOP", 0, 8)
		_G["CharacterStatsPane"].AttributesCategory:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelFrame, "BOTTOM", 0, 6)

		local categoryYOffset = 8;
		local statYOffset = 0;

	end
	_G["CharacterStatsPane"].ItemLevelCategory:Show();
	_G["CharacterStatsPane"].ItemLevelCategory.Title:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.enable and E.db.sle.armory.stats.catFonts.font or E.db.general.itemLevel.itemLevelFont), E.db.sle.armory.stats.enable and E.db.sle.armory.stats.catFonts.size or (E.db.general.itemLevel.itemLevelFontSize or 12), E.db.sle.armory.stats.enable and E.db.sle.armory.stats.catFonts.outline or NONE)
	_G["CharacterStatsPane"].ItemLevelFrame:Show();

	local spec = GetSpecialization();
	local role = GetSpecializationRole(spec);
	local _, powerType = UnitPowerType("player")
	-- print(GetSpecializationInfo(spec))

	_G["CharacterStatsPane"].statsFramePool:ReleaseAll();
	-- we need a stat frame to first do the math to know if we need to show the stat frame
	-- so effectively we'll always pre-allocate
	local statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire();

	local lastAnchor;
	for catIndex = 1, #PAPERDOLL_STATCATEGORIES do
		local catFrame = _G["CharacterStatsPane"][PAPERDOLL_STATCATEGORIES[catIndex].categoryFrame];
		catFrame.Title:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.enable and E.db.sle.armory.stats.catFonts.font or E.db.general.itemLevel.itemLevelFont), E.db.sle.armory.stats.enable and E.db.sle.armory.stats.catFonts.size or (E.db.general.itemLevel.itemLevelFontSize or 12), E.db.sle.armory.stats.enable and E.db.sle.armory.stats.catFonts.outline or NONE)
		local numStatInCat = 0;

		for statIndex = 1, #PAPERDOLL_STATCATEGORIES[catIndex].stats do
			local stat = PAPERDOLL_STATCATEGORIES[catIndex].stats[statIndex];
			local showStat = true;
			if E.db.sle.armory.stats.enable and stat.option and not E.db.sle.armory.stats.List[stat.stat] then showStat = false end
			if ( showStat and stat.primary ) then
				local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
				if ( stat.primary ~= primaryStat ) and E.db.sle.armory.stats.OnlyPrimary then
					showStat = false;
				end
			end
			if ( showStat and stat.roles ) then
				local foundRole = false;
				for _, statRole in pairs(stat.roles) do
					if ( role == statRole ) then
						foundRole = true;
						break;
					end
				end
				if foundRole and stat.classes then
					for _, statClass in pairs(stat.classes) do
						if ( E.myclass == statClass ) then
							showStat = true;
							break;
						end
					end
				else
					showStat = foundRole;
				end
			end
			if showStat and stat.power and stat.power ~= powerType then showStat = false end
			if ( showStat ) then
				statFrame.onEnterFunc = nil;
				PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, "player");
				statFrame.Label:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.enable and  E.db.sle.armory.stats.statFonts.font or E.db.sle.armory.stats.statFonts.font), E.db.sle.armory.stats.enable and E.db.sle.armory.stats.statFonts.size or (E.db.general.itemLevel.itemLevelFontSize or 12), E.db.sle.armory.stats.enable and E.db.sle.armory.stats.statFonts.outline or NONE)
				statFrame.Value:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.enable and  E.db.sle.armory.stats.statFonts.font or E.db.sle.armory.stats.statFonts.font), E.db.sle.armory.stats.enable and E.db.sle.armory.stats.statFonts.size or (E.db.general.itemLevel.itemLevelFontSize or 12), E.db.sle.armory.stats.enable and E.db.sle.armory.stats.statFonts.outline or NONE)
				if ( not stat.hideAt or stat.hideAt ~= statFrame.numericValue ) then
					if ( numStatInCat == 0 ) then
						if ( lastAnchor ) then
							catFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, categoryYOffset);
						end
						lastAnchor = catFrame;
						statFrame:SetPoint("TOP", catFrame, "BOTTOM", 0, 6);
					else
						statFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, statYOffset);
					end
					if statFrame:IsShown() then
						SA.totalShown = SA.totalShown + 1
						numStatInCat = numStatInCat + 1;
						-- statFrame.Background:SetShown((numStatInCat % 2) == 0);
						statFrame.Background:SetShown(false)
						if statFrame.leftGrad then statFrame.leftGrad:Hide() end
						if statFrame.rightGrad then statFrame.rightGrad:Hide() end
						lastAnchor = statFrame;
					end
					-- done with this stat frame, get the next one
					statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire();
				end
			end
		end
		catFrame:SetShown(numStatInCat > 0)
	end
	-- release the current stat frame
	_G["CharacterStatsPane"].statsFramePool:Release(statFrame);
	if SA.Scrollbar then
		if SA.totalShown > 12 then
			SA.Scrollbar:SetMinMaxValues(1, SA.totalShown*Armory.Constants.Stats.ScrollStepMultiplier)
			SA.Scrollbar:Show()
		else
			SA.Scrollbar:SetMinMaxValues(1, 1)
			SA.Scrollbar:Hide()
		end
		SA.Scrollbar:SetValue(SA.Scrollbar:GetValue())
	end
end

function SA:UpdateIlvlFont()
	local db = E.db.sle.armory.stats.itemLevel
	local font, size, outline
	font = E.db.sle.armory.stats.enable and E.LSM:Fetch('font', db.font) or nil
	size = E.db.sle.armory.stats.enable and (db.size or 12) or 20
	outline = E.db.sle.armory.stats.enable and db.outline or nil

	_G["CharacterFrame"].ItemLevelText:FontTemplate(font, size, outline)

	_G["CharacterStatsPane"].ItemLevelFrame.Value:FontTemplate(font, size, outline)
	_G["CharacterStatsPane"].ItemLevelFrame:SetHeight(size)
	_G["CharacterStatsPane"].ItemLevelFrame.Background:SetHeight(size)
	if _G["CharacterStatsPane"].ItemLevelFrame.leftGrad then
		_G["CharacterStatsPane"].ItemLevelFrame.leftGrad:SetHeight(size)
		_G["CharacterStatsPane"].ItemLevelFrame.rightGrad:SetHeight(size)
	end
	if not E.db.general.itemLevel.displayCharacterInfo then
		_G["CharacterFrame"].ItemLevelText:SetText('')
	end
end

function SA:ToggleArmory()
	PAPERDOLL_STATCATEGORIES = E.db.sle.armory.stats.enable and SA.AlteredPaperdollStats or SA.OriginalPaperdollStats
	if E.db.sle.armory.stats.enable then
		_G["CharacterStatsPane"]["OffenseCategory"]:Show()
		_G["CharacterStatsPane"]["DefenceCategory"]:Show()
		_G["CharacterStatsPane"].ItemLevelFrame:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelCategory, "BOTTOM", 0, 6)
		_G["CharacterFrame"].ItemLevelText:SetText('')
		-- SA:ToggleDecimals("enable")
	else
		_G["CharacterStatsPane"]["OffenseCategory"]:Hide()
		_G["CharacterStatsPane"]["DefenceCategory"]:Hide()
		_G["CharacterStatsPane"].ItemLevelFrame:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelCategory, "BOTTOM", 0, 0)
		-- SA:ToggleDecimals("disable")
		SA.Scrollbar:Hide()
	end
	PaperDollFrame_UpdateStats()
	M:UpdateCharacterItemLevel()
	if not E.db.general.itemLevel.displayCharacterInfo then
		_G["CharacterFrame"].ItemLevelText:SetText('')
	end
	Armory:HandleCorruption()
end

--Replacing broken Blizz function and adding some decimals
function SA:ReplaceBlizzFunctions()

	function PaperDollFrame_SetAttackSpeed(statFrame, unit)
		local meleeHaste = GetMeleeHaste();
		local speed, offhandSpeed = UnitAttackSpeed(unit);
		local displaySpeedxt

		local displaySpeed =  format("%.2f", speed);
		if ( offhandSpeed ) then
			offhandSpeed = format("%.2f", offhandSpeed);
		end
		if ( offhandSpeed ) then
			displaySpeedxt =  BreakUpLargeNumbers(displaySpeed).." / ".. offhandSpeed;
		else
			displaySpeedxt =  BreakUpLargeNumbers(displaySpeed);
		end
		PaperDollFrame_SetLabelAndText(statFrame, WEAPON_SPEED, displaySpeed, false, speed);

		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..displaySpeed..FONT_COLOR_CODE_CLOSE;
		statFrame.tooltip2 = format(STAT_ATTACK_SPEED_BASE_TOOLTIP, BreakUpLargeNumbers(meleeHaste));

		statFrame:Show();
	end

	function PaperDollFrame_SetVersatility(statFrame, unit)
		if ( unit ~= "player" ) then
			statFrame:Hide();
			return;
		end

		local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE);
		local versatilityDamageBonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
		local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN);

		if E.db.sle.armory.stats.decimals then --Alters format
			PaperDollFrame_SetLabelAndText(statFrame, STAT_VERSATILITY, format("%.2f%%", versatilityDamageBonus) .. " / " .. format("%.2f%%", versatilityDamageTakenReduction), false, versatilityDamageBonus)
		else
			PaperDollFrame_SetLabelAndText(statFrame, STAT_VERSATILITY, versatilityDamageBonus, true, versatilityDamageBonus)
		end

		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(VERSATILITY_TOOLTIP_FORMAT, STAT_VERSATILITY, versatilityDamageBonus, versatilityDamageTakenReduction) .. FONT_COLOR_CODE_CLOSE;
		statFrame.tooltip2 = format(CR_VERSATILITY_TOOLTIP, versatilityDamageBonus, versatilityDamageTakenReduction, BreakUpLargeNumbers(versatility), versatilityDamageBonus, versatilityDamageTakenReduction);

		statFrame:Show();
	end

	function PaperDollFrame_SetMastery(statFrame, unit)
		if ( unit ~= "player" ) then
			statFrame:Hide();
			return;
		end
		if (UnitLevel("player") < SHOW_MASTERY_LEVEL) then
			statFrame:Hide();
			return;
		end

		local mastery = GetMasteryEffect();
		if E.db.sle.armory.stats.decimals then
			PaperDollFrame_SetLabelAndText(statFrame, STAT_MASTERY, format("%.2f%%", mastery), false, mastery)
		else
			PaperDollFrame_SetLabelAndText(statFrame, STAT_MASTERY, mastery, true, mastery)
		end
		statFrame.onEnterFunc = Mastery_OnEnter;
		statFrame:Show();
	end

	function PaperDollFrame_SetLifesteal(statFrame, unit)
		if ( unit ~= "player" ) then
			statFrame:Hide();
			return;
		end

		local lifesteal = GetLifesteal();
		if E.db.sle.armory.stats.decimals then
			PaperDollFrame_SetLabelAndText(statFrame, STAT_LIFESTEAL, format("%.2f%%", lifesteal), false, lifesteal)
		else
			PaperDollFrame_SetLabelAndText(statFrame, STAT_LIFESTEAL, lifesteal, true, lifesteal)
		end
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_LIFESTEAL) .. " " .. format("%.2f%%", lifesteal) .. FONT_COLOR_CODE_CLOSE;

		statFrame.tooltip2 = format(CR_LIFESTEAL_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_LIFESTEAL)), GetCombatRatingBonus(CR_LIFESTEAL));

		statFrame:Show();
	end

	function PaperDollFrame_SetAvoidance(statFrame, unit)
		if ( unit ~= "player" ) then
			statFrame:Hide();
			return;
		end

		local avoidance = GetAvoidance();
	-- PaperDollFrame_SetLabelAndText Format Change
		if E.db.sle.armory.stats.decimals then
			PaperDollFrame_SetLabelAndText(statFrame, STAT_AVOIDANCE, format("%.2f%%", avoidance), false, avoidance)
		else
			PaperDollFrame_SetLabelAndText(statFrame, STAT_AVOIDANCE, avoidance, true, avoidance)
		end
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_AVOIDANCE) .. " " .. format("%.2f%%", avoidance) .. FONT_COLOR_CODE_CLOSE;

		statFrame.tooltip2 = format(CR_AVOIDANCE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_AVOIDANCE)), GetCombatRatingBonus(CR_AVOIDANCE));

		statFrame:Show();
	end

	function PaperDollFrame_SetDodge(statFrame, unit)
		if (unit ~= "player") then
			statFrame:Hide();
			return;
		end

		local chance = GetDodgeChance();
	-- PaperDollFrame_SetLabelAndText Format Change
		if E.db.sle.armory.stats.decimals then
			PaperDollFrame_SetLabelAndText(statFrame, STAT_DODGE, format("%.2f%%", chance), false, chance)
		else
			PaperDollFrame_SetLabelAndText(statFrame, STAT_DODGE, chance, true, chance);
		end
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, DODGE_CHANCE).." "..format("%.2f", chance).."%"..FONT_COLOR_CODE_CLOSE;
		statFrame.tooltip2 = format(CR_DODGE_TOOLTIP, GetCombatRating(CR_DODGE), GetCombatRatingBonus(CR_DODGE));
		statFrame:Show();
	end

	function PaperDollFrame_SetParry(statFrame, unit)
		if (unit ~= "player") then
			statFrame:Hide();
			return;
		end

		local chance = GetParryChance();
	-- PaperDollFrame_SetLabelAndText Format Change
		if E.db.sle.armory.stats.decimals then
			PaperDollFrame_SetLabelAndText(statFrame, STAT_PARRY, format("%.2f%%", chance), false, chance)
		else
			PaperDollFrame_SetLabelAndText(statFrame, STAT_PARRY, chance, true, chance)
		end
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, PARRY_CHANCE).." "..format("%.2f", chance).."%"..FONT_COLOR_CODE_CLOSE;
		statFrame.tooltip2 = format(CR_PARRY_TOOLTIP, GetCombatRating(CR_PARRY), GetCombatRatingBonus(CR_PARRY));
		statFrame:Show();
	end

	function PaperDollFrame_SetCritChance(statFrame, unit)
		if ( unit ~= "player" ) then
			statFrame:Hide();
			return;
		end

		local rating;
		local spellCrit, rangedCrit, meleeCrit;
		local critChance;

		-- Start at 2 to skip physical damage
		local holySchool = 2;
		local minCrit = GetSpellCritChance(holySchool);
		statFrame.spellCrit = {};
		statFrame.spellCrit[holySchool] = minCrit;
		local spellCrit;
		for i=(holySchool+1), MAX_SPELL_SCHOOLS do
			spellCrit = GetSpellCritChance(i);
			minCrit = math_min(minCrit, spellCrit);
			statFrame.spellCrit[i] = spellCrit;
		end
		spellCrit = minCrit
		rangedCrit = GetRangedCritChance();
		meleeCrit = GetCritChance();

		if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
			critChance = spellCrit;
			rating = CR_CRIT_SPELL;
		elseif (rangedCrit >= meleeCrit) then
			critChance = rangedCrit;
			rating = CR_CRIT_RANGED;
		else
			critChance = meleeCrit;
			rating = CR_CRIT_MELEE;
		end
	-- PaperDollFrame_SetLabelAndText Format Change
		if E.db.sle.armory.stats.decimals then
			PaperDollFrame_SetLabelAndText(statFrame, STAT_CRITICAL_STRIKE, format("%.2f%%", critChance), false, critChance)
		else
			PaperDollFrame_SetLabelAndText(statFrame, STAT_CRITICAL_STRIKE, critChance, true, critChance)
		end


		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_CRITICAL_STRIKE).." "..format("%.2f%%", critChance)..FONT_COLOR_CODE_CLOSE;
		local extraCritChance = GetCombatRatingBonus(rating);
		local extraCritRating = GetCombatRating(rating);
		if (GetCritChanceProvidesParryEffect()) then
			statFrame.tooltip2 = format(CR_CRIT_PARRY_RATING_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance, GetCombatRatingBonusForCombatRatingValue(CR_PARRY, extraCritRating));
		else
			statFrame.tooltip2 = format(CR_CRIT_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance);
		end
		statFrame:Show();
	end

	function PaperDollFrame_SetHaste(statFrame, unit)
		if ( unit ~= "player" ) then
			statFrame:Hide();
			return;
		end

		local haste = GetHaste();
		local rating = CR_HASTE_MELEE;

		local hasteFormatString;
		if (haste < 0) then
			hasteFormatString = RED_FONT_COLOR_CODE.."%s"..FONT_COLOR_CODE_CLOSE;
		else
			hasteFormatString = "%s";
		end
	-- PaperDollFrame_SetLabelAndText Format Change
		if E.db.sle.armory.stats.decimals then
			PaperDollFrame_SetLabelAndText(statFrame, STAT_HASTE, format(hasteFormatString, format("%.2f%%", haste)), false, haste)
		else
			PaperDollFrame_SetLabelAndText(statFrame, STAT_HASTE, format(hasteFormatString, format("%d%%", haste + 0.5)), false, haste)
		end
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_HASTE) .. " " .. format(hasteFormatString, format("%.2f%%", haste)) .. FONT_COLOR_CODE_CLOSE;

		local _, class = UnitClass(unit);
		statFrame.tooltip2 = _G["STAT_HASTE_"..class.."_TOOLTIP"];
		if (not statFrame.tooltip2) then
			statFrame.tooltip2 = STAT_HASTE_TOOLTIP;
		end
		statFrame.tooltip2 = statFrame.tooltip2 .. format(STAT_HASTE_BASE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(rating)), GetCombatRatingBonus(rating));

		statFrame:Show();
	end

end

function SA:LoadAndSetup()
	if SLE._Compatibility["DejaCharacterStats"] then return end
	SA:ReplaceBlizzFunctions()
	hooksecurefunc("PaperDollFrame_UpdateStats", SA.PaperDollFrame_UpdateStats)
	hooksecurefunc(M, "UpdateCharacterItemLevel", SA.UpdateCharacterItemLevel)
	hooksecurefunc(M, "ToggleItemLevelInfo", SA.UpdateCharacterItemLevel)
	hooksecurefunc(M, "UpdateAverageString", SA.UpdateCharacterItemLevel)

	SA:BuildScrollBar()
	SA:BuildNewStats()
	SA:ToggleArmory()

	_G["CharacterFrame"]:HookScript("OnShow", SA.UpdateCharacterItemLevel)

	_G["CharacterFrame"].ItemLevelText:SetText('')
end
