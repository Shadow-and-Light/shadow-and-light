local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local M = E.Minimap
local MM, DD = SLE.Minimap, SLE.Dropdowns
local LP = SLE.LocationPanel


local _G = _G
local format = format
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local GetScreenHeight = GetScreenHeight
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local IsShiftKeyDown = IsShiftKeyDown
local GetBindLocation = GetBindLocation
local ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat = ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat
local UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK = UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK
local DUNGEON_FLOOR_DALARAN1 = DUNGEON_FLOOR_DALARAN1
local CHALLENGE_MODE = CHALLENGE_MODE
local PlayerHasToy = PlayerHasToy
local C_ToyBox = C_ToyBox
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local loc_panel
local C_Garrison_IsPlayerInGarrison = C_Garrison.IsPlayerInGarrison
local C_Spell_GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local C_Item_GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local C_Item_IsUsableItem = C_Item and C_Item.IsUsableItem or IsUsableItem
local C_PvP_GetZonePVPInfo = C_PvP and C_PvP.GetZonePVPInfo or GetZonePVPInfo

local collectgarbage = collectgarbage

LP.CDformats = {
	["DEFAULT"] = [[ (%s |TInterface\FriendsFrame\StatusIcon-Away:16|t)]],
	["DEFAULT_ICONFIRST"] = [[ (|TInterface\FriendsFrame\StatusIcon-Away:16|t %s)]],
}

LP.ReactionColors = {
	["sanctuary"] = {r = 0.41, g = 0.8, b = 0.94},
	["arena"] = {r = 1, g = 0.1, b = 0.1},
	["friendly"] = {r = 0.1, g = 1, b = 0.1},
	["hostile"] = {r = 1, g = 0.1, b = 0.1},
	["contested"] = {r = 1, g = 0.7, b = 0.10},
	["combat"] = {r = 1, g = 0.1, b = 0.1},
}

LP.MainMenu = {}
LP.SecondaryMenu = {}
LP.RestrictedArea = false

LP.ListUpdating = false
LP.ListBuilding = false
LP.ListBuildAttempts = 0
LP.InfoUpdatingTimer = nil

local function GetDirection()
	local y = select(2, _G.SLE_LocationPanel:GetCenter())
	local screenHeight = GetScreenHeight()
	local anchor, point = 'TOP', 'BOTTOM'

	if y and y < (screenHeight / 2) then
		anchor = 'BOTTOM'
		point = 'TOP'
	end

	return anchor, point
end

function LP:CreateSpellsEntry(id, entryType, useTooltip)
	local entry = {}
	entry.text = C_Spell_GetSpellInfo(id).name
	entry.icon = SLE:GetIconFromID(entryType, id)
	entry.secure = {
		buttonType = entryType,
		ID = id
	}
	entry.UseTooltip = useTooltip

	return entry
end

--{ItemID, ButtonText, isToy}
LP.Hearthstones = {
	{6948}, --Hearthstone
	{54452, nil, true}, --Etherial Portal
	{64488, nil, true}, --The Innkeeper's Daughter
	{93672, nil, true}, --Dark Portal
	{142542, nil, true}, --Tome of Town Portal (Diablo Event)
	{162973, nil, true}, --Winter HS
	{163045, nil, true}, --Hallow HS
	{165669, nil, true}, -- Lunar HS
	{165670, nil, true}, -- Love HS
	{165802, nil, true}, -- Noblegarden HS
	{166746, nil, true}, -- Midsummer HS
	{166747, nil, true}, -- Brewfest HS
	{168907, nil, true}, --Holographic Digitalization Hearthstone
	{172179, nil, true}, --Eternal Traveller
	{183716, nil, true}, --Sinstone
	{182773, nil, true}, --Necrolord HS
	{180290, nil, true}, --Night Fae HS
	{184353, nil, true}, --Kyrian HS
	{188952, nil, true}, --Dominated HS
	{190196, nil, true}, -- Enlightened Hearthstone
	{190237, nil, true}, -- Broker Translocation Matrix
	{208704, nil, true}, -- Deepdweller's Earthen Hearthstone
	{209035, nil, true}, -- Hearthstone of the Flame
	{212337, nil, true}, -- Stone of the Hearth (Hearthstone 10th Anniversary)
	{210455, nil, true}, -- Draenic Hologem
	{193588, nil, true}, -- Timewalker's Hearthstone
}

LP.PortItems = {
	{110560, nil, true}, --Garrison Hearthstone
	{128353}, --Admiral's Compass
	{140192, nil, true}, --Dalaran Hearthstone
	{37863}, --Grim Guzzler
	{52251}, --Jaina's Locket
	{58487}, --Potion of Deepholm
	{43824, nil, true}, --The Schools of Arcane Magic - Mastery
	{64457}, --The Last Relic of Argus
	{141605}, --Flight Masters's Whistle
	{128502}, --Hunter's Seeking Crystal
	{128503}, --Master Hunter's Seeking Crystal
	{140324, nil, true}, --Mobile Telemancy Beacon
	{129276}, --Beginner's Guide to Dimensional Rifting
	{140493}, --Adept's Guide to Dimensional Rifting
	{95567, nil, true}, --Kirin Tor beakon
	{95568, nil, true}, --Sunreaver beakon
	{87548}, --Pandaria Arch
	{180817}, --Cypher of Relocation
	{151016}, --Fractured Necrolyte Skull
	{211788, nil, true}, -- Tess's Peacebloom (Gilneas)
}
LP.EngineerItems = {
	{18984, nil, true}, --Dimensional Ripper - Everlook
	{18986, nil, true}, --Ultrasafe Transporter: Gadgetzan
	{30542, nil, true}, --Dimensional Ripper - Area 52
	{30544, nil, true}, --Ultrasafe Transporter: Toshley's Station
	{48933, nil, true}, --Wormhole Generator: Northrend
	{87215, nil, true}, --Wormhole Generator: Pandaria
	{112059, nil, true}, --Wormhole Centrifuge
	{151652, nil, true}, --Wormhole Generator: Argus
	{168807, nil, true}, --Wormhole Generator: Kul Tiras
	{168808, nil, true}, --Wormhole Generator: Zandalar
	{172924, nil, true}, --Wormhole Generator: Shadowlands
	{198156, nil, true}, -- Wyrmhole Generator (Dragonflight)
}
LP.Spells = {
	DEATHKNIGHT = {
		[1] = LP:CreateSpellsEntry(50977, 'spell', true),
	},
	DEMONHUNTER = {},
	DRUID = {
		[1] = LP:CreateSpellsEntry(18960, 'spell', true), --Moonglade
		[2] = LP:CreateSpellsEntry(147420, 'spell', true), --One With Nature
		[3] = LP:CreateSpellsEntry(193753, 'spell', true), --Druid ClassHall
	},
	EVOKER = {},
	HUNTER = {},
	MAGE = {
		[1] = LP:CreateSpellsEntry(193759, 'spell', true), --Guardian place
	},
	MONK = {
		[1] = LP:CreateSpellsEntry(126892, 'spell', true), -- Zen Pilgrimage
		[2] = LP:CreateSpellsEntry(126895, 'spell', true), -- Zen Pilgrimage: Return
	},
	PALADIN = {},
	PRIEST = {},
	ROGUE = {},
	SHAMAN = {
		[1] = LP:CreateSpellsEntry(556, 'spell', true),
	},
	WARLOCK = {},
	WARRIOR = {},
	racials = {
		DarkIronDwarf = {
			[1] = LP:CreateSpellsEntry(265225, 'spell', true), -- Mole Machine (Dark Iron Dwarfs)
		},
		Vulpera = {
			[1] = LP:CreateSpellsEntry(312370, 'spell', true), -- Make Camp
			[2] = LP:CreateSpellsEntry(312372, 'spell', true), -- Return to Camp
		},
	},

	teleports = {
		Horde = {
			[1] = LP:CreateSpellsEntry(3563, 'spell', true), -- TP:Undercity
			[2] = LP:CreateSpellsEntry(3566, 'spell', true), -- TP:Thunder Bluff
			[3] = LP:CreateSpellsEntry(3567, 'spell', true), -- TP:Orgrimmar
			[4] = LP:CreateSpellsEntry(32272, 'spell', true), -- TP:Silvermoon
			[5] = LP:CreateSpellsEntry(49358, 'spell', true), -- TP:Stonard
			[6] = LP:CreateSpellsEntry(35715, 'spell', true), -- TP:Shattrath
			[7] = LP:CreateSpellsEntry(53140, 'spell', true), -- TP:Dalaran - Northrend
			[8] = LP:CreateSpellsEntry(88344, 'spell', true), -- TP:Tol Barad
			[9] = LP:CreateSpellsEntry(132627, 'spell', true), -- TP:Vale of Eternal Blossoms
			[10] = LP:CreateSpellsEntry(120145, 'spell', true), -- TP:Ancient Dalaran
			[11] = LP:CreateSpellsEntry(176242, 'spell', true), -- TP:Warspear
			[12] = LP:CreateSpellsEntry(224869, 'spell', true), -- TP:Dalaran - BI
			[13] = LP:CreateSpellsEntry(281404, 'spell', true), -- TP:Dazar'alor
			[14] = LP:CreateSpellsEntry(344587, 'spell', true), -- TP:Oribos
			[15] = LP:CreateSpellsEntry(395277, 'spell', true), -- TP:Valdrakken
			[16] = LP:CreateSpellsEntry(446540, 'spell', true), -- TP:Dornogal
		},
		Alliance = {
			[1] = LP:CreateSpellsEntry(3561, 'spell', true), -- TP:Stormwind
			[2] = LP:CreateSpellsEntry(3562, 'spell', true), -- TP:Ironforge
			[3] = LP:CreateSpellsEntry(3565, 'spell', true), -- TP:Darnassus
			[4] = LP:CreateSpellsEntry(32271, 'spell', true), -- TP:Exodar
			[5] = LP:CreateSpellsEntry(49359, 'spell', true), -- TP:Theramore
			[6] = LP:CreateSpellsEntry(33690, 'spell', true), -- TP:Shattrath
			[7] = LP:CreateSpellsEntry(53140, 'spell', true), -- TP:Dalaran - Northrend
			[8] = LP:CreateSpellsEntry(88342, 'spell', true), -- TP:Tol Barad
			[9] = LP:CreateSpellsEntry(132621, 'spell', true), -- TP:Vale of Eternal Blossoms
			[10] = LP:CreateSpellsEntry(120145, 'spell', true), -- TP:Ancient Dalaran
			[11] = LP:CreateSpellsEntry(176248, 'spell', true), -- TP:StormShield
			[12] = LP:CreateSpellsEntry(224869, 'spell', true), -- TP:Dalaran - BI
			[13] = LP:CreateSpellsEntry(281403, 'spell', true), -- TP:Boralus
			[14] = LP:CreateSpellsEntry(344587, 'spell', true), -- TP:Oribos
			[15] = LP:CreateSpellsEntry(395277, 'spell', true), -- TP:Valdrakken
			[16] = LP:CreateSpellsEntry(446540, 'spell', true), -- TP:Dornogal
		},
	},
	portals = {
		Horde = {
			[1] = LP:CreateSpellsEntry(11418, 'spell', true), -- P:Undercity
			[2] = LP:CreateSpellsEntry(11420, 'spell', true), -- P:Thunder Bluff
			[3] = LP:CreateSpellsEntry(11417, 'spell', true), -- P:Orgrimmar
			[4] = LP:CreateSpellsEntry(32267, 'spell', true), -- P:Silvermoon
			[5] = LP:CreateSpellsEntry(49361, 'spell', true), -- P:Stonard
			[6] = LP:CreateSpellsEntry(35717, 'spell', true), -- P:Shattrath
			[7] = LP:CreateSpellsEntry(53142, 'spell', true), -- P:Dalaran - Northred
			[8] = LP:CreateSpellsEntry(88346, 'spell', true), -- P:Tol Barad
			[9] = LP:CreateSpellsEntry(120146, 'spell', true), -- P:Ancient Dalaran
			[10] = LP:CreateSpellsEntry(132626, 'spell', true), -- P:Vale of Eternal Blossoms
			[11] = LP:CreateSpellsEntry(176244, 'spell', true), -- P:Warspear
			[12] = LP:CreateSpellsEntry(224871, 'spell', true), -- P:Dalaran - BI
			[13] = LP:CreateSpellsEntry(281402, 'spell', true), -- P:Dazar'alor
			[14] = LP:CreateSpellsEntry(344597, 'spell', true), -- P:Oribos
			[15] = LP:CreateSpellsEntry(395289, 'spell', true), -- P:Valdrakken
			[16] = LP:CreateSpellsEntry(446534, 'spell', true), -- P:Dornogal
		},
		Alliance = {
			[1] = LP:CreateSpellsEntry(10059, 'spell', true), -- P:Stormwind
			[2] = LP:CreateSpellsEntry(11416, 'spell', true), -- P:Ironforge
			[3] = LP:CreateSpellsEntry(11419, 'spell', true), -- P:Darnassus
			[4] = LP:CreateSpellsEntry(32266, 'spell', true), -- P:Exodar
			[5] = LP:CreateSpellsEntry(49360, 'spell', true), -- P:Theramore
			[6] = LP:CreateSpellsEntry(33691, 'spell', true), -- P:Shattrath
			[7] = LP:CreateSpellsEntry(53142, 'spell', true), -- P:Dalaran - Northred
			[8] = LP:CreateSpellsEntry(88345, 'spell', true), -- P:Tol Barad
			[9] = LP:CreateSpellsEntry(120146, 'spell', true), -- P:Ancient Dalaran
			[10] = LP:CreateSpellsEntry(132620, 'spell', true), -- P:Vale of Eternal Blossoms
			[11] = LP:CreateSpellsEntry(176246, 'spell', true), -- P:StormShield
			[12] = LP:CreateSpellsEntry(224871, 'spell', true), -- P:Dalaran - BI
			[13] = LP:CreateSpellsEntry(281400, 'spell', true), -- P:Boralus
			[14] = LP:CreateSpellsEntry(344597, 'spell', true), -- P:Oribos
			[15] = LP:CreateSpellsEntry(395289, 'spell', true), -- P:Valdrakken
			[16] = LP:CreateSpellsEntry(446534, 'spell', true), -- P:Dornogal
		},
	},
	challenge = {
		[1] = LP:CreateSpellsEntry(131204, 'spell', true), -- Temple of the Jade Serpent (Path of the Jade Serpent)
		[2] = LP:CreateSpellsEntry(131205, 'spell', true), -- Stormstout Brewery (Path of the Stout Brew)
		[3] = LP:CreateSpellsEntry(131206, 'spell', true), -- Shado-Pan Monastery (Path of the Shado-Pan)
		[4] = LP:CreateSpellsEntry(131222, 'spell', true), -- Mogu'shan Palace (Path of the Mogu King)
		[5] = LP:CreateSpellsEntry(131225, 'spell', true), -- Gate of the Setting Sun (Path of the Setting Sun)
		[6] = LP:CreateSpellsEntry(131231, 'spell', true), -- Scarlet Halls (Path of the Scarlet Blade)
		[7] = LP:CreateSpellsEntry(131229, 'spell', true), -- Scarlet Monastery (Path of the Scarlet Mitre)
		[8] = LP:CreateSpellsEntry(131232, 'spell', true), -- Scholomance (Path of the Necromancer)
		[9] = LP:CreateSpellsEntry(131228, 'spell', true), -- Siege of Niuzao (Path of the Black Ox)
		[10] = LP:CreateSpellsEntry(159895, 'spell', true), -- Bloodmaul Slag Mines (Path of the Bloodmaul)
		[11] = LP:CreateSpellsEntry(159902, 'spell', true), -- Upper Blackrock Spire (Path of the Burning Mountain)
		[12] = LP:CreateSpellsEntry(159899, 'spell', true), -- Shadowmoon Burial Grounds (Path of the Crescent Moon)
		[13] = LP:CreateSpellsEntry(159900, 'spell', true), -- Grimrail Depot (Path of the Dark Rail)
		[14] = LP:CreateSpellsEntry(159896, 'spell', true), -- Iron Docks (Path of the Iron Prow)
		[15] = LP:CreateSpellsEntry(159898, 'spell', true), -- Skyreach (Path of the Skies)
		[16] = LP:CreateSpellsEntry(159901, 'spell', true), -- Everbloom (Path of the Verdant)
		[17] = LP:CreateSpellsEntry(159897, 'spell', true), -- Auchindoun (Path of the Vigilant)
		[18] = LP:CreateSpellsEntry(354468, 'spell', true), -- De Other Side (Path of the Scheming Loa)
		[19] = LP:CreateSpellsEntry(354465, 'spell', true), -- Halls of Atonement (Path of the Sinful Soul)
		[20] = LP:CreateSpellsEntry(354464, 'spell', true), -- Mists of Tirna Scithe (Path of the Misty Forest)
		[21] = LP:CreateSpellsEntry(354463, 'spell', true), -- Plaguefall (Path of the Plagued)
		[22] = LP:CreateSpellsEntry(354469, 'spell', true), -- Sanguine Depths (Path of the Stone Warden)
		[23] = LP:CreateSpellsEntry(354466, 'spell', true), -- Spires of Ascension (Path of the Ascendant)
		[24] = LP:CreateSpellsEntry(354462, 'spell', true), -- Necrotic Wake (Path of the Courageous)
		[25] = LP:CreateSpellsEntry(354467, 'spell', true), -- Theater of Pain (Path of the Undefeated)
		[26] = LP:CreateSpellsEntry(367416, 'spell', true), -- Tazavesh, the Veiled Market (Path of the Streetwise Merchant)
		[27] = LP:CreateSpellsEntry(373274, 'spell', true), -- Mechagon (Path of the Scrappy Prince)
		[28] = LP:CreateSpellsEntry(373262, 'spell', true), -- Karazhan (Path of the Fallen Guardian)
		[29] = LP:CreateSpellsEntry(373190, 'spell', true), -- Castle Nathria (Path of the Sire)
		[30] = LP:CreateSpellsEntry(373191, 'spell', true), -- Sanctum of Domination (Path of the Tormented Soul)
		[31] = LP:CreateSpellsEntry(373192, 'spell', true), -- Sepulcher of the First Ones (Path of the First Ones)
		[32] = LP:CreateSpellsEntry(393222, 'spell', true), -- Uldaman: Legacy of Tyr (Path of the Watcher's Legacy)
		[33] = LP:CreateSpellsEntry(393256, 'spell', true), -- Ruby Life Pools (Path of the Clutch Defender)
		[34] = LP:CreateSpellsEntry(393262, 'spell', true), -- The Nokhud Offensive (Path of the Windswept Plains)
		[35] = LP:CreateSpellsEntry(393267, 'spell', true), -- Brackenhide (Path of the Rotting Woods)
		[36] = LP:CreateSpellsEntry(393273, 'spell', true), -- Algeth'ar Academy (Path of the Draconic Diploma)
		[37] = LP:CreateSpellsEntry(393276, 'spell', true), -- Neltharus (Path of the Obsidian Hoard)
		[38] = LP:CreateSpellsEntry(393279, 'spell', true), -- Azur Vault (Path of Arcane Secrets)
		[39] = LP:CreateSpellsEntry(393283, 'spell', true), -- Halls of Infusion (Path of the Titanic Reservoir)
		[40] = LP:CreateSpellsEntry(393764, 'spell', true), -- Halls of Valor (Path of Proven Worth)
		[41] = LP:CreateSpellsEntry(393766, 'spell', true), -- Court of Stars (Path of the Grand Magistrix)
		[42] = LP:CreateSpellsEntry(410071, 'spell', true), -- Freehold (Path of the Freebooter)
        [43] = LP:CreateSpellsEntry(410074, 'spell', true), -- Underrot (Path of the Festering Rot)
        [44] = LP:CreateSpellsEntry(410078, 'spell', true), -- Neltharion's Lair (Path of the Earth-Warder)
        [45] = LP:CreateSpellsEntry(410080, 'spell', true), -- The Vortex Pinacle (Path of Wind's Domain)
		[46] = LP:CreateSpellsEntry(424142, 'spell', true), -- Teleport to Throne of the Tides (Path of the Tidehunter)
		[47] = LP:CreateSpellsEntry(424153, 'spell', true), -- Teleport to Black Rock Hold (Path of Ancient Horrors)
		[48] = LP:CreateSpellsEntry(424163, 'spell', true), -- Teleport to Darkheart Thicket (Path of the Nightmare Lord)
		[49] = LP:CreateSpellsEntry(424167, 'spell', true), -- Teleport to Waycrest Manor (Path of Heart's Bane)
		[50] = LP:CreateSpellsEntry(424187, 'spell', true), -- Teleport to Atal'Dazar (Path of the Golden Tomb)
		[51] = LP:CreateSpellsEntry(424197, 'spell', true), -- Teleport to Dawn of the Infinite (Path of Twisted Time)
	},
}

function LP:CreateLocationPanel()
	loc_panel = CreateFrame('Frame', 'SLE_LocationPanel', E.UIParent, 'BackdropTemplate')
	loc_panel:Point('TOP', E.UIParent, 'TOP', 0, -E.mult -22)
	loc_panel:SetFrameStrata('MEDIUM')
	loc_panel:SetFrameLevel(2)
	loc_panel:EnableMouse(true)
	loc_panel:SetScript('OnMouseUp', LP.OnClick)
	loc_panel:SetScript('OnUpdate', LP.UpdateCoords)

	-- Location Text
	loc_panel.Text = loc_panel:CreateFontString(nil, 'BORDER')
	loc_panel.Text:Point('CENTER', 0, 0)
	loc_panel.Text:SetWordWrap(false)
	E.FrameLocks[loc_panel] = true

	--Coords
	loc_panel.Xcoord = CreateFrame('Frame', 'SLE_LocationPanel_X', loc_panel, 'BackdropTemplate')
	-- loc_panel.Xcoord:SetPoint('RIGHT', loc_panel, 'LEFT', 1 - 2*E.Spacing, 0)
	loc_panel.Xcoord:Point('RIGHT', loc_panel, 'LEFT', 1, 0)
	loc_panel.Xcoord.Text = loc_panel.Xcoord:CreateFontString(nil, 'BORDER')
	loc_panel.Xcoord.Text:Point('CENTER', 0, 0)

	loc_panel.Ycoord = CreateFrame('Frame', 'SLE_LocationPanel_Y', loc_panel, 'BackdropTemplate')
	-- loc_panel.Ycoord:SetPoint('LEFT', loc_panel, 'RIGHT', -1 + 2*E.Spacing, 0)
	loc_panel.Ycoord:Point('LEFT', loc_panel, 'RIGHT', -1, 0)
	loc_panel.Ycoord.Text = loc_panel.Ycoord:CreateFontString(nil, 'BORDER')
	loc_panel.Ycoord.Text:Point('CENTER', 0, 0)

	LP:Resize()
	-- Mover
	E:CreateMover(loc_panel, 'SLE_Location_Mover', L["Location Panel"], nil, nil, nil, 'ALL,S&L,S&L MISC')

	LP.Menu1 = CreateFrame('Frame', 'SLE_LocationPanel_RightClickMenu1', E.UIParent, 'BackdropTemplate')
	LP.Menu1:SetTemplate('Transparent', true)
	LP.Menu2 = CreateFrame('Frame', 'SLE_LocationPanel_RightClickMenu2', E.UIParent, 'BackdropTemplate')
	LP.Menu2:SetTemplate('Transparent', true)
	DD:RegisterMenu(LP.Menu1)
	DD:RegisterMenu(LP.Menu2)
	LP.Menu1:SetScript('OnHide', function() wipe(LP.MainMenu) end)
	LP.Menu2:SetScript('OnHide', function() wipe(LP.SecondaryMenu) end)
end

function LP:OnClick(btn)
	local zoneText = GetRealZoneText() or UNKNOWN
	if btn == 'LeftButton' then
		if IsShiftKeyDown() and LP.db.linkcoords then
			local edit_box = ChatEdit_ChooseBoxForSend()
			local message
			local coords = format(LP.db.format, E.MapInfo.xText or 0)..', '..format(LP.db.format, E.MapInfo.yText or 0)
				if zoneText ~= GetSubZoneText() then
					message = format('%s: %s (%s)', zoneText, GetSubZoneText(), coords)
				else
					message = format('%s (%s)', zoneText, coords)
				end
			ChatEdit_ActivateChat(edit_box)
			edit_box:Insert(message)
		else
			ToggleFrame(_G.WorldMapFrame)
		end
	elseif btn == 'RightButton' and LP.db.portals.enable and not InCombatLockdown() then
		if LP.ListBuilding then SLE:Print(L["Info for some items is not available yet. Please try again later"], 'info') return end
		LP:PopulateDropdown(true)
	end
end

function LP:UpdateCoords(elapsed)
	if not E.db.sle.minimap.locPanel.enable then return end
	LP.elapsed = (LP.elapsed or 0) + elapsed
	if LP.elapsed < (LP.db.throttle or 0.2) then return end
	if not LP.db.format then return end

	--Coords
	if E.MapInfo then
		loc_panel.Xcoord.Text:SetText(format(LP.db.format, E.MapInfo.xText or 0))
		loc_panel.Ycoord.Text:SetText(format(LP.db.format, E.MapInfo.yText or 0))
	else
		loc_panel.Xcoord.Text:SetText('-')
		loc_panel.Ycoord.Text:SetText('-')
	end
	--Coords coloring
	local colorC = {r = 1, g = 1, b = 1}
	if LP.db.coords.colorType == 'REACTION' then
		local inInstance, _ = IsInInstance()
		if inInstance then
			colorC = {r = 1, g = 0.1, b = 0.1}
		else
			local pvpType = C_PvP_GetZonePVPInfo()
			colorC = LP.ReactionColors[pvpType] or {r = 1, g = 1, b = 0}
		end
	elseif LP.db.coords.colorType == 'CUSTOM' then
		colorC = LP.db.coords.customColor
	elseif LP.db.coords.colorType == 'CLASS' then
		colorC = RAID_CLASS_COLORS[E.myclass]
	end
	loc_panel.Xcoord.Text:SetTextColor(colorC.r, colorC.g, colorC.b)
	loc_panel.Ycoord.Text:SetTextColor(colorC.r, colorC.g, colorC.b)

	--Location
	local subZoneText = E.MapInfo.subZoneText or ''
	local zoneText = E.MapInfo.zoneText or UNKNOWN
	local displayLine
	if LP.db.zoneText then
		if (subZoneText ~= '') and (subZoneText ~= zoneText) then
			displayLine = zoneText .. ': ' .. subZoneText
		else
			displayLine = subZoneText
		end
	else
		displayLine = subZoneText
	end

	loc_panel.Text:SetText(displayLine)
	if LP.db.autowidth then loc_panel:Width(loc_panel.Text:GetStringWidth() + 10) end

	--Location Colorings
	if displayLine ~= '' then
		local color = {r = 1, g = 1, b = 1}
		if LP.db.colorType == 'REACTION' then
			local inInstance, _ = IsInInstance()
			if inInstance then
				color = {r = 1, g = 0.1,b =  0.1}
			else
				local pvpType = C_PvP_GetZonePVPInfo()
				color = LP.ReactionColors[pvpType] or {r = 1, g = 1, b = 0}
			end
		elseif LP.db.colorType == 'CUSTOM' then
			color = LP.db.customColor
		elseif LP.db.colorType == 'CLASS' then
			color = RAID_CLASS_COLORS[E.myclass]
		end
		loc_panel.Text:SetTextColor(color.r, color.g, color.b)
	end

	LP.elapsed = 0
end

function LP:Resize()
	local coordSize = LP.db.fontSize * 3
	local panelHeight = LP.db.height
	local panelWidth = LP.db.width

	if LP.db.autowidth then
		local stringWidth = loc_panel.Text:GetStringWidth() + 10
		panelWidth = (stringWidth >= E.screenWidth and E.screenWidth) or stringWidth
		loc_panel:SetSize(panelWidth, panelHeight)
	else
		loc_panel:SetSize(panelWidth, panelHeight)
	end
	loc_panel.Text:Width(panelWidth - 18)
	loc_panel.Xcoord:SetSize(coordSize, panelHeight)
	loc_panel.Ycoord:SetSize(coordSize, panelHeight)

	loc_panel.Xcoord:SetShown(LP.db.coords.enable)
	loc_panel.Ycoord:SetShown(LP.db.coords.enable)
end

function LP:Fonts()
	loc_panel.Text:FontTemplate(E.LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Xcoord.Text:FontTemplate(E.LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Ycoord.Text:FontTemplate(E.LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
end

function LP:Template()
	loc_panel:SetTemplate(LP.db.template)
	loc_panel.Xcoord:SetTemplate(LP.db.template)
	loc_panel.Ycoord:SetTemplate(LP.db.template)
end

function LP:CheckForIncompatible()
	if C_AddOns_IsAddOnLoaded('ElvUI_LocLite') and E.db.sle.minimap.locPanel.enable then
		SLE:IncompatibleAddOn('ElvUI_LocLite', 'Location Panel', E.db.sle.minimap.locPanel.enable, 'enable')
	end
end

function LP:Toggle()
	if LP.db.enable then
		LP:CheckForIncompatible()
		loc_panel:Show()
		E:EnableMover(loc_panel.mover:GetName())
	else
		loc_panel:Hide()
		E:DisableMover(loc_panel.mover:GetName())
	end
	LP:UNIT_AURA(nil, 'player')
end

function LP:PopulateItems()
	local noItem = false

	for _, data in pairs(LP.Hearthstones) do
		if select(2, C_Item_GetItemInfo(data[1])) == nil then noItem = true end
	end
	for _, data in pairs(LP.PortItems) do
		if select(2, C_Item_GetItemInfo(data[1])) == nil then noItem = true end
	end
	for _, data in pairs(LP.EngineerItems) do
		if select(2, C_Item_GetItemInfo(data[1])) == nil then noItem = true end
	end

	if noItem and LP.ListBuildAttempts < 15 then
		LP.ListBuilding = true
		LP.ListBuildAttempts = LP.ListBuildAttempts + 1
		E:Delay(2, LP.PopulateItems)
	else
		LP.ListBuilding = false
		LP.ListBuildAttempts = 0
		for index, data in pairs(LP.Hearthstones) do
			local id, name, toy = data[1], data[2], data[3]
			if select(2, C_Item_GetItemInfo(id)) then
				LP.Hearthstones[index] = {text = name or C_Item_GetItemInfo(id), icon = SLE:GetIconFromID('item', id),secure = {buttonType = 'item',ID = id, isToy = toy}, UseTooltip = true,}
			else
				LP.EngineerItems[index] = { text = UNKNOWN }
			end
		end
		for index, data in pairs(LP.PortItems) do
			local id, name, toy = data[1], data[2], data[3]
			if select(2, C_Item_GetItemInfo(id)) then
				LP.PortItems[index] = {text = name or C_Item_GetItemInfo(id), icon = SLE:GetIconFromID('item', id),secure = {buttonType = 'item',ID = id, isToy = toy}, UseTooltip = true,}
			else
				LP.EngineerItems[index] = { text = UNKNOWN }
			end
		end
		for index, data in pairs(LP.EngineerItems) do
			local id, name, toy = data[1], data[2], data[3]
			if select(2, C_Item_GetItemInfo(id)) then
				LP.EngineerItems[index] = { text = name or C_Item_GetItemInfo(id), icon = SLE:GetIconFromID('item', id),secure = {buttonType = 'item',ID = id, isToy = toy}, UseTooltip = true,}
			else
				LP.EngineerItems[index] = { text = UNKNOWN }
			end
		end
	end
end

function LP:ItemList()
	if LP.db.portals.HSplace then tinsert(LP.MainMenu, {text = L["Hearthstone Location"]..": "..GetBindLocation(), title = true, nohighlight = true}) end
	tinsert(LP.MainMenu, {text = ITEMS..':', title = true, nohighlight = true})

	if LP.db.portals.showHearthstones then
		local priority = 100
		local ShownHearthstone
		local tmp = {}
		local hsPrio = {strsplit(',', E.db.sle.minimap.locPanel.portals.hsPrio)}
		local hsRealPrio = {}
		for key = 1, #hsPrio do hsRealPrio[hsPrio[key]] = key end
		for i = 1, #LP.Hearthstones do
			local data = LP.Hearthstones[i]
			local ID, isToy = data.secure.ID, data.secure.isToy
			isToy = (LP.db.portals.showToys and isToy)
			if not LP.db.portals.ignoreMissingInfo and ((isToy and PlayerHasToy(ID)) and C_ToyBox.IsToyUsable(ID) == nil) then return false end
			if (not isToy and (SLE:BagSearch(ID) and C_Item_IsUsableItem(ID))) or (isToy and (PlayerHasToy(ID) and C_ToyBox.IsToyUsable(ID))) then
				if data.text then
					if not isToy then
						ShownHearthstone = data
						break
					else
						local curPriorirty = hsRealPrio[tostring(ID)]

						if curPriorirty and curPriorirty < priority then
							priority = curPriorirty
							ShownHearthstone = data
						end

						if priority == 1 then break end
					end
				end
			end
		end
		if ShownHearthstone then
			local data = ShownHearthstone
			-- local ID, isToy = data.secure.ID, data.secure.isToy  -- isToy isn't even used here
			local ID = data.secure.ID
			local cd = DD:GetCooldown('Item', ID)
			E:CopyTable(tmp, data)
			if cd or (tonumber(cd) and tonumber(cd) > 1.5) then
				tmp.text = '|cff636363'..tmp.text..'|r'..format(LP.CDformats[LP.db.portals.cdFormat], cd)
				tinsert(LP.MainMenu, tmp)
			else
				tinsert(LP.MainMenu, data)
			end
		end
	end

	for i = 1, #LP.PortItems do
		local tmp = {}
		local data = LP.PortItems[i]
		local ID, isToy = data.secure.ID, data.secure.isToy
		isToy = (LP.db.portals.showToys and isToy)
		if not LP.db.portals.ignoreMissingInfo and ((isToy and PlayerHasToy(ID)) and C_ToyBox.IsToyUsable(ID) == nil) then return false end
		if ((not isToy and (SLE:BagSearch(ID) and C_Item_IsUsableItem(ID))) or (isToy and (PlayerHasToy(ID) and C_ToyBox.IsToyUsable(ID)))) then
			if data.text then
				local cd = DD:GetCooldown('Item', ID)
				E:CopyTable(tmp, data)
				if cd or (tonumber(cd) and tonumber(cd) > 2) then
					tmp.text = '|cff636363'..tmp.text..'|r'..format(LP.CDformats[LP.db.portals.cdFormat], cd)
					tinsert(LP.MainMenu, tmp)
				else
					tinsert(LP.MainMenu, data)
				end
			end
		end
	end

	if LP.db.portals.showEngineer and LP.isEngineer then
		tinsert(LP.MainMenu, {text = LP.EngineerName..':', title = true, nohighlight = true})
		for i = 1, #LP.EngineerItems do
			local tmp = {}
			local data = LP.EngineerItems[i]
			local ID, isToy = data.secure.ID, data.secure.isToy
			if not LP.db.portals.ignoreMissingInfo and ((isToy and PlayerHasToy(ID)) and C_ToyBox.IsToyUsable(ID) == nil) then return false end
			if (not isToy and (SLE:BagSearch(ID) and C_Item_IsUsableItem(ID))) or (isToy and (PlayerHasToy(ID) and C_ToyBox.IsToyUsable(ID))) then
				if data.text then
					local cd = DD:GetCooldown('Item', ID)
					E:CopyTable(tmp, data)
					if cd or (tonumber(cd) and tonumber(cd) > 2) then
						tmp.text = '|cff636363'..tmp.text..'|r'..format(LP.CDformats[LP.db.portals.cdFormat], cd)
						tinsert(LP.MainMenu, tmp)
					else
						tinsert(LP.MainMenu, data)
					end

				end
			end
		end
	end

	return true
end

function LP:SpellList(list, dropdown, check)
	for i = 1, #list do
		local tmp = {}
		local data = list[i]
		if IsSpellKnown(data.secure.ID) then
			if check then
				return true
			else
				if data.text then
					local cd = DD:GetCooldown('Spell', data.secure.ID)
					if cd or (tonumber(cd) and tonumber(cd) > 1.5) then
						E:CopyTable(tmp, data)
						tmp.text = '|cff636363'..tmp.text..'|r'..format(LP.CDformats[LP.db.portals.cdFormat], cd)
						tinsert(dropdown, tmp)
					else
						tinsert(dropdown, data)
					end
				end
			end
		end
	end
end

function LP:PopulateDropdown(click)
	if LP.ListUpdating and click then
		SLE:Print(L["Update canceled."])
		LP.ListUpdating = false
		if LP.InfoUpdatingTimer then LP:CancelTimer(LP.InfoUpdatingTimer) end
		return
	end
	LP.InfoUpdatingTimer = nil
	if LP.Menu1:IsShown() then ToggleFrame(LP.Menu1) return end
	if LP.Menu2:IsShown() then ToggleFrame(LP.Menu2) return end
	local full_list = LP:ItemList()
	if not full_list then
		if not LP.ListUpdating then SLE:Print(L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."], "error"); LP.ListUpdating = true end
		if not LP.InfoUpdatingTimer then LP.InfoUpdatingTimer = LP:ScheduleTimer(LP.PopulateDropdown, 3) end
		wipe(LP.MainMenu)
		return
	end
	if LP.ListUpdating then LP.ListUpdating = false; SLE:Print(L["Update complete. Opening menu."]) end
	local anchor, point = GetDirection()
	local MENU_WIDTH

	if LP.db.portals.showSpells then
		if LP:SpellList(LP.Spells[E.myclass], nil, true) or LP:SpellList(LP.Spells.challenge, nil, true) or E.myclass == 'MAGE' or LP.Spells['racials'][E.myrace] then
			tinsert(LP.MainMenu, {text = SPELLS..':', title = true, nohighlight = true})
			LP:SpellList(LP.Spells[E.myclass], LP.MainMenu)
			if LP:SpellList(LP.Spells.challenge, nil, true) then
				tinsert(LP.MainMenu, {text = CHALLENGE_MODE..' >>',icon = SLE:GetIconFromID('achiev', 6378), func = function()
					wipe(LP.SecondaryMenu)
					MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G.SLE_LocationPanel:GetWidth()
					tinsert(LP.SecondaryMenu, {text = '<< '..BACK, func = function() wipe(LP.MainMenu); ToggleFrame(LP.Menu2); LP:PopulateDropdown() end})
					tinsert(LP.SecondaryMenu, {text = CHALLENGE_MODE..':', title = true, nohighlight = true})
					LP:SpellList(LP.Spells.challenge, LP.SecondaryMenu)
					tinsert(LP.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() wipe(LP.MainMenu); wipe(LP.SecondaryMenu); ToggleFrame(LP.Menu2) end})
					SLE:DropDown(LP.SecondaryMenu, LP.Menu2, anchor, point, 0, 1, _G.SLE_LocationPanel, MENU_WIDTH, LP.db.portals.justify)
				end})
			end
			if E.myclass == 'MAGE' then
				tinsert(LP.MainMenu, {text = L["Teleports"]..' >>', icon = SLE:GetIconFromID('spell', 53140), func = function()
					wipe(LP.SecondaryMenu)
					MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G.SLE_LocationPanel:GetWidth()
					tinsert(LP.SecondaryMenu, {text = '<< '..BACK, func = function() wipe(LP.MainMenu); ToggleFrame(LP.Menu2); LP:PopulateDropdown() end})
					tinsert(LP.SecondaryMenu, {text = L["Teleports"]..':', title = true, nohighlight = true})
					LP:SpellList(LP.Spells['teleports'][E.myfaction], LP.SecondaryMenu)
					tinsert(LP.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() wipe(LP.MainMenu); wipe(LP.SecondaryMenu); ToggleFrame(LP.Menu2) end})
					SLE:DropDown(LP.SecondaryMenu, LP.Menu2, anchor, point, 0, 1, _G.SLE_LocationPanel, MENU_WIDTH, LP.db.portals.justify)
				end})
				tinsert(LP.MainMenu, {text = L["Portals"]..' >>',icon = SLE:GetIconFromID('spell', 53142), func = function()
					wipe(LP.SecondaryMenu)
					MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G.SLE_LocationPanel:GetWidth()
					tinsert(LP.SecondaryMenu, {text = '<< '..BACK, func = function() wipe(LP.MainMenu); ToggleFrame(LP.Menu2) LP:PopulateDropdown() end})
					tinsert(LP.SecondaryMenu, {text = L["Portals"]..':', title = true, nohighlight = true})
					LP:SpellList(LP.Spells['portals'][E.myfaction], LP.SecondaryMenu)
					tinsert(LP.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() wipe(LP.MainMenu); wipe(LP.SecondaryMenu); ToggleFrame(LP.Menu2) end})
					SLE:DropDown(LP.SecondaryMenu, LP.Menu2, anchor, point, 0, 1, _G.SLE_LocationPanel, MENU_WIDTH, LP.db.portals.justify)
				end})
			end
			if LP.Spells['racials'][E.myrace] then
				LP:SpellList(LP.Spells['racials'][E.myrace], LP.MainMenu)
			end
		end
	end
	tinsert(LP.MainMenu, {text = CLOSE, title = true, ending = true, func = function() wipe(LP.MainMenu); wipe(LP.SecondaryMenu); ToggleFrame(LP.Menu1) end})
	MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G.SLE_LocationPanel:GetWidth()
	SLE:DropDown(LP.MainMenu, LP.Menu1, anchor, point, 0, 1, _G.SLE_LocationPanel, MENU_WIDTH, LP.db.portals.justify)

	collectgarbage('collect')
end

function LP:GetProf()
	LP.EngineerName = C_Spell_GetSpellInfo(4036).name
	LP:CHAT_MSG_SKILL()
end

function LP:CHAT_MSG_SKILL()
	local prof1, prof2 = GetProfessions()
	local name

	if prof1 then
		name = GetProfessionInfo(prof1)
		if name == LP.EngineerName then LP.isEngineer = true return end
	end
	if prof2 then
		name = GetProfessionInfo(prof2)
		if name == LP.EngineerName then LP.isEngineer = true return end
	end
end

function LP:PLAYER_REGEN_DISABLED()
	if LP.db.combathide then loc_panel:SetAlpha(0) end
end

function LP:PLAYER_REGEN_ENABLED()
	if LP.db.enable then loc_panel:SetAlpha(1) end
end

function LP:UNIT_AURA(_, unit)
	if unit ~= 'player' then return end
	if LP.db.enable and LP.db.orderhallhide then
		local inOrderHall = C_Garrison_IsPlayerInGarrison(Enum.GarrisonType.Type_7_0)
		if inOrderHall then
			loc_panel:SetAlpha(0)
		else
			loc_panel:SetAlpha(1)
		end
	end
end

function LP:Initialize()
	LP.db = E.db.sle.minimap.locPanel
	if not SLE.initialized then return end
	LP.elapsed = 0

	LP:PopulateItems()
	LP:GetProf()
	LP:CreateLocationPanel()
	LP:Template()
	LP:Fonts()
	LP:Toggle()

	function LP:ForUpdateAll()
		LP.db = E.db.sle.minimap.locPanel
		LP:Resize()
		LP:Template()
		LP:Fonts()
		LP:Toggle()
	end

	LP:RegisterEvent('PLAYER_REGEN_DISABLED')
	LP:RegisterEvent('PLAYER_REGEN_ENABLED')
	LP:RegisterEvent('UNIT_AURA')
	LP:RegisterEvent('CHAT_MSG_SKILL')

	LP:CreatePortalButtons()
end

SLE:RegisterModule(LP:GetName())
