local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local S = E:GetModule('Skins')

local function LoadSkin()
	S:HandleButton(TradeSkillCreateScrollButton, true)
end
S:RegisterSkin('OneClickEnchantScroll', LoadSkin)