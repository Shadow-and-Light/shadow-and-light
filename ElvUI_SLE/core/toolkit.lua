local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

--GLOBALS: unpack, NUM_BAG_SLOTS, IsAddOnLoaded, DEFAULT_CHAT_FRAME
local _G = _G
local select, format, tonumber, match, ipairs, pairs, gsub = select, format, tonumber, string.match, ipairs, pairs, gsub
local getmetatable, error, type, assert, random = getmetatable, error, type, assert, random
local tremove, tinsert, tconcat, date = tremove, tinsert, table.concat, date
local strjoin, strmatch, strsplit, strfind = strjoin, strmatch, strsplit, strfind
local EnumerateFrames = EnumerateFrames

local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemID = C_Container.GetContainerItemID
local C_Item_GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local C_Spell_GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo

T.Values = {
	FontFlags = {
		[''] = L["NONE"],
		OUTLINE = 'Outline',
		THICKOUTLINE = 'Thick',
		MONOCHROME = '|cffaaaaaaMono|r',
		MONOCHROMEOUTLINE = '|cffaaaaaaMono|r Outline',
		MONOCHROMETHICKOUTLINE = '|cffaaaaaaMono|r Thick',
	},
	positionValues = {
		TOPLEFT = 'TOPLEFT',
		LEFT = 'LEFT',
		BOTTOMLEFT = 'BOTTOMLEFT',
		RIGHT = 'RIGHT',
		TOPRIGHT = 'TOPRIGHT',
		BOTTOMRIGHT = 'BOTTOMRIGHT',
		CENTER = 'CENTER',
		TOP = 'TOP',
		BOTTOM = 'BOTTOM',
	},
	-- FontSize = { min = 8, max = 64, step = 1 },
	Strata = { BACKGROUND = 'BACKGROUND', LOW = 'LOW', MEDIUM = 'MEDIUM', HIGH = 'HIGH', DIALOG = 'DIALOG', TOOLTIP = 'TOOLTIP' },
	AllPoints = { TOPLEFT = 'TOPLEFT', LEFT = 'LEFT', BOTTOMLEFT = 'BOTTOMLEFT', RIGHT = 'RIGHT', TOPRIGHT = 'TOPRIGHT', BOTTOMRIGHT = 'BOTTOMRIGHT', CENTER = 'CENTER', TOP = 'TOP', BOTTOM = 'BOTTOM' }
}

T.StringToUpper = function(str)
	return (gsub(str, '^%l', strupper))
end

T.GetSpell = function(id)
	return C_Spell_GetSpellInfo(btn.secure.ID).name
end

--Some of Simpy's (and now Flamanis) herecy bullshit
T.rgsub = function(pattern, ...)
    for i = 1, select('#', ...), 2 do
        local v, y = select(i, ...)
        local z = strmatch(pattern, v) and y
        if z then
            pattern = gsub(pattern, v, z)
        end
    end

    return pattern
end


T.SafeHookScript = function(frame, handlername, newscript)
	local oldValue = frame:GetScript(handlername)
	frame:SetScript(handlername, newscript)
	return oldValue
end

--Search in a table like {"arg1", "arg2", "arg3"}
function SLE:SimpleTable(table, item)
	for i = 1, #table do
		if table[i] == item then
			return true
		end
	end

	return false
end
--Search in a table like {["stuff"] = {}, ["stuff2"] = {} }
function SLE:ValueTable(table, item)
	for i, _ in pairs(table) do
		if i == item then
			return true
		end
	end

	return false
end

function SLE:GetIconFromID(idtype, id)
	local path
	if idtype == 'item' then
		path = select(10, C_Item_GetItemInfo(id))
	elseif idtype == 'spell' then
		path = C_Spell_GetSpellInfo(id).iconID
	elseif idtype == 'achiev' then
		path = select(10, GetAchievementInfo(id))
	end
	return path or nil
end

--For searching stuff in bags
function SLE:BagSearch(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, C_Container_GetContainerNumSlots(container) do
			if itemId == C_Container_GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

--S&L print
function SLE:Print(msg, msgtype)
	if msgtype == 'error' then
		(_G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(strjoin('', '|cffff0000S&L Error:|r ', msg))
	elseif msgtype == 'warning' then
		(_G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(strjoin('', '|cffd3cf00S&L Warning:|r ', msg))
	elseif msgtype == 'info' then
		(_G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(strjoin('', '|cff14adcdS&L Info:|r ', msg))
	else
		(_G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(
			strjoin('', E['media'].hexvaluecolor, 'S&L Message:|r ', msg)
		)
	end
end

--A function to ensure any files which set movers will be recognised as text by git.
function SLE:SetMoverPosition(mover, anchor, parent, point, x, y)
	if not _G[mover] then
		return
	end
	local frame = _G[mover]

	frame:ClearAllPoints()
	frame:SetPoint(anchor, parent, point, x, y)
	E:SaveMoverPosition(mover)
end

--To get stuff from item link. Got this from suspctz
function SLE:GetItemSplit(itemLink)
	local itemString = strmatch(itemLink, 'item:([%-?%d:]+)')
	local itemSplit = {}

	-- Split data into a table
	for _, v in ipairs({strsplit(':', itemString)}) do
		if v == '' then
			itemSplit[#itemSplit + 1] = 0
		else
			itemSplit[#itemSplit + 1] = tonumber(v)
		end
	end

	return itemSplit
end

--Reseting shit
function SLE:Reset(group)
	if not group then
		print('U wot m8?')
	end
	if group == 'unitframes' or group == 'all' then
		E.db.sle.unitframes.roleIcons.icons = 'ElvUI'
		E.db.sle.powtext = false
	end
	if group == 'backgrounds' or group == 'all' then
		E:CopyTable(E.db.sle.backgrounds, P.sle.backgrounds)
		E:ResetMovers(L["SLE_BG_1_Mover"])
		E:ResetMovers(L["SLE_BG_2_Mover"])
		E:ResetMovers(L["SLE_BG_3_Mover"])
		E:ResetMovers(L["SLE_BG_4_Mover"])
	end
	if group == 'datatexts' or group == 'all' then
		E:CopyTable(E.db.sle.datatexts, P.sle.datatexts)
		E:CopyTable(E.db.sle.dt, P.sle.dt)
	end
	if group == 'marks' or group == 'all' then
		E:CopyTable(E.db.sle.raidmarkers, P.sle.raidmarkers)
		E:ResetMovers(L["Raid Marker Bar"])
	end
	if group == 'all' then
		E:CopyTable(E.db.sle, P.sle)
		E:ResetMovers("PvP")
		E:ResetMovers(L["S&L UI Buttons"])
		E:ResetMovers(L["Error Frame"])
		E:ResetMovers(L["Pet Battle Status"])
		E:ResetMovers(L["Pet Battle AB"])
		E:ResetMovers(L["Garrison Tools Bar"])
		E:ResetMovers(L["Raid Utility"])
	end
	E:UpdateAll()
end

function SLE:GetMapInfo(id, arg)
	if not arg then
		return
	end
	local MapInfo
	if T.MapInfoTable[id] then
		MapInfo = T.MapInfoTable[id]
	else
		MapInfo = C_Map.GetMapInfo(id)
		T.MapInfoTable[id] = MapInfo
	end
	if not MapInfo then
		return UNKNOWN
	end
	if arg == 'all' then
		return MapInfo['name'], MapInfo['mapID'], MapInfo['parentMapID'], MapInfo['mapType']
	end
	return MapInfo[arg]
end

local txframe = CreateFrame('Frame')
local tx = txframe:CreateTexture()

function SLE:TextureExists(path)
	if not path or path == '' then
		return SLE:Print('Path not valid or defined.', 'error')
	end
	tx:SetTexture('?')
	tx:SetTexture(path)

	return (tx:GetTexture())
end

--Trying to determine the region player is in, not entirely reliable cause based on atypet not an actual region id
function SLE:GetRegion()
	--[[local lib = LibStub('LibRealmInfo')
	if not GetPlayerInfoByGUID(E.myguid) then
		return
	end
	local rid, _, _, _, _, _, region = lib:GetRealmInfoByGUID(E.myguid)
	SLE.region = region
	if not SLE.region then
		if not IsTestBuild() then
			SLE.region =
				format(
				"An error happened. Your region is unknown. Realm: %s. RID: %s. Please report your realm name and the region you are playing in to |cff1784d1Shadow & Light|r authors.",
				E.myrealm,
				rid or 'nil'
			)
			SLE:Print(SLE.region, 'error')
		end
		SLE.region = 'PTR'
	end]]
	local portal = GetCVar("portal")

	if not portal or portal == "" then
		SLE.region = "PTR"
	elseif portal == "test" then
		SLE.region = "PTR"
	else
		SLE.region = portal
	end
end

--Registering and loading modules
SLE['RegisteredModules'] = {}
function SLE:RegisterModule(name)
	if self.initialized then
		self:GetModule(name):Initialize()
	else
		self['RegisteredModules'][#self['RegisteredModules'] + 1] = name
	end
end

local GetCVarBool = GetCVarBool
local pcall = pcall
local ScriptErrorsFrame_OnError = ScriptErrorsFrame_OnError
function SLE:InitializeModules()
	for _, module in pairs(SLE['RegisteredModules']) do
		module = self:GetModule(module)
		if module.Initialize then
			local _, catch = pcall(module.Initialize, module)

			if catch and GetCVarBool('scriptErrors') == true then
				if E.wowbuild < 24330 then --7.2
					ScriptErrorsFrame_OnError(catch, false)
				end
			end
		end
	end
end

--[[
Updating alongside with ElvUI. SLE:UpdateAll() is hooked to E:UpdateAll()
Modules are supposed to provide a function(s) to call when profile change happens (or global update is called).
Provided functions should be named Module:ForUpdateAll() or otherwise stored in SLE.UpdateFunctions table (when there is no need of reassigning settings table.
Each modules insert their functions in respective files.
]]
local collectgarbage = collectgarbage
SLE.UpdateFunctions = {}
function SLE:UpdateAll()
	if not SLE.initialized then
		return
	end

	for _, name in pairs(SLE['RegisteredModules']) do
		local module = SLE:GetModule(name)
		if module.ForUpdateAll then
			module:ForUpdateAll()
		else
			if SLE.UpdateFunctions[name] then
				SLE.UpdateFunctions[name]()
			end
		end
	end

	if not SLE._Compatibility['oRA3'] then
		SLE.BlizzRaid:CreateAndUpdateIcons()
	end

	SLE:SetCompareItems()

	collectgarbage('collect')
end

--Movable buttons in config stuff. Some Simpy's billshit applied
local function MovableButton_Match(s, v)
	local m1, m2, m3, m4 = "^" .. v .. "$", "^" .. v .. ",", "," .. v .. "$", "," .. v .. ","
	return (match(s, m1) and m1) or (match(s, m2) and m2) or (match(s, m3) and m3) or (match(s, m4) and v .. ",")
end
function SLE:MovableButtonSettings(db, key, value, remove, movehere)
	local str = db[key]
	if not db or not str or not value then
		return
	end
	local found = MovableButton_Match(str, E:EscapeString(value))
	if found and movehere then
		local tbl, sv, sm = {strsplit(",", str)}
		for i in ipairs(tbl) do
			if tbl[i] == value then
				sv = i
			elseif tbl[i] == movehere then
				sm = i
			end
			if sv and sm then
				break
			end
		end
		tremove(tbl, sm)
		tinsert(tbl, sv, movehere)

		db[key] = tconcat(tbl, ",")
	elseif found and remove then
		db[key] = gsub(str, found, "")
	elseif not found and not remove then
		db[key] = (str == "" and value) or (str .. "," .. value)
	end
end

function SLE:CreateMovableButtons(Order, Name, CanRemove, db, key)
	local moveItemFrom, moveItemTo
	local config = {
		order = Order,
		dragdrop = true,
		type = 'multiselect',
		name = Name,
		dragOnLeave = function()
		end, --keep this here
		dragOnEnter = function(info) moveItemTo = info.obj.value end,
		dragOnMouseDown = function(info)
			moveItemFrom, moveItemTo = info.obj.value, nil
		end,
		dragOnMouseUp = function(info)
			SLE:MovableButtonSettings(db, key, moveItemTo, nil, moveItemFrom) --add it in the new spot
			moveItemFrom, moveItemTo = nil, nil
		end,
		stateSwitchGetText = function(info, TEXT)
			local text = C_Item_GetItemInfo(tonumber(TEXT))
			info.userdata.text = text
			return text
		end,
		stateSwitchOnClick = function(info)
			SLE:MovableButtonSettings(db, key, moveItemFrom)
		end,
		values = function()
			local str = db[key]
			if str == "" then
				return nil
			end
			return {strsplit(",", str)}
		end,
		get = function(info, value)
			local str = db[key]
			if str == "" then
				return nil
			end
			local tbl = {strsplit(",", str)}
			return tbl[value]
		end,
		set = function(info, value)
		end
	}
	if CanRemove then --This allows to remove shit
		config.dragOnClick = function(info)
			SLE:MovableButtonSettings(db, key, moveItemFrom, true)
		end
	end
	return config
end

--New API
local function LevelUpBG(frame, topcolor, bottomcolor)
	if not frame then
		return
	end
	if not frame.bg then
		frame.bg = frame:CreateTexture(nil, 'BACKGROUND')
	end
	frame.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	frame.bg:ClearAllPoints()
	frame.bg:SetPoint('CENTER')
	frame.bg:Point('TOPLEFT', frame)
	frame.bg:Point('BOTTOMRIGHT', frame)
	frame.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	frame.bg:SetVertexColor(1, 1, 1, 0.7)

	if not frame.lineTop then
		frame.lineTop = frame:CreateTexture(nil, 'BACKGROUND')
	end
	frame.lineTop:SetDrawLayer('BACKGROUND', 2)
	frame.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	frame.lineTop:ClearAllPoints()
	frame.lineTop:SetPoint('TOP', frame.bg, 0, 4)
	frame.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	frame.lineTop:Size(frame:GetWidth(), 7)

	if not frame.lineBottom then
		frame.lineBottom = frame:CreateTexture(nil, 'BACKGROUND')
	end
	frame.lineBottom:SetDrawLayer('BACKGROUND', 2)
	frame.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	frame.lineBottom:ClearAllPoints()
	frame.lineBottom:SetPoint('BOTTOM', frame.bg, 0, -2)
	frame.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	frame.lineBottom:Size(frame:GetWidth(), 7)

	local ColorCode = {
		['red'] = {1, 0, 0},
		['green'] = {0, 1, 0},
		['blue'] = {0.15, 0.3, 1}
	}
	if topcolor then
		if type(topcolor) == 'table' then
			frame.lineTop:SetVertexColor(unpack(topcolor), 1)
		elseif type(topcolor) == 'string' then
			if ColorCode[topcolor] then
				local r, g, b = unpack(ColorCode[topcolor])
				frame.lineTop:SetVertexColor(r, g, b, 1)
			else
				error(format("Invalid color setting in |cff00FFFFLevelUpBG|r(frame, |cffFF0000topcolor|r, bottomcolor). |cffFFFF00\"%s\"|r is not a supported color.", topcolor))
				return
			end

		else
			error('Invalid color setting in |cff00FFFFLevelUpBG|r(frame, |cffFF0000topcolor|r, bottomcolor).')
			return
		end
	end
	if bottomcolor then
		if type(bottomcolor) == 'table' then
			frame.lineBottom:SetVertexColor(unpack(bottomcolor), 1)
		elseif type(bottomcolor) == 'string' then
			if ColorCode[bottomcolor] then
				local r, g, b = unpack(ColorCode[bottomcolor])
				frame.lineBottom:SetVertexColor(r, g, b, 1)
			else
				error(format("Invalid color setting in |cff00FFFFLevelUpBG|r(frame, [topcolor, |cffFF0000bottomcolor|r). |cffFFFF00\"%s\"|r is not a supported color.", topcolor))
				return
			end
		else
			error("Invalid color setting in |cff00FFFFLevelUpBG|r(frame, [topcolor, |cffFF0000bottomcolor|r).")
			return
		end
	end
end

--Add API
local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.LevelUpBG then
		mt.LevelUpBG = LevelUpBG
	end
end

local handled = {['Frame'] = true}
local object = CreateFrame('Frame')
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

--AF stuff
function SLE:IsFoolsDay()
	if strfind(date(), "04/01/") and not E.global.aprilFoolsSLE and not C_AddOns.IsAddOnLoaded("ElvUI_SLE_Dev") then
		return true
	else
		return false
	end
end
