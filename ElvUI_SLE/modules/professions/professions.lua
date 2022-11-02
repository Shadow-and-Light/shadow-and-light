local SLE, _, E = unpack(select(2, ...))
local Pr = SLE.Professions

--GLOBALS: unpack, select, LoadAddOn, IsAddOnLoaded
local _G = _G
local GetSpellInfo, IsSpellKnown = GetSpellInfo, IsSpellKnown
local IsNPCCrafting = C_TradeSkillUI.IsNPCCrafting
local IsTradeSkillGuild = C_TradeSkillUI.IsTradeSkillGuild
local IsTradeSkillGuildMember = C_TradeSkillUI.IsTradeSkillGuildMember
local IsTradeSkillLinked = C_TradeSkillUI.IsTradeSkillLinked

Pr.baseTradeSkills = {
	Alchemy = 171,
	Archeology = 794,
	Blacksmithing = 164,
	Cooking = 185,
	Enchanting = 333,
	Engineering = 202,
	FirstAid = 129,
	Fishing = 356,
	Herbalism = 182,
	Inscription = 773,
	Jewelcrafting = 755,
	Leatherworking = 165,
	Mining = 186,
	Skinning = 393,
	Tailoring = 197,
}

function Pr:UpdateSkills(event)
	if event ~= 'CHAT_MSG_SKILL' then
		Pr.DEname, Pr.LOCKname, Pr.SMITHname = false, false, false

		if(IsSpellKnown(13262)) then Pr.DEname = GetSpellInfo(13262) end --Enchant
		if(IsSpellKnown(1804)) then Pr.LOCKname = GetSpellInfo(1804) end --Lockpicking
		if(IsSpellKnown(31252)) then Pr.PROSPECTname = GetSpellInfo(31252) end --Jewelcrating
		if(IsSpellKnown(51005)) then Pr.MILLname = GetSpellInfo(51005) end --Milling
	end
end

function Pr:IsSkillMine()
	local npc = IsNPCCrafting()
	if npc then return false end
	local guild = IsTradeSkillGuild()
	if guild then return false end
	local member = IsTradeSkillGuildMember()
	if member then return false end
	local linked = IsTradeSkillLinked()
	if linked then return false end
	return true
end

function Pr:Initialize()
	if not SLE.initialized then return end

	if not IsAddOnLoaded('Blizzard_TradeSkillUI') then LoadAddOn('Blizzard_TradeSkillUI') end
	--Next line is to fix other guys' code cause they feel like being assholes and morons
	-- if SLE._Compatibility["TradeSkillMaster"] and not TradeSkillFrame.RecipeList.collapsedCategories then TradeSkillFrame.RecipeList.collapsedCategories = {} end
	Pr:UpdateSkills()

	if E.private.sle.professions.enchant.enchScroll then Pr:EnchantButton() end

	self:RegisterEvent('CHAT_MSG_SKILL', 'UpdateSkills')

	if E.private.sle.professions.deconButton.enable then Pr:InitializeDeconstruct() end
	if E.private.sle.professions.fishing.EasyCast then Pr:FishingInitialize() end
end
SLE:RegisterModule('Professions')
