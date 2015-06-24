local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local EP = LibStub("LibElvUIPlugin-1.0")
local UF = E:GetModule('UnitFrames')
local Sk = E:GetModule("Skins")
local addon = ...

--localizing functions--
local tinsert = tinsert

local elvV = tonumber(E.version)
local elvR = tonumber(GetAddOnMetadata("ElvUI_SLE", "X-ElvVersion"))

--SLE['media'] = {}

function SLE:MismatchText()
	local text = format(L['MSG_OUTDATED'],elvV,elvR)
	return text
end

local function AddTutorials() --Additional tutorials
	tinsert(E.TutorialList, #(E.TutorialList)+1, L["To enable full values of health/power on unitframes in Shadow & Light add \":sl\" to the end of the health/power tag.\nExample: [health:current:sl]."]);
end

local function ConfigCats() --Additional mover groups
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L");
	E.ConfigModeLocalizedStrings["S&L"] = L["S&L: All"]
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L DT");
	E.ConfigModeLocalizedStrings["S&L DT"] = L["S&L: Datatexts"]
	if E.private.sle.backgrounds then
		tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L BG");
		E.ConfigModeLocalizedStrings["S&L BG"] = L["S&L: Backgrounds"]
	end
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "S&L MISC");
	E.ConfigModeLocalizedStrings["S&L MISC"] = L["S&L: Misc"]
end

local function GetOptions()
	for _, func in pairs(E.SLEConfigs) do
		func()
	end
end

local function IncompatibleAddOn(addon, module, optiontable, value)
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].button1 = addon
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].button2 = 'S&L: '..module
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].addon = addon
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].module = module
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].optiontable = optiontable
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].value = value
	E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].showAlert = true
	E:StaticPopup_Show('SLE_INCOMPATIBLE_ADDON', addon, module)
end

local function CheckIncompatible()
	if IsAddOnLoaded('ElvUI_Enhanced') and not E.global.ignoreEnhancedIncompatible then
		E:StaticPopup_Show('ENHANCED_SLE_INCOMPATIBLE')
	end
	if IsAddOnLoaded('SquareMinimapButtons') and E.private.sle.minimap.mapicons.enable then
		IncompatibleAddOn('SquareMinimapButtons', 'SquareMinimapButtons', E.private.sle.minimap.mapicons, "enable")
	end
	if IsAddOnLoaded('LootConfirm') then
		E:StaticPopup_Show('LOOTCONFIRM_SLE_INCOMPATIBLE')
	end
	-- if IsAddOnLoaded('oRA3') then
		-- E:StaticPopup_Show('ORA_SLE_INCOMPATIBLE')
	-- end
end

function SLE:CreateExport()
	local frame = CreateFrame("Frame", "SLEExImFrame", E.UIParent)
	tinsert(UISpecialFrames, "SLEExImFrame")
	frame:SetTemplate('Transparent')
	frame:Size(800, 400)
	frame:Point('CENTER', E.UIParent)
	frame:Hide()
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self) 
		if IsShiftKeyDown() then 
			self:StartMoving()
		end 
	end)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetFont(E["media"].normFont, 14)
	text:SetPoint("TOP", frame, "TOP", -10, -10)
	text:SetText("<  "..L["Export / Import"].."  >")
	text:SetJustifyH("left")
		
	local ExScrollArea = CreateFrame("ScrollFrame", "SLEExportScrollFrame", frame, "UIPanelScrollFrameTemplate")
	ExScrollArea:Point("TOPLEFT", frame, "TOPLEFT", 10, -30)
	ExScrollArea:Point("BOTTOMRIGHT", frame, "BOTTOM", -25, 10)
	ExScrollArea:CreateBackdrop()
	Sk:HandleScrollBar(SLEExportScrollFrameScrollBar)
	
	local ImScrollArea = CreateFrame("ScrollFrame", "SLEImportScrollFrame", frame, "UIPanelScrollFrameTemplate")
	ImScrollArea:Point("TOPRIGHT", frame, "TOPRIGHT", -30, -30)
	ImScrollArea:Point("BOTTOMLEFT", frame, "BOTTOM", 5, 10)
	ImScrollArea:CreateBackdrop()
	Sk:HandleScrollBar(SLEImportScrollFrameScrollBar)

	local ExEditBox = CreateFrame("EditBox", "SLEExportEditBox", frame)
	ExEditBox:SetMultiLine(true)
	ExEditBox:SetMaxLetters(0)
	ExEditBox:EnableMouse(true)
	ExEditBox:SetAutoFocus(false)
	ExEditBox:SetFontObject(ChatFontNormal)
	ExEditBox:Width(ExScrollArea:GetWidth())
	ExEditBox:SetScript("OnEscapePressed", function() SLEExImFrame:Hide() end)
	ExScrollArea:SetScrollChild(ExEditBox)
	SLEExportEditBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput then return end
		local _, max = SLEExportScrollFrameScrollBar:GetMinMaxValues()
		for i=1, max do
			ScrollFrameTemplate_OnMouseWheel(SLEExportScrollFrame, -1)
		end
	end)
	
	local ImEditBox = CreateFrame("EditBox", "SLEImportEditBox", frame)
	ImEditBox:SetMultiLine(true)
	ImEditBox:SetMaxLetters(0)
	ImEditBox:EnableMouse(true)
	ImEditBox:SetAutoFocus(false)
	ImEditBox:SetFontObject(ChatFontNormal)
	ImEditBox:Width(ExScrollArea:GetWidth())
	ImEditBox:SetScript("OnEscapePressed", function() SLEExImFrame:Hide() end)
	ImScrollArea:SetScrollChild(ImEditBox)
	SLEImportEditBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput then return end
		local _, max = SLEImportScrollFrameScrollBar:GetMinMaxValues()
		for i=1, max do
			ScrollFrameTemplate_OnMouseWheel(SLEImportScrollFrame, -1)
		end
	end)
	

	local close = CreateFrame("Button", "SLEExImFrameCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT")
	close:SetFrameLevel(close:GetFrameLevel() + 1)
	close:EnableMouse(true)
	Sk:HandleCloseButton(close)	
	
	local exHelp = CreateFrame("Button", "SLEExportHelp", frame)
	exHelp:Size(20, 20)
	exHelp:Point("TOPLEFT", frame, "TOPLEFT", 9, -6)
	local exHelp_t = exHelp:CreateFontString(nil, "OVERLAY")
	exHelp_t:SetFont(E["media"].normFont, 14)
	exHelp_t:SetPoint("CENTER", exHelp)
	exHelp_t:SetText("?")
	Sk:HandleButton(exHelp)
	exHelp:HookScript("OnEnter", function(self) 
		GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 2, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine([[|cffFFFFFFExporting:
Click the Export button and the settings that are different from defaults in selected options tables' will be dumped to the export box.
 - Profile will copy profile based settings;
 - Private will copy character specific settings;
 - Global will copy global settings.|r
|cffFF0000Warning: exporting may cause your game to freeze for some time.|r

|cffFFFFFFImporting:
To import the settings you need to paste the setting table
or line to the import editbox and click import button.
You can use next formats for settings:
1) E.db.chat.panelHeight = 185
2) E.db['chat']['panelHeight'] = 185
3) E.db['chat'] = {
...
}
In case of the third format you should put at least 2 values.|r

|cffFF0000Know issue: coloring options will be exported anyway no matter the values and exporting options set.|r]])
		GameTooltip:Show()
	end)
	exHelp:HookScript("OnLeave", function() GameTooltip:Hide() end)
	exHelp:SetScript("OnClick", function(self) 
		SLEExportEditBox:SetText(dropdown.selectedID)
	end)
	
	local exButton = CreateFrame("Button", "SLEExportButton", frame)
	exButton:Size(100, 20)
	exButton:Point("LEFT", exHelp, "RIGHT", 4, 0)
	local exButton_t = exButton:CreateFontString(nil, "OVERLAY")
	exButton_t:SetFont(E["media"].normFont, 14)
	exButton_t:SetPoint("CENTER", exButton)
	exButton_t:SetText(L["Export"])
	Sk:HandleButton(exButton)
	exButton:SetScript("OnClick", SLE.Exporting)
	
	local imButton = CreateFrame("Button", "SLEImportButton", frame)
	imButton:Size(100, 20)
	imButton:Point("LEFT", exButton, "RIGHT", 4, 0)
	local imButton_t = imButton:CreateFontString(nil, "OVERLAY")
	imButton_t:SetFont(E["media"].normFont, 14)
	imButton_t:SetPoint("CENTER", imButton)
	imButton_t:SetText(L["Import"])
	Sk:HandleButton(imButton)
	imButton:SetScript("OnClick", function(self)
 		local msg = ImEditBox:GetText()
		msg = SLE:ImportTableReplace(msg)
		if msg then
			local func, err = loadstring(msg)
			if not err then
				func()
				E:UpdateAll(true)
				ReloadUI()
			else
				SLE:Print(err)
			end
		else
			SLE:Print("Entered text is not a valid settings table!")
		end
	end)
	
	
	
	local returnB = CreateFrame("Button", "SLEReturnButton", frame)
	returnB:Size(100, 20)
	returnB:Point("RIGHT", close, "LEFT", 4, 0)
	local returnB_t = returnB:CreateFontString(nil, "OVERLAY")
	returnB_t:SetFont(E["media"].normFont, 14)
	returnB_t:SetPoint("CENTER", returnB)
	returnB_t:SetText(L["Back"])
	Sk:HandleButton(returnB)
	returnB:SetScript("OnClick", function(self)
 		E:ToggleConfig()
		SLEExImFrame:Hide()
	end)
end

function SLE:FixDatabase() --For when we dramatically change some options
	if E.db.sle.chat.combathide == true then E.db.sle.chat.combathide = "BOTH" end
	if E.db.sle.chat.combathide == false then E.db.sle.chat.combathide = "NONE" end
	if E.db.sle.uibuttons.position == "uib_vert" then E.db.sle.uibuttons.orientation = "vertical" end
	if E.db.sle.uibuttons.position == "uib_hor" then E.db.sle.uibuttons.orientation = "horizontal" end
end

function SLE:Initialize()
	SLE:FixDatabase()
	--ElvUI's version check
	if elvV < elvR then
		E:StaticPopup_Show("VERSION_MISMATCH")
	end
	EP:RegisterPlugin(addon, GetOptions)
	if E.private.unitframe.enable then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", UF.Update_CombatIndicator);
	end
	if E.private.install_complete and E.private.sle.install_complete == nil then SLE:Install() end
	if E.db.general.loginmessage then
		SLE:Print(format(L['SLE_LOGIN_MSG'], E["media"].hexvaluecolor, SLE.version))
	end
	E:GetModule('SLE_DTPanels'):DashboardShow()
	AddTutorials()
	ConfigCats()
	CheckIncompatible()
end