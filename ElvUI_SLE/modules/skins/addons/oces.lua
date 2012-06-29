local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
	S:HandleButton(TradeSkillCreateScrollButton, true)
end
S:RegisterSkin('OneClickEnchantScroll', LoadSkin)