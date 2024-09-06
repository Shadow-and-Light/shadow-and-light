local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local UB = SLE.UIButtons
local lib = LibStub('LibElv-UIButtons-1.0')

--GLOBALS: DBM, LibStub, Altoholic, AtlasLoot, xCT_Plus, Swatter, SlashCmdList
local _G = _G
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local ADDONS, CUSTOM = ADDONS, CUSTOM
local RandomRoll = RandomRoll
local SendChatMessage = SendChatMessage
local ReloadUI = ReloadUI
local ShowUIPanel, HideUIPanel = ShowUIPanel, HideUIPanel

local function CustomRollCall()
	local min, max = tonumber(E.db.sle.uibuttons.customroll.min), tonumber(E.db.sle.uibuttons.customroll.max)
	if min <= max then
		RandomRoll(min, max)
	else
		SLE:Print(L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."])
	end
end

function UB:ConfigSetup(menu)
	menu:CreateDropdownButton('Config', 'Elv', '|cff1784d1ElvUI|r', L["ElvUI Config"], L["Click to toggle config window"],  function() if InCombatLockdown() then return end E:ToggleOptions() end, nil, true)
	menu:CreateDropdownButton('Config', 'SLE', '|cff9482c9S&L|r', L["S&L Config"], L["Click to toggle Shadow & Light config group"],  function() if InCombatLockdown() then return end E:ToggleOptions() E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'sle') end, nil, true)
	menu:CreateSeparator('Config', 'First', 4, 2)
	menu:CreateDropdownButton( 'Config', 'Reload', '/reloadui', L["Reload UI"], L["Click to reload your interface"],  function() ReloadUI() end, nil, true)
	menu:CreateDropdownButton('Config', 'MoveUI', '/moveui', L["Move UI"], L["Unlock various elements of the UI to be repositioned."],  function() if InCombatLockdown() then return end E:ToggleMoveMode() end, nil, true)
end

function UB:AddonSetup(menu)
	menu:CreateDropdownButton('Addon', 'Manager', ADDONS, L["AddOn Manager"], L["Click to toggle the AddOn Manager frame."],  function()
		if not _G.AddonList:IsShown() then ShowUIPanel(_G.AddonList) else HideUIPanel(_G.AddonList) end
	end, nil, true)

	menu:CreateDropdownButton('Addon', 'DBM', L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() DBM:LoadGUI() end, 'DBM-Core')
	menu:CreateDropdownButton('Addon', 'BigWigs', L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() LibStub('LibDataBroker-1.1'):GetDataObjectByName('BigWigs'):OnClick('RightButton') end, 'BigWigs')
	menu:CreateSeparator('Addon', 'First', 4, 2)
	menu:CreateDropdownButton('Addon', 'Altoholic', 'Altoholic', nil, nil, function() AltoholicFrame:ToggleUI() end, 'Altoholic')
	menu:CreateDropdownButton('Addon', 'AtlasLoot', 'AtlasLoot', nil, nil, function() AtlasLoot.GUI:Toggle() end, 'AtlasLoot')
	menu:CreateDropdownButton('Addon', 'WeakAuras', 'WeakAuras', nil, nil, function() SlashCmdList.WEAKAURAS('') end, 'WeakAuras')
	menu:CreateDropdownButton('Addon', 'xCT', 'xCT+', nil, nil, function() xCT_Plus:ToggleConfigTool() end, 'xCT+')
	menu:CreateDropdownButton('Addon', 'Swatter', 'Swatter', nil, nil, function() Swatter.ErrorShow() end, '!Swatter')


	--Always keep at the bottom--
	menu:CreateDropdownButton('Addon', 'WowLua', 'WowLua', nil, nil, function() SlashCmdList['WOWLUA']('') end, 'WowLua', false)
end

function UB:StatusSetup(menu)
	menu:CreateDropdownButton('Status', 'AFK', L["AFK"], nil, nil,  function() SendChatMessage('' ,'AFK' ) end)
	menu:CreateDropdownButton('Status', 'DND', L["DND"], nil, nil,  function() SendChatMessage('' ,'DND' ) end)
end

function UB:RollSetup(menu)
	menu:CreateDropdownButton('Roll', 'Ten', '1-10', nil, nil,  function() RandomRoll(1, 10) end)
	menu:CreateDropdownButton('Roll', 'Twenty', '1-20', nil, nil,  function() RandomRoll(1, 20) end)
	menu:CreateDropdownButton('Roll', 'Thirty', '1-30', nil, nil,  function() RandomRoll(1, 30) end)
	menu:CreateDropdownButton('Roll', 'Forty', '1-40', nil, nil,  function() RandomRoll(1, 40) end)
	menu:CreateDropdownButton('Roll', 'Hundred', '1-100', nil, nil,  function() RandomRoll(1, 100) end)
	menu:CreateDropdownButton('Roll', 'Custom', CUSTOM, nil, nil,  function() CustomRollCall() end)
end

function UB:SetupBar(menu)
	if E.private.sle.uibuttons.style == 'classic' then
		menu:CreateCoreButton('Config', 'C', function() E:ToggleOptions() end)
		menu:CreateCoreButton('Reload', 'R', function() ReloadUI() end)
		menu:CreateCoreButton('MoveUI', 'M', function() E:ToggleMoveMode() end)
		menu:CreateCoreButton('Boss', 'B', function()
			if C_AddOns_IsAddOnLoaded('DBM-Core') then
				DBM:LoadGUI()
			elseif C_AddOns_IsAddOnLoaded('BigWigs') then
				LibStub('LibDataBroker-1.1'):GetDataObjectByName('BigWigs'):OnClick('RightButton')
			end
		end)
		menu:CreateCoreButton('Addon', 'A', function() if not E:AlertCombat() and not AddonList:IsShown() then ShowUIPanel(AddonList) else HideUIPanel(AddonList) end end)
	else
		menu:CreateCoreButton('Config', 'C')
		UB:ConfigSetup(menu)

		menu:CreateCoreButton('Addon', 'A')
		UB:AddonSetup(menu)

		menu:CreateCoreButton('Status', 'S')
		UB:StatusSetup(menu)

		menu:CreateCoreButton('Roll', 'R')
		UB:RollSetup(menu)
	end
end

function UB:RightClicks(menu)
	if E.private.sle.uibuttons.style == 'classic' then return end
	for i = 1, #menu.ToggleTable do
		menu.ToggleTable[i]:RegisterForClicks('LeftButtonDown', 'RightButtonDown')
	end
	menu.Config.Toggle:HookScript('OnClick', function(self, button, down)
		if button == 'RightButton' and E.db.sle.uibuttons.Config.enable then
			menu.Config[menu.db.Config.called]:Click()
		end
	end)
	menu.Addon.Toggle:HookScript('OnClick', function(self, button, down)
		if button == 'RightButton' and E.db.sle.uibuttons.Addon.enable then
			menu.Addon[menu.db.Addon.called]:Click()
		end
	end)
	menu.Status.Toggle:HookScript('OnClick', function(self, button, down)
		if button == 'RightButton' and E.db.sle.uibuttons.Status.enable then
			menu.Status[menu.db.Status.called]:Click()
		end
	end)
	menu.Roll.Toggle:HookScript('OnClick', function(self, button, down)
		if button == 'RightButton' and E.db.sle.uibuttons.Roll.enable then
			menu.Roll[menu.db.Roll.called]:Click()
		end
	end)
end

function UB:Initialize()
	if not SLE.initialized then return end
	if E.private.sle.uiButtonStyle then
		E.private.sle.uibuttons.style = E.private.sle.uiButtonStyle
		E.private.sle.uiButtonStyle = nil
	end
	UB.Holder = lib:CreateFrame('SLE_UIButtons', E.db.sle.uibuttons, P.sle.uibuttons, E.private.sle.uibuttons.style, 'dropdown', E.private.sle.uibuttons.strata, E.private.sle.uibuttons.level, E.private.sle.uibuttons.transparent)
	local menu = UB.Holder
	menu:SetPoint('LEFT', E.UIParent, 'LEFT', -2, 0)
	menu:SetupMover(L["S&L UI Buttons"], 'ALL,S&L,S&L MISC')

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
	UB.Holder.mover:SetFrameLevel(305)
end

SLE:RegisterModule(UB:GetName())
