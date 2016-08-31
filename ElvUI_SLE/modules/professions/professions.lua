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

		if(T.IsSpellKnown(13262)) then Pr.DEname = T.GetSpell(13262) end --Enchant
		if(T.IsSpellKnown(1804)) then Pr.LOCKname = T.GetSpell(1804) end --Lockpicking
		if(T.IsSpellKnown(2018)) then Pr.SMITHname = T.GetSpellBookItemInfo((T.GetSpellInfo(2018))) end --Blacksmith
		if(T.IsSpellKnown(25229)) then Pr.JEWELname = T.GetSpellBookItemInfo((T.GetSpellInfo(25229))) end --Jewelcrating
		if(T.IsSpellKnown(31252)) then Pr.PROSPECTname = T.GetSpell((T.GetSpellInfo(31252))) end --Jewelcrating
		if(T.IsSpellKnown(51005)) then Pr.MILLname = T.GetSpell((T.GetSpellInfo(51005))) end --Milling
	end

	local prof1, prof2 = T.GetProfessions()
	if prof1 then
		local name, _, rank = T.GetProfessionInfo(prof1)
		if name == T.GetSpell(7411) then
			Pr.DErank = rank
		end
	end
	if prof2 then
		local name, _, rank = T.GetProfessionInfo(prof2)
		if name == T.GetSpell(7411) then
			Pr.DErank = rank
		end
	end
end

function Pr:Initialize()
	if not SLE.initialized then return end

	if not T.IsAddOnLoaded("Blizzard_TradeSkillUI") then LoadAddOn("Blizzard_TradeSkillUI") end
	--Next line is to fix other guys' code cause they fell like being assholes and morons
	if SLE._Compatibility["TradeSkillMaster"] and not TradeSkillFrame.RecipeList.collapsedCategories then TradeSkillFrame.RecipeList.collapsedCategories = {} end
	Pr:UpdateSkills()
	_G["TradeSkillFrame"]:HookScript("OnShow", function(self)
		if Pr.FirstOpen then return end
		E:Delay(0.2, function()
			Pr.FirstOpen = true
			self.RecipeList.scrollBar:SetValue(0)
		end)
	end)

	if E.private.sle.professions.enchant.enchScroll then Pr:EnchantButton() end

	self:RegisterEvent("TRADE_SKILL_UPDATE", "UpdateSkills")
	self:RegisterEvent("CHAT_MSG_SKILL", "UpdateSkills")

	if E.private.sle.professions.deconButton.enable then Pr:InitializeDeconstruct() end
	if E.private.sle.professions.fishing.EasyCast then Pr:FishingInitialize() end
end
SLE:RegisterModule("Professions")