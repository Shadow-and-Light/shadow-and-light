local E, L, V, P, G = unpack(ElvUI); 
local UB = E:GetModule('SLE_UIButtons');
local ACD = LibStub("AceConfigDialog-3.0")
local SLE = E:GetModule("SLE")
local Sk = E:GetModule("Skins")

local BorderColor = E['media'].bordercolor
local NumBut = 4
local ToggleTable = {}
local ConfigTable = {}
local AddonTable = {}
local StatusTable = {}
local RollTable = {}

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
	
	UB.menuHolder.Config = CreateFrame("Frame", "SLEUIConfigHolder", UB.menuHolder)
	UB:CreateCoreButton("Config", "C")
	UB:ConfigSetup()
	
	UB.menuHolder.Addon = CreateFrame("Frame", "SLEUIAddonHolder", UB.menuHolder)
	UB:CreateCoreButton("Addon", "A")
	UB:AddonSetup()
	
	UB.menuHolder.Status = CreateFrame("Frame", "SLEUIStatusHolder", UB.menuHolder)
	UB:CreateCoreButton("Status", "S")
	UB:StatusSetup()
	
	UB.menuHolder.Roll = CreateFrame("Frame", "SLEUIRollHolder", UB.menuHolder)
	UB:CreateCoreButton("Roll", "R")
	UB:RollSetup()
	
	
	ToggleTable = {
		UB.menuHolder.Config.Toggle,
		UB.menuHolder.Addon.Toggle,
		UB.menuHolder.Status.Toggle,
		UB.menuHolder.Roll.Toggle,
	}
end

function UB:CreateCoreButton(name, text)
	UB.menuHolder[name].Toggle = CreateFrame("Button", "SLEUI"..name.."Toggle", UB.menuHolder)
	local button = UB.menuHolder[name].Toggle
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

function UB:CreateDropdownButton(parent, name, text, tooltip1, tooltip2, click, addon)
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
	elseif addon then
		if IsAddOnLoaded(addon) then
			b.shown = true
		else
			b.shown = false
		end
	end
	
	b:SetScript("OnClick", function(self)
		click()
		toggle.opened = false
		UB:ToggleCats()
	end)

	if tooltip1 then
		b:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(tooltip1, .6, .6, .6, .6, .6, 1)
			GameTooltip:AddLine(tooltip2, 1, 1, 1, 1, 1, 1)
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
	
	if text then
		local t = b:CreateFontString(nil,"OVERLAY",b)
		t:FontTemplate()
		t:SetPoint("CENTER", b, 'CENTER', 0, -1)
		t:SetJustifyH("CENTER")
		t:SetText(text)
		b:SetFontString(t)
	end
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

	UB:CreateDropdownButton("Config", "Elv", "ElvUI", L["ElvUI Config"], L["Click to toggle config window"],  E.ToggleConfig)
	UB:CreateDropdownButton("Config", "SLE", "S&L", L["S&L Config"], L["Click to toggle Shadow & Light config group"],  function() E:ToggleConfig(); ACD:SelectGroup("ElvUI", "sle", "options") end)
	UB:CreateDropdownButton("Config", "Benik", "BenikUI", L["BenikUI Config"], L["Click to toggle BenikUI config group"],  function() E:ToggleConfig(); ACD:SelectGroup("ElvUI", "bui") end)
	UB:CreateDropdownButton("Config", "Reload", "/reloadui", L["Reload UI"], L["Click to reload your interface"],  ReloadUI)
	UB:CreateDropdownButton("Config", "MoveUI", "/moveui", L["Move UI"], L["Click to unlock moving ElvUI elements"],  function() E:ToggleConfigMode() end)
	
	ConfigTable = {
		UB.menuHolder.Config.Elv,
		UB.menuHolder.Config.SLE,
		UB.menuHolder.Config.Benik,
		UB.menuHolder.Config.Reload,
		UB.menuHolder.Config.MoveUI,
	}
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
	

	UB:CreateDropdownButton("Addon", "Manager", L["AddOns"], L["AddOns Manager"], L["Click to toggle the AddOn Manager frame."],  function() GameMenuButtonAddons:Click() end)
	UB:CreateDropdownButton("Addon", "Boss", L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() UB.menuHolder.Addon.Boss.bossmode() end, true)
	UB:CreateDropdownButton("Addon", "Altoholic", "Altoholic", nil, nil, Altoholic.ToggleUI, "Altoholic")
	UB:CreateDropdownButton("Addon", "AtlasLoot", "AtlasLoot", nil, nil, function() AtlasLoot.GUI:Toggle() end, "AtlasLoot")
	UB:CreateDropdownButton("Addon", "WeakAuras", "WeakAuras", nil, nil, SlashCmdList.WEAKAURAS, "WeakAuras")
	UB:CreateDropdownButton("Addon", "Swatter", "Swatter", nil, nil, Swatter.ErrorShow, "!Swatter")
	
	tinsert(AddonTable, UB.menuHolder.Addon.Manager)
	tinsert(AddonTable, UB.menuHolder.Addon.Boss)
	tinsert(AddonTable, UB.menuHolder.Addon.Altoholic)
	tinsert(AddonTable, UB.menuHolder.Addon.AtlasLoot)
	tinsert(AddonTable, UB.menuHolder.Addon.WeakAuras)
	tinsert(AddonTable, UB.menuHolder.Addon.Swatter)
	
	--Always keep at the bottom--
	UB:CreateDropdownButton("Addon", "WowLua", "WowLua", nil, nil, function() SlashCmdList["WOWLUA"]("") end, "WowLua")
	UB:CreateDropdownButton("Addon", "Darth", "DarthUI", nil, nil, function() DarthUI[1]:ToggleConfig() end, "DarthUI")
	
	tinsert(AddonTable, UB.menuHolder.Addon.WowLua)
	tinsert(AddonTable, UB.menuHolder.Addon.Darth)
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

	UB:CreateDropdownButton("Status", "AFK", L["AFK"], nil, nil,  function() SendChatMessage("" ,"AFK" ) end)
	UB:CreateDropdownButton("Status", "DND", L["DND"], nil, nil,  function() SendChatMessage("" ,"DND" ) end)
	
	StatusTable = {
		UB.menuHolder.Status.AFK,
		UB.menuHolder.Status.DND
	}
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
	
	UB:CreateDropdownButton("Roll", "Ten", "1-10", nil, nil,  function() RandomRoll(1, 10) end)
	UB:CreateDropdownButton("Roll", "Twenty", "1-20", nil, nil,  function() RandomRoll(1, 20) end)
	UB:CreateDropdownButton("Roll", "Thirty", "1-30", nil, nil,  function() RandomRoll(1, 30) end)
	UB:CreateDropdownButton("Roll", "Forty", "1-40", nil, nil,  function() RandomRoll(1, 40) end)
	UB:CreateDropdownButton("Roll", "Hundred", "1-100", nil, nil,  function() RandomRoll(1, 100) end)
	UB:CreateDropdownButton("Roll", "Custom", L["Custom"], nil, nil,  CusomRollCall)
	
	RollTable = {
		UB.menuHolder.Roll.Ten,
		UB.menuHolder.Roll.Twenty,
		UB.menuHolder.Roll.Thirty,
		UB.menuHolder.Roll.Forty,
		UB.menuHolder.Roll.Hundred,
		UB.menuHolder.Roll.Custom,
	}
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

function UB:FrameSize(onLoad)
	local db = E.db.sle.uibuttons
	UB:MoverSize()

	for i = 1, #ToggleTable do
		ToggleTable[i]:Size(db.size)
	end
	UB.menuHolder.Config:Size(db.size * 2.6, (db.size * #ConfigTable)+(db.spacing*(#ConfigTable-1)))
	for i = 1, #ConfigTable do
		ConfigTable[i]:Size(db.size * 2.6, db.size)
	end
	for i = 1, #AddonTable do
		AddonTable[i]:Size(db.size * 3.1, db.size)
	end
	UB.menuHolder.Status:Size(db.size * 2.1, (db.size * #StatusTable)+(db.spacing*(#StatusTable-1)))
	for i = 1, #StatusTable do
		StatusTable[i]:Size(db.size * 2.1, db.size)
	end
	UB.menuHolder.Roll:Size(db.size * 2.1, (db.size * #RollTable)+(db.spacing*(#RollTable-1)))
	for i = 1, #RollTable do
		RollTable[i]:Size(db.size * 2.1, db.size)
	end

	UB:Positioning(onLoad)
end

function UB:UpdateConfigLayout(load)
	local db = E.db.sle.uibuttons
	local button = UB.menuHolder.Config.Toggle
	UB.menuHolder.Config:ClearAllPoints()
	UB.menuHolder.Config:Point(db.point, button, db.anchor, db.xoffset, db.yoffset)
	if load then
		UB.menuHolder.Config.Elv:Point("TOP", UB.menuHolder.Config, "TOP", 0, 0)
		UB.menuHolder.Config.SLE:Point("TOP", UB.menuHolder.Config.Elv, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
		if IsAddOnLoaded("ElvUI_BenikUI") then 
			UB.menuHolder.Config.Benik:Point("TOP", UB.menuHolder.Config.SLE, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
			UB.menuHolder.Config.Reload:Point("TOP", UB.menuHolder.Config.Benik, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
		else
			UB.menuHolder.Config.Reload:Point("TOP", UB.menuHolder.Config.SLE, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
		end
		UB.menuHolder.Config.MoveUI:Point("TOP", UB.menuHolder.Config.Reload, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
	end
end

function UB:UpdateAddonLayout(load)
	local count = 0
	local button = UB.menuHolder.Addon.Toggle
	local db = E.db.sle.uibuttons
	UB.menuHolder.Addon:ClearAllPoints()
	UB.menuHolder.Addon:Point(db.point, button, db.anchor, db.xoffset, db.yoffset)
	if load then
		UB.menuHolder.Addon.Manager:Point("TOP", UB.menuHolder.Addon, "TOP", 0, 0)
		for i = 2, #AddonTable do
			if AddonTable[i].shown then
				AddonTable[i]:Point("TOP", UB.menuHolder.Addon.Manager, "BOTTOM", 0, -(count * (db.size)) - (count + 1) * (E.PixelMode and db.spacing or (db.spacing+2))+(E.PixelMode and 0 or 1))
				AddonTable[i]:Show()
				count = count + 1
			else
				AddonTable[i]:Hide()
			end
		end
		UB.menuHolder.Addon:Size(db.size * 3.1, (db.size * (count+1))+(db.spacing*(count)))
	end
end

function UB:UpdateStatusLayout(load)
	local button = UB.menuHolder.Status.Toggle
	local db = E.db.sle.uibuttons
	UB.menuHolder.Status:ClearAllPoints()
	UB.menuHolder.Status:Point(db.point, button, db.anchor, db.xoffset, db.yoffset)
	if load then
		UB.menuHolder.Status.AFK:Point("TOP", UB.menuHolder.Status, "TOP", 0, 0)
		UB.menuHolder.Status.DND:Point("TOP", UB.menuHolder.Status.AFK, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
	end
end

function UB:UpdateRollLayout(load)
	local button = UB.menuHolder.Roll.Toggle
	local db = E.db.sle.uibuttons
	UB.menuHolder.Roll:ClearAllPoints()
	UB.menuHolder.Roll:Point(db.point, button, db.anchor, db.xoffset, db.yoffset)
	if load then
		UB.menuHolder.Roll.Ten:Point("TOP", UB.menuHolder.Roll, "TOP", 0, 0)
		UB.menuHolder.Roll.Twenty:Point("TOP", UB.menuHolder.Roll.Ten, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
		UB.menuHolder.Roll.Thirty:Point("TOP", UB.menuHolder.Roll.Twenty, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
		UB.menuHolder.Roll.Forty:Point("TOP", UB.menuHolder.Roll.Thirty, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
		UB.menuHolder.Roll.Hundred:Point("TOP", UB.menuHolder.Roll.Forty, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
		UB.menuHolder.Roll.Custom:Point("TOP", UB.menuHolder.Roll.Hundred, "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
	end
end

function UB:Positioning(load)
	local db = E.db.sle.uibuttons
	for i = 1, #ToggleTable do
		ToggleTable[i]:ClearAllPoints()
	end
	--position check
	if db.position == "uib_vert" then
		UB.menuHolder.Config.Toggle:Point("TOP", UB.menuHolder, "TOP", 0, (E.PixelMode and -1 or -2))
		for i = 2, #ToggleTable do
			ToggleTable[i]:Point("TOP", ToggleTable[i-1], "BOTTOM", 0, (E.PixelMode and -db.spacing or -(db.spacing+2)))
		end
	else
		UB.menuHolder.Config.Toggle:Point("LEFT", UB.menuHolder, "LEFT", (E.PixelMode and 1 or 2), 0)
		for i = 2, #ToggleTable do
			ToggleTable[i]:Point("LEFT", ToggleTable[i-1], "RIGHT", (E.PixelMode and db.spacing or db.spacing+2), 0)
		end
	end
	
	UB:UpdateConfigLayout(load)
	UB:UpdateAddonLayout(load)
	UB:UpdateStatusLayout(load)
	UB:UpdateRollLayout(load)
end


function UB:Toggle()
	if not E.db.sle.uibuttons.enable then
		UB.menuHolder:Hide()
	else
		UB.menuHolder:Show()
		UB:UpdateMouseOverSetting()
	end
end

function UB:Initialize()
	UB:CreateFrame()
	UB:FrameSize(true)
	UB:Toggle()
	
	E.FrameLocks['SLEUIButtonHolder'] = true
	
	E:CreateMover(UB.menuHolder, "UIBFrameMover", L["UI Buttons"], nil, nil, nil, "ALL,S&L,S&L MISC")
	UB:MoverSize()
end