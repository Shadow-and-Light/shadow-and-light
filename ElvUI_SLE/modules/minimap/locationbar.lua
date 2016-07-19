local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule('Minimap')
local MM, DD = SLE:GetModules("Minimap", "Dropdowns")
local LP = SLE:NewModule("LocationPanel", "AceTimer-3.0")
local LSM = LibStub("LibSharedMedia-3.0");
local loc_panel
local COORDS_WIDTH = 35 -- Coord panels width

local _G = _G
local cluster = _G["MinimapCluster"]
local faction
local GetScreenHeight = GetScreenHeight
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local IsShiftKeyDown = IsShiftKeyDown
local ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat = ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat
local UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK = UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK
LP.CDformats = {
	["DEFAULT"] = [[ (%s |TInterface\FriendsFrame\StatusIcon-Away:16|t)]],
	["DEFAULT_ICONFIRST"] = [[ (|TInterface\FriendsFrame\StatusIcon-Away:16|t %s)]],
}

LP.ReactionColors = {
	["sanctuary"] = {r = 0.41, g = 0.8, b = 0.94},
	["arena"] = {r = 1, g = 0.1, b = 0.1},
	["friendly"] = {r = 0.1, g = 1, b = 0.1},
	["hostile"] = {r = 1, g = 0.1, b = 0.1},
	["contested"] = {r = 1, g = 0.7, b = 0.10},
	["combat"] = {r = 1, g = 0.1, b = 0.1},
}

LP.MainMenu = {}
LP.SecondaryMenu = {}

local function GetDirection()
	local x, y = _G["SLE_LocationPanel"]:GetCenter()
	local screenHeight = GetScreenHeight()
	local anchor, point = "TOP", "BOTTOM"
	if y and y < (screenHeight / 2) then
		anchor = "BOTTOM"
		point = "TOP"
	end
	return anchor, point
end

LP.PortItems = {}
LP.Spells = {
	["DEATHKNIGHT"] = {
		[1] = {text =  T.GetSpellInfo(50977),icon = SLE:GetIconFromID("spell", 50977),secure = {buttonType = "spell",ID = 50977}},
	},
	["DEMONHUNTER"] = {},
	["DRUID"] = {
		[1] = {text =  T.GetSpellInfo(18960),icon = SLE:GetIconFromID("spell", 18960),secure = {buttonType = "spell",ID = 18960}},--Moonglade
		[2] = {text =  T.GetSpellInfo(147420),icon = SLE:GetIconFromID("spell", 147420),secure = {buttonType = "spell",ID = 147420}},--One With Nature
		[3] = {text =  T.GetSpellInfo(193753),icon = SLE:GetIconFromID("spell", 193753),secure = {buttonType = "spell",ID = 193753}},--Druid ClassHall
	},
	["HUNTER"] = {},
	["MAGE"] = {
		[1] = {text =  T.GetSpellInfo(193759),icon = SLE:GetIconFromID("spell", 193759),secure = {buttonType = "spell",ID = 193759}}, --Guardian place
	},
	["MONK"] = {
		[1] = {text =  T.GetSpellInfo(126892),icon = SLE:GetIconFromID("spell", 126892),secure = {buttonType = "spell",ID = 126892}},-- Zen Pilgrimage
		[2] = {text =  T.GetSpellInfo(126895),icon = SLE:GetIconFromID("spell", 126895),secure = {buttonType = "spell",ID = 126895}},-- Zen Pilgrimage: Return
	},
	["PALADIN"] = {},
	["PRIEST"] = {},
	["ROGUE"] = {},
	["SHAMAN"] = {
		[1] = {text =  T.GetSpellInfo(556),icon = SLE:GetIconFromID("spell", 556),secure = {buttonType = "spell",ID = 556}},
	},
	["WARLOCK"] = {},
	["WARRIOR"] = {},
	["teleports"] = {
		["Horde"] = {
			[1] = {text = T.GetSpellInfo(3563),icon = SLE:GetIconFromID("spell", 3563),secure = {buttonType = "spell",ID = 3563}},-- TP:Undercity
			[2] = {text = T.GetSpellInfo(3566),icon = SLE:GetIconFromID("spell", 3566),secure = {buttonType = "spell",ID = 3566}},-- TP:Thunder Bluff
			[3] = {text = T.GetSpellInfo(3567),icon = SLE:GetIconFromID("spell", 3567),secure = {buttonType = "spell",ID = 3567}},-- TP:Orgrimmar
			[4] = {text = T.GetSpellInfo(32272),icon = SLE:GetIconFromID("spell", 32272),secure = {buttonType = "spell",ID = 32272}},-- TP:Silvermoon
			[5] = {text = T.GetSpellInfo(49358),icon = SLE:GetIconFromID("spell", 49358),secure = {buttonType = "spell",ID = 49358}},-- TP:Stonard
			[6] = {text = T.GetSpellInfo(35715),icon = SLE:GetIconFromID("spell", 35715),secure = {buttonType = "spell",ID = 35715}},-- TP:Shattrath
			[7] = {text = T.GetSpellInfo(53140),icon = SLE:GetIconFromID("spell", 53140),secure = {buttonType = "spell",ID = 53140}},-- TP:Dalaran - Northrend
			[8] = {text = T.GetSpellInfo(88344),icon = SLE:GetIconFromID("spell", 88344),secure = {buttonType = "spell",ID = 88344}},-- TP:Tol Barad
			[9] = {text = T.GetSpellInfo(132627),icon = SLE:GetIconFromID("spell", 132627),secure = {buttonType = "spell",ID = 132627}},-- TP:Vale of Eternal Blossoms
			[10] = {text = T.GetSpellInfo(120145),icon = SLE:GetIconFromID("spell", 120145),secure = {buttonType = "spell",ID = 120145}},-- TP:Ancient Dalaran
			[11] = {text = T.GetSpellInfo(176242),icon = SLE:GetIconFromID("spell", 176242),secure = {buttonType = "spell",ID = 176242}},-- TP:Warspear
			[12] = {text = T.GetSpellInfo(224873),icon = SLE:GetIconFromID("spell", 224873),secure = {buttonType = "spell",ID = 224873}},-- TP:Dalaran - BI
		},
		["Alliance"] = {
			[1] = {text = T.GetSpellInfo(3561),icon = SLE:GetIconFromID("spell", 3561),secure = {buttonType = "spell",ID = 3561}},-- TP:Stormwind
			[2] = {text = T.GetSpellInfo(3562),icon = SLE:GetIconFromID("spell", 3562),secure = {buttonType = "spell",ID = 3562}},-- TP:Ironforge
			[3] = {text = T.GetSpellInfo(3565),icon = SLE:GetIconFromID("spell", 3565),secure = {buttonType = "spell",ID = 3565}},-- TP:Darnassus
			[4] = {text = T.GetSpellInfo(32271),icon = SLE:GetIconFromID("spell", 32271),secure = {buttonType = "spell",ID = 32271}},-- TP:Exodar
			[5] = {text = T.GetSpellInfo(49359),icon = SLE:GetIconFromID("spell", 49359),secure = {buttonType = "spell",ID = 49359}},-- TP:Theramore
			[6] = {text = T.GetSpellInfo(33690),icon = SLE:GetIconFromID("spell", 33690),secure = {buttonType = "spell",ID = 33690}},-- TP:Shattrath
			[7] = {text = T.GetSpellInfo(53140),icon = SLE:GetIconFromID("spell", 53140),secure = {buttonType = "spell",ID = 53140}},-- TP:Dalaran - Northrend
			[8] = {text = T.GetSpellInfo(88342),icon = SLE:GetIconFromID("spell", 88342),secure = {buttonType = "spell",ID = 88342}},-- TP:Tol Barad
			[9] = {text = T.GetSpellInfo(132621),icon = SLE:GetIconFromID("spell", 132621),secure = {buttonType = "spell",ID = 132621}},-- TP:Vale of Eternal Blossoms
			[10] = {text = T.GetSpellInfo(120145),icon = SLE:GetIconFromID("spell", 120145),secure = {buttonType = "spell",ID = 120145}},-- TP:Ancient Dalaran
			[11] = {text = T.GetSpellInfo(176248),icon = SLE:GetIconFromID("spell", 176248),secure = {buttonType = "spell",ID = 176248}},-- TP:StormShield
			[12] = {text = T.GetSpellInfo(224873),icon = SLE:GetIconFromID("spell", 224873),secure = {buttonType = "spell",ID = 224873}},-- TP:Dalaran - BI
		},
	},
	["portals"] = {
		["Horde"] = {
			[1] = {text = T.GetSpellInfo(11418),icon = SLE:GetIconFromID("spell", 11418),secure = {buttonType = "spell",ID = 11418}},-- P:Undercity
			[2] = {text = T.GetSpellInfo(11420),icon = SLE:GetIconFromID("spell", 11420),secure = {buttonType = "spell",ID = 11420}}, -- P:Thunder Bluff
			[3] = {text = T.GetSpellInfo(11417),icon = SLE:GetIconFromID("spell", 11417),secure = {buttonType = "spell",ID = 11417}},-- P:Orgrimmar
			[4] = {text = T.GetSpellInfo(32267),icon = SLE:GetIconFromID("spell", 32267),secure = {buttonType = "spell",ID = 32267}},-- P:Silvermoon
			[5] = {text = T.GetSpellInfo(49361),icon = SLE:GetIconFromID("spell", 49361),secure = {buttonType = "spell",ID = 49361}},-- P:Stonard
			[6] = {text = T.GetSpellInfo(35717),icon = SLE:GetIconFromID("spell", 35717),secure = {buttonType = "spell",ID = 35717}},-- P:Shattrath
			[7] = {text = T.GetSpellInfo(53142),icon = SLE:GetIconFromID("spell", 53142),secure = {buttonType = "spell",ID = 53142}},-- P:Dalaran - Northred
			[8] = {text = T.GetSpellInfo(88346),icon = SLE:GetIconFromID("spell", 88346),secure = {buttonType = "spell",ID = 88346}},-- P:Tol Barad
			[9] = {text = T.GetSpellInfo(120146),icon = SLE:GetIconFromID("spell", 120146),secure = {buttonType = "spell",ID = 120146}},-- P:Ancient Dalaran
			[10] = {text = T.GetSpellInfo(132626),icon = SLE:GetIconFromID("spell", 132626),secure = {buttonType = "spell",ID = 132626}},-- P:Vale of Eternal Blossoms
			[11] = {text = T.GetSpellInfo(176244),icon = SLE:GetIconFromID("spell", 176244),secure = {buttonType = "spell",ID = 176244}},-- P:Warspear
			[12] = {text = T.GetSpellInfo(224871),icon = SLE:GetIconFromID("spell", 224871),secure = {buttonType = "spell",ID = 224871}},-- P:Dalaran - BI
		},
		["Alliance"] = {
			[1] = {text = T.GetSpellInfo(10059),icon = SLE:GetIconFromID("spell", 10059),secure = {buttonType = "spell",ID = 10059}},-- P:Stormwind
			[2] = {text = T.GetSpellInfo(11416),icon = SLE:GetIconFromID("spell", 11416),secure = {buttonType = "spell",ID = 11416}},-- P:Ironforge
			[3] = {text = T.GetSpellInfo(11419),icon = SLE:GetIconFromID("spell", 11419),secure = {buttonType = "spell",ID = 11419}},-- P:Darnassus
			[4] = {text = T.GetSpellInfo(32266),icon = SLE:GetIconFromID("spell", 32266),secure = {buttonType = "spell",ID = 32266}},-- P:Exodar
			[5] = {text = T.GetSpellInfo(49360),icon = SLE:GetIconFromID("spell", 49360),secure = {buttonType = "spell",ID = 49360}},-- P:Theramore
			[6] = {text = T.GetSpellInfo(33691),icon = SLE:GetIconFromID("spell", 33691),secure = {buttonType = "spell",ID = 33691}},-- P:Shattrath
			[7] = {text = T.GetSpellInfo(53142),icon = SLE:GetIconFromID("spell", 53142),secure = {buttonType = "spell",ID = 53142}},-- P:Dalaran - Northred
			[8] = {text = T.GetSpellInfo(88345),icon = SLE:GetIconFromID("spell", 88345),secure = {buttonType = "spell",ID = 88345}},-- P:Tol Barad
			[9] = {text = T.GetSpellInfo(120146),icon = SLE:GetIconFromID("spell", 120146),secure = {buttonType = "spell",ID = 120146}},-- P:Ancient Dalaran
			[10] = {text = T.GetSpellInfo(132620),icon = SLE:GetIconFromID("spell", 132620),secure = {buttonType = "spell",ID = 132620}},-- P:Vale of Eternal Blossoms
			[11] = {text = T.GetSpellInfo(176246),icon = SLE:GetIconFromID("spell", 176246),secure = {buttonType = "spell",ID = 176246}},-- P:StormShield
			[12] = {text = T.GetSpellInfo(224871),icon = SLE:GetIconFromID("spell", 224871),secure = {buttonType = "spell",ID = 224871}},-- P:Dalaran - BI
		},
	},
}

local function CreateCoords()
	local x, y = T.GetPlayerMapPosition("player")
	x = T.format(LP.db.format, x * 100)
	y = T.format(LP.db.format, y * 100)
	
	return x, y
end

function LP:CreateLocationPanel()
	loc_panel = CreateFrame('Frame', "SLE_LocationPanel", E.UIParent)
	loc_panel:Point('TOP', E.UIParent, 'TOP', 0, -E.mult -22)
	loc_panel:SetFrameStrata('LOW')
	loc_panel:SetFrameLevel(2)
	loc_panel:EnableMouse(true)
	loc_panel:SetScript('OnMouseUp', LP.OnClick)
	loc_panel:SetScript("OnUpdate", LP.UpdateCoords)

	-- Location Text
	loc_panel.Text = loc_panel:CreateFontString(nil, "LOW")
	loc_panel.Text:Point("CENTER", 0, 0)
	loc_panel.Text:SetWordWrap(false)
	E.FrameLocks[loc_panel] = true

	--Coords
	loc_panel.Xcoord = CreateFrame('Frame', "SLE_LocationPanel_X", loc_panel)
	loc_panel.Xcoord:SetPoint("RIGHT", loc_panel, "LEFT", 1 - 2*E.Spacing, 0)
	loc_panel.Xcoord.Text = loc_panel.Xcoord:CreateFontString(nil, "LOW")
	loc_panel.Xcoord.Text:Point("CENTER", 0, 0)

	loc_panel.Ycoord = CreateFrame('Frame', "SLE_LocationPanel_Y", loc_panel)
	loc_panel.Ycoord:SetPoint("LEFT", loc_panel, "RIGHT", -1 + 2*E.Spacing, 0)
	loc_panel.Ycoord.Text = loc_panel.Ycoord:CreateFontString(nil, "LOW")
	loc_panel.Ycoord.Text:Point("CENTER", 0, 0)

	LP:Resize()
	-- Mover
	E:CreateMover(loc_panel, "SLE_Location_Mover", L["Location Panel"], nil, nil, nil, "ALL,S&L,S&L MISC")

	LP.Menu1 = CreateFrame("Frame", "SLE_LocationPanel_RightClickMenu1", E.UIParent)
	LP.Menu1:SetTemplate("Transparent", true)
	LP.Menu2 = CreateFrame("Frame", "SLE_LocationPanel_RightClickMenu2", E.UIParent)
	LP.Menu2:SetTemplate("Transparent", true)
	DD:RegisterMenu(LP.Menu1)
	DD:RegisterMenu(LP.Menu2)
end

function LP:OnClick(btn)
	local zoneText = T.GetRealZoneText() or UNKNOWN;
	if btn == "LeftButton" then
		if IsShiftKeyDown() and LP.db.linkcoords then
			local edit_box = ChatEdit_ChooseBoxForSend()
			local x, y = CreateCoords()
			local message
			local coords = x..", "..y
				if zoneText ~= T.GetSubZoneText() then
					message = T.format("%s: %s (%s)", zoneText, T.GetSubZoneText(), coords)
				else
					message = T.format("%s (%s)", zoneText, coords)
				end
			ChatEdit_ActivateChat(edit_box)
			edit_box:Insert(message) 
		else
			ToggleFrame(_G["WorldMapFrame"])
		end
	elseif btn == "RightButton" and LP.db.portals.enable then
		LP:PopulateDropdown()
	end
end

function LP:UpdateCoords(elapsed)
	LP.elapsed = LP.elapsed + elapsed
	if LP.elapsed < LP.db.throttle then return end
	--Coords
	local x, y = CreateCoords()
	if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
	if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
	loc_panel.Xcoord.Text:SetText(x)
	loc_panel.Ycoord.Text:SetText(y)
	--Location
	local subZoneText = T.GetMinimapZoneText() or ""
	local zoneText = T.GetRealZoneText() or UNKNOWN;
	local displayLine
	if LP.db.zoneText then
		if (subZoneText ~= "") and (subZoneText ~= zoneText) then
			displayLine = zoneText .. ": " .. subZoneText
		else
			displayLine = subZoneText
		end
	else
		displayLine = subZoneText
	end
	loc_panel.Text:SetText(displayLine)

	--Location Colorings
	if displayLine ~= "" then
		local color = {r = 1, g = 1, b = 1}
		if LP.db.colorType == "REACTION" then
			local inInstance, _ = T.IsInInstance()
			if inInstance then
				color = {r = 1, g = 0.1,b =  0.1}
			else
				local pvpType = T.GetZonePVPInfo()
				color = LP.ReactionColors[pvpType] or {r = 1, g = 1, b = 0}
			end
		elseif LP.db.colorType == "CUSTOM" then
			color = LP.db.customColor
		end
		loc_panel.Text:SetTextColor(color.r, color.g, color.b)
	end

	LP.elapsed = 0
end

function LP:Resize()
	loc_panel:Size(LP.db.width, LP.db.height)
	loc_panel.Text:Width(LP.db.width - 18)
	loc_panel.Xcoord:Size(LP.db.fontSize * 3, LP.db.height)
	loc_panel.Ycoord:Size(LP.db.fontSize * 3, LP.db.height)
end

function LP:Fonts()
	loc_panel.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Xcoord.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Ycoord.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
end

function LP:Template()
	loc_panel:SetTemplate(LP.db.template)
	loc_panel.Xcoord:SetTemplate(LP.db.template)
	loc_panel.Ycoord:SetTemplate(LP.db.template)
end

function LP:Toggle()
	if LP.db.enable then
		loc_panel:Show()
		E:EnableMover(loc_panel.mover:GetName())
	else
		loc_panel:Hide()
		E:DisableMover(loc_panel.mover:GetName())
	end
end

function LP:PopulateItems()
	local noItem = false
	if T.select(2, T.GetItemInfo(6948)) == nil then noItem = true end
	if noItem then
		E:Delay(2, LP.PopulateItems)
	else
		LP.PortItems[1] = {text = T.GetItemInfo(6948), icon = SLE:GetIconFromID("item", 6948),secure = {buttonType = "item",ID = 6948}} --Hearthstone
		LP.PortItems[2] = {text = T.GetItemInfo(64488), icon = SLE:GetIconFromID("item", 64488),secure = {buttonType = "item",ID = 64488}} -- The Innkeeper's Daughter
		LP.PortItems[3] = {text = GARRISON_LOCATION_TOOLTIP, icon = SLE:GetIconFromID("item", 110560),secure = {buttonType = "item",ID = 110560}} --Garrison Hearthstone
		LP.PortItems[4] = {text = DUNGEON_FLOOR_DALARAN1, icon = SLE:GetIconFromID("item", 140192),secure = {buttonType = "item",ID = 140192}} --Dalaran Hearthstone
		LP.PortItems[5] = {text = T.GetItemInfo(48933), icon = SLE:GetIconFromID("item", 48933),secure = {buttonType = "item",ID = 48933}} --Wormhole Generator: Northrend
		LP.PortItems[6] = {text = T.GetItemInfo(87215), icon = SLE:GetIconFromID("item", 87215),secure = {buttonType = "item",ID = 87215}} --Wormhole Generator: Pandaria
		LP.PortItems[7] = {text = T.GetItemInfo(112059), icon = SLE:GetIconFromID("item", 112059),secure = {buttonType = "item",ID = 112059}} --Wormhole Centrifuge
		LP.PortItems[8] = {text = T.GetItemInfo(128502), icon = SLE:GetIconFromID("item", 128502),secure = {buttonType = "item",ID = 128502}} --Hunter's Seeking Crystal
		LP.PortItems[9] = {text = T.GetItemInfo(128503), icon = SLE:GetIconFromID("item", 128503),secure = {buttonType = "item",ID = 128503}} --Master Hunter's Seeking Crystal
	end
end

function LP:ItemList(check)
	for i = 1, #LP.PortItems do
		local data = LP.PortItems[i]
		if SLE:BagSearch(data.secure.ID) then
			if check then 
				T.tinsert(LP.MainMenu, {text = ITEMS..":", title = true, nohighlight = true})
				return true 
			else
				local tmp = {}
				local cd = DD:GetCooldown("Item", data.secure.ID)
				if cd then
					E:CopyTable(tmp, data)
					tmp.text = tmp.text..T.format(LP.CDformats[LP.db.portals.cdFormat], cd)
					T.tinsert(LP.MainMenu, tmp)
				else
					T.tinsert(LP.MainMenu, data)
				end
			end
		end
	end
end

function LP:SpellList(list, dropdown, check)
	local tmp = {}
	for i = 1, #list do
		local data = list[i]
		if T.IsSpellKnown(data.secure.ID) then
			if check then 
				return true 
			else
				local cd = DD:GetCooldown("Spell", data.secure.ID)
				if cd then
					E:CopyTable(tmp, data)
					tmp.text = tmp.text..T.format(LP.CDformats[LP.db.portals.cdFormat], cd)
					T.tinsert(dropdown, tmp)
				else
					T.tinsert(dropdown, data)
				end
			end
		end
	end
end

function LP:PopulateDropdown()
	if LP.Menu2:IsShown() then ToggleFrame(LP.Menu2) end
	T.twipe(LP.MainMenu)
	local anchor, point = GetDirection()
	local MENU_WIDTH
	if LP:ItemList(true) then
		LP:ItemList() 
	end
	if LP:SpellList(LP.Spells[E.myclass], nil, true) or E.myclass == "MAGE" then
		T.tinsert(LP.MainMenu, {text = SPELLS..":", title = true, nohighlight = true})
		LP:SpellList(LP.Spells[E.myclass], LP.MainMenu)
		if E.myclass == "MAGE" then
			T.tinsert(LP.MainMenu, {text = L["Teleports"].." >>", icon = SLE:GetIconFromID("spell", 53140), func = function() 
				T.twipe(LP.SecondaryMenu)
				MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G["SLE_LocationPanel"]:GetWidth()
				T.tinsert(LP.SecondaryMenu, {text = "<< "..BACK, func = function() LP:PopulateDropdown() end})
				T.tinsert(LP.SecondaryMenu, {text = L["Teleports"]..":", title = true, nohighlight = true})
				LP:SpellList(LP.Spells["teleports"][faction], LP.SecondaryMenu)
				T.tinsert(LP.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() ToggleFrame(LP.Menu2) end})
				SLE:DropDown(LP.SecondaryMenu, LP.Menu2, anchor, point, 0, 0, _G["SLE_LocationPanel"], MENU_WIDTH, LP.db.portals.justify)
			end})
			T.tinsert(LP.MainMenu, {text = L["Portals"].." >>",icon = SLE:GetIconFromID("spell", 53142), func = function() 
				T.twipe(LP.SecondaryMenu)
				MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G["SLE_LocationPanel"]:GetWidth()
				T.tinsert(LP.SecondaryMenu, {text = "<< "..BACK, func = function() LP:PopulateDropdown() end})
				T.tinsert(LP.SecondaryMenu, {text = L["Portals"]..":", title = true, nohighlight = true})
				LP:SpellList(LP.Spells["portals"][faction], LP.SecondaryMenu)
				T.tinsert(LP.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() ToggleFrame(LP.Menu2) end})
				SLE:DropDown(LP.SecondaryMenu, LP.Menu2, anchor, point, 0, 0, _G["SLE_LocationPanel"], MENU_WIDTH, LP.db.portals.justify)
			end})
		end
	end
	T.tinsert(LP.MainMenu, {text = CLOSE, title = true, ending = true, func = function() ToggleFrame(LP.Menu1) end})
	MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G["SLE_LocationPanel"]:GetWidth()
	SLE:DropDown(LP.MainMenu, LP.Menu1, anchor, point, 0, 0, _G["SLE_LocationPanel"], MENU_WIDTH, LP.db.portals.justify)
end

function LP:Initialize()
	LP.db = E.db.sle.minimap.locPanel
	if not SLE.initialized then return end
	faction = T.UnitFactionGroup('player')
	LP:PopulateItems()

	LP.elapsed = 0
	LP:CreateLocationPanel()
	LP:Template()
	LP:Fonts()
	LP:Toggle()
	function LP:ForUpdateAll()
		LP.db = E.db.sle.minimap.locPanel
		LP:Resize()
		LP:Template()
		LP:Fonts()
		LP:Toggle()
	end
end

SLE:RegisterModule(LP:GetName())