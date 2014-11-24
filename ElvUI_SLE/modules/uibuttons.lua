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
	UB.menuHolder.Config.Toggle = CreateFrame("Button", "SLEUIConfigToggle", UB.menuHolder)
	UB.menuHolder.Config.Toggle.text = UB.menuHolder.Config.Toggle:CreateFontString(nil, "OVERLAY")
	UB.menuHolder.Config.Toggle.text:SetFont(E["media"].normFont, 10, "OUTLINE")
	UB.menuHolder.Config.Toggle.text:SetPoint("CENTER", UB.menuHolder.Config.Toggle, "CENTER", 0, 0)
	UB.menuHolder.Config.Toggle.text:SetText("C")
	UB.menuHolder.Config:HookScript('OnEnter', UB.OnEnter)
	UB.menuHolder.Config:HookScript('OnLeave', UB.OnLeave)
	UB:ConfigSetup()
	Sk:HandleButton(UB.menuHolder.Config.Toggle)
	
	UB.menuHolder.Addon = CreateFrame("Frame", "SLEUIAddonHolder", UB.menuHolder)
	UB.menuHolder.Addon.Toggle = CreateFrame("Button", "SLEUIAddonToggle", UB.menuHolder)
	UB.menuHolder.Addon.Toggle.text = UB.menuHolder.Addon.Toggle:CreateFontString(nil, "OVERLAY")
	UB.menuHolder.Addon.Toggle.text:SetFont(E["media"].normFont, 10, "OUTLINE")
	UB.menuHolder.Addon.Toggle.text:SetPoint("CENTER", UB.menuHolder.Addon.Toggle, "CENTER", 0, 0)
	UB.menuHolder.Addon.Toggle.text:SetText("A")
	UB.menuHolder.Addon:HookScript('OnEnter', UB.OnEnter)
	UB.menuHolder.Addon:HookScript('OnLeave', UB.OnLeave)
	UB:AddonSetup()
	Sk:HandleButton(UB.menuHolder.Addon.Toggle)
	
	UB.menuHolder.Status = CreateFrame("Frame", "SLEUIStatusHolder", UB.menuHolder)
	UB.menuHolder.Status.Toggle = CreateFrame("Button", "SLEUIStatusToggle", UB.menuHolder)
	UB.menuHolder.Status.Toggle.text = UB.menuHolder.Status.Toggle:CreateFontString(nil, "OVERLAY")
	UB.menuHolder.Status.Toggle.text:SetFont(E["media"].normFont, 10, "OUTLINE")
	UB.menuHolder.Status.Toggle.text:SetPoint("CENTER", UB.menuHolder.Status.Toggle, "CENTER", 0, 0)
	UB.menuHolder.Status.Toggle.text:SetText("S")
	UB.menuHolder.Status:HookScript('OnEnter', UB.OnEnter)
	UB.menuHolder.Status:HookScript('OnLeave', UB.OnLeave)
	UB:StatusSetup()
	Sk:HandleButton(UB.menuHolder.Status.Toggle)
	
	UB.menuHolder.Roll = CreateFrame("Frame", "SLEUIRollHolder", UB.menuHolder)
	UB.menuHolder.Roll.Toggle = CreateFrame("Button", "SLEUIRollToggle", UB.menuHolder)
	UB.menuHolder.Roll.Toggle.text = UB.menuHolder.Roll.Toggle:CreateFontString(nil, "OVERLAY")
	UB.menuHolder.Roll.Toggle.text:SetFont(E["media"].normFont, 10, "OUTLINE")
	UB.menuHolder.Roll.Toggle.text:SetPoint("CENTER", UB.menuHolder.Roll.Toggle, "CENTER", 0, 0)
	UB.menuHolder.Roll.Toggle.text:SetText("R")
	UB.menuHolder.Roll:HookScript('OnEnter', UB.OnEnter)
	UB.menuHolder.Roll:HookScript('OnLeave', UB.OnLeave)
	UB:RollSetup()
	Sk:HandleButton(UB.menuHolder.Roll.Toggle)
	
	ToggleTable = {
		UB.menuHolder.Config.Toggle,
		UB.menuHolder.Addon.Toggle,
		UB.menuHolder.Status.Toggle,
		UB.menuHolder.Roll.Toggle,
	}
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
	button:SetScript("OnClick", function(self)
		if self.opened then
			self.opened = false
		else
			self.opened = true
			UB.menuHolder.Addon.Toggle.opened = false
			UB.menuHolder.Status.Toggle.opened = false
			UB.menuHolder.Roll.Toggle.opened = false
		end
		UB:ToggleCats()
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)
	do
		UB.menuHolder.Config.Elv = CreateFrame("Button", "SLEUIConfigElv", UB.menuHolder.Config)
		UB.menuHolder.Config.Elv.text = UB.menuHolder.Config.Elv:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Config.Elv.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Config.Elv.text:SetPoint("CENTER", UB.menuHolder.Config.Elv, "CENTER")
		UB.menuHolder.Config.Elv.text:SetText("ElvUI")
		UB.menuHolder.Config.Elv:SetScript("OnClick", function(self)
			E:ToggleConfig()
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Config.Elv:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(L["ElvUI Config"], .6, .6, .6, .6, .6, 1)
			GameTooltip:AddLine(L["Click to toggle config window"], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		UB.menuHolder.Config.Elv:SetScript("OnLeave", function(self)
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
		Sk:HandleButton(UB.menuHolder.Config.Elv)
	end
	do
		UB.menuHolder.Config.SLE = CreateFrame("Button", "SLEUIConfigSLE", UB.menuHolder.Config)
		UB.menuHolder.Config.SLE.text = UB.menuHolder.Config.SLE:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Config.SLE.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Config.SLE.text:SetPoint("CENTER", UB.menuHolder.Config.SLE, "CENTER")
		UB.menuHolder.Config.SLE.text:SetText("S&L")
		UB.menuHolder.Config.SLE:SetScript("OnClick", function(self)
			E:ToggleConfig()
			ACD:SelectGroup("ElvUI", "sle", "options")
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Config.SLE:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(L["S&L Config"], .6, .6, .6, .6, .6, 1)
			GameTooltip:AddLine(L["Click to toggle Shadow & Light config group"], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		UB.menuHolder.Config.SLE:SetScript("OnLeave", function(self)
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
		Sk:HandleButton(UB.menuHolder.Config.SLE)
	end
	do
		UB.menuHolder.Config.Benik = CreateFrame("Button", "SLEUIConfigBenik", UB.menuHolder.Config)
		UB.menuHolder.Config.Benik.text = UB.menuHolder.Config.Benik:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Config.Benik.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Config.Benik.text:SetPoint("CENTER", UB.menuHolder.Config.Benik, "CENTER")
		UB.menuHolder.Config.Benik.text:SetText("BenikUI")
		UB.menuHolder.Config.Benik:SetScript("OnClick", function(self)
			E:ToggleConfig()
			ACD:SelectGroup("ElvUI", "bui")
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Config.Benik:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(L["BenikUI Config"], .6, .6, .6, .6, .6, 1)
			GameTooltip:AddLine(L["Click to toggle BenikUI config group"], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		UB.menuHolder.Config.Benik:SetScript("OnLeave", function(self)
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
		Sk:HandleButton(UB.menuHolder.Config.Benik)
	end
	do
		UB.menuHolder.Config.Reload = CreateFrame("Button", "SLEUIConfigReload", UB.menuHolder.Config)
		UB.menuHolder.Config.Reload.text = UB.menuHolder.Config.Reload:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Config.Reload.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Config.Reload.text:SetPoint("CENTER", UB.menuHolder.Config.Reload, "CENTER")
		UB.menuHolder.Config.Reload.text:SetText("/reload")
		UB.menuHolder.Config.Reload:SetScript("OnClick", function(self)
			ReloadUI()
		end)
		UB.menuHolder.Config.Reload:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(L["Reload UI"], .6, .6, .6, .6, .6, 1)
			GameTooltip:AddLine(L["Click to reload your interface"], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		UB.menuHolder.Config.Reload:SetScript("OnLeave", function(self)
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
		Sk:HandleButton(UB.menuHolder.Config.Reload)
	end
	do
		UB.menuHolder.Config.MoveUI = CreateFrame("Button", "SLEUIConfigMoveUI", UB.menuHolder.Config)
		UB.menuHolder.Config.MoveUI.text = UB.menuHolder.Config.MoveUI:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Config.MoveUI.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Config.MoveUI.text:SetPoint("CENTER", UB.menuHolder.Config.MoveUI, "CENTER")
		UB.menuHolder.Config.MoveUI.text:SetText("/moveui") 
		UB.menuHolder.Config.MoveUI:SetScript("OnClick", function(self)
			E:ToggleConfigMode()
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Config.MoveUI:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(L["Move UI"], .6, .6, .6, .6, .6, 1)
			GameTooltip:AddLine(L["Click to unlock moving ElvUI elements"], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		UB.menuHolder.Config.MoveUI:SetScript("OnLeave", function(self)
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
		Sk:HandleButton(UB.menuHolder.Config.MoveUI)
	end
	
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
	button:SetScript("OnClick", function(self)
		if self.opened then
			self.opened = false
		else
			self.opened = true
			UB.menuHolder.Config.Toggle.opened = false
			UB.menuHolder.Status.Toggle.opened = false
			UB.menuHolder.Roll.Toggle.opened = false
		end
		UB:ToggleCats()
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)
	
	do
		UB.menuHolder.Addon.Manager = CreateFrame("Button", "SLEUIAddonManager", UB.menuHolder.Addon)
		UB.menuHolder.Addon.Manager.text = UB.menuHolder.Addon.Manager:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Addon.Manager.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Addon.Manager.text:SetPoint("CENTER", UB.menuHolder.Addon.Manager, "CENTER")
		UB.menuHolder.Addon.Manager.text:SetText(L["Addons"])
		UB.menuHolder.Addon.Manager:SetScript("OnClick", function(self)
			GameMenuButtonAddons:Click()
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Addon.Manager:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 30,0)
			GameTooltip:AddLine(L["AddOns Manager"], .6, .6, .6, .6, .6, 1)
			GameTooltip:AddLine(L["Click to toggle the AddOn Manager frame."], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		UB.menuHolder.Addon.Manager:SetScript("OnLeave", function(self)
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
		UB.menuHolder.Addon.Manager.shown = true
		Sk:HandleButton(UB.menuHolder.Addon.Manager)
		tinsert(AddonTable, UB.menuHolder.Addon.Manager)
	end
	do
		UB.menuHolder.Addon.Boss = CreateFrame("Button", "SLEUIAddonBoss", UB.menuHolder.Addon)
		UB.menuHolder.Addon.Boss.text = UB.menuHolder.Addon.Boss:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Addon.Boss.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Addon.Boss.text:SetPoint("CENTER", UB.menuHolder.Addon.Boss, "CENTER")
		UB.menuHolder.Addon.Boss.text:SetText(L["Boss Mod"])
		UB.menuHolder.Addon.Boss:SetScript("OnClick", function(self)
			UB.menuHolder.Addon.bossmode()
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Addon.Boss:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 30,0)
			GameTooltip:AddLine(L["Boss Mod"], .6, .6, .6, .6, .6, 1)
			GameTooltip:AddLine(L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		UB.menuHolder.Addon.Boss:SetScript("OnLeave", function(self) 
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
		UB.menuHolder.Addon.Boss.shown = true
		UB.menuHolder.Addon.bossmode = function() end
		if IsAddOnLoaded("DBM-Core") then
			UB.menuHolder.Addon.bossmode = function() DBM:LoadGUI() end
		-- elseif IsAddOnLoaded("Bigwigs") then
			-- UB.menuHolder.Addon.bossmode = function() end
		elseif IsAddOnLoaded("VEM-Core") then
			UB.menuHolder.Addon.bossmode = function() VEM:LoadGUI() end
		-- elseif IsAddOnLoaded("DXE_Loader") then
			-- UB.menuHolder.Addon.bossmode = function() end
		-- elseif IsAddOnLoaded("") then
			-- UB.menuHolder.Addon.bossmode = function() end
		else
			UB.menuHolder.Addon.Boss.shown = false
		end
		Sk:HandleButton(UB.menuHolder.Addon.Boss)
		tinsert(AddonTable, UB.menuHolder.Addon.Boss)
	end
	do
		UB.menuHolder.Addon.Altoholic = CreateFrame("Button", "SLEUIAddonAltoholic", UB.menuHolder.Addon)
		UB.menuHolder.Addon.Altoholic.text = UB.menuHolder.Addon.Altoholic:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Addon.Altoholic.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Addon.Altoholic.text:SetInside(UB.menuHolder.Addon.Altoholic)
		UB.menuHolder.Addon.Altoholic.text:SetText("Altoholic")
		UB.menuHolder.Addon.Altoholic.text:SetJustifyH("CENTER") 
		UB.menuHolder.Addon.Altoholic:SetScript("OnClick", function(self)
			Altoholic:ToggleUI()
			button.opened = false
			UB:ToggleCats()
		end)
		if IsAddOnLoaded("Altoholic") then
			UB.menuHolder.Addon.Altoholic.shown = true
		else
			UB.menuHolder.Addon.Altoholic.shown = false
		end
		UB.menuHolder.Addon.Altoholic:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Addon.Altoholic:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Addon.Altoholic)
		tinsert(AddonTable, UB.menuHolder.Addon.Altoholic)
	end
	do
		UB.menuHolder.Addon.AtlasLoot = CreateFrame("Button", "SLEUIAddonAtlasLoot", UB.menuHolder.Addon)
		UB.menuHolder.Addon.AtlasLoot.text = UB.menuHolder.Addon.AtlasLoot:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Addon.AtlasLoot.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Addon.AtlasLoot.text:SetPoint("CENTER", UB.menuHolder.Addon.AtlasLoot, "CENTER")
		UB.menuHolder.Addon.AtlasLoot.text:SetText("AtlasLoot")
		UB.menuHolder.Addon.AtlasLoot:SetScript("OnClick", function(self)
			AtlasLoot:SlashCommand("/al")
			button.opened = false
			UB:ToggleCats()
		end)
		if IsAddOnLoaded("AtlasLoot_Loader") then
			UB.menuHolder.Addon.AtlasLoot.shown = true
		else
			UB.menuHolder.Addon.AtlasLoot.shown = false
		end
		UB.menuHolder.Addon.AtlasLoot:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Addon.AtlasLoot:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Addon.AtlasLoot)
		tinsert(AddonTable, UB.menuHolder.Addon.AtlasLoot)
	end
	
	do
		UB.menuHolder.Addon.WeakAuras = CreateFrame("Button", "SLEUIAddonWeakAuras", UB.menuHolder.Addon)
		UB.menuHolder.Addon.WeakAuras.text = UB.menuHolder.Addon.WeakAuras:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Addon.WeakAuras.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Addon.WeakAuras.text:SetPoint("CENTER", UB.menuHolder.Addon.WeakAuras, "CENTER")
		UB.menuHolder.Addon.WeakAuras.text:SetText("WeakAuras")
		UB.menuHolder.Addon.WeakAuras:SetScript("OnClick", function(self)
			SlashCmdList.WEAKAURAS()
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Addon.WeakAuras:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Addon.WeakAuras:HookScript('OnLeave', UB.OnLeave)
		if IsAddOnLoaded("WeakAuras") then
			UB.menuHolder.Addon.WeakAuras.shown = true
		else
			UB.menuHolder.Addon.WeakAuras.shown = false
		end
		Sk:HandleButton(UB.menuHolder.Addon.WeakAuras)
		tinsert(AddonTable, UB.menuHolder.Addon.WeakAuras)
	end
	
	do
		UB.menuHolder.Addon.Swatter = CreateFrame("Button", "SLEUIAddonSwatter", UB.menuHolder.Addon)
		UB.menuHolder.Addon.Swatter.text = UB.menuHolder.Addon.Swatter:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Addon.Swatter.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Addon.Swatter.text:SetPoint("CENTER", UB.menuHolder.Addon.Swatter, "CENTER")
		UB.menuHolder.Addon.Swatter.text:SetText("Swatter")
		UB.menuHolder.Addon.Swatter:SetScript("OnClick", function(self)
			Swatter.ErrorShow()
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Addon.Swatter:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Addon.Swatter:HookScript('OnLeave', UB.OnLeave)
		if IsAddOnLoaded("!Swatter") then
			UB.menuHolder.Addon.Swatter.shown = true
		else
			UB.menuHolder.Addon.Swatter.shown = false
		end
		Sk:HandleButton(UB.menuHolder.Addon.Swatter)
		tinsert(AddonTable, UB.menuHolder.Addon.Swatter)
	end
	
	--Always keep at the bottom--
	do
		UB.menuHolder.Addon.WowLua = CreateFrame("Button", "SLEUIAddonWowLua", UB.menuHolder.Addon)
		UB.menuHolder.Addon.WowLua.text = UB.menuHolder.Addon.WowLua:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Addon.WowLua.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Addon.WowLua.text:SetPoint("CENTER", UB.menuHolder.Addon.WowLua, "CENTER")
		UB.menuHolder.Addon.WowLua.text:SetText("WowLua")
		UB.menuHolder.Addon.WowLua:SetScript("OnClick", function(self)
			SlashCmdList["WOWLUA"]("")
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Addon.WowLua:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Addon.WowLua:HookScript('OnLeave', UB.OnLeave)
		if IsAddOnLoaded("WowLua") then
			UB.menuHolder.Addon.WowLua.shown = true
		else
			UB.menuHolder.Addon.WowLua.shown = false
		end
		Sk:HandleButton(UB.menuHolder.Addon.WowLua)
		tinsert(AddonTable, UB.menuHolder.Addon.WowLua)
	end
	do
		UB.menuHolder.Addon.Darth = CreateFrame("Button", "SLEUIAddonDarth", UB.menuHolder.Addon)
		UB.menuHolder.Addon.Darth.text = UB.menuHolder.Addon.Darth:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Addon.Darth.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Addon.Darth.text:SetPoint("CENTER", UB.menuHolder.Addon.Darth, "CENTER")
		UB.menuHolder.Addon.Darth.text:SetText("DarthUI")
		UB.menuHolder.Addon.Darth:SetScript("OnClick", function(self)
			DarthUI[1]:ToggleConfig()
			button.opened = false
			UB:ToggleCats()
		end)
		if IsAddOnLoaded("DarthUI") then
			UB.menuHolder.Addon.Darth.shown = true
		else
			UB.menuHolder.Addon.Darth.shown = false
		end
		Sk:HandleButton(UB.menuHolder.Addon.Darth)
		tinsert(AddonTable, UB.menuHolder.Addon.Darth)
	end
end

function UB:StatusSetup()
	local button = UB.menuHolder.Status.Toggle
	local db = E.db.sle.uibuttons
	button.opened = false
	UB.menuHolder.Status:Point("TOP", button, "BOTTOM", 0, -4)
	UB.menuHolder.Status:Hide()
	button:SetScript("OnClick", function(self)
		if self.opened then
			self.opened = false
		else
			self.opened = true
			UB.menuHolder.Config.Toggle.opened = false
			UB.menuHolder.Addon.Toggle.opened = false
			UB.menuHolder.Roll.Toggle.opened = false
		end
		UB:ToggleCats()
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)
	
	do
		UB.menuHolder.Status.AFK = CreateFrame("Button", "SLEUIStatusAFK", UB.menuHolder.Status)
		UB.menuHolder.Status.AFK.text = UB.menuHolder.Status.AFK:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Status.AFK.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Status.AFK.text:SetPoint("CENTER", UB.menuHolder.Status.AFK, "CENTER")
		UB.menuHolder.Status.AFK.text:SetText(L["AFK"])
		UB.menuHolder.Status.AFK:SetScript("OnClick", function(self)
			SendChatMessage("" ,"AFK" )
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Status.AFK:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Status.AFK:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Status.AFK)
	end
	
	do
		UB.menuHolder.Status.DND = CreateFrame("Button", "SLEUIStatusDND", UB.menuHolder.Status)
		UB.menuHolder.Status.DND.text = UB.menuHolder.Status.DND:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Status.DND.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Status.DND.text:SetPoint("CENTER", UB.menuHolder.Status.DND, "CENTER")
		UB.menuHolder.Status.DND.text:SetText(L["DND"])
		UB.menuHolder.Status.DND:SetScript("OnClick", function(self)
			SendChatMessage("" ,"DND" )
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Status.DND:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Status.DND:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Status.DND)
	end
	
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
	button:SetScript("OnClick", function(self)
		if self.opened then
			self.opened = false
		else
			self.opened = true
			UB.menuHolder.Config.Toggle.opened = false
			UB.menuHolder.Addon.Toggle.opened = false
			UB.menuHolder.Status.Toggle.opened = false
		end
		UB:ToggleCats()
	end)
	button:HookScript('OnEnter', UB.OnEnter)
	button:HookScript('OnLeave', UB.OnLeave)
	
	do
		UB.menuHolder.Roll.Ten = CreateFrame("Button", "SLEUIRollTen", UB.menuHolder.Roll)
		UB.menuHolder.Roll.Ten.text = UB.menuHolder.Roll.Ten:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Roll.Ten.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Roll.Ten.text:SetPoint("CENTER", UB.menuHolder.Roll.Ten, "CENTER")
		UB.menuHolder.Roll.Ten.text:SetText("1-10")
		UB.menuHolder.Roll.Ten:SetScript("OnClick", function(self)
			RandomRoll(1, 10)
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Roll.Ten:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Roll.Ten:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Roll.Ten)
	end
	do
		UB.menuHolder.Roll.Twenty = CreateFrame("Button", "SLEUIRollTwenty", UB.menuHolder.Roll)
		UB.menuHolder.Roll.Twenty.text = UB.menuHolder.Roll.Twenty:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Roll.Twenty.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Roll.Twenty.text:SetPoint("CENTER", UB.menuHolder.Roll.Twenty, "CENTER")
		UB.menuHolder.Roll.Twenty.text:SetText("1-20")
		UB.menuHolder.Roll.Twenty:SetScript("OnClick", function(self)
			RandomRoll(1, 20)
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Roll.Twenty:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Roll.Twenty:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Roll.Twenty)
	end
	do
		UB.menuHolder.Roll.Thirty = CreateFrame("Button", "SLEUIRollThirty", UB.menuHolder.Roll)
		UB.menuHolder.Roll.Thirty.text = UB.menuHolder.Roll.Thirty:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Roll.Thirty.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Roll.Thirty.text:SetPoint("CENTER", UB.menuHolder.Roll.Thirty, "CENTER")
		UB.menuHolder.Roll.Thirty.text:SetText("1-30")
		UB.menuHolder.Roll.Thirty:SetScript("OnClick", function(self)
			RandomRoll(1, 30)
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Roll.Thirty:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Roll.Thirty:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Roll.Thirty)
	end
	do
		UB.menuHolder.Roll.Forty = CreateFrame("Button", "SLEUIRollForty", UB.menuHolder.Roll)
		UB.menuHolder.Roll.Forty.text = UB.menuHolder.Roll.Forty:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Roll.Forty.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Roll.Forty.text:SetPoint("CENTER", UB.menuHolder.Roll.Forty, "CENTER")
		UB.menuHolder.Roll.Forty.text:SetText("1-40")
		UB.menuHolder.Roll.Forty:SetScript("OnClick", function(self)
			RandomRoll(1, 40)
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Roll.Forty:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Roll.Forty:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Roll.Forty)
	end
	do
		UB.menuHolder.Roll.Hundred = CreateFrame("Button", "SLEUIRollHundred", UB.menuHolder.Roll)
		UB.menuHolder.Roll.Hundred.text = UB.menuHolder.Roll.Hundred:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Roll.Hundred.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Roll.Hundred.text:SetPoint("CENTER", UB.menuHolder.Roll.Hundred, "CENTER")
		UB.menuHolder.Roll.Hundred.text:SetText("1-100")
		UB.menuHolder.Roll.Hundred:SetScript("OnClick", function(self)
			RandomRoll(1, 100)
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Roll.Hundred:HookScript('OnEnter', UB.OnEnter)
		UB.menuHolder.Roll.Hundred:HookScript('OnLeave', UB.OnLeave)
		Sk:HandleButton(UB.menuHolder.Roll.Hundred)
	end
	do
		UB.menuHolder.Roll.Custom = CreateFrame("Button", "SLEUIRollCustom", UB.menuHolder.Roll)
		UB.menuHolder.Roll.Custom.text = UB.menuHolder.Roll.Custom:CreateFontString(nil, "OVERLAY")
		UB.menuHolder.Roll.Custom.text:SetFont(E["media"].normFont, 10, "OUTLINE")
		UB.menuHolder.Roll.Custom.text:SetPoint("CENTER", UB.menuHolder.Roll.Custom, "CENTER")
		UB.menuHolder.Roll.Custom.text:SetText(L["Custom"])
		UB.menuHolder.Roll.Custom:SetScript("OnClick", function(self)
			local min, max = tonumber(E.db.sle.uibuttons.roll.min), tonumber(E.db.sle.uibuttons.roll.max)
			if min <= max then
				RandomRoll(min, max)
			else
				SLE:Print(L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."])
			end
			button.opened = false
			UB:ToggleCats()
		end)
		UB.menuHolder.Roll.Custom:SetScript("OnEnter", function(self)
			UB:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(L["Do a roll with custom limits. Those limits can be set in S&L config."], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		end)
		UB.menuHolder.Roll.Custom:SetScript("OnLeave", function(self) 
			UB:OnLeave()
			GameTooltip:Hide() 
		end)
		Sk:HandleButton(UB.menuHolder.Roll.Custom)
	end
	
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
	UB.menuHolder.Config:Size(db.size * 2.5, (db.size * #ConfigTable)+(db.spacing*(#ConfigTable-1)))
	for i = 1, #ConfigTable do
		ConfigTable[i]:Size(db.size * 2.5, db.size)
	end
	for i = 1, #AddonTable do
		AddonTable[i]:Size(db.size * 3, db.size)
	end
	UB.menuHolder.Status:Size(db.size * 2, (db.size * #StatusTable)+(db.spacing*(#StatusTable-1)))
	for i = 1, #StatusTable do
		StatusTable[i]:Size(db.size * 2, db.size)
	end
	UB.menuHolder.Roll:Size(db.size * 2, (db.size * #RollTable)+(db.spacing*(#RollTable-1)))
	for i = 1, #RollTable do
		RollTable[i]:Size(db.size * 2, db.size)
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
		UB.menuHolder.Addon:Size(db.size * 3, (db.size * (count+1))+(db.spacing*(count)))
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
	
	E.FrameLocks['UB.menuHolder'] = true
	
	E:CreateMover(UB.menuHolder, "UIBFrameMover", L["UI Buttons"], nil, nil, nil, "ALL,S&L,S&L MISC")
	UB:MoverSize()
end