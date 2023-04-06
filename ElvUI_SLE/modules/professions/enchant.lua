local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Pr = SLE.Professions
local S = E.Skins

local _G = _G
local C_TradeSkillUI_CraftRecipe = C_TradeSkillUI.CraftRecipe
local C_TradeSkillUI_IsTradeSkillGuild = C_TradeSkillUI.IsTradeSkillGuild
local C_TradeSkillUI_IsTradeSkillLinked = C_TradeSkillUI.IsTradeSkillLinked
local UseItemByName = UseItemByName

local button

local function ShouldShowButton(recipeInfo)
	if (recipeInfo and recipeInfo.isEnchantingRecipe) and (not C_TradeSkillUI_IsTradeSkillGuild() or not C_TradeSkillUI_IsTradeSkillLinked()) then
		return true
	end
	return false
end

local function UpdateButtonText(recipeInfo)
	local scrollCount = GetItemCount(38682)
	button:SetText(format('%s (%d)', L["Scroll"], scrollCount))
	if recipeInfo and recipeInfo.craftable and recipeInfo.learned and scrollCount > 0 then
		button:Enable()
	else
		button:Disable()
	end
end

function Pr:UpdateButtonInfo(recipeInfo)
	UpdateButtonText(recipeInfo)
	button:SetShown(ShouldShowButton(recipeInfo))
end

function Pr:EnchantButton()
	if not E.private.sle.professions.enchant.enchScroll then return end
	button = CreateFrame('Button', 'SL_EnchantScrollButton', _G.ProfessionsFrame.CraftingPage.CreateAllButton, 'MagicButtonTemplate, BackdropTemplate')
	button:Hide()
	if E.private.skins.blizzard.tradeskill and E.private.skins.blizzard.enable then
		S:HandleButton(button)
		button:SetTemplate('Default', true)
		button:ClearAllPoints()
		button:SetPoint('TOPRIGHT', _G.ProfessionsFrame.CraftingPage.CreateAllButton, 'TOPLEFT', -1, 0)
	else
		button:SetPoint('TOPRIGHT', _G.ProfessionsFrame.CraftingPage.CreateAllButton, 'TOPLEFT')
	end
	button:SetMotionScriptsWhileDisabled(true)
	button:SetScript('OnClick', function()
		C_TradeSkillUI_CraftRecipe(_G.ProfessionsFrame.CraftingPage.SchematicForm:GetRecipeInfo().recipeID)
		UseItemByName(38682)
	end)
	hooksecurefunc(_G.ProfessionsFrame.CraftingPage, 'Refresh', function(CraftingPage)
		if not CraftingPage.SchematicForm or not CraftingPage.SchematicForm.currentRecipeInfo then return end
		Pr:UpdateButtonInfo(CraftingPage.SchematicForm.currentRecipeInfo)
	end)

	Pr:RegisterEvent('ITEM_COUNT_CHANGED', function(_, itemID)
		if not itemID or itemID ~= 38682 then return end
		UpdateButtonText(_G.ProfessionsFrame.CraftingPage.SchematicForm.currentRecipeInfo)
	end)
	EventRegistry:RegisterCallback('ProfessionsRecipeListMixin.Event.OnRecipeSelected', Pr.UpdateButtonInfo)
end
