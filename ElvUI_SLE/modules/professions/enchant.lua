local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Pr = SLE.Professions
local S = E.Skins

-- GLOBALS: CreateFrame, hooksecurefunc
local _G = _G
local UseItemByName = UseItemByName
local GetRecipeInfo = C_TradeSkillUI.GetRecipeInfo
local IsTradeSkillLinked = C_TradeSkillUI.IsTradeSkillLinked
local IsTradeSkillGuild = C_TradeSkillUI.IsTradeSkillGuild
local CraftRecipe = C_TradeSkillUI.CraftRecipe

function Pr:EnchantButton()
	local button = CreateFrame('Button', 'SLE_EnchScrollButton', _G.ProfessionsFrame, 'MagicButtonTemplate, BackdropTemplate')
	if E.private.skins.blizzard.tradeskill == true and E.private.skins.blizzard.enable == true then
		S:HandleButton(button)
		button:StripTextures()
		button:SetTemplate('Default', true)
		button:ClearAllPoints()
		button:SetPoint('TOPRIGHT', _G.ProfessionsFrame.CraftingPage.CreateButton, 'TOPLEFT', -1, 0)
	else
		button:SetPoint('TOPRIGHT', _G.ProfessionsFrame.CraftingPage.CreateButton, 'TOPLEFT')
	end
	button:SetScript('OnClick', function()
		CraftRecipe(_G.ProfessionsFrame.CraftingPage.SchematicForm:GetRecipeInfo().recipeID)
		UseItemByName(38682)
	end)
	button:SetMotionScriptsWhileDisabled(true)

	local function UpdateScrollButton(frame)
		if not frame.SchematicForm then return end
		if not Pr:IsSkillMine() then _G.SLE_EnchScrollButton:Hide() return end

		local skillInfo = C_TradeSkillUI.GetBaseProfessionInfo()
		if Pr.baseTradeSkills.Enchanting ~= skillInfo.parentProfessionId and Pr.baseTradeSkills.Enchanting ~= skillInfo.professionID then
			_G.SLE_EnchScrollButton:Hide()
			return
		end

		local recipeInfo = frame.SchematicForm:GetRecipeInfo()

		if not recipeInfo then return end
		if IsTradeSkillGuild() or IsTradeSkillLinked() then
			_G.SLE_EnchScrollButton:Hide()
		elseif recipeInfo.alternateVerb then
			_G.SLE_EnchScrollButton:Show()
			local scrollnum = GetItemCount(38682)
			_G.SLE_EnchScrollButton:SetText(string.format('%s (%d)', L["Scroll"], scrollnum))
			if recipeInfo.craftable and recipeInfo.learned and scrollnum > 0 then
				_G.SLE_EnchScrollButton:Enable()
			else
				_G.SLE_EnchScrollButton:Disable()
			end
		else
			_G.SLE_EnchScrollButton:Hide()
		end
	end
	hooksecurefunc(_G.ProfessionsFrame.CraftingPage, 'Refresh', UpdateScrollButton)
end
