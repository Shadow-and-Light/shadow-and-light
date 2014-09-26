local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local BG = E:GetModule('SLE_BackGrounds')
local DTP = E:GetModule('SLE_DTPanels')
local CH = E:GetModule("Chat")
local UB = E:GetModule('SLE_UIButtons')
local RM = E:GetModule('SLE_RaidMarks')
local RF = E:GetModule('SLE_RaidFlares')
local F = E:GetModule('SLE_Farm')
local LT = E:GetModule('SLE_Loot')
local UF = E:GetModule('UnitFrames')
local M = E:GetModule('SLE_Media')
local I = E:GetModule('SLE_InstDif')
local S = E:GetModule("SLE_ScreenSaver")
local Sk = E:GetModule("Skins")

local GetContainerNumSlots, GetContainerItemID = GetContainerNumSlots, GetContainerItemID

function SLE:BagSearch(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

function SLE:ValueTable(table, item)
	for i, _ in pairs(table) do
		if i == item then return true end
	end

	return false
end

function SLE:SimpleTable(table, item)
	for i = 1, #table do
		if table[i] == item then  
			return true 
		end
	end

	return false
end

function SLE:Print(msg)
	print(E["media"].hexvaluecolor..'S&L:|r', msg)
end

function SLE:Scale(f)
		return f*GetCVar('uiScale')
end

local function UpdateAll()
	BG:UpdateFrames()
	BG:RegisterHide()
	DTP:Update()
	DTP:DashboardShow()
	DTP:DashWidth()
	if E.private.unitframe.enable then
		UF:Update_CombatIndicator()
	end
	LT:LootShow()
	LT:Update()
	UB:UpdateAll()
	RM:Update()
	RF:Update()
	F:UpdateLayout()
	CH:GMIconUpdate()
	M:TextWidth()
	I:UpdateFrame()
	S:Reg(true)

	collectgarbage('collect');
end

function SLE:OpenExport()
	if not SLEExImFrame then SLE:CreateExport() end
	if not SLEExImFrame:IsShown() then 
		SLEExImFrame:Show() 
	end
end

function SLE:DisplayToTableString(tab, set)
    local ret = "";
    local function recurse(table, level)
        for i,v in pairs(table) do
			ret = ret..strrep("    ", level)..(level == 0 and set or "").."[";
            if(type(i) == "string") then
                ret = ret.."\""..i.."\"";
            else
                ret = ret..i;
            end
            ret = ret.."] = ";
            
            if(type(v) == "number") then
                ret = ret..v..(level == 0 and "" or ",").."\n"
            elseif(type(v) == "string") then
                ret = ret.."\""..v:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\"", "\\\"")..(level == 0 and "\"\n" or "\",\n")
            elseif(type(v) == "boolean") then
                if(v) then
                    ret = ret.."true"..(level == 0 and "" or ",").."\n"
                else
                    ret = ret.."false"..(level == 0 and "" or ",").."\n"
                end
            elseif(type(v) == "table") then
                ret = ret.."{\n"
                recurse(v, level + 1);
					ret = ret..strrep("    ", level).."}"..(level == 0 and "" or ",").."\n"
            else
                ret = ret.."\""..tostring(v).."\",\n"
            end
        end
    end
    
    if(tab) then
        recurse(tab, 0);
    end
    return ret;
end

function SLE:ImportTableReplace(msg)
	if string.find(msg, "E.db") then
		msg = gsub(msg, "E.db", "ElvUI[1].db")
	elseif string.find(msg, "E.private") then
		msg = gsub(msg, "E.private", "ElvUI[1].private")
	else
		return nil
	end
	
	return msg
end

function SLE:CreateExport()
	local frame = CreateFrame("Frame", "SLEExImFrame", E.UIParent)
	tinsert(UISpecialFrames, "SLEExImFrame")
	frame:SetTemplate('Transparent')
	frame:Size(800, 400)
	frame:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 20)
	frame:Hide()
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")

	local text = frame:CreateFontString(nil, "OVERLAY")
	text:SetFont(E["media"].normFont, 14)
	text:SetPoint("TOP", frame, "TOP", -10, -10)
	text:SetText("<  "..L["Export / Import"].."  >")
	text:SetJustifyH("left")
	
	local ExScrollArea = CreateFrame("ScrollFrame", "SLEExportScrollFrame", frame, "UIPanelScrollFrameTemplate")
	ExScrollArea:Point("TOPLEFT", frame, "TOPLEFT", 10, -30)
	ExScrollArea:Point("BOTTOMRIGHT", frame, "BOTTOM", -25, 30)
	ExScrollArea:CreateBackdrop()
	Sk:HandleScrollBar(SLEExportScrollFrameScrollBar)
	
	local ImScrollArea = CreateFrame("ScrollFrame", "SLEImportScrollFrame", frame, "UIPanelScrollFrameTemplate")
	ImScrollArea:Point("TOPRIGHT", frame, "TOPRIGHT", -30, -30)
	ImScrollArea:Point("BOTTOMLEFT", frame, "BOTTOM", 5, 30)
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
	ExEditBox:SetText("Press button - get ya settings!")

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
	ImEditBox:SetText("Put your settings here, NAO!")

	local close = CreateFrame("Button", "SLEExImFrameCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT")
	close:SetFrameLevel(close:GetFrameLevel() + 1)
	close:EnableMouse(true)
	
	Sk:HandleCloseButton(close)	
	
	local button1 = CreateFrame("Button", "SLEExportProfileTab", frame)
	button1:Size(100, 20)
	button1:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 9, 6)
	local button1_t = button1:CreateFontString(nil, "OVERLAY")
	button1_t:SetFont(E["media"].normFont, 14)
	button1_t:SetPoint("CENTER", button1)
	button1_t:SetText("Export Profile")
	Sk:HandleButton(button1)
	button1:SetScript("OnClick", function(self) 
		local msg = SLE:DisplayToTableString(E.db, "E.db")
		ExEditBox:SetText(msg)
		ExEditBox:SetFocus()
		ExEditBox:HighlightText()
	end)
	
	local button2 = CreateFrame("Button", "SLEExportPrivateTab", frame)
	button2:Size(100, 20)
	button2:Point("LEFT", button1, "RIGHT", 4, 0)
	local button2_t = button2:CreateFontString(nil, "OVERLAY")
	button2_t:SetFont(E["media"].normFont, 14)
	button2_t:SetPoint("CENTER", button2)
	button2_t:SetText("Export Private")
	Sk:HandleButton(button2)
	button2:SetScript("OnClick", function(self) 
		local msg = SLE:DisplayToTableString(E.private, "E.private")
		ExEditBox:SetText(msg)
		ExEditBox:SetFocus()
		ExEditBox:HighlightText()
	end)
	
	local exHelp = CreateFrame("Button", "SLEExportHelp", frame)
	exHelp:Size(20, 20)
	exHelp:Point("LEFT", button2, "RIGHT", 4, 0)
	local exHelp_t = exHelp:CreateFontString(nil, "OVERLAY")
	exHelp_t:SetFont(E["media"].normFont, 14)
	exHelp_t:SetPoint("CENTER", exHelp)
	exHelp_t:SetText("?")
	Sk:HandleButton(exHelp)
	exHelp:HookScript("OnEnter", function(self) 
		GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 2, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine([[|cffFFFFFFExporting:
Click button for whatever table you are willing to export.
Profile will copy profile based settings;
Private will copy character specific settings.|r]])
			if self.allowDrop then
				GameTooltip:AddLine(L['Right-click to drop the item.'])
			end
		GameTooltip:Show()
	end)
	exHelp:HookScript("OnLeave", function() GameTooltip:Hide() end)
		
	local button3 = CreateFrame("Button", "SLEExportPrivateTab", frame)
	button3:Size(100, 20)
	button3:Point("BOTTOMLEFT", frame, "BOTTOM", 4, 6)
	local button3_t = button3:CreateFontString(nil, "OVERLAY")
	button3_t:SetFont(E["media"].normFont, 14)
	button3_t:SetPoint("CENTER", button3)
	button3_t:SetText("Import")
	Sk:HandleButton(button3)
	button3:SetScript("OnClick", function(self) --This shit doesn't work right now
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
	
	local imHelp = CreateFrame("Button", "SLEImportHelp", frame)
	imHelp:Size(20, 20)
	imHelp:Point("LEFT", button3, "RIGHT", 4, 0)
	local imHelp_t = imHelp:CreateFontString(nil, "OVERLAY")
	imHelp_t:SetFont(E["media"].normFont, 14)
	imHelp_t:SetPoint("CENTER", imHelp)
	imHelp_t:SetText("?")
	Sk:HandleButton(imHelp)
	imHelp:HookScript("OnEnter", function(self) 
		GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 2, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine([[|cffFFFFFFImporting:
To import the settings you need to paste the setting table
or line to the import editbox and click import button.
You can use next formats for settings:
1) E.db.chat.panelHeight = 185
2) E.db['chat']['panelHeight'] = 185
3) E.db['chat'] = {
...
}
In case of the third format you should put at least 2 values.|r]])
			if self.allowDrop then
				GameTooltip:AddLine(L['Right-click to drop the item.'])
			end
		GameTooltip:Show()
	end)
	imHelp:HookScript("OnLeave", function() GameTooltip:Hide() end)
end

hooksecurefunc(E, "UpdateAll", UpdateAll)