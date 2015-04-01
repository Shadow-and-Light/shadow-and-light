local E, L, V, P, G = unpack(ElvUI);
local B = LibStub("LibBabble-SubZone-3.0")
local BL = B:GetLookupTable()
local F = E:GetModule('SLE_Farm')
local SLE = E:GetModule('SLE');
local S = E:GetModule("Skins")

local SeedAnchor, ToolAnchor, PortalAnchor, SalvageAnchor, MineAnchor
local tsort, format = table.sort, format
local farmzones = { BL["Sunsong Ranch"], BL["The Halfhill Market"] }
local garrisonzones = { BL["Salvage Yard"], BL["Frostwall Mine"], BL["Lunarfall Excavation"]}
local size
local Zcheck = false
local GetSubZoneText = GetSubZoneText
local InCombatLockdown = InCombatLockdown
local GetItemCount, GetItemInfo = GetItemCount, GetItemInfo
local Point = Point
local playerFaction = UnitFactionGroup('player')


FseedButtons = {}
FtoolButtons = {}
FportalButtons = {}
FsalvageButtons = {}
FminingButtons = {}

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

local addseeds = {
	[95434] = { 80809 }, -- Green Cabbage
	[95437] = { 89848 }, -- Jade Squash
	[95436] = { 84782 }, -- Juicycrunch Carrot
	[95438] = { 85153 }, -- Mogu Pumpkin
	[95439] = { 85162 }, -- Pink Turnip
	[95440] = { 85158 }, -- Red Blossom Leek
	[95441] = { 84783 }, -- Scallion
	[95442] = { 89849 }, -- Striped Melon
	[95443] = { 85163 }, -- White Turnip
	[95444] = { 89847 }, -- Witchberry
	
	[95450] = { 95449 }, -- Enigma
	[95452] = { 95451 }, -- Magebulb
	[95458] = { 95457 }, -- Raptorleaf
	[95448] = { 95447 }, -- Snakeroot
	[95446] = { 95445 }, -- Songbell
	[95456] = { 95454 }, -- Windshear Cactus
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

local salvage = {
	[114116] = { 1 }, -- Bag of Salvaged Goods
	[114119] = { 1 }, -- Crate of Salvage
	[114120] = { 1 }, -- Big Crate of Salvage
}

local mineTools = {
	[118903] = { 1 }, -- Minepick
	[118897] = { 1 }, -- Coffee
}

local buttoncounts = {}

local function CanSeed()
	local subzone = GetSubZoneText()
	for _, zone in ipairs(farmzones) do
		if (zone == subzone) then
			return true
		end
	end
	return false
end

local function OnFarm()
	return GetSubZoneText() == farmzones[1]
end

local function InSalvageYard()
	return GetMinimapZoneText() == garrisonzones[1]
end

local function InMine()
	return GetMinimapZoneText() == garrisonzones[playerFaction == "Horde" and 2 or 3]
end

local function InventoryUpdate(event)
	if InCombatLockdown() then
		F:RegisterEvent("PLAYER_REGEN_ENABLED", InventoryUpdate)	
		return
	else
		F:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end

 	local SeedChange = false
	for i = 1, 5 do
		for _, button in ipairs(FseedButtons[i]) do
			button.items = GetItemCount(button.itemId, nil, true)
			if i == 2 or i == 4 then
				for id, v in pairs(addseeds) do
					if button.itemId == addseeds[id][1] then
						local nCount = GetItemCount(id, nil, true)
						button.items = button.items + nCount
					end
				end
			end
			if not buttoncounts[button.itemId] then
				buttoncounts[button.itemId] = button.items
			end
			if button.items ~= buttoncounts[button.itemId] then
				SeedChange = true
				buttoncounts[button.itemId] = button.items
			end
			button.text:SetText(button.items)
			button.icon:SetDesaturated(button.items == 0)
			button.icon:SetAlpha(button.items == 0 and .25 or 1)
		end
	end
	
	for _, button in ipairs(FtoolButtons) do
		button.items = GetItemCount(button.itemId)
		if not buttoncounts[button.itemId] then
			buttoncounts[button.itemId] = button.items
		end
		if button.items ~= buttoncounts[button.itemId] then
			SeedChange = true
			buttoncounts[button.itemId] = button.items
		end
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end
	
	for _, button in ipairs(FportalButtons) do
		button.items = GetItemCount(button.itemId)
		if not buttoncounts[button.itemId] then
			buttoncounts[button.itemId] = button.items
		end
		if button.items ~= buttoncounts[button.itemId] then
			SeedChange = true
			buttoncounts[button.itemId] = button.items
		end
		button.text:SetText(button.items)
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end	
	
	for _, button in ipairs(FsalvageButtons) do
		button.items = GetItemCount(button.itemId)
		if not buttoncounts[button.itemId] then
			buttoncounts[button.itemId] = button.items
		end
		if button.items ~= buttoncounts[button.itemId] then
			SeedChange = true
			buttoncounts[button.itemId] = button.items
		end
		button.text:SetText(button.items)
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end
	for _, button in ipairs(FminingButtons) do
		button.items = GetItemCount(button.itemId)
		if not buttoncounts[button.itemId] then
			buttoncounts[button.itemId] = button.items
		end
		if button.items ~= buttoncounts[button.itemId] then
			SeedChange = true
			buttoncounts[button.itemId] = button.items
		end
		button.text:SetText(button.items)
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end
	if event and event ~= "BAG_UPDATE_COOLDOWN" and SeedChange == true then
		F:UpdateLayout()
	end
end

local function UpdateBarLayout(bar, anchor, buttons)
	local count = 0
	size = E.db.sle.farm.size
	bar:ClearAllPoints()
	bar:Point("LEFT", anchor, "LEFT", 0, 0)
	
	for i, button in ipairs(buttons) do
		button:ClearAllPoints()
		if not button.items then InventoryUpdate() end
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

local function QuestItems(itemID)
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

local function UpdateButtonCooldown(button)
	if button.cooldown then
		button.cooldown:SetCooldown(GetItemCooldown(button.itemId))
	end
end

local function UpdateCooldown()
	if not CanSeed() and not InSalvageYard() and not InMine() then return end

	for i = 1, 5 do
		for _, button in ipairs(FseedButtons[i]) do
			UpdateButtonCooldown(button)
		end
	end
	for _, button in ipairs(FtoolButtons) do
		UpdateButtonCooldown(button)
	end
	for _, button in ipairs(FportalButtons) do
		UpdateButtonCooldown(button)
	end
	for _, button in ipairs(FsalvageButtons) do
		UpdateButtonCooldown(button)
	end
	for _, button in ipairs(FminingButtons) do
		UpdateButtonCooldown(button)
	end
end

local function UpdateSeedBarLayout(seedBar, anchor, buttons, category)
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
			UpdateSeedBarLayout(seedBar, anchor, buttons, category-1)
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
			if not CanSeed() then
				seedBar:Width(size+2)
				seedBar:Height(size+2)
				return count 
			end
			if QuestItems(id) then
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

local function UpdateBar(bar, layoutfunc, zonecheck, anchor, buttons, category)
	bar:Show()

	local count = layoutfunc(bar, anchor, buttons, category)
	if (E.private.sle.farm.enable and count > 0 and zonecheck() and not InCombatLockdown()) then
		bar:Show()
	else
		bar:Hide()
	end
end

function F:BAG_UPDATE_COOLDOWN()
	InventoryUpdate()
	UpdateCooldown()
end

local function Zone(event)
	if CanSeed() or InSalvageYard() or InMine() then
		F:RegisterEvent("BAG_UPDATE", InventoryUpdate)
		F:RegisterEvent("BAG_UPDATE_COOLDOWN")
		F:RegisterEvent("UNIT_QUEST_LOG_CHANGED", "UpdateLayout")
		F:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", InventoryUpdate)

		InventoryUpdate(event)
		F:UpdateLayout()
		Zcheck = true
	else
		F:UnregisterEvent("BAG_UPDATE")
		F:UnregisterEvent("BAG_UPDATE_COOLDOWN")
		F:UnregisterEvent("UNIT_QUEST_LOG_CHANGED")
		F:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		if Zcheck then
			F:UpdateLayout()
			Zcheck = false
		end
	end
end

local function ResizeFrames()
	local seedor = E.db.sle.farm.seedor
	if seedor == "TOP" or seedor == "BOTTOM" then
		SeedAnchor:Size((size+(E.PixelMode and 2 or 1))*5-(E.PixelMode and 0 or 1), (size+(E.PixelMode and 2 or 1))*10-(E.PixelMode and 0 or 1))
	elseif seedor == "LEFT" or seedor == "RIGHT" then
		SeedAnchor:Size((size+(E.PixelMode and 2 or 1))*10-(E.PixelMode and 0 or 1), (size+(E.PixelMode and 2 or 1))*5-(E.PixelMode and 0 or 1))
	end
	ToolAnchor:Size((size+(E.PixelMode and 2 or 1))*5-(E.PixelMode and 0 or 1), size+(E.PixelMode and 2 or 1)-(E.PixelMode and 0 or 1))
	PortalAnchor:Size((size+(E.PixelMode and 2 or 1))*5-(E.PixelMode and 0 or 1), size+(E.PixelMode and 2 or 1)-(E.PixelMode and 0 or 1))
	SalvageAnchor:Size((size+(E.PixelMode and 2 or 1))*3-(E.PixelMode and 0 or 1), size+(E.PixelMode and 2 or 1)-(E.PixelMode and 0 or 1))
	MineAnchor:Size((size+(E.PixelMode and 2 or 1))*2-(E.PixelMode and 0 or 1), size+(E.PixelMode and 2 or 1)-(E.PixelMode and 0 or 1))
end

function F:UpdateLayout(event, unit) --don't touch
	if not SeedAnchor then return end
	--For updating borders after quest was complited. for some reason events fires before quest disappeares from log
	if event == "UNIT_QUEST_LOG_CHANGED" then
		if unit == "player" then 
			E:Delay(1, F.UpdateLayout)
		else
			return
		end
	end 
	if InCombatLockdown() then
		F:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")	
		return
	else
		F:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end
	UpdateBar(_G["FarmToolBar"], UpdateBarLayout, OnFarm, ToolAnchor, FtoolButtons)
	UpdateBar(_G["FarmPortalBar"], UpdateBarLayout, OnFarm, PortalAnchor, FportalButtons)
	for i=1, 5 do
		UpdateBar(_G[("FarmSeedBar%d"):format(i)], UpdateSeedBarLayout, CanSeed, SeedAnchor, FseedButtons[i], i)
	end
	UpdateBar(_G["SalvageCrateBar"], UpdateBarLayout, InSalvageYard, SalvageAnchor, FsalvageButtons);
	UpdateBar(_G["MiningToolsBar"], UpdateBarLayout, InMine, MineAnchor, FminingButtons);
	ResizeFrames()
end

local function AutoTarget(button)
	local container, slot = SLE:BagSearch(button.itemId)
	if container and slot then
		button:SetAttribute("type", "macro")
		button:SetAttribute("macrotext", format("/targetexact %s \n/use %s %s", L["Tilled Soil"], container, slot))
	end
end

local function onClick(self, mousebutton)
	if mousebutton == "LeftButton" then
		if InCombatLockdown() and not self.macro then
			SLE:Print(L["We are sorry, but you can't do this now. Try again after the end of this combat."])
			return
		end
		self:SetAttribute("type", self.buttonType)
		self:SetAttribute(self.buttonType, self.sortname)
		if self.id and self.id ~= 2 and self.id ~= 4 and E.db.sle.farm.autotarget and UnitName("target") ~= L["Tilled Soil"] then
			AutoTarget(self)
		end
		if self.cooldown then 
			self.cooldown:SetCooldown(GetItemCooldown(self.itemId))
		end	
		if not self.macro then self.macro = true end
	elseif mousebutton == "RightButton" and self.allowDrop then
		self:SetAttribute("type", "click")
		local container, slot = SLE:BagSearch(self.itemId)
		if container and slot then
			PickupContainerItem(container, slot)
			DeleteCursorItem()
		end			
	end
	InventoryUpdate()
end

local function onEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 2, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(" ")
	GameTooltip:SetItemByID(self.itemId) 
	if self.allowDrop then
		GameTooltip:AddLine(L['Right-click to drop the item.'])
	end
	GameTooltip:Show()
end

local function onLeave()
	GameTooltip:Hide() 
end

local function CreateFarmButton(index, owner, buttonType, name, texture, allowDrop, id)
	size = E.db.sle.farm.size
	local button = CreateFrame("Button", ("FarmButton%d"):format(index), owner, "SecureActionButtonTemplate")
	button:Size(size, size)
	S:HandleButton(button)

	button.sortname = name
	button.itemId = index
	button.allowDrop = allowDrop
	button.buttonType = buttonType
	button.id = id
	button.macro = false
	
	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetTexture(texture)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetInside()

	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetFont(E.media.normFont, 12, "OUTLINE")
	button.text:SetPoint("BOTTOMRIGHT", button, 1, 2)
	
	if select(3, GetItemCooldown(button.itemId)) == 1 then
		button.cooldown = CreateFrame("Cooldown", ("FarmButton%dCooldown"):format(index), button)
		button.cooldown:SetAllPoints(button)
	end
		
	button:HookScript("OnEnter", onEnter)
	button:HookScript("OnLeave", onLeave)
	button:SetScript("OnMouseDown", onClick)
	
	return button
end				

local function FramesPosition()
	SeedAnchor:Point("LEFT", E.UIParent, "LEFT", 24, -160)
	ToolAnchor:Point("BOTTOMLEFT", SeedAnchor, "TOPLEFT", 0, E.PixelMode and 1 or 5)
	PortalAnchor:Point("BOTTOMLEFT", ToolAnchor, "TOPLEFT", 0, E.PixelMode and 1 or 5)
	SalvageAnchor:Point("LEFT", E.UIParent, "LEFT", 24, 0);
	MineAnchor:Point("LEFT", SalvageAnchor, "LEFT", 0, 0)
end				

local function CreateFrames()
	size = E.db.sle.farm.size
	SeedAnchor = CreateFrame("Frame", "SeedAnchor", E.UIParent)
	SeedAnchor:SetFrameStrata("BACKGROUND")

	ToolAnchor = CreateFrame("Frame", "ToolAnchor", E.UIParent)
	ToolAnchor:SetFrameStrata("BACKGROUND")
	
	PortalAnchor = CreateFrame("Frame", "PortalAnchor", E.UIParent)
	PortalAnchor:SetFrameStrata("BACKGROUND")

	SalvageAnchor = CreateFrame("Frame", "SalvageAnchor", E.UIParent)
	SalvageAnchor:SetFrameStrata("BACKGROUND")
	
	MineAnchor = CreateFrame("Frame", "MineAnchor", E.UIParent)
	MineAnchor:SetFrameStrata("BACKGROUND")

	ResizeFrames()
	FramesPosition()
	
	E:CreateMover(SeedAnchor, "FarmSeedMover", L["Farm Seed Bars"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:CreateMover(ToolAnchor, "FarmToolMover", L["Farm Tool Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:CreateMover(PortalAnchor, "FarmPortalMover", L["Farm Portal Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:CreateMover(SalvageAnchor, "SalvageCrateMover", L["Garrison Tools Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")

	for id, v in pairs(seeds) do
		seeds[id] = { v[1], GetItemInfo(id) }	
	end
	
	for id, v in pairs(tools) do
		tools[id] = { GetItemInfo(id) }
	end

	for id, v in pairs(portals) do
		portals[id] = { v[1], GetItemInfo(id) }
	end

	for id, v in pairs(salvage) do
		salvage[id] = { GetItemInfo(id) }
	end
	
	for id, v in pairs(mineTools) do
		mineTools[id] = { GetItemInfo(id) }
	end

	for i = 1, 5 do
		local seedBar = CreateFrame("Frame", ("FarmSeedBar%d"):format(i), UIParent)
		seedBar:SetFrameStrata("BACKGROUND")
		
		seedBar:SetPoint("CENTER", SeedAnchor, "CENTER", 0, 0)

		FseedButtons[i] = FseedButtons[i] or {}
				
		for id, v in pairs(seeds) do
			if v[1] == i then
				tinsert(FseedButtons[i], CreateFarmButton(id, seedBar, "item", v[2], v[11], E.private.sle.farm.seedtrash, i))
			end
			tsort(FseedButtons[i], function(a, b) return a.sortname < b.sortname end)
		end
	end
	
	local toolBar = CreateFrame("Frame", "FarmToolBar", UIParent)	
	toolBar:SetFrameStrata("BACKGROUND")
	toolBar:SetPoint("CENTER", ToolAnchor, "CENTER", 0, 0)
	for id, v in pairs(tools) do
		tinsert(FtoolButtons, CreateFarmButton(id, toolBar, "item", v[1], v[10], true, nil))
	end
	
	local portalBar = CreateFrame("Frame", "FarmPortalBar", UIParent)
	portalBar:SetFrameStrata("BACKGROUND")
	portalBar:SetPoint("CENTER", PortalAnchor, "CENTER", 0, 0)
	for id, v in pairs(portals) do
		if v[1] == playerFaction then
			tinsert(FportalButtons, CreateFarmButton(id, portalBar, "item", v[2], v[11], false, nil))
		end
	end

	local salvageBar = CreateFrame("Frame", "SalvageCrateBar", UIParent);
	salvageBar:SetFrameStrata("BACKGROUND")
	salvageBar:SetPoint("CENTER", SalvageAnchor, "CENTER", 0, 0)
	for id, v in pairs(salvage) do
		tinsert(FsalvageButtons, CreateFarmButton(id, salvageBar, "item", v[1], v[10], false, nil));
	end
	
	local mineBar = CreateFrame("Frame", "MiningToolsBar", UIParent);
	mineBar:SetFrameStrata("BACKGROUND")
	mineBar:SetPoint("CENTER", MineAnchor, "CENTER", 0, 0)
	for id, v in pairs(mineTools) do
		tinsert(FminingButtons, CreateFarmButton(id, mineBar, "item", v[1], v[10], false, nil));
	end

	F:RegisterEvent("ZONE_CHANGED", Zone)
	F:RegisterEvent("ZONE_CHANGED_NEW_AREA", Zone)
	F:RegisterEvent("ZONE_CHANGED_INDOORS", Zone)
	F:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", InventoryUpdate)
		
	E:Delay(10, Zone)
end

local function StartFarmBarLoader()
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
	for id, _ in pairs(salvage) do
		if select(2, GetItemInfo(id)) == nil then noItem = true end
	end
	for id, _ in pairs(mineTools) do
		if select(2, GetItemInfo(id)) == nil then noItem = true end
	end
	if noItem then
		E:Delay(5, StartFarmBarLoader)
	else
		CreateFrames()
	end
end

function F:Initialize()
	if not E.private.sle.farm.enable then return end
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD", StartFarmBarLoader)
end