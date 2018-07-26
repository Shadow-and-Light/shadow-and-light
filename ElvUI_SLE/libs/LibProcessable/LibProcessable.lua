local MAJOR, MINOR = 'LibProcessable', 31
assert(LibStub, MAJOR .. ' requires LibStub')

local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

local professions = {}

--[[ LibProcessable:IsMillable(_item[, ignoreMortar]_)
Returns `true`/`false` wether the player can mill the given item, and `true`/`false` if using the [Draenic Mortar](http://www.wowhead.com/item=114942).

* `item`: item ID or link
* `ignoreMortar`: `true`/`false` if the [Draenic Mortar](http://www.wowhead.com/item=114942) should be ignored or not, if the player has one
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
		return itemID >= 109124 and itemID <= 109130, true
	end
end

--[[ LibProcessable:IsProspectable(_item_)
Returns `true`/`false` wether the player can prospect the given item.

**NB**: Outland and Pandaria ores have actual skill level requirements which this addon does not check for.
See [issue #14](https://github.com/p3lim-wow/LibProcessable/issues/14) for more information.

* `item`: item ID or link
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
Returns `true`/`false` wether the player can disenchant the given item.

**NB**: Many items that are not disenchantable will still return as `true`, as the amount of such
items and the volatility of that list is too much effort to keep up to date and accurate.

* `item`: item ID or link
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
				or (class == LE_ITEM_CLASS_GEM and subClass == 11)) -- artifact relics
		end
	end
end

-- http://www.wowhead.com/items/name:key?filter=86;2;0
local function GetSkeletonKey(pickLevel)
	if(pickLevel <= 25 and GetItemCount(15869) > 0) then
		return 15869, 590, 100 -- Silver Skeleton Key
	elseif(pickLevel <= 125 and GetItemCount(15870) > 0) then
		return 15870, 590, 150 -- Golden Skeleton Key
	elseif(pickLevel <= 200 and GetItemCount(15871) > 0) then
		return 15871, 590, 200 -- Truesilver Skeleton Key
	elseif(pickLevel <= 300 and GetItemCount(15872) > 0) then
		return 15872, 590, 275 -- Arcanite Skeleton Key
	elseif(pickLevel <= 375 and GetItemCount(43854) > 0) then
		return 43854, 577, 1 -- Cobalt Skeleton Key
	elseif(pickLevel <= 400 and GetItemCount(43853) > 0) then
		return 43853, 577, 55 -- Titanium Skeleton Key
	elseif(pickLevel <= 425 and GetItemCount(55053) > 0) then
		return 55053, 569, 25 -- Obsidium Skeleton Key
	elseif(pickLevel <= 450 and GetItemCount(82960) > 0) then
		return 82960, 553, 1 -- Ghostly Skeleton Key
	elseif(pickLevel <= 600 and GetItemCount(159826) > 0) then
		return 159826, 542, 1 -- Monelite Skeleton Key
	end
end

-- http://www.wowhead.com/items/name:lock?filter=86;7;0
local function GetJeweledLockpick(pickLevel)
	if(pickLevel <= 550 and GetItemCount(130250) > 0) then
		return 130250, 464, 1 -- Jeweled Lockpick
	end
end

--[[ LibProcessable:IsOpenable(_item_)
Returns `true`/`false` wether the player can open the given item with a class ability.

* `item`: item ID or link
--]]
function lib:IsOpenable(itemID)
	if(type(itemID) == 'string') then
		assert(string.match(itemID, 'item:(%d+):') or tonumber(itemID), 'item must be an item ID or item Link')
		itemID = (tonumber(itemID)) or (GetItemInfoFromHyperlink(itemID))
	end

	if(IsSpellKnown(1804)) then -- Pick Lock, Rogue ability
		local pickLevel = lib.containers[itemID]
		return pickLevel and pickLevel <= (UnitLevel('player') * 5)
	end
end

--[[ LibProcessable:IsOpenableProfession(_item_)
Returns `true`/`false` wether the player can open the given item with a profession, and the `itemID`
of the item used to open with, if any.

* `item`: item ID or link
--]]
function lib:IsOpenableProfession(itemID)
	assert(tonumber(itemID), 'itemID needs to be a number or convertable to a number')
	itemID = tonumber(itemID)

	local pickLevel = lib.containers[itemID]
	if(not pickLevel) then
		return false
	end

	if(self:HasProfession(164)) then -- Blacksmithing
		local itemID, categoryID, skillLevelRequired = GetSkeletonKey(pickLevel)
		if(itemID) then
			local skillLevel = GetProfessionSkill(164, categoryID)
			return skillLevel >= skillLevelRequired, 164, itemID
		end
	end

	if(self:HasProfession(755)) then
		local itemID, categoryID, skillLevelRequired = GetJeweledLockpick(pickLevel)
		if(itemID) then
			local skillLevel = GetProfessionSkill(755, categoryID)
			return skillLevel >= skillLevelRequired, 755, itemID
		end
	end
end

--[[ LibProcessable:HasProfession(_professionID_)
Returns `true`/`false` wether the player has the given profession.

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

* `professionID`: a profession's ID
--]]
function lib:HasProfession(professionID)
	return not not professions[professionID]
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('SKILL_LINES_CHANGED')
Handler:SetScript('OnEvent', function(self, event, ...)
	table.wipe(professions)

	local first, second = GetProfessions()
	if(first) then
		local _, _, _, _, _, _, professionID = GetProfessionInfo(first)
		professions[professionID] = true
	end

	if(second) then
		local _, _, _, _, _, _, professionID = GetProfessionInfo(second)
		professions[professionID] = true
	end
end)

--[[ LibProcessable.ores
Table of all ores that can be prospected by a jewelcrafter.

**NB:** Some items have specific profession skill requirements, thus the item's value is a table.

See [LibProcessable:IsProspectable()](LibProcessable#libprocessableisprospectableitem).
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
}

--[[ LibProcessable.herbs
Table of all herbs that can be milled by a scribe.

See [LibProcessable:IsMillable()](LibProcessable#libprocessableismillableitemignoremortar).
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
--]]
lib.containers = {
	-- http://www.wowhead.com/items?filter=10:161:128;1:1:1;::
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
