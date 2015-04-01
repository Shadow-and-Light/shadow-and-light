local E, L, V, P, G = unpack(ElvUI);
local EM = E:GetModule('SLE_EquipManager')

local GetEquipmentSetInfo, GetSpecialization, GetActiveSpecGroup, UseEquipmentSet = GetEquipmentSetInfo, GetSpecialization, GetActiveSpecGroup, UseEquipmentSet
local IsInInstance, GetNumWorldPVPAreas, GetWorldPVPAreaInfo = IsInInstance, GetNumWorldPVPAreas, GetWorldPVPAreaInfo
local gsub, strfind = string.gsub, string.find, string.sub

local function Equip(event)
	local primary = GetSpecialization()
	local equipSet
	local pvp = false
	for i = 1, GetNumEquipmentSets() do
		local name, _, _, isEquipped = GetEquipmentSetInfo(i)
		if isEquipped then
			equipSet = name
			break
		end
	end

	if primary ~= nil then
		local inInstance, instanceType = IsInInstance()

		if (event == "ACTIVE_TALENT_GROUP_CHANGED") then
			if GetActiveSpecGroup() == 1 then
				if equipSet ~= E.private.sle.equip.primary and E.private.sle.equip.primary ~= "NONE" then
					UseEquipmentSet(E.private.sle.equip.primary)
					return
				end
			else
				if equipSet ~= E.private.sle.equip.secondary and E.private.sle.equip.secondary ~= "NONE" then
					UseEquipmentSet(E.private.sle.equip.secondary)
					return
				end
			end
		end

		if (instanceType == "party" or instanceType == "raid") then
			if equipSet ~= E.private.sle.equip.instance and E.private.sle.equip.instance ~= "NONE" then
				UseEquipmentSet(E.private.sle.equip.instance)
				return
			end
		end

		if (instanceType == "pvp" or instanceType == "arena") then
			pvp = true
			if equipSet ~= E.private.sle.equip.pvp and E.private.sle.equip.pvp ~= "NONE" then
				UseEquipmentSet(E.private.sle.equip.pvp)
				return
			end
		end

		if E.private.sle.equip.pvp ~= "NONE" then
			for i = 1, GetNumWorldPVPAreas() do
				local _, localizedName, isActive = GetWorldPVPAreaInfo(i)

				if (GetRealZoneText() == localizedName and isActive) then
					pvp = true
					if equipSet ~= E.private.sle.equip.pvp then
						UseEquipmentSet(E.private.sle.equip.pvp)
						return
					end
				end
			end
		end
		
		if event == "ZONE_CHANGED" then
			if (equipSet ~= E.private.sle.equip.primary and E.private.sle.equip.primary ~= "NONE") and (equipSet ~= E.private.sle.equip.secondary and E.private.sle.equip.secondary ~= "NONE") and equipSet == E.private.sle.equip.pvp and not pvp then
				if GetActiveSpecGroup() == 1 then
					UseEquipmentSet(E.private.sle.equip.primary)
					return
				else
					UseEquipmentSet(E.private.sle.equip.secondary)
					return
				end
			end
		end
	end
end

function EM:EquipSpamFilter(event, msg, ...)
	if strfind(msg, string.gsub(ERR_LEARN_ABILITY_S:gsub('%.', '%.'), '%%s', '(.*)')) then
		return true
	elseif strfind(msg, string.gsub(ERR_LEARN_SPELL_S:gsub('%.', '%.'), '%%s', '(.*)')) then
		return true
	elseif strfind(msg, string.gsub(ERR_SPELL_UNLEARNED_S:gsub('%.', '%.'), '%%s', '(.*)')) then
		return true
	elseif strfind(msg, string.gsub(ERR_LEARN_PASSIVE_S:gsub('%.', '%.'), '%%s', '(.*)')) then
		return true
	end

	return false, msg, ...
end

local function EnableSpamFilter()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", EM.EquipSpamFilter)
end

local function DisableSpamFilter()
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", EM.EquipSpamFilter)
end

function EM:SpamThrottle()
	if E.private.sle.equip.spam then
		EnableSpamFilter()
	else
		DisableSpamFilter()
	end
end

function EM:Initialize()
	EM:SpamThrottle()
	if not E.private.sle.equip.enable then return end
	self:RegisterEvent("PLAYER_ENTERING_WORLD", Equip)
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", Equip)
	self:RegisterEvent("PLAYER_TALENT_UPDATE", Equip)
	self:RegisterEvent("ZONE_CHANGED", Equip)
end