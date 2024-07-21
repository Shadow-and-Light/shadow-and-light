local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Pr = SLE.Professions
local S = E.Skins

local _G = _G
local C_TradeSkillUI_CraftRecipe = C_TradeSkillUI.CraftRecipe
local C_TradeSkillUI_IsTradeSkillGuild = C_TradeSkillUI.IsTradeSkillGuild
local C_TradeSkillUI_IsTradeSkillLinked = C_TradeSkillUI.IsTradeSkillLinked

local GetItemCount = C_Item and C_Item.GetItemCount or GetItemCount
local UseItemByName = C_Item and C_Item.UseItemByName or UseItemByName

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
