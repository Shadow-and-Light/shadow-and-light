local SLE, _, E = unpack(select(2, ...))
local Pr = SLE:NewModule("Professions", "AceHook-3.0", "AceEvent-3.0")

--GLOBALS: unpack, select, LoadAddOn, IsAddOnLoaded
local _G = _G
local GetSpellInfo, IsSpellKnown, GetProfessions, GetProfessionInfo = GetSpellInfo, IsSpellKnown, GetProfessions, GetProfessionInfo


-- Pr.DEname, Pr.LOCKname, Pr.SMITHname = false, false, false
function Pr:UpdateSkills(event)
	if event ~= "CHAT_MSG_SKILL" then
		Pr.DEname, Pr.LOCKname, Pr.SMITHname = false, false, false

		if(IsSpellKnown(13262)) then Pr.DEname = GetSpellInfo(13262) end --Enchant
		if(IsSpellKnown(1804)) then Pr.LOCKname = GetSpellInfo(1804) end --Lockpicking
		if(IsSpellKnown(31252)) then Pr.PROSPECTname = GetSpellInfo(31252) end --Jewelcrating
		if(IsSpellKnown(51005)) then Pr.MILLname = GetSpellInfo(51005) end --Milling
	end

	local prof1, prof2 = GetProfessions()
	if prof1 then
		local name, _, rank = GetProfessionInfo(prof1)
		if name == GetSpellInfo(7411) then
			Pr.DErank = rank
		end
	end
	if prof2 then
		local name, _, rank = GetProfessionInfo(prof2)
		if name == GetSpellInfo(7411) then
			Pr.DErank = rank
		end
	end
end

function Pr:Initialize()
	if not SLE.initialized then return end

	if not IsAddOnLoaded("Blizzard_TradeSkillUI") then LoadAddOn("Blizzard_TradeSkillUI") end
	--Next line is to fix other guys' code cause they feel like being assholes and morons
	if SLE._Compatibility["TradeSkillMaster"] and not TradeSkillFrame.RecipeList.collapsedCategories then TradeSkillFrame.RecipeList.collapsedCategories = {} end
	Pr:UpdateSkills()
	_G["TradeSkillFrame"]:HookScript("OnShow", function(frame)
		if Pr.FirstOpen then return end
		E:Delay(0.2, function()
			Pr.FirstOpen = true
			frame.RecipeList.scrollBar:SetValue(0)
		end)
	end)

	if E.private.sle.professions.enchant.enchScroll then Pr:EnchantButton() end

	self:RegisterEvent("CHAT_MSG_SKILL", "UpdateSkills")

	if E.private.sle.professions.deconButton.enable then Pr:InitializeDeconstruct() end
	if E.private.sle.professions.fishing.EasyCast then Pr:FishingInitialize() end
end
SLE:RegisterModule("Professions")