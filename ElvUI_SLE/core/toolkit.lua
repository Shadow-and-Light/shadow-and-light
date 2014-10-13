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
	E:ToggleConfig()
	if not SLEExImFrame then SLE:CreateExport() end
	if not SLEExImFrame:IsShown() then 
		SLEExportEditBox:SetText(L["SLE_Exp_Desc"])
		SLEImportEditBox:SetText(L["SLE_Imp_Desc"])
		SLEExImFrame:Show() 
	end
end

local datable = {}

function SLE:ExportPrint()
	local text = ''
	for i = 1, #datable do
		text = text..datable[i]
	end
	
	return text
end

function SLE:SettingTable(t, s, root)
	if not root then root = "" end
	for k, v in pairs(t) do
		if type(v) == "string" then
			if root[k] ~= v or E.global.sle.export.full then
				tinsert(datable, #(datable)+1, s.."."..k.." = "..v.."\n")
			end
		elseif type(v) == "number" then
			if root[k] ~= v or E.global.sle.export.full then
				tinsert(datable, #(datable)+1, s.."."..k.." = "..v.."\n")
			else
			end
		elseif type(v) == "boolean" then
			if root[k] ~= v or E.global.sle.export.full then
				local b = v == true and "true" or "false"
				tinsert(datable, #(datable)+1, s.."."..k.." = "..b.."\n")	
			end
		else
			local new = "."..k
			SLE:SettingTable(t[k], s..new, root[k])
		end
	end
end

function SLE:ImportTableReplace(msg)
	if not string.find(msg, "E.db") and not string.find(msg, "E.private") and not string.find(msg, "E.global") then
		return nil
	end
	if string.find(msg, "E.db") then
		msg = gsub(msg, "E.db", "ElvUI[1].db")
	end
	if string.find(msg, "E.private") then
		msg = gsub(msg, "E.private", "ElvUI[1].private")
	end
	if string.find(msg, "E.global") then
		msg = gsub(msg, "E.global", "ElvUI[1].global")
	end

	return msg
end

function SLE:Exporting()
	local msg = ''
	datable = {}
	if E.global.sle.export.profile then
		tinsert(datable, #(datable)+1, "--Profile--\n")
		SLE:SettingTable(E.db, "E.db", P)
	end
	if E.global.sle.export.private then
		tinsert(datable, #(datable)+1, "--Character--\n")
		SLE:SettingTable(E.private, "E.private", V)
	end
	if E.global.sle.export.global then
		tinsert(datable, #(datable)+1, "--Global--\n")
		SLE:SettingTable(E.global, "E.global", G)
	end
	msg = SLE:ExportPrint()
	local editbox = SLEExportEditBox
	editbox:SetText(msg)
	editbox:SetFocus()
	editbox:HighlightText()
end
hooksecurefunc(E, "UpdateAll", UpdateAll)