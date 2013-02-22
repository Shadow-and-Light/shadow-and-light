--Raid mark bar. Similar to quickmark which just semms to be impossible to skin
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local EM = E:NewModule('EquipManager', 'AceHook-3.0', 'AceEvent-3.0');

function EM:Equip(event)
	EM:EnableSpecSwitcherSpamFilter()
	local primary = GetSpecialization()
	if primary ~= nil then
		local inInstance, instanceType = IsInInstance()
		if (event == "ACTIVE_TALENT_GROUP_CHANGED") then
			if GetActiveSpecGroup() == 1 then
				UseEquipmentSet(E.private.sle.specswitch.primary)
			else
				UseEquipmentSet(E.private.sle.specswitch.secondary)
			end
		end
		if (instanceType == "party" or instanceType == "raid") then
			UseEquipmentSet(E.private.sle.specswitch.instance)
		end
		if (instanceType == "pvp" or instanceType == "arena") then
			UseEquipmentSet(E.private.sle.specswitch.pvp)
		end
	end
end

function EM:SpecSwitcherSpamFilter(event, msg, ...)
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

function EM:EnableSpecSwitcherSpamFilter()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", EM.SpecSwitcherSpamFilter)
end

function EM:DisableSpecSwitcherSpamFilter()
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", EM.SpecSwitcherSpamFilter)
end


function EM:Initialize()
	print("stuff")
	if not E.private.sle.specswitch.enable then return end
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "Equip")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "Equip")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "Equip")
end

E:RegisterModule(EM:GetName())