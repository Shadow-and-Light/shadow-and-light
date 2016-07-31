local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if SLE._Compatibility["DejaCharacterStats"] then return end
--Credits: Dejablue

--GLOBALS: PAPERDOLL_STATCATEGORIES, PAPERDOLL_STATINFO, PaperDollFrame_SetAttackSpeed, PaperDollFrame_SetMovementSpeed
local _G = _G
local math_min, math_max= math.min, math.max

local GetMeleeHaste, UnitAttackSpeed = GetMeleeHaste, UnitAttackSpeed
local BreakUpLargeNumbers = BreakUpLargeNumbers
local PaperDollFrame_SetLabelAndText = PaperDollFrame_SetLabelAndText
local UnitSex = UnitSex
-- local PaperDollFrame_UpdateStats = PaperDollFrame_UpdateStats
local PaperDollFrame_SetItemLevel = PaperDollFrame_SetItemLevel
local GetItemLevelColor = GetItemLevelColor
local MovementSpeed_OnEnter, MovementSpeed_OnUpdate = MovementSpeed_OnEnter, MovementSpeed_OnUpdate

local LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY, LE_UNIT_STAT_INTELLECT = LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY, LE_UNIT_STAT_INTELLECT
local STAT_ATTACK_SPEED_BASE_TOOLTIP = STAT_ATTACK_SPEED_BASE_TOOLTIP
local FONT_COLOR_CODE_CLOSE, HIGHLIGHT_FONT_COLOR_CODE = FONT_COLOR_CODE_CLOSE, HIGHLIGHT_FONT_COLOR_CODE
local ATTACK_SPEED = ATTACK_SPEED
local PAPERDOLLFRAME_TOOLTIP_FORMAT = PAPERDOLLFRAME_TOOLTIP_FORMAT
local WEAPON_SPEED = WEAPON_SPEED

local CA = CharacterArmory
local totalShown = 0

--Replacing broken Blizz function
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

function PaperDollFrame_SetMovementSpeed(statFrame, unit)
	statFrame.wasSwimming = nil;
	statFrame.unit = unit;
	MovementSpeed_OnUpdate(statFrame);

	statFrame.onEnterFunc = MovementSpeed_OnEnter;
	-- TODO: Fix if we decide to show movement speed
	-- statFrame:SetScript("OnUpdate", MovementSpeed_OnUpdate);

	statFrame:Show();
end

local PAPERDOLL_AttributesIndexDefaultStats ={
	[1] = "HEALTH",
	[2] = "POWER",
	[3] = "ALTERNATEMANA",
	[4] = "ATTACK_DAMAGE",
	[5] = "ATTACK_AP",
	[6] = "ATTACK_ATTACKSPEED",
	[7] = "SPELLPOWER",
	[8] = "ENERGY_REGEN",
	[9] = "RUNE_REGEN",
	[10] = "FOCUS_REGEN",
	[11] = "MOVESPEED",
}

function CA:ResetAllStats()
	PAPERDOLL_STATCATEGORIES= {
		[1] = {
			categoryFrame = "AttributesCategory",
			stats = {
				[1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH },
				[2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY },
				[3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT },
				[4] = { stat = "STAMINA" },
				[5] = { stat = "ARMOR" },
				[6] = { stat = "MANAREGEN", roles =  { "HEALER" } },
			},
		},
		[2] = {
			categoryFrame = "EnhancementsCategory",
			stats = {
				[1] = { stat = "CRITCHANCE", hideAt = 0 },
				[2] = { stat = "HASTE", hideAt = 0 },
				[3] = { stat = "MASTERY", hideAt = 0 },
				[4] = { stat = "VERSATILITY", hideAt = 0 },
				[5] = { stat = "LIFESTEAL", hideAt = 0 },
				[6] = { stat = "AVOIDANCE", hideAt = 0 },
				[7] = { stat = "DODGE", roles =  { "TANK" } },
				[8] = { stat = "PARRY", hideAt = 0, roles =  { "TANK" } },
				[9] = { stat = "BLOCK", hideAt = 0, roles =  { "TANK" } },
			},
		},
	};
end

function CA:ToggleStats()
	CA:ResetAllStats()
	for _, value in T.pairs(PAPERDOLL_AttributesIndexDefaultStats) do
		local checked = E.db.sle.Armory.Character.Stats.List[value]
		if checked then
			T.tinsert(PAPERDOLL_STATCATEGORIES[1].stats, { stat = T.format("%s", value) })
		end
	end
	PaperDollFrame_UpdateStats();
end

function CA:PaperDollFrame_UpdateStats()
	totalShown = 0
	local total, equipped = T.GetAverageItemLevel()
	if E.db.sle.Armory.Character.Stats.IlvlFull then
		if E.db.sle.Armory.Character.Stats.IlvlColor then
			local R, G, B = E:ColorGradient((equipped / total), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			local avColor = E.db.sle.Armory.Character.Stats.AverageColor
			_G["CharacterStatsPane"].ItemLevelFrame.Value:SetFormattedText("%s%.2f|r / %s%.2f|r", E:RGBToHex(R, G, B), equipped, E:RGBToHex(avColor.r, avColor.g, avColor.b), total)
		else
			_G["CharacterStatsPane"].ItemLevelFrame.Value:SetFormattedText("%.2f / %.2f", equipped, total)
		end
	else
		_G["CharacterStatsPane"].ItemLevelFrame.Value:SetTextColor(GetItemLevelColor())
		PaperDollFrame_SetItemLevel(_G["CharacterStatsPane"].ItemLevelFrame, "player");
	end

	_G["CharacterStatsPane"].AttributesCategory:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelFrame, "BOTTOM", 0, 6)

	local level = T.UnitLevel("player");
	local categoryYOffset = 6;
	local statYOffset = 0;

	_G["CharacterStatsPane"].ItemLevelCategory:Show();
	_G["CharacterStatsPane"].ItemLevelFrame:Show();

	local spec = T.GetSpecialization();
	local role = T.GetSpecializationRole(spec);

	_G["CharacterStatsPane"].statsFramePool:ReleaseAll();
	-- we need a stat frame to first do the math to know if we need to show the stat frame
	-- so effectively we'll always pre-allocate
	local statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire();

	local lastAnchor;

	for catIndex = 1, #PAPERDOLL_STATCATEGORIES do
		local catFrame = _G["CharacterStatsPane"][PAPERDOLL_STATCATEGORIES[catIndex].categoryFrame];
		local numStatInCat = 0;
		for statIndex = 1, #PAPERDOLL_STATCATEGORIES[catIndex].stats do
			local stat = PAPERDOLL_STATCATEGORIES[catIndex].stats[statIndex];
			local showStat = true;
			if ( showStat and stat.primary ) then
				local primaryStat = T.select(7, T.GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
				if ( stat.primary ~= primaryStat ) and E.db.sle.Armory.Character.Stats.OnlyPrimary then
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
				showStat = foundRole;
			end
			if ( showStat ) then
				statFrame.onEnterFunc = nil;
				PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, "player");
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
						totalShown = totalShown + 1
						numStatInCat = numStatInCat + 1;
						statFrame.Background:SetShown((numStatInCat % 2) == 0);
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
	if totalShown > 16 then
		CA.Scrollbar:Show()
	else
		CA.Scrollbar:Hide()
	end
end

--Creating new scroll
--Scrollframe Parent Frame
CA.ScrollframeParentFrame = CreateFrame("Frame", nil, CharacterFrameInsetRight)
CA.ScrollframeParentFrame:SetSize(198, 352)
CA.ScrollframeParentFrame:SetPoint("TOP", CharacterFrameInsetRight, "TOP", 0, -4)

--Scrollframe 
CA.ScrollFrame = CreateFrame("ScrollFrame", nil, CA.ScrollframeParentFrame)
CA.ScrollFrame:SetPoint("TOP")
CA.ScrollFrame:SetSize(CA.ScrollframeParentFrame:GetSize())

--Scrollbar 
CA.Scrollbar = CreateFrame("Slider", nil, CA.ScrollFrame, "UIPanelScrollBarTemplate") 
CA.Scrollbar:SetPoint("TOPLEFT", CharacterFrameInsetRight, "TOPRIGHT", -12, -20) 
CA.Scrollbar:SetPoint("BOTTOMLEFT", CharacterFrameInsetRight, "BOTTOMRIGHT", -12, 18) 
CA.Scrollbar:SetMinMaxValues(1, 2) 
CA.Scrollbar:SetValueStep(1) 
CA.Scrollbar.scrollStep = 1
CA.Scrollbar:SetValue(0) 
CA.Scrollbar:SetWidth(8) 
CA.Scrollbar:SetScript("OnValueChanged", function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
end)
E:GetModule("Skins"):HandleScrollBar(CA.Scrollbar)
CA.Scrollbar:Hide() 

--CA.ScrollChild Frame
CA.ScrollChild = CreateFrame("Frame", nil, CA.ScrollFrame)
CA.ScrollChild:SetSize(CA.ScrollFrame:GetSize())
CA.ScrollFrame:SetScrollChild(CA.ScrollChild)

CharacterStatsPane:ClearAllPoints()
CharacterStatsPane:SetParent(CA.ScrollChild)
CharacterStatsPane:SetSize(CA.ScrollChild:GetSize())
CharacterStatsPane:SetPoint("TOP", CA.ScrollChild, "TOP", 0, 0) 

CharacterStatsPane.ClassBackground:ClearAllPoints()
CharacterStatsPane.ClassBackground:SetParent(CharacterFrameInsetRight)
CharacterStatsPane.ClassBackground:SetPoint("CENTER")

-- Enable mousewheel scrolling
CA.ScrollFrame:EnableMouseWheel(true)
CA.ScrollFrame:SetScript("OnMouseWheel", function(self, delta)
	if totalShown > 16 then
		CA.Scrollbar:SetMinMaxValues(1, 45)  
	else
		CA.Scrollbar:SetMinMaxValues(1, 1) 
	end

	local cur_val = CA.Scrollbar:GetValue()
	local min_val, max_val = CA.Scrollbar:GetMinMaxValues()

	if delta < 0 and cur_val < max_val then
		cur_val = math_min(max_val, cur_val + 22)
		CA.Scrollbar:SetValue(cur_val)
	elseif delta > 0 and cur_val > min_val then
		cur_val = math_max(min_val, cur_val - 22)
		CA.Scrollbar:SetValue(cur_val)
	end
end)