local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local B = LibStub("LibBabble-SubZone-3.0")
local BL = B:GetLookupTable()
local Tools = SLE:GetModule("Toolbars")
local Farm = SLE:NewModule("Farm")

--GLOBALS: CreateFrame, hooksecurefunc, UIParent
local _G = _G
local format = format
local ToolAnchor, PortalAnchor
local farmzones = { BL["Sunsong Ranch"], BL["The Halfhill Market"] }
local size

local Seeds = {
	[1] = { --Seeds general
		79102, -- Green Cabbage
		89328, -- Jade Squash
		80590, -- Juicycrunch Carrot
		80592, -- Mogu Pumpkin
		80594, -- Pink Turnip
		80593, -- Red Blossom Leek
		80591, -- Scallion
		89329, -- Striped Melon
		80595, -- White Turnip
		89326, -- Witchberry
	},
	[2] = { --Bags general
		80809, -- Green Cabbage
		89848, -- Jade Squash
		84782, -- Juicycrunch Carrot
		85153, -- Mogu Pumpkin
		85162, -- Pink Turnip
		85158, -- Red Blossom Leek
		84783, -- Scallion
		89849, -- Striped Melon
		85163, -- White Turnip
		89847, -- Witchberry
	},
	[3] = { --Seeds special
		85216, -- Enigma
		85217, -- Magebulb
		85219, -- Ominous
		89202, -- Raptorleaf
		85215, -- Snakeroot
		89233, -- Songbell
		91806, -- Unstable Portal
		89197, -- Windshear Cactus
	},
	[4] = { --Bags special
		95449, -- Enigma
		95451, -- Magebulb
		95457, -- Raptorleaf
		95447, -- Snakeroot
		95445, -- Songbell
		95454, -- Windshear Cactus
	},
	[5] = { --Trees lol
		85267, -- Autumn Blossom Sapling
		85268, -- Spring Blossom Sapling
		85269, -- Winter Blossom Sapling
	},
}

local FarmTools = {
	[1] = {
		79104, -- Rusy Watering Can
		80513, -- Vintage Bug Sprayer
		89880, -- Dented Shovel
		89815, -- Master Plow
	},
}
local FarmPortals = {
	["Horde"] = {
		91850, -- Orgrimmar Portal Shard
		91861, -- Thunder Bluff Portal Shard
		91862, -- Undercity Portal Shard
		91863, -- Silvermoon Portal Shard
	},
	["Alliance"] = {
		91860, -- Stormwind Portal Shard
		91864, -- Ironforge Portal Shard
		91865, -- Darnassus Portal Shard
		91866, -- Exodar Portal Shard
	},
}
local FarmQuests = {
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
-- Tools.FseedButtons = {}
Tools.FtoolButtons = {}
Tools.FportalButtons = {}

local function QuestItems(itemID)
	for i = 1, GetNumQuestLogEntries() do
		for qid, sid in pairs(FarmQuests) do
			if qid == select(9, GetQuestLogTitle(i)) then
				if itemID == sid[1] or itemID == sid[2] then
					return true
				end
			end
		end
	end

	return false
end

local function CanSeed()
	if not E.db.sle.legacy.farm.enable then return end
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

function Farm:CreateFarmSeeds()
	local SeedAnchor = CreateFrame("Frame", "SLE_SeedToolbarsAnchor", E.UIParent)
	SeedAnchor:SetFrameStrata("BACKGROUND")
	SeedAnchor:SetPoint("LEFT", E.UIParent, "LEFT", 24, -160)

	SeedAnchor.Bars = {}
	SeedAnchor.NumBars = 5
	SeedAnchor.BarsName = "SLE_FarmSeedToolbar"

	SeedAnchor.ReturnDB = function() return E.db.sle.legacy.farm end
	SeedAnchor.ShouldShow = CanSeed
	SeedAnchor.InventroyCheck = function()
		local change = false
		for i = 1, SeedAnchor.NumBars do
			for id, button in ipairs(SeedAnchor.Bars[SeedAnchor.BarsName..i].Buttons) do
				button.items = GetItemCount(button.itemId, nil, true)
				if not Tools.buttoncounts[button.itemId] then
					Tools.buttoncounts[button.itemId] = 0
				end
				if button.items ~= Tools.buttoncounts[button.itemId] then
					change = true
					Tools.buttoncounts[button.itemId] = button.items
				end
				button.text:SetText(button.items)
				button.icon:SetDesaturated(button.items == 0)
				button.icon:SetAlpha(button.items == 0 and .25 or 1)
			end
		end
		return change
	end
	SeedAnchor.EnableMover = function() return E.db.sle.legacy.farm.enable end
	SeedAnchor.UpdateBarLayout = function(Bar, anchor, buttons, category, db)
		if not db.enable then return end
		if not category then category = Bar.id end
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
			if _G[SeedAnchor.BarsName..(category-1)]:IsShown() then
				if seedor == "TOP" or seedor == "BOTTOM" then
					Bar:Point("TOPLEFT", _G[SeedAnchor.BarsName..(category-1)], "TOPRIGHT", -E.Spacing, 0)
				elseif seedor == "LEFT" or seedor ==  "RIGHT" then
					Bar:Point("TOPLEFT", _G[SeedAnchor.BarsName..(category-1)], "BOTTOMLEFT", 0, E.Spacing)
				end
			else
				SeedAnchor.UpdateBarLayout(Bar, anchor, buttons, category-1, db)
			end
		end

		for i, button in ipairs(buttons) do
			id = gsub(button:GetName(), "FarmButton", "")
			id = tonumber(id)
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
	SeedAnchor.Resize = function(self)
		local seedor = E.db.sle.legacy.farm.seedor
		if seedor == "TOP" or seedor == "BOTTOM" then
			self:Size((E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*SeedAnchor.NumBars - E.Spacing, (E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*10 - E.Spacing)
		elseif seedor == "LEFT" or seedor == "RIGHT" then
			self:Size((E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*10 - E.Spacing, (E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*SeedAnchor.NumBars - E.Spacing)
		end
	end

	for i = 1, SeedAnchor.NumBars do
		local seedBar = CreateFrame("Frame", SeedAnchor.BarsName..i, SeedAnchor)
		seedBar:SetFrameStrata("BACKGROUND")

		if i == 1 or i == 3 then
			seedBar.Autotarget = function(button)
				if not E.db.sle.legacy.farm.autotarget then return end
				local container, slot = SLE:BagSearch(button.itemId)
				if container and slot then
					button:SetAttribute("type", "macro")
					button:SetAttribute("macrotext", format("/targetexact %s \n/use %s %s", L["Tilled Soil"], container, slot))
				end
			end
		end

		seedBar:SetPoint("CENTER", SeedAnchor, "CENTER", 0, 0)
		seedBar.id = i
		seedBar.Items = {}
		seedBar.zonecheck = CanSeed

		for index = 1, #Seeds[i] do
			local itemID = Seeds[i][index]
			seedBar.Items[itemID] = itemID
		end
		SeedAnchor.Bars[SeedAnchor.BarsName..i] = seedBar
	end

	SeedAnchor.Resize(SeedAnchor)
	E:CreateMover(SeedAnchor, "SLE_FarmSeedMover", L["S&L: Farm Seed Bars"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:DisableMover("SLE_FarmSeedMover")
	return SeedAnchor
end

function Farm:CreateFarmTools()
	ToolAnchor = CreateFrame("Frame", "SLE_ToolsToolbarsAnchor", E.UIParent)
	ToolAnchor:SetFrameStrata("BACKGROUND")
	ToolAnchor:SetPoint("BOTTOMLEFT", _G["SLE_SeedToolbarsAnchor"], "TOPLEFT", 0, 1 + E.Spacing*4)

	ToolAnchor.Bars = {}
	ToolAnchor.NumBars = 1
	ToolAnchor.BarsName = "SLE_FarmToolsToolbar"

	ToolAnchor.ReturnDB = function() return E.db.sle.legacy.farm end
	ToolAnchor.ShouldShow = CanSeed
	ToolAnchor.InventroyCheck = function()
		local change = false
		for _, button in ipairs(ToolAnchor.Bars["SLE_FarmToolsToolbar1"].Buttons) do
			button.items = GetItemCount(button.itemId)
			if not Tools.buttoncounts[button.itemId] then
				Tools.buttoncounts[button.itemId] = button.items
			end
			if button.items ~= Tools.buttoncounts[button.itemId] then
				change = true
				Tools.buttoncounts[button.itemId] = button.items
			end
			button.icon:SetDesaturated(button.items == 0)
			button.icon:SetAlpha(button.items == 0 and .25 or 1)
		end
		return change
	end
	ToolAnchor.EnableMover = function() return E.db.sle.legacy.farm.enable end
	ToolAnchor.UpdateBarLayout = Tools.UpdateBarLayout
	ToolAnchor.Resize = function(self)
		self:Size((E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*5 - E.Spacing, E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing) - E.Spacing)
	end

	local toolBar = CreateFrame("Frame", "SLE_FarmToolsToolbar1", ToolAnchor)
	toolBar:SetFrameStrata("BACKGROUND")
	toolBar:SetPoint("CENTER", ToolAnchor, "CENTER", 0, 0)
	toolBar.id = 1
	toolBar.Items = {}
	toolBar.zonecheck = CanSeed

	for index = 1, #FarmTools[1] do
		local itemID = FarmTools[1][index]
		toolBar.Items[itemID] = itemID
	end
	ToolAnchor.Bars["SLE_FarmToolsToolbar1"] = toolBar

	ToolAnchor.Resize(ToolAnchor)
	E:CreateMover(ToolAnchor, "SLE_FarmToolMover", L["S&L: Farm Tool Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:DisableMover("SLE_FarmToolMover")
	return ToolAnchor
end

function Farm:CreateFarmPortals()
	PortalAnchor = CreateFrame("Frame", "SLE_PortalToolbarAnchor", E.UIParent)
	PortalAnchor:SetFrameStrata("BACKGROUND")
	PortalAnchor:Point("BOTTOMLEFT", "SLE_ToolsToolbarsAnchor", "TOPLEFT", 0, 1 + E.Spacing*4)

	PortalAnchor.Bars = {}
	PortalAnchor.NumBars = 1
	PortalAnchor.BarsName = "SLE_FarmPortalToolbar"

	PortalAnchor.ReturnDB = function() return E.db.sle.legacy.farm end
	PortalAnchor.ShouldShow = CanSeed
	PortalAnchor.InventroyCheck = function()
		local change = false
		for _, button in ipairs(PortalAnchor.Bars["SLE_FarmPortalToolbar1"].Buttons) do
			button.items = GetItemCount(button.itemId)
			if not Tools.buttoncounts[button.itemId] then
				Tools.buttoncounts[button.itemId] = button.items
			end
			if button.items ~= Tools.buttoncounts[button.itemId] then
				change = true
				Tools.buttoncounts[button.itemId] = button.items
			end
			button.text:SetText(button.items)
			button.icon:SetDesaturated(button.items == 0)
			button.icon:SetAlpha(button.items == 0 and .25 or 1)
		end
		return change
	end
	PortalAnchor.EnableMover = function() return E.db.sle.legacy.farm.enable end
	PortalAnchor.UpdateBarLayout = Tools.UpdateBarLayout
	PortalAnchor.Resize = function(self)
		self:Size((E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing))*5 - E.Spacing, E.db.sle.legacy.farm.buttonsize+(2 - E.Spacing) - E.Spacing)
	end

	local portalBar = CreateFrame("Frame", "SLE_FarmPortalToolbar1", PortalAnchor)
	portalBar:SetFrameStrata("BACKGROUND")
	portalBar:SetPoint("CENTER", PortalAnchor, "CENTER", 0, 0)
	portalBar.id = 1
	portalBar.Items = {}
	portalBar.zonecheck = CanSeed

	for index = 1, #FarmPortals[E.myfaction] do
		local itemID = FarmPortals[E.myfaction][index]
		portalBar.Items[itemID] = itemID
	end
	PortalAnchor.Bars["SLE_FarmPortalToolbar1"] = portalBar

	PortalAnchor.Resize(PortalAnchor)
	E:CreateMover(PortalAnchor, "SLE_FarmPortalMover", L["S&L: Farm Portal Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:DisableMover("SLE_FarmPortalMover")
	return PortalAnchor
end

function Farm:Initialize()
	Tools:RegisterForBar(Farm.CreateFarmSeeds)
	Tools:RegisterForBar(Farm.CreateFarmTools)
	Tools:RegisterForBar(Farm.CreateFarmPortals)
end

SLE:RegisterModule(Farm:GetName())