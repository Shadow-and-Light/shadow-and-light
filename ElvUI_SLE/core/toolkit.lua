local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local BG = E:GetModule('SLE_BackGrounds')
local DTP = E:GetModule('SLE_DTPanels')
local CH = E:GetModule("Chat")
local UB = E:GetModule('SLE_UIButtons')
local RM = E:GetModule('SLE_RaidMarkers')
local F = E:GetModule('SLE_Farm')
local LT = E:GetModule('SLE_Loot')
local UF = E:GetModule('UnitFrames')
local M = E:GetModule('SLE_Media')
local I = E:GetModule('SLE_InstDif')
local S = E:GetModule("SLE_ScreenSaver")
local G = E:GetModule("SLE_Garrison")
local EF = E:GetModule('SLE_ErrorFrame');
local AT = E:GetModule('SLE_AuraTimers')
local A = E:GetModule('Auras')
local LocTable = {}
LocTable[1], LocTable[2], LocTable[3], LocTable[4], LocTable[5], LocTable[6], LocTable[7] = GetAvailableLocales()

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
	RM:UpdateBar(true)
	F:UpdateLayout()
	CH:GMIconUpdate()
	M:TextWidth()
	I:UpdateFrame()
	S:Reg(true)
	EF:SetSize()
	AT:BuildCasts()
	A:Update_ConsolidatedBuffsSettings()

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
				tinsert(datable, #(datable)+1, s.."."..k..' = "'..v..'"\n')
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

function SLE:GetRegion()
	local rid = GetCurrentRegion()
	local region = {
		[1] = "US",
		[2] = "KR",
		[3] = "EU",
		[4] = "TW",
		[5] = "CN",
	}
	SLE.region = region[rid]
	if not SLE.region then 
		SLE.region = format("An error happened. Your region is unknown. Realm: %s. Please report your realm name and the region you are playing in to |cff1784d1Shadow & Light|r authors.", E.myrealm)
		SLE:Print(SLE.region)
		SLE.region = ""
	end
end

function SLE:Reset(group)
	if not group then print("U wot m8?") end
	if group == "unitframes" or group == "all" then
		E.db.sle.combatico.pos = 'TOP'
		E.db.sle.roleicons = "ElvUI"
		E.db.sle.powtext = false
	end
	if group == "backgrounds" or group == "all" then
		E:CopyTable(E.db.sle.backgrounds, P.sle.backgrounds)
		E:ResetMovers(L["Bottom BG"])
		E:ResetMovers(L["Left BG"])
		E:ResetMovers(L["Right BG"])
		E:ResetMovers(L["Actionbar BG"])
	end
	if group == "datatexts" or group == "all" then
		E:CopyTable(E.db.sle.datatext, P.sle.datatext)
		E:CopyTable(E.db.sle.dt, P.sle.dt)
		E:ResetMovers(L["DP_1"])
		E:ResetMovers(L["DP_2"])
		E:ResetMovers(L["DP_3"])
		E:ResetMovers(L["DP_4"])
		E:ResetMovers(L["DP_5"])
		E:ResetMovers(L["DP_6"])
		E:ResetMovers(L["Top_Center"])
		E:ResetMovers(L["Bottom_Panel"])
		E:ResetMovers(L["Dashboard"])
	end
	if group == "marks" or group == "all" then
		E:CopyTable(E.db.sle.raidmarkers, P.sle.raidmarkers)
		E:ResetMovers(L['Raid Marker Bar'])
	end
	if group == "all" then
		E:CopyTable(E.db.sle, P.sle)
		E:ResetMovers("PvP")
		E:ResetMovers(L["S&L UI Buttons"])
		E:ResetMovers(L["Error Frame"])
		E:ResetMovers(L["Pet Battle Status"])
		E:ResetMovers(L["Pet Battle AB"])
		E:ResetMovers(L["Farm Seed Bars"])
		E:ResetMovers(L["Farm Tool Bar"])
		E:ResetMovers(L["Farm Portal Bar"])
		E:ResetMovers(L["Garrison Tools Bar"])
		E:ResetMovers(L["Ghost Frame"])
		E:ResetMovers(L["Raid Utility"])
		
	end
	E:UpdateAll()
end

function SLE:SetMoverPosition(mover, anchor, parent, point, x, y)
	if not _G[mover] then return end
	local frame = _G[mover]

	frame:ClearAllPoints()
	frame:SetPoint(anchor, parent, point, x, y)
	E:SaveMoverPosition(mover)
end
