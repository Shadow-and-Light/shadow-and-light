local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local UB = SLE:NewModule('UIButtons', 'AceHook-3.0');
local lib = LibStub("LibElv-UIButtons-1.0")
local S = E:GetModule("Skins")
local RandomRoll = RandomRoll
local SendChatMessage = SendChatMessage

local function CustomRollCall()
	local min, max = T.tonumber(E.db.sle.uibuttons.customroll.min), T.tonumber(E.db.sle.uibuttons.customroll.max)
	if min <= max then
		RandomRoll(min, max)
	else
		SLE:Print(L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."])
	end
end

function UB:ConfigSetup(menu)
	--UB:CreateSeparator("Config", "SLE_StartSeparator", 1, 2)
	menu:CreateDropdownButton("Config", "Elv", "|cff1784d1ElvUI|r", L["ElvUI Config"], L["Click to toggle config window"],  function() if T.InCombatLockdown() then return end; E:ToggleConfig() end, nil, true)
	menu:CreateDropdownButton("Config", "SLE", "|cff9482c9S&L|r", L["S&L Config"], L["Click to toggle Shadow & Light config group"],  function() if T.InCombatLockdown() then return end; E:ToggleConfig(); SLE.ACD:SelectGroup("ElvUI", "sle") end, nil, true)
	menu:CreateSeparator("Config", "First", 4, 2)
	menu:CreateDropdownButton( "Config", "Reload", "/reloadui", L["Reload UI"], L["Click to reload your interface"],  function() ReloadUI() end, nil, true)
	menu:CreateDropdownButton("Config", "MoveUI", "/moveui", L["Move UI"], L["Click to unlock moving ElvUI elements"],  function() if T.InCombatLockdown() then return end; E:ToggleConfigMode() end, nil, true)
	--UB:CreateSeparator("Config", "SLE_EndSeparator", 1, 2)
end

function UB:AddonSetup(menu)
	--UB:CreateSeparator("Addon", "SLE_StartSeparator", 1, 2)
	menu:CreateDropdownButton("Addon", "Manager", L["AddOns"], L["AddOns Manager"], L["Click to toggle the AddOn Manager frame."],  function() GameMenuButtonAddons:Click() end, nil, true)

	menu:CreateDropdownButton("Addon", "DBM", L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() DBM:LoadGUI() end, "DBM-Core")
	menu:CreateDropdownButton("Addon", "VEM", L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() VEM:LoadGUI() end, "VEM-Core")
	menu:CreateDropdownButton("Addon", "BigWigs", L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() LibStub("LibDataBroker-1.1"):GetDataObjectByName("BigWigs"):OnClick("RightButton") end, "BigWigs")
	menu:CreateSeparator("Addon", "First", 4, 2)
	menu:CreateDropdownButton("Addon", "Altoholic", "Altoholic", nil, nil, function() Altoholic:ToggleUI() end, "Altoholic")
	menu:CreateDropdownButton("Addon", "AtlasLoot", "AtlasLoot", nil, nil, function() AtlasLoot.GUI:Toggle() end, "AtlasLoot")
	menu:CreateDropdownButton("Addon", "WeakAuras", "WeakAuras", nil, nil, function() SlashCmdList.WEAKAURAS() end, "WeakAuras")
	menu:CreateDropdownButton("Addon", "xCT", "xCT+", nil, nil, function() xCT_Plus:ToggleConfigTool() end, "xCT+")
	menu:CreateDropdownButton("Addon", "Swatter", "Swatter", nil, nil, function() Swatter.ErrorShow() end, "!Swatter")


	--Always keep at the bottom--
	menu:CreateDropdownButton("Addon", "WowLua", "WowLua", nil, nil, function() SlashCmdList["WOWLUA"]("") end, "WowLua", false)
	--UB:CreateSeparator("Addon", "SLE_EndSeparator", 1, 2)
end

function UB:StatusSetup(menu)
	menu:CreateDropdownButton("Status", "AFK", L["AFK"], nil, nil,  function() SendChatMessage("" ,"AFK" ) end)
	menu:CreateDropdownButton("Status", "DND", L["DND"], nil, nil,  function() SendChatMessage("" ,"DND" ) end)
end

function UB:RollSetup(menu)
	menu:CreateDropdownButton("Roll", "Ten", "1-10", nil, nil,  function() RandomRoll(1, 10) end)
	menu:CreateDropdownButton("Roll", "Twenty", "1-20", nil, nil,  function() RandomRoll(1, 20) end)
	menu:CreateDropdownButton("Roll", "Thirty", "1-30", nil, nil,  function() RandomRoll(1, 30) end)
	menu:CreateDropdownButton("Roll", "Forty", "1-40", nil, nil,  function() RandomRoll(1, 40) end)
	menu:CreateDropdownButton("Roll", "Hundred", "1-100", nil, nil,  function() RandomRoll(1, 100) end)
	menu:CreateDropdownButton("Roll", "Custom", L["Custom"], nil, nil,  function() CustomRollCall() end)
end

function UB:SetupBar(menu)
	if E.private.sle.uiButtonStyle == "classic" then
		menu:CreateCoreButton("Config", "C", function() E:ToggleConfig() end)
		menu:CreateCoreButton("Reload", "R", function() ReloadUI() end)
		menu:CreateCoreButton("MoveUI", "M", function(self) E:ToggleConfigMode() end)
		menu:CreateCoreButton("Boss", "B", function(self)
			if T.IsAddOnLoaded("DBM-Core") then
				DBM:LoadGUI()
			elseif T.IsAddOnLoaded("VEM-Core") then
				VEM:LoadGUI()
			elseif T.IsAddOnLoaded("BigWigs") then
				LibStub("LibDataBroker-1.1"):GetDataObjectByName("BigWigs"):OnClick("RightButton")
			end
		end)
		menu:CreateCoreButton("Addon", "A", function(self) GameMenuButtonAddons:Click() end)
	else
		menu:CreateCoreButton("Config", "C")
		UB:ConfigSetup(menu)

		menu:CreateCoreButton("Addon", "A")
		UB:AddonSetup(menu)

		menu:CreateCoreButton("Status", "S")
		UB:StatusSetup(menu)

		menu:CreateCoreButton("Roll", "R")
		UB:RollSetup(menu)
	end
end

function UB:RightClicks(menu)
	if E.private.sle.uiButtonStyle == "classic" then return end
	for i = 1, #menu.ToggleTable do
		menu.ToggleTable[i]:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	end
	menu.Config.Toggle:HookScript("OnClick", function(self, button, down)
		if button == "RightButton" and E.db.sle.uibuttons.Config.enable then
			menu.Config[menu.db.Config.called]:Click()
		end
	end)
	menu.Addon.Toggle:HookScript("OnClick", function(self, button, down)
		if button == "RightButton" and E.db.sle.uibuttons.Addon.enable then
			menu.Addon[menu.db.Addon.called]:Click()
		end
	end)
	menu.Status.Toggle:HookScript("OnClick", function(self, button, down)
		if button == "RightButton" and E.db.sle.uibuttons.Status.enable then
			menu.Status[menu.db.Status.called]:Click()
		end
	end)
	menu.Roll.Toggle:HookScript("OnClick", function(self, button, down)
		if button == "RightButton" and E.db.sle.uibuttons.Roll.enable then
			menu.Roll[menu.db.Roll.called]:Click()
		end
	end)
end

function UB:Initialize()
	if not SLE.initialized then return end
	UB.Holder = lib:CreateFrame("SLE_UIButtons", E.db.sle.uibuttons, P.sle.uibuttons, E.private.sle.uiButtonStyle, "dropdown")
	local menu = UB.Holder
	menu:Point("LEFT", E.UIParent, "LEFT", -2, 0);
	menu:SetupMover(L["S&L UI Buttons"], "ALL,S&L,S&L MISC")

	function UB:ForUpdateAll()
		UB.Holder.db = E.db.sle.uibuttons
		UB.Holder:ToggleShow()
		UB.Holder:FrameSize()
	end

	UB:SetupBar(menu)

	menu:FrameSize()
	menu:ToggleShow()

	UB.FrameSize = menu.FrameSize

	UB:RightClicks(menu)
end

SLE:RegisterModule(UB:GetName())