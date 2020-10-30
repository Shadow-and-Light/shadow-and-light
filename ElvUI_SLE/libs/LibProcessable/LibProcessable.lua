local MAJOR, MINOR = 'LibProcessable', 46
assert(LibStub, MAJOR .. ' requires LibStub')

local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

local CLASSIC = select(4, GetBuildInfo()) < 20000

local LE_ITEM_QUALITY_UNCOMMON = LE_ITEM_QUALITY_UNCOMMON or Enum.ItemQuality.Uncommon
local LE_ITEM_QUALITY_EPIC = LE_ITEM_QUALITY_EPIC or Enum.ItemQuality.Epic
local LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_ARMOR or 4
local LE_ITEM_CLASS_WEAPON = LE_ITEM_CLASS_WEAPON or 2
local LE_ITEM_CLASS_GEM = LE_ITEM_CLASS_GEM or 3
local LE_ITEM_SUBCLASS_ARTIFACT = 11 -- no existing constant for this one

local professions = {}
--[[ LibProcessable:IsMillable(_item[, ignoreMortar]_)
Returns whether the player can mill the given item.

**Arguments:**
* `item`: item ID or link
* `ignoreMortar`: whether the [Draenic Mortar](http://www.wowhead.com/item=114942) should be ignored or not _(boolean, optional)_

**Return values:**
* `isMillable`: Whether or not the player can mill the given item _(boolean)_
--]]
function lib:IsMillable(itemID, ignoreMortar)
	if(type(itemID) == 'string') then
		assert(string.match(itemID, 'item:(%d+):') or tonumber(itemID), 'item must be an item ID or item Link')
		itemID = (tonumber(itemID)) or (GetItemInfoFromHyperlink(itemID))
	end

	if(self:HasProfession(773)) then -- Inscription
		-- any herb can be milled at level 1
		return self.herbs[itemID]
	elseif(not ignoreMortar and GetItemCount(114942) > 0) then
		-- Draenic Mortar can mill Draenor herbs without a profession
		return itemID >= 109124 and itemID <= 109130, true
	end
end

--[[ LibProcessable:IsProspectable(_item_)
Returns whether the player can prospect the given item.

**Arguments:**
* `item`: item ID or link

**Return values:**
* `isProspectable`: Whether or not the player can prospect the given item _(boolean)_

**Notes**:
* This does not check if the player has the required skills to use the profession items
   * Only Outland and Pandaria ores have skill level requirements
--]]
function lib:IsProspectable(itemID)
	if(type(itemID) == 'string') then
		assert(string.match(itemID, 'item:(%d+):') or tonumber(itemID), 'item must be an item ID or item Link')
		itemID = (tonumber(itemID)) or (GetItemInfoFromHyperlink(itemID))
	end

	if(self:HasProfession(755)) then -- Jewelcrafting
		return not not self.ores[itemID]
	end
end

--[[ LibProcessable:IsDisenchantable(_item_)
Returns whether the player can disenchant the given item.

**Arguments:**
* `item`: item ID or link

**Return values:**
* `isDisenchantable`: Whether or not the player can disenchant the given item _(boolean)_

**Notes**:
* Many items that are not disenchantable will still return as `true`
   * These items are hard to keep track of since they're not flagged in any known database, and thus hard to keep track of
--]]
function lib:IsDisenchantable(item)
	local itemID = item
	if(type(itemID) == 'string') then
		assert(string.match(itemID, 'item:(%d+):') or tonumber(itemID), 'item must be an item ID or item Link')
		itemID = (tonumber(itemID)) or (GetItemInfoFromHyperlink(itemID))
	end

	if(self:HasProfession(333)) then -- Enchanting
		if(self.enchantingItems[itemID]) then
			-- special items that can be disenchanted
			return true
		else
			local _, _, quality, _, _, _, _, _, _, _, _, class, subClass = GetItemInfo(item)
			return (quality >= LE_ITEM_QUALITY_UNCOMMON and quality <= LE_ITEM_QUALITY_EPIC)
				and (class == LE_ITEM_CLASS_ARMOR or class == LE_ITEM_CLASS_WEAPON
				or (class == LE_ITEM_CLASS_GEM and subClass == LE_ITEM_SUBCLASS_ARTIFACT))
		end
	end
end

-- https://wowhead.com/items?filter=107:99;0:2;lockpick:0
local function GetBlacksmithingPick(pickLevel)
	if(CLASSIC) then
		if(pickLevel <= 25 and GetItemCount(15869) > 0) then
			return 15869, nil, 100 -- Silver Skeleton Key
		end
		if(pickLevel <= 125 and GetItemCount(15870) > 0) then
			return 15870, nil, 150 -- Golden Skeleton Key
		end
		if(pickLevel <= 200 and GetItemCount(15871) > 0) then
			return 15871, nil, 200 -- Truesilver Skeleton Key
		end
		if(pickLevel <= 300 and GetItemCount(15872) > 0) then
			return 15872, nil, 275 -- Arcanite Skeleton Key
		end
	else
		if(pickLevel <= 15 and GetItemCount(15869) > 0) then
			return 15869, 590, 100 -- Silver Skeleton Key
		end
		if(pickLevel <= 15 and GetItemCount(15870) > 0) then
			return 15870, 590, 150 -- Golden Skeleton Key
		end
		if(pickLevel <= 20 and GetItemCount(15871) > 0) then
			return 15871, 590, 200 -- Truesilver Skeleton Key
		end
		if(pickLevel <= 30 and GetItemCount(15872) > 0) then
			return 15872, 590, 275 -- Arcanite Skeleton Key
		end
		if(pickLevel <= 30 and GetItemCount(43854) > 0) then
			return 43854, 577, 1 -- Cobalt Skeleton Key
		end
		if(pickLevel <= 30 and GetItemCount(43853) > 0) then
			return 43853, 577, 55 -- Titanium Skeleton Key
		end
		if(pickLevel <= 35 and GetItemCount(55053) > 0) then
			return 55053, 569, 25 -- Obsidium Skeleton Key
		end
		if(pickLevel <= 35 and GetItemCount(82960) > 0) then
			return 82960, 553, 1 -- Ghostly Skeleton Key
		end
		if(pickLevel <= 50 and GetItemCount(159826) > 0) then
			return 159826, 542, 1 -- Monelite Skeleton Key
		end
		if(pickLevel <= 50 and GetItemCount(171441) > 0) then
			return 171441, 1311, 1 -- Laestrite Skeleton Key
		end
	end
end

-- https://wowhead.com/items?filter=107:99;0:7;lockpick:0
local function GetJewelcraftingPick(pickLevel)
	if(pickLevel <= 550 and GetItemCount(130250) > 0) then
		-- TODO: this item has not been updated for 9.0, so it has incorrect pick level
		return 130250, 464, 1 -- Jeweled Lockpick
	end
end

-- https://wowhead.com/items?filter=107:99;0:15;lockpick:0
local function GetInscriptionPick(pickLevel)
	if(pickLevel <= 50 and GetItemCount(159825) > 0) then
		return 159825, 759, 1 -- Scroll of Unlocking
	elseif(pickLevel <= 625 and GetItemCount(173065) > 0) then
		-- TODO: this item has not been updated for 9.0, so it has incorrect pick level
		return 173065, 1406, 1 -- Writ of Grave Robbing
	end
end

-- https://wowhead.com/items?filter=107:99;0:5;lockpick:0
local function GetEngineeringPick(pickLevel)
	if(pickLevel <= 35 and GetItemCount(60853) > 0) then
		return 60853, 715, 1 -- Volatile Seaforium Blastpack
	elseif(pickLevel <= 35 and GetItemCount(77532) > 0) then
		return 77532, 713, 1 -- Locksmith's Powderkeg
	end
end

--[[ LibProcessable:IsOpenable(_item_)
Returns whether the player can open the given item with a class/racial ability.

**Arguments:**
* `item`: item ID or link

**Return values:**
* `isOpenable`: Whether or not the player can open the given item _(boolean)_
* `spellID`:    SpellID of the spell that can be used to open the given item _(number)_
--]]
function lib:IsOpenable(itemID)
	if(type(itemID) == 'string') then
		assert(string.match(itemID, 'item:(%d+):') or tonumber(itemID), 'item must be an item ID or item Link')
		itemID = (tonumber(itemID)) or (GetItemInfoFromHyperlink(itemID))
	end

	local spellID = (IsSpellKnown(1804) and 1804) or -- Pick Lock, Rogue ability
	                (IsSpellKnown(312890) and 312890) -- Skeleton Pinkie, Mechagnome racial ability
	if(spellID) then
		local pickLevel = lib.containers[itemID]
		return pickLevel and pickLevel <= (UnitLevel('player') * (CLASSIC and 5 or 1)), spellID
	end
end

--[[ LibProcessable:IsOpenableProfession(_item_)
Returns the profession data if the given item can be opened by a profession item that the player
posesses.

**Arguments:**
* `item`: item ID or link

**Return values:**
* `skillRequired`:        The skill required in the profession category _(number)_
* `professionID`:         The profession ID _(number)_
* `professionCategoryID`: The profession category ID associated with the unlocking item _(number)_
* `professionItem`:       The itemID for the unlocking item _(number)_

**Notes:**
* The method will return `nil` instead of a category ID for Classic clients, as there are no profession categories there
* This does not check if the player has the required skills to use the profession items
--]]
function lib:IsOpenableProfession(itemID)
	if(type(itemID) == 'string') then
		assert(string.match(itemID, 'item:(%d+):') or tonumber(itemID), 'item must be an item ID or item Link')
		itemID = (tonumber(itemID)) or (GetItemInfoFromHyperlink(itemID))
	end

	local pickLevel = lib.containers[itemID]
	if(not pickLevel) then
		return
	end

	if(self:HasProfession(164)) then -- Blacksmithing
		local itemID, categoryID, skillLevelRequired = GetBlacksmithingPick(pickLevel)
		if(itemID) then
			return skillLevelRequired, 164, categoryID, itemID
		end
	end

	if(self:HasProfession(755)) then -- Jewelcrafting
		local itemID, categoryID, skillLevelRequired = GetJewelcraftingPick(pickLevel)
		if(itemID) then
			return skillLevelRequired, 755, categoryID, itemID
		end
	end

	if(self:HasProfession(773)) then -- Inscription
		local itemID, categoryID, skillLevelRequired = GetInscriptionPick(pickLevel)
		if(itemID) then
			return skillLevelRequired, 773, categoryID, itemID
		end
	end

	if(self:HasProfession(202)) then -- Engineering
		local itemID, categoryID, skillLevelRequired = GetEngineeringPick(pickLevel)
		if(itemID) then
			return skillLevelRequired, 202, categoryID, itemID
		end
	end
end

--[[ LibProcessable:HasProfession(_professionID_)
Returns whether the player has the given profession.

Here's a table with the profession ID for each profession.

| Profession Name | Profession ID |
|-----------------|:--------------|
| Alchemy         | 171           |
| Blacksmithing   | 164           |
| Enchanting      | 333           |
| Engineering     | 202           |
| Herbalism       | 182           |
| Inscription     | 773           |
| Jewelcrafting   | 755           |
| Leatherworking  | 165           |
| Mining          | 186           |
| Skinning        | 393           |
| Tailoring       | 197           |

**Arguments:**
* `professionID`: The profession ID

**Return values:**
* `hasProfession`: Whether or not the player has the profession _(boolean)_
--]]
function lib:HasProfession(professionID)
	return not not professions[professionID]
end

--[[ LibProcessable:GetProfessionCategories(_professionID_)
Returns data of all category IDs for a given (valid) profession, indexed by the expansion level index.

**Arguments:**
* `professionID`: The profession ID _(number)_

**Return values:**
* `categories`: Profession categories _(table)_
--]]
function lib:GetProfessionCategories(professionID)
	local professionCategories = lib.professionCategories[professionID]
	return professionCategories and CopyTable(professionCategories)
end

local classicIDs = {
	[(GetSpellInfo(2259))] = 171, -- Alchemy
	[(GetSpellInfo(2018))] = 164, -- Blacksmithing
	[(GetSpellInfo(7411))] = 333, -- Enchanting
	[(GetSpellInfo(4036))] = 202, -- Engineering
	[(GetSpellInfo(9134))] = 182, -- Herbalism (spell from gloves with +5 herbalism)
	[(GetSpellInfo(2108))] = 165, -- Leatherworking
	[(GetSpellInfo(2575))] = 186, -- Mining
	[(GetSpellInfo(8613))] = 393, -- Skinning
	[(GetSpellInfo(3908))] = 197, -- Tailoring
}

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('SKILL_LINES_CHANGED')
Handler:SetScript('OnEvent', function(self, event, ...)
	table.wipe(professions)

	if(CLASSIC) then
		-- all professions are spells in the first spellbook tab
		local _, _, offset, numSpells = GetSpellTabInfo(1)
		for index = offset + 1, offset + numSpells do
			-- iterate through all the spells to find the professions
			local professionID = classicIDs[(GetSpellBookItemName(index, BOOKTYPE_SPELL))]
			if(professionID) then
				professions[professionID] = true
			end
		end
	else
		local first, second = GetProfessions()
		if(first) then
			local _, _, _, _, _, _, professionID = GetProfessionInfo(first)
			professions[professionID] = true
		end

		if(second) then
			local _, _, _, _, _, _, professionID = GetProfessionInfo(second)
			professions[professionID] = true
		end
	end
end)

--[[ LibProcessable.ores
Table of all ores that can be prospected by a jewelcrafter.

See [LibProcessable:IsProspectable()](LibProcessable#libprocessableisprospectableitem).

**Notes**:
* Some items contains a table instead of a boolean
   * Outland and Pandaria ores have skill level requirements, the tables hold that information
--]]
lib.ores = {
	-- http://www.wowhead.com/spell=31252/prospecting#prospected-from:0+1+17-20
	[2770] = true, -- Copper Ore
	[2771] = true, -- Tin Ore
	[2772] = true, -- Iron Ore
	[3858] = true, -- Mithril Ore
	[10620] = true, -- Thorium Ore
	[23424] = {815, 1}, -- Fel Iron Ore
	[23425] = {815, 25}, -- Adamantite Ore
	[36909] = true, -- Cobalt Ore
	[36910] = true, -- Titanium Ore
	[36912] = true, -- Saronite Ore
	[52183] = true, -- Pyrite Ore
	[52185] = true, -- Elementium Ore
	[53038] = true, -- Obsidium Ore
	[72092] = {809, 1}, -- Ghost Iron Ore
	[72093] = {809, 25}, -- Kyparite
	[72094] = {809, 75}, -- Black Trillium Ore
	[72103] = {809, 75}, -- White Trillium Ore
	[123918] = true, -- Leystone Ore
	[123919] = true, -- Felslate
	[151564] = true, -- Empyrium
	[152579] = true, -- Storm Silver Ore
	[152512] = true, -- Monelite Ore
	[152513] = true, -- Platinum Ore
	[155830] = true, -- Runic Core, BfA Jewelcrafting Quest
	[168185] = true, -- Osmenite Ore
	[171828] = true, -- Laestrite
	[171829] = true, -- Solenium
	[171830] = true, -- Oxxein
	[171831] = true, -- Phaedrum
	[171832] = true, -- Sinvyr
	[171833] = true, -- Elethium
}

--[[ LibProcessable.herbs
Table of all herbs that can be milled by a scribe.

See [LibProcessable:IsMillable()](LibProcessable#libprocessableismillableitem-ignoremortar).
--]]
lib.herbs = {
	-- http://www.wowhead.com/spell=51005/milling#milled-from:0+1+17-20
	[765] = true, -- Silverleaf
	[785] = true, -- Mageroyal
	[2447] = true, -- Peacebloom
	[2449] = true, -- Earthroot
	[2450] = true, -- Briarthorn
	[2452] = true, -- Swiftthistle
	[2453] = true, -- Bruiseweed
	[3355] = true, -- Wild Steelbloom
	[3356] = true, -- Kingsblood
	[3357] = true, -- Liferoot
	[3358] = true, -- Khadgar's Whisker
	[3369] = true, -- Grave Moss
	[3818] = true, -- Fadeleaf
	[3819] = true, -- Dragon's Teeth
	[3820] = true, -- Stranglekelp
	[3821] = true, -- Goldthorn
	[4625] = true, -- Firebloom
	[8831] = true, -- Purple Lotus
	[8836] = true, -- Arthas' Tears
	[8838] = true, -- Sungrass
	[8839] = true, -- Blindweed
	[8845] = true, -- Ghost Mushroom
	[8846] = true, -- Gromsblood
	[13463] = true, -- Dreamfoil
	[13464] = true, -- Golden Sansam
	[13465] = true, -- Mountain Silversage
	[13466] = true, -- Sorrowmoss
	[13467] = true, -- Icecap
	[22785] = true, -- Felweed
	[22786] = true, -- Dreaming Glory
	[22787] = true, -- Ragveil
	[22789] = true, -- Terocone
	[22790] = true, -- Ancient Lichen
	[22791] = true, -- Netherbloom
	[22792] = true, -- Nightmare Vine
	[22793] = true, -- Mana Thistle
	[36901] = true, -- Goldclover
	[36903] = true, -- Adder's Tongue
	[36904] = true, -- Tiger Lily
	[36905] = true, -- Lichbloom
	[36906] = true, -- Icethorn
	[36907] = true, -- Talandra's Rose
	[37921] = true, -- Deadnettle
	[39969] = true, -- Fire Seed
	[39970] = true, -- Fire Leaf
	[52983] = true, -- Cinderbloom
	[52984] = true, -- Stormvine
	[52985] = true, -- Azshara's Veil
	[52986] = true, -- Heartblossom
	[52987] = true, -- Twilight Jasmine
	[52988] = true, -- Whiptail
	[72234] = true, -- Green Tea Leaf
	[72235] = true, -- Silkweed
	[72237] = true, -- Rain Poppy
	[79010] = true, -- Snow Lily
	[79011] = true, -- Fool's Cap
	[89639] = true, -- Desecrated Herb
	[109124] = true, -- Frostweed
	[109125] = true, -- Fireweed
	[109126] = true, -- Gorgrond Flytrap
	[109127] = true, -- Starflower
	[109128] = true, -- Nagrand Arrowbloom
	[109129] = true, -- Talador Orchid
	[124101] = true, -- Aethril
	[124102] = true, -- Dreamleaf
	[124103] = true, -- Foxflower
	[124104] = true, -- Fjarnskaggl
	[124105] = true, -- Starlight Rose
	[124106] = true, -- Felwort
	[128304] = true, -- Yseralline Seed
	[151565] = true, -- Astral Glory
	[152511] = true, -- Sea Stalk
	[152509] = true, -- Siren's Pollen
	[152508] = true, -- Winter's Kiss
	[152507] = true, -- Akunda's Bite
	[152506] = true, -- Star Moss
	[152505] = true, -- Riverbud
	[152510] = true, -- Anchor Weed
	[168487] = true, -- Zin'anthid
	[168583] = true, -- Widowbloom
	[168586] = true, -- Rising Glory
	[168589] = true, -- Marrowroot
	[169701] = true, -- Deathblossom
	[170554] = true, -- Vigil's Torch
	[171315] = true, -- Nightshade
}

--[[ LibProcessable.enchantingItems
Table of special items used as part of the Enchanting profession's quest line in the Legion expansion.

See [LibProcessable:IsDisenchantable()](LibProcessable#libprocessableisdisenchantableitem).
--]]
lib.enchantingItems = {
	-- These items are used as part of the Legion enchanting quest line
	[137195] = true, -- Highmountain Armor
	[137221] = true, -- Enchanted Raven Sigil
	[137286] = true, -- Fel-Crusted Rune
}

--[[ LibProcessable.containers
Table of all items that can be opened with a Rogue's _Pick Lock_ ability, or with profession keys.

The value is the required skill to open the item.

See [LibProcessable:IsOpenable()](LibProcessable#libprocessableisopenableitem) and
[LibProcessable:IsOpenableProfession()](LibProcessable#libprocessableisopenableprofessionitem).

**Notes**:
* This table has different content based on the game version (retail vs classic).
--]]
if(CLASSIC) then
	lib.containers = {
		-- https://classic.wowhead.com/items?filter=10:195;1:2;:0
		[4632]  = 1,    -- Ornate Bronze Lockbox
		[6354]  = 1,    -- Small Locked Chest
		[6712]  = 1,    -- Practice Lock
		[7209]  = 1,    -- Tazan's Satchel
		[16882] = 1,    -- Battered Junkbox
		[4633]  = 25,   -- Heavy Bronze Lockbox
		[4634]  = 70,   -- Iron Lockbox
		[5046]  = 70,   -- Locked Gift
		[6355]  = 70,   -- Sturdy Locked Chest
		[7869]  = 70,   -- Lucius's Lockbox
		[16883] = 70,   -- Worn Junkbox
		[4636]  = 125,  -- Strong Iron Lockbox
		[4637]  = 175,  -- Steel Lockbox
		[13875] = 175,  -- Ironbound Locked Chest
		[16884] = 175,  -- Sturdy Junkbox
		[4638]  = 225,  -- Reinforced Steel Lockbox
		[5758]  = 225,  -- Mithril Lockbox
		[5759]  = 225,  -- Thorium Lockbox
		[5760]  = 225,  -- Eternium Lockbox
		[13918] = 250,  -- Reinforced Locked Chest
		[16885] = 250,  -- Heavy Junkbox
		[12033] = 275,  -- Thaurissan Family Jewels
		[24282] = 5000, -- Rogue's Diary (lockpick requirement sourced from comments, unverified)
	}
else
	lib.containers = {
		-- https://www.wowhead.com/items?filter=10:195;1:2;:0
		[7209]   = 0,    -- Tazan's Satchel
		[4632]   = 15, -- Ornate Bronze Lockbox
		[4633]   = 15, -- Heavy Bronze Lockbox
		[4634]   = 15, -- Iron Lockbox
		[4636]   = 15, -- Strong Iron Lockbox
		[4637]   = 15, -- Steel Lockbox
		[4638]   = 15, -- Reinforced Steel Lockbox
		[5758]   = 15, -- Mithril Lockbox
		[5759]   = 15, -- Thorium Lockbox
		[5760]   = 15, -- Eternium Lockbox
		[6354]   = 15, -- Small Locked Chest
		[6355]   = 15, -- Sturdy Locked Chest
		[12033]  = 15, -- Thaurissan Family Jewels
		[13875]  = 15, -- Ironbound Locked Chest
		[13918]  = 15, -- Reinforced Locked Chest
		[16882]  = 15, -- Battered Junkbox
		[16883]  = 15, -- Worn Junkbox
		[16884]  = 15, -- Sturdy Junkbox
		[16885]  = 15, -- Heavy Junkbox
		[106895] = 15, -- Iron-Bound Junkbox
		[29569]  = 30, -- Strong Junkbox
		[31952]  = 30, -- Khorium Lockbox
		[43575]  = 30, -- Reinforced Junkbox
		[43622]  = 30, -- Froststeel Lockbox
		[43624]  = 30, -- Titanium Lockbox
		[63349]  = 30, -- Flame-Scarred Junkbox
		[68729]  = 30, -- Elementium Lockbox
		[106895] = 30, -- Tiny Titanium Lockbox
		[88165]  = 35, -- Vine-Cracked Junkbox
		[88567]  = 35, -- Ghost Iron Lockbox
		[116920] = 40, -- True Steel Lockbox
		[121331] = 45, -- Leystone Lockbox
		[169475] = 50, -- Barnacled Lockbox
		[179311] = 50, -- Venthyr Lockbox
		[180522] = 50, -- Night Fae Lockbox
		[180532] = 50, -- Maldraxxian Lockbox
		[180533] = 50, -- Kyrian Lockbox
	}
end

--[[ LibProcessable.professionCategories
Table of all professionIDs and their respective categories, indexed by expansion ID.

See [LibProcessable:GetProfessionCategories()](LibProcessable#libprocessablegetprofessioncategoriesprofessionid).
--]]
lib.professionCategories = {
	[171] = { -- Alchemy
		604, -- Classic
		602, -- Outland
		600, -- Northrend
		598, -- Cataclysm
		596, -- Pandaria
		332, -- Draenor
		433, -- Legion
		592, -- Zandalari/Kul Tiran
		1294, -- Shadowlands
	},
	[164] = { -- Blacksmithing
		590, -- Classic
		584, -- Outland
		577, -- Northrend
		569, -- Cataclysm
		553, -- Pandaria
		389, -- Draenor
		426, -- Legion
		542, -- Zandalari/Kul Tiran
		1311, -- Shadowlands
	},
	[333] = { -- Enchanting
		667, -- Classic
		665, -- Outland
		663, -- Northrend
		661, -- Cataclysm
		656, -- Pandaria
		348, -- Draenor
		443, -- Legion
		647, -- Zandalari/Kul Tiran
		1364, -- Shadowlands
	},
	[202] = { -- Engineering
		419, -- Classic
		719, -- Outland
		717, -- Northrend
		715, -- Cataclysm
		713, -- Pandaria
		347, -- Draenor
		469, -- Legion
		709, -- Zandalari/Kul Tiran
		1381, -- Shadowlands
	},
	[182] = { -- Herbalism
		1044, -- Classic
		1042, -- Outland
		1040, -- Northrend
		1038, -- Cataclysm
		1036, -- Pandaria
		1034, -- Draenor
		456, -- Legion
		1029, -- Zandalari/Kul Tiran
		1441, -- Shadowlands
	},
	[773] = { -- Inscription
		415, -- Classic
		769, -- Outland
		767, -- Northrend
		765, -- Cataclysm
		763, -- Pandaria
		410, -- Draenor
		450, -- Legion
		759, -- Zandalari/Kul Tiran
		1406, -- Shadowlands
	},
	[755] = { -- Jewelcrafting
		372, -- Classic
		815, -- Outland
		813, -- Northrend
		811, -- Cataclysm
		809, -- Pandaria
		373, -- Draenor
		464, -- Legion
		805, -- Zandalari/Kul Tiran
		1418, -- Shadowlands
	},
	[165] = { -- Leatherworking
		379, -- Classic
		882, -- Outland
		880, -- Northrend
		878, -- Cataclysm
		876, -- Pandaria
		380, -- Draenor
		460, -- Legion
		871, -- Zandalari/Kul Tiran
		1334, -- Shadowlands
	},
	[186] = { -- Mining
		1078, -- Classic
		1076, -- Outland
		1074, -- Northrend
		1072, -- Cataclysm
		1070, -- Pandaria
		1068, -- Draenor
		425, -- Legion
		1065, -- Zandalari/Kul Tiran
		1320, -- Shadowlands
	},
	[393] = { -- Skinning
		1060, -- Classic
		1058, -- Outland
		1056, -- Northrend
		1054, -- Cataclysm
		1042, -- Pandaria
		1050, -- Draenor
		459, -- Legion
		1046, -- Zandalari/Kul Tiran
		1331, -- Shadowlands
	},
	[197] = { -- Tailoring
		362, -- Classic
		956, -- Outland
		954, -- Northrend
		952, -- Cataclysm
		950, -- Pandaria
		369, -- Draenor
		430, -- Legion
		942, -- Zandalari/Kul Tiran
		1395, -- Shadowlands
	},
}
