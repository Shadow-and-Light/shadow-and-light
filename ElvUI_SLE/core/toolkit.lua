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

function SLE:ImportTable()
	
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
	
	local button3 = CreateFrame("Button", "SLEExportPrivateTab", frame)
	button3:Size(100, 20)
	button3:Point("BOTTOMLEFT", frame, "BOTTOM", 4, 6)
	local button3_t = button3:CreateFontString(nil, "OVERLAY")
	button3_t:SetFont(E["media"].normFont, 14)
	button3_t:SetPoint("CENTER", button3)
	button3_t:SetText("Import")
	Sk:HandleButton(button3)
	button3:SetScript("OnClick", function(self) --This shit doesn't work right now
		local E, L, V, P, G = unpack(ElvUI);
 		local msg = ImEditBox:GetText()
		local func = loadstring(msg)
		func()
		E:UpdateAll(true)
	end)
end

hooksecurefunc(E, "UpdateAll", UpdateAll)