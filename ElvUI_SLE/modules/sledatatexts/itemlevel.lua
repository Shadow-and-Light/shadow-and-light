local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DT = E:GetModule('DataTexts')
local HEADSLOT, NECKSLOT, SHOULDERSLOT, BACKSLOT, CHESTSLOT, WRISTSLOT, HANDSSLOT, WAISTSLOT, LEGSSLOT, FEETSLOT, FINGER0SLOT_UNIQUE, FINGER1SLOT_UNIQUE, TRINKET0SLOT_UNIQUE, TRINKET1SLOT_UNIQUE, MAINHANDSLOT, SECONDARYHANDSLOT = HEADSLOT, NECKSLOT, SHOULDERSLOT, BACKSLOT, CHESTSLOT, WRISTSLOT, HANDSSLOT, WAISTSLOT, LEGSSLOT, FEETSLOT, FINGER0SLOT_UNIQUE, FINGER1SLOT_UNIQUE, TRINKET0SLOT_UNIQUE, TRINKET1SLOT_UNIQUE, MAINHANDSLOT, SECONDARYHANDSLOT
local displayString = ''
local lastPanel
local ITEM_LEVEL_ABBR = ITEM_LEVEL_ABBR
local GMSURVEYRATING3 = GMSURVEYRATING3
local TOTAL = TOTAL

local slots = {
	[1] = { "HeadSlot", HEADSLOT },
	[2] = { "NeckSlot", NECKSLOT },
	[3] = { "ShoulderSlot", SHOULDERSLOT },
	[4] = { "BackSlot", BACKSLOT },
	[5] = { "ChestSlot", CHESTSLOT },
	[6] = { "WristSlot", WRISTSLOT },
	[7] = { "HandsSlot", HANDSSLOT },
	[8] = { "WaistSlot", WAISTSLOT },
	[9] = { "LegsSlot", LEGSSLOT },
	[10] = { "FeetSlot", FEETSLOT },
	[11] = { "Finger0Slot", FINGER0SLOT_UNIQUE },
	[12] = { "Finger1Slot", FINGER1SLOT_UNIQUE },
	[13] = { "Trinket0Slot", TRINKET0SLOT_UNIQUE },
	[14] = { "Trinket1Slot", TRINKET1SLOT_UNIQUE },
	[15] = { "MainHandSlot", MAINHANDSLOT },
	[16] = { "SecondaryHandSlot", SECONDARYHANDSLOT },
}

local levelColors = {
	[0] = { 1, 0, 0 },
	[1] = { 0, 1, 0 },
	[2] = { 1, 1, .5 },
}

local levelAdjust = {
	["0"]=0,["1"]=8,["373"]=4,["374"]=8,["375"]=4,["376"]=4,["377"]=4,["379"]=4,["380"]=4,
	["445"]=0,["446"]=4,["447"]=8,["451"]=0,["452"]=8,["453"]=0,["454"]=4,["455"]=8,
	["456"]=0,["457"]=8,["458"]=0,["459"]=4,["460"]=8,["461"]=12,["462"]=16,
	["465"]=0,["466"]=4,["467"]=8,["468"] = 0,["469"] = 4,["470"] = 8,["471"] = 12,["472"] = 16,
	["491"]=0,["492"]=4,["493"]=8,["494"]=4,["495"]=8,["496"]=8,["497"]=12,["498"]=16
}

local heirlooms = {
	[80] = {
		42943, --Bloodied Arcanite Reaper
		42944, --Balanced Heartseeker
		42945, --Venerable Dal'Rend's Sacred Charge
		42946, --Charmed Ancient Bone Bow
		42947, --Dignified Headmaster's Charge
		42948, --Devout Aurastone Hammer
		42949, --Polished Spaulders of Valor
		42950, --Champion Herod's Shoulder
		42951, --Mystical Pauldrons of Elements
		42952, --Stained Shadowcraft Spaulders
		42984, --Preened Ironfeather Shoulders
		42985, --Tattered Dreadmist Mantle
		42991, --Swift Hand of Justice
		42992, --Discerning Eye of the Beast
		44091, --Sharpened Scarlet Kris
		44092, --Reforged Truesilver Champion
		44093, --Upgraded Dwarven Hand Cannon
		44094, --The Blessed Hammer of Grace
		44095, --Grand Staff of Jordan
		44096, --Battleworn Thrash Blade
		44097, --Inherited Insignia of the Horde
		44098, --Inherited Insignia of the Alliance
		44099, --Strengthened Stockade Pauldrons
		44100, --Pristine Lightforge Spaulders
		44101, --Prized Beastmaster's Mantle
		44102, --Aged Pauldrons of The Five Thunders
		44103, --Exceptional Stormshroud Shoulders
		44105, --Lasting Feralheart Spaulders
		44107, --Exquisite Sunderseer Mantle
		48677, --Champion's Deathdealer Breastplate
		48683, --Mystical Vest of Elements
		48685, --Polished Breastplate of Valor
		48687, --Preened Ironfeather Breastplate
		48689, --Stained Shadowcraft Tunic
		48691, --Tattered Dreadmist Robe
		48716, --Venerable Mass of McGowan
		48718, --Repurposed Lava Dredger
		50255, --Dread Pirate Ring
		69889, --Burnished Breastplate of Might
		69890, --Burnished Pauldrons of Might
		69893, --Bloodsoaked Skullforge Reaver
		79131, --Burnished Warden Staff
	},
	[85] = {
		61931, --Polished Helm of Valor
		61935, --Tarnished Raging Berserker's Helm
		61936, --Mystical Coif of Elements
		61937, --Stained Shadowcraft Cap
		61942, --Preened Tribal War Feathers
		61958, --Tattered Dreadmist Mask
		62023, --Polished Legplates of Valor
		62024, --Tarnished Leggings of Destruction
		62025, --Mystical Kilt of Elements
		62026, --Stained Shadowcraft Pants
		62027, --Preened Wildfeather Leggings
		62029, --Tattered Dreadmist Leggings
		62038, --Worn Stoneskin Gargoyle Cape
		62039, --Inherited Cape of the Black Baron
		62040, --Ancient Bloodmoon Cloak
		69887, --Burnished Helm of Might
		69888, --Burnished Legplates of Might
		69892, --Ripped Sandstorm Cloak
		93841, --Smoothbore Dwarven Hand Cannon
		93843, --Hardened Arcanite Reaper
		93844, --Refinished Warden Staff
		93845, --Gore-Steeped Skullforge Reaver
		93846, --Re-Engineered Lava Dredger
		93847, --Crushing Mass of McGowan
		93848, --Battle-Hardened Thrash Blade
		93849, --Elder Staff of Jordan
		93850, --The Sanctified hammer of Grace
		93851, --Battle-Forged Truesilver Champion
		93852, --Deadly Scarlet Kris
		93853, --Pious Aurastone hammer
		93854, --Scholarly Headmaster's Charge
		93855, --War-Torn Ancient Bone Bow
		93856, --Noble Dal'Rend's Sacred Charge
		93857, --Vengeful Heartseeker
		93859, --Bloodstained Dreadmist Mantle
		93860, --Bloodstained Dreadmist Robe
		93861, --Prestigious Sunderseer Mantle
		93862, --Supple Shadowcraft Spaulders
		93863, --Supple Shadowcraft Tunic
		93864, --Majestic Ironfeather Shoulders
		93865, --Majestic Ironfeather Breastplate
		93866, --Wild Feralheart Spaulders
		93867, --Superior Stormshroud Shoulders
		93876, --Awakened Pauldrons of Elements
		93885, --Awakened Vest of Elements
		93886, --Adorned Beastmaster's Mantle
		93887, --Grand Champion Herod's Shoulder
		93888, --Furious Deathdealer Breastplate
		93889, --Venerated Pauldrons of The Five Thunders
		93890, --Gleaming Spaulders of Valor
		93891, --Gleaming Breastplate of Valor
		93892, --Brushed Breaastplate of Might
		93893, --Brushed Pauldrons of Might
		93894, --Immaculate Lightforge Spaulders
		93895, --Reinforced Stockade Pauldrons
		93896, --Forceful Hand of Justice
		93897, --Piercing Eye of the Beast
		93899, --Bequeathed Insignia of the Alliance
		93900, --Inherited Mark of Tyranny
		93902, --Flamescarred Draconian Deflector
		93903, --Weathered Observer's Shield
		93904, --Musty Tome of the Lost
	},
	[90] = {
		104399, --Hellscream's Warbow (Normal)
		104400, --Hellscream's Razor (Normal)
		104401, --Hellscream's Doomblade (Normal)
		104402, --Hellscream's Warmace (Normal)
		104403, --Hellscream's Pig Sticker (Normal)
		104404, --Hellscream's Cleaver (Normal)
		104405, --Hellscream's Decapitator (Normal)
		104406, --Hellscream's War Staff (Normal)
		104407, --Hellscream's Shield Wall (Normal)
		104408, --Hellscream's Tome of Destruction (Normal)
		104409, --Hellscream's Barrier (Normal)
		105670, --Hellscream's Warbow (Flex)
		105671, --Hellscream's Razor (Flex)
		105672, --Hellscream's Cleaver (Flex)
		105673, --Hellscream's Pig Sticker (Flex)
		105674, --Hellscream's Barrier (Flex)
		105675, --Hellscream's Warmace (Flex)
		105676, --Hellscream's Tome of Destruction (Flex)
		105677, --Hellscream's War Staff (Flex)
		105678, --Hellscream's Doomblade (Flex)
		105679, --Hellscream's Decapitator (Flex)
		105680, --Hellscream's Shield Wall (Flex)
		105683, --Hellscream's Warbow (Heroic)
		105684, --Hellscream's Razor (Heroic)
		105685, --Hellscream's Cleaver (Heroic)
		105686, --Hellscream's Pig Sticker (Heroic)
		105687, --Hellscream's Barrier (Heroic)
		105688, --Hellscream's Warmace (Heroic)
		105689, --Hellscream's Tome of Destruction (Heroic)
		105690, --Hellscream's War Staff (Heroic)
		105691, --Hellscream's Doomblade (Heroic)
		105692, --Hellscream's Decapitator (Heroic)
		105693, --Hellscream's Shield Wall (Heroic)
	},
	[100] = {
		133585, --Judgment of the Naaru
		133595, --Gronntooth War Horn
		133596, --Orb of Voidsight
		133597, --Infallible Tracking Charm
		133598, --Purified Shard of the Third Moon
	},
}

local function HeirLoomLevel(itemLink)
	local ItemID, _, _, _, _, _, _, _, level = T.match(itemLink, '|Hitem:(%d+):(%d*):(%d*):(%d*):(%d*):(%d*):(%d*):(%d*):(%d*)')
	ItemID, level = T.tonumber(ItemID), T.tonumber(level)
	for _, ID in pairs(heirlooms[100]) do
		if ID == ItemID then
			return (715 + (10 * (level - 100)));
		end
	end
	for _, ID in T.pairs(heirlooms[90]) do
		if ID == ItemID then
			return T.select(4, T.GetItemInfo(itemLink))
		end
	end
	for _, ID in T.pairs(heirlooms[85]) do
		if ID == ItemID and level > 85 then
			level = 85
			break
		end
	end
	for _, ID in T.pairs(heirlooms[80]) do
		if ID == ItemID and level > 80 then
			level = 80
			break
		end
	end

	if level > 80 then
		return (( level - 81) * 12) + 285;
	elseif level > 67 then
		return (( level - 68) * 6) + 115;
	elseif level > 59 then
		return (( level - 60) * 3) + 85;
	else
		return level
	end
end

local function ArtifactLevel(itemLink)
	local itemLevel = select(4, T.GetItemInfo(itemLink));
	for i = 1, 3 do
		local relicLink = select(4, C_ArtifactUI.GetEquippedArtifactRelicInfo(i));
		if (relicLink and T.match(relicLink, "item:")) then
			itemLevel = itemLevel + C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic(relicLink);
		end
	end

	return itemLevel;
end

local function GetItemLevel(itemLink)
	local rarity, itemLevel = T.select(3, T.GetItemInfo(itemLink))
	if rarity == 6 then
		itemLevel = ArtifactLevel(itemLink);
	elseif rarity == 7 then
		itemLevel = HeirLoomLevel(itemLink)
	end
	local upgrade = T.match(itemLink, ":(%d+)\124h%[")
	if itemLevel and upgrade and levelAdjust[upgrade] then
		itemLevel = itemLevel + levelAdjust[upgrade]
	end
	return itemLevel
end

local function OnEvent(self)
	self.avgItemLevel, self.avgEquipItemLevel = T.GetAverageItemLevel()
	self.text:SetFormattedText(displayString, ITEM_LEVEL_ABBR, T.floor(self.avgEquipItemLevel), T.floor(self.avgItemLevel))
end

local function OnEnter(self)
	local avgItemLevel, avgEquipItemLevel = self.avgItemLevel, self.avgEquipItemLevel
	local itemLevel
	DT:SetupTooltip(self)
	DT.tooltip:AddDoubleLine(TOTAL, T.floor(avgItemLevel), 1, 1, 1, 0, 1, 0)
	DT.tooltip:AddDoubleLine(GMSURVEYRATING3, T.floor(avgEquipItemLevel), 1, 1, 1, 0, 1, 0)
	DT.tooltip:AddLine(" ")
	for i = 1, 16 do
		local itemLink = T.GetInventoryItemLink("player", T.GetInventorySlotInfo(slots[i][1]))
		if itemLink then
			itemLevel = GetItemLevel(itemLink)
			if itemLevel and avgEquipItemLevel then
				local color = levelColors[(itemLevel < avgEquipItemLevel - 10 and 0 or (itemLevel > avgEquipItemLevel + 10 and 1 or (2)))]
				DT.tooltip:AddDoubleLine(slots[i][2], itemLevel, 1, 1, 1, color[1], color[2], color[3])
			end
		end
	end
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = T.join("", "|cffffffff%s:|r", " ", hex, "%d / %d|r")
	if lastPanel ~= nil then OnEvent(lastPanel) end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("S&L Item Level", {"PLAYER_ENTERING_WORLD", "PLAYER_EQUIPMENT_CHANGED", "UNIT_INVENTORY_CHANGED"}, OnEvent, nil, nil, OnEnter)