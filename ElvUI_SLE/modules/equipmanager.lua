local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local EM = SLE:NewModule('EquipManager', 'AceHook-3.0', 'AceEvent-3.0')
local GetRealZoneText = GetRealZoneText
EM.Processing = false
EM.ErrorShown = false

local SpecTable = {
	[1] = "firstSpec",
	[2] = "secondSpec",
	[3] = "thirdSpec",
	[4] = "forthSpec",
}

function EM:GetData()
	local spec = T.GetSpecialization()
	local equipSet
	for i = 1, T.GetNumEquipmentSets() do
		local name, _, _, isEquipped = T.GetEquipmentSetInfo(i)
		if isEquipped then
			equipSet = name
			break
		end
	end
	return spec, equipSet
end

function EM:IsPvP(inInstance, instanceType)
	if inInstance and (instanceType == "pvp" or instanceType == "arena") then return true end
	for i = 1, T.GetNumWorldPVPAreas() do
		local _, localizedName, isActive, canQueue = T.GetWorldPVPAreaInfo(i)
		if (T.GetRealZoneText() == localizedName and isActive) or (GetRealZoneText() == localizedName and canQueue) then return true end
	end
	return false
end

local TIMEWALKING_DIFFICULTYID = 24;

function EM:IsTimewalkingDungeon(inInstance, instanceType)
	if inInstance and (instanceType ==  "scenario" or instanceType == "party" or instanceType == "raid") and select(3, GetInstanceInfo()) == TIMEWALKING_DIFFICULTYID then
		return true
	end
	return false
end

function EM:IsDungeon(inInstance, instanceType)
	if inInstance and (instanceType ==  "scenario" or instanceType == "party" or instanceType == "raid") then return true end
	return false
end

function EM:HasFishingRaftAura()
	return UnitAura("player", GetSpellInfo(124036)) ~= nil;
end

function EM:WrongSet(equipSet, group, inCombat)
	local inInstance, instanceType = T.IsInInstance()
	if EM:HasFishingRaftAura() and E.private.sle.equip.FishingRaft.enable then
		return E.private.sle.equip.FishingRaft.set ~= equipSet, E.private.sle.equip.FishingRaft.set
	end
	if inInstance and ((EM.db.timewalkingSet and EM.db[group].timewalking ~= "NONE") or (EM.db.instanceSet and EM.db[group].instance ~= "NONE") or (EM.db.pvpSet and EM.db[group].pvp ~= "NONE")) then
		if EM:IsTimewalkingDungeon(inInstance, instanceType) and EM.db.timewalkingSet then
			if equipSet ~= EM.db[group].timewalking and EM.db[group].timewalking ~= "NONE" then
				if inCombat then
					if not EM.ErrorShown then SLE:ErrorPrint(L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."]); EM.ErrorShown = true end
					return false
				end
				return true, EM.db[group].timewalking
			end
		end
		if EM:IsDungeon(inInstance, instanceType) and EM.db.instanceSet then
			if equipSet ~= EM.db[group].instance and EM.db[group].instance ~= "NONE" then
				if inCombat then
					if not EM.ErrorShown then SLE:ErrorPrint(L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."]); EM.ErrorShown = true end
					return false
				end
				return true, EM.db[group].instance
			end
		end
		if EM:IsPvP(inInstance, instanceType) and EM.db.pvpSet then
			if equipSet ~= EM.db[group].pvp and EM.db[group].pvp ~= "NONE" then
				if inCombat then
					if not EM.ErrorShown then SLE:ErrorPrint(L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."]); EM.ErrorShown = true end
					return false
				end
				return true, EM.db[group].pvp
			end
		end
	end
	if equipSet ~= EM.db[group].general and EM.db[group].general ~= "NONE" then
		if inCombat then
			if not EM.ErrorShown then SLE:ErrorPrint(L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."]); EM.ErrorShown = true end
			return false
		end
		return true, EM.db[group].general
	end
	return false
end

local function Equip(event)
	if EM.Processing or EM.lock then return end
	if event == "ZONE_CHANGED" and EM.db.onlyTalent then return end
	EM.Processing = true
	local inCombat = false
	E:Delay(1, function() EM.Processing = false end)
	if T.InCombatLockdown() then
		EM:RegisterEvent("PLAYER_REGEN_ENABLED", Equip)
		inCombat = true
	end
	if event == "PLAYER_REGEN_ENABLED" then
		EM:UnregisterEvent(event)
		EM.ErrorShown = false
	end

	local spec, equipSet = EM:GetData()

	local shouldHandleUnitAura = E.private.sle.equip.FishingRaft.enable and (EM:HasFishingRaftAura() and equipSet ~= E.private.sle.equip.FishingRaft.set) or (not EM:HasFishingRaftAura() and equipSet == E.private.sle.equip.FishingRaft.set);

	if (event == "UNIT_AURA" and not shouldHandleUnitAura) then
		return
	end

	if spec ~= nil then --In case you don't have spec
		local isWrong, trueSet = EM:WrongSet(equipSet, SpecTable[spec], inCombat)
		if isWrong and not T.UnitInVehicle("player") then
			T.UseEquipmentSet(trueSet)
		end
	end
end

function EM:CreateLock()
	if _G["SLE_Equip_Lock_Button"] or not EM.db.lockbutton then return end
	local button = CreateFrame("Button", "SLE_Equip_Lock_Button", CharacterFrame)
	button:Size(20, 20)
	button:Point("BOTTOMLEFT", _G["CharacterFrame"], "BOTTOMLEFT", 4, 4)
	button:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 2)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self)
		GameTooltip:AddLine(L["SLE_EM_LOCK_TOOLTIP"])
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide() 
	end)
	E:GetModule("Skins"):HandleButton(button)

	button.TitleText = button:CreateFontString(nil, "OVERLAY")
	button.TitleText:FontTemplate()
	button.TitleText:SetPoint("BOTTOMLEFT", button, "TOPLEFT", 0, 0)
	button.TitleText:SetJustifyH("LEFT")
	button.TitleText:SetText(L["SLE_EM_LOCK_TITLE"])

	button.Icon = button:CreateTexture(nil, "OVERLAY")
	button.Icon:SetAllPoints()
	button.Icon:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\lock]])
	button.Icon:SetVertexColor(0, 1, 0)

	button:SetScript("OnClick", function()
		EM.lock = not EM.lock
		button.Icon:SetVertexColor(EM.lock and 1 or 0, EM.lock and 0 or 1, 0)
	end)
end

function EM:Initialize()
	EM.db = E.private.sle.equip
	EM.lock = false
	if not SLE.initialized then return end
	if not EM.db.enable then return end
	self:RegisterEvent("PLAYER_ENTERING_WORLD", Equip)
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", Equip)
	self:RegisterEvent("ZONE_CHANGED", Equip)
	if E.private.sle.equip.FishingRaft.enable then
		self:RegisterEvent("UNIT_AURA", Equip)
	end
	
	self:CreateLock()
end

SLE:RegisterModule(EM:GetName())