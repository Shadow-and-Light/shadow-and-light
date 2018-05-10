--[[
Name: LibTourist-3.0
Revision: $Rev: 198 $
Author(s): Odica (maintainer), originally created by ckknight and Arrowmaster
Documentation: https://www.wowace.com/projects/libtourist-3-0/pages/api-reference
SVN: svn://svn.wowace.com/wow/libtourist-3-0/mainline/trunk
Description: A library to provide information about zones and instances.
License: MIT
]]

local MAJOR_VERSION = "LibTourist-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 198 $"):match("(%d+)"))

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end

local GetCurrentMapAreaID = C_Map.GetCurrentMapAreaID
local GetMapNameByID = C_Map.GetMapInfo

local Tourist, oldLib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not Tourist then
	return
end
if oldLib then
	oldLib = {}
	for k, v in pairs(Tourist) do
		Tourist[k] = nil
		oldLib[k] = v
	end
end

local function trace(msg)
--	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

-- Localization tables
local BZ = {}
local BZR = {}

local playerLevel = UnitLevel("player")
trace("INIT: Player Level = "..tostring(playerLevel))

local isAlliance, isHorde, isNeutral
do
	local faction = UnitFactionGroup("player")
	isAlliance = faction == "Alliance"
	isHorde = faction == "Horde"
	isNeutral = not isAlliance and not isHorde
end

local isWestern = GetLocale() == "enUS" or GetLocale() == "deDE" or GetLocale() == "frFR" or GetLocale() == "esES"

local Azeroth = "Azeroth"
local Kalimdor = "Kalimdor"
local Eastern_Kingdoms = "Eastern Kingdoms"
local Outland = "Outland"
local Northrend = "Northrend"
local The_Maelstrom = "The Maelstrom"
local Pandaria = "Pandaria"
local Draenor = "Draenor"
local BrokenIsles = "Broken Isles"
local Argus = "Argus"

local X_Y_ZEPPELIN = "%s - %s Zeppelin"
local X_Y_BOAT = "%s - %s Boat"
local X_Y_PORTAL = "%s - %s Portal"
local X_Y_TELEPORT = "%s - %s Teleport"


if GetLocale() == "zhCN" then
	X_Y_ZEPPELIN = "%s - %s 飞艇"
	X_Y_BOAT = "%s - %s 船"
	X_Y_PORTAL = "%s - %s 传送门"
	X_Y_TELEPORT = "%s - %s 传送门"
elseif GetLocale() == "zhTW" then
	X_Y_ZEPPELIN = "%s - %s 飛艇"
	X_Y_BOAT = "%s - %s 船"
	X_Y_PORTAL = "%s - %s 傳送門"
	X_Y_TELEPORT = "%s - %s 傳送門"
elseif GetLocale() == "frFR" then
	X_Y_ZEPPELIN = "Zeppelin %s - %s"
	X_Y_BOAT = "Bateau %s - %s"
	X_Y_PORTAL = "Portail %s - %s"
	X_Y_TELEPORT = "Téléport %s - %s"
elseif GetLocale() == "koKR" then
	X_Y_ZEPPELIN = "%s - %s 비행선"
	X_Y_BOAT = "%s - %s 배"
	X_Y_PORTAL = "%s - %s 차원문"
	X_Y_TELEPORT = "%s - %s 차원문"
end

local recZones = {}
local recInstances = {}
local lows = setmetatable({}, {__index = function() return 0 end})
local highs = setmetatable({}, getmetatable(lows))
local continents = {}
local instances = {}
local paths = {}
local types = {}
local groupSizes = {}
local groupMinSizes = {}
local groupMaxSizes = {}
local groupAltSizes = {}
local factions = {}
local yardWidths = {}
local yardHeights = {}
local yardXOffsets = {}
local yardYOffsets = {}
local continentScales = {}
local fishing = {}
local battlepet_lows = {}
local battlepet_highs = {}
local cost = {}
local textures = {}
local textures_rev = {}
local complexOfInstance = {}
local zoneComplexes = {}
local entrancePortals_zone = {}
local entrancePortals_x = {}
local entrancePortals_y = {}

local zoneIDtoContinentID = {}
local continentZoneToMapID = {}

local zoneMapIDs = {}
local zoneMapIDs_rev = {}

-- HELPER AND LOOKUP FUNCTIONS -------------------------------------------------------------

--local function UpdateCachedLegionZoneLevels()
--	-- Because the cache for highs and lows is initialized before the player level is known, update the values on PLAYER_LEVEL_UP
--	-- which fires directly after initialization. Is also assures the cache is being updated when the player levels up during play
--	local legionZoneLevel = Tourist:GetLegionZoneLevel()
--	for k in Tourist:IterateBrokenIsles() do
--		if types[k] ~= "Instance" and types[k] ~= "Battleground" and types[k] ~= "Arena" and types[k] ~= "Complex" and types[k] ~= "City" and types[k] ~= "Continent" then
--			-- Exception for Suramar and Broken Shore (which are fixed at lvl 110)
--			if k ~= BZ["Suramar"] and k ~= BZ["Broken Shore"] then
--				lows[k] = legionZoneLevel
--				highs[k] = legionZoneLevel
--				trace("Level for "..tostring(k).." is "..tostring(legionZoneLevel))
--			else
--				trace("Level for "..tostring(k).." is "..tostring(lows[k]).." (fixed)")
--			end
--		end
--	end
--end


local function PLAYER_LEVEL_UP(self, level)
	playerLevel = UnitLevel("player")
	trace("PLAYER_LEVEL_UP: Player Level = "..tostring(playerLevel))
	
	for k in pairs(recZones) do
		recZones[k] = nil
	end
	for k in pairs(recInstances) do
		recInstances[k] = nil
	end
	for k in pairs(cost) do
		cost[k] = nil
	end

--	UpdateCachedLegionZoneLevels()
	
	for zone in pairs(lows) do
		if not self:IsHostile(zone) then
			local low, high, scaled = self:GetLevel(zone)
			if scaled then
				low = scaled
				high = scaled
			end
			
			local zoneType = self:GetType(zone)
			if zoneType == "Zone" or zoneType == "PvP Zone" and low and high then
				if low <= playerLevel and playerLevel <= high then
					recZones[zone] = true
				end
			elseif zoneType == "Battleground" and low and high then
				local playerLevel = playerLevel
				if low <= playerLevel and playerLevel <= high then
					recInstances[zone] = true
				end
			elseif zoneType == "Instance" and low and high then
				if low <= playerLevel and playerLevel <= high then
					recInstances[zone] = true
				end
			end
		end
	end
end




-- Public alternative for GetMapContinents, removes the map IDs that were added to its output in WoW 6.0
function Tourist:GetMapContinentsAlt()
	local temp = { GetMapContinents() }

	if tonumber(temp[1]) then
		-- The first value is an ID instead of a name -> WoW 6.0 or later
		local continents = {}
		local index = 0
		for i = 2, #temp, 2 do
			index = index + 1
			continents[index] = temp[i]
--			trace( "C "..tostring(index).." = "..tostring(continents[index]) )
		end
		return continents
	else
		-- Backward compatibility for pre-WoW 6.0
		return temp
	end
end

-- Public Alternative for GetMapZones because GetMapZones does NOT return all zones (as of 6.0.2), 
-- making its output useless as input for for SetMapZoom. 
-- Thanks to Blackspirit (US) for this code.
-- NOTE: This method does not convert duplicate zone names for lookup in LibTourist,
-- use GetUniqueZoneNameForLookup for that.
local mapZonesByContinentID = {}
function Tourist:GetMapZonesAlt(continentID)
	if mapZonesByContinentID[continentID] then
		return mapZonesByContinentID[continentID]
	else
		-- Just in case GetMapZonesAltLocal has not been called yet:
		local zones = {}
		SetMapZoom(continentID)
		local continentAreaID = GetCurrentMapAreaID()
		for i=1, 100, 1 do 
			SetMapZoom(continentID, i) 
			local zoneAreaID = GetCurrentMapAreaID() 
			if zoneAreaID == continentAreaID then 
				-- If the index gets out of bounds, the continent map is returned -> exit the loop
				break 
			end 
			-- Get the localized zone name and store it
			zones[i] = GetMapNameByID(zoneAreaID)
		end
		-- Cache
		mapZonesByContinentID[continentID] = zones
		return zones
	end
end

-- Local version of GetMapZonesAlt, used during initialisation of LibTourist
local function GetMapZonesAltLocal(continentID)
	local zones = {}
	SetMapZoom(continentID)
	local continentAreaID = GetCurrentMapAreaID()
	for i=1, 100, 1 do 
		SetMapZoom(continentID, i) 
		local zoneAreaID = GetCurrentMapAreaID() 
		if zoneAreaID == continentAreaID then 
			-- If the index is out of bounds, the continent map is returned -> exit the loop
			break 
		end 
		-- Add area IDs to lookup tables
		zoneIDtoContinentID[zoneAreaID] = continentID
		if not continentZoneToMapID[continentID] then
			continentZoneToMapID[continentID] = {}
		end
		continentZoneToMapID[continentID][i] = zoneAreaID
		-- Get the localized zone name and store it
		zones[i] = GetMapNameByID(zoneAreaID)
	end
	-- Cache (for GetMapZonesAlt)
	mapZonesByContinentID[continentID] = zones
	return zones
end

-- Public alternative for GetMapNameByID, returns a unique localized zone name
-- to be used to lookup data in LibTourist
function Tourist:GetMapNameByIDAlt(zoneAreaID)
	local zoneName = GetMapNameByID(zoneAreaID)
	local continentID = zoneIDtoContinentID[zoneAreaID]
	return Tourist:GetUniqueZoneNameForLookup(zoneName, continentID)
end 


-- Returns a unique localized zone name to be used to lookup data in LibTourist,
-- based on a localized or English zone name
function Tourist:GetUniqueZoneNameForLookup(zoneName, continentID)
	if continentID == 5 then
		if zoneName == BZ["The Maelstrom"] or zoneName == "The Maelstrom" then
			zoneName = BZ["The Maelstrom"].." (zone)"
		end
	end
	if continentID == 7 then
		if zoneName == BZ["Nagrand"] or zoneName == "Nagrand"  then
			zoneName = BZ["Nagrand"].." ("..BZ["Draenor"]..")"
		end
		if zoneName == BZ["Shadowmoon Valley"] or zoneName == "Shadowmoon Valley"  then
			zoneName = BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"
		end
		if zoneName == BZ["Hellfire Citadel"] or zoneName == "Hellfire Citadel"  then
			zoneName = BZ["Hellfire Citadel"].." ("..BZ["Draenor"]..")"
		end
	end
	if continentID == 8 then
		if zoneName == BZ["Dalaran"] or zoneName == "Dalaran"  then
			zoneName = BZ["Dalaran"].." ("..BZ["Broken Isles"]..")"
		end
		if zoneName == BZ["The Violet Hold"] or zoneName == "The Violet Hold"  then
			zoneName = BZ["The Violet Hold"].." ("..BZ["Broken Isles"]..")"
		end
	end
	return zoneName
end

-- Returns a unique English zone name to be used to lookup data in LibTourist,
-- based on a localized or English zone name
function Tourist:GetUniqueEnglishZoneNameForLookup(zoneName, continentID)
	if continentID == 5 then
		if zoneName == BZ["The Maelstrom"] or zoneName == "The Maelstrom" then
			zoneName = "The Maelstrom (zone)"
		end
	end
	if continentID == 7 then
		if zoneName == BZ["Nagrand"] or zoneName == "Nagrand" then
			zoneName = "Nagrand (Draenor)"
		end
		if zoneName == BZ["Shadowmoon Valley"] or zoneName == "Shadowmoon Valley" then
			zoneName = "Shadowmoon Valley (Draenor)"
		end
		if zoneName == BZ["Hellfire Citadel"] or zoneName == "Hellfire Citadel" then
			zoneName = "Hellfire Citadel (Draenor)"
		end
	end
	if continentID == 8 then
		if zoneName == BZ["Dalaran"] or zoneName == "Dalaran" then
			zoneName = "Dalaran (Broken Isles)"
		end	
		if zoneName == BZ["The Violet Hold"] or zoneName == "The Violet Hold"  then
			zoneName = "The Violet Hold (Broken Isles)"
		end
	end
	return zoneName
end

-- Minimum fishing skill to fish these zones junk-free (Draenor: to catch Enormous Fish only)
function Tourist:GetFishingLevel(zone)
	return fishing[zone]
end

function Tourist:GetBattlePetLevel(zone)
	return battlepet_lows[zone], battlepet_highs[zone]
end

-- function has been replaced by GetScaledZoneLevel
-- WoW Legions: most zones scale to the player's level between 100 and 110
--function Tourist:GetLegionZoneLevel()
--	local playerLvl = playerLevel
--
--	if playerLvl <= 100 then 
--		return 100
--	elseif playerLvl >= 110 then
--		return 110
--	else
--		return playerLvl
--	end
--end

-- WoW patch 7.3.5: most zones now scale - within their level range - to the player's level
function Tourist:GetScaledZoneLevel(zone)
	local playerLvl = playerLevel

	if playerLvl <= lows[zone] then 
		return lows[zone]
	elseif playerLvl >= highs[zone] then
		return highs[zone]
	else
		return playerLvl
	end
end

function Tourist:GetLevelString(zone)
	local lo, hi, scaled = Tourist:GetLevel(zone)
	
	if lo and hi then
		if scaled then
			if lo == hi then
				return tostring(scaled).." ("..tostring(lo)..")"
			else
				return tostring(scaled).." ("..tostring(lo).."-"..tostring(hi)..")"
			end
		else	
			if lo == hi then
				return tostring(lo)
			else
				return tostring(lo).."-"..tostring(hi)
			end
		end
	else
		return tostring(lo) or tostring(hi) or ""
	end
end

function Tourist:GetBattlePetLevelString(zone)
	local lo, hi = Tourist:GetBattlePetLevel(zone)
	if lo and hi then
		if lo == hi then
			return tostring(lo)
		else
			return tostring(lo).."-"..tostring(hi)
		end
	else
		return tostring(lo) or tostring(hi) or ""
	end
end

function Tourist:GetLevel(zone)

	if types[zone] == "Battleground" then
		-- Note: Not all BG's start at level 10, but all BG's support players up to MAX_PLAYER_LEVEL.

		local playerLvl = playerLevel
		if playerLvl <= lows[zone] then
			-- Player is too low level to enter the BG -> return the lowest available bracket
			-- by assuming the player is at the min level required for the BG.
			playerLvl = lows[zone]
		end

		-- Find the most suitable bracket
		if playerLvl >= MAX_PLAYER_LEVEL then
			return MAX_PLAYER_LEVEL, MAX_PLAYER_LEVEL, nil
		elseif playerLvl >= 105 then
			return 105, 109, nil
		elseif playerLvl >= 100 then
			return 100, 104, nil			
		elseif playerLvl >= 95 then
			return 95, 99, nil
		elseif playerLvl >= 90 then
			return 90, 94, nil
		elseif playerLvl >= 85 then
			return 85, 89, nil
		elseif playerLvl >= 80 then
			return 80, 84, nil
		elseif playerLvl >= 75 then
			return 75, 79, nil
		elseif playerLvl >= 70 then
			return 70, 74, nil
		elseif playerLvl >= 65 then
			return 65, 69, nil
		elseif playerLvl >= 60 then
			return 60, 64, nil
		elseif playerLvl >= 55 then
			return 55, 59, nil
		elseif playerLvl >= 50 then
			return 50, 54, nil
		elseif playerLvl >= 45 then
			return 45, 49, nil
		elseif playerLvl >= 40 then
			return 40, 44, nil
		elseif playerLvl >= 35 then
			return 35, 39, nil
		elseif playerLvl >= 30 then
			return 30, 34, nil
		elseif playerLvl >= 25 then
			return 25, 29, nil
		elseif playerLvl >= 20 then
			return 20, 24, nil
		elseif playerLvl >= 15 then
			return 15, 19, nil
		else
			return 10, 14, nil
		end
	else
		if types[zone] ~= "Arena" and types[zone] ~= "Complex" and types[zone] ~= "City" and types[zone] ~= "Continent" then
			-- Zones and Instances (scaling):
			return lows[zone], highs[zone], Tourist:GetScaledZoneLevel(zone)
		else
			-- Other zones
			return lows[zone], highs[zone], nil
		end
	end
end

function Tourist:GetBattlePetLevelColor(zone, petLevel)
	local low, high = self:GetBattlePetLevel(zone)
	
	return Tourist:CalculateLevelColor(low, high, petLevel)
end


function Tourist:GetLevelColor(zone)
	local low, high, scaled = self:GetLevel(zone)

	if types[zone] == "Battleground" then
		if playerLevel < low then
			-- player cannot enter the lowest bracket of the BG -> red
			return 1, 0, 0
		end
	end
	
	if scaled then
		return Tourist:CalculateLevelColor(scaled, scaled, playerLevel)
	else
		return Tourist:CalculateLevelColor(low, high, playerLevel)
	end
end
	
	
function Tourist:CalculateLevelColor(low, high, currentLevel)
	local midBracket = (low + high) / 2

	if low <= 0 and high <= 0 then
		-- City or level unknown -> White
		return 1, 1, 1
	elseif currentLevel == low and currentLevel == high then
		-- Exact match, one-level bracket -> Yellow
		return 1, 1, 0
	elseif currentLevel <= low - 3 then
		-- Player is three or more levels short of Low -> Red
		return 1, 0, 0
	elseif currentLevel < low then
		-- Player is two or less levels short of Low -> sliding scale between Red and Orange
		-- Green component goes from 0 to 0.5
		local greenComponent = (currentLevel - low + 3) / 6
		return 1, greenComponent, 0
	elseif currentLevel == low then
		-- Player is at low, at least two-level bracket -> Orange
		return 1, 0.5, 0
	elseif currentLevel < midBracket then
		-- Player is between low and the middle of the bracket -> sliding scale between Orange and Yellow
		-- Green component goes from 0.5 to 1
		local halfBracketSize = (high - low) / 2
		local posInBracketHalf = currentLevel - low
		local greenComponent = 0.5 + (posInBracketHalf / halfBracketSize) * 0.5
		return 1, greenComponent, 0
	elseif currentLevel == midBracket then
		-- Player is at the middle of the bracket -> Yellow
		return 1, 1, 0
	elseif currentLevel < high then
		-- Player is between the middle of the bracket and High -> sliding scale between Yellow and Green
		-- Red component goes from 1 to 0
		local halfBracketSize = (high - low) / 2
		local posInBracketHalf = currentLevel - midBracket
		local redComponent = 1 - (posInBracketHalf / halfBracketSize)
		return redComponent, 1, 0
	elseif currentLevel == high then
		-- Player is at High, at least two-level bracket -> Green
		return 0, 1, 0
	elseif currentLevel < high + 3 then
		-- Player is up to three levels above High -> sliding scale between Green and Gray
		-- Red and Blue components go from 0 to 0.5
		-- Green component goes from 1 to 0.5
		local pos = (currentLevel - high) / 3
		local redAndBlueComponent = pos * 0.5
		local greenComponent = 1 - redAndBlueComponent
		return redAndBlueComponent, greenComponent, redAndBlueComponent
	else
		-- Player is at High + 3 or above -> Gray
		return 0.5, 0.5, 0.5
	end
end

function Tourist:GetFactionColor(zone)
	if factions[zone] == "Sanctuary" then
		-- Blue
		return 0.41, 0.8, 0.94
	elseif self:IsPvPZone(zone) then
		-- Orange
		return 1, 0.7, 0
	elseif factions[zone] == (isHorde and "Alliance" or "Horde") then
		-- Red
		return 1, 0, 0
	elseif factions[zone] == (isHorde and "Horde" or "Alliance") then
		-- Green
		return 0, 1, 0
	else
		-- Yellow
		return 1, 1, 0
	end
end

function Tourist:GetZoneYardSize(zone)
	return yardWidths[zone], yardHeights[zone]
end

function Tourist:GetZoneYardOffset(zone)
	return yardXOffsets[zone], yardYOffsets[zone]
end


-- This function is used to calculate the distance in yards between two sets of coordinates
-- Zone can be a continent or Azeroth
function Tourist:GetYardDistance(zone1, x1, y1, zone2, x2, y2)
	local zone1_continent = continents[zone1]
	local zone2_continent = continents[zone2]
	
	if not zone1_continent or not zone2_continent then
		-- Unknown zone
		return nil
	end
	if (zone1_continent == Outland) ~= (zone2_continent == Outland) then
		-- Cannot calculate distances from or to outside Outland
		return nil
	end
	if (zone1_continent == The_Maelstrom or zone2_continent == The_Maelstrom) and (zone1 ~= zone2) then
		-- Cannot calculate distances from or to outside The Maelstrom
		-- In addition, in The Maelstrom only distances within a single zone can be calculated
		-- as the zones are not geographically related to each other
		return nil
	end
	if (zone1_continent == Draenor) ~= (zone2_continent == Draenor) then
		-- Cannot calculate distances from or to outside Draenor
		return nil
	end
	
	-- Get the zone sizes in yards
	local zone1_yardWidth = yardWidths[zone1]
	local zone1_yardHeight = yardHeights[zone1]
	local zone2_yardWidth = yardWidths[zone2]
	local zone2_yardHeight = yardHeights[zone2]
	if not zone1_yardWidth or not zone2_yardWidth or zone1_yardWidth == 0 or zone2_yardWidth == 0 then
		-- Need zone sizes to continue
		return nil
	end

	-- Convert position coordinates (a value between 0 and 1) to yards, measured from the top and the left of the map
	local x1_yard = zone1_yardWidth * x1
	local y1_yard = zone1_yardHeight * y1
	local x2_yard = zone2_yardWidth * x2
	local y2_yard = zone2_yardHeight * y2

	if zone1 ~= zone2 then
		-- The two locations are not within the same zone. Get the zone offsets (their position at the continent map), which
		-- are also measured from the top and the left of the map
		local zone1_yardXOffset = yardXOffsets[zone1]
		local zone1_yardYOffset = yardYOffsets[zone1]
		local zone2_yardXOffset = yardXOffsets[zone2]
		local zone2_yardYOffset = yardYOffsets[zone2]	
	
		-- Don't apply zone offsets if a zone is a continent (this includes Azeroth)
		if zone1 == zone1_continent then
			zone1_yardXOffset = 0
			zone1_yardYOffset = 0
		end
		if zone2 == zone2_continent then
			zone2_yardXOffset = 0
			zone2_yardYOffset = 0
		end
	
		if not zone1_yardXOffset or not zone1_yardYOffset or not zone2_yardXOffset or not zone2_yardYOffset then
			-- Need all offsets to continue
			return nil
		end

		-- Calculate the positions on the continent map, in yards
		x1_yard = x1_yard + zone1_yardXOffset
		y1_yard = y1_yard + zone1_yardYOffset

		x2_yard = x2_yard + zone2_yardXOffset
		y2_yard = y2_yard + zone2_yardYOffset

		if zone1_continent ~= zone2_continent then
			-- The two locations are not on the same continent
			-- Possible continents here are the Azeroth continents, except The Maelstrom.
			local cont1_scale = continentScales[zone1_continent]
			local cont1_XOffset = yardXOffsets[zone1_continent]
			local cont1_YOffset = yardYOffsets[zone1_continent]
			local cont2_scale = continentScales[zone2_continent]
			local cont2_XOffset = yardXOffsets[zone2_continent]
			local cont2_YOffset = yardYOffsets[zone2_continent]
			
			-- Calculate x and y on the Azeroth map, expressed in Azeroth yards
			if zone1 ~= Azeroth then
				x1_yard = (x1_yard * cont1_scale) + cont1_XOffset
				y1_yard = (y1_yard * cont1_scale) + cont1_YOffset
			end
			if zone2 ~= Azeroth then
				x2_yard = (x2_yard * cont2_scale) + cont2_XOffset
				y2_yard = (y2_yard * cont2_scale) + cont2_YOffset
			end
			
			-- Calculate distance, in Azeroth yards
			local x_diff = x1_yard - x2_yard
			local y_diff = y1_yard - y2_yard
			local distAz = x_diff*x_diff + y_diff*y_diff
			
			if zone1 ~= Azeroth then
				-- Correct the distance for the source continent scale
				return (distAz^0.5) / cont1_scale
			else
				return (distAz^0.5)
			end
		end
	end

	-- x and y for both locations are now at the same map level (a zone or a continent) -> calculate distance
	local x_diff = x1_yard - x2_yard
	local y_diff = y1_yard - y2_yard
	local dist_2 = x_diff*x_diff + y_diff*y_diff
	return dist_2^0.5
end

-- This function is used to calculate the coordinates of a location in zone1, on the map of zone2.
-- Zone can be a continent or Azeroth
function Tourist:TransposeZoneCoordinate(x, y, zone1, zone2)
--	trace("TZC: z1 = "..tostring(zone1)..", z2 = "..tostring(zone2))

	if zone1 == zone2 then
		-- Nothing to do
		return x, y
	end

	local zone1_continent = continents[zone1]
	local zone2_continent = continents[zone2]
	if not zone1_continent or not zone2_continent then
		-- Unknown zone
		return nil
	end
	if (zone1_continent == Outland) ~= (zone2_continent == Outland) then
		-- Cannot transpose from or to outside Outland
		return nil
	end
	if (zone1_continent == The_Maelstrom or zone2_continent == The_Maelstrom) then
		-- Cannot transpose from, to or within The Maelstrom
		return nil
	end
	if (zone1_continent == Draenor) ~= (zone2_continent == Draenor) then
		-- Cannot transpose from or to outside Draenor
		return nil
	end
	
	-- Get the zone sizes in yards
	local zone1_yardWidth = yardWidths[zone1]
	local zone1_yardHeight = yardHeights[zone1]
	local zone2_yardWidth = yardWidths[zone2]
	local zone2_yardHeight = yardHeights[zone2]
	if not zone1_yardWidth or not zone2_yardWidth or zone1_yardWidth == 0 or zone2_yardWidth == 0 then
		-- Need zone sizes to continue
		return nil
	end
	
	-- Get zone offsets
	local zone1_yardXOffset = yardXOffsets[zone1]
	local zone1_yardYOffset = yardYOffsets[zone1]
	local zone2_yardXOffset = yardXOffsets[zone2]
	local zone2_yardYOffset = yardYOffsets[zone2]	
	if not zone1_yardXOffset or not zone1_yardYOffset or not zone2_yardXOffset or not zone2_yardYOffset then
		-- Need all offsets to continue
		return nil
	end
	
	-- Don't apply zone offsets if a zone is a continent (this includes Azeroth)
	if zone1 == zone1_continent then
		zone1_yardXOffset = 0
		zone1_yardYOffset = 0
	end
	if zone2 == zone2_continent then
		zone2_yardXOffset = 0
		zone2_yardYOffset = 0
	end

	-- Convert source coordinates (a value between 0 and 1) to yards, measured from the top and the left of the map
	local x_yard = zone1_yardWidth * x
	local y_yard = zone1_yardHeight * y

	-- Calculate the positions on the continent map, in yards
	x_yard = x_yard + zone1_yardXOffset
	y_yard = y_yard + zone1_yardYOffset

	if zone1_continent ~= zone2_continent then
		-- Target zone is not on the same continent
		-- Possible continents here are the Azeroth continents, except The Maelstrom.
		local cont1_scale = continentScales[zone1_continent]
		local cont1_XOffset = yardXOffsets[zone1_continent]
		local cont1_YOffset = yardYOffsets[zone1_continent]
		local cont2_scale = continentScales[zone2_continent]
		local cont2_XOffset = yardXOffsets[zone2_continent]
		local cont2_YOffset = yardYOffsets[zone2_continent]

		if zone1 ~= Azeroth then
			-- Translate the coordinate from the source continent to Azeroth
			x_yard = (x_yard * cont1_scale) + cont1_XOffset
			y_yard = (y_yard * cont1_scale) + cont1_YOffset
		end
			
		if zone2 ~= Azeroth then
			-- Translate the coordinate from Azeroth to the target continent
			x_yard = (x_yard - cont2_XOffset) / cont2_scale
			y_yard = (y_yard - cont2_YOffset) / cont2_scale
		end
	end

	-- 'Move' (transpose) the coordinates to the target zone
	x_yard = x_yard - zone2_yardXOffset
	y_yard = y_yard - zone2_yardYOffset

	-- Convert yards back to coordinates
	x = x_yard / zone2_yardWidth
	y = y_yard / zone2_yardHeight

	return x, y
end

local zonesToIterate = setmetatable({}, {__index = function(self, key)
	local t = {}
	self[key] = t
	for k,v in pairs(continents) do
		if v == key and v ~= k and yardXOffsets[k] then
			t[#t+1] = k
		end
	end
	return t
end})


-- This function is used to find the actual zone a player is in, including coordinates for that zone, if the current map 
-- is a map that contains the player position, but is not the map of the zone where the player really is.
-- x, y = player position on current map
-- zone = the zone of the current map
function Tourist:GetBestZoneCoordinate(x, y, zone)
	-- This only works properly if we have a player position and the current map zone is not a continent or so
	if not x or not y or not zone or x ==0 or y == 0 or Tourist:IsContinent(zone) then
		return x, y, zone
	end

	-- Get current map zone data
	local zone_continent = continents[zone]
	local zone_yardXOffset = yardXOffsets[zone]
	local zone_yardYOffset = yardYOffsets[zone]
	local zone_yardWidth = yardWidths[zone]
	local zone_yardHeight = yardHeights[zone]
	if not zone_yardXOffset or not zone_yardYOffset or not zone_yardWidth or not zone_yardHeight then
		-- Need all offsets to continue
		return x, y, zone
	end

	-- Convert coordinates to offsets in yards (within the zone)
	local x_yard = zone_yardWidth * x
	local y_yard = zone_yardHeight * y

	-- Translate the location to a location on the continent map
	x_yard = x_yard + zone_yardXOffset
	y_yard = y_yard + zone_yardYOffset
	
	local best_zone, best_x, best_y, best_value

	-- Loop through all zones on the continent...
	for _,z in ipairs(zonesToIterate[zone_continent]) do
		local z_yardXOffset = yardXOffsets[z]
		local z_yardYOffset = yardYOffsets[z]
		local z_yardWidth = yardWidths[z]
		local z_yardHeight = yardHeights[z]

		-- Translate the coordinates to the zone
		local x_yd = x_yard - z_yardXOffset
		local y_yd = y_yard - z_yardYOffset

		if x_yd >= 0 and y_yd >= 0 and x_yd <= z_yardWidth and y_yd <= z_yardHeight then
			-- Coordinates are within the probed zone
			if types[z] == "City" then
				-- City has no adjacent zones -> done
				return x_yd/z_yardWidth, y_yd/z_yardHeight, z
			end
			-- Calculate the midpoint of the zone map
			local x_tmp = x_yd - z_yardWidth / 2
			local y_tmp = y_yd - z_yardHeight / 2
			-- Calculate the distance (sort of, no need to sqrt)
			local value = x_tmp*x_tmp + y_tmp*y_tmp
			if not best_value or value < best_value then
				-- Lowest distance wins (= closest to map center)
				best_zone = z
				best_value = value
				best_x = x_yd/z_yardWidth
				best_y = y_yd/z_yardHeight
			end
		end
	end
	
	if not best_zone then
		-- No best zone found -> best map is the continent map
		return x_yard / yardWidths[zone_continent], y_yard / yardHeights[zone_continent], zone_continent
	end
	
	return best_x, best_y, best_zone
end


local function retNil() 
	return nil 
end
	
local function retOne(object, state)
	if state == object then
		return nil
	else
		return object
	end
end

local function retNormal(t, position)
	return (next(t, position))
end

local function round(num, digits)
	-- banker's rounding
	local mantissa = 10^digits
	local norm = num*mantissa
	norm = norm + 0.5
	local norm_f = math.floor(norm)
	if norm == norm_f and (norm_f % 2) ~= 0 then
		return (norm_f-1)/mantissa
	end
	return norm_f/mantissa
end

local function mysort(a,b)
	if not lows[a] then
		return false
	elseif not lows[b] then
		return true
	else
		local aval, bval = groupSizes[a] or groupMaxSizes[a], groupSizes[b] or groupMaxSizes[b]
		if aval and bval then
			if aval ~= bval then
				return aval < bval
			end
		end
		aval, bval = lows[a], lows[b]
		if aval ~= bval then
			return aval < bval
		end
		aval, bval = highs[a], highs[b]
		if aval ~= bval then
			return aval < bval
		end
		return a < b
	end
end
local t = {}
local function myiter(t)
	local n = t.n
	n = n + 1
	local v = t[n]
	if v then
		t[n] = nil
		t.n = n
		return v
	else
		t.n = nil
	end
end
function Tourist:IterateZoneInstances(zone)
	local inst = instances[zone]

	if not inst then
		return retNil
	elseif type(inst) == "table" then
		for k in pairs(t) do
			t[k] = nil
		end
		for k in pairs(inst) do
			t[#t+1] = k
		end
		table.sort(t, mysort)
		t.n = 0
		return myiter, t, nil
	else
		return retOne, inst, nil
	end
end

function Tourist:IterateZoneComplexes(zone)
	local compl = zoneComplexes[zone]

	if not compl then
		return retNil
	elseif type(compl) == "table" then
		for k in pairs(t) do
			t[k] = nil
		end
		for k in pairs(compl) do
			t[#t+1] = k
		end
		table.sort(t, mysort)
		t.n = 0
		return myiter, t, nil
	else
		return retOne, compl, nil
	end
end

function Tourist:GetInstanceZone(instance)
	for k, v in pairs(instances) do
		if v then
			if type(v) == "string" then
				if v == instance then
					return k
				end
			else -- table
				for l in pairs(v) do
					if l == instance then
						return k
					end
				end
			end
		end
	end
end

function Tourist:GetComplexZone(complex)
	for k, v in pairs(zoneComplexes) do
		if v then
			if type(v) == "string" then
				if v == complex then
					return k
				end
			else -- table
				for l in pairs(v) do
					if l == complex then
						return k
					end
				end
			end
		end
	end
end

function Tourist:DoesZoneHaveInstances(zone)
	return not not instances[zone]
end

function Tourist:DoesZoneHaveComplexes(zone)
	return not not zoneComplexes[zone]
end

local zonesInstances
local function initZonesInstances()
	if not zonesInstances then
		zonesInstances = {}
		for zone, v in pairs(lows) do
			if types[zone] ~= "Transport" then
				zonesInstances[zone] = true
			end
		end
	end
	initZonesInstances = nil
end

function Tourist:IterateZonesAndInstances()
	if initZonesInstances then
		initZonesInstances()
	end
	return retNormal, zonesInstances, nil
end

local function zoneIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and (types[k] == "Instance" or types[k] == "Battleground" or types[k] == "Arena" or types[k] == "Complex") do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateZones()
	if initZonesInstances then
		initZonesInstances()
	end
	return zoneIter, nil, nil
end

local function instanceIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and (types[k] ~= "Instance" and types[k] ~= "Battleground" and types[k] ~= "Arena") do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateInstances()
	if initZonesInstances then
		initZonesInstances()
	end
	return instanceIter, nil, nil
end

local function bgIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "Battleground" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateBattlegrounds()
	if initZonesInstances then
		initZonesInstances()
	end
	return bgIter, nil, nil
end

local function arIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "Arena" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateArenas()
	if initZonesInstances then
		initZonesInstances()
	end
	return arIter, nil, nil
end

local function compIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "Complex" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateComplexes()
	if initZonesInstances then
		initZonesInstances()
	end
	return compIter, nil, nil
end

local function pvpIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "PvP Zone" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IteratePvPZones()
	if initZonesInstances then
		initZonesInstances()
	end
	return pvpIter, nil, nil
end

local function allianceIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] ~= "Alliance" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateAlliance()
	if initZonesInstances then
		initZonesInstances()
	end
	return allianceIter, nil, nil
end

local function hordeIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] ~= "Horde" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateHorde()
	if initZonesInstances then
		initZonesInstances()
	end
	return hordeIter, nil, nil
end

if isHorde then
	Tourist.IterateFriendly = Tourist.IterateHorde
	Tourist.IterateHostile = Tourist.IterateAlliance
else
	Tourist.IterateFriendly = Tourist.IterateAlliance
	Tourist.IterateHostile = Tourist.IterateHorde
end

local function sanctIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] ~= "Sanctuary" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateSanctuaries()
	if initZonesInstances then
		initZonesInstances()
	end
	return sanctIter, nil, nil
end

local function contestedIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateContested()
	if initZonesInstances then
		initZonesInstances()
	end
	return contestedIter, nil, nil
end

local function kalimdorIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Kalimdor do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateKalimdor()
	if initZonesInstances then
		initZonesInstances()
	end
	return kalimdorIter, nil, nil
end

local function easternKingdomsIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Eastern_Kingdoms do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateEasternKingdoms()
	if initZonesInstances then
		initZonesInstances()
	end
	return easternKingdomsIter, nil, nil
end

local function outlandIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Outland do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateOutland()
	if initZonesInstances then
		initZonesInstances()
	end
	return outlandIter, nil, nil
end

local function northrendIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Northrend do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateNorthrend()
	if initZonesInstances then
		initZonesInstances()
	end
	return northrendIter, nil, nil
end

local function theMaelstromIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= The_Maelstrom do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateTheMaelstrom()
	if initZonesInstances then
		initZonesInstances()
	end
	return theMaelstromIter, nil, nil
end

local function pandariaIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Pandaria do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IteratePandaria()
	if initZonesInstances then
		initZonesInstances()
	end
	return pandariaIter, nil, nil
end


local function draenorIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Draenor do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateDraenor()
	if initZonesInstances then
		initZonesInstances()
	end
	return draenorIter, nil, nil
end


local function brokenislesIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= BrokenIsles do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateBrokenIsles()
	if initZonesInstances then
		initZonesInstances()
	end
	return brokenislesIter, nil, nil
end


function Tourist:IterateRecommendedZones()
	return retNormal, recZones, nil
end

function Tourist:IterateRecommendedInstances()
	return retNormal, recInstances, nil
end

function Tourist:HasRecommendedInstances()
	return next(recInstances) ~= nil
end

function Tourist:IsInstance(zone)
	local t = types[zone]
	return t == "Instance" or t == "Battleground" or t == "Arena"
end

function Tourist:IsZone(zone)
	local t = types[zone]
	return t and t ~= "Instance" and t ~= "Battleground" and t ~= "Transport" and t ~= "Arena" and t ~= "Complex"
end

function Tourist:IsContinent(zone)
	local t = types[zone]
	return t == "Continent"
end

function Tourist:GetComplex(zone)
	return complexOfInstance[zone]
end

function Tourist:GetType(zone)
	return types[zone] or "Zone"
end

function Tourist:IsZoneOrInstance(zone)
	local t = types[zone]
	return t and t ~= "Transport"
end

function Tourist:IsTransport(zone)
	local t = types[zone]
	return t == "Transport"
end

function Tourist:IsComplex(zone)
	local t = types[zone]
	return t == "Complex"
end

function Tourist:IsBattleground(zone)
	local t = types[zone]
	return t == "Battleground"
end

function Tourist:IsArena(zone)
	local t = types[zone]
	return t == "Arena"
end

function Tourist:IsPvPZone(zone)
	local t = types[zone]
	return t == "PvP Zone"
end

function Tourist:IsCity(zone)
	local t = types[zone]
	return t == "City"
end

function Tourist:IsAlliance(zone)
	return factions[zone] == "Alliance"
end

function Tourist:IsHorde(zone)
	return factions[zone] == "Horde"
end

if isHorde then
	Tourist.IsFriendly = Tourist.IsHorde
	Tourist.IsHostile = Tourist.IsAlliance
else
	Tourist.IsFriendly = Tourist.IsAlliance
	Tourist.IsHostile = Tourist.IsHorde
end

function Tourist:IsSanctuary(zone)
	return factions[zone] == "Sanctuary"
end

function Tourist:IsContested(zone)
	return not factions[zone]
end

function Tourist:GetContinent(zone)
	return continents[zone] or UNKNOWN
end

function Tourist:IsInKalimdor(zone)
	return continents[zone] == Kalimdor
end

function Tourist:IsInEasternKingdoms(zone)
	return continents[zone] == Eastern_Kingdoms
end

function Tourist:IsInOutland(zone)
	return continents[zone] == Outland
end

function Tourist:IsInNorthrend(zone)
	return continents[zone] == Northrend
end

function Tourist:IsInTheMaelstrom(zone)
	return continents[zone] == The_Maelstrom
end

function Tourist:IsInPandaria(zone)
	return continents[zone] == Pandaria
end

function Tourist:IsInDraenor(zone)
	return continents[zone] == Draenor
end

function Tourist:IsInBrokenIsles(zone)
	return continents[zone] == BrokenIsles
end

function Tourist:GetInstanceGroupSize(instance)
	return groupSizes[instance] or groupMaxSizes[instance] or 0
end

function Tourist:GetInstanceGroupMinSize(instance)
	return groupMinSizes[instance] or groupSizes[instance] or 0
end

function Tourist:GetInstanceGroupMaxSize(instance)
	return groupMaxSizes[instance] or groupSizes[instance] or 0
end

function Tourist:GetInstanceGroupSizeString(instance, includeAltSize)
	local retValue
	if groupSizes[instance] then
		-- Fixed size
		retValue = tostring(groupSizes[instance])
	elseif groupMinSizes[instance] and groupMaxSizes[instance] then
		-- Variable size
		if groupMinSizes[instance] == groupMaxSizes[instance] then
			-- ...but equal
			retValue = tostring(groupMinSizes[instance])
		else
			retValue = tostring(groupMinSizes[instance]).."-"..tostring(groupMaxSizes[instance])
		end
	else
		-- No size known
		return ""
	end
	if includeAltSize and groupAltSizes[instance] then
		-- Add second size
		retValue = retValue.." or "..tostring(groupAltSizes[instance])
	end
	return retValue
end

function Tourist:GetInstanceAltGroupSize(instance)
	return groupAltSizes[instance] or 0
end

function Tourist:GetTexture(zone)
	return textures[zone]
end

function Tourist:GetZoneMapID(zone)
	return zoneMapIDs[zone]
end

-- Returns the MapAreaID for a given continent ID and zone Index (the index of the zone within the continent)
function Tourist:GetMapAreaIDByContinentZone(continentID, zoneIndex)
	if continentID and continentZoneToMapID[continentID] then
		return continentZoneToMapID[continentID][zoneIndex]
	else
		return nil
	end
end

-- Returns the MapAreaID of a zone based on the texture name
function Tourist:GetZoneMapIDFromTexture(texture)
	if not texture then
		return -1
	end
	local zone = textures_rev[texture]
	if zone then
		return zoneMapIDs[zone]
	else
		-- Might be phased terrain, look for "_terrain<number>" postfix
		local pos1 = string.find(texture, "_terrain")
		if pos1 then
			-- Remove the postfix from the texture name and try again
			texture = string.sub(texture, 0, pos1 - 1)
			zone = textures_rev[texture]
			if zone then
				return zoneMapIDs[zone]
			end
		end
		-- Might be tiered terrain (garrison), look for "_tier<number>" postfix
		local pos2 = string.find(texture, "_tier")
		if pos2 then
			-- Remove the postfix from the texture name and try again
			texture = string.sub(texture, 0, pos2 - 1)
			zone = textures_rev[texture]
			if zone then
				return zoneMapIDs[zone]
			end
		end
	end
	return nil
end

function Tourist:GetZoneFromTexture(texture)
	if not texture then
		return "Azeroth"
	end
	local zone = textures_rev[texture]
	if zone then
		return zone
	else
		-- Might be phased terrain, look for "_terrain<number>" postfix
		local pos1 = string.find(texture, "_terrain")
		if pos1 then
			-- Remove the postfix from the texture name and try again
			texture = string.sub(texture, 0, pos1 - 1)
			zone = textures_rev[texture]
			if zone then
				return zone
			end
		end
		-- Might be tiered terrain (garrison), look for "_tier<number>" postfix
		local pos2 = string.find(texture, "_tier")
		if pos2 then
			-- Remove the postfix from the texture name and try again
			texture = string.sub(texture, 0, pos2 - 1)
			zone = textures_rev[texture]
			if zone then
				return zone
			end
		end
	end
	return nil
end

function Tourist:GetEnglishZoneFromTexture(texture)
	if not texture then
		return "Azeroth"
	end
	local zone = textures_rev[texture]
	if zone then
		return BZR[zone]
	else
		-- Might be phased terrain, look for "_terrain<number>" postfix
		local pos1 = string.find(texture, "_terrain")
		if pos1 then
			-- Remove the postfix from the texture name
			texture = string.sub(texture, 0, pos1 - 1)
			zone = textures_rev[texture]
			if zone then
				return BZR[zone]
			end
		end
		-- Might be tiered terrain (garrison), look for "_tier<number>" postfix
		local pos2 = string.find(texture, "_tier")
		if pos2 then
			-- Remove the postfix from the texture name and try again
			texture = string.sub(texture, 0, pos2 - 1)
			zone = textures_rev[texture]
			if zone then
				return BZR[zone]
			end
		end
	end
	return nil
end

function Tourist:GetEntrancePortalLocation(instance)
	return entrancePortals_zone[instance], entrancePortals_x[instance], entrancePortals_y[instance]
end

local inf = math.huge
local stack = setmetatable({}, {__mode='k'})
local function iterator(S)
	local position = S['#'] - 1
	S['#'] = position
	local x = S[position]
	if not x then
		for k in pairs(S) do
			S[k] = nil
		end
		stack[S] = true
		return nil
	end
	return x
end

setmetatable(cost, {
	__index = function(self, vertex)
		local price = 1

		if lows[vertex] > playerLevel then
			price = price * (1 + math.ceil((lows[vertex] - playerLevel) / 6))
		end

		if factions[vertex] == (isHorde and "Horde" or "Alliance") then
			price = price / 2
		elseif factions[vertex] == (isHorde and "Alliance" or "Horde") then
			if types[vertex] == "City" then
				price = price * 10
			else
				price = price * 3
			end
		end

		if types[x] == "Transport" then
			price = price * 2
		end

		self[vertex] = price
		return price
	end
})

function Tourist:IteratePath(alpha, bravo)
	if paths[alpha] == nil or paths[bravo] == nil then
		return retNil
	end

	local d = next(stack) or {}
	stack[d] = nil
	local Q = next(stack) or {}
	stack[Q] = nil
	local S = next(stack) or {}
	stack[S] = nil
	local pi = next(stack) or {}
	stack[pi] = nil

	for vertex, v in pairs(paths) do
		d[vertex] = inf
		Q[vertex] = v
	end
	d[alpha] = 0

	while next(Q) do
		local u
		local min = inf
		for z in pairs(Q) do
			local value = d[z]
			if value < min then
				min = value
				u = z
			end
		end
		if min == inf then
			return retNil
		end
		Q[u] = nil
		if u == bravo then
			break
		end

		local adj = paths[u]
		if type(adj) == "table" then
			local d_u = d[u]
			for v in pairs(adj) do
				local c = d_u + cost[v]
				if d[v] > c then
					d[v] = c
					pi[v] = u
				end
			end
		elseif adj ~= false then
			local c = d[u] + cost[adj]
			if d[adj] > c then
				d[adj] = c
				pi[adj] = u
			end
		end
	end

	local i = 1
	local last = bravo
	while last do
		S[i] = last
		i = i + 1
		last = pi[last]
	end

	for k in pairs(pi) do
		pi[k] = nil
	end
	for k in pairs(Q) do
		Q[k] = nil
	end
	for k in pairs(d) do
		d[k] = nil
	end
	stack[pi] = true
	stack[Q] = true
	stack[d] = true

	S['#'] = i

	return iterator, S
end

local function retWithOffset(t, key)
	while true do
		key = next(t, key)
		if not key then
			return nil
		end
		if yardYOffsets[key] then
			return key
		end
	end
end

function Tourist:IterateBorderZones(zone, zonesOnly)
	local path = paths[zone]
	if not path then
		return retNil
	elseif type(path) == "table" then
		return zonesOnly and retWithOffset or retNormal, path
	else
		if zonesOnly and not yardYOffsets[path] then
			return retNil
		end
		return retOne, path
	end
end

function Tourist:GetLookupTable()
	return BZ
end

function Tourist:GetReverseLookupTable()
	return BZR
end

--------------------------------------------------------------------------------------------------------
--                                            Localization                                            --
--------------------------------------------------------------------------------------------------------
local MapIdLookupTable = {
	[-1] = "Azeroth",
	[4] = "Durotar",
	[9] = "Mulgore",
	[11] = "Northern Barrens",
	[13] = "Kalimdor",
	[14] = "Eastern Kingdoms",
	[16] = "Arathi Highlands",
	[17] = "Badlands",
	[19] = "Blasted Lands",
	[20] = "Tirisfal Glades",
	[21] = "Silverpine Forest",
	[22] = "Western Plaguelands",
	[23] = "Eastern Plaguelands",
	[24] = "Hillsbrad Foothills",
	[26] = "The Hinterlands",
	[27] = "Dun Morogh",
	[28] = "Searing Gorge",
	[29] = "Burning Steppes",
	[30] = "Elwynn Forest",
	[32] = "Deadwind Pass",
	[34] = "Duskwood",
	[35] = "Loch Modan",
	[36] = "Redridge Mountains",
	[37] = "Northern Stranglethorn",
	[38] = "Swamp of Sorrows",
	[39] = "Westfall",
	[40] = "Wetlands",
	[41] = "Teldrassil",
	[42] = "Darkshore",
	[43] = "Ashenvale",
	[61] = "Thousand Needles",
	[81] = "Stonetalon Mountains",
	[101] = "Desolace",
	[121] = "Feralas",
	[141] = "Dustwallow Marsh",
	[161] = "Tanaris",
	[181] = "Azshara",
	[182] = "Felwood",
	[201] = "Un'Goro Crater",
	[241] = "Moonglade",
	[261] = "Silithus",
	[281] = "Winterspring",
	[301] = "Stormwind City",
	[321] = "Orgrimmar",
	[341] = "Ironforge",
	[362] = "Thunder Bluff",
	[381] = "Darnassus",
	[382] = "Undercity",
	[401] = "Alterac Valley",
	[443] = "Warsong Gulch",
	[461] = "Arathi Basin",
	[462] = "Eversong Woods",
	[463] = "Ghostlands",
	[464] = "Azuremyst Isle",
	[465] = "Hellfire Peninsula",
	[466] = "Outland",
	[467] = "Zangarmarsh",
	[471] = "The Exodar",
	[473] = "Shadowmoon Valley",
	[475] = "Blade's Edge Mountains",
	[476] = "Bloodmyst Isle",
	[477] = "Nagrand",
	[478] = "Terokkar Forest",
	[479] = "Netherstorm",
	[480] = "Silvermoon City",
	[481] = "Shattrath City",
	[482] = "Eye of the Storm",
	[485] = "Northrend",
	[486] = "Borean Tundra",
	[488] = "Dragonblight",
	[490] = "Grizzly Hills",
	[491] = "Howling Fjord",
	[492] = "Icecrown",
	[493] = "Sholazar Basin",
	[495] = "The Storm Peaks",
	[496] = "Zul'Drak",
	[499] = "Isle of Quel'Danas",
	[501] = "Wintergrasp",
	[502] = "Plaguelands: The Scarlet Enclave",
	[504] = "Dalaran",
	[510] = "Crystalsong Forest",
	[512] = "Strand of the Ancients",
	[520] = "The Nexus",
	[521] = "The Culling of Stratholme",
	[522] = "Ahn'kahet: The Old Kingdom",
	[523] = "Utgarde Keep",
	[524] = "Utgarde Pinnacle",
	[525] = "Halls of Lightning",
	[526] = "Halls of Stone",
	[527] = "The Eye of Eternity",
	[528] = "The Oculus",
	[529] = "Ulduar",
	[530] = "Gundrak",
	[531] = "The Obsidian Sanctum",
	[532] = "Vault of Archavon",
	[533] = "Azjol-Nerub",
	[534] = "Drak'Tharon Keep",
	[535] = "Naxxramas",
	[536] = "The Violet Hold",
	[539] = "Gilneas",
	[540] = "Isle of Conquest",
	[541] = "Hrothgar's Landing",
	[542] = "Trial of the Champion",
	[543] = "Trial of the Crusader",
	[544] = "The Lost Isles",
	[545] = "Gilneas",
	[601] = "The Forge of Souls",
	[602] = "Pit of Saron",
	[603] = "Halls of Reflection",
	[604] = "Icecrown Citadel",
	[605] = "Kezan",
	[606] = "Mount Hyjal",
	[607] = "Southern Barrens",
	[609] = "The Ruby Sanctum",
	[610] = "Kelp'thar Forest",
	[611] = "Gilneas City",
	[613] = "Vashj'ir",
	[614] = "Abyssal Depths",
	[615] = "Shimmering Expanse",
	[626] = "Twin Peaks",
	[640] = "Deepholm",
	[673] = "The Cape of Stranglethorn",
	[677] = "The Battle for Gilneas (Old City Map)",
	[678] = "Gilneas",
	[679] = "Gilneas",
	[680] = "Ragefire Chasm",
	[681] = "The Lost Isles",
	[682] = "The Lost Isles",
	[683] = "Mount Hyjal",
	[684] = "Ruins of Gilneas",
	[685] = "Ruins of Gilneas City",
	[686] = "Zul'Farrak",
	[687] = "The Temple of Atal'Hakkar",
	[688] = "Blackfathom Deeps",
	[689] = "Stranglethorn Vale",
	[690] = "The Stockade",
	[691] = "Gnomeregan",
	[692] = "Uldaman",
	[696] = "Molten Core",
	[697] = "Zul'Gurub",
	[699] = "Dire Maul",
	[700] = "Twilight Highlands",
	[704] = "Blackrock Depths",
	[708] = "Tol Barad",
	[709] = "Tol Barad Peninsula",
	[710] = "The Shattered Halls",
	[717] = "Ruins of Ahn'Qiraj",
	[718] = "Onyxia's Lair",
	[720] = "Uldum",
	[721] = "Blackrock Spire",
	[722] = "Auchenai Crypts",
	[723] = "Sethekk Halls",
	[724] = "Shadow Labyrinth",
	[725] = "The Blood Furnace",
	[726] = "The Underbog",
	[727] = "The Steamvault",
	[728] = "The Slave Pens",
	[729] = "The Botanica",
	[730] = "The Mechanar",
	[731] = "The Arcatraz",
	[732] = "Mana-Tombs",
	[733] = "The Black Morass",
	[734] = "Old Hillsbrad Foothills",
	[736] = "The Battle for Gilneas",
	[737] = "The Maelstrom",
	[747] = "Lost City of the Tol'vir",
	[748] = "Uldum",
	[749] = "Wailing Caverns",
	[750] = "Maraudon",
	[751] = "The Maelstrom",
	[752] = "Baradin Hold",
	[753] = "Blackrock Caverns",
	[754] = "Blackwing Descent",
	[755] = "Blackwing Lair",
	[756] = "The Deadmines",
	[757] = "Grim Batol",
	[758] = "The Bastion of Twilight",
	[759] = "Halls of Origination",
	[760] = "Razorfen Downs",
	[761] = "Razorfen Kraul",
	[762] = "Scarlet Monastery",
	[763] = "ScholomanceOLD",
	[764] = "Shadowfang Keep",
	[765] = "Stratholme",
	[766] = "Ahn'Qiraj",
	[767] = "Throne of the Tides",
	[768] = "The Stonecore",
	[769] = "The Vortex Pinnacle",
	[770] = "Twilight Highlands",
	[772] = "Ahn'Qiraj: The Fallen Kingdom",
	[773] = "Throne of the Four Winds",
	[775] = "Hyjal Summit",
	[776] = "Gruul's Lair",
	[779] = "Magtheridon's Lair",
	[780] = "Serpentshrine Cavern",
	[781] = "Zul'Aman",
	[782] = "Tempest Keep",   -- previously "The Eye"
	[789] = "Sunwell Plateau",
	[793] = "Zul'Gurub",
	[795] = "Molten Front",
	[796] = "Black Temple",
	[797] = "Hellfire Ramparts",
	[798] = "Magisters' Terrace",
	[799] = "Karazhan",
	[800] = "Firelands",
	[803] = "The Nexus",
	[806] = "The Jade Forest",
	[807] = "Valley of the Four Winds",
	[808] = "The Wandering Isle",
	[809] = "Kun-Lai Summit",
	[810] = "Townlong Steppes",
	[811] = "Vale of Eternal Blossoms",
	[813] = "Eye of the Storm",
	[816] = "Well of Eternity",
	[819] = "Hour of Twilight",
	[820] = "End Time",
	[823] = "Darkmoon Island",
	[824] = "Dragon Soul",
	[851] = "Dustwallow Marsh",
	[856] = "Temple of Kotmogu",
	[857] = "Krasarang Wilds",
	[858] = "Dread Wastes",
	[860] = "Silvershard Mines",
	[862] = "Pandaria",
	[864] = "Northshire",
	[866] = "Coldridge Valley",
	[867] = "Temple of the Jade Serpent",
	[871] = "Scarlet Halls",
	[873] = "The Veiled Stair",
	[874] = "Scarlet Monastery",
	[875] = "Gate of the Setting Sun",
	[876] = "Stormstout Brewery",
	[877] = "Shado-Pan Monastery",
	[878] = "A Brewing Storm",
	[880] = "The Jade Forest",
	[881] = "Temple of Kotmogu",
	[882] = "Unga Ingoo",
	[883] = "Assault on Zan'vess",
	[884] = "Brewmoon Festival",
	[885] = "Mogu'shan Palace",
	[886] = "Terrace of Endless Spring",
	[887] = "Siege of Niuzao Temple",
	[888] = "Shadowglen",
	[889] = "Valley of Trials",
	[890] = "Camp Narache",
	[891] = "Echo Isles",
	[892] = "Deathknell",
	[893] = "Sunstrider Isle",
	[894] = "Ammen Vale",
	[895] = "New Tinkertown",
	[896] = "Mogu'shan Vaults",
	[897] = "Heart of Fear",
	[898] = "Scholomance",
	[899] = "Proving Grounds",
	[900] = "Crypt of Forgotten Kings",
	[903] = "Shrine of Two Moons",
	[905] = "Shrine of Seven Stars",
	[906] = "Dustwallow Marsh",
	[907] = "Dustwallow Marsh",
	[910] = "Krasarang Wilds",
	[911] = "Krasarang Wilds",
	[912] = "A Little Patience",
	[914] = "Dagger in the Dark",
	[919] = "Black Temple",
	[920] = "Krasarang Wilds",
	[922] = "Deeprun Tram",
	[924] = "Dalaran",
	[925] = "Brawl'gar Arena",	
	[928] = "Isle of Thunder",
	[929] = "Isle of Giants",
	[930] = "Throne of Thunder",
	[933] = "Isle of Thunder",
	[934] = "Thunder King's Citadel",
	[935] = "Deepwind Gorge",
	[937] = "Vale of Eternal Blossoms",
	[938] = "The Secrets of Ragefire",
	[939] = "Dun Morogh",
	[940] = "Battle on the High Seas",
	[941] = "Frostfire Ridge",
	[945] = "Tanaan Jungle",
	[946] = "Talador",
	[947] = "Shadowmoon Valley",
	[948] = "Spires of Arak",
	[949] = "Gorgrond",
	[950] = "Nagrand",
	[951] = "Timeless Isle",
	[953] = "Siege of Orgrimmar",
	[955] = "Celestial Tournament",
	[962] = "Draenor",
	[964] = "Bloodmaul Slag Mines",
	[969] = "Shadowmoon Burial Grounds",
	[970] = "Tanaan Jungle",
	[971] = "Lunarfall",
	[973] = "Lunarfall",
	[974] = "Lunarfall",
	[975] = "Lunarfall",
	[976] = "Frostwall",
	[978] = "Ashran",
	[980] = "Frostwall",
	[981] = "Frostwall",
	[982] = "Frostwall",
	[983] = "Defense of Karabor",
	[984] = "Auchindoun",
	[986] = "Shattrath City",
	[987] = "Iron Docks",
	[988] = "Blackrock Foundry",
	[989] = "Skyreach",
	[990] = "Frostwall",
	[991] = "Lunarfall",
	[992] = "Blasted Lands",
	[993] = "Grimrail Depot",
	[994] = "Highmaul",
	[995] = "Upper Blackrock Spire",
	[1007] = "Broken Isles",
	[1008] = "The Everbloom",
	[1009] = "Stormshield",
	[1010] = "Hillsbrad Foothills (Southshore vs. Tarren Mill)",
	[1011] = "Warspear",
	[1014] = "Dalaran",
	[1015] = "Azsuna",
	[1017] = "Stormheim",
	[1018] = "Val'sharah",
	[1020] = "Twisting Nether",
	[1021] = "Broken Shore",
	[1022] = "Helheim",
	[1024] = "Highmountain",
	[1026] = "Hellfire Citadel",
	[1027] = "The Cove of Nashal",
	[1028] = "Mardum, the Shattered Abyss",
	[1031] = "Broken Shore",
	[1032] = "Vault of the Wardens",
	[1033] = "Suramar",
	[1034] = "Helmouth Shallows",
	[1035] = "Skyhold",
	[1036] = "Shield's Rest",
	[1037] = "Stormheim",
	[1038] = "Azshara",
	[1039] = "Icecrown Citadel",
	[1040] = "Netherlight Temple",
	[1041] = "Halls of Valor",
	[1042] = "Helmouth Cliffs",
	[1043] = "The Naglfar",
	[1044] = "The Wandering Isle",
	[1045] = "Vault of the Wardens",
	[1046] = "Eye of Azshara",
	[1047] = "Niskara",
	[1048] = "Emerald Dreamway",
	[1049] = "Skywall",
	[1050] = "Dreadscar Rift",
	[1051] = "Dreadscar Rift",
	[1052] = "Mardum, the Shattered Abyss",
	[1053] = "Azsuna",
	[1054] = "The Violet Hold",
	[1055] = "Suramar",
	[1056] = "The Maelstrom",
	[1057] = "The Maelstrom",
	[1058] = "Kun-Lai Summit",
	[1059] = "Terrace of Endless Spring",
	[1060] = "Deepholm",
	[1062] = "Tirisfal Glades",
	[1065] = "Neltharion's Lair",
	[1066] = "Violet Hold",
	[1067] = "Darkheart Thicket",
	[1068] = "Hall of the Guardian",
	[1069] = "The Beyond",
	[1070] = "The Vortex Pinnacle",
	[1071] = "Firelands",
	[1072] = "Trueshot Lodge",
	[1073] = "Shadowgore Citadel",
	[1075] = "Abyssal Maw",
	[1076] = "Ulduar",
	[1077] = "The Dreamgrove",
	[1078] = "Niskara",
	[1079] = "The Arcway",
	[1080] = "Thunder Totem",
	[1081] = "Black Rook Hold",
	[1082] = "Ursoc's Lair",
	[1084] = "Gloaming Reef",
	[1085] = "Black Temple",
	[1086] = "Malorne's Nightmare",
	[1087] = "Court of Stars",
	[1088] = "The Nighthold",
	[1090] = "Tol Barad",
	[1091] = "The Exodar",
	[1092] = "Azuremyst Isle",
	[1094] = "The Emerald Nightmare",
	[1096] = "Eye of Azshara",
	[1097] = "Temple of the Jade Serpent",
	[1098] = "Eye of Azshara",
	[1099] = "Black Rook Hold",
	[1100] = "Karazhan",
	[1102] = "The Arcway",
	[1104] = "The Oculus",
	[1105] = "Scarlet Monastery",
	[1114] = "Trial of Valor",
	[1115] = "Karazhan",
	[1116] = "Pit of Saron",
	[1121] = "Broken Shore",
	[1125] = "Broken Shore",
	[1127] = "Wailing Caverns",
	[1129] = "Cave of the Bloodtotem",
	[1130] = "Stratholme",
	[1131] = "The Eye of Eternity",
	[1132] = "Halls of Valor",
	[1135] = "Krokuun",
    [1136] = "Coldridge Valley",
    [1137] = "The Deadmines",
	[1139] = "Arathi Basin",
	[1140] = "Battle for Blackrock Mountain",
	[1142] = "The Maelstrom",
    [1143] = "Gnomeregan",
	[1144] = "Shado-Pan Showdown",
	[1146] = "Cathedral of Eternal Night",
	[1147] = "Tomb of Sargeras",
	[1148] = "Throne of the Four Winds",
	[1149] = "Assault on Broken Shore",
	[1151] = "The Ruby Sanctum",
	[1152] = "Mardum, the Shattered Abyss",
	[1156] = "Stormheim",
	[1157] = "Azsuna",
	[1158] = "Val'sharah",
	[1159] = "Highmountain",
	[1160] = "The Lost Glacier",
	[1161] = "Stormstout Brewery",
	[1164] = "Fields of the Eternal Hunt",
	[1165] = "Mardum, the Shattered Abyss",
	[1166] = "The Eye of Eternity",
    [1170] = "Mac'Aree",
    [1171] = "Antoran Wastes",
    [1172] = "Hall of Communion",
    [1173] = "Arcatraz",
    [1174] = "Azuremyst Isle",
    [1177] = "The Deaths of Chromie",
    [1178] = "The Seat of the Triumvirate",
    [1184] = "Argus",
	[1183] = "Silithus Brawl",
	[1186] = "Seething Shore",
    [1188] = "Antorus, the Burning Throne",
    [1190] = "Invasion Point: Aurinor",
    [1191] = "Invasion Point: Bonich",
    [1192] = "Invasion Point: Cen'gar",
    [1193] = "Invasion Point: Naigtal",
    [1194] = "Invasion Point: Sangua",
    [1195] = "Invasion Point: Val",
    [1196] = "Greater Invasion Point: Pit Lord Vilemus",
    [1197] = "Greater Invasion Point: Mistress Alluradel",
    [1198] = "Greater Invasion Point: Matron Folnuna",
    [1199] = "Greater Invasion Point: Inquisitor Meto",
    [1200] = "Greater Invasion Point: Sotanathor",
    [1201] = "Greater Invasion Point: Occularus",
	[1202] = "Forge of Aeons",
	[1206] = "Silithus",
	[1212] = "The Vindicaar",
	[1215] = "Telogrus Rift",
	[1216] = "Telogrus Rift",
	[1217] = "The Sunwell",	
}

local zoneTranslation = {
	enUS = {
		-- Complexes
		[1941] = "Caverns of Time",
		[25] = "Blackrock Mountain",
		[4406] = "The Ring of Valor",
		[3545] = "Hellfire Citadel",
		[3905] = "Coilfang Reservoir",
		[3893] = "Ring of Observance",
		[3842] = "Tempest Keep",
		[4024] = "Coldarra",
		[5695] = "Ahn'Qiraj: The Fallen Kingdom",

		-- Continents
		[0] = "Eastern Kingdoms",
		[1] = "Kalimdor",
		[530] = "Outland",
		[571] = "Northrend",
		[5416] = "The Maelstrom",
		[870] = "Pandaria",
		["Azeroth"] = "Azeroth",

		-- Transports
		[72] = "The Dark Portal",
		[2257] = "Deeprun Tram",

		-- Dungeons
		[5914] = "Dire Maul (East)",
		[5913] = "Dire Maul (North)",
		[5915] = "Dire Maul (West)",

		-- Arenas
		[559] = "Nagrand Arena",
		[562] = "Blade's Edge Arena",
		[572] = "Ruins of Lordaeron",
		[4378] = "Dalaran Arena",
		[6732] = "The Tiger's Peak",

		-- Other
		[4298] = "Plaguelands: The Scarlet Enclave",
		[3508] = "Amani Pass",
		[3979] = "The Frozen Sea",
	},
	deDE = {
		-- Complexes
		[1941] = "Höhlen der Zeit",
		[25] = "Der Schwarzfels",
		[4406] = "Der Ring der Ehre",
		[3545] = "Höllenfeuerzitadelle",
		[3905] = "Der Echsenkessel",
		[3893] = "Ring der Beobachtung",
		[3842] = "Festung der Stürme",
		[4024] = "Kaltarra",
		[5695] = "Ahn'Qiraj: Das Gefallene Königreich",

		-- Continents
		[0] = "Östliche Königreiche",
		[1] = "Kalimdor",
		[530] = "Scherbenwelt",
		[571] = "Nordend",
		[5416] = "Der Mahlstrom",
		[870] = "Pandaria",
		["Azeroth"] = "Azeroth",

		-- Transports
		[72] = "Das Dunkle Portal",
		[2257] = "Die Tiefenbahn",

		-- Dungeons
		[5914] = "Düsterbruch - Ost",
		[5913] = "Düsterbruch - Nord",
		[5915] = "Düsterbruch - West",

		-- Arenas
		[559] = "Arena von Nagrand",
		[562] = "Arena des Schergrats",
		[572] = "Ruinen von Lordaeron",
		[4378] = "Arena von Dalaran",
		[6732] = "Der Tigergipfel", 

		-- Other
		[4298] = "Pestländer: Die Scharlachrote Enklave",
		[3508] = "Amanipass",
		[3979] = "Die Gefrorene See",
	},
	esES = {
		-- Complexes
		[1941] = "Cavernas del Tiempo",
		[25] = "Montaña Roca Negra",
		[4406] = "El Círculo del Valor",
		[3545] = "Ciudadela del Fuego Infernal",
		[3905] = "Reserva Colmillo Torcido",
		[3893] = "Círculo de la Observancia",
		[3842] = "El Castillo de la Tempestad",
		[4024] = "Gelidar",
		[5695] = "Ahn'Qiraj: El Reino Caído",

		-- Continents
		[0] = "Reinos del Este",
		[1] = "Kalimdor",
		[530] = "Terrallende",
		[571] = "Rasganorte",
		[5416] = "La Vorágine",
		[870] = "Pandaria",
		["Azeroth"] = "Azeroth",

		-- Transports
		[72] = "El Portal Oscuro",
		[2257] = "Tranvía Subterráneo",

		-- Dungeons
		[5914] = "La Masacre: Este",
		[5913] = "La Masacre: Norte",
		[5915] = "La Masacre: Oeste",

		-- Arenas
		[559] = "Arena de Nagrand",
		[562] = "Arena Filospada",
		[572] = "Ruinas de Lordaeron",
		[4378] = "Arena de Dalaran",
		[6732] = "La Cima del Tigre",

		-- Other
		[4298] = "Tierras de la Peste: El Enclave Escarlata",
		[3508] = "Paso de Amani",
		[3979] = "El Mar Gélido",
	},
	esMX = {
		-- Complexes
		[1941] = "Cavernas del Tiempo",
		[25] = "Montaña Roca Negra",
		[4406] = "El Círculo del Valor",
		[3545] = "Ciudadela del Fuego Infernal",
		[3905] = "Reserva Colmillo Torcido",
		[3893] = "Círculo de la Observancia",
		[3842] = "El Castillo de la Tempestad",
		[4024] = "Gelidar",
		[5695] = "Ahn'Qiraj: El Reino Caído",

		-- Continents
		[0] = "Reinos del Este",
		[1] = "Kalimdor",
		[530] = "Terrallende",
		[571] = "Rasganorte",
		[5416] = "La Vorágine",
		[870] = "Pandaria",
		["Azeroth"] = "Azeroth",

		-- Transports
		[72] = "El Portal Oscuro",
		[2257] = "Tranvía Subterráneo",

		-- Dungeons
		[5914] = "La Masacre: Este",
		[5913] = "La Masacre: Norte",
		[5915] = "La Masacre: Oeste",

		-- Arenas
		[559] = "Arena de Nagrand",
		[562] = "Arena Filospada",
		[572] = "Ruinas de Lordaeron",
		[4378] = "Arena de Dalaran",
		[6732] = "La Cima del Tigre",

		-- Other
		[4298] = "Tierras de la Peste: El Enclave Escarlata",
		[3508] = "Paso de Amani",
		[3979] = "El Mar Gélido",
	},
	frFR = {
		-- Complexes
		[1941] = "Grottes du Temps",
		[25] = "Mont Rochenoire",
		[4406] = "L’arène des Valeureux",
		[3545] = "Citadelle des Flammes infernales",
		[3905] = "Réservoir de Glissecroc",
		[3893] = "Cercle d’observance",
		[3842] = "Donjon de la Tempête",
		[4024] = "Frimarra",
		[5695] = "Ahn’Qiraj : le royaume Déchu",

		-- Continents
		[0] = "Royaumes de l'est",
		[1] = "Kalimdor",
		[530] = "Outreterre",
		[571] = "Norfendre",
		[5416] = "Le Maelström",
		[870] = "Pandarie",
		["Azeroth"] = "Azeroth",

		-- Transports
		[72] = "La porte des Ténèbres",
		[2257] = "Tram des profondeurs",

		-- Dungeons
		[5914] = "Haches-Tripes - Est",
		[5913] = "Haches-Tripes - Nord",
		[5915] = "Haches-Tripes - Ouest",

		-- Arenas
		[559] = "Arène de Nagrand",
		[562] = "Arène des Tranchantes",
		[572] = "Ruines de Lordaeron",
		[4378] = "Arène de Dalaran",
		[6732] = "Le croc du Tigre",

		-- Other
		[4298] = "Maleterres : l’enclave Écarlate",
		[3508] = "Passage des Amani",
		[3979] = "La mer Gelée",
	},
	itIT = {
		-- Complexes
		[1941] = "Caverne del Tempo",
		[25] = "Massiccio Roccianera",
		[4406] = "Arena del Valore",
		[3545] = "Cittadella del Fuoco Infernale",
		[3905] = "Bacino degli Spiraguzza",
		[3893] = "Anello dell'Osservanza",
		[3842] = "Forte Tempesta",
		[4024] = "Ibernia",
		[5695] = "Ahn'Qiraj: il Regno Perduto",

		-- Continents
		[0] = "Regni Orientali",
		[1] = "Kalimdor",
		[530] = "Terre Esterne",
		[571] = "Nordania",
		[5416] = "Maelstrom",
		[870] = "Pandaria",
		["Azeroth"] = "Azeroth",

		-- Transports
		[72] = "Portale Oscuro",
		[2257] = "Tram degli Abissi",

		-- Dungeons
		[5914] = "Maglio Infausto - Est",
		[5913] = "Maglio Infausto - Nord",
		[5915] = "Maglio Infausto - Ovest",

		-- Arenas
		[559] = "Arena di Nagrand",
		[562] = "Arena di Spinaguzza",
		[572] = "Rovine di Lordaeron",
		[4378] = "Arena di Dalaran",
		[6732] = "Picco della Tigre",

		-- Other
		[4298] = "Terre Infette: l'Enclave Scarlatta",
		[3508] = "Passo degli Amani",
		[3979] = "Mare Ghiacciato",
	},
	koKR = {
		-- Complexes
		[1941] = "시간의 동굴",
		[25] = "검은바위 산",
		[4406] = "용맹의 투기장",
		[3545] = "지옥불 성채",
		[3905] = "갈퀴송곳니 저수지",
		[3893] = "규율의 광장",
		[3842] = "폭풍우 요새",
		[4024] = "콜다라",
		[5695] = "안퀴라즈: 무너진 왕국",

		-- Continents
		[0] = "동부 왕국",
		[1] = "칼림도어",
		[530] = "아웃랜드",
		[571] = "노스렌드",
		[5416] = "혼돈의 소용돌이",
		[870] = "판다리아",
		["Azeroth"] = "아제로스",

		-- Transports
		[72] = "어둠의 문",
		[2257] = "깊은굴 지하철",

		-- Dungeons
		[5914] = "혈투의 전장 - 동쪽",
		[5913] = "혈투의 전장 - 북쪽",
		[5915] = "혈투의 전장 - 서쪽",

		-- Arenas
		[559] = "나그란드 투기장",
		[562] = "칼날 산맥 투기장",
		[572] = "로데론의 폐허",
		[4378] = "달라란 투기장",
		[6732] = "범의 봉우리",

		-- Other
		[4298] = "동부 역병지대: 붉은십자군 초소",
		[3508] = "아마니 고개",
		[3979] = "얼어붙은 바다",
	},
	ptBR = {
		-- Complexes
		[1941] = "Cavernas do Tempo",
		[25] = "Montanha Rocha Negra",
		[4406] = "Ringue dos Valorosos",
		[3545] = "Cidadela Fogo do Inferno",
		[3905] = "Reservatório Presacurva",
		[3893] = "Círculo da Obediência",
		[3842] = "Bastilha da Tormenta",
		[4024] = "Gelarra",
		[5695] = "Ahn'Qiraj: O Reino Derrotado",

		-- Continents
		[0] = "Reinos do Leste",
		[1] = "Kalimdor",
		[530] = "Terralém",
		[571] = "Nortúndria",
		[5416] = "Voragem",
		[870] = "Pandária",
		["Azeroth"] = "Azeroth",

		-- Transports
		[72] = "Portal Negro",
		[2257] = "Metrô Correfundo",

		-- Dungeons
		[5914] = "Gládio Cruel – Leste",
		[5913] = "Gládio Cruel – Norte",
		[5915] = "Gládio Cruel – Oeste",

		-- Arenas
		[559] = "Arena de Nagrand",
		[562] = "Arena da Lâmina Afiada",
		[572] = "Ruínas de Lordaeron",
		[4378] = "Arena de Dalaran",
		[6732] = "O Pico do Tigre",
		
		-- Other
		[4298] = "Terras Pestilentas: Enclave Escarlate",
		[3508] = "Desfiladeiro Amani",
		[3979] = "Mar Congelado",
	},
	ruRU = {
		-- Complexes
		[1941] = "Пещеры Времени",
		[25] = "Черная гора",
		[4406] = "Арена Доблести",
		[3545] = "Цитадель Адского Пламени",
		[3905] = "Резервуар Кривого Клыка",
		[3893] = "Ритуальный Круг",
		[3842] = "Крепость Бурь",
		[4024] = "Хладарра",
		[5695] = "Ан'Кираж: Павшее Королевство",

		-- Continents
		[0] = "Восточные королевства",
		[1] = "Калимдор",
		[530] = "Запределье",
		[571] = "Нордскол",
		[5416] = "Водоворот",
		[870] = "Пандария",
		["Azeroth"] = "Азерот",

		-- Transports
		[72] = "Темный портал",
		[2257] = "Подземный поезд",

		-- Dungeons
		[5914] = "Забытый город – восток",
		[5913] = "Забытый город – север",
		[5915] = "Забытый город – запад",

		-- Arenas
		[559] = "Арена Награнда",
		[562] = "Арена Острогорья",
		[572] = "Руины Лордерона",
		[4378] = "Арена Даларана",
		[6732] = "Пик Тигра",
		
		-- Other
		[4298] = "Чумные земли: Анклав Алого ордена",
		[3508] = "Перевал Амани",
		[3979] = "Ледяное море",
	},
	zhCN = {
		-- Complexes
		[1941] = "时光之穴",
		[25] = "黑石山",
		[4406] = "勇气竞技场",
		[3545] = "地狱火堡垒",
		[3905] = "盘牙水库",
		[3893] = "仪式广场",
		[3842] = "风暴要塞",
		[4024] = "考达拉",
		[5695] = "安其拉：堕落王国",

		-- Continents
		[0] = "东部王国",
		[1] = "卡利姆多",
		[530] = "外域",
		[571] = "诺森德",
		[5416] = "大漩涡",
		[870] = "潘达利亚",
		["Azeroth"] = "艾泽拉斯",

		-- Transports
		[72] = "黑暗之门",
		[2257] = "矿道地铁",

		-- Dungeons
		[5914] = "厄运之槌 - 东",
		[5913] = "厄运之槌 - 北",
		[5915] = "厄运之槌 - 西",

		-- Arenas
		[559] = "纳格兰竞技场",
		[562] = "刀锋山竞技场",
		[572] = "洛丹伦废墟",
		[4378] = "达拉然竞技场",
		[6732] = "虎踞峰",
		
		-- Other
		[4298] = "东瘟疫之地：血色领地",
		[3508] = "阿曼尼小径",
		[3979] = "冰冻之海",
	},
	zhTW = {
		-- Complexes
		[1941] = "時光之穴",
		[25] = "黑石山",
		[4406] = "勇武競技場",
		[3545] = "地獄火堡壘",
		[3905] = "盤牙蓄湖",
		[3893] = "儀式競技場",
		[3842] = "風暴要塞",
		[4024] = "凜懼島",
		[5695] = "安其拉: 沒落的王朝",

		-- Continents
		[0] = "東部王國",
		[1] = "卡林多",
		[530] = "外域",
		[571] = "北裂境",
		[5416] = "大漩渦",
		[870] = "潘達利亞",
		["Azeroth"] = "艾澤拉斯",

		-- Transports
		[72] = "黑暗之門",
		[2257] = "礦道地鐵",

		-- Dungeons
		[5914] = "厄運之槌 - 東方",
		[5913] = "厄運之槌 - 北方",
		[5915] = "厄運之槌 - 西方",

		-- Arenas
		[559] = "納葛蘭競技場",
		[562] = "劍刃競技場",
		[572] = "羅德隆廢墟",
		[4378] = "達拉然競技場",
		[6732] = "猛虎峰",
		
		-- Other
		[4298] = "東瘟疫之地:血色領區",
		[3508] = "阿曼尼小徑",
		[3979] = "冰凍之海",
	},
}

local function CreateLocalizedZoneNameLookups()
	local mapID
	local localizedZoneName

	for mapID, englishName in pairs(MapIdLookupTable) do
		-- Get localized map name
		localizedZoneName = GetMapNameByID(mapID)
		if localizedZoneName then
			-- Add combination of English and localized name to lookup tables
			if not BZ[englishName] then
				BZ[englishName] = localizedZoneName
			end
			if not BZR[localizedZoneName] then
				BZR[localizedZoneName] = englishName
			end
		else
			trace("! ----- No map name for ID "..tostring(mapID).." ("..tostring(englishName)..")")
		end
	end

	-- Load from zoneTranslation
	local GAME_LOCALE = GetLocale()
	for key, localizedZoneName in pairs(zoneTranslation[GAME_LOCALE]) do
		local englishName = zoneTranslation["enUS"][key]
		if not BZ[englishName] then
			BZ[englishName] = localizedZoneName
		end
		if not BZR[localizedZoneName] then
			BZR[localizedZoneName] = englishName
		end
	end
end

local function AddDuplicatesToLocalizedLookup()
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("The Maelstrom", 5)] = Tourist:GetUniqueZoneNameForLookup("The Maelstrom", 5)
	BZR[Tourist:GetUniqueZoneNameForLookup("The Maelstrom", 5)] = Tourist:GetUniqueEnglishZoneNameForLookup("The Maelstrom", 5)
	
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("Nagrand", 7)] = Tourist:GetUniqueZoneNameForLookup("Nagrand", 7)
	BZR[Tourist:GetUniqueZoneNameForLookup("Nagrand", 7)] = Tourist:GetUniqueEnglishZoneNameForLookup("Nagrand", 7)

	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("Shadowmoon Valley", 7)] = Tourist:GetUniqueZoneNameForLookup("Shadowmoon Valley", 7)
	BZR[Tourist:GetUniqueZoneNameForLookup("Shadowmoon Valley", 7)] = Tourist:GetUniqueEnglishZoneNameForLookup("Shadowmoon Valley", 7)
	
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("Hellfire Citadel", 7)] = Tourist:GetUniqueZoneNameForLookup("Hellfire Citadel", 7)
	BZR[Tourist:GetUniqueZoneNameForLookup("Hellfire Citadel", 7)] = Tourist:GetUniqueEnglishZoneNameForLookup("Hellfire Citadel", 7)
	
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("Dalaran", 8)] = Tourist:GetUniqueZoneNameForLookup("Dalaran", 8)
	BZR[Tourist:GetUniqueZoneNameForLookup("Dalaran", 8)] = Tourist:GetUniqueEnglishZoneNameForLookup("Dalaran", 8)
	
	BZ[Tourist:GetUniqueEnglishZoneNameForLookup("The Violet Hold", 8)] = Tourist:GetUniqueZoneNameForLookup("The Violet Hold", 8)
	BZR[Tourist:GetUniqueZoneNameForLookup("The Violet Hold", 8)] = Tourist:GetUniqueEnglishZoneNameForLookup("The Violet Hold", 8)
end


--------------------------------------------------------------------------------------------------------
--                                            BZ table                                             --
--------------------------------------------------------------------------------------------------------

do
	Tourist.frame = oldLib and oldLib.frame or CreateFrame("Frame", MAJOR_VERSION .. "Frame", UIParent)
	Tourist.frame:UnregisterAllEvents()
	Tourist.frame:RegisterEvent("PLAYER_LEVEL_UP")
	Tourist.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	Tourist.frame:SetScript("OnEvent", function(frame, event, ...)
		PLAYER_LEVEL_UP(Tourist, ...)
	end)


	trace("Tourist: Initializing localized zone name lookups...")
	CreateLocalizedZoneNameLookups()
	AddDuplicatesToLocalizedLookup()

	
	-- TRANSPORT DEFINITIONS ----------------------------------------------------------------

	local transports = {}

	-- Boats
	transports["BOOTYBAY_RATCHET_BOAT"] = string.format(X_Y_BOAT, BZ["The Cape of Stranglethorn"], BZ["Northern Barrens"])
	transports["MENETHIL_HOWLINGFJORD_BOAT"] = string.format(X_Y_BOAT, BZ["Wetlands"], BZ["Howling Fjord"])
	transports["MENETHIL_THERAMORE_BOAT"] = string.format(X_Y_BOAT, BZ["Wetlands"], BZ["Dustwallow Marsh"])
	transports["MOAKI_KAMAGUA_BOAT"] = string.format(X_Y_BOAT, BZ["Dragonblight"], BZ["Howling Fjord"])
	transports["MOAKI_UNUPE_BOAT"] = string.format(X_Y_BOAT, BZ["Dragonblight"], BZ["Borean Tundra"])
	transports["STORMWIND_BOREANTUNDRA_BOAT"] = string.format(X_Y_BOAT, BZ["Stormwind City"], BZ["Borean Tundra"])
	transports["TELDRASSIL_AZUREMYST_BOAT"] = string.format(X_Y_BOAT, BZ["Teldrassil"], BZ["Azuremyst Isle"])
	transports["TELDRASSIL_STORMWIND_BOAT"] = string.format(X_Y_BOAT, BZ["Teldrassil"], BZ["Stormwind City"])
	
	-- Zeppelins
	transports["ORGRIMMAR_BOREANTUNDRA_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Orgrimmar"], BZ["Borean Tundra"])
	transports["ORGRIMMAR_GROMGOL_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Orgrimmar"], BZ["Northern Stranglethorn"])
	transports["ORGRIMMAR_THUNDERBLUFF_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Orgrimmar"], BZ["Thunder Bluff"])
	transports["ORGRIMMAR_UNDERCITY_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Orgrimmar"], BZ["Undercity"])
	transports["UNDERCITY_GROMGOL_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Undercity"], BZ["Northern Stranglethorn"])
	transports["UNDERCITY_HOWLINGFJORD_ZEPPELIN"] = string.format(X_Y_ZEPPELIN, BZ["Undercity"], BZ["Howling Fjord"])
	
	-- Teleports
	transports["SILVERMOON_UNDERCITY_TELEPORT"] = string.format(X_Y_TELEPORT, BZ["Silvermoon City"], BZ["Undercity"])
	transports["DALARAN_CRYSTALSONG_TELEPORT"] = string.format(X_Y_TELEPORT, BZ["Dalaran"], BZ["Crystalsong Forest"])
	
	-- Portals
	transports["DALARAN_COT_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"], BZ["Caverns of Time"])
	transports["DALARAN_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"], BZ["Orgrimmar"])
	transports["DALARAN_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"], BZ["Stormwind City"])
	transports["DALARANBROKENISLES_COT_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Caverns of Time"])
	transports["DALARANBROKENISLES_DARNASSUS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Darnassus"])
	transports["DALARANBROKENISLES_DRAGONBLIGHT_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Dragonblight"])
	transports["DALARANBROKENISLES_EXODAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["The Exodar"])
	transports["DALARANBROKENISLES_HILLSBRAD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Hillsbrad Foothills"])
	transports["DALARANBROKENISLES_IRONFORGE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Ironforge"])
	transports["DALARANBROKENISLES_KARAZHAN_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Karazhan"])
	transports["DALARANBROKENISLES_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Orgrimmar"])
	transports["DALARANBROKENISLES_SEVENSTARS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Shrine of Seven Stars"])
	transports["DALARANBROKENISLES_SHATTRATH_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Shattrath City"])
	transports["DALARANBROKENISLES_SILVERMOON_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Silvermoon City"])
	transports["DALARANBROKENISLES_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Stormwind City"])
	transports["DALARANBROKENISLES_THUNDERBLUFF_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Thunder Bluff"])
	transports["DALARANBROKENISLES_TWOMOONS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Shrine of Two Moons"])
	transports["DALARANBROKENISLES_UNDERCITY_PORTAL"] = string.format(X_Y_PORTAL, BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", BZ["Undercity"])
	transports["DARKMOON_ELWYNNFOREST_PORTAL"] = string.format(X_Y_PORTAL, BZ["Darkmoon Island"], BZ["Elwynn Forest"])
	transports["DARKMOON_MULGORE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Darkmoon Island"], BZ["Mulgore"])
	transports["DARNASSUS_EXODAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Darnassus"], BZ["The Exodar"])
	transports["DARNASSUS_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Darnassus"], BZ["Hellfire Peninsula"])
	transports["DEEPHOLM_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Deepholm"], BZ["Orgrimmar"])
	transports["DEEPHOLM_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Deepholm"], BZ["Stormwind City"])
	transports["ELWYNNFOREST_DARKMOON_PORTAL"] = string.format(X_Y_PORTAL, BZ["Elwynn Forest"], BZ["Darkmoon Island"])
	transports["EXODAR_DARNASSUS_PORTAL"] = string.format(X_Y_PORTAL, BZ["The Exodar"], BZ["Darnassus"])
	transports["EXODAR_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["The Exodar"], BZ["Hellfire Peninsula"])
	transports["FROSTFIRERIDGE_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Frostfire Ridge"], BZ["Orgrimmar"])
	transports["HELLFIRE_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Hellfire Peninsula"], BZ["Orgrimmar"])
	transports["HELLFIRE_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Hellfire Peninsula"], BZ["Stormwind City"])
	transports["IRONFORGE_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Ironforge"], BZ["Hellfire Peninsula"])
	transports["ISLEOFTHUNDER_TOWNLONGSTEPPES_PORTAL"] = string.format(X_Y_PORTAL, BZ["Isle of Thunder"], BZ["Townlong Steppes"])
	transports["JADEFOREST_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["The Jade Forest"], BZ["Orgrimmar"])
	transports["JADEFOREST_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["The Jade Forest"], BZ["Stormwind City"])
	transports["MULGORE_DARKMOON_PORTAL"] = string.format(X_Y_PORTAL, BZ["Mulgore"], BZ["Darkmoon Island"])
	transports["ORGRIMMAR_BLASTEDLANDS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Blasted Lands"])
	transports["ORGRIMMAR_DALARANBROKENISLES_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Dalaran"].." ("..BZ["Broken Isles"]..")")
	transports["ORGRIMMAR_DEEPHOLM_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Deepholm"])
	transports["ORGRIMMAR_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Hellfire Peninsula"])
	transports["ORGRIMMAR_JADEFOREST_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["The Jade Forest"])
	transports["ORGRIMMAR_MOUNTHYJAL_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Mount Hyjal"])
	transports["ORGRIMMAR_TOLBARAD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Tol Barad Peninsula"])
	transports["ORGRIMMAR_TWILIGHTHIGHLANDS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Twilight Highlands"])
	transports["ORGRIMMAR_ULDUM_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Uldum"])
	transports["ORGRIMMAR_VASHJIR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Orgrimmar"], BZ["Vashj'ir"])
	transports["SEVENSTARS_DALARAN_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Seven Stars"], BZ["Dalaran"])
	transports["SEVENSTARS_DARNASSUS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Seven Stars"], BZ["Darnassus"])
	transports["SEVENSTARS_EXODAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Seven Stars"], BZ["The Exodar"])
	transports["SEVENSTARS_IRONFORGE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Seven Stars"], BZ["Ironforge"])
	transports["SEVENSTARS_SHATTRATH_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Seven Stars"], BZ["Shattrath City"])
	transports["SEVENSTARS_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Seven Stars"], BZ["Stormwind City"])
	transports["SHADOWMOONVALLEY_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shadowmoon Valley"], BZ["Stormwind City"])
	transports["SHATTRATH_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shattrath City"], BZ["Orgrimmar"])
	transports["SHATTRATH_QUELDANAS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shattrath City"], BZ["Isle of Quel'Danas"])
	transports["SHATTRATH_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shattrath City"], BZ["Stormwind City"])
	transports["SILVERMOON_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Silvermoon City"], BZ["Hellfire Peninsula"])
	transports["STORMSHIELD_DARNASSUS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormshield"], BZ["Darnassus"])
	transports["STORMSHIELD_IRONFORGE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormshield"], BZ["Ironforge"])
	transports["STORMSHIELD_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormshield"], BZ["Stormwind City"])
	transports["STORMWIND_BLASTEDLANDS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Blasted Lands"])
	transports["STORMWIND_DALARANBROKENISLES_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Dalaran"].." ("..BZ["Broken Isles"]..")")
	transports["STORMWIND_DEEPHOLM_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Deepholm"])
	transports["STORMWIND_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Hellfire Peninsula"])
	transports["STORMWIND_JADEFOREST_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["The Jade Forest"])
	transports["STORMWIND_MOUNTHYJAL_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Mount Hyjal"])
	transports["STORMWIND_TOLBARAD_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Tol Barad Peninsula"])
	transports["STORMWIND_TWILIGHTHIGHLANDS_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Twilight Highlands"])
	transports["STORMWIND_ULDUM_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Uldum"])
	transports["STORMWIND_VASHJIR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Stormwind City"], BZ["Vashj'ir"])
	transports["THUNDERBLUFF_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Thunder Bluff"], BZ["Hellfire Peninsula"])
	transports["TOLBARAD_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Tol Barad Peninsula"], BZ["Orgrimmar"])
	transports["TOLBARAD_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Tol Barad Peninsula"], BZ["Stormwind City"])
	transports["TOWNLONGSTEPPES_ISLEOFTHUNDER_PORTAL"] = string.format(X_Y_PORTAL, BZ["Townlong Steppes"], BZ["Isle of Thunder"])
	transports["TWILIGHTHIGHLANDS_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Twilight Highlands"], BZ["Orgrimmar"])
	transports["TWILIGHTHIGHLANDS_STORMWIND_PORTAL"] = string.format(X_Y_PORTAL, BZ["Twilight Highlands"], BZ["Stormwind City"])
	transports["TWOMOONS_DALARAN_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Two Moons"], BZ["Dalaran"])
	transports["TWOMOONS_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Two Moons"], BZ["Orgrimmar"])
	transports["TWOMOONS_SHATTRATH_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Two Moons"], BZ["Shattrath City"])
	transports["TWOMOONS_SILVERMOON_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Two Moons"], BZ["Silvermoon City"])
	transports["TWOMOONS_THUNDERBLUFF_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Two Moons"], BZ["Thunder Bluff"])
	transports["TWOMOONS_UNDERCITY_PORTAL"] = string.format(X_Y_PORTAL, BZ["Shrine of Two Moons"], BZ["Undercity"])
	transports["UNDERCITY_HELLFIRE_PORTAL"] = string.format(X_Y_PORTAL, BZ["Undercity"], BZ["Hellfire Peninsula"])
	transports["WARSPEAR_ORGRIMMAR_PORTAL"] = string.format(X_Y_PORTAL, BZ["Warspear"], BZ["Orgrimmar"])
	transports["WARSPEAR_THUNDERBLUFF_PORTAL"] = string.format(X_Y_PORTAL, BZ["Warspear"], BZ["Thunder Bluff"])
	transports["WARSPEAR_UNDERCITY_PORTAL"] = string.format(X_Y_PORTAL, BZ["Warspear"], BZ["Undercity"])

	
	
	local zones = {}

	-- CONTINENTS ---------------------------------------------------------------

	zones[BZ["Azeroth"]] = {
		type = "Continent",
--		yards = 44531.82907938571,
		yards = 33400.121,
		x_offset = 0,
		y_offset = 0,
		continent = Azeroth,
	}
	
	zones[BZ["Eastern Kingdoms"]] = {
		type = "Continent",
		continent = Eastern_Kingdoms,
	}

	zones[BZ["Kalimdor"]] = {
		type = "Continent",
		continent = Kalimdor,
	}

	zones[BZ["Outland"]] = {
		type = "Continent",
		continent = Outland,
	}

	zones[BZ["Northrend"]] = {
		type = "Continent",
		continent = Northrend,
	}

	zones[BZ["The Maelstrom"]] = {
		type = "Continent",
		continent = The_Maelstrom,
	}

	zones[BZ["Pandaria"]] = {
		type = "Continent",
		continent = Pandaria,
	}

	zones[BZ["Draenor"]] = {
		type = "Continent",
		continent = Draenor,
	}

	zones[BZ["Broken Isles"]] = {
		type = "Continent",
		continent = BrokenIsles,
	}

	zones[BZ["Argus"]] = {
		type = "Continent",
		continent = Argus,
	}
	
	-- TRANSPORTS ---------------------------------------------------------------

	zones[transports["STORMWIND_BOREANTUNDRA_BOAT"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
			[BZ["Borean Tundra"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_BOREANTUNDRA_ZEPPELIN"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
			[BZ["Borean Tundra"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["UNDERCITY_HOWLINGFJORD_ZEPPELIN"]] = {
		paths = {
			[BZ["Tirisfal Glades"]] = true,
			[BZ["Howling Fjord"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_BLASTEDLANDS_PORTAL"]] = {
		paths = {
			[BZ["Blasted Lands"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["HELLFIRE_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["UNDERCITY_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["THUNDERBLUFF_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["SILVERMOON_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["STORMWIND_BLASTEDLANDS_PORTAL"]] = {
		paths = {
			[BZ["Blasted Lands"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	
	zones[transports["HELLFIRE_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DALARAN_STORMWIND_PORTAL"]] = {
		paths = BZ["Stormwind City"],
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DALARAN_ORGRIMMAR_PORTAL"]] = {
		paths = BZ["Orgrimmar"],
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DARNASSUS_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["EXODAR_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DARNASSUS_EXODAR_PORTAL"]] = {
		paths = {
			[BZ["The Exodar"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["EXODAR_DARNASSUS_PORTAL"]] = {
		paths = {
			[BZ["Darnassus"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}


	zones[transports["MULGORE_DARKMOON_PORTAL"]] = {
		paths = BZ["Darkmoon Island"],
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DARKMOON_MULGORE_PORTAL"]] = {
		paths = BZ["Mulgore"],
		faction = "Horde",
		type = "Transport",
	}


	zones[transports["ELWYNNFOREST_DARKMOON_PORTAL"]] = {
		paths = BZ["Darkmoon Island"],
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DARKMOON_ELWYNNFOREST_PORTAL"]] = {
		paths = BZ["Elwynn Forest"],
		faction = "Alliance",
		type = "Transport",
	}



	zones[transports["IRONFORGE_HELLFIRE_PORTAL"]] = {
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TELDRASSIL_STORMWIND_BOAT"]] = {
		paths = {
			[BZ["Teldrassil"]] = true,
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TELDRASSIL_AZUREMYST_BOAT"]] = {
		paths = {
			[BZ["Teldrassil"]] = true,
			[BZ["Azuremyst Isle"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["BOOTYBAY_RATCHET_BOAT"]] = {
		paths = {
			[BZ["The Cape of Stranglethorn"]] = true,
			[BZ["Northern Barrens"]] = true,
		},
		type = "Transport",
	}

	zones[transports["MENETHIL_HOWLINGFJORD_BOAT"]] = {
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Howling Fjord"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["MENETHIL_THERAMORE_BOAT"]] = {
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Dustwallow Marsh"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_GROMGOL_ZEPPELIN"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
			[BZ["Northern Stranglethorn"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_UNDERCITY_ZEPPELIN"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
			[BZ["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_THUNDERBLUFF_ZEPPELIN"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
			[BZ["Thunder Bluff"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["SHATTRATH_QUELDANAS_PORTAL"]] = {
		paths = BZ["Isle of Quel'Danas"],
		type = "Transport",
	}

	zones[transports["SHATTRATH_ORGRIMMAR_PORTAL"]] = {
		paths = BZ["Orgrimmar"],
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["SHATTRATH_STORMWIND_PORTAL"]] = {
		paths = BZ["Stormwind City"],
		faction = "Alliance",
		type = "Transport",
	}


	zones[transports["MOAKI_UNUPE_BOAT"]] = {
		paths = {
			[BZ["Dragonblight"]] = true,
			[BZ["Borean Tundra"]] = true,
		},
		type = "Transport",
	}

	zones[transports["MOAKI_KAMAGUA_BOAT"]] = {
		paths = {
			[BZ["Dragonblight"]] = true,
			[BZ["Howling Fjord"]] = true,
		},
		type = "Transport",
	}

	zones[BZ["The Dark Portal"]] = {
		paths = {
			[BZ["Blasted Lands"]] = true,
			[BZ["Hellfire Peninsula"]] = true,
		},
		type = "Transport",
	}

	zones[BZ["Deeprun Tram"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Stormwind City"]] = true,
			[BZ["Ironforge"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["UNDERCITY_GROMGOL_ZEPPELIN"]] = {
		paths = {
			[BZ["Northern Stranglethorn"]] = true,
			[BZ["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["SILVERMOON_UNDERCITY_TELEPORT"]] = {
		paths = {
			[BZ["Silvermoon City"]] = true,
			[BZ["Undercity"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DALARAN_CRYSTALSONG_TELEPORT"]] = {
		paths = {
			[BZ["Dalaran"]] = true,
			[BZ["Crystalsong Forest"]] = true,
		},
		type = "Transport",
	}

	zones[transports["DALARAN_COT_PORTAL"]] = {
		paths = BZ["Caverns of Time"],
		type = "Transport",
	}


	zones[transports["STORMWIND_TWILIGHTHIGHLANDS_PORTAL"]] = {
		paths = {
			[BZ["Twilight Highlands"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TWILIGHTHIGHLANDS_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_MOUNTHYJAL_PORTAL"]] = {
		paths = {
			[BZ["Mount Hyjal"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_DEEPHOLM_PORTAL"]] = {
		paths = {
			[BZ["Deepholm"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DEEPHOLM_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["TOLBARAD_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_ULDUM_PORTAL"]] = {
		paths = {
			[BZ["Uldum"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_VASHJIR_PORTAL"]] = {
		paths = {
			[BZ["Vashj'ir"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMWIND_TOLBARAD_PORTAL"]] = {
		paths = {
			[BZ["Tol Barad Peninsula"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_TWILIGHTHIGHLANDS_PORTAL"]] = {
		paths = {
			[BZ["Twilight Highlands"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["TWILIGHTHIGHLANDS_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_MOUNTHYJAL_PORTAL"]] = {
		paths = {
			[BZ["Mount Hyjal"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_DEEPHOLM_PORTAL"]] = {
		paths = {
			[BZ["Deepholm"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DEEPHOLM_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["TOLBARAD_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_ULDUM_PORTAL"]] = {
		paths = {
			[BZ["Uldum"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_VASHJIR_PORTAL"]] = {
		paths = {
			[BZ["Vashj'ir"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["ORGRIMMAR_TOLBARAD_PORTAL"]] = {
		paths = {
			[BZ["Tol Barad Peninsula"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	
	zones[transports["ORGRIMMAR_JADEFOREST_PORTAL"]] = {
		paths = {
			[BZ["The Jade Forest"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["JADEFOREST_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["STORMWIND_JADEFOREST_PORTAL"]] = {
		paths = {
			[BZ["The Jade Forest"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["JADEFOREST_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	zones[transports["TOWNLONGSTEPPES_ISLEOFTHUNDER_PORTAL"]] = {
		paths = {
			[BZ["Isle of Thunder"]] = true,
		},
		type = "Transport",
	}	

	zones[transports["ISLEOFTHUNDER_TOWNLONGSTEPPES_PORTAL"]] = {
		paths = {
			[BZ["Townlong Steppes"]] = true,
		},
		type = "Transport",
	}	

	zones[transports["WARSPEAR_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["WARSPEAR_UNDERCITY_PORTAL"]] = {
		paths = {
			[BZ["Undercity"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["WARSPEAR_THUNDERBLUFF_PORTAL"]] = {
		paths = {
			[BZ["Thunder Bluff"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	
	zones[transports["STORMSHIELD_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	zones[transports["STORMSHIELD_IRONFORGE_PORTAL"]] = {
		paths = {
			[BZ["Ironforge"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["STORMSHIELD_DARNASSUS_PORTAL"]] = {
		paths = {
			[BZ["Darnassus"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["SHADOWMOONVALLEY_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	zones[transports["FROSTFIRERIDGE_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	

	
	zones[transports["TWOMOONS_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	
	zones[transports["TWOMOONS_UNDERCITY_PORTAL"]] = {
		paths = {
			[BZ["Undercity"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["TWOMOONS_THUNDERBLUFF_PORTAL"]] = {
		paths = {
			[BZ["Thunder Bluff"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	
	zones[transports["TWOMOONS_SILVERMOON_PORTAL"]] = {
		paths = {
			[BZ["Silvermoon City"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["TWOMOONS_SHATTRATH_PORTAL"]] = {
		paths = {
			[BZ["Shattrath City"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["TWOMOONS_DALARAN_PORTAL"]] = {
		paths = {
			[BZ["Dalaran"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	
	zones[transports["SEVENSTARS_EXODAR_PORTAL"]] = {
		paths = {
			[BZ["The Exodar"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["SEVENSTARS_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["SEVENSTARS_IRONFORGE_PORTAL"]] = {
		paths = {
			[BZ["Ironforge"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["SEVENSTARS_DARNASSUS_PORTAL"]] = {
		paths = {
			[BZ["Darnassus"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["SEVENSTARS_SHATTRATH_PORTAL"]] = {
		paths = {
			[BZ["Shattrath City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["SEVENSTARS_DALARAN_PORTAL"]] = {
		paths = {
			[BZ["Dalaran"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	
	zones[transports["DALARANBROKENISLES_STORMWIND_PORTAL"]] = {
		paths = {
			[BZ["Stormwind City"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DALARANBROKENISLES_EXODAR_PORTAL"]] = {
		paths = {
			[BZ["The Exodar"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["DALARANBROKENISLES_DARNASSUS_PORTAL"]] = {
		paths = {
			[BZ["Darnassus"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["DALARANBROKENISLES_IRONFORGE_PORTAL"]] = {
		paths = {
			[BZ["Ironforge"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[transports["DALARANBROKENISLES_SEVENSTARS_PORTAL"]] = {
		paths = {
			[BZ["Shrine of Seven Stars"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[transports["DALARANBROKENISLES_ORGRIMMAR_PORTAL"]] = {
		paths = {
			[BZ["Orgrimmar"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[transports["DALARANBROKENISLES_UNDERCITY_PORTAL"]] = {
		paths = {
			[BZ["Undercity"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DALARANBROKENISLES_THUNDERBLUFF_PORTAL"]] = {
		paths = {
			[BZ["Thunder Bluff"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DALARANBROKENISLES_SILVERMOON_PORTAL"]] = {
		paths = {
			[BZ["Silvermoon City"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[transports["DALARANBROKENISLES_TWOMOONS_PORTAL"]] = {
		paths = {
			[BZ["Shrine of Two Moons"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	
	zones[transports["DALARANBROKENISLES_COT_PORTAL"]] = {
		paths = {
			[BZ["Caverns of Time"]] = true,
		},
		type = "Transport",
	}	
	
	zones[transports["DALARANBROKENISLES_SHATTRATH_PORTAL"]] = {
		paths = {
			[BZ["Shattrath City"]] = true,
		},
		type = "Transport",
	}	
	
	zones[transports["DALARANBROKENISLES_DRAGONBLIGHT_PORTAL"]] = {
		paths = {
			[BZ["Dragonblight"]] = true,
		},
		type = "Transport",
	}	
	
	zones[transports["DALARANBROKENISLES_HILLSBRAD_PORTAL"]] = {
		paths = {
			[BZ["Hillsbrad Foothills"]] = true,
		},
		type = "Transport",
	}	
	
	zones[transports["DALARANBROKENISLES_KARAZHAN_PORTAL"]] = {
		paths = {
			[BZ["Karazhan"]] = true,
		},
		type = "Transport",
	}	
	
	zones[transports["ORGRIMMAR_DALARANBROKENISLES_PORTAL"]] = {
		paths = {
			[BZ["Dalaran"].." ("..BZ["Broken Isles"]..")"] = true,
		},
		faction = "Horde",
		type = "Transport",
	}	
	
	zones[transports["STORMWIND_DALARANBROKENISLES_PORTAL"]] = {
		paths = {
			[BZ["Dalaran"].." ("..BZ["Broken Isles"]..")"] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}	

	
	-- ZONES, INSTANCES AND COMPLEXES ---------------------------------------------------------

	-- Eastern Kingdoms cities and zones --
	
	zones[BZ["Stormwind City"]] = {
		continent = Eastern_Kingdoms,
		instances = BZ["The Stockade"],
		paths = {
			[BZ["Deeprun Tram"]] = true,
			[BZ["The Stockade"]] = true,
			[BZ["Elwynn Forest"]] = true,
			[transports["TELDRASSIL_STORMWIND_BOAT"]] = true,
			[transports["STORMWIND_BOREANTUNDRA_BOAT"]] = true,
			[transports["STORMWIND_BLASTEDLANDS_PORTAL"]] = true,
			[transports["STORMWIND_HELLFIRE_PORTAL"]] = true,
			[transports["STORMWIND_TWILIGHTHIGHLANDS_PORTAL"]] = true,
			[transports["STORMWIND_MOUNTHYJAL_PORTAL"]] = true,
			[transports["STORMWIND_DEEPHOLM_PORTAL"]] = true,
			[transports["STORMWIND_ULDUM_PORTAL"]] = true,
			[transports["STORMWIND_VASHJIR_PORTAL"]] = true,
			[transports["STORMWIND_TOLBARAD_PORTAL"]] = true,
			[transports["STORMWIND_JADEFOREST_PORTAL"]] = true,
			[transports["STORMWIND_DALARANBROKENISLES_PORTAL"]] = true,
		},
		faction = "Alliance",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 1,
	}
	
	zones[BZ["Undercity"]] = {
		continent = Eastern_Kingdoms,
		instances = BZ["Ruins of Lordaeron"],
		paths = {
			[BZ["Tirisfal Glades"]] = true,
			[transports["SILVERMOON_UNDERCITY_TELEPORT"]] = true,
			[transports["UNDERCITY_HELLFIRE_PORTAL"]] = true,
		},
		faction = "Horde",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 3,
	}	
	
	zones[BZ["Ironforge"]] = {
		continent = Eastern_Kingdoms,
		instances = BZ["Gnomeregan"],
		paths = {
			[BZ["Dun Morogh"]] = true,
			[BZ["Deeprun Tram"]] = true,
			[transports["IRONFORGE_HELLFIRE_PORTAL"]] = true,
		},
		faction = "Alliance",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 3,
	}

	zones[BZ["Silvermoon City"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Eversong Woods"]] = true,
			[transports["SILVERMOON_UNDERCITY_TELEPORT"]] = true,
			[transports["SILVERMOON_HELLFIRE_PORTAL"]] = true,
		},
		faction = "Horde",
		type = "City",
		battlepet_low = 1,
		battlepet_high = 3,
	}
	
	
	zones[BZ["Northshire"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Elwynn Forest"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}

	zones[BZ["Sunstrider Isle"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Eversong Woods"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}

	zones[BZ["Deathknell"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}	
	
	zones[BZ["Coldridge Valley"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Dun Morogh"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}
	
	zones[BZ["New Tinkertown"]] = {
		low = 1,
		high = 6,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Dun Morogh"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}	
	
	
	
	zones[BZ["Dun Morogh"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		instances = BZ["Gnomeregan"],
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Gnomeregan"]] = true,
			[BZ["Ironforge"]] = true,
			[BZ["Loch Modan"]] = true,
			[BZ["Coldridge Valley"]] = true,
			[BZ["New Tinkertown"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Elwynn Forest"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Northshire"]] = true,
			[BZ["Westfall"]] = true,
			[BZ["Redridge Mountains"]] = true,
			[BZ["Stormwind City"]] = true,
			[BZ["Duskwood"]] = true,
			[BZ["Burning Steppes"]] = true,
			[transports["ELWYNNFOREST_DARKMOON_PORTAL"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Eversong Woods"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Silvermoon City"]] = true,
			[BZ["Ghostlands"]] = true,
			[BZ["Sunstrider Isle"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Gilneas"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {},  -- phased instance
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 1,
	}	
	
	zones[BZ["Gilneas City"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {},  -- phased instance
		faction = "Alliance",
		battlepet_low = 1,
		battlepet_high = 2,
	}

	zones[BZ["Ruins of Gilneas"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Silverpine Forest"]] = true,
			[BZ["Ruins of Gilneas City"]] = true,
		},
		fishing_min = 75,
	}

	zones[BZ["Ruins of Gilneas City"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Silverpine Forest"]] = true,
			[BZ["Ruins of Gilneas"]] = true,
		},
		fishing_min = 75,
	}
	
	zones[BZ["Tirisfal Glades"]] = {
		low = 1,
		high = 20,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Scarlet Monastery"]] = true,
			[BZ["Scarlet Halls"]] = true,
		},
		paths = {
			[BZ["Western Plaguelands"]] = true,
			[BZ["Undercity"]] = true,
			[BZ["Scarlet Monastery"]] = true,
			[BZ["Scarlet Halls"]] = true,
			[transports["UNDERCITY_GROMGOL_ZEPPELIN"]] = true,
			[transports["ORGRIMMAR_UNDERCITY_ZEPPELIN"]] = true,
			[transports["UNDERCITY_HOWLINGFJORD_ZEPPELIN"]] = true,
			[BZ["Silverpine Forest"]] = true,
			[BZ["Deathknell"]] = true,
		},
--		complexes = {
--			[BZ["Scarlet Monastery"]] = true,   -- Duplicate name with instance (thanks, Blizz)
--		},
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Westfall"]] = {
		low = 10,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["The Deadmines"],
		paths = {
			[BZ["Duskwood"]] = true,
			[BZ["Elwynn Forest"]] = true,
			[BZ["The Deadmines"]] = true,
		},
		faction = "Alliance",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 4,
	}	
	
	zones[BZ["Ghostlands"]] = {
		low = 10,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Zul'Aman"],
		paths = {
			[BZ["Eastern Plaguelands"]] = true,
			[BZ["Zul'Aman"]] = true,
			[BZ["Eversong Woods"]] = true,
		},
		faction = "Horde",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}

	zones[BZ["Loch Modan"]] = {
		low = 10,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Badlands"]] = true,
			[BZ["Dun Morogh"]] = true,
			[BZ["Searing Gorge"]] = not isHorde and true or nil,
		},
		faction = "Alliance",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}

	zones[BZ["Silverpine Forest"]] = {
		low = 10,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Shadowfang Keep"],
		paths = {
			[BZ["Tirisfal Glades"]] = true,
			[BZ["Hillsbrad Foothills"]] = true,
			[BZ["Shadowfang Keep"]] = true,
			[BZ["Ruins of Gilneas"]] = true,
		},
		faction = "Horde",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}

	zones[BZ["Redridge Mountains"]] = {
		low = 15,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Burning Steppes"]] = true,
			[BZ["Elwynn Forest"]] = true,
			[BZ["Duskwood"]] = true,
			[BZ["Swamp of Sorrows"]] = true,
		},
		fishing_min = 75,
		battlepet_low = 4,
		battlepet_high = 6,
	}
	
	zones[BZ["Duskwood"]] = {
		low = 20,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Redridge Mountains"]] = true,
			[BZ["Northern Stranglethorn"]] = true,
			[BZ["Westfall"]] = true,
			[BZ["Deadwind Pass"]] = true,
			[BZ["Elwynn Forest"]] = true,
		},
		fishing_min = 150,
		battlepet_low = 5,
		battlepet_high = 7,
	}	
	
	zones[BZ["Hillsbrad Foothills"]] = {
		low = 15,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Alterac Valley"],
		paths = {
			[BZ["Alterac Valley"]] = true,
			[BZ["The Hinterlands"]] = true,
			[BZ["Arathi Highlands"]] = true,
			[BZ["Silverpine Forest"]] = true,
			[BZ["Western Plaguelands"]] = true,
		},
		faction = "Horde",
		fishing_min = 150,
		battlepet_low = 6,
		battlepet_high = 7,
	}

	zones[BZ["Wetlands"]] = {
		low = 25,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Arathi Highlands"]] = true,
			[transports["MENETHIL_THERAMORE_BOAT"]] = true,
			[transports["MENETHIL_HOWLINGFJORD_BOAT"]] = true,
			[BZ["Dun Morogh"]] = true,
			[BZ["Loch Modan"]] = true,
		},
		fishing_min = 150,
		battlepet_low = 6,
		battlepet_high = 7,
	}

	zones[BZ["Arathi Highlands"]] = {
		low = 25,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Arathi Basin"],
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Hillsbrad Foothills"]] = true,
			[BZ["Arathi Basin"]] = true,
			[BZ["The Hinterlands"]] = true,
		},
		fishing_min = 150,
		battlepet_low = 7,
		battlepet_high = 8,
	}

	zones[BZ["Stranglethorn Vale"]] = {
		low = 25,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Zul'Gurub"],
		paths = {
			[BZ["Duskwood"]] = true,
			[BZ["Zul'Gurub"]] = true,
			[transports["ORGRIMMAR_GROMGOL_ZEPPELIN"]] = true,
			[transports["UNDERCITY_GROMGOL_ZEPPELIN"]] = true,
			[transports["BOOTYBAY_RATCHET_BOAT"]] = true,
		},
		fishing_min = 150,
		battlepet_low = 7,
		battlepet_high = 10,
	}
	
	zones[BZ["Northern Stranglethorn"]] = {
		low = 25,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Zul'Gurub"],
		paths = {
			[BZ["The Cape of Stranglethorn"]] = true,
			[BZ["Duskwood"]] = true,
			[BZ["Zul'Gurub"]] = true,
			[transports["ORGRIMMAR_GROMGOL_ZEPPELIN"]] = true,
			[transports["UNDERCITY_GROMGOL_ZEPPELIN"]] = true,
		},
		fishing_min = 150,
		battlepet_low = 7,
		battlepet_high = 9,
	}

	zones[BZ["The Cape of Stranglethorn"]] = {
		low = 30,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[transports["BOOTYBAY_RATCHET_BOAT"]] = true,
			["Northern Stranglethorn"] = true,
		},
		fishing_min = 225,
		battlepet_low = 9,
		battlepet_high = 10,
	}

	zones[BZ["The Hinterlands"]] = {
		low = 30,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Hillsbrad Foothills"]] = true,
			[BZ["Western Plaguelands"]] = true,
			[BZ["Arathi Highlands"]] = true,
		},
		fishing_min = 225,
		battlepet_low = 11,
		battlepet_high = 12,
	}

	zones[BZ["Western Plaguelands"]] = {
		low = 35,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Scholomance"],
		paths = {
			[BZ["The Hinterlands"]] = true,
			[BZ["Eastern Plaguelands"]] = true,
			[BZ["Tirisfal Glades"]] = true,
			[BZ["Scholomance"]] = true,
			[BZ["Hillsbrad Foothills"]] = true,
		},
		fishing_min = 225,
		battlepet_low = 10,
		battlepet_high = 11,
	}

	zones[BZ["Eastern Plaguelands"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Stratholme"],
		paths = {
			[BZ["Western Plaguelands"]] = true,
			[BZ["Stratholme"]] = true,
			[BZ["Ghostlands"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 300,
		battlepet_low = 12,
		battlepet_high = 13,
	}

	zones[BZ["Badlands"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Uldaman"],
		paths = {
			[BZ["Uldaman"]] = true,
			[BZ["Searing Gorge"]] = true,
			[BZ["Loch Modan"]] = true,
		},
		fishing_min = 300,
		battlepet_low = 13,
		battlepet_high = 14,
	}	
	
	zones[BZ["Searing Gorge"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Blackrock Depths"]] = true,
			[BZ["Blackrock Caverns"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Spire"]] = true,
			[BZ["Upper Blackrock Spire"]] = true,
		},
		paths = {
			[BZ["Blackrock Mountain"]] = true,
			[BZ["Badlands"]] = true,
			[BZ["Loch Modan"]] = not isHorde and true or nil,
		},
		complexes = {
			[BZ["Blackrock Mountain"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 13,
		battlepet_high = 14,
	}	
	
	zones[BZ["Burning Steppes"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Blackrock Depths"]] = true,
			[BZ["Blackrock Caverns"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Spire"]] = true,
			[BZ["Upper Blackrock Spire"]] = true,
		},
		paths = {
			[BZ["Blackrock Mountain"]] = true,
			[BZ["Redridge Mountains"]] = true,
			[BZ["Elwynn Forest"]] = true,
		},
		complexes = {
			[BZ["Blackrock Mountain"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 15,
		battlepet_high = 16,
	}	
	
	zones[BZ["Swamp of Sorrows"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["The Temple of Atal'Hakkar"],
		paths = {
			[BZ["Blasted Lands"]] = true,
			[BZ["Deadwind Pass"]] = true,
			[BZ["The Temple of Atal'Hakkar"]] = true,
			[BZ["Redridge Mountains"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 14,
		battlepet_high = 15,
	}

	zones[BZ["Blasted Lands"]] = {
		low = 40,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["The Dark Portal"]] = true,
			[BZ["Swamp of Sorrows"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 16,
		battlepet_high = 17,
	}

	zones[BZ["Deadwind Pass"]] = {
		low = 50,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = BZ["Karazhan"],
		paths = {
			[BZ["Duskwood"]] = true,
			[BZ["Swamp of Sorrows"]] = true,
			[BZ["Karazhan"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 17,
		battlepet_high = 18,
	}

	-- DK starting zone
	zones[BZ["Plaguelands: The Scarlet Enclave"]] = {
		low = 55,
		high = 58,
		continent = Eastern_Kingdoms,
		yards = 3162.5,
		x_offset = 0,
		y_offset = 0,
		texture = "ScarletEnclave",
	}

	zones[BZ["Isle of Quel'Danas"]] = {
		continent = Eastern_Kingdoms,
		low = 70,
		high = 70,
		paths = {
			[BZ["Magisters' Terrace"]] = true,
			[BZ["Sunwell Plateau"]] = true,
		},
		instances = {
			[BZ["Magisters' Terrace"]] = true,
			[BZ["Sunwell Plateau"]] = true,
		},
		fishing_min = 450,
		battlepet_low = 20,
		battlepet_high = 20,
	}
	
	zones[BZ["Vashj'ir"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Throne of the Tides"]] = true,
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 23,
	}

	zones[BZ["Kelp'thar Forest"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Shimmering Expanse"]] = true,
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 23,
	}

	zones[BZ["Shimmering Expanse"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Kelp'thar Forest"]] = true,
			[BZ["Abyssal Depths"]] = true,
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 23,
	}

	zones[BZ["Abyssal Depths"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Throne of the Tides"]] = true,
		},
		paths = {
			[BZ["Shimmering Expanse"]] = true,
			[BZ["Throne of the Tides"]] = true,
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Twilight Highlands"]] = {
		low = 84,
		high = 90,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Grim Batol"]] = true,
			[BZ["The Bastion of Twilight"]] = true,
			[BZ["Twin Peaks"]] = true,
		},
		paths = {
			[BZ["Wetlands"]] = true,
			[BZ["Grim Batol"]] = true,
			[BZ["Twin Peaks"]] = true,
			[transports["TWILIGHTHIGHLANDS_STORMWIND_PORTAL"]] = true,
			[transports["TWILIGHTHIGHLANDS_ORGRIMMAR_PORTAL"]] = true,
		},
		fishing_min = 650,
		battlepet_low = 23,
		battlepet_high = 24,
	}	
	
	zones[BZ["Tol Barad"]] = {
		low = 84,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Tol Barad Peninsula"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 675,
		battlepet_low = 23,
		battlepet_high = 24,
	}

	zones[BZ["Tol Barad Peninsula"]] = {
		low = 84,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Tol Barad"]] = true,
			[transports["TOLBARAD_ORGRIMMAR_PORTAL"]] = true,
			[transports["TOLBARAD_STORMWIND_PORTAL"]] = true,
		},
		fishing_min = 675,
		battlepet_low = 23,
		battlepet_high = 24,
	}	
	
	zones[BZ["Amani Pass"]] = {
		continent = Eastern_Kingdoms,
	}	



	-- Kalimdor cities and zones --
	
	zones[BZ["Orgrimmar"]] = {
		continent = Kalimdor,
		instances = {
			[BZ["Ragefire Chasm"]] = true,
			[BZ["The Ring of Valor"]] = true,
		},
		paths = {
			[BZ["Durotar"]] = true,
			[BZ["Ragefire Chasm"]] = true,
			[BZ["Azshara"]] = true,
			[transports["ORGRIMMAR_UNDERCITY_ZEPPELIN"]] = true,
			[transports["ORGRIMMAR_GROMGOL_ZEPPELIN"]] = true,
			[transports["ORGRIMMAR_BOREANTUNDRA_ZEPPELIN"]] = true,
			[transports["ORGRIMMAR_THUNDERBLUFF_ZEPPELIN"]] = true,
			[transports["ORGRIMMAR_BLASTEDLANDS_PORTAL"]] = true,
			[transports["ORGRIMMAR_HELLFIRE_PORTAL"]] = true,
			[transports["ORGRIMMAR_TWILIGHTHIGHLANDS_PORTAL"]] = true,
			[transports["ORGRIMMAR_MOUNTHYJAL_PORTAL"]] = true,
			[transports["ORGRIMMAR_DEEPHOLM_PORTAL"]] = true,
			[transports["ORGRIMMAR_ULDUM_PORTAL"]] = true,
			[transports["ORGRIMMAR_VASHJIR_PORTAL"]] = true,
			[transports["ORGRIMMAR_TOLBARAD_PORTAL"]] = true,
			[transports["ORGRIMMAR_JADEFOREST_PORTAL"]] = true,
			[transports["ORGRIMMAR_DALARANBROKENISLES_PORTAL"]] = true,
		},
		faction = "Horde",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 1,
	}
	
	zones[BZ["Thunder Bluff"]] = {
		continent = Kalimdor,
		paths = {
			[BZ["Mulgore"]] = true,
			[transports["ORGRIMMAR_THUNDERBLUFF_ZEPPELIN"]] = true,
			[transports["THUNDERBLUFF_HELLFIRE_PORTAL"]] = true,
		},
		faction = "Horde",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 2,
	}
	
	zones[BZ["The Exodar"]] = {
		continent = Kalimdor,
		paths = {
			[BZ["Azuremyst Isle"]] = true,
			[transports["EXODAR_HELLFIRE_PORTAL"]] = true,
			[transports["EXODAR_DARNASSUS_PORTAL"]] = true,
		},
		faction = "Alliance",
		type = "City",
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Darnassus"]] = {
		continent = Kalimdor,
		paths = {
			[BZ["Teldrassil"]] = true,
			[transports["DARNASSUS_HELLFIRE_PORTAL"]] = true,
			[transports["DARNASSUS_EXODAR_PORTAL"]] = true,
		},
		faction = "Alliance",
		type = "City",
		fishing_min = 75,
		battlepet_low = 1,
		battlepet_high = 2,
	}



	zones[BZ["Ammen Vale"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Azuremyst Isle"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}
	
	zones[BZ["Valley of Trials"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Durotar"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}
	
	zones[BZ["Echo Isles"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Durotar"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}

	zones[BZ["Camp Narache"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Mulgore"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
	}
	
	zones[BZ["Shadowglen"]] = {
		low = 1,
		high = 6,
		continent = Kalimdor,
		paths = {
			[BZ["Teldrassil"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
	}	
	
	
	zones[BZ["Azuremyst Isle"]] = {
		low = 1,
		high = 20,
		continent = Kalimdor,
		paths = {
			[BZ["The Exodar"]] = true,
			[BZ["Ammen Vale"]] = true,
			[BZ["Bloodmyst Isle"]] = true,
			[transports["TELDRASSIL_AZUREMYST_BOAT"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Durotar"]] = {
		low = 1,
		high = 20,
		continent = Kalimdor,
		instances = BZ["Ragefire Chasm"],
		paths = {
			[BZ["Northern Barrens"]] = true,
			[BZ["Orgrimmar"]] = true,
			[BZ["Valley of Trials"]] = true,
			[BZ["Echo Isles"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Mulgore"]] = {
		low = 1,
		high = 20,
		continent = Kalimdor,
		paths = {
			[BZ["Thunder Bluff"]] = true,
			[BZ["Southern Barrens"]] = true,
			[transports["MULGORE_DARKMOON_PORTAL"]] = true,
		},
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Teldrassil"]] = {
		low = 1,
		high = 20,
		continent = Kalimdor,
		paths = {
			[BZ["Darnassus"]] = true,
			[BZ["Shadowglen"]] = true,
			[transports["TELDRASSIL_AZUREMYST_BOAT"]] = true,
			[transports["TELDRASSIL_STORMWIND_BOAT"]] = true,
		},
		faction = "Alliance",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["Azshara"]] = {
		low = 10,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Ashenvale"],
		paths = BZ["Orgrimmar"],
		fishing_min = 75,
		faction = "Horde",
		battlepet_low = 3,
		battlepet_high = 6,
	}	
	
	zones[BZ["Bloodmyst Isle"]] = {
		low = 10,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Azuremyst Isle"],
		faction = "Alliance",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}	
	
	zones[BZ["Darkshore"]] = {
		low = 10,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Ashenvale"]] = true,
		},
		faction = "Alliance",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 6,
	}

	zones[BZ["Northern Barrens"]] = {
		low = 10,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Wailing Caverns"]] = true,
			[BZ["Warsong Gulch"]] = isHorde and true or nil,
		},
		paths = {
			[BZ["Southern Barrens"]] = true,
			[BZ["Ashenvale"]] = true,
			[BZ["Durotar"]] = true,
			[BZ["Wailing Caverns"]] = true,
			[transports["BOOTYBAY_RATCHET_BOAT"]] = true,
			[BZ["Warsong Gulch"]] = isHorde and true or nil,
			[BZ["Stonetalon Mountains"]] = true,
		},
		faction = "Horde",
		fishing_min = 75,
		battlepet_low = 3,
		battlepet_high = 4,
	}

	zones[BZ["Ashenvale"]] = {
		low = 15,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Blackfathom Deeps"]] = true,
			[BZ["Warsong Gulch"]] = not isHorde and true or nil,
		},
		paths = {
			[BZ["Azshara"]] = true,
			[BZ["Northern Barrens"]] = true,
			[BZ["Blackfathom Deeps"]] = true,
			[BZ["Warsong Gulch"]] = not isHorde and true or nil,
			[BZ["Felwood"]] = true,
			[BZ["Darkshore"]] = true,
			[BZ["Stonetalon Mountains"]] = true,
		},
		fishing_min = 150,
		battlepet_low = 4,
		battlepet_high = 6,
	}

	zones[BZ["Stonetalon Mountains"]] = {
		low = 20,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Desolace"]] = true,
			[BZ["Northern Barrens"]] = true,
			[BZ["Southern Barrens"]] = true,
			[BZ["Ashenvale"]] = true,
		},
		fishing_min = 150,
		battlepet_low = 5,
		battlepet_high = 7,
	}
	
	zones[BZ["Desolace"]] = {
		low = 30,
		high = 60,
		continent = Kalimdor,
		instances = BZ["Maraudon"],
		paths = {
			[BZ["Feralas"]] = true,
			[BZ["Stonetalon Mountains"]] = true,
			[BZ["Maraudon"]] = true,
		},
		fishing_min = 225,
		battlepet_low = 7,
		battlepet_high = 9,
	}	
	
	zones[BZ["Southern Barrens"]] = {
		low = 25,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Razorfen Kraul"]] = true,
		},
		paths = {
			[BZ["Northern Barrens"]] = true,
			[BZ["Thousand Needles"]] = true,
			[BZ["Razorfen Kraul"]] = true,
			[BZ["Dustwallow Marsh"]] = true,
			[BZ["Stonetalon Mountains"]] = true,
			[BZ["Mulgore"]] = true,
		},
		fishing_min = 225,
		battlepet_low = 9,
		battlepet_high = 10,
	}	
	
	zones[BZ["Dustwallow Marsh"]] = {
		low = 35,
		high = 60,
		continent = Kalimdor,
		instances = BZ["Onyxia's Lair"],
		paths = {
			[BZ["Onyxia's Lair"]] = true,
			[BZ["Southern Barrens"]] = true,
			[BZ["Thousand Needles"]] = true,
			[transports["MENETHIL_THERAMORE_BOAT"]] = true,
		},
		fishing_min = 225,
		battlepet_low = 12,
		battlepet_high = 13,
	}	
	
	zones[BZ["Feralas"]] = {
		low = 35,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Dire Maul (East)"]] = true,
			[BZ["Dire Maul (North)"]] = true,
			[BZ["Dire Maul (West)"]] = true,
		},
		paths = {
			[BZ["Thousand Needles"]] = true,
			[BZ["Desolace"]] = true,
			[BZ["Dire Maul"]] = true,
		},
		complexes = {
			[BZ["Dire Maul"]] = true,
		},
		fishing_min = 225,
		battlepet_low = 11,
		battlepet_high = 12,
	}	
	
	zones[BZ["Thousand Needles"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Razorfen Downs"]] = true,
		},
		paths = {
			[BZ["Feralas"]] = true,
			[BZ["Southern Barrens"]] = true,
			[BZ["Tanaris"]] = true,
			[BZ["Dustwallow Marsh"]] = true,
			[BZ["Razorfen Downs"]] = true,
		},
		fishing_min = 300,
		battlepet_low = 13,
		battlepet_high = 14,
	}	
	
	zones[BZ["Felwood"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Winterspring"]] = true,
			[BZ["Moonglade"]] = true,
			[BZ["Ashenvale"]] = true,
		},
		fishing_min = 300,
		battlepet_low = 14,
		battlepet_high = 15,
	}	
	
	zones[BZ["Tanaris"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Zul'Farrak"]] = true,
			[BZ["Old Hillsbrad Foothills"]] = true,
			[BZ["The Black Morass"]] = true,
			[BZ["Hyjal Summit"]] = true,
			[BZ["The Culling of Stratholme"]] = true,
			[BZ["End Time"]] = true,
			[BZ["Hour of Twilight"]] = true,
			[BZ["Well of Eternity"]] = true,
			[BZ["Dragon Soul"]] = true,
		},
		paths = {
			[BZ["Thousand Needles"]] = true,
			[BZ["Un'Goro Crater"]] = true,
			[BZ["Zul'Farrak"]] = true,
			[BZ["Caverns of Time"]] = true,
			[BZ["Uldum"]] = true,
		},
		complexes = {
			[BZ["Caverns of Time"]] = true,
		},
		fishing_min = 300,
		battlepet_low = 13,
		battlepet_high = 14,
	}

	zones[BZ["Un'Goro Crater"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Silithus"]] = true,
			[BZ["Tanaris"]] = true,
		},
		fishing_min = 375,
		battlepet_low = 15,
		battlepet_high = 16,
	}

	zones[BZ["Winterspring"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Felwood"]] = true,
			[BZ["Moonglade"]] = true,
			[BZ["Mount Hyjal"]] = true,
		},
		fishing_min = 425,
		battlepet_low = 17,
		battlepet_high = 18,
	}	
	
	zones[BZ["Silithus"]] = {
		low = 40,
		high = 60,
		continent = Kalimdor,
		paths = {
			[BZ["Ruins of Ahn'Qiraj"]] = true,
			[BZ["Un'Goro Crater"]] = true,
			[BZ["Ahn'Qiraj: The Fallen Kingdom"]] = true,
		},
		instances = {
			[BZ["Ahn'Qiraj"]] = true,
			[BZ["Ruins of Ahn'Qiraj"]] = true,
		},
		complexes = {
			[BZ["Ahn'Qiraj: The Fallen Kingdom"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 425,
		battlepet_low = 16,
		battlepet_high = 17,
	}

	zones[BZ["Moonglade"]] = {
		continent = Kalimdor,
		low = 1,
		high = 90,
		paths = {
			[BZ["Felwood"]] = true,
			[BZ["Winterspring"]] = true,
		},
		fishing_min = 300,
		battlepet_low = 15,
		battlepet_high = 16,
	}

	zones[BZ["Mount Hyjal"]] = {
		low = 80,
		high = 90,
		continent = Kalimdor,
		paths = {
			[BZ["Winterspring"]] = true,
		},
		instances = {
			[BZ["Firelands"]] = true,
		},
		fishing_min = 575,
		battlepet_low = 22,
		battlepet_high = 24,
	}

	zones[BZ["Uldum"]] = {
		low = 80,
		high = 90,
		continent = Kalimdor,
		paths = {
			[BZ["Tanaris"]] = true,
		},
		instances = {
			[BZ["Halls of Origination"]] = true,
			[BZ["Lost City of the Tol'vir"]] = true,
			[BZ["The Vortex Pinnacle"]] = true,
			[BZ["Throne of the Four Winds"]] = true,
		},
		fishing_min = 650,
		battlepet_low = 23,
		battlepet_high = 24,
	}

	zones[BZ["Molten Front"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		battlepet_low = 24,
		battlepet_high = 24,
	}
	
	
	
	
	-- Outland city and zones --
	
	zones[BZ["Shattrath City"]] = {
		continent = Outland,
		paths = {
			[BZ["Terokkar Forest"]] = true,
			[BZ["Nagrand"]] = true,
			[transports["SHATTRATH_QUELDANAS_PORTAL"]] = true,
			[transports["SHATTRATH_STORMWIND_PORTAL"]] = true,
			[transports["SHATTRATH_ORGRIMMAR_PORTAL"]] = true,
			},
		faction = "Sanctuary",
		type = "City",
		battlepet_low = 17,
		battlepet_high = 17,
	}
	
	
	
	zones[BZ["Hellfire Peninsula"]] = {
		low = 58,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Blood Furnace"]] = true,
			[BZ["Hellfire Ramparts"]] = true,
			[BZ["Magtheridon's Lair"]] = true,
			[BZ["The Shattered Halls"]] = true,
		},
		paths = {
			[BZ["Zangarmarsh"]] = true,
			[BZ["The Dark Portal"]] = true,
			[BZ["Terokkar Forest"]] = true,
			[BZ["Hellfire Citadel"]] = true,
			[transports["HELLFIRE_ORGRIMMAR_PORTAL"]] = true,
			[transports["HELLFIRE_STORMWIND_PORTAL"]] = true,
		},
		complexes = {
			[BZ["Hellfire Citadel"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 375,
		battlepet_low = 17,
		battlepet_high = 18,
	}	
	
	zones[BZ["Zangarmarsh"]] = {
		low = 60,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Underbog"]] = true,
			[BZ["Serpentshrine Cavern"]] = true,
			[BZ["The Steamvault"]] = true,
			[BZ["The Slave Pens"]] = true,
		},
		paths = {
			[BZ["Coilfang Reservoir"]] = true,
			[BZ["Blade's Edge Mountains"]] = true,
			[BZ["Terokkar Forest"]] = true,
			[BZ["Nagrand"]] = true,
			[BZ["Hellfire Peninsula"]] = true,
		},
		complexes = {
			[BZ["Coilfang Reservoir"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 400,
		battlepet_low = 18,
		battlepet_high = 19,
	}	
	
	zones[BZ["Terokkar Forest"]] = {
		low = 62,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["Mana-Tombs"]] = true,
			[BZ["Sethekk Halls"]] = true,
			[BZ["Shadow Labyrinth"]] = true,
			[BZ["Auchenai Crypts"]] = true,
		},
		paths = {
			[BZ["Ring of Observance"]] = true,
			[BZ["Shadowmoon Valley"]] = true,
			[BZ["Zangarmarsh"]] = true,
			[BZ["Shattrath City"]] = true,
			[BZ["Hellfire Peninsula"]] = true,
			[BZ["Nagrand"]] = true,
		},
		complexes = {
			[BZ["Ring of Observance"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 450,
		battlepet_low = 18,
		battlepet_high = 19,
	}

	zones[BZ["Nagrand"]] = {
		low = 64,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["Nagrand Arena"]] = true,
		},
		paths = {
			[BZ["Zangarmarsh"]] = true,
			[BZ["Shattrath City"]] = true,
			[BZ["Terokkar Forest"]] = true,
		},
		type = "PvP Zone",
		fishing_min = 475,
		battlepet_low = 18,
		battlepet_high = 19,
	}

	zones[BZ["Blade's Edge Mountains"]] = {
		low = 65,
		high = 80,
		continent = Outland,
		instances =
		{
			[BZ["Gruul's Lair"]] = true,
			[BZ["Blade's Edge Arena"]] = true,
		},
		paths = {
			[BZ["Netherstorm"]] = true,
			[BZ["Zangarmarsh"]] = true,
			[BZ["Gruul's Lair"]] = true,
		},
		battlepet_low = 18,
		battlepet_high = 20,
	}

	zones[BZ["Netherstorm"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Mechanar"]] = true,
			[BZ["The Botanica"]] = true,
			[BZ["The Arcatraz"]] = true,
			[BZ["Tempest Keep"]] = true,  -- previously "The Eye"
			[BZ["Eye of the Storm"]] = true,
		},
		paths = {
--			[BZ["Tempest Keep"]] = true,
			[BZ["Blade's Edge Mountains"]] = true,
		},
--		complexes = {
--			[BZ["Tempest Keep"]] = true,
--		},
		fishing_min = 475,
		battlepet_low = 20,
		battlepet_high = 21,
	}

	zones[BZ["Shadowmoon Valley"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		instances = BZ["Black Temple"],
		paths = {
			[BZ["Terokkar Forest"]] = true,
			[BZ["Black Temple"]] = true,
		},
		fishing_min = 375,
		battlepet_low = 20,
		battlepet_high = 21,
	}
	
	
	
	
	-- Northrend city and zones --
	
	zones[BZ["Dalaran"]] = {
		continent = Northrend,
		paths = {
			[BZ["The Violet Hold"]] = true,
			[transports["DALARAN_CRYSTALSONG_TELEPORT"]] = true,
			[transports["DALARAN_COT_PORTAL"]] = true,
			[transports["DALARAN_STORMWIND_PORTAL"]] = true,
			[transports["DALARAN_ORGRIMMAR_PORTAL"]] = true,
		},
		instances = {
			[BZ["The Violet Hold"]] = true,
			[BZ["Dalaran Arena"]] = true,
		},
		type = "City",
		texture = "Dalaran",
		faction = "Sanctuary",
		fishing_min = 525,
		battlepet_low = 21,
		battlepet_high = 21,
	}
	
	
	zones[BZ["Borean Tundra"]] = {
		low = 58,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Coldarra"]] = true,
			[BZ["Dragonblight"]] = true,
			[BZ["Sholazar Basin"]] = true,
			[transports["STORMWIND_BOREANTUNDRA_BOAT"]] = true,
			[transports["ORGRIMMAR_BOREANTUNDRA_ZEPPELIN"]] = true,
			[transports["MOAKI_UNUPE_BOAT"]] = true,
		},
		instances = {
			[BZ["The Nexus"]] = true,
			[BZ["The Oculus"]] = true,
			[BZ["The Eye of Eternity"]] = true,
		},
		complexes = {
			[BZ["Coldarra"]] = true,
		},
		fishing_min = 475,
		battlepet_low = 20,
		battlepet_high = 22,
	}	
	
	zones[BZ["Howling Fjord"]] = {
		low = 58,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Grizzly Hills"]] = true,
			[transports["MENETHIL_HOWLINGFJORD_BOAT"]] = true,
			[transports["UNDERCITY_HOWLINGFJORD_ZEPPELIN"]] = true,
			[transports["MOAKI_KAMAGUA_BOAT"]] = true,
			[BZ["Utgarde Keep"]] = true,
			[BZ["Utgarde Pinnacle"]] = true,
		},
		instances = {
			[BZ["Utgarde Keep"]] = true,
			[BZ["Utgarde Pinnacle"]] = true,
		},
		fishing_min = 475,
		battlepet_low = 20,
		battlepet_high = 22,
	}	
	
	zones[BZ["Dragonblight"]] = {
		low = 61,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Borean Tundra"]] = true,
			[BZ["Grizzly Hills"]] = true,
			[BZ["Zul'Drak"]] = true,
			[BZ["Crystalsong Forest"]] = true,
			[transports["MOAKI_UNUPE_BOAT"]] = true,
			[transports["MOAKI_KAMAGUA_BOAT"]] = true,
			[BZ["Azjol-Nerub"]] = true,
			[BZ["Ahn'kahet: The Old Kingdom"]] = true,
			[BZ["Naxxramas"]] = true,
			[BZ["The Obsidian Sanctum"]] = true,
		},
		instances = {
			[BZ["Azjol-Nerub"]] = true,
			[BZ["Ahn'kahet: The Old Kingdom"]] = true,
			[BZ["Naxxramas"]] = true,
			[BZ["The Obsidian Sanctum"]] = true,
			[BZ["Strand of the Ancients"]] = true,
		},
		fishing_min = 475,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Grizzly Hills"]] = {
		low = 63,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Howling Fjord"]] = true,
			[BZ["Dragonblight"]] = true,
			[BZ["Zul'Drak"]] = true,
			[BZ["Drak'Tharon Keep"]] = true,
		},
		instances = BZ["Drak'Tharon Keep"],
		fishing_min = 475,
		battlepet_low = 21,
		battlepet_high = 22,
	}	
	
	zones[BZ["Zul'Drak"]] = {
		low = 64,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Dragonblight"]] = true,
			[BZ["Grizzly Hills"]] = true,
			[BZ["Crystalsong Forest"]] = true,
			[BZ["Gundrak"]] = true,
			[BZ["Drak'Tharon Keep"]] = true,
		},
		instances = {
			[BZ["Gundrak"]] = true,
			[BZ["Drak'Tharon Keep"]] = true,
		},
		fishing_min = 475,
		battlepet_low = 22,
		battlepet_high = 23,
	}

	zones[BZ["Sholazar Basin"]] = {
		low = 66,
		high = 80,
		continent = Northrend,
		paths = BZ["Borean Tundra"],
		fishing_min = 525,
		battlepet_low = 21,
		battlepet_high = 22,
	}

	zones[BZ["Icecrown"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Trial of the Champion"]] = true,
			[BZ["Trial of the Crusader"]] = true,
			[BZ["The Forge of Souls"]] = true,
			[BZ["Pit of Saron"]] = true,
			[BZ["Halls of Reflection"]] = true,
			[BZ["Icecrown Citadel"]] = true,
			[BZ["Hrothgar's Landing"]] = true,
		},
		instances = {
			[BZ["Trial of the Champion"]] = true,
			[BZ["Trial of the Crusader"]] = true,
			[BZ["The Forge of Souls"]] = true,
			[BZ["Pit of Saron"]] = true,
			[BZ["Halls of Reflection"]] = true,
			[BZ["Icecrown Citadel"]] = true,
			[BZ["Isle of Conquest"]] = true,
		},
		fishing_min = 550,
		battlepet_low = 22,
		battlepet_high = 23,
	}
	
	zones[BZ["The Storm Peaks"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Crystalsong Forest"]] = true,
			[BZ["Halls of Stone"]] = true,
			[BZ["Halls of Lightning"]] = true,
			[BZ["Ulduar"]] = true,
		},
		instances = {
			[BZ["Halls of Stone"]] = true,
			[BZ["Halls of Lightning"]] = true,
			[BZ["Ulduar"]] = true,
		},
		fishing_min = 550,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Crystalsong Forest"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = {
			[transports["DALARAN_CRYSTALSONG_TELEPORT"]] = true,
			[BZ["Dragonblight"]] = true,
			[BZ["Zul'Drak"]] = true,
			[BZ["The Storm Peaks"]] = true,
		},
		fishing_min = 500,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Hrothgar's Landing"]] = {
		low = 67,
		high = 80,
		paths = BZ["Icecrown"],
		continent = Northrend,
		fishing_min = 550,
		battlepet_low = 22,
		battlepet_high = 22,
	}	
	
	zones[BZ["Wintergrasp"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = BZ["Vault of Archavon"],
		instances = BZ["Vault of Archavon"],
		type = "PvP Zone",
		fishing_min = 525,
		battlepet_low = 22,
		battlepet_high = 22,
	}	

	zones[BZ["The Frozen Sea"]] = {
		continent = Northrend,
		fishing_min = 575,
	}	
	
	-- The Maelstrom zones --
	
	-- Goblin start zone
	zones[BZ["Kezan"]] = {
		low = 1,
		high = 5,
		continent = The_Maelstrom,
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 1,
	}

	-- Goblin start zone
	zones[BZ["The Lost Isles"]] = {
		low = 1,
		high = 10,
		continent = The_Maelstrom,
		faction = "Horde",
		fishing_min = 25,
		battlepet_low = 1,
		battlepet_high = 2,
	}	
	
	zones[BZ["The Maelstrom"].." (zone)"] = {
		low = 82,
		high = 90,
		continent = The_Maelstrom,
		paths = {
		},
		faction = "Sanctuary",
	}

	zones[BZ["Deepholm"]] = {
		low = 82,
		high = 90,
		continent = The_Maelstrom,
		instances = {
			[BZ["The Stonecore"]] = true,
		},
		paths = {
			[BZ["The Stonecore"]] = true,
			[transports["DEEPHOLM_ORGRIMMAR_PORTAL"]] = true,
			[transports["DEEPHOLM_STORMWIND_PORTAL"]] = true,
		},
		fishing_min = 550,
		battlepet_low = 22,
		battlepet_high = 23,
	}	
	
	zones[BZ["Darkmoon Island"]] = {
		continent = The_Maelstrom,
		fishing_min = 75,
		paths = {
			[transports["DARKMOON_MULGORE_PORTAL"]] = true,
			[transports["DARKMOON_ELWYNNFOREST_PORTAL"]] = true,
		},
		battlepet_low = 1, 
		battlepet_high = 10,
	}
	
	
	
	-- Pandaria cities and zones -- 
	
	zones[BZ["Shrine of Seven Stars"]] = {
		continent = Pandaria,
		paths = {
			[BZ["Vale of Eternal Blossoms"]] = true,
			[transports["SEVENSTARS_EXODAR_PORTAL"]] = true,
			[transports["SEVENSTARS_STORMWIND_PORTAL"]] = true,
			[transports["SEVENSTARS_IRONFORGE_PORTAL"]] = true,
			[transports["SEVENSTARS_DARNASSUS_PORTAL"]] = true,
			[transports["SEVENSTARS_SHATTRATH_PORTAL"]] = true,
			[transports["SEVENSTARS_DALARAN_PORTAL"]] = true,
		},
		faction = "Alliance",
		type = "City",
		battlepet_low = 23,
		battlepet_high = 23,
	}

	zones[BZ["Shrine of Two Moons"]] = {
		continent = Pandaria,
		paths = {
			[BZ["Vale of Eternal Blossoms"]] = true,
			[transports["TWOMOONS_ORGRIMMAR_PORTAL"]] = true,
			[transports["TWOMOONS_UNDERCITY_PORTAL"]] = true,
			[transports["TWOMOONS_THUNDERBLUFF_PORTAL"]] = true,
			[transports["TWOMOONS_SILVERMOON_PORTAL"]] = true,
			[transports["TWOMOONS_SHATTRATH_PORTAL"]] = true,
			[transports["TWOMOONS_DALARAN_PORTAL"]] = true,
		},
		faction = "Horde",
		type = "City",
		battlepet_low = 23,
		battlepet_high = 23,
	}
	
	
	zones[BZ["The Wandering Isle"]] = {
		low = 1,
		high = 10,
		continent = Pandaria,
--		fishing_min = 25,
 		faction = "Sanctuary",  -- Not contested and not Alliance nor Horde -> no PvP -> sanctuary
	}	
	
	zones[BZ["The Jade Forest"]] = {
		low = 80,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Temple of the Jade Serpent"]] = true,
		},
		paths = {
			[BZ["Temple of the Jade Serpent"]] = true,
			[BZ["Valley of the Four Winds"]] = true,
			[BZ["Timeless Isle"]] = true,
			[transports["JADEFOREST_ORGRIMMAR_PORTAL"]] = true,
			[transports["JADEFOREST_STORMWIND_PORTAL"]] = true,
		},
		fishing_min = 650,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Valley of the Four Winds"]] = {
		low = 81,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Stormstout Brewery"]] = true,
			[BZ["Deepwind Gorge"]] = true,
		},
		paths = {
			[BZ["Stormstout Brewery"]] = true,
			[BZ["The Jade Forest"]] = true,
			[BZ["Krasarang Wilds"]] = true,
			[BZ["The Veiled Stair"]] = true,
			[BZ["Deepwind Gorge"]] = true,
		},
		fishing_min = 700,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Krasarang Wilds"]] = {
		low = 81,
		high = 90,
		continent = Pandaria,
		paths = {
			[BZ["Valley of the Four Winds"]] = true,
		},
		fishing_min = 700,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["The Veiled Stair"]] = {
		low = 87,
		high = 87,
		continent = Pandaria,
		instances = {
			[BZ["Terrace of Endless Spring"]] = true,
		},
		paths = {
			[BZ["Terrace of Endless Spring"]] = true,
			[BZ["Valley of the Four Winds"]] = true,
			[BZ["Kun-Lai Summit"]] = true,
		},
		fishing_min = 750,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Kun-Lai Summit"]] = {
		low = 82,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Shado-Pan Monastery"]] = true,
			[BZ["Mogu'shan Vaults"]] = true,
			[BZ["The Tiger's Peak"]] = true,
		},
		paths = {
			[BZ["Shado-Pan Monastery"]] = true,
			[BZ["Mogu'shan Vaults"]] = true,
			[BZ["Vale of Eternal Blossoms"]] = true,
			[BZ["The Veiled Stair"]] = true,
		},
		fishing_min = 625,
		battlepet_low = 23,
		battlepet_high = 25,
	}

	zones[BZ["Townlong Steppes"]] = {
		low = 83,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Siege of Niuzao Temple"]] = true,
		},
		paths = {
			[BZ["Siege of Niuzao Temple"]] = true,
			[BZ["Dread Wastes"]] = true,
			[transports["TOWNLONGSTEPPES_ISLEOFTHUNDER_PORTAL"]] = true,
		},
		fishing_min = 700,
		battlepet_low = 24,
		battlepet_high = 25,
	}

	zones[BZ["Dread Wastes"]] = {
		low = 84,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Gate of the Setting Sun"]] = true,
			[BZ["Heart of Fear"]] = true,
		},
		paths = {
			[BZ["Gate of the Setting Sun"]] = true,
			[BZ["Heart of Fear"]] = true,
			[BZ["Townlong Steppes"]] = true
		},
		fishing_min = 625,
		battlepet_low = 24,
		battlepet_high = 25,
	}

	zones[BZ["Vale of Eternal Blossoms"]] = {
		low = 85,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Mogu'shan Palace"]] = true,
			[BZ["Siege of Orgrimmar"]] = true,
		},
		paths = {
			[BZ["Mogu'shan Palace"]] = true,
			[BZ["Kun-Lai Summit"]] = true,
			[BZ["Siege of Orgrimmar"]] = true,
		},
		fishing_min = 825,
		battlepet_low = 23,
		battlepet_high = 25,
	}

	zones[BZ["Isle of Giants"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		fishing_min = 750,
		battlepet_low = 23,
		battlepet_high = 25,
	}
	
	zones[BZ["Isle of Thunder"]] = {
		low = 85,
		high = 90,
		continent = Pandaria,
		instances = {
			[BZ["Throne of Thunder"]] = true,
		},
		paths = {
			[transports["ISLEOFTHUNDER_TOWNLONGSTEPPES_PORTAL"]] = true,
		},
		fishing_min = 750,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Timeless Isle"]] = {
		low = 85,
		high = 90,
		continent = Pandaria,
		paths = BZ["The Jade Forest"],
		fishing_min = 825,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	
	-- Draenor cities, garrisons and zones -- 
	
	zones[BZ["Warspear"]] = {
		continent = Draenor,
		paths = {
			[BZ["Ashran"]] = true,
			[transports["WARSPEAR_ORGRIMMAR_PORTAL"]] = true,
			[transports["WARSPEAR_UNDERCITY_PORTAL"]] = true,
			[transports["WARSPEAR_THUNDERBLUFF_PORTAL"]] = true,
		},
		faction = "Horde",
		type = "City",
        fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Stormshield"]] = {
		continent = Draenor,
		paths = {
			[BZ["Ashran"]] = true,
			[transports["STORMSHIELD_STORMWIND_PORTAL"]] = true,
			[transports["STORMSHIELD_IRONFORGE_PORTAL"]] = true,
			[transports["STORMSHIELD_DARNASSUS_PORTAL"]] = true,
		},
		faction = "Alliance",
		type = "City",
        fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	-- Alliance garrison
	zones[BZ["Lunarfall"]] = {
        low = 90,
        high = 100,
        continent = Draenor,
        paths = {
            [BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = true,
        },
        faction = "Alliance",
        fishing_min = 950,
		yards = 683.334,
		x_offset = 11696.5098,
		y_offset = 9101.3333,
		texture = "garrisonsmvalliance"
    }
	
	-- Horde garrison
	zones[BZ["Frostwall"]] = {
        low = 90,
        high = 100,
        continent = Draenor,
        paths = {
            [BZ["Frostfire Ridge"]] = true,
        },
        faction = "Horde",
        fishing_min = 950,
		yards = 702.08,
		x_offset = 7356.9277,
		y_offset = 5378.4173,
		texture = "garrisonffhorde"
    }

	
	
	zones[BZ["Frostfire Ridge"]] = {
		low = 90,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Bloodmaul Slag Mines"]] = true,
		},
		paths = {
			[BZ["Gorgrond"]] = true,
			[BZ["Frostwall"]] = true,
			[transports["FROSTFIRERIDGE_ORGRIMMAR_PORTAL"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = {
		low = 90,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Shadowmoon Burial Grounds"]] = true,
		},
		paths = {
			[BZ["Talador"]] = true,
			[BZ["Spires of Arak"]] = true,
			[BZ["Tanaan Jungle"]] = true,
			[BZ["Lunarfall"]] = true,
			[transports["SHADOWMOONVALLEY_STORMWIND_PORTAL"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 23,
		battlepet_high = 25,
	}	
	
	zones[BZ["Gorgrond"]] = {
		low = 92,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Iron Docks"]] = true,
			[BZ["Grimrail Depot"]] = true,
			[BZ["The Everbloom"]] = true,
			[BZ["Blackrock Foundry"]] = true,
		},
		paths = {
			[BZ["Frostfire Ridge"]] = true,
			[BZ["Talador"]] = true,
			[BZ["Tanaan Jungle"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	zones[BZ["Talador"]] = {
		low = 94,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Auchindoun"]] = true,
		},
		paths = {
			[BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = true,
			[BZ["Gorgrond"]] = true,
			[BZ["Tanaan Jungle"]] = true,
			[BZ["Spires of Arak"]] = true,
			[BZ["Nagrand"].." ("..BZ["Draenor"]..")"] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}		
	
	zones[BZ["Spires of Arak"]] = {
		low = 96,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Skyreach"]] = true,
			[BZ["Blackrock Foundry"]] = true,
		},
		paths = {
			[BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = true,
			[BZ["Talador"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	zones[BZ["Nagrand"].." ("..BZ["Draenor"]..")"] = {
		low = 98,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Highmaul"]] = true,
			[BZ["Blackrock Foundry"]] = true,
		},
		paths = {
			[BZ["Talador"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Tanaan Jungle"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		instances = {
			[BZ["Hellfire Citadel"].." ("..BZ["Draenor"]..")"] = true,
		},
		paths = {
			[BZ["Talador"]] = true,
			[BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")"] = true,
			[BZ["Gorgrond"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	zones[BZ["Ashran"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		type = "PvP Zone",
		paths = {
			[BZ["Warspear"]] = true,
			[BZ["Stormshield"]] = true,
			[transports["WARSPEAR_ORGRIMMAR_PORTAL"]] = true,
			[transports["WARSPEAR_UNDERCITY_PORTAL"]] = true,
			[transports["WARSPEAR_THUNDERBLUFF_PORTAL"]] = true,
			[transports["STORMSHIELD_STORMWIND_PORTAL"]] = true,
			[transports["STORMSHIELD_IRONFORGE_PORTAL"]] = true,
			[transports["STORMSHIELD_DARNASSUS_PORTAL"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}	
	
	
	
	-- The Broken Isles cities and zones

	zones[BZ["Dalaran"].." ("..BZ["Broken Isles"]..")"] = {
		continent = BrokenIsles,
		paths = {
			[BZ["The Violet Hold"].." ("..BZ["Broken Isles"]..")"] = true,
			[transports["DALARANBROKENISLES_STORMWIND_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_EXODAR_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_DARNASSUS_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_IRONFORGE_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_SEVENSTARS_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_ORGRIMMAR_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_UNDERCITY_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_THUNDERBLUFF_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_SILVERMOON_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_TWOMOONS_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_COT_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_SHATTRATH_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_DRAGONBLIGHT_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_HILLSBRAD_PORTAL"]] = true,
			[transports["DALARANBROKENISLES_KARAZHAN_PORTAL"]] = true,
			},
		instances = {
			[BZ["The Violet Hold"].." ("..BZ["Broken Isles"]..")"] = true,
		},		
		faction = "Sanctuary",
		type = "City",
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Thunder Totem"]] = {
		continent = BrokenIsles,
		paths = {
			[BZ["Highmountain"]] = true,
			[BZ["Stormheim"]] = true,
		},
		faction = "Sanctuary",
		type = "City",
--		fishing_min = 950,  TODO: check for fishable waters
		battlepet_low = 25,
		battlepet_high = 25,
	}


	zones[BZ["Azsuna"]] = {
		low = 98,
		high = 110,
		continent = BrokenIsles,
		instances = {
			[BZ["Vault of the Wardens"]] = true,
			[BZ["Eye of Azshara"]] = true,
		},
		paths = {
			[BZ["Suramar"]] = true,
			[BZ["Val'sharah"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	zones[BZ["Val'sharah"]] = {
		low = 98,
		high = 110,
		continent = BrokenIsles,
		instances = {
			[BZ["Black Rook Hold"]] = true,
			[BZ["Darkheart Thicket"]] = true,
			[BZ["The Emerald Nightmare"]] = true,
		},
		paths = {
			[BZ["Suramar"]] = true,
			[BZ["Azsuna"]] = true,
			[BZ["Highmountain"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	zones[BZ["Highmountain"]] = {
		low = 98,
		high = 110,
		continent = BrokenIsles,
		instances = {
			[BZ["Neltharion's Lair"]] = true,
		},
		paths = {
			[BZ["Suramar"]] = true,
			[BZ["Stormheim"]] = true,
			[BZ["Val'sharah"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	zones[BZ["Stormheim"]] = {
		low = 98,
		high = 110,
		continent = BrokenIsles,
		instances = {
			[BZ["Halls of Valor"]] = true,
			[BZ["Helmouth Cliffs"]] = true, 
		},
		paths = {
			[BZ["Suramar"]] = true,
			[BZ["Highmountain"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Broken Shore"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		instances = {
			[BZ["Cathedral of Eternal Night"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}

	zones[BZ["Suramar"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		instances = {
			[BZ["Court of Stars"]] = true,
			[BZ["The Arcway"]] = true,
			[BZ["The Nighthold"]] = true,		
		},
		paths = {
			[BZ["Broken Shore"]] = true,
			[BZ["Azsuna"]] = true,
			[BZ["Val'sharah"]] = true,
			[BZ["Highmountain"]] = true,
			[BZ["Stormheim"]] = true,
		},
		fishing_min = 950,
		battlepet_low = 25,
		battlepet_high = 25,
	}
	
	
	-- Argus zones --
	
	zones[BZ["Krokuun"]] = {
		low = 110,
		high = 110,
		continent = Argus,
	}
	
	zones[BZ["Antoran Wastes"]] = {
		low = 110,
		high = 110,
		continent = Argus,
	}
	
	zones[BZ["Mac'Aree"]] = {
		low = 110,
		high = 110,
		continent = Argus,
		instances = {
			[BZ["The Seat of the Triumvirate"]] = true,
		},
	}
	

	
	
	-- Classic dungeons --
	
	zones[BZ["Ragefire Chasm"]] = {
		low = 15,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Orgrimmar"],
		groupSize = 5,
		faction = "Horde",
		type = "Instance",
		entrancePortal = { BZ["Orgrimmar"], 52.8, 49 },
	}
	
	zones[BZ["The Deadmines"]] = {
		low = 15,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Westfall"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
		fishing_min = 75,
		entrancePortal = { BZ["Westfall"], 42.6, 72.2 },
	}	
	
	zones[BZ["Shadowfang Keep"]] = {
		low = 17,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Silverpine Forest"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Silverpine Forest"], 44.80, 67.83 },
	}	
	
	zones[BZ["Wailing Caverns"]] = {
		low = 15,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Northern Barrens"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 75,
		entrancePortal = { BZ["Northern Barrens"], 42.1, 66.5 },
	}	
	
	zones[BZ["Blackfathom Deeps"]] = {
		low = 20,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Ashenvale"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 75,
		entrancePortal = { BZ["Ashenvale"], 14.6, 15.3 },
	}	
	
	zones[BZ["The Stockade"]] = {
		low = 20,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Stormwind City"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
		entrancePortal = { BZ["Stormwind City"], 50.5, 66.3 },
	}
	
	zones[BZ["Gnomeregan"]] = {
		low = 24,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Dun Morogh"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
		entrancePortal = { BZ["Dun Morogh"], 24, 38.9 },
	}	
	
	zones[BZ["Scarlet Halls"]] = {
		low = 26,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Tirisfal Glades"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Tirisfal Glades"], 84.9, 35.3 },
	}	
	
	zones[BZ["Scarlet Monastery"]] = {
		low = 28,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Tirisfal Glades"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Tirisfal Glades"], 85.3, 32.1 },
	}	

	zones[BZ["Razorfen Kraul"]] = {
		low = 30,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Southern Barrens"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Southern Barrens"], 40.8, 94.5 },
	}
	
	-- consists of The Wicked Grotto, Foulspore Cavern and Earth Song Falls
	zones[BZ["Maraudon"]] = {
		low = 30,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Desolace"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 300,
		entrancePortal = { BZ["Desolace"], 29, 62.4 },
	}	
	
	zones[BZ["Razorfen Downs"]] = {
		low = 35,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Thousand Needles"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Thousand Needles"], 47.5, 23.7 },
	}	
	
	zones[BZ["Uldaman"]] = {
		low = 35,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Badlands"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Badlands"], 42.4, 18.6 },
	}
	
	-- a.k.a. Warpwood Quarter
	zones[BZ["Dire Maul (East)"]] = {
		low = 36,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Dire Maul"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Dire Maul"],
		entrancePortal = { BZ["Feralas"], 66.7, 34.8 },
	}	
	
	-- a.k.a. Capital Gardens
	zones[BZ["Dire Maul (West)"]] = {
		low = 39,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Dire Maul"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Dire Maul"],
		entrancePortal = { BZ["Feralas"], 60.3, 30.6 },
	}

	-- a.k.a. Gordok Commons
	zones[BZ["Dire Maul (North)"]] = {
		low = 42,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Dire Maul"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Dire Maul"],
		entrancePortal = { BZ["Feralas"], 62.5, 24.9 },
	}

	zones[BZ["Scholomance"]] = {
		low = 38,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Western Plaguelands"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 425,
		entrancePortal = { BZ["Western Plaguelands"], 69.4, 72.8 },
	}
	
	-- consists of Main Gate and Service Entrance
	zones[BZ["Stratholme"]] = {
		low = 42,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Eastern Plaguelands"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 425,
		entrancePortal = { BZ["Eastern Plaguelands"], 30.8, 14.4 },
	}	
	
	zones[BZ["Zul'Farrak"]] = {
		low = 44,
		high = 60,
		continent = Kalimdor,
		paths = BZ["Tanaris"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Tanaris"], 36, 11.7 },
	}	
	
	-- consists of Detention Block and Upper City
	zones[BZ["Blackrock Depths"]] = {
		low = 47,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Mountain"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Searing Gorge"], 35.4, 84.4 },
	}	
	
	-- a.k.a. Sunken Temple
	zones[BZ["The Temple of Atal'Hakkar"]] = {
		low = 50,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = BZ["Swamp of Sorrows"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 300,
		entrancePortal = { BZ["Swamp of Sorrows"], 70, 54 },
	}	
	
	-- a.k.a. Lower Blackrock Spire
	zones[BZ["Blackrock Spire"]] = {
		low = 55,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Blackrock Mountain"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Burning Steppes"], 29.7, 37.5 },
	}

	
	
	-- Burning Crusade dungeons (Outland) --
	
	zones[BZ["Hellfire Ramparts"]] = {
		low = 58,
		high = 80,
		continent = Outland,
		paths = BZ["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Hellfire Citadel"],
		entrancePortal = { BZ["Hellfire Peninsula"], 46.8, 54.9 },
	}	

	zones[BZ["The Blood Furnace"]] = {
		low = 59,
		high = 80,
		continent = Outland,
		paths = BZ["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Hellfire Citadel"],
		entrancePortal = { BZ["Hellfire Peninsula"], 46.8, 54.9 },
	}
	
	zones[BZ["The Slave Pens"]] = {
		low = 60,
		high = 80,
		continent = Outland,
		paths = BZ["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coilfang Reservoir"],
		entrancePortal = { BZ["Zangarmarsh"], 50.2, 40.8 },
	}	
	
	zones[BZ["The Underbog"]] = {
		low = 61,
		high = 80,
		continent = Outland,
		paths = BZ["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coilfang Reservoir"],
		entrancePortal = { BZ["Zangarmarsh"], 50.2, 40.8 },
	}

	zones[BZ["Mana-Tombs"]] = {
		low = 62,
		high = 80,
		continent = Outland,
		paths = BZ["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Ring of Observance"],
		entrancePortal = { BZ["Terokkar Forest"], 39.6, 65.5 },
	}

	zones[BZ["Auchenai Crypts"]] = {
		low = 63,
		high = 80,
		continent = Outland,
		paths = BZ["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Ring of Observance"],
		entrancePortal = { BZ["Terokkar Forest"], 39.6, 65.5 },
	}
	
	-- a.k.a. The Escape from Durnhold Keep
	zones[BZ["Old Hillsbrad Foothills"]] = {
		low = 64,
		high = 80,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 26.7, 32.6 },
	}

	zones[BZ["Sethekk Halls"]] = {
		low = 65,
		high = 80,
		continent = Outland,
		paths = BZ["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Ring of Observance"],
		entrancePortal = { BZ["Terokkar Forest"], 39.6, 65.5 },
	}
	
	zones[BZ["Shadow Labyrinth"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		paths = BZ["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Ring of Observance"],
		entrancePortal = { BZ["Terokkar Forest"], 39.6, 65.5 },
	}

	zones[BZ["The Shattered Halls"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		paths = BZ["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Hellfire Citadel"],
		entrancePortal = { BZ["Hellfire Peninsula"], 46.8, 54.9 },
	}

	zones[BZ["The Steamvault"]] = {
		low = 67,
		high = 80,
		continent = Outland,
		paths = BZ["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coilfang Reservoir"],
		entrancePortal = { BZ["Zangarmarsh"], 50.2, 40.8 },
	}

	zones[BZ["The Mechanar"]] = {
		low = 67,
		high = 80,
		continent = Outland,
--		paths = BZ["Tempest Keep"],
		paths = BZ["Netherstorm"],
		groupSize = 5,
		type = "Instance",
--		complex = BZ["Tempest Keep"],
		entrancePortal = { BZ["Netherstorm"], 76.5, 65.1 },
	}

	zones[BZ["The Botanica"]] = {
		low = 67,
		high = 80,
		continent = Outland,
--		paths = BZ["Tempest Keep"],
		paths = BZ["Netherstorm"],
		groupSize = 5,
		type = "Instance",
--		complex = BZ["Tempest Keep"],
		entrancePortal = { BZ["Netherstorm"], 76.5, 65.1 },
	}
	
	zones[BZ["The Arcatraz"]] = {
		low = 68,
		high = 80,
		continent = Outland,
--		paths = BZ["Tempest Keep"],
		paths = BZ["Netherstorm"],
		groupSize = 5,
		type = "Instance",
--		complex = BZ["Tempest Keep"],
		entrancePortal = { BZ["Netherstorm"], 76.5, 65.1 },
	}
	
	
	-- Wrath of the Lich King dungeons (Northrend) --
	
	zones[BZ["Utgarde Keep"]] = {
		low = 58,
		high = 80,
		continent = Northrend,
		paths = BZ["Howling Fjord"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Howling Fjord"], 57.30, 46.84 },
	}	
	
	zones[BZ["The Nexus"]] = {
		low = 59,
		high = 80,
		continent = Northrend,
		paths = BZ["Coldarra"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coldarra"],
		entrancePortal = { BZ["Borean Tundra"], 27.50, 26.03 },
	}	
	
	zones[BZ["Azjol-Nerub"]] = {
		low = 60,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dragonblight"], 26.01, 50.83 },
	}	
	
	zones[BZ["Ahn'kahet: The Old Kingdom"]] = {
		low = 61,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dragonblight"], 28.49, 51.73 },
	}	
	
	zones[BZ["Drak'Tharon Keep"]] = {
		low = 62,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Grizzly Hills"]] = true,
			[BZ["Zul'Drak"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Zul'Drak"], 28.53, 86.93 },
	}	
	
	zones[BZ["The Violet Hold"]] = {
		low = 63,
		high = 80,
		continent = Northrend,
		paths = BZ["Dalaran"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dalaran"], 66.78, 68.19 },
	}
	
	zones[BZ["Gundrak"]] = {
		low = 64,
		high = 80,
		continent = Northrend,
		paths = BZ["Zul'Drak"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 475,
		entrancePortal = { BZ["Zul'Drak"], 76.14, 21.00 },
	}	
	
	zones[BZ["Halls of Stone"]] = {
		low = 65,
		high = 80,
		continent = Northrend,
		paths = BZ["The Storm Peaks"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["The Storm Peaks"], 39.52, 26.91 },
	}	
	
	zones[BZ["Halls of Lightning"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = BZ["The Storm Peaks"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["The Storm Peaks"], 45.38, 21.37 },
	}	
	
	zones[BZ["The Oculus"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = BZ["Coldarra"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Coldarra"],
		entrancePortal = { BZ["Borean Tundra"], 27.52, 26.67 },
	}	
	
	zones[BZ["Utgarde Pinnacle"]] = {
		low = 67,
		high = 80,
		continent = Northrend,
		paths = BZ["Howling Fjord"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Howling Fjord"], 57.25, 46.60 },
	}
	
	zones[BZ["The Culling of Stratholme"]] = {
		low = 68,
		high = 80,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 60.3, 82.8 },
	}	
	
	zones[BZ["Magisters' Terrace"]] = {
		low = 68,
		high = 80,
		continent = Eastern_Kingdoms,
		paths = BZ["Isle of Quel'Danas"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Isle of Quel'Danas"], 61.3, 30.9 },
	}
	
	-- a.k.a. The Opening of the Black Portal
	zones[BZ["The Black Morass"]] = {
		low = 68,
		high = 75,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 34.4, 84.9 },
	}	
	
	zones[BZ["Trial of the Champion"]] = {
		low = 68,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 74.18, 20.45 },
	}	
	
	zones[BZ["The Forge of Souls"]] = {
		low = 70,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 52.60, 89.35 },
	}	
	
	zones[BZ["Halls of Reflection"]] = {
		low = 70,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 52.60, 89.35 },
	}	
	
	zones[BZ["Pit of Saron"]] = {
		low = 70,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 550,
		entrancePortal = { BZ["Icecrown"], 52.60, 89.35 },
	}	
	
	
	-- Cataclysm dungeons --
	
	zones[BZ["Blackrock Caverns"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Blackrock Mountain"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Searing Gorge"], 47.8, 69.1 },
	}	
	
	zones[BZ["Throne of the Tides"]] = {
		low = 80,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = BZ["Abyssal Depths"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Abyssal Depths"], 69.3, 25.2 },
	}	
	
	zones[BZ["The Stonecore"]] = {
		low = 81,
		high = 90,
		continent = The_Maelstrom,
		paths = BZ["Deepholm"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Deepholm"], 47.70, 51.96 },
	}	
	
	zones[BZ["The Vortex Pinnacle"]] = {
		low = 81,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Uldum"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Uldum"], 76.79, 84.51 },
	}
	
	zones[BZ["Lost City of the Tol'vir"]] = {
		low = 84,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Uldum"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Uldum"], 60.53, 64.24 },
	}
	
	zones[BZ["Grim Batol"]] = {
		low = 84,
		high = 90,
		continent = Eastern_Kingdoms,
		paths = BZ["Twilight Highlands"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Twilight Highlands"], 19, 53.5 },
	}	
	
	-- TODO: confirm level range
	zones[BZ["Halls of Origination"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		paths = BZ["Uldum"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Uldum"], 69.09, 52.95 },
	}
	
	-- TODO: confirm level range
	zones[BZ["End Time"]] = {
		low = 84,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 57.1, 25.7 },
	}

	-- TODO: confirm level range
	zones[BZ["Hour of Twilight"]] = {
		low = 84,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 67.9, 29.0 },
	}

	-- TODO: confirm level range
	zones[BZ["Well of Eternity"]] = {
		low = 84,
		high = 90,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 5,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 22.2, 63.6 },
	}
	
	-- Note: before Cataclysm, this was a lvl 70 10-man raid
	zones[BZ["Zul'Aman"]] = {
		low = 85,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = BZ["Ghostlands"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Ghostlands"], 77.7, 63.2 },
		fishing_min = 425,
	}	

	-- Note: before Cataclysm, this was a lvl 60 20-man raid
	zones[BZ["Zul'Gurub"]] = {
		low = 85,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = BZ["Northern Stranglethorn"],
		groupSize = 5,
		type = "Instance",
--		fishing_min = 330,
		entrancePortal = { BZ["Northern Stranglethorn"], 52.2, 17.1 },
	}


	
	-- Mists of Pandaria dungeons --
	
	zones[BZ["Temple of the Jade Serpent"]] = {
		low = 80,
		high = 90,
		continent = Pandaria,
		paths = BZ["The Jade Forest"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["The Jade Forest"], 56.20, 57.90 },
	}	
	
	zones[BZ["Stormstout Brewery"]] = {
		low = 80,
		high = 90,
		continent = Pandaria,
		paths = BZ["Valley of the Four Winds"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Valley of the Four Winds"], 36.10, 69.10 }, 
	}	
	
	zones[BZ["Shado-Pan Monastery"]] = {
		low = 82,
		high = 90,
		continent = Pandaria,
		paths = BZ["Kun-Lai Summit"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Kun-Lai Summit"], 36.7, 47.6 },  
	}	
	
	zones[BZ["Mogu'shan Palace"]] = {
		low = 82,
		high = 90,
		continent = Pandaria,
		paths = BZ["Vale of Eternal Blossoms"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Vale of Eternal Blossoms"], 80.7, 33.0 }, 
	}	
	
	zones[BZ["Gate of the Setting Sun"]] = {
		low = 83,
		high = 90,
		continent = Pandaria,
		paths = BZ["Dread Wastes"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dread Wastes"], 15.80, 74.30 }, 
	}	
	
	zones[BZ["Siege of Niuzao Temple"]] = {
		low = 83,
		high = 90,
		continent = Pandaria,
		paths = BZ["Townlong Steppes"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Townlong Steppes"], 34.5, 81.1 },
	}	
	


	-- Warlords of Draenor dungeons --

	zones[BZ["Bloodmaul Slag Mines"]] = {
		low = 90,
		high = 100,
		continent = Draenor,
		paths = BZ["Forstfire Ridge"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Forstfire Ridge"], 50.0, 24.8 }, 
	}
	
	zones[BZ["Iron Docks"]] = {
		low = 92,
		high = 100,
		continent = Draenor,
		paths = BZ["Gorgrond"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Gorgrond"], 45.2, 13.7 },
	}		
	
	zones[BZ["Auchindoun"]] = {
		low = 94,
		high = 100,
		continent = Draenor,
		paths = BZ["Talador"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Talador"], 43.6, 74.1 },
	}	
	
	zones[BZ["Skyreach"]] = {
		low = 97,
		high = 100,
		continent = Draenor,
		paths = BZ["Spires of Arak"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Spires of Arak"], 35.6, 33.5 }, 
	}

	zones[BZ["Shadowmoon Burial Grounds"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")",
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Shadowmoon Valley"].." ("..BZ["Draenor"]..")", 31.9, 42.5 },
	}
	
	zones[BZ["Grimrail Depot"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Gorgrond"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Gorgrond"], 55.2, 32.1 },
	}	
	
	zones[BZ["The Everbloom"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Gorgrond"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Gorgrond"], 59.5, 45.3 },
	}

	zones[BZ["Upper Blackrock Spire"]] = {
		low = 100,
		high = 100,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Blackrock Mountain"]] = true,
		},
		groupSize = 5,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Burning Steppes"], 29.7, 37.5 },
	}
	
	
	-- Legion dungeons --
	
	zones[BZ["Eye of Azshara"]] = {
		low = 98,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Aszuna"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Aszuna"], 67.1, 41.1 }, 
	}

	zones[BZ["Darkheart Thicket"]] = {
		low = 98,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Val'sharah"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Val'sharah"], 59.2, 31.5 }, 
	}

	zones[BZ["Neltharion's Lair"]] = {
		low = 98,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Highmountain"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Highmountain"], 49.9, 63.6 }, 
	}

	zones[BZ["Halls of Valor"]] = {
		low = 98,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Stormheim"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Stormheim"], 68.3, 66.2 }, 
	}	

	zones[BZ["The Violet Hold"].." ("..BZ["Broken Isles"]..")"] = {
		low = 105,
		high = 110,
		continent = BrokenIsles,
		paths = {
			[BZ["Dalaran"].." ("..BZ["Broken Isles"]..")"] = true,
		},
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Dalaran"].." ("..BZ["Broken Isles"]..")", 66.78, 68.19 },
	}
	
	zones[BZ["Helmouth Cliffs"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Stormheim"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Stormheim"], 53.0, 47.2 }, 
	}	
	
	zones[BZ["Court of Stars"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Suramar"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Suramar"], 50.7, 65.5 }, 
	}		
	
	zones[BZ["The Arcway"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Suramar"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Suramar"], 43, 62 }, 
	}		
	
	zones[BZ["Cathedral of Eternal Night"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Broken Shore"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Broken Shore"], 63, 18 },
	}	
	
	zones[BZ["The Seat of the Triumvirate"]] = {
		low = 110,
		high = 110,
		continent = Argus,
		paths = BZ["Mac'Aree"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Mac'Aree"], 22.3, 56.1 }, 
	}	

	zones[BZ["Black Rook Hold"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Val'sharah"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Val'sharah"], 38.7, 53.2 }, 
	}	
	
	zones[BZ["Vault of the Wardens"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Aszuna"],
		groupSize = 5,
		type = "Instance",
		entrancePortal = { BZ["Aszuna"], 48.2, 82.7 }, 
	}	
	
	
	
	
	-- Raids --
	
	zones[BZ["Blackwing Lair"]] = {
		low = 60,
		high = 62,
		continent = Eastern_Kingdoms,
		paths = BZ["Blackrock Mountain"],
		groupSize = 40,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Burning Steppes"], 29.7, 37.5 },
	}

	zones[BZ["Molten Core"]] = {
		low = 60,
		high = 62,
		continent = Eastern_Kingdoms,
		paths = BZ["Blackrock Mountain"],
		groupSize = 40,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		fishing_min = 1,  -- lava
		entrancePortal = { BZ["Searing Gorge"], 35.4, 84.4 },
	}

	zones[BZ["Ahn'Qiraj"]] = {
		low = 60,
		high = 63,
		continent = Kalimdor,
		paths = BZ["Ahn'Qiraj: The Fallen Kingdom"],
		groupSize = 40,
		type = "Instance",
		complex = BZ["Ahn'Qiraj: The Fallen Kingdom"],
		entrancePortal = { BZ["Ahn'Qiraj: The Fallen Kingdom"], 46.6, 7.4 },
	}
	
	zones[BZ["Ruins of Ahn'Qiraj"]] = {
		low = 60,
		high = 63,
		continent = Kalimdor,
		paths = BZ["Ahn'Qiraj: The Fallen Kingdom"],
		groupSize = 20,
		type = "Instance",
		complex = BZ["Ahn'Qiraj: The Fallen Kingdom"],
		entrancePortal = { BZ["Ahn'Qiraj: The Fallen Kingdom"], 58.9, 14.3 },
	}	
	
	
	zones[BZ["Karazhan"]] = {
		low = 70,
		high = 72,
		continent = Eastern_Kingdoms,
		paths = BZ["Deadwind Pass"],
		groupSize = 10,
		type = "Instance",
		entrancePortal = { BZ["Deadwind Pass"], 40.9, 73.2 },
	}	
	
	-- a.k.a. The Battle for Mount Hyjal
	zones[BZ["Hyjal Summit"]] = {
		low = 70,
		high = 72,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 25,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 38.8, 16.6 },
	}

	zones[BZ["Black Temple"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = BZ["Shadowmoon Valley"],
		groupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Shadowmoon Valley"], 77.7, 43.7 },
	}

	zones[BZ["Magtheridon's Lair"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = BZ["Hellfire Citadel"],
		groupSize = 25,
		type = "Instance",
		complex = BZ["Hellfire Citadel"],
		entrancePortal = { BZ["Hellfire Peninsula"], 46.8, 54.9 },
	}

	zones[BZ["Serpentshrine Cavern"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = BZ["Coilfang Reservoir"],
		groupSize = 25,
		type = "Instance",
		complex = BZ["Coilfang Reservoir"],
		entrancePortal = { BZ["Zangarmarsh"], 50.2, 40.8 },
	}

	zones[BZ["Gruul's Lair"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = BZ["Blade's Edge Mountains"],
		groupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Blade's Edge Mountains"], 68, 24 },
	}

	zones[BZ["Tempest Keep"]] = {
		low = 70,
		high = 72,
		continent = Outland,
--		paths = BZ["Tempest Keep"],
		paths = BZ["Netherstorm"],
		groupSize = 25,
		type = "Instance",
--		complex = BZ["Tempest Keep"],
		entrancePortal = { BZ["Netherstorm"], 76.5, 65.1 },
	}
	
	zones[BZ["Sunwell Plateau"]] = {
		low = 70,
		high = 72,
		continent = Eastern_Kingdoms,
		paths = BZ["Isle of Quel'Danas"],
		groupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Isle of Quel'Danas"], 44.3, 45.7 },
	}


	zones[BZ["The Eye of Eternity"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Coldarra"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		complex = BZ["Coldarra"],
		entrancePortal = { BZ["Borean Tundra"], 27.54, 26.68 },
	}
	
	zones[BZ["Onyxia's Lair"]] = {
		low = 80,
		high = 80,
		continent = Kalimdor,
		paths = BZ["Dustwallow Marsh"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Dustwallow Marsh"], 52, 76 },
	}	

	zones[BZ["Naxxramas"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		fishing_min = 1,  -- acid
		entrancePortal = { BZ["Dragonblight"], 87.30, 51.00 },
	}

	zones[BZ["The Obsidian Sanctum"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		fishing_min = 1,  -- lava
		entrancePortal = { BZ["Dragonblight"], 60.00, 57.00 },
	}	
	
	zones[BZ["Ulduar"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["The Storm Peaks"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["The Storm Peaks"], 41.56, 17.76 },
		fishing_min = 550,
	}

	zones[BZ["Trial of the Crusader"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 75.07, 21.80 },
	}

	zones[BZ["Icecrown Citadel"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Icecrown"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Icecrown"], 53.86, 87.27 },
	}

	zones[BZ["Vault of Archavon"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Wintergrasp"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Wintergrasp"], 50, 11.2 },
	}

	zones[BZ["The Ruby Sanctum"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		paths = BZ["Dragonblight"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		fishing_min = 650,
		entrancePortal = { BZ["Dragonblight"], 61.00, 53.00 },
	}	
	

	zones[BZ["Firelands"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		paths = BZ["Mount Hyjal"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Mount Hyjal"], 47.3, 78.3 },
	}
	
	zones[BZ["Throne of the Four Winds"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		paths = BZ["Uldum"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Uldum"], 38.26, 80.66 },
	}	

	zones[BZ["Blackwing Descent"]] = {
		low = 85,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = {
			[BZ["Burning Steppes"]] = true,
			[BZ["Blackrock Mountain"]] = true,
			[BZ["Blackrock Spire"]] = true,
		},
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		complex = BZ["Blackrock Mountain"],
		entrancePortal = { BZ["Burning Steppes"], 26.1, 24.6 },
	}
	
	zones[BZ["The Bastion of Twilight"]] = {
		low = 85,
		high = 85,
		continent = Eastern_Kingdoms,
		paths = BZ["Twilight Highlands"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Twilight Highlands"], 33.8, 78.2 },
	}	
	
	zones[BZ["Dragon Soul"]] = {
		low = 85,
		high = 85,
		continent = Kalimdor,
		paths = BZ["Caverns of Time"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		complex = BZ["Caverns of Time"],
		entrancePortal = { BZ["Caverns of Time"], 60.0, 21.1 },
	}	


	zones[BZ["Mogu'shan Vaults"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["Kun-Lai Summit"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Kun-Lai Summit"], 59.1, 39.8 }, 
	}

	zones[BZ["Heart of Fear"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["Dread Wastes"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["Dread Wastes"], 39.0, 35.0 }, 
	}

	zones[BZ["Terrace of Endless Spring"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["The Veiled Stair"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["The Veiled Stair"], 47.9, 60.8 }, 
	}

	zones[BZ["Throne of Thunder"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["Isle of Thunder"],
		groupSize = 10,
		altGroupSize = 25,
		type = "Instance",
		entrancePortal = { BZ["The Veiled Stair"], 63.5, 32.2 }, 
	}

	zones[BZ["Siege of Orgrimmar"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		paths = BZ["Vale of Eternal Blossoms"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Vale of Eternal Blossoms"], 74.0, 42.2 },
	}
	
	
	
	zones[BZ["Blackrock Foundry"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Gorgrond"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Gorgrond"], 51.5, 27.4 },
	}	
	
	zones[BZ["Highmaul"]] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Nagrand"].." ("..BZ["Draenor"]..")",
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Nagrand"].." ("..BZ["Draenor"]..")", 34, 38 },
	}
	
	zones[BZ["Hellfire Citadel"].." ("..BZ["Draenor"]..")"] = {
		low = 100,
		high = 100,
		continent = Draenor,
		paths = BZ["Tanaan Jungle"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Tanaan Jungle"], 45, 53 },
	}

	zones[BZ["The Emerald Nightmare"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Val'sharah"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Val'sharah"], 57.1, 39.9 }, 
	}
	
	zones[BZ["The Nighthold"]] = {
		low = 110,
		high = 110,
		continent = BrokenIsles,
		paths = BZ["Suramar"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		entrancePortal = { BZ["Suramar"], 43, 62 }, 
	}
	
	zones[BZ["Antorus, the Burning Throne"]] = {
		low = 110,
		high = 110,
		continent = Argus,
		paths = BZ["Antoran Wastes"],
		groupMinSize = 10,
		groupMaxSize = 30,
		type = "Instance",
		--entrancePortal = { BZ["Antoran Wastes"], 0, 0 }, TODO
	}

	
	
	-- Battlegrounds --
	
	zones[BZ["Arathi Basin"]] = {
		low = 10,
		high = MAX_PLAYER_LEVEL,
		continent = Eastern_Kingdoms,
		paths = BZ["Arathi Highlands"],
		groupSize = 15,
		type = "Battleground",
		texture = "ArathiBasin",
	}

	zones[BZ["Warsong Gulch"]] = {
		low = 10,
		high = MAX_PLAYER_LEVEL,
		continent = Kalimdor,
		paths = isHorde and BZ["Northern Barrens"] or BZ["Ashenvale"],
		groupSize = 10,
		type = "Battleground",
		texture = "WarsongGulch",
	}	

	zones[BZ["Eye of the Storm"]] = {
		low = 35,
		high = MAX_PLAYER_LEVEL,
		continent = Outland,
		groupSize = 15,
		type = "Battleground",
		texture = "NetherstormArena",
	}
	
	zones[BZ["Alterac Valley"]] = {
		low = 45,
		high = MAX_PLAYER_LEVEL,
		continent = Eastern_Kingdoms,
		paths = BZ["Hillsbrad Foothills"],
		groupSize = 40,
		type = "Battleground",
		texture = "AlteracValley",
	}	
	
	zones[BZ["Strand of the Ancients"]] = {
		low = 65,
		high = MAX_PLAYER_LEVEL,
		continent = Northrend,
		groupSize = 15,
		type = "Battleground",
		texture = "StrandoftheAncients",
	}

	zones[BZ["Isle of Conquest"]] = {
		low = 75,
		high = MAX_PLAYER_LEVEL,
		continent = Northrend,
		groupSize = 40,
		type = "Battleground",
		texture = "IsleofConquest",
	}

	zones[BZ["The Battle for Gilneas"]] = {
		low = 85,
		high = MAX_PLAYER_LEVEL,
		continent = Eastern_Kingdoms,
		groupSize = 10,
		type = "Battleground",
		texture = "TheBattleforGilneas",
	}

	zones[BZ["Twin Peaks"]] = {
		low = 85,
		high = MAX_PLAYER_LEVEL,
		continent = Eastern_Kingdoms,
		paths = BZ["Twilight Highlands"],
		groupSize = 10,
		type = "Battleground",
		texture = "TwinPeaks",  -- TODO: verify
	}
	
	zones[BZ["Deepwind Gorge"]] = {
		low = 90,
		high = MAX_PLAYER_LEVEL,
		continent = Pandaria,
		paths = BZ["Valley of the Four Winds"],
		groupSize = 15,
		type = "Battleground",
		texture = "DeepwindGorge",  -- TODO: verify
	}


	-- Arenas --
	
	zones[BZ["Blade's Edge Arena"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		type = "Arena",
	}

	zones[BZ["Nagrand Arena"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		type = "Arena",
	}

	zones[BZ["Ruins of Lordaeron"]] = {
		low = 70,
		high = 70,
		continent = Kalimdor,
		type = "Arena",
	}	
	
	zones[BZ["Dalaran Arena"]] = {
		low = 80,
		high = 80,
		continent = Northrend,
		type = "Arena",
	}

	zones[BZ["The Ring of Valor"]] = {
		low = 80,
		high = 80,
		continent = Kalimdor,
		type = "Arena",
	}

	zones[BZ["The Tiger's Peak"]] = {
		low = 90,
		high = 90,
		continent = Pandaria,
		type = "Arena",
	}
	
	
	
	-- Complexes --

	zones[BZ["Dire Maul"]] = {
		low = 36,
		high = 60,
		continent = Kalimdor,
		instances = {
			[BZ["Dire Maul (East)"]] = true,
			[BZ["Dire Maul (North)"]] = true,
			[BZ["Dire Maul (West)"]] = true,
		},
		paths = {
			[BZ["Feralas"]] = true,
			[BZ["Dire Maul (East)"]] = true,
			[BZ["Dire Maul (North)"]] = true,
			[BZ["Dire Maul (West)"]] = true,
		},
		type = "Complex",
	}	
	
	zones[BZ["Blackrock Mountain"]] = {
		low = 47,
		high = 100,
		continent = Eastern_Kingdoms,
		instances = {
			[BZ["Blackrock Depths"]] = true,
			[BZ["Blackrock Caverns"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Spire"]] = true,
			[BZ["Upper Blackrock Spire"]] = true,
		},
		paths = {
			[BZ["Burning Steppes"]] = true,
			[BZ["Searing Gorge"]] = true,
			[BZ["Blackwing Lair"]] = true,
			[BZ["Blackwing Descent"]] = true,
			[BZ["Molten Core"]] = true,
			[BZ["Blackrock Depths"]] = true,
			[BZ["Blackrock Caverns"]] = true,
			[BZ["Blackrock Spire"]] = true,
			[BZ["Upper Blackrock Spire"]] = true,
		},
		type = "Complex",
		fishing_min = 1, -- lava
	}

	zones[BZ["Hellfire Citadel"]] = {
		low = 58,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Blood Furnace"]] = true,
			[BZ["Hellfire Ramparts"]] = true,
			[BZ["Magtheridon's Lair"]] = true,
			[BZ["The Shattered Halls"]] = true,
		},
		paths = {
			[BZ["Hellfire Peninsula"]] = true,
			[BZ["The Blood Furnace"]] = true,
			[BZ["Hellfire Ramparts"]] = true,
			[BZ["Magtheridon's Lair"]] = true,
			[BZ["The Shattered Halls"]] = true,
		},
		type = "Complex",
	}

	zones[BZ["Coldarra"]] = {
		low = 59,
		high = 80,
		continent = Northrend,
		paths = {
			[BZ["Borean Tundra"]] = true,
			[BZ["The Nexus"]] = true,
			[BZ["The Oculus"]] = true,
			[BZ["The Eye of Eternity"]] = true,
		},
		instances = {
			[BZ["The Nexus"]] = true,
			[BZ["The Oculus"]] = true,
			[BZ["The Eye of Eternity"]] = true,
		},
		type = "Complex",
	}
	
	zones[BZ["Coilfang Reservoir"]] = {
		low = 60,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["The Underbog"]] = true,
			[BZ["Serpentshrine Cavern"]] = true,
			[BZ["The Steamvault"]] = true,
			[BZ["The Slave Pens"]] = true,
		},
		paths = {
			[BZ["Zangarmarsh"]] = true,
			[BZ["The Underbog"]] = true,
			[BZ["Serpentshrine Cavern"]] = true,
			[BZ["The Steamvault"]] = true,
			[BZ["The Slave Pens"]] = true,
		},
		fishing_min = 400,
		type = "Complex",
	}
	
	zones[BZ["Ahn'Qiraj: The Fallen Kingdom"]] = {
		low = 60,
		high = 63,
		continent = Kalimdor,
		paths = {
			[BZ["Silithus"]] = true,
		},
		instances = {
			[BZ["Ahn'Qiraj"]] = true,
			[BZ["Ruins of Ahn'Qiraj"]] = true,
		},
		type = "Complex",
		battlepet_low = 16,
		battlepet_high = 17,
	}
	
	zones[BZ["Ring of Observance"]] = {
		low = 62,
		high = 80,
		continent = Outland,
		instances = {
			[BZ["Mana-Tombs"]] = true,
			[BZ["Sethekk Halls"]] = true,
			[BZ["Shadow Labyrinth"]] = true,
			[BZ["Auchenai Crypts"]] = true,
		},
		paths = {
			[BZ["Terokkar Forest"]] = true,
			[BZ["Mana-Tombs"]] = true,
			[BZ["Sethekk Halls"]] = true,
			[BZ["Shadow Labyrinth"]] = true,
			[BZ["Auchenai Crypts"]] = true,
		},
		type = "Complex",
	}

	zones[BZ["Caverns of Time"]] = {
		low = 64,
		high = 90,
		continent = Kalimdor,
		instances = {
			[BZ["Old Hillsbrad Foothills"]] = true,
			[BZ["The Black Morass"]] = true,
			[BZ["Hyjal Summit"]] = true,
			[BZ["The Culling of Stratholme"]] = true,
			[BZ["End Time"]] = true,
			[BZ["Hour of Twilight"]] = true,
			[BZ["Well of Eternity"]] = true,
			[BZ["Dragon Soul"]] = true,
		},
		paths = {
			[BZ["Tanaris"]] = true,
			[BZ["Old Hillsbrad Foothills"]] = true,
			[BZ["The Black Morass"]] = true,
			[BZ["Hyjal Summit"]] = true,
			[BZ["The Culling of Stratholme"]] = true,
		},
		type = "Complex",
	}
	
	
	-- Had to remove the complex 'Tempest Keep' because of the renamed 'The Eye' instance now has same name (Legion)
	-- zones[BZ["Tempest Keep"]] = {
		-- low = 67,
		-- high = 75,
		-- continent = Outland,
		-- instances = {
			-- [BZ["The Mechanar"]] = true,
			-- [BZ["Tempest Keep"]] = true,  -- previously "The Eye"
			-- [BZ["The Botanica"]] = true,
			-- [BZ["The Arcatraz"]] = true,
		-- },
		-- paths = {
			-- [BZ["Netherstorm"]] = true,
			-- [BZ["The Mechanar"]] = true,
			-- [BZ["Tempest Keep"]] = true,
			-- [BZ["The Botanica"]] = true,
			-- [BZ["The Arcatraz"]] = true,
		-- },
		-- type = "Complex",
	-- }


	
--------------------------------------------------------------------------------------------------------
--                                                CORE                                                --
--------------------------------------------------------------------------------------------------------

	trace("Tourist: Initializing continents...")
	local continentNames = Tourist:GetMapContinentsAlt()

	for continentID, continentName in ipairs(continentNames) do
		SetMapZoom(continentID)
		
		if zones[continentName] then
			-- Get map texture name
			zones[continentName].texture = GetMapInfo()
			-- Get MapID
			zones[continentName].zoneMapID = GetCurrentMapAreaID()
			
			local _, cLeft, cTop, cRight, cBottom = GetCurrentMapZone()
			-- Calculate size in yards
			zones[continentName].yards = cLeft - cRight
			
			-- Calculate x-axis shift and y-axis shift, which indicate how many yards the X and Y axis of the continent map are shifted
			-- from the midpoint of the map. These shift values are the difference between the zone offsets returned by UpdateMapHighLight and the 
			-- offsets calculated using data provided by GetCurrentMapZone.
			-- Note: For The Maelstrom continent, no such data is available at all. The four zones of this "continent" are 
			-- geographically not related to each other, so there are no zone offsets and there's no continent shift or size.
			zones[continentName].x_shift = (cLeft + cRight) / 2
			zones[continentName].y_shift = (cTop + cBottom) / 2
					
			trace("Tourist: Continent size in yards for "..tostring(continentName).." ("..tostring(continentID).."): "..tostring(round(zones[continentName].yards, 2)))
		else
			-- Unknown Continent
			trace("|r|cffff4422! -- Tourist:|r TODO: Add Continent '"..tostring(continentName).."'")		
		end
	end
	
	-- --------------------------------------------------------------------------------------------------------------------------
	-- Set the continent offsets and scale for the continents on the Azeroth map, except The Maelstrom.
	-- The offsets are expressed in Azeroth yards (that is, without the scale correction used for the continent maps)
	-- and have been calculated as follows.
	-- I've used a player position because it is displayed at both the continent map and the Azeroth map.
	-- Using the player coordinates (which are a percentage of the map size) and the continent and Azeroth map sizes:
	
	-- a = playerXContinent * continentWidth * continentScale (= player X offset on the continent map, expressed in Azeroth yards)
	-- b = playerXAzeroth * azerothWidth (= player X offset on the Azeroth map)
	-- continentXOffset = b - a

	-- c = playerYContinent * continentHeight * continentScale (= player Y offset on the continent map, expressed in Azeroth yards)
	-- d = playerYAzeroth * azerothHeight (= player Y offset on the Azeroth map)
	-- continentYOffset = d - c

	-- The scales are 'borrowed' from Astrolabe ;-)
	
	zones[BZ["Kalimdor"]].x_offset = -4023.28
	zones[BZ["Kalimdor"]].y_offset = 3243.71
	zones[BZ["Kalimdor"]].scale = 0.5609
	
	zones[BZ["Eastern Kingdoms"]].x_offset = 16095.36
	zones[BZ["Eastern Kingdoms"]].y_offset = 2945.14
	zones[BZ["Eastern Kingdoms"]].scale = 0.5630
	
	zones[BZ["Northrend"]].x_offset = 12223.65
	zones[BZ["Northrend"]].y_offset = 520.24
	zones[BZ["Northrend"]].scale = 0.5949
	
	zones[BZ["Pandaria"]].x_offset = 12223.65
	zones[BZ["Pandaria"]].y_offset = 520.24
	zones[BZ["Pandaria"]].scale = 0.6514
	
	zones[BZ["Broken Isles"]].x_offset = 16297
	zones[BZ["Broken Isles"]].y_offset = 8225.3
	zones[BZ["Broken Isles"]].scale = 0.4469
	
	-- --------------------------------------------------------------------------------------------------------------------------

	
	trace("Tourist: Initializing zones...")
	local doneZones = {}
	
	for continentID, continentName in ipairs(continentNames) do
		-- Get continent width and height
		local cWidth = zones[continentName] and zones[continentName].yards or 0
		local cHeight = 2/3 * cWidth

		-- Build a collection of the indices of the zones within the continent
		-- to be able to lookup a zone index for SetMapZoom()
		local zoneNames = GetMapZonesAltLocal(continentID)
		local zoneIndices = {}
		for index = 1, #zoneNames do
			zoneIndices[zoneNames[index]] = index
		end
		
		for i = 1, #zoneNames do		
			-- The zones Frostfire Ridge, Highmountain and Val'sharah appear twice in the collection of zones of their continent
			-- so we need to be able to skip duplicates, even within a Continent
			if not doneZones[continentName.."."..zoneNames[i]] then
				local zoneName = Tourist:GetUniqueZoneNameForLookup(zoneNames[i], continentID)
				local zoneIndex = zoneIndices[zoneNames[i]]
				if zones[zoneName] then
					-- Get zone map data
					SetMapZoom(continentID, zoneIndex)
					local z, zLeft, zTop, zRight, zBot = GetCurrentMapZone()
				
					-- Calculate zone size
					local sizeInYards = 0
					if zLeft and zRight then
						sizeInYards = zLeft - zRight
					end
					if sizeInYards ~= 0 or not zones[zoneName].yards then
						-- Make sure the size is always set (even if it's 0) but don't overwrite any hardcoded values if the size is 0
						zones[zoneName].yards = sizeInYards
					end
					if zones[zoneName].yards == 0 then 
						trace("|r|cffff4422! -- Tourist:|r Size for "..zoneName.." = 0 yards")
						-- Skip offset calculation as we obviously got no data from GetCurrentMapZone
					else 
						if cWidth ~= 0 then
							-- Calculate zone offsets if the size of the continent is known (The Maelstrom has no continent size).
							-- LibTourist uses positive x and y axis with the source located at the top left corner of the map.
							-- GetCurrentMapZone uses a source *somewhere* in the middle of the map, and the x axis is 
							-- reversed so it's positive to the LEFT.
							-- First assume the source is exactly in the middle of the map...
							local zXOffset = (cWidth * 0.5) - zLeft
							local zYOffset = (cHeight * 0.5) - zTop
							-- ...then correct the offsets for continent map axis shifts
							zXOffset = zXOffset + zones[continentName].x_shift
							zYOffset = zYOffset + zones[continentName].y_shift
							zones[zoneName].x_offset = zXOffset
							zones[zoneName].y_offset = zYOffset
						end
					end
								
					-- Get zone texture filename
					zones[zoneName].texture = GetMapInfo()
					-- Get zone mapID
					zones[zoneName].zoneMapID = GetCurrentMapAreaID()
				else
					trace("|r|cffff4422! -- Tourist:|r TODO: Add zone "..tostring(zoneName))
				end
				
				doneZones[continentName.."."..zoneNames[i]] = true
			else
				trace("|r|cffff4422! -- Tourist:|r Duplicate zone: "..tostring(continentName).."["..tostring(i).."]: "..tostring(zoneNames[i]) )
			end

		end -- zones loop
		trace( "Tourist: Processed "..tostring(#zoneNames).." zones for "..continentName )
		
	end -- continents loop

	SetMapToCurrentZone()

	trace("Tourist: Filling lookup tables...")
	
	-- Fill the lookup tables
	for k,v in pairs(zones) do
		lows[k] = v.low or 0
		highs[k] = v.high or 0
		continents[k] = v.continent or UNKNOWN
		instances[k] = v.instances
		paths[k] = v.paths or false
		types[k] = v.type or "Zone"
		groupSizes[k] = v.groupSize
		groupMinSizes[k] = v.groupMinSize
		groupMaxSizes[k] = v.groupMaxSize
		groupAltSizes[k] = v.altGroupSize
		factions[k] = v.faction
		yardWidths[k] = v.yards
		yardHeights[k] = v.yards and v.yards * 2/3 or nil
		yardXOffsets[k] = v.x_offset
		yardYOffsets[k] = v.y_offset
		fishing[k] = v.fishing_min
		battlepet_lows[k] = v.battlepet_low
		battlepet_highs[k] = v.battlepet_high
		textures[k] = v.texture
		complexOfInstance[k] = v.complex
		zoneComplexes[k] = v.complexes
		if v.texture then
			textures_rev[v.texture] = k
		end
		zoneMapIDs[k] = v.zoneMapID
		if v.zoneMapID then
			zoneMapIDs_rev[v.zoneMapID] = k
		end
		if v.entrancePortal then
			entrancePortals_zone[k] = v.entrancePortal[1]
			entrancePortals_x[k] = v.entrancePortal[2]
			entrancePortals_y[k] = v.entrancePortal[3]
		end
		if v.scale then
			continentScales[k] = v.scale
		end
	end
	zones = nil

	trace("Tourist: Initialized.")

	PLAYER_LEVEL_UP(Tourist)
end
