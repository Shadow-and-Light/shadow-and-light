local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:NewModule("QuestKingSkinner", "AceEvent-3.0")

QK.Replaces = {}
QK.Icons = {
	["Achievement_small"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Achievement_small]],
	["Daily"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Daily]],
	["Factions"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Factions]],
	["Flightmaster"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Flightmaster]],
	["Legendary"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Legendary]],
	["LFG"] = [[Interface\LFGFRAME\BattlenetWorking0]],
	["Portal_Blue"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Portal_Blue]],
	["Portal_Red"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Portal_Red]],
	["Quest"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Quest]],
	["Raid"] = [[Interface\LFGFRAME\UI-LFR-PORTRAIT]],
	["Skull"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Skull]],
	["Skull_Event"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Skull_Event]],
	["Swords"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Swords]],
	["Swords_Event"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Swords_Event]],
	["Weekly"] = [[Interface\AddOns\ElvUI_SLE\media\textures\Weekly]],
}

local function StartReplacement()
	if #QK.Replaces == 0 then E:Delay(1, function() StartReplacement() return end) end
	for i = 1, #QK.Replaces do
		QK.Replaces[i]()
	end
end

function QK:Initialize()
	if not E.private.sle.skins.QuestKing.enable or not SLE._Compatibility["QuestKing"] then return end
	StartReplacement()
end

SLE:RegisterModule(QK:GetName())