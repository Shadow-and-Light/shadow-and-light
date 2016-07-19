local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Pr = SLE:GetModule("Professions")
local S = E:GetModule("Skins")
-- GLOBALS: CreateFrame
local _G = _G
local UseItemByName = UseItemByName
local C_TradeSkillUI = C_TradeSkillUI
Pr.DErank = 0
Pr.EnchantSkillTable = {
	[2] = { --Greens
		[1] = 1,
		[25] = 21,
		[50] = 26,
		[75] = 31,
		[100] = 36,
		[125] = 41,
		[150] = 46,
		[175] = 51,
		[200] = 56,
		[225] = 61,
		[275] = 102,
		[325] = 130,
		[350] = 154,
		[425] = 232,
		[475] = 372,
	},
	[3] = { --Blues
		[25] = 10,
		[50] = 26,
		[75] = 31,
		[100] = 36,
		[125] = 41,
		[150] = 46,
		[175] = 51,
		[200] = 56,
		[225] = 61,
		[275] = 100,
		[325] = 130,
		[450] = 288,
		[525] = 417,
		[550] = 425,
	},
	[4] = { --Epics
		[225] = 61,
		[300] = 100,
		[375] = 200,
		[475] = 300,
		[575] = 420,
	},
}

function Pr:EnchantButton()
	local button = CreateFrame("Button", "SLE_EnchScrollButton", _G["TradeSkillFrame"], "MagicButtonTemplate")
	if E.private.skins.blizzard.tradeskill == true and E.private.skins.blizzard.enable == true then
		S:HandleButton(button)
		button:StripTextures()
		button:SetTemplate('Default', true)
		button:ClearAllPoints()
		button:SetPoint("TOPRIGHT", _G["TradeSkillFrame"].DetailsFrame.CreateButton, "TOPLEFT", -1, 0)
	else
		button:SetPoint("TOPRIGHT", _G["TradeSkillFrame"].DetailsFrame.CreateButton, "TOPLEFT")
	end
	button:SetScript("OnClick", function()
		C_TradeSkillUI.CraftRecipe(_G["TradeSkillFrame"].DetailsFrame.selectedRecipeID)
		UseItemByName(38682)
	end)
	local EnchName = T.GetSpellInfo(7411)

	local function UpdateScrollButton(frame)
		if not frame.selectedRecipeID then return end
		local _, CURRENT_TRADESKILL = C_TradeSkillUI.GetTradeSkillLine()
		if CURRENT_TRADESKILL ~= EnchName then _G["SLE_EnchScrollButton"]:Hide() return end

		local recipeInfo = C_TradeSkillUI.GetRecipeInfo(frame.selectedRecipeID)
		if C_TradeSkillUI.IsTradeSkillGuild() or C_TradeSkillUI.IsTradeSkillLinked() then
			_G["SLE_EnchScrollButton"]:Hide()
		elseif recipeInfo.alternateVerb then
			_G["SLE_EnchScrollButton"]:Show()
			local scrollnum = T.GetItemCount(38682)
			_G["SLE_EnchScrollButton"]:SetText(L['Scroll'].." ("..scrollnum..")")
			if recipeInfo.craftable and scrollnum > 0 then
				_G["SLE_EnchScrollButton"]:Enable()
			else
				_G["SLE_EnchScrollButton"]:Disable()
			end
		else
			_G["SLE_EnchScrollButton"]:Hide()
		end
	end
	hooksecurefunc(_G["TradeSkillFrame"].DetailsFrame, "Refresh", UpdateScrollButton)
end