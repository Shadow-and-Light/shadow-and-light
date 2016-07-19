local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local B = LibStub("LibBabble-SubZone-3.0")
local BL = B:GetLookupTable()
local S = E:GetModule("Skins")
local Tools = SLE:NewModule("Toolbars", 'AceHook-3.0', 'AceEvent-3.0')

local SeedAnchor, ToolAnchor, PortalAnchor, SalvageAnchor, MineAnchor
local farmzones = { BL["Sunsong Ranch"], BL["The Halfhill Market"] }
local garrisonzones = { BL["Salvage Yard"], BL["Frostwall Mine"], BL["Lunarfall Excavation"]}
local size
local Zcheck = false
local playerFaction = T.UnitFactionGroup('player')
local _G = _G
local GameTooltip = GameTooltip
local ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow = ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow
local PickupContainerItem, DeleteCursorItem = PickupContainerItem, DeleteCursorItem


--MoP Farm
Tools.Seeds = {
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
Tools.AddSeeds = {
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
Tools.FarmTools = {
	[79104]	= { 1 }, -- Rusy Watering Can
	[80513] = { 1 }, -- Vintage Bug Sprayer
	[89880] = { 1 }, -- Dented Shovel
	[89815] = { 1 }, -- Master Plow
}
Tools.FarmPortals = {
	[91850] = { "Horde" }, -- Orgrimmar Portal Shard
	[91861] = { "Horde" }, -- Thunder Bluff Portal Shard
	[91862] = { "Horde" }, -- Undercity Portal Shard
	[91863] = { "Horde" }, -- Silvermoon Portal Shard

	[91860] = { "Alliance" }, -- Stormwind Portal Shard
	[91864] = { "Alliance" }, -- Ironforge Portal Shard
	[91865] = { "Alliance" }, -- Darnassus Portal Shard
	[91866] = { "Alliance" }, -- Exodar Portal Shard
}
Tools.FarmQuests = {
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
Tools.FseedButtons = {}
Tools.FtoolButtons = {}
Tools.FportalButtons = {}


--WoD Garrison
Tools.Salvage = {
	[114116] = { 1 }, -- Bag of Salvaged Goods
	[114119] = { 1 }, -- Crate of Salvage
	[114120] = { 1 }, -- Big Crate of Salvage
}
Tools.GarMine = {
	[118903] = { 1 }, -- Minepick
	[118897] = { 1 }, -- Coffee
}
Tools.GsalvageButtons = {}
Tools.GminingButtons = {}

Tools.buttoncounts = {} --To kepp number of itams
Tools.Bars = {
	["SeedBars"] = {},
}

local function CanSeed()
	-- local subzone = T.GetSubZoneText()
	-- for _, zone in T.ipairs(farmzones) do
		-- if (zone == subzone) then
			-- return true
		-- end
	-- end
	-- return false
	return true
end

local function OnFarm()
	return T.GetSubZoneText() == farmzones[1]
end

local function InSalvageYard()
	return T.GetMinimapZoneText() == garrisonzones[1]
end

local function InMine()
	return T.GetMinimapZoneText() == garrisonzones[playerFaction == "Horde" and 2 or 3]
end

function Tools:InventoryUpdate(event)
	if T.InCombatLockdown() then
		Tools:RegisterEvent("PLAYER_REGEN_ENABLED", "InventoryUpdate")
		return
	else
		Tools:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end

 	local SeedChange = false
	for i = 1, 5 do
		for _, button in T.ipairs(Tools.FseedButtons[i]) do
			button.items = T.GetItemCount(button.itemId, nil, true)
			if i == 2 or i == 4 then
				for id, v in T.pairs(Tools.AddSeeds) do
					if button.itemId == Tools.AddSeeds[id][1] then
						local nCount = T.GetItemCount(id, nil, true)
						button.items = button.items + nCount
					end
				end
			end
			if not Tools.buttoncounts[button.itemId] then
				Tools.buttoncounts[button.itemId] = button.items
			end
			if button.items ~= Tools.buttoncounts[button.itemId] then
				SeedChange = true
				Tools.buttoncounts[button.itemId] = button.items
			end
			button.text:SetText(button.items)
			button.icon:SetDesaturated(button.items == 0)
			button.icon:SetAlpha(button.items == 0 and .25 or 1)
		end
	end
	
	for _, button in T.ipairs(Tools.FtoolButtons) do
		button.items = T.GetItemCount(button.itemId)
		if not Tools.buttoncounts[button.itemId] then
			Tools.buttoncounts[button.itemId] = button.items
		end
		if button.items ~= Tools.buttoncounts[button.itemId] then
			SeedChange = true
			Tools.buttoncounts[button.itemId] = button.items
		end
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end
	
	for _, button in T.ipairs(Tools.FportalButtons) do
		button.items = T.GetItemCount(button.itemId)
		if not Tools.buttoncounts[button.itemId] then
			Tools.buttoncounts[button.itemId] = button.items
		end
		if button.items ~= Tools.buttoncounts[button.itemId] then
			SeedChange = true
			Tools.buttoncounts[button.itemId] = button.items
		end
		button.text:SetText(button.items)
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end	
	
	for _, button in T.ipairs(Tools.GsalvageButtons) do
		button.items = T.GetItemCount(button.itemId)
		if not Tools.buttoncounts[button.itemId] then
			Tools.buttoncounts[button.itemId] = button.items
		end
		if button.items ~= Tools.buttoncounts[button.itemId] then
			SeedChange = true
			Tools.buttoncounts[button.itemId] = button.items
		end
		button.text:SetText(button.items)
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end
	for _, button in T.ipairs(Tools.GminingButtons) do
		button.items = T.GetItemCount(button.itemId)
		if not Tools.buttoncounts[button.itemId] then
			Tools.buttoncounts[button.itemId] = button.items
		end
		if button.items ~= Tools.buttoncounts[button.itemId] then
			SeedChange = true
			Tools.buttoncounts[button.itemId] = button.items
		end
		button.text:SetText(button.items)
		button.icon:SetDesaturated(button.items == 0)
		button.icon:SetAlpha(button.items == 0 and .25 or 1)
	end
	if event and event ~= "BAG_UPDATE_COOLDOWN" and SeedChange == true then
		Tools:UpdateLayout()
	end
end

local function UpdateBarLayout(bar, anchor, buttons, category, db)
	if not db.enable then return end
	local count = 0
	bar:ClearAllPoints()
	bar:Point("LEFT", anchor, "LEFT", 0, 0)
	
	for i, button in T.ipairs(buttons) do
		button:ClearAllPoints()
		if not button.items then Tools:InventoryUpdate() end
		if not db.active or button.items > 0 then
			button:Point("TOPLEFT", bar, "TOPLEFT", (count * (db.buttonsize+(2 - E.Spacing)))+(1 - E.Spacing), -1)
			button:Show()
			button:Size(db.buttonsize, db.buttonsize)
			count = count + 1
		else
			button:Hide()
		end
	end
	
	bar:Width(1)
	bar:Height(db.buttonsize+2)
	
	return count
end

local function QuestItems(itemID)
	for i = 1, T.GetNumQuestLogEntries() do
		for qid, sid in T.pairs(Tools.FarmQuests) do
			if qid == T.select(9,T.GetQuestLogTitle(i)) then
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
		button.cooldown:SetCooldown(T.GetItemCooldown(button.itemId))
	end
end

local function UpdateCooldown()
	if not CanSeed() and not InSalvageYard() and not InMine() then return end

	for i = 1, 5 do
		for _, button in T.ipairs(Tools.FseedButtons[i]) do
			UpdateButtonCooldown(button)
		end
	end
	for _, button in T.ipairs(Tools.FtoolButtons) do
		UpdateButtonCooldown(button)
	end
	for _, button in T.ipairs(Tools.FportalButtons) do
		UpdateButtonCooldown(button)
	end
	for _, button in T.ipairs(Tools.GsalvageButtons) do
		UpdateButtonCooldown(button)
	end
	for _, button in T.ipairs(Tools.GminingButtons) do
		UpdateButtonCooldown(button)
	end
end

local function UpdateSeedBarLayout(Bar, anchor, buttons, category, db)
	if not db.enable then return end
	local count = 0
	size = db.buttonsize
	local seedor = db.seedor
	local id
	Bar:ClearAllPoints()
	if category == 1 then
		if seedor == "TOP" or seedor == "BOTTOM" then
			Bar:Point(seedor.."LEFT", anchor, -2*E.Spacing, seedor == "TOP" and 0 or (2 - E.Spacing*2))
		elseif seedor == "LEFT" or seedor ==  "RIGHT" then
			Bar:Point("TOP"..seedor, anchor, (seedor == "LEFT" and 0 or 2), -2)
		end
		
	else
		if _G["SLEFarmSeedBar"..(category-1)]:IsShown() then
			if seedor == "TOP" or seedor == "BOTTOM" then
				Bar:Point("TOPLEFT", _G["SLEFarmSeedBar"..(category-1)], "TOPRIGHT", -E.Spacing, 0)
			elseif seedor == "LEFT" or seedor ==  "RIGHT" then
				Bar:Point("TOPLEFT", _G["SLEFarmSeedBar"..(category-1)], "BOTTOMLEFT", 0, E.Spacing)
			end
		else
			UpdateSeedBarLayout(Bar, anchor, buttons, category-1, db)
		end
	end
	
	
	for i, button in T.ipairs(buttons) do
		id = T.gsub(button:GetName(), "FarmButton", "")
		id = T.tonumber(id)
		button:ClearAllPoints()
		if not db.active or button.items > 0 then
			if seedor == "TOP" or seedor == "BOTTOM" then
				local mult = seedor == "TOP" and -1 or 1
				button:Point(seedor.."LEFT", Bar, 1 + E.Spacing, mult*(count * (size+(2 - E.Spacing))) - 1 + E.Spacing)
			elseif seedor == "LEFT" or seedor == "RIGHT" then
				local mult = seedor == "RIGHT" and -1 or 1
				button:Point("TOPLEFT", Bar, "TOPLEFT", mult*(count * (size+(2 - E.Spacing))) - 1 + E.Spacing, 1 + E.Spacing)
			end
			button:Show()
			button:Size(size, size)
			count = count + 1
		else
			button:Hide()
		end
		if db.quest then
			if not CanSeed() then
				Bar:Width(size+2)
				Bar:Height(size+2)
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
	
	Bar:Width(size+2)
	Bar:Height(size+2)

	return count
end

local function UpdateBar(bar, layoutfunc, zonecheck, anchor, buttons, category, db)
	bar:Show()

	local count = layoutfunc(bar, anchor, buttons, category, db)
	if (db.enable and (count and count > 0) and zonecheck() and not T.InCombatLockdown()) then
		bar:Show()
	else
		bar:Hide()
	end
end

function Tools:BAG_UPDATE_COOLDOWN()
	Tools:InventoryUpdate()
	UpdateCooldown()
end

local function Zone(event)
	if CanSeed() or InSalvageYard() or InMine() then
		Tools:RegisterEvent("BAG_UPDATE", "InventoryUpdate")
		Tools:RegisterEvent("BAG_UPDATE_COOLDOWN")
		Tools:RegisterEvent("UNIT_QUEST_LOG_CHANGED", "UpdateLayout")
		Tools:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "InventoryUpdate")

		Tools:InventoryUpdate(event)
		Tools:UpdateLayout()
		Zcheck = true
	else
		Tools:UnregisterEvent("BAG_UPDATE")
		Tools:UnregisterEvent("BAG_UPDATE_COOLDOWN")
		Tools:UnregisterEvent("UNIT_QUEST_LOG_CHANGED")
		Tools:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		if Zcheck then
			Tools:UpdateLayout()
			Zcheck = false
		end
	end
end

local function ResizeFrames()
	local seedor = E.db.sle.legacy.farm.seedor
	if seedor == "TOP" or seedor == "BOTTOM" then
		SeedAnchor:Size((E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*5 - E.Spacing, (E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*10 - E.Spacing)
	elseif seedor == "LEFT" or seedor == "RIGHT" then
		SeedAnchor:Size((E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*10 - E.Spacing, (E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*5 - E.Spacing)
	end
	ToolAnchor:Size((E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*5 - E.Spacing, E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing) - E.Spacing)
	PortalAnchor:Size((E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*5 - E.Spacing, E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing) - E.Spacing)
	SalvageAnchor:Size((E.db.sle.legacy.garrison.toolbar.buttonsize+(2 - E.Spacing))*3 - E.Spacing, E.db.sle.legacy.garrison.toolbar.buttonsize+(2 - E.Spacing) - E.Spacing)
	MineAnchor:Size((E.db.sle.legacy.garrison.toolbar.buttonsize+(2 - E.Spacing))*2 - E.Spacing, E.db.sle.legacy.garrison.toolbar.buttonsize+(2 - E.Spacing) - E.Spacing)
end

function Tools:UpdateLayout(event, unit) --don't touch
	-- if not SeedAnchor then return end
	--For updating borders after quest was complited. for some reason events fires before quest disappeares from log
	if event == "UNIT_QUEST_LOG_CHANGED" then
		if unit == "player" then 
			E:Delay(1, Tools.UpdateLayout)
		else
			return
		end
	end 
	if T.InCombatLockdown() then
		Tools:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")	
		return
	else
		Tools:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end
	if E.db.sle.legacy.farm.enable then
		E:EnableMover(SeedAnchor.mover:GetName())
		E:EnableMover(ToolAnchor.mover:GetName())
		E:EnableMover(PortalAnchor.mover:GetName())
	else
		E:DisableMover(SeedAnchor.mover:GetName())
		E:DisableMover(ToolAnchor.mover:GetName())
		E:DisableMover(PortalAnchor.mover:GetName())
	end
	UpdateBar(_G["SLEFarmToolsBar"], UpdateBarLayout, OnFarm, ToolAnchor, Tools.FtoolButtons, nil, E.db.sle.legacy.farm)
	UpdateBar(_G["SLEFarmPortalBar"], UpdateBarLayout, OnFarm, PortalAnchor, Tools.FportalButtons, nil, E.db.sle.legacy.farm)
	for i=1, 5 do
		UpdateBar(_G["SLEFarmSeedBar"..i], UpdateSeedBarLayout, CanSeed, SeedAnchor, Tools.FseedButtons[i], i, E.db.sle.legacy.farm)
	end
	if E.db.sle.legacy.garrison.toolbar.enable then
		E:EnableMover(SalvageAnchor.mover:GetName())
	else
		E:DisableMover(SalvageAnchor.mover:GetName())
	end
	
	UpdateBar(_G["SLEGarrisonSalvageBar"], UpdateBarLayout, InSalvageYard, SalvageAnchor, Tools.GsalvageButtons, nil, E.db.sle.legacy.garrison.toolbar);
	UpdateBar(_G["SLEGarrisonMiningBar"], UpdateBarLayout, InMine, MineAnchor, Tools.GminingButtons, nil, E.db.sle.legacy.garrison.toolbar);
	ResizeFrames()
end

local function AutoTarget(button)
	local container, slot = SLE:BagSearch(button.itemId)
	if container and slot then
		button:SetAttribute("type", "macro")
		button:SetAttribute("macrotext", T.format("/targetexact %s \n/use %s %s", L["Tilled Soil"], container, slot))
	end
end

local function onClick(self, mousebutton)
	if mousebutton == "LeftButton" then
		if T.InCombatLockdown() and not self.macro then
			SLE:Print(L["We are sorry, but you can't do this now. Try again after the end of this combat."])
			return
		end
		self:SetAttribute("type", self.buttonType)
		self:SetAttribute(self.buttonType, self.sortname)
		if self.id and self.id ~= 2 and self.id ~= 4 and E.db.sle.legacy.farm.autotarget and T.UnitName("target") ~= L["Tilled Soil"] then
			AutoTarget(self)
		end
		if self.cooldown then 
			self.cooldown:SetCooldown(T.GetItemCooldown(self.itemId))
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
	Tools:InventoryUpdate()
end

local function onEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 2, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(" ")
	GameTooltip:SetItemByID(self.itemId) 
	if self.allowDrop then
		GameTooltip:AddLine(L["Right-click to drop the item."])
	end
	GameTooltip:Show()
end

local function onLeave()
	GameTooltip:Hide() 
end

local function CreateToolsButton(index, owner, buttonType, name, texture, allowDrop, id, db)
	size = db.buttonsize
	local button = CreateFrame("Button", T.format("ToolsButton%d", index), owner, "SecureActionButtonTemplate")
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

	if T.select(3, T.GetItemCooldown(button.itemId)) == 1 then
		button.cooldown = CreateFrame("Cooldown", T.format("ToolsButton%dCooldown", index), button)
		button.cooldown:SetAllPoints(button)
	end

	button:HookScript("OnEnter", onEnter)
	button:HookScript("OnLeave", onLeave)
	button:SetScript("OnMouseDown", onClick)
	
	return button
end

local function FramesPosition()
	SeedAnchor:Point("LEFT", E.UIParent, "LEFT", 24, -160)
	ToolAnchor:Point("BOTTOMLEFT", SeedAnchor, "TOPLEFT", 0, 1 + E.Spacing*4)
	PortalAnchor:Point("BOTTOMLEFT", ToolAnchor, "TOPLEFT", 0, 1 + E.Spacing*4)
	SalvageAnchor:Point("LEFT", E.UIParent, "LEFT", 24, 0);
	MineAnchor:Point("LEFT", SalvageAnchor, "LEFT", 0, 0)
end

function Tools:CreateFrames()
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

	for id, v in T.pairs(Tools.Seeds) do
		Tools.Seeds[id] = { v[1], T.GetItemInfo(id) }
	end
	
	for id, v in T.pairs(Tools.FarmTools) do
		Tools.FarmTools[id] = { T.GetItemInfo(id) }
	end

	for id, v in T.pairs(Tools.FarmPortals) do
		Tools.FarmPortals[id] = { v[1], T.GetItemInfo(id) }
	end

	for id, v in T.pairs(Tools.Salvage) do
		Tools.Salvage[id] = { T.GetItemInfo(id) }
	end
	
	for id, v in T.pairs(Tools.GarMine) do
		Tools.GarMine[id] = { T.GetItemInfo(id) }
	end

	for i = 1, 5 do
		local seedBar = CreateFrame("Frame", "SLEFarmSeedBar"..i, UIParent)
		seedBar:SetFrameStrata("BACKGROUND")
		
		seedBar:SetPoint("CENTER", SeedAnchor, "CENTER", 0, 0)

		Tools.FseedButtons[i] = Tools.FseedButtons[i] or {}
				
		for id, v in T.pairs(Tools.Seeds) do
			if v[1] == i then
				T.tinsert(Tools.FseedButtons[i], CreateToolsButton(id, seedBar, "item", v[2], v[11], true, i, E.db.sle.legacy.farm))
			end
			T.sort(Tools.FseedButtons[i], function(a, b) return a.sortname < b.sortname end)
		end
	end
	
	local toolBar = CreateFrame("Frame", "SLEFarmToolsBar", UIParent)
	toolBar:SetFrameStrata("BACKGROUND")
	toolBar:SetPoint("CENTER", ToolAnchor, "CENTER", 0, 0)
	for id, v in T.pairs(Tools.FarmTools) do
		T.tinsert(Tools.FtoolButtons, CreateToolsButton(id, toolBar, "item", v[1], v[10], true, nil, E.db.sle.legacy.farm))
	end
	
	local portalBar = CreateFrame("Frame", "SLEFarmPortalBar", UIParent)
	portalBar:SetFrameStrata("BACKGROUND")
	portalBar:SetPoint("CENTER", PortalAnchor, "CENTER", 0, 0)
	for id, v in T.pairs(Tools.FarmPortals) do
		if v[1] == playerFaction then
			T.tinsert(Tools.FportalButtons, CreateToolsButton(id, portalBar, "item", v[2], v[11], false, nil, E.db.sle.legacy.farm))
		end
	end

	local salvageBar = CreateFrame("Frame", "SLEGarrisonSalvageBar", UIParent);
	salvageBar:SetFrameStrata("BACKGROUND")
	salvageBar:SetPoint("CENTER", SalvageAnchor, "CENTER", 0, 0)
	for id, v in T.pairs(Tools.Salvage) do
		T.tinsert(Tools.GsalvageButtons, CreateToolsButton(id, salvageBar, "item", v[1], v[10], false, nil, E.db.sle.legacy.garrison.toolbar));
	end
	
	local mineBar = CreateFrame("Frame", "SLEGarrisonMiningBar", UIParent);
	mineBar:SetFrameStrata("BACKGROUND")
	mineBar:SetPoint("CENTER", MineAnchor, "CENTER", 0, 0)
	for id, v in T.pairs(Tools.GarMine) do
		T.tinsert(Tools.GminingButtons, CreateToolsButton(id, mineBar, "item", v[1], v[10], false, nil, E.db.sle.legacy.garrison.toolbar));
	end

	Tools:RegisterEvent("ZONE_CHANGED", Zone)
	Tools:RegisterEvent("ZONE_CHANGED_NEW_AREA", Zone)
	Tools:RegisterEvent("ZONE_CHANGED_INDOORS", Zone)
	Tools:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "InventoryUpdate")

	E:Delay(10, Zone)
end

function Tools:StartBarLoader()
	Tools:UnregisterEvent("PLAYER_ENTERING_WORLD")

	local noItem = false
	-- preload item links to prevent errors
	for id, _ in T.pairs(Tools.Seeds) do
		if T.select(2, T.GetItemInfo(id)) == nil then noItem = true end
	end
	for id, _ in T.pairs(Tools.FarmTools) do
		if T.select(2, T.GetItemInfo(id)) == nil then noItem = true end
	end
	for id, _ in T.pairs(Tools.FarmPortals) do
		if T.select(2, T.GetItemInfo(id)) == nil then noItem = true end
	end
	for id, _ in T.pairs(Tools.Salvage) do
		if T.select(2, T.GetItemInfo(id)) == nil then noItem = true end
	end
	for id, _ in T.pairs(Tools.GarMine) do
		if T.select(2, T.GetItemInfo(id)) == nil then noItem = true end
	end
	if noItem then
		E:Delay(5, Tools.StartBarLoader)
	else
		Tools:CreateFrames()
	end
end

function Tools:Initialize()
	if not SLE.initialized then return end

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "StartBarLoader")

	function Tools:ForUpdateAll()
		Tools:UpdateLayout()
	end
end

SLE:RegisterModule(Tools:GetName())