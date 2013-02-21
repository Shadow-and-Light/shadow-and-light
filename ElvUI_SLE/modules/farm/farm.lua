local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local B = LibStub("LibBabble-SubZone-3.0")
local BL = B:GetLookupTable()
local F = E:NewModule('Farm', 'AceHook-3.0', 'AceEvent-3.0');
local SLE = E:GetModule('SLE');

local SeedAnchor, ToolAnchor, PortalAnchor
local tsort = table.sort
local farmzones = { BL["Sunsong Ranch"], BL["The Halfhill Market"] }
local size

local seedButtons = {}
local toolButtons = {}
local portalButtons = {}

local seeds = {
	--Seeds general
	[79102] = { 1 }, -- Green Cabbage
	[89328] = { 1 }, -- Jade Squash
	[80590] = { 1 }, -- Juicycrunch Carrot
	[80592] = { 1 }, -- Mogu Pumpkin
	[80594] = { 1 }, -- Pink Turnip
	[80593] = { 1 }, -- Red Blossom Leek
	[80591] = { 1 }, -- Scallion
	[89329] = { 1 }, -- Striped Melon
	[80595] = { 1 }, -- White Turnip
	[89326] = { 1 }, -- Witchberry
	--Bags general
	[80809] = { 2 }, -- Green Cabbage
	[89848] = { 2 }, -- Jade Squash
	[84782] = { 2 }, -- Juicycrunch Carrot
	[85153] = { 2 }, -- Mogu Pumpkin
	[85162] = { 2 }, -- Pink Turnip
	[85158] = { 2 }, -- Red Blossom Leek
	[84783] = { 2 }, -- Scallion
	[89849] = { 2 }, -- Striped Melon
	[85163] = { 2 }, -- White Turnip
	[89847] = { 2 }, -- Witchberry
	--Seeds special
	[85216] = { 3 }, -- Enigma
	[85217] = { 3 }, -- Magebulb
	[85219] = { 3 }, -- Ominous
	[89202] = { 3 }, -- Raptorleaf
	[85215] = { 3 }, -- Snakeroot
	[89233] = { 3 }, -- Songbell
	[91806] = { 3 }, -- Unstable Portal
	[89197] = { 3 }, -- Windshear Cactus
	--Bags special
	[95449] = { 4 }, -- Enigma
	[95451] = { 4 }, -- Magebulb
	[95457] = { 4 }, -- Raptorleaf
	[95447] = { 4 }, -- Snakeroot
	[95445] = { 4 }, -- Songbell
	[95454] = { 4 }, -- Windshear Cactus
	--Trees lol
	[85267] = { 5 }, -- Autumn Blossom Sapling
	[85268] = { 5 }, -- Spring Blossom Sapling
	[85269] = { 5 }, -- Winter Blossom Sapling
}

local tools = {
	[79104]	= { 1 }, -- Rusy Watering Can
	[80513] = { 1 }, -- Vintage Bug Sprayer
	[89880] = { 1 }, -- Dented Shovel
	[89815] = { 1 }, -- Master Plow
}

local portals = {
	[91850] = { "Horde" }, -- Orgrimmar Portal Shard
	[91861] = { "Horde" }, -- Thunder Bluff Portal Shard
	[91862] = { "Horde" }, -- Undercity Portal Shard
	[91863] = { "Horde" }, -- Silvermoon Portal Shard
	
	[91860] = { "Alliance" }, -- Stormwind Portal Shard
	[91864] = { "Alliance" }, -- Ironforge Portal Shard
	[91865] = { "Alliance" }, -- Darnassus Portal Shard
	[91866] = { "Alliance" }, -- Exodar Portal Shard
}

local quests = {
--Tillers counsil
[31945] = {80591, 84783}, -- Gina, Scallion
[31946] = {80590, 84782}, -- Mung-Mung, Juicycrunch Carrot
[31947] = {79102, 80809}, -- Farmer Fung, Green Cabbage
[31949] = {89326, 89847}, -- Nana, Witchberry
[30527] = {89329, 89849}, -- Haohan, Striped Melon
--Farmer Yoon
[31943] = {89326, 89847}, -- Witchberry
[31942] = {89329, 89849}, -- Striped Melon
[31941] = {89328, 89848}, -- Jade Squash
[31669] = {79102, 80809}, -- Green Cabbage
[31670] = {80590, 84782}, -- Juicycrunch Carrot
[31672] = {80592, 85153}, -- Mogu Pumpkin
[31673] = {80593, 85158}, -- Red Blossom Leek
[31674] = {80594, 85162}, -- Pink Turnip
[31675] = {80595, 85163}, -- White Turnip
[31671] = {80591, 84783}, -- Scallion
--Work Orders
[32645] = {89326, 89847}, -- Witchberry (Alliance Only)
[32653] = {89329, 89849}, -- Striped Melon
--[31941] = {89328, 89848}, -- Jade Squash
[32649] = {79102, 80809}, -- Green Cabbage
--[31670] = {80590, 84782}, -- Juicycrunch Carrot
[32658] = {80592, 85153}, -- Mogu Pumpkin
[32642] = {80593, 85158}, -- Red Blossom Leek (Horde Only)
--[31674] = {80594, 85162}, -- Pink Turnip
[32647] = {80595, 85163}, -- White Turnip
--[31671] = {80591, 84783}, -- Scallion
}

function F:InSeedZone()
	local subzone = GetSubZoneText()
	for _, zone in ipairs(farmzones) do
		if (zone == subzone) then
			return true
		end
	end
	return false
end

function F:InFarmZone()
	return GetSubZoneText() == farmzones[1]
end

function F:FarmerInventoryUpdate()
	if InCombatLockdown() then return end
	
	for i = 1, 5 do
		for _, button in ipairs(seedButtons[i]) do
			button.items = GetItemCount(button.itemId, nil, true)
			button.text:SetText(button.items)
			button.icon:SetDesaturated(button.items == 0)
			button.icon:SetAlpha(button.items == 0 and .25 or 1)
		end
	end
	
	for _, button in ipairs(toolButtons) do
		button.items = GetItemCount(button.itemId)
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end
	
	for _, button in ipairs(portalButtons) do
		button.items = GetItemCount(button.itemId)
		button.text:SetText(button.items)
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end	
	
	self:UpdateLayout()
end

function F:UpdateBarLayout(bar, anchor, buttons)
	local count = 0
	size = E.db.sle.farm.size
	bar:ClearAllPoints()
	bar:Point("LEFT", anchor, "LEFT", 0, 0)
	
	for i, button in ipairs(buttons) do
		button:ClearAllPoints()
		if not E.db.sle.farm.active or button.items > 0 then
			button:Point("TOPLEFT", bar, "TOPLEFT", (count * (size+(E.PixelMode and 2 or 1)))+(E.PixelMode and 1 or 0), -1)
			button:Show()
			button:Size(size, size)
			count = count + 1
		else
			button:Hide()
		end
	end
	
	bar:Width(1)
	bar:Height(size+2)
	
	return count
end

function F:QuestItems(itemID)
	for i = 1, GetNumQuestLogEntries() do
		for qid, sid in pairs(quests) do
			if qid == select(9,GetQuestLogTitle(i)) then
				if itemID == sid[1] or itemID == sid[2] then
					return true
				end
			end
		end
	end
	
	return false
end

function F:UpdateSeedBarLayout(seedBar, anchor, buttons, category)
	local count = 0
	local db = E.db.sle.farm
	size = db.size
	local seedor = db.seedor
	local id
	seedBar:ClearAllPoints()
	if category == 1 then
		if seedor == "TOP" or seedor == "BOTTOM" then
			seedBar:Point(seedor.."LEFT", anchor, (E.PixelMode and 0 or -2), seedor == "TOP" and 0 or (E.PixelMode and 2 or 0))
		elseif seedor == "LEFT" or seedor ==  "RIGHT" then
			seedBar:Point("TOP"..seedor, anchor, E.PixelMode and 2 or (seedor == "LEFT" and 0 or 2), (E.PixelMode and -2 or -2))
		end
		
	else
		if _G[("FarmSeedBar%d"):format(category-1)]:IsShown() then
			if seedor == "TOP" or seedor == "BOTTOM" then
				seedBar:Point("TOPLEFT", _G[("FarmSeedBar%d"):format(category-1)], "TOPRIGHT", (E.PixelMode and 0 or -1), 0)
			elseif seedor == "LEFT" or seedor ==  "RIGHT" then
				seedBar:Point("TOPLEFT", _G[("FarmSeedBar%d"):format(category-1)], "BOTTOMLEFT", 0, (E.PixelMode and 0 or 1))
			end
		else
			F:UpdateSeedBarLayout(seedBar, anchor, buttons, category-1)
		end
	end
	
	
	for i, button in ipairs(buttons) do
		id = button:GetName():gsub("FarmButton", "")
		id = tonumber(id)
		button:ClearAllPoints()
		if not E.db.sle.farm.active or button.items > 0 then
			if seedor == "TOP" or seedor == "BOTTOM" then
				local mult = seedor == "TOP" and -1 or 1
				button:Point(seedor.."LEFT", seedBar, E.PixelMode and 1 or 2, mult*(count * (size+(E.PixelMode and 2 or 1)))-(E.PixelMode and 1 or 0))
			elseif seedor == "LEFT" or seedor == "RIGHT" then
				local mult = seedor == "RIGHT" and -1 or 1
				button:Point("TOPLEFT", seedBar, "TOPLEFT", mult*(count * (size+(E.PixelMode and 2 or 1)))-(E.PixelMode and 1 or 0), E.PixelMode and 1 or 2)
			end
			button:Show()
			button:Size(size, size)
			count = count + 1
		else
			button:Hide()
		end
		if E.db.sle.farm.quest then
			if F:QuestItems(id) then
				ActionButton_ShowOverlayGlow(button)
			else
				ActionButton_HideOverlayGlow(button)
			end
		else
			ActionButton_HideOverlayGlow(button)
		end
	end
	
	seedBar:Width(size+2)
	seedBar:Height(size+2)

	return count
end

function F:UpdateBar(bar, layoutfunc, zonecheck, anchor, buttons, category)
	bar:Show()
	
	local count = layoutfunc(self, bar, anchor, buttons, category)
	if (E.private.sle.farm.enable and count > 0 and zonecheck(self) and not InCombatLockdown()) then
		bar:Show()
	else
		bar:Hide()
	end
end

function F:UpdateLayout(event)
	if not SeedAnchor then return end
	if event == "UNIT_QUEST_LOG_CHANGED" then E:Delay(1, F.UpdateLayout) end --For updating borders after quest was complited. for some reason events fires before quest disappeares from log
	if InCombatLockdown() then return end
	F:UpdateBar(_G["FarmToolBar"], F.UpdateBarLayout, F.InFarmZone, ToolAnchor, toolButtons)
	F:UpdateBar(_G["FarmPortalBar"], F.UpdateBarLayout, F.InFarmZone, PortalAnchor, portalButtons)
	for i=1, 5 do
		F:UpdateBar(_G[("FarmSeedBar%d"):format(i)], F.UpdateSeedBarLayout, F.InSeedZone, SeedAnchor, seedButtons[i], i)
	end
	F:ResizeFrames()
end

function F:AutoTarget(button)
	local container, slot = SLE:BagSearch(button.itemId)
	if container and slot then
		button:SetAttribute("type", "macro")
		button:SetAttribute("macrotext", format("/targetexact %s \n/use %s %s", L["Tilled Soil"], container, slot))
	end
end

function F:CreateFarmButton(index, owner, buttonType, name, texture, allowDrop, id)
	size = E.db.sle.farm.size
	local button = CreateFrame("Button", ("FarmButton%d"):format(index), owner, "SecureActionButtonTemplate")
	button:Size(size, size)
	button:SetTemplate('Default', true)

	button.sortname = name
	button.itemId = index
	
	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetTexture(texture)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetInside()

	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetFont(E.media.normFont, 12, "OUTLINE")
	button.text:SetPoint("BOTTOMRIGHT", button, 1, 2)
		
	button:SetScript("OnEnter", function()
		GameTooltip:SetOwner(button, 'ANCHOR_TOPLEFT', 2, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(name)
		if allowDrop then
			GameTooltip:AddLine(L['Right-click to drop the item.'])
		end
		GameTooltip:Show()
	end)
	
	button:SetScript("OnLeave", function()
		GameTooltip:Hide() 
	end)

	button:SetScript("OnMouseDown", function(self, mousebutton)
		if mousebutton == "LeftButton" then
			button:SetAttribute("type", buttonType)
			button:SetAttribute(buttonType, name)

			if id and id ~= 2 and id ~= 4 and E.db.sle.farm.autotarget and UnitName("target") ~= L["Tilled Soil"] then
				F:AutoTarget(button)
			end
		elseif mousebutton == "RightButton" and allowDrop then
			button:SetAttribute("type", "click")
			local container, slot = SLE:BagSearch(button.itemId)
			if container and slot then
				PickupContainerItem(container, slot)
				DeleteCursorItem()
			end			
		end
	end)
	
	return button
end				

function F:ResizeFrames()
	local seedor = E.db.sle.farm.seedor
	if seedor == "TOP" or seedor == "BOTTOM" then
		SeedAnchor:Size((size+(E.PixelMode and 2 or 1))*5-(E.PixelMode and 0 or 1), (size+(E.PixelMode and 2 or 1))*10-(E.PixelMode and 0 or 1))
	elseif seedor == "LEFT" or seedor == "RIGHT" then
		SeedAnchor:Size((size+(E.PixelMode and 2 or 1))*10-(E.PixelMode and 0 or 1), (size+(E.PixelMode and 2 or 1))*5-(E.PixelMode and 0 or 1))
	end
	ToolAnchor:Size((size+(E.PixelMode and 2 or 1))*5-(E.PixelMode and 0 or 1), size+(E.PixelMode and 2 or 1)-(E.PixelMode and 0 or 1))
	PortalAnchor:Size((size+(E.PixelMode and 2 or 1))*5-(E.PixelMode and 0 or 1), size+(E.PixelMode and 2 or 1)-(E.PixelMode and 0 or 1))
end

function F:FramesPosition()
	SeedAnchor:Point("LEFT", E.UIParent, "LEFT", 24, -160)
	ToolAnchor:Point("BOTTOMLEFT", SeedAnchor, "TOPLEFT", 0, E.PixelMode and 1 or 5)
	PortalAnchor:Point("BOTTOMLEFT", ToolAnchor, "TOPLEFT", 0, E.PixelMode and 1 or 5)
end				

function F:CreateFrames()
	size = E.db.sle.farm.size
	SeedAnchor = CreateFrame("Frame", "SeedAnchor", E.UIParent)
	SeedAnchor:SetFrameStrata("BACKGROUND")

	ToolAnchor = CreateFrame("Frame", "ToolAnchor", E.UIParent)
	ToolAnchor:SetFrameStrata("BACKGROUND")
	
	PortalAnchor = CreateFrame("Frame", "PortalAnchor", E.UIParent)
	PortalAnchor:SetFrameStrata("BACKGROUND")

	F:ResizeFrames()
	F:FramesPosition()
	
	E:CreateMover(SeedAnchor, "FarmSeedAnchor", L["Farm Seed Bars"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:CreateMover(ToolAnchor, "FarmToolAnchor", L["Farm Tool Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:CreateMover(PortalAnchor, "FarmPortalAnchor", L["Farm Portal Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")
	
	for id, v in pairs(seeds) do
		seeds[id] = { v[1], GetItemInfo(id) }	
	end
	
	for id, v in pairs(tools) do
		tools[id] = { GetItemInfo(id) }
	end

	for id, v in pairs(portals) do
		portals[id] = { v[1], GetItemInfo(id) }
	end

	for i = 1, 5 do
		local seedBar = CreateFrame("Frame", ("FarmSeedBar%d"):format(i), UIParent)
		seedBar:SetFrameStrata("BACKGROUND")
		
		seedBar:SetPoint("CENTER", SeedAnchor, "CENTER", 0, 0)

		seedButtons[i] = seedButtons[i] or {}
				
		for id, v in pairs(seeds) do
			if v[1] == i then
				tinsert(seedButtons[i], F:CreateFarmButton(id, seedBar, "item", v[2], v[11], E.private.sle.farm.seedtrash, i))
			end
			tsort(seedButtons[i], function(a, b) return a.sortname < b.sortname end)
		end
	end
	
	local toolBar = CreateFrame("Frame", "FarmToolBar", UIParent)	
	toolBar:SetFrameStrata("BACKGROUND")
	toolBar:SetPoint("CENTER", ToolAnchor, "CENTER", 0, 0)
	for id, v in pairs(tools) do
		tinsert(toolButtons, F:CreateFarmButton(id, toolBar, "item", v[1], v[10], true, nil))
	end
	
	local portalBar = CreateFrame("Frame", "FarmPortalBar", UIParent)
	portalBar:SetFrameStrata("BACKGROUND")
	portalBar:SetPoint("CENTER", PortalAnchor, "CENTER", 0, 0)
	local playerFaction = UnitFactionGroup('player')
	for id, v in pairs(portals) do
		if v[1] == playerFaction then
			tinsert(portalButtons, F:CreateFarmButton(id, portalBar, "item", v[2], v[11], false, nil))
		end
	end
	
	F:FarmerInventoryUpdate()
	F:UpdateLayout()
	
	F:RegisterEvent("ZONE_CHANGED", "UpdateLayout")
	F:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")
	F:RegisterEvent("BAG_UPDATE", "FarmerInventoryUpdate")
	F:RegisterEvent("UNIT_QUEST_LOG_CHANGED", "UpdateLayout")
end

function F:OnLoadDelay()
	E:Delay(5, F.UpdateLayout)
end

function F:StartFarmBarLoader()
	F:UnregisterEvent("PLAYER_ENTERING_WORLD")

	local noItem = false
	-- preload item links to prevent errors
	for id, _ in pairs(seeds) do
		if select(2, GetItemInfo(id)) == nil then noItem = true end
	end
	for id, _ in pairs(tools) do
		if select(2, GetItemInfo(id)) == nil then noItem = true end
	end
	for id, _ in pairs(portals) do
		if select(2, GetItemInfo(id)) == nil then noItem = true end
	end
	if noItem then
		E:Delay(5, F.StartFarmBarLoader)
	else
		F.CreateFrames()
		E:Delay(1, F.OnLoadDelay)
	end
end

function F:Initialize()
	if not E.private.sle.farm.enable then return end
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "StartFarmBarLoader")
end

E:RegisterModule(F:GetName())