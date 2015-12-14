local E, L, V, P, G = unpack(ElvUI);
local AT = E:GetModule('SLE_AuraTimers');
local A = E:GetModule('Auras');
local SLE = E:GetModule("SLE")
local Masque = LibStub("Masque", true)
local MasqueGroup = Masque and Masque:Group("ElvUI", "Consolidated Buffs")

local format = string.format
local twipe = table.wipe
local GetSpellInfo = GetSpellInfo

local function GetSpell(id)
	local name = GetSpellInfo(id)
	return name
end
AT.Buffs = {
	[1] = { --Stats
		GetSpell(1126), --Dru
		GetSpell(115921), --MW Monk
		GetSpell(20217), --Pal
		GetSpell(116781), --WW/BM Monk
		GetSpell(160206), --Hunt
	},
	[2] = { --Stamina
		GetSpell(21562), --Priest
		GetSpell(469), --Warr
		GetSpell(160199), --Hunt
	},
	[3] = { --AttackPower
		GetSpell(57330), --DK
		GetSpell(6673), --War
	},
	[4] = { --Haste
		GetSpell(160203), --Hunt
	},
	[5] = { --SpellPower
		GetSpell(61316), --Mage Dal
		GetSpell(1459), --Mage
		GetSpell(109773), --Lock
		GetSpell(160205), --Hunt
	},
	[6] = { --Crit
		GetSpell(61316), --Mage Dal
		GetSpell(1459), --Mage
		GetSpell(116781), --BM/WW Monk
		GetSpell(160200), --Hunter
	},
	[7] = { --Mastery
		GetSpell(19740), --Pal
		GetSpell(160198), --Hunt
	},
	[8] = { --Multistrike
		GetSpell(109773), --Lock
		GetSpell(172968), --Hunt
	},
	[9] = { --Verstility
		GetSpell(1126), --Dru
		GetSpell(172967), --Hunt
	},
}
AT.Spells = {
	["DEATHKNIGHT"] = {[3] = GetSpell(57330),},
	["DRUID"] = {[1] = GetSpell(1126),[9] = GetSpell(1126),},
	["HUNTER"] = {
		[1] = GetSpell(160206),
		[2] = GetSpell(160199),
		[4] = GetSpell(160203),
		[5] = GetSpell(160205),
		[6] = GetSpell(160200),
		[7] = GetSpell(160198),
		[8] = GetSpell(172968),
		[9] = GetSpell(172967),
	},
	["MAGE"] = {
		[5] = IsSpellKnown(61316) and GetSpell(61316) or GetSpell(1459),
		[6] = IsSpellKnown(61316) and GetSpell(61316) or GetSpell(1459),
	},
	["MONK"] = {},
	["PALADIN"] = {
		[1] = GetSpell(20217),
		[7] = GetSpell(19740),
	},
	["PRIEST"] = {[2] = GetSpell(21562),},
	["WARLOCK"] = {
		[5] = GetSpell(109773),
		[8] = GetSpell(109773),
	},
	["WARRIOR"] = {
		[2] = GetSpell(469),
		[3] = GetSpell(6673),
	},
}

local ignoreIcons = {}
function AT:Update_ConsolidatedBuffsSettings()
	if(E.private.auras.disableBlizzard) then
		for i = 1, NUM_LE_RAID_BUFF_TYPES do
			local tt = _G[format("ConsolidatedBuffsTooltipBuff%d",i)]
			tt:Hide()
		end
	end
end

local function ConsOnEnter(button)
	GameTooltip:Hide()
	GameTooltip:SetOwner(button, "ANCHOR_BOTTOMLEFT", -3, button:GetHeight() + 2)
	GameTooltip:ClearLines()

	if button.BuffID and (button.SpellName and button.SpellName ~= "") then
		GameTooltip:SetUnitConsolidatedBuff("player", button.BuffID)
	else
		GameTooltip:AddLine(_G[("RAID_BUFF_%d"):format(button.BuffID)])
	end

	GameTooltip:Show()
end

local function ConsOnLeave()
	GameTooltip:Hide()
end

function A:CreateButton(i)
	local button = CreateFrame("Button", "ElvUIConsolidatedBuff"..i, ElvUI_ConsolidatedBuffs, "SecureActionButtonTemplate")
	button.BuffID = i

	button.t = button:CreateTexture(nil, "OVERLAY")
	button.t:SetTexCoord(unpack(E.TexCoords))
	button.t:SetInside()
	button.t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

	button.cd = CreateFrame('Cooldown', nil, button, 'CooldownFrameTemplate')
	button.cd:SetInside()
	button.cd.noOCC = true;
	button.cd.noCooldownCount = true;
	button.cd:SetHideCountdownNumbers(true)

	button:SetAttribute("type1", "spell")
	button:SetAttribute("unit", "player")

	button.timer = button.cd:CreateFontString(nil, 'OVERLAY')
	button.timer:SetPoint('CENTER')

	local ButtonData = {
		FloatingBG = nil,
		Icon = button.t,
		Cooldown = button.cd,
		Flash = nil,
		Pushed = nil,
		Normal = nil,
		Disabled = nil,
		Checked = nil,
		Border = nil,
		AutoCastable = nil,
		Highlight = nil,
		HotKey = nil,
		Count = nil,
		Name = nil,
		Duration = false,
		AutoCast = nil,
	}

	if MasqueGroup and E.private.auras.masque.consolidatedBuffs then
		MasqueGroup:AddButton(button, ButtonData)
	elseif not E.private.auras.masque.consolidatedBuffs then
		button:SetTemplate('Default')
	end

	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetScript("OnEnter", function(self) ConsOnEnter(self) end)
	button:SetScript("OnLeave", function(self) ConsOnLeave() end)

	button.icon = CreateFrame("Frame", "ElvUIConsolidatedBuff"..i.."CanCast", button)
	-- local icon = button.icon
	-- icon:Width(3)
	-- icon:SetPoint("TOPRIGHT", button, "TOPLEFT", 1, (E.PixelMode and -1 or 0))
	-- icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", 1, (E.PixelMode and 1 or 0))
	-- local overlay = icon:CreateTexture(nil, "OVERLAY")
	-- overlay:SetTexture(E['media'].blankTex)
	-- overlay:SetAllPoints(icon)
	-- local classColor = RAID_CLASS_COLORS[E.myclass]
	-- overlay:SetVertexColor(classColor.r, classColor.g, classColor.b)
	-- icon:SetFrameLevel(button:GetFrameLevel() + 3)
	-- icon:Hide()
	button.icon = CreateFrame("Frame", "ElvUIConsolidatedBuff"..i.."CanCast", button)
	local icon = button.icon
	icon:Width(3)
	icon:SetPoint("TOPLEFT", button, "TOPLEFT", 1, (E.PixelMode and -1 or 0))
	icon:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 1, (E.PixelMode and 1 or 0))
	local overlay = icon:CreateTexture(nil, "OVERLAY")
	overlay:SetTexture(E["media"].blankTex)
	overlay:SetAllPoints(icon)
	local classColor = RAID_CLASS_COLORS[E.myclass]
	overlay:SetVertexColor(classColor.r, classColor.g, classColor.b)
	icon:Hide()
	
	button.cd:SetFrameLevel(icon:GetFrameLevel() + 1)

	return button
end

function AT:UpdateAura(button, index)
	if not E.db.sle.auras.enable then return end
	local isDebuff
	local filter = button:GetParent():GetAttribute('filter')
	local unit = button:GetParent():GetAttribute("unit")
	local name, _, _, _, dtype, duration, expiration = UnitAura(unit, index, filter)

	if (name) then
		if UnitBuff('player', name) then
			isDebuff = false
		elseif UnitDebuff('player', name) then
			isDebuff = true
		end

		if isDebuff == false and E.db.sle.auras.buffs.hideTimer then
			button.time:Hide()
		elseif isDebuff == false then
			button.time:Show()
		end

		if isDebuff == true and E.db.sle.auras.debuffs.hideTimer then
			button.time:Hide()
		elseif isDebuff == true then
			button.time:Show()
		end
	end
end

function AT:UpdateTempEnchant(button, index)
	--Might do tempenchant stuff later
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event)
	AT:BuildCasts(event)
end)
function AT:BuildCasts(event, unit)
	if unit and unit ~= "player" then return end
	if InCombatLockdown() then
		f:RegisterEvent("PLAYER_REGEN_ENABLED")
		SLE:Print(L["You are in combat, Consolidated Buffs Bars will be updated upon leaving it"])
		return
	end
	if event == "PLAYER_REGEN_ENABLED" then f:UnregisterEvent(event) end
	if E.myclass == "MONK" and GetSpecialization() then
		twipe(AT.Spells["MONK"])
		if GetSpecialization() == 2 then
			AT.Spells["MONK"][1] = GetSpell(115921)
			AT.Spells["MONK"][6] = nil
		else
			AT.Spells["MONK"][1] = GetSpell(116781)
			AT.Spells["MONK"][6] = GetSpell(116781)
		end
	end
	for i = 1, NUM_LE_RAID_BUFF_TYPES do
		local button = _G["ElvUIConsolidatedBuff"..i]
		if AT.Spells[E.myclass] then
			local name = AT.Spells[E.myclass][i]
			if name then
				button:SetAttribute("spell1", name)
				if E.private.sle.auras.consolidatedMark then
					button.icon:Show()
				else
					button.icon:Hide()
				end
			end
		end
	end
	AT:Update_ConsolidatedBuffsSettings()
	AT:UpdateAuraStandings(nil, "player")
end

function AT:UpdateAuraStandings(event, unit)
	if unit ~= "player" and event ~= "PLAYER_REGEN_ENABLED" then return end
	if event == "PLAYER_REGEN_DISABLED" or InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateAuraStandings")
		return
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent(event)
	end
	for i = 1, NUM_LE_RAID_BUFF_TYPES do
		local button = _G["ElvUIConsolidatedBuff"..i]
		button.SpellName = ""
		for s = 1, #AT.Buffs[i] do
			local name = UnitAura("player", AT.Buffs[i][s])
			if name then
				button:SetAttribute("type2", "cancelaura")
				button:SetAttribute("spell2", name)
				button.SpellName = name
				break
			end
		end
	end
end

function AT:Initialize()
	if E.private.auras.enable ~= true then return end
	hooksecurefunc(A, 'UpdateAura', AT.UpdateAura)
	hooksecurefunc(A, 'Update_ConsolidatedBuffsSettings', AT.Update_ConsolidatedBuffsSettings)
	--hooksecurefunc(A, 'UpdateTempEnchant', AT.UpdateTempEnchant)

	self:RegisterEvent("UNIT_AURA", "UpdateAuraStandings")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "BuildCasts")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "BuildCasts")
	self:RegisterEvent("UNIT_LEVEL", "BuildCasts")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateAuraStandings")

	C_Timer.After(5, AT.BuildCasts)
	C_Timer.After(5, function() A:Update_ConsolidatedBuffsSettings() end)
end