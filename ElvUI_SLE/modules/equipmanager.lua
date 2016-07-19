local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local EM = SLE:NewModule('EquipManager', 'AceHook-3.0', 'AceEvent-3.0')
local GetRealZoneText = GetRealZoneText
EM.Processing = false

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

function EM:IsDungeon(inInstance, instanceType)
	if inInstance and (instanceType ==  "scenario" or instanceType == "party" or instanceType == "raid") then return true end
	return false
end

function EM:WrongSet(equipSet, group, inCombat)
	local inInstance, instanceType = T.IsInInstance()
	if inInstance and ((EM.db.instanceSet and EM.db[group].instance ~= "NONE") or (EM.db.pvpSet and EM.db[group].pvp ~= "NONE")) then
		if EM:IsDungeon(inInstance, instanceType) and EM.db.instanceSet then
			if equipSet ~= EM.db[group].instance and EM.db[group].instance ~= "NONE" then
				if inCombat then SLE:ErrorPrint(L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."]); return false end
				return true, EM.db[group].instance
			end
		end
		if EM:IsPvP(inInstance, instanceType) and EM.db.pvpSet then
			if equipSet ~= EM.db[group].pvp and EM.db[group].pvp ~= "NONE" then
				if inCombat then SLE:ErrorPrint(L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."]); return false end
				return true, EM.db[group].pvp
			end
		end
	end
	if equipSet ~= EM.db[group].general and EM.db[group].general ~= "NONE" then
		if inCombat then SLE:ErrorPrint(L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."]); return false end
		return true, EM.db[group].general
	end
	return false
end

local function Equip(event)
	if EM.Processing then return end
	EM.Processing = true
	local inCombat = false
	E:Delay(1, function() EM.Processing = false end)
	if T.InCombatLockdown() then
		EM:RegisterEvent("PLAYER_REGEN_ENABLED", Equip)
		inCombat = true
	end
	if event == "PLAYER_REGEN_ENABLED" then
		EM:UnregisterEvent(event)
	end
	local spec, equipSet = EM:GetData()
	if spec ~= nil then --In case you don't have spec
		local isWrong, trueSet = EM:WrongSet(equipSet, SpecTable[spec], inCombat)
		if isWrong then
			T.UseEquipmentSet(trueSet)
		end
	end
end

function EM:Initialize()
	EM.db = E.private.sle.equip
	if not SLE.initialized then return end
	if not EM.db.enable then return end
	self:RegisterEvent("PLAYER_ENTERING_WORLD", Equip)
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", Equip)
	self:RegisterEvent("ZONE_CHANGED", Equip)
end

SLE:RegisterModule(EM:GetName())