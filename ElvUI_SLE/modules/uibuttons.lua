local E, L, V, P, G = unpack(ElvUI); 
local UB = E:GetModule('SLE_UIButtons');
local ACD = LibStub("AceConfigDialog-3.0")
local SLE = E:GetModule("SLE")
local Sk = E:GetModule("Skins")

local BorderColor = E['media'].bordercolor
local NumBut = 4
UB.ToggleTable = {}
UB.ConfigTable = {}
UB.AddonTable = {}
UB.StatusTable = {}
UB.RollTable = {}

local function CustomRollCall()
	local min, max = tonumber(E.db.sle.uibuttons.roll.min), tonumber(E.db.sle.uibuttons.roll.max)
	if min <= max then
		RandomRoll(min, max)
	else
		SLE:Print(L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."])
	end
end

function UB:OnEnter(self)
	UB.menuHolder:SetAlpha(1)
end

function UB:OnLeave(self)
	if E.db.sle.uibuttons.mouse then
		UB.menuHolder:SetAlpha(0)
	end
end

function UB:UpdateMouseOverSetting()
	if E.db.sle.uibuttons.mouse then
		UB.menuHolder:SetAlpha(0)
	else
		UB.menuHolder:SetAlpha(1)
	end
end

function UB:CreateFrame()
	UB.menuHolder = CreateFrame("Frame", "SLEUIButtonHolder", E.UIParent)
	UB.menuHolder:SetFrameStrata("HIGH")
	UB.menuHolder:SetFrameLevel(5)
	UB.menuHolder:SetClampedToScreen(true)
	UB.menuHolder:Point("LEFT", E.UIParent, "LEFT", -2, 0);
	UB.menuHolder:HookScript('OnEnter', UB.OnEnter)
	UB.menuHolder:HookScript('OnLeave', UB.OnLeave)

	if E.private.sle.uiButtonStyle == "classic" then
		UB:CreateCoreButton("Config", "C")
		UB:CreateCoreButton("Reload", "R")
		UB:CreateCoreButton("MoveUI", "M")
		UB:CreateCoreButton("Boss", "B")
		UB:CreateCoreButton("Addon", "A")
		NumBut = 5

		UB:ClassicSetup()

		UB.ToggleTable = {
			UB.menuHolder.Config,
			UB.menuHolder.Reload,
			UB.menuHolder.MoveUI,
			UB.menuHolder.Boss,
			UB.menuHolder.Addon,
		}
	else
		UB.menuHolder.Config = CreateFrame("Frame", "SLEUIConfigHolder", UB.menuHolder)
		UB.menuHolder.Config:CreateBackdrop("Transparent")
		UB:CreateCoreButton("Config", "C")
		UB:ConfigSetup()

		UB.menuHolder.Addon = CreateFrame("Frame", "SLEUIAddonHolder", UB.menuHolder)
		UB.menuHolder.Addon:CreateBackdrop("Transparent")
		UB:CreateCoreButton("Addon", "A")
		UB:AddonSetup()

		UB.menuHolder.Status = CreateFrame("Frame", "SLEUIStatusHolder", UB.menuHolder)
		UB.menuHolder.Status:CreateBackdrop("Transparent")
		UB:CreateCoreButton("Status", "S")
		UB:StatusSetup()

		UB.menuHolder.Roll = CreateFrame("Frame", "SLEUIRollHolder", UB.menuHolder)
		UB.menuHolder.Roll:CreateBackdrop("Transparent")
		UB:CreateCoreButton("Roll", "R")
		UB:RollSetup()

		UB.ToggleTable = {
			UB.menuHolder.Config.Toggle,
			UB.menuHolder.Addon.Toggle,
			UB.menuHolder.Status.Toggle,
			UB.menuHolder.Roll.Toggle,
		}
	end
end

function UB:CreateCoreButton(name, text)
	local button
	if E.private.sle.uiButtonStyle == "classic" then
		UB.menuHolder[name] = CreateFrame("Button", "SLEUI"..name, UB.menuHolder)
		button = UB.menuHolder[name]
	else
		UB.menuHolder[name].Toggle = CreateFrame("Button", "SLEUI"..name.."Toggle", UB.menuHolder)
		button = UB.menuHolder[name].Toggle
	end
	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetPoint("CENTER", button, "CENTER", 0, 0)
	UB.menuHolder[name]:HookScript('OnEnter', UB.OnEnter)
	UB.menuHolder[name]:HookScript('OnLeave', UB.OnLeave)
	Sk:HandleButton(button)
	
	if text then
		local t = button:CreateFontString(nil,"OVERLAY",button)
		t:FontTemplate()
		t:SetPoint("CENTER", button, 'CENTER', 0, -1)
		t:SetJustifyH("CENTER")
		t:SetText(text)
		button:SetFontString(t)
	end
end

--[[
A function to create a dropdown button for pretty much anything in any UB's dropdown.
UB:CreateDropdownButton(always, parent, name, text, tooltip1, tooltip2, click, addon)

always - (boolean) true if the button should be shown no matter what
parent - (string) a group the button will be in: Config, Addon, Status, Roll
name - (string) unique button's name used for table reference and actual name creation
text - (string) a string that will be shown on button
tooltip1 (string) - upper line of button's tooltip shown in yellow-ish color. Mandatory for creating a tooltip. If tooltip is not needed set to nil
tooltip2 (string) - lower line of the tooltip shown in white color. If not needed set to nil
click - (function) a function executed on button click. Preferably in the form of function() <your stuff here> end
addon (string) - if button's function requires an addon to function should be addon's name for IsAddOnLoaded check. the button will not be shown if check is failed.

To hook your button into UB dropdown use this method:

local E = ElvUI[1]
local UB = E:GetModule('SLE_UIButtons');
local function MyButtonInsert()
	UB:CreateDropdownButton(always, parent, name, text, tooltip1, tooltip2, click, addon)
end
hooksecurefunc(UB, "InsertButtons", MyButtonInsert)

You can have as many buttons created inside your function as you want.
]]

function UB:CreateDropdownButton(always, parent, name, text, tooltip1, tooltip2, click, addon)
	if type(always) ~= "boolean" then
		SLE:Print(format("You function contains unappropriate type for 1st argument \""..E["media"].hexvaluecolor.."always|r\" in function "..E["media"].hexvaluecolor.."UB:CreateDropdownButton|r. Your type is "..E["media"].hexvaluecolor.."%s|r (should be \"boolean\"). Parent: "..E["media"].hexvaluecolor.."%s|r. Name: "..E["media"].hexvaluecolor.."%s|r", type(always), parent, name))
		return
	elseif not UB.menuHolder[parent] then
		SLE:Print(format("You function contains unappropriate type for 2nd argument \""..E["media"].hexvaluecolor.."parent|r\" in function "..E["media"].hexvaluecolor.."UB:CreateDropdownButton|r. Parent frame: "..E["media"].hexvaluecolor.."UB.menuHolder.%s|r doesn't exist.", parent))
		return
	elseif not name or type(name) ~= "string" then
		SLE:Print(format("You function contains unappropriate type for 3rd argument \""..E["media"].hexvaluecolor.."name|r\" in function "..E["media"].hexvaluecolor.."UB:CreateDropdownButton|r. Your type is "..E["media"].hexvaluecolor.."%s|r (should be \"strigh\"). Parent: "..E["media"].hexvaluecolor.."%s|r.", type(name), parent))
		return
	elseif type(click) ~= "function" then
		SLE:Print(format("You function contains unappropriate type for 7th argument \""..E["media"].hexvaluecolor.."click|r\" in function "..E["media"].hexvaluecolor.."UB:CreateDropdownButton|r. Your type is "..E["media"].hexvaluecolor.."%s|r (should be \"function\"). Parent: "..E["media"].hexvaluecolor.."%s|r. Name: "..E["media"].hexvaluecolor.."%s|r", type(click), parent, name))
		return
	elseif (tooltip1 and type(tooltip1) ~= "string") or (tooltip2 and type(tooltip2) ~= "string") then
		SLE:Print(format("You function contains unappropriate type for 5th or 6th argument \""..E["media"].hexvaluecolor.."tooltip|r\" in function "..E["media"].hexvaluecolor.."UB:CreateDropdownButton|r. Parent: "..E["media"].hexvaluecolor.."%s|r. Name: "..E["media"].hexvaluecolor.."%s|r", parent, name))
		return
	elseif (addon and type(addon) ~= "string" and type(addon) ~= nil and name ~= "Boss") then
		SLE:Print(format("You function contains unappropriate type for 8rd argument \""..E["media"].hexvaluecolor.."addon|r\" in function "..E["media"].hexvaluecolor.."UB:CreateDropdownButton|r. Your type is "..E["media"].hexvaluecolor.."%s|r (should be \"strigh\"). Parent: "..E["media"].hexvaluecolor.."%s|r. Name: "..E["media"].hexvaluecolor.."%s|r", type(addon), parent, name))
		return
	end
	UB.menuHolder[parent][name] = CreateFrame("Button", "SLEUI"..parent..name, UB.menuHolder[parent])
	local b = UB.menuHolder[parent][name]
	local toggle = UB.menuHolder[parent].Toggle
	if addon and name == "Boss" then
		b.shown = true
		b.bossmode = function() end
		if IsAddOnLoaded("DBM-Core") then
			b.bossmode = function() DBM:LoadGUI() end
		-- elseif IsAddOnLoaded("Bigwigs") then
			-- b.bossmode = function() end
		elseif IsAddOnLoaded("VEM-Core") then
			b.bossmode = function() VEM:LoadGUI() end
		-- elseif IsAddOnLoaded("DXE_Loader") then
			-- b.bossmode = function() end
		-- elseif IsAddOnLoaded("") then
			-- b.bossmode = function() end
		else
			b.shown = false
		end
	elseif always and type(always) == "boolean" then
		b.shown = true
	elseif addon then
		if IsAddOnLoaded(addon) then
			b.shown = true
		else
			b.shown = false
		end
	end
	if not b.shown then return end
	
	b:SetScript("OnClick", function(self)
		click()
		toggle.opened = false
		UB:ToggleCats()
	end)

	if tooltip1 then
		b:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(tooltip1, 1, .96, .41, .6, .6, 1)
			if tooltip2 then GameTooltip:AddLine(tooltip2, 1, 1, 1, 1, 1, 1) end
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", function(self)
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
	else
		b:HookScript('OnEnter', UB.OnEnter)
		b:HookScript('OnEnter', UB.OnEnter)
	end
	Sk:HandleButton(b)
	
	if text and type(text) == "string" then
		b.text = b:CreateFontString(nil,"OVERLAY",b)
		b.text:FontTemplate()
		b.text:SetPoint("CENTER", b, 'CENTER', 0, -1)
		b.text:SetJustifyH("CENTER")
		b.text:SetText(text)
		b:SetFontString(b.text)
	end
	
	tinsert(UB[parent.."Table"], b)
end

function UB:CreateSeparator(parent, name, size, space)
	UB.menuHolder[parent][name] = CreateFrame("Frame", "SLEUI"..parent..name, UB.menuHolder[parent])
	local f = UB.menuHolder[parent][name]
	f.isSeparator = true
	f.shown = true
	f.size = size or 1
	f.space = space or 2
	f:CreateBackdrop("Transparent")
	
	tinsert(UB[parent.."Table"], f)
end

function UB:ToggleCats()
	if UB.menuHolder.Config.Toggle.opened then
		UB.menuHolder.Config:Show()
	else
		UB.menuHolder.Config:Hide()
	end
	if UB.menuHolder.Addon.Toggle.opened then
		UB.menuHolder.Addon:Show()
	else
		UB.menuHolder.Addon:Hide()
	end
	if UB.menuHolder.Status.Toggle.opened then
		UB.menuHolder.Status:Show()
	else
		UB.menuHolder.Status:Hide()
	end
	if UB.menuHolder.Roll.Toggle.opened then
		UB.menuHolder.Roll:Show()
	else
		UB.menuHolder.Roll:Hide()
	end
end

function UB:ClassicSetup()
	local button
	local db = E.db.sle.uibuttons

	button = UB.menuHolder.Config
	button:SetScript("OnClick", function(self)
		E:ToggleConfig()
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)

	button = UB.menuHolder.Reload
	button:SetScript("OnClick", function(self)
		ReloadUI()
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)

	button = UB.menuHolder.MoveUI
	button:SetScript("OnClick", function(self)
		E:ToggleConfigMode()
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)

	button = UB.menuHolder.Boss
	button:SetScript("OnClick", function(self)
		if IsAddOnLoaded("DBM-Core") then
			DBM:LoadGUI()
		-- elseif IsAddOnLoaded("Bigwigs") then
			-- b.bossmode = function() end
		elseif IsAddOnLoaded("VEM-Core") then
			VEM:LoadGUI()
		-- elseif IsAddOnLoaded("DXE_Loader") then
			-- b.bossmode = function() end
		-- elseif IsAddOnLoaded("") then
			-- b.bossmode = function() end
		end
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)

	button = UB.menuHolder.Addon
	button:SetScript("OnClick", function(self)
		GameMenuButtonAddons:Click()
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)
end

function UB:ConfigSetup()
	local button = UB.menuHolder.Config.Toggle
	local db = E.db.sle.uibuttons
	button.opened = false
	
	UB.menuHolder.Config:Hide()
	button:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	button:SetScript("OnClick", function(self, button, down)
		if button == "LeftButton" then
			if self.opened then
				self.opened = false
			else
				self.opened = true
				UB.menuHolder.Addon.Toggle.opened = false
				UB.menuHolder.Status.Toggle.opened = false
				UB.menuHolder.Roll.Toggle.opened = false
			end
			UB:ToggleCats()
		elseif button == "RightButton" and E.db.sle.uibuttons.cfunc.enable then
			UB.menuHolder.Config[E.db.sle.uibuttons.cfunc.called]:Click()
		end
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)

	--UB:CreateSeparator("Config", "SLE_StartSeparator", 1, 2)
	UB:CreateDropdownButton(true, "Config", "Elv", "ElvUI", L["ElvUI Config"], L["Click to toggle config window"],  function() E:ToggleConfig() end)
	UB:CreateDropdownButton(true, "Config", "SLE", "S&L", L["S&L Config"], L["Click to toggle Shadow & Light config group"],  function() E:ToggleConfig(); ACD:SelectGroup("ElvUI", "sle", "options") end)
	UB:CreateSeparator("Config", "SLE_FirstSeparator", 4, 2)
	UB:CreateDropdownButton(true, "Config", "Reload", "/reloadui", L["Reload UI"], L["Click to reload your interface"],  function() ReloadUI() end)
	UB:CreateDropdownButton(true, "Config", "MoveUI", "/moveui", L["Move UI"], L["Click to unlock moving ElvUI elements"],  function() E:ToggleConfigMode() end)
	--UB:CreateSeparator("Config", "SLE_EndSeparator", 1, 2)
end

function UB:AddonSetup()
	local button = UB.menuHolder.Addon.Toggle
	button.opened = false
	UB.menuHolder.Addon:Hide()

	button:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	button:SetScript("OnClick", function(self, button, down)
		if button == "LeftButton" then
			if self.opened then
				self.opened = false
			else
				self.opened = true
				UB.menuHolder.Config.Toggle.opened = false
				UB.menuHolder.Status.Toggle.opened = false
				UB.menuHolder.Roll.Toggle.opened = false
			end
			UB:ToggleCats()
		elseif button == "RightButton" and E.db.sle.uibuttons.afunc.enable then
			UB.menuHolder.Addon[E.db.sle.uibuttons.afunc.called]:Click()
		end
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)
	
	--UB:CreateSeparator("Addon", "SLE_StartSeparator", 1, 2)
	UB:CreateDropdownButton(true, "Addon", "Manager", L["AddOns"], L["AddOns Manager"], L["Click to toggle the AddOn Manager frame."],  function() GameMenuButtonAddons:Click() end)
	UB:CreateDropdownButton(false, "Addon", "Boss", L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() UB.menuHolder.Addon.Boss.bossmode() end, true)
	UB:CreateSeparator("Addon", "SLE_FirstSeparator", 4, 2)
	UB:CreateDropdownButton(false, "Addon", "Altoholic", "Altoholic", nil, nil, function() Altoholic:ToggleUI() end, "Altoholic")
	UB:CreateDropdownButton(false, "Addon", "AtlasLoot", "AtlasLoot", nil, nil, function() AtlasLoot.GUI:Toggle() end, "AtlasLoot")
	UB:CreateDropdownButton(false, "Addon", "WeakAuras", "WeakAuras", nil, nil, function() SlashCmdList.WEAKAURAS() end, "WeakAuras")
	UB:CreateDropdownButton(false, "Addon", "xCT", "xCT+", nil, nil, function() xCT_Plus:ToggleConfigTool() end, "xCT+")
	UB:CreateDropdownButton(false, "Addon", "Swatter", "Swatter", nil, nil, function() Swatter.ErrorShow() end, "!Swatter")


	--Always keep at the bottom--
	UB:CreateDropdownButton(false, "Addon", "WowLua", "WowLua", nil, nil, function() SlashCmdList["WOWLUA"]("") end, "WowLua")
	--UB:CreateSeparator("Addon", "SLE_EndSeparator", 1, 2)
end

function UB:StatusSetup()
	local button = UB.menuHolder.Status.Toggle
	local db = E.db.sle.uibuttons
	button.opened = false
	UB.menuHolder.Status:Point("TOP", button, "BOTTOM", 0, -4)
	UB.menuHolder.Status:Hide()
	button:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	button:SetScript("OnClick", function(self, button, down)
		if button == "LeftButton" then
			if self.opened then
				self.opened = false
			else
				self.opened = true
				UB.menuHolder.Config.Toggle.opened = false
				UB.menuHolder.Addon.Toggle.opened = false
				UB.menuHolder.Roll.Toggle.opened = false
			end
			UB:ToggleCats()
		elseif button == "RightButton" and E.db.sle.uibuttons.sfunc.enable then
			UB.menuHolder.Status[E.db.sle.uibuttons.sfunc.called]:Click()
		end
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)

	UB:CreateDropdownButton(true, "Status", "AFK", L["AFK"], nil, nil,  function() SendChatMessage("" ,"AFK" ) end)
	UB:CreateDropdownButton(true, "Status", "DND", L["DND"], nil, nil,  function() SendChatMessage("" ,"DND" ) end)
end

function UB:RollSetup()
	local button = UB.menuHolder.Roll.Toggle
	local db = E.db.sle.uibuttons
	button.opened = false
	UB.menuHolder.Roll:Point("TOP", button, "BOTTOM", 0, -4)
	UB.menuHolder.Roll:Hide()
	button:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	button:SetScript("OnClick", function(self, button, down)
		if button == "LeftButton" then
			if self.opened then
				self.opened = false
			else
				self.opened = true
				UB.menuHolder.Config.Toggle.opened = false
				UB.menuHolder.Addon.Toggle.opened = false
				UB.menuHolder.Status.Toggle.opened = false
			end
			UB:ToggleCats()
		elseif button == "RightButton" and E.db.sle.uibuttons.rfunc.enable then
			UB.menuHolder.Roll[E.db.sle.uibuttons.rfunc.called]:Click()
		end
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)
	
	UB:CreateDropdownButton(true, "Roll", "Ten", "1-10", nil, nil,  function() RandomRoll(1, 10) end)
	UB:CreateDropdownButton(true, "Roll", "Twenty", "1-20", nil, nil,  function() RandomRoll(1, 20) end)
	UB:CreateDropdownButton(true, "Roll", "Thirty", "1-30", nil, nil,  function() RandomRoll(1, 30) end)
	UB:CreateDropdownButton(true, "Roll", "Forty", "1-40", nil, nil,  function() RandomRoll(1, 40) end)
	UB:CreateDropdownButton(true, "Roll", "Hundred", "1-100", nil, nil,  function() RandomRoll(1, 100) end)
	UB:CreateDropdownButton(true, "Roll", "Custom", L["Custom"], nil, nil,  function() CusomRollCall() end)
end

function UB:MoverSize()
	local db = E.db.sle.uibuttons
	if db.position == "uib_vert" then
		UB.menuHolder:SetWidth(db.size + (E.PixelMode and 2 or 4))
		UB.menuHolder:SetHeight((db.size*NumBut)+((E.PixelMode and db.spacing or db.spacing+2)*(NumBut-1))+2)
	else
		UB.menuHolder:SetWidth((db.size*NumBut)+((E.PixelMode and db.spacing or db.spacing+2)*(NumBut-1))+2)
		UB.menuHolder:SetHeight(db.size + (E.PixelMode and 2 or 4))
	end
end

function UB:FrameSize()
	local db = E.db.sle.uibuttons
	if not db.size then return end
	UB:MoverSize()

	for i = 1, #UB.ToggleTable do
		UB.ToggleTable[i]:Size(db.size)
	end

	if E.private.sle.uiButtonStyle == "dropdown" then
		for i = 1, #UB.MetaTable do
			local group = UB.MetaTable[i]
			local mass = UB[group.."Table"]
			for n = 1, #mass do
				if mass[n].isSeparator then
					mass[n]:Size((db.size * 3.1) - 2, mass[n].size)
				else
					mass[n]:Size(db.size * 3.1, db.size)	
				end
			end
		end
	end
	
	UB:Positioning()
end

function UB:UpdateDropdownLayout(group, backdrop)
	local count = -1
	local sepS, sepC = 0, 0
	local header = UB.menuHolder[group]
	local db = E.db.sle.uibuttons
	header:ClearAllPoints()
	header:Point(db.point, header.Toggle, db.anchor, db.xoffset, db.yoffset)
	local T = UB[group.."Table"]
	for i = 1, #T do
		local button, prev, next = T[i], T[i-1], T[i+1]
		local y_offset = prev and ((E.PixelMode and -db.spacing or -(db.spacing+2))-(prev.isSeparator and prev.space or 0)-(button.isSeparator and button.space or 0)) or 0
		button:Point("TOP", (prev or header), (prev and "BOTTOM" or "TOP"), 0, y_offset)
		count = button.isSeparator and count or count + 1
		sepS = (button.isSeparator and sepS + ((prev and 2 or 1)*button.space + button.size)) or sepS
		sepC = button.isSeparator and sepC + 1 or sepC
	end
	header:Size(db.size * 3.1, (db.size * (count+1))+(db.spacing*(count))+sepS+(.5*sepC))
	if backdrop then
		header.backdrop:Show()
	else
		header.backdrop:Hide()
	end
end

function UB:Positioning()
	local db = E.db.sle.uibuttons

	--position check
	local header = UB.menuHolder
	if db.position == "uib_vert" then
		for i = 1, #UB.ToggleTable do
			local button, prev = UB.ToggleTable[i], UB.ToggleTable[i-1]
			UB.ToggleTable[i]:ClearAllPoints()
			UB.ToggleTable[i]:Point("TOP", (prev or header), prev and "BOTTOM" or "TOP", 0, prev and (E.PixelMode and -db.spacing or -(db.spacing+2)) or (E.PixelMode and -1 or -2))
		end
	else
		for i = 1, #UB.ToggleTable do
			local button, prev = UB.ToggleTable[i], UB.ToggleTable[i-1]
			UB.ToggleTable[i]:ClearAllPoints()
			UB.ToggleTable[i]:Point("LEFT", (prev or header), prev and "RIGHT" or "LEFT", prev and (E.PixelMode and db.spacing or db.spacing+2) or (E.PixelMode and 1 or 2), 0)
		end
	end
	if E.private.sle.uiButtonStyle == "dropdown" then
		for i = 1, #UB.MetaTable do
			UB:UpdateDropdownLayout(UB.MetaTable[i], E.db.sle.uibuttons.dropdownBackdrop)
		end
	end
end

function UB:Toggle()
	if not E.db.sle.uibuttons.enable then
		UB.menuHolder:Hide()
	else
		UB.menuHolder:Show()
		UB:UpdateMouseOverSetting()
	end
end

function UB:CreateMetaTable()
	if E.private.sle.uiButtonStyle ~= "dropdown" then return end
	UB.MetaTable = {
		"Config",
		"Addon",
		"Status",
		"Roll",
	}
end

function UB:InsertButtons()
	--This function is purely cosmetic and used only for hooking other button creating funct to it by any external addon
end

function UB:Initialize()
	UB:CreateFrame()
	
	UB:InsertButtons() --For external buttons
	
	UB:CreateMetaTable()
	
	UB:FrameSize()
	UB:Toggle()
	
	E.FrameLocks['SLEUIButtonHolder'] = true
	
	E:CreateMover(UB.menuHolder, "UIBFrameMover", L["UI Buttons"], nil, nil, nil, "ALL,S&L,S&L MISC")
	UB:MoverSize()
end