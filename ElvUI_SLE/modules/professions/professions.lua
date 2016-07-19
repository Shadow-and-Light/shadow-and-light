local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Pr = SLE:NewModule("Professions", "AceHook-3.0", "AceEvent-3.0")
--GLOBALS: LoadAddOn, TradeSkillFrame_SetSelection
local _G = _G
local ITEM_MILLABLE, ITEM_PROSPECTABLE = ITEM_MILLABLE, ITEM_PROSPECTABLE

Pr.DEname, Pr.LOCKname, Pr.SMITHname = false, false, false

function Pr:UpdateSkills(event)
	if event ~= "CHAT_MSG_SKILL" then
		local spellName
		Pr.DEname, Pr.LOCKname, Pr.SMITHname = false, false, false
		T.twipe(Pr.ItemTable[ITEM_MILLABLE])
		T.twipe(Pr.ItemTable['OVERRIDE_MILLABLE'])
		T.twipe(Pr.ItemTable[ITEM_PROSPECTABLE])

		if(T.IsSpellKnown(13262)) then Pr.DEname = T.GetSpell(13262) end --Enchant
		if(T.IsSpellKnown(1804)) then Pr.LOCKname = T.GetSpell(1804) end --Lockpicking
		if(T.IsSpellKnown(2018)) then Pr.SMITHname = T.GetSpellBookItemInfo((T.GetSpellInfo(2018))) end --Blacksmith

		if(T.IsSpellKnown(51005)) then --Milling
			spellName = T.GetSpell(51005)
			Pr.ItemTable[ITEM_MILLABLE] = {spellName, 0.5, 1, 0.5}
			Pr.ItemTable['OVERRIDE_MILLABLE'] = {spellName, 0.5, 1, 0.5}
		end

		if(T.IsSpellKnown(31252)) then --Prospecting
			spellName = T.GetSpell(31252)
			Pr.ItemTable[ITEM_PROSPECTABLE] = {spellName, 1, 0.33, 0.33}
			-- Pr.ItemTable['OVERRIDE_PROSPECTABLE'] = {spellName, 1, 0.33, 0.33}
		end
	end

	local prof1, prof2 = GetProfessions()
	if prof1 then
		local name, _, rank = GetProfessionInfo(prof1)
		if name == T.GetSpell(7411) then
			Pr.DErank = rank
		end
	end
	if prof2 then
		local name, _, rank = GetProfessionInfo(prof2)
		if name == T.GetSpell(7411) then
			Pr.DErank = rank
		end
	end
end

function Pr:Initialize()
	if not SLE.initialized then return end

	LoadAddOn("Blizzard_TradeSkillUI")
	Pr:UpdateSkills()

	if E.private.sle.professions.enchant.enchScroll then Pr:EnchantButton() end

	self:RegisterEvent("TRADE_SKILL_UPDATE", "UpdateSkills")
	self:RegisterEvent("CHAT_MSG_SKILL", "UpdateSkills")

	if E.private.sle.professions.deconButton.enable then Pr:InitializeDeconstruct() end
	if E.private.sle.professions.fishing.EasyCast then Pr:FishingInitialize() end
end
SLE:RegisterModule("Professions")