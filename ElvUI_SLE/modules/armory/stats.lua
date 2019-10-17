local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end --Don't break korean code :D
local Armory = SLE:GetModule("Armory_Core")
local SA = SLE:NewModule("Armory_Stats") --, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
local M = E:GetModule("Misc")

local _G = _G
local math_min, math_max= math.min, math.max

SA.totalShown = 0

SA.OriginalPaperdollStats = PAPERDOLL_STATCATEGORIES

--Replacing broken Blizz function and adding some decimals
--Atteack speed
function PaperDollFrame_SetAttackSpeed(statFrame, unit)
	local meleeHaste = GetMeleeHaste();
	local speed, offhandSpeed = UnitAttackSpeed(unit);
	local displaySpeedxt

	local displaySpeed = T.format("%.2f", speed);
	if ( offhandSpeed ) then
		offhandSpeed = T.format("%.2f", offhandSpeed);
	end
	if ( offhandSpeed ) then
		displaySpeedxt =  BreakUpLargeNumbers(displaySpeed).." / ".. offhandSpeed;
	else
		displaySpeedxt =  BreakUpLargeNumbers(displaySpeed);
	end
	PaperDollFrame_SetLabelAndText(statFrame, WEAPON_SPEED, displaySpeed, false, speed);

	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..T.format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..displaySpeed..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = T.format(STAT_ATTACK_SPEED_BASE_TOOLTIP, BreakUpLargeNumbers(meleeHaste));

	statFrame:Show();
end

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
		self:GetParent():SetVerticalScroll(value) 
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
		if SA.totalShown > 26 - E.db.sle.armory.stats.itemLevel.size then
			SA.Scrollbar:SetMinMaxValues(1, 100)
		else
			SA.Scrollbar:SetMinMaxValues(1, 1) 
		end

		local cur_val = SA.Scrollbar:GetValue()
		local min_val, max_val = SA.Scrollbar:GetMinMaxValues()

		if delta < 0 and cur_val < max_val then
			cur_val = math_min(max_val, cur_val + 22)
			SA.Scrollbar:SetValue(cur_val)
		elseif delta > 0 and cur_val > min_val then
			cur_val = math_max(min_val, cur_val - 22)
			SA.Scrollbar:SetValue(cur_val)
		end
	end)
end

function SA:UpdateCharacterItemLevel()
	SA:UpdateIlvlFont()
	if not E.db.sle.armory.stats.enable then return end
	local total, equipped = T.GetAverageItemLevel()
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
	if not E.db.sle.armory.stats.enable then return end
	SA.totalShown = 0
	local total, equipped = T.GetAverageItemLevel()
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

	_G["CharacterStatsPane"].ItemLevelCategory:Show();
	_G["CharacterStatsPane"].ItemLevelCategory.Title:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.catFonts.font), E.db.sle.armory.stats.catFonts.size, E.db.sle.armory.stats.catFonts.outline)
	_G["CharacterStatsPane"].ItemLevelFrame:Show();

	local spec = T.GetSpecialization();
	local role = T.GetSpecializationRole(spec);
	local _, powerType = UnitPowerType("player")
	-- print(T.GetSpecializationInfo(spec))

	_G["CharacterStatsPane"].statsFramePool:ReleaseAll();
	-- we need a stat frame to first do the math to know if we need to show the stat frame
	-- so effectively we'll always pre-allocate
	local statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire();

	local lastAnchor;
	for catIndex = 1, #PAPERDOLL_STATCATEGORIES do
		local catFrame = _G["CharacterStatsPane"][PAPERDOLL_STATCATEGORIES[catIndex].categoryFrame];
		catFrame.Title:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.catFonts.font), E.db.sle.armory.stats.catFonts.size, E.db.sle.armory.stats.catFonts.outline)
		local numStatInCat = 0;

		for statIndex = 1, #PAPERDOLL_STATCATEGORIES[catIndex].stats do
			local stat = PAPERDOLL_STATCATEGORIES[catIndex].stats[statIndex];
			local showStat = true;
			if stat.option and not E.db.sle.armory.stats.List[stat.stat] then showStat = false end
			if ( showStat and stat.primary ) then
				local primaryStat = T.select(6, T.GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
				if ( stat.primary ~= primaryStat ) and E.db.sle.armory.stats.OnlyPrimary then
					showStat = false;
				end
			end
			if ( showStat and stat.roles ) then
				local foundRole = false;
				for _, statRole in T.pairs(stat.roles) do
					if ( role == statRole ) then
						foundRole = true;
						break;
					end
				end
				if foundRole and stat.classes then
					for _, statClass in T.pairs(stat.classes) do
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
				statFrame.Label:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.statFonts.font), E.db.sle.armory.stats.statFonts.size, E.db.sle.armory.stats.statFonts.outline)
				statFrame.Value:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.stats.statFonts.font), E.db.sle.armory.stats.statFonts.size, E.db.sle.armory.stats.statFonts.outline)
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
						statFrame.leftGrad:Hide()
						statFrame.rightGrad:Hide()
						lastAnchor = statFrame;
					end
					-- done with this stat frame, get the next one
					statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire();
				end
			end
		end
		catFrame:SetShown(numStatInCat > 0);
	end
	-- release the current stat frame
	_G["CharacterStatsPane"].statsFramePool:Release(statFrame);
	if SA.Scrollbar then
		if SA.totalShown > 26 - E.db.sle.armory.stats.itemLevel.size then
			SA.Scrollbar:Show()
		else
			SA.Scrollbar:Hide()
		end
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

	else
		_G["CharacterStatsPane"]["OffenseCategory"]:Hide()
		_G["CharacterStatsPane"]["DefenceCategory"]:Hide()
		_G["CharacterStatsPane"].ItemLevelFrame:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelCategory, "BOTTOM", 0, 0)
		SA.Scrollbar:Hide()
	end
	PaperDollFrame_UpdateStats()
	M:UpdateCharacterItemLevel()
	if not E.db.general.itemLevel.displayCharacterInfo then
		_G["CharacterFrame"].ItemLevelText:SetText('')
	end
end

function SA:LoadAndSetup()
	if SLE._Compatibility["DejaCharacterStats"] then return end
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