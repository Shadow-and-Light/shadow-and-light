local MAJOR, MINOR = 'LibProcessable', 23
assert(LibStub, MAJOR .. ' requires LibStub')

local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

local hasEnchantingBuilding
local inscriptionSkill, jewelcraftingSkill, enchantingSkill, blacksmithingSkill

local MILLING, MORTAR = 51005, 114942
--- API to verify if an item can be processed through the Milling skill or with the Draenic Mortar.
-- @name LibProcessable:IsMillable
-- @usage LibStub('LibProcessable'):IsMillable(itemID[, ignoreMortar])
-- @param itemID The itemID of the item to check against
-- @param ignoreMortar Ignore the Draenic Mortar, an item to mill Draenor herbs without needing Inscription
-- @return isMillable Boolean indicating if the player can process the item
-- @return skillRequired Number representing the required skill to process the item
-- @return skillLevel Number representing the player's skill in Inscription
-- @return mortarItemID Number representing the Draenic Mortar, if used
function lib:IsMillable(itemID, ignoreMortar)
	assert(tonumber(itemID), 'itemID needs to be a number or convertable to a number')
	itemID = tonumber(itemID)

	if(IsSpellKnown(MILLING)) then
		local skillRequired = lib.herbs[itemID]
		return skillRequired and skillRequired <= inscriptionSkill, skillRequired, inscriptionSkill
	elseif(not ignoreMortar and GetItemCount(MORTAR) > 0) then
		return itemID >= 109124 and itemID <= 109130, 1, nil, MORTAR
	end
end

local PROSPECTING = 31252
--- API to verify if an item can be processed through the Prospecting skill.
-- @name LibProcessable:IsProspectable
-- @usage LibStub('LibProcessable'):IsProspectable(itemID)
-- @param itemID The itemID of the item to check against
-- @return isProspectable Boolean indicating if the player can process the item
-- @return skillRequired Number representing the required skill to process the item
-- @return skillLevel Number representing the player's skill in Jewelcrafting
function lib:IsProspectable(itemID)
	assert(tonumber(itemID), 'itemID needs to be a number or convertable to a number')
	itemID = tonumber(itemID)

	if(IsSpellKnown(PROSPECTING)) then
		local skillRequired = lib.ores[itemID]
		return skillRequired and skillRequired <= jewelcraftingSkill, skillRequired, jewelcraftingSkill
	end
end

local DISENCHANTING = 13262
--- API to verify if an item can be processed through the Disenchanting profession ability.
-- @name LibProcessable:IsDisenchantable
-- @usage LibStub('LibProcessable'):IsDisenchantable(itemID | itemLink)
-- @param itemID The itemID of the item to check against
-- @param itemLink The itemLink of the item to check against
-- @return isDisenchantable Boolean indicating if the player can process the item
-- @return skillRequired Number representing the required skill to process the item
-- @return skillLevel Number representing the player's skill in Enchanting
function lib:IsDisenchantable(item)
	if(type(item) == 'string') then
		if(not string.match(item, 'item:(%d+):') and not tonumber(item)) then
			assert(false, 'item must be an item ID or item Link')
		end

		if(tonumber(item)) then
			item = tonumber(item)
		end
	end

	if(IsSpellKnown(DISENCHANTING)) then
		local _, _, quality, _, _, _, _, _, _, _, _, class, subClass = GetItemInfo(item)
		if(self.specialItems.enchanting[itemID] or ((class == 2 or class == 4 or (class == 3 and subClass == 11)) and (quality >= 2 and quality <= 4))) then
			return true, 1, enchantingSkill
		end
	end
end

-- http://www.wowhead.com/items/name:key?filter=86;2;0
local function GetSkeletonKey(pickLevel)
	if(pickLevel > 425) then
		return 82960, 500, 450 -- Ghostly Skeleton Key
	elseif(pickLevel > 400) then
		return 55053, 475, 425 -- Obsidium Skeleton Key
	elseif(pickLevel > 375) then
		return 43853, 430, 400 -- Titanium Skeleton Key
	elseif(pickLevel > 300) then
		return 43854, 350, 375 -- Cobalt Skeleton Key
	elseif(pickLevel > 200) then
		return 15872, 275, 300 -- Arcanite Skeleton Key
	elseif(pickLevel > 125) then
		return 15871, 200, 200 -- Truesilver Skeleton Key
	elseif(pickLevel > 25) then
		return 15870, 150, 125 -- Golden Skeleton Key
	else
		return 15869, 100, 25 -- Silver Skeleton Key
	end
end

-- http://www.wowhead.com/items/name:lock?filter=86;7;0
local function GetJeweledLockpick(pickLevel)
	if(pickLevel <= 750) then
		return 130250, 1, 750
	end
end

local LOCKPICKING = 1804
--- API to verify if an item can be opened through Rogue's Lock Pick skill
-- @name	LibProcessable:IsOpenable
-- @usage	LibStub('LibProcessable'):IsOpenable(itemID)
-- @param	itemID		Number	The itemID of the item to check against
-- @return	isOpenable	Boolean `true` if the player can open the item, `false` otherwise
-- @return	pickLevel	Number	Represents the required lockpick level of the item
-- @return	skillLevel	Number	Represents the player's lockpicking skill level
function lib:IsOpenable(itemID)
	assert(tonumber(itemID), 'itemID needs to be a number or convertable to a number')
	itemID = tonumber(itemID)

	local pickLevel = lib.containers[itemID]
	if(IsSpellKnown(LOCKPICKING)) then
		local skillLevel = UnitLevel('player') * 5
		return pickLevel and pickLevel <= skillLevel, pickLevel, skillLevel
	end
end

local BLACKSMITHING, JEWELCRAFTING = 2018, 25229
--- API to verify if an item can be opened through the players' professions
-- @name	LibProcessable:IsOpenableProfession
-- @usage	LibStub('LibProcessable'):IsOpenableProfession(itemID)
-- @param	itemID			Number	The itemID of the item to check against
-- @return	isOpenable		Boolean `true` if the player can open the item, `false` otherwise
-- @return	pickLevel		Number	Represents the required lockpick level of the item
-- @return	professionData	Table	Containing data relavant to the profession(s) that can open the item with a key
function lib:IsOpenableProfession(itemID)
	assert(tonumber(itemID), 'itemID needs to be a number or convertable to a number')
	itemID = tonumber(itemID)

	local pickLevel = lib.containers[itemID]
	if(not pickLevel) then
		return false
	end

	local professionData, canOpen = {}
	if(GetSpellBookItemInfo(GetSpellInfo(BLACKSMITHING))) then
		local professionItemID, skillRequired, skillLevel = GetSkeletonKey(pickLevel)
		canOpen = skillRequired <= blacksmithingSkill and pickLevel <= skillLevel

		professionData['blacksmithing'] = {
			skillID = BLACKSMITHING,
			itemID = professionItemID,
			skillRequired = skillRequired,
			skillLevel = blacksmithingSkill,
			opensLevel = skillLevel
		}
	end

	if(GetSpellBookItemInfo(GetSpellInfo(JEWELCRAFTING))) then
		local professionItemID, skillRequired, skillLevel = GetJeweledLockpick(pickLevel)
		canOpen = skillRequired <= jewelcraftingSkill and pickLevel <= skillLevel

		professionData['jewelcrafting'] = {
			skillID = JEWELCRAFTING,
			itemID = professionItemID,
			skillRequired = skillRequired,
			skillLevel = jewelcraftingSkill,
			opensLevel = skillLevel
		}
	end

	return canOpen, pickLevel, professionData
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('SKILL_LINES_CHANGED')
Handler:RegisterEvent('GARRISON_BUILDING_PLACED')
Handler:RegisterEvent('GARRISON_BUILDING_REMOVED')
Handler:SetScript('OnEvent', function(self, event, ...)
	if(event == 'SKILL_LINES_CHANGED') then
		inscriptionSkill, jewelcraftingSkill, enchantingSkill, blacksmithingSkill = 0, 0, 0, 0

		local first, second = GetProfessions()
		if(first) then
			local _, _, skill, _, _, _, id = GetProfessionInfo(first)
			if(id == 773) then
				inscriptionSkill = skill
			elseif(id == 755) then
				jewelcraftingSkill = skill
			elseif(id == 333) then
				enchantingSkill = skill
			elseif(id == 164) then
				blacksmithingSkill = skill
			end
		end

		if(second) then
			local _, _, skill, _, _, _, id = GetProfessionInfo(second)
			if(id == 773) then
				inscriptionSkill = skill
			elseif(id == 755) then
				jewelcraftingSkill = skill
			elseif(id == 333) then
				enchantingSkill = skill
			elseif(id == 164) then
				blacksmithingSkill = skill
			end
		end
	elseif(event == 'GARRISON_BUILDING_PLACED') then
		local plotID = ...
		local buildingID = C_Garrison.GetOwnedBuildingInfoAbbrev(plotID)
		if(lib.enchantingBuildings[buildingID]) then
			hasEnchantingBuilding = true
		end
	elseif(event == 'GARRISON_BUILDING_REMOVED') then
		local _, buildingID = ...
		if(lib.enchantingBuildings[buildingID]) then
			hasEnchantingBuilding = false
		end
	end
end)

-- https://gist.github.com/p3lim/04e614e59c0064100c7c
lib.herbs = {
	[765] = 1, -- Silverleaf
	[785] = 0, -- Mageroyal
	[2447] = 1, -- Peacebloom
	[2449] = 1, -- Earthroot
	[2450] = 25, -- Briarthorn
	[2452] = 25, -- Swiftthistle
	[2453] = 25, -- Bruiseweed
	[3355] = 75, -- Wild Steelbloom
	[3356] = 75, -- Kingsblood
	[3357] = 75, -- Liferoot
	[3358] = 125, -- Khadgar's Whisker
	[3369] = 75, -- Grave Moss
	[3818] = 125, -- Fadeleaf
	[3819] = 125, -- Dragon's Teeth
	[3820] = 25, -- Stranglekelp
	[3821] = 125, -- Goldthorn
	[4625] = 175, -- Firebloom
	[8831] = 175, -- Purple Lotus
	[8836] = 175, -- Arthas' Tears
	[8838] = 175, -- Sungrass
	[8839] = 175, -- Blindweed
	[8845] = 175, -- Ghost Mushroom
	[8846] = 175, -- Gromsblood
	[13463] = 225, -- Dreamfoil
	[13464] = 225, -- Golden Sansam
	[13465] = 225, -- Mountain Silversage
	[13466] = 225, -- Sorrowmoss
	[13467] = 200, -- Icecap
	[22785] = 275, -- Felweed
	[22786] = 275, -- Dreaming Glory
	[22787] = 275, -- Ragveil
	[22789] = 275, -- Terocone
	[22790] = 275, -- Ancient Lichen
	[22791] = 275, -- Netherbloom
	[22792] = 275, -- Nightmare Vine
	[22793] = 275, -- Mana Thistle
	[36901] = 325, -- Goldclover
	[36903] = 325, -- Adder's Tongue
	[36904] = 325, -- Tiger Lily
	[36905] = 325, -- Lichbloom
	[36906] = 325, -- Icethorn
	[36907] = 325, -- Talandra's Rose
	[37921] = 325, -- Deadnettle
	[39970] = 325, -- Fire Leaf
	[52983] = 425, -- Cinderbloom
	[52984] = 425, -- Stormvine
	[52985] = 450, -- Azshara's Veil
	[52986] = 450, -- Heartblossom
	[52987] = 475, -- Twilight Jasmine
	[52988] = 475, -- Whiptail
	[72234] = 500, -- Green Tea Leaf
	[72235] = 500, -- Silkweed
	[72237] = 500, -- Rain Poppy
	[79010] = 500, -- Snow Lily
	[79011] = 500, -- Fool's Cap
	[89639] = 500, -- Desecrated Herb
	[109124] = 0, -- Frostweed
	[109125] = 0, -- Fireweed
	[109126] = 0, -- Gorgrond Flytrap
	[109127] = 0, -- Starflower
	[109128] = 0, -- Nagrand Arrowbloom
	[109129] = 0, -- Talador Orchid
	[109130] = 0, -- Chameleon Lotus
	[124101] = 0, -- Aethril
	[124102] = 0, -- Dreamleaf
	[124103] = 0, -- Foxflower
	[124104] = 0, -- Fjarnskaggl
	[124105] = 0, -- Starlight Rose
	[124106] = 0, -- Felwort
	[128304] = 0, -- Yseralline Seed
	[151565] = 0, -- Astral Glory
}

-- https://gist.github.com/p3lim/5c0363251db4a110017b
lib.ores = {
	[2770] = 1, -- Copper Ore
	[2771] = 50, -- Tin Ore
	[2772] = 125, -- Iron Ore
	[3858] = 175, -- Mithril Ore
	[10620] = 250, -- Thorium Ore
	[23424] = 275, -- Fel Iron Ore
	[23425] = 325, -- Adamantite Ore
	[36909] = 350, -- Cobalt Ore
	[36910] = 450, -- Titanium Ore
	[36912] = 400, -- Saronite Ore
	[52183] = 500, -- Pyrite Ore
	[52185] = 475, -- Elementium Ore
	[53038] = 425, -- Obsidium Ore
	[72092] = 500, -- Ghost Iron Ore
	[72093] = 550, -- Kyparite
	[72094] = 600, -- Black Trillium Ore
	[72103] = 600, -- White Trillium Ore
	[123918] = 0, -- Leystone Ore
	[123919] = 0, -- Felslate
	[151564] = 0, -- Empyrium
}

-- http://www.wowhead.com/items?filter=10:161:128;1:1:1;::
lib.containers = {
	[4632] = 1, -- Ornate Bronze Lockbox
	[6354] = 1, -- Small Locked Chest
	[16882] = 1, -- Battered Junkbox
	[4633] = 25, -- Heavy Bronze Lockbox
	[4634] = 70, -- Iron Lockbox
	[6355] = 70, -- Sturdy Locked Chest
	[16883] = 70, -- Worn Junkbox
	[4636] = 125, -- Strong Iron Lockbox
	[4637] = 175, -- Steel Lockbox
	[13875] = 175, -- Ironbound Locked Chest
	[16884] = 175, -- Sturdy Junkbox
	[4638] = 225, -- Reinforced Steel Lockbox
	[5758] = 225, -- Mithril Lockbox
	[5759] = 225, -- Thorium Lockbox
	[5760] = 225, -- Eternium Lockbox
	[13918] = 250, -- Reinforced Locked Chest
	[16885] = 250, -- Heavy Junkbox
	[12033] = 275, -- Thaurissan Family Jewels
	[29569] = 300, -- Strong Junkbox
	[31952] = 325, -- Khorium Lockbox
	[43575] = 350, -- Reinforced Junkbox
	[43622] = 375, -- Froststeel Lockbox
	[43624] = 400, -- Titanium Lockbox
	[45986] = 400, -- Tiny Titanium Lockbox
	[63349] = 400, -- Flame-Scarred Junkbox
	[68729] = 425, -- Elementium Lockbox
	[88567] = 450, -- Ghost Iron Lockbox
	[88165] = 450, -- Vine-Cracked Junkbox
	[106895] = 500, -- Iron-Bound Junkbox
	[116920] = 500, -- True Steel Lockbox
	[121331] = 550, -- Leystone Lockbox
}

lib.enchantingBuildings = {
	[93] = true,
	[125] = true,
	[126] = true,
}

lib.specialItems = {
	enchanting = {
		-- These items are used as part of the Legion enchanting quest line
		[137195] = 1, -- Highmountain Armor
		[137221] = 1, -- Enchanted Raven Sigil
		[137286] = 1, -- Fel-Crusted Rune
	}
}
