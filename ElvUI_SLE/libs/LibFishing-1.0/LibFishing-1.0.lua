--[[
Name: LibFishing-1.0
Maintainers: Sutorix <sutorix@hotmail.com>
Description: A library with fishing support routines used by Fishing Buddy, Fishing Ace and FB_Broker.
Copyright (c) by Bob Schumaker
Licensed under a Creative Commons "Attribution Non-Commercial Share Alike" License
--]]
--[[Modded and name altered for purpose of S&L's profession module.]]

local MAJOR_VERSION = "LibFishing-1.0-SLE"
local MINOR_VERSION = 101074
-- 5.0.4 has a problem with a global "_" (see some for loops below)
local _

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end

local FishLib, lastVersion = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not FishLib then
	return
end

FishLib.UNKNOWN = "UNKNOWN";
FishLib.caughtSoFar = 0;
FishLib.gearcheck = true;
FishLib.hasgear = false;

local PROFESSIONS_FISHING, INVSLOT_MAINHAND = PROFESSIONS_FISHING, INVSLOT_MAINHAND
local ipairs = ipairs
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemID = GetInventoryItemID
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local UnitBuff = UnitBuff
local GetItemCooldown = GetItemCooldown
local GetProfessions, GetProfessionInfo = GetProfessions, GetProfessionInfo
local GetItemInfo = GetItemInfo
local GetSpellLink, GetSpellInfo = GetSpellLink, GetSpellInfo
local GetActionTexture = GetActionTexture

local LureEffects = {
	[263] = 25,
	[264] = 50,
	[265] = 75,
	[266] = 100,
	[3868] = 100,
	[4225] = 150,
	[5386] = 200,
}

function FishLib:GetFishingSkillInfo()
	local _, _, _, fishing, _, _ = GetProfessions();
	if not fishing then
		return 131474, PROFESSIONS_FISHING
	end
	local name, _, _, _, count, offset, _ = GetProfessionInfo(fishing);
	local id = nil;
	for i = 1, count do
		local _, spellId = GetSpellLink(offset + i, "spell");
		local spellName = GetSpellInfo(spellId);
		if (spellName == name) then
			id = spellId;
			break;
		end
	end
	return id, name
end

-- get our current fishing skill level
function FishLib:GetCurrentSkill()
	local _, _, _, fishing, _, _ = GetProfessions();
	if (fishing) then
		local name, _, rank, skillmax, _, _, _, mods = GetProfessionInfo(fishing);
		local lure = self:GetPoleBonus();
		return rank, mods, skillmax, lure;
	end
	return 0, 0, 0;
end

-- Lure library
local FISHINGLURES = {
	{	["id"] = 88710,
		["n"] = "Nat's Hat",						-- 150 for 10 mins
		["b"] = 150,
		["s"] = 100,
		["d"] = 10,
		["w"] = true,
	},
	{	["id"] = 117405,
		["n"] = "Nat's Drinking Hat",				-- 150 for 10 mins
		["b"] = 150,
		["s"] = 100,
		["d"] = 10,
		["w"] = true,
	},
	{	["id"] = 33820,
		["n"] = "Weather-Beaten Fishing Hat",		 -- 75 for 10 minutes
		["b"] = 75,
		["s"] = 1,
		["d"] = 10,
		["w"] = true,
	},
	{	["id"] = 116826,
		["n"] = "Draenic Fishing Pole",				 -- 200 for 10 minutes
		["b"] = 200,
		["s"] = 1,
		["d"] = 20,									 -- 20 minute cooldown
		["w"] = true,
	},
	{	["id"] = 116825,
		["n"] = "Savage Fishing Pole",				 -- 200 for 10 minutes
		["b"] = 200,
		["s"] = 1,
		["d"] = 20,									 -- 20 minute cooldown
		["w"] = true,
	},

	{	["id"] = 34832,
		["n"] = "Captain Rumsey's Lager",			     -- 10 for 3 mins
		["b"] = 10,
		["s"] = 1,
		["d"] = 3,
		["u"] = 1,
	},
	{	["id"] = 67404,
		["n"] = "Glass Fishing Bobber",				-- ???
		["b"] = 15,
		["s"] = 1,
		["d"] = 10,
	},
	{	["id"] = 6529,
		["n"] = "Shiny Bauble",							  -- 25 for 10 mins
		["b"] = 25,
		["s"] = 1,
		["d"] = 10,
	},
	{	["id"] = 6811,
		["n"] = "Aquadynamic Fish Lens",				  -- 50 for 10 mins
		["b"] = 50,
		["s"] = 50,
		["d"] = 10,
	},
	{	["id"] = 6530,
		["n"] = "Nightcrawlers",						  -- 50 for 10 mins
		["b"] = 50,
		["s"] = 50,
		["d"] = 10,
	},
	{	["id"] = 7307,
		["n"] = "Flesh Eating Worm",					  -- 75 for 10 mins
		["b"] = 75,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 6532,
		["n"] = "Bright Baubles",						  -- 75 for 10 mins
		["b"] = 75,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 34861,
		["n"] = "Sharpened Fish Hook",				  -- 100 for 10 minutes
		["b"] = 100,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 6533,
		["n"] = "Aquadynamic Fish Attractor",		  -- 100 for 10 minutes
		["b"] = 100,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 62673,
		["n"] = "Feathered Lure",					  -- 100 for 10 minutes
		["b"] = 100,
		["s"] = 100,
		["d"] = 10,
	},
	{	["id"] = 46006,
		["n"] = "Glow Worm",						-- 100 for 60 minutes
		["b"] = 100,
		["s"] = 100,
		["d"] = 60,
		["l"] = 1,
	},
	{	["id"] = 68049,
		["n"] = "Heat-Treated Spinning Lure",		 -- 150 for 5 minutes
		["b"] = 150,
		["s"] = 250,
		["d"] = 5,
	},
	{	["id"] = 118391,
		["n"] = "Worm Supreme",						-- 200 for 10 mins
		["b"] = 200,
		["s"] = 100,
		["d"] = 10,
	},
}

-- sort ascending bonus and ascending time
-- we may have to treat "Heat-Treated Spinning Lure" differently someday
table.sort(FISHINGLURES,
	function(a,b)
		if ( a.b == b.b ) then
			return a.d < b.d;
		else
			return a.b < b.b;
		end
	end);

function FishLib:GetLureTable()
	return FISHINGLURES;
end

function FishLib:IsWorn(itemid)
	for slot=1,19 do
		local link = GetInventoryItemLink("player", slot);
		if ( link ) then
			local _, id, _ = self:SplitFishLink(link);
			if ( itemid == id ) then
				return true;
			end
		end
	end
	-- return nil
end

local useinventory = {};
local lureinventory = {};
function FishLib:UpdateLureInventory()
	local rawskill, _, _, _ = self:GetCurrentSkill();

	useinventory = {};
	lureinventory = {};
	local b = 0;
	for _,lure in ipairs(FISHINGLURES) do
		local id = lure.id;
		local count = GetItemCount(id);
		-- does this lure have to be "worn"
		if ( count > 0 ) then
			local startTime, _, _ = GetItemCooldown(id);
			if (startTime == 0) then
				-- get the name so we can check enchants
				lure.n,_,_,_,_,_,_,_,_,_ = GetItemInfo(id);
				if ( lure.b > b or lure.w ) then
					b = lure.b;
					if ( lure.u ) then
						tinsert(useinventory, lure);
					elseif ( lure.s <= rawskill ) then
						if ( not lure.w or FishLib:IsWorn(id)) then
							tinsert(lureinventory, lure);
						end
					end
				end
			end
		end
	end
	return lureinventory, useinventory;
 end

function FishLib:GetLureInventory()
	return lureinventory, useinventory;
end

-- Deal with lures
function FishLib:HasBuff(buffName)
	if ( buffName ) then
		 local name = UnitBuff("player", buffName);
		 return name ~= nil;
	end
	-- return nil
end

local function UseThisLure(lure, b, enchant, skill, level)
	if ( lure ) then
		local startTime, _, _ = GetItemCooldown(lure.id);
		level = level or 0;
		local bonus = lure.b or 0;
		if ( startTime == 0 and (skill and level <= (skill + bonus)) and (bonus > enchant) ) then
			if ( not b or bonus > b ) then 
				return true, bonus;
			end
		end
		return false, bonus;
	end
	return false, 0;
end

function FishLib:FindBestLure(b, state, usedrinks)
		local rank, modifier, _, enchant = self:GetCurrentSkill();
		local skill = rank + modifier;

		if ( skill ) then
			self:UpdateLureInventory();
			-- if drinking will work, then we're done
			if ( usedrinks and #useinventory > 0 ) then
				if ( not LastUsed or not self:HasBuff(LastUsed.n) ) then
					local id = useinventory[1].id;
					if ( not self:HasBuff(useinventory[1].n) ) then
						return nil, useinventory[1];
					end
				end
			end

			skill = skill - enchant;
			state = state or 0;
			local checklure;
			local useit, b = 0;

			-- Look for lures we're wearing, first
			for s=state+1,#lureinventory,1 do
				checklure = lureinventory[s];
				if (checklure.w) then
					useit, b = UseThisLure(checklure, b, enchant, skill);
					if ( useit and b and b > 0 ) then
						return s, checklure;
					end
				end
			end

			b = 0;
			for s=state+1,#lureinventory,1 do
				checklure = lureinventory[s];
				useit, b = UseThisLure(checklure, b, enchant, skill);
				if ( useit and b and b > 0 ) then
					return s, checklure;
				end
			end

			-- if we ran off the end of the table and we had a valid lure, let's use that one
			if ( (not enchant or enchant == 0) and b and (b > 0) and checklure ) then
				return #lureinventory, checklure;
			end
		end
end

-- Handle events we care about
local canCreateFrame = false;

local FISHLIBFRAMENAME="FishLibFrame";
local fishlibframe = getglobal(FISHLIBFRAMENAME);
if ( not fishlibframe) then
	fishlibframe = CreateFrame("Frame", FISHLIBFRAMENAME);
	fishlibframe:RegisterEvent("PLAYER_ENTERING_WORLD");
	fishlibframe:RegisterEvent("PLAYER_LEAVING_WORLD");
	fishlibframe:RegisterEvent("UPDATE_CHAT_WINDOWS");
	fishlibframe:RegisterEvent("LOOT_OPENED");
	fishlibframe:RegisterEvent("CHAT_MSG_SKILL");
	fishlibframe:RegisterEvent("SKILL_LINES_CHANGED");
	fishlibframe:RegisterEvent("UNIT_INVENTORY_CHANGED");
	fishlibframe:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
	fishlibframe:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
	fishlibframe:RegisterEvent("EQUIPMENT_SWAP_FINISHED");
	fishlibframe:RegisterEvent("ITEM_LOCK_CHANGED");
end

fishlibframe.fl = FishLib;

fishlibframe:SetScript("OnEvent", function(self, event, ...)
	local arg1 = select(1, ...);
	if ( event == "UPDATE_CHAT_WINDOWS" ) then
		canCreateFrame = true;
		self:UnregisterEvent(event);
	elseif ( event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" ) then
		self.fl:UpdateLureInventory();
		-- we can't actually rely on EQUIPMENT_SWAP_FINISHED, it appears
		self.fl:ForceGearCheck();
	elseif ( event == "SKILL_LINES_CHANGED" or event == "ITEM_LOCK_CHANGED" or event == "EQUIPMENT_SWAP_FINISHED" ) then
		-- Did something we're wearing change?
		self.fl:ForceGearCheck();
	elseif ( event == "CHAT_MSG_SKILL" ) then
		self.fl.caughtSoFar = 0;
	elseif ( event == "LOOT_OPENED" ) then
		if (IsFishingLoot()) then
			self.fl.caughtSoFar = self.fl.caughtSoFar + 1;
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_CHANNEL_STOP" ) then
		if (arg1 == "player" ) then
			self.fl:UpdateLureInventory();
		end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		self:RegisterEvent("ITEM_LOCK_CHANGED")
		self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		self:RegisterEvent("SPELLS_CHANGED")
	elseif ( event == "PLAYER_LEAVING_WORLD" ) then
		self:UnregisterEvent("ITEM_LOCK_CHANGED")
		self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
		self:UnregisterEvent("SPELLS_CHANGED")
	end
end);
fishlibframe:Show();

-- this changes all the damn time
-- "|c(%x+)|Hitem:(%d+)(:%d+):%d+:%d+:%d+:%d+:[-]?%d+:[-]?%d+:[-]?%d+:[-]?%d+|h%[(.*)%]|h|r"
-- go with a fixed pattern, since sometimes the hyperlink trick appears not to work
local _itempattern = "|c(%x+)|Hitem:([^:]+):([^:]+)[-:%d]+|h%[(.*)%]|h|r"

function FishLib:GetItemPattern()
	if ( not _itempattern ) then
		-- This should work all the time
		self:GetPoleType(); -- force the default pole into the cache
		local _, pat, _, _, _, _, _, _ = GetItemInfo(6256);
		pat = string.gsub(pat, "|c(%x+)|Hitem:(%d+)(:%d+)", "|c(%%x+)|Hitem:(%%d+)(:%%d+)");
		pat = string.gsub(pat, ":[-]?%d+", ":[-]?%%d+");
		_itempattern = string.gsub(pat, "|h%[(.*)%]|h|r", "|h%%[(.*)%%]|h|r");
	end
	return _itempattern;
end

function FishLib:SplitFishLink(link)
	if ( link ) then
		local _,_, color, id, enchant, name = string.find(link, self:GetItemPattern());
		return color, tonumber(id), name, enchant;
	end
end

function FishLib:GetItemInfo(link)
-- name, link, rarity, itemlevel, minlevel, itemtype
-- subtype, stackcount, equiploc, texture
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(link);
	return itemName, itemLink, itemRarity, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemLevel, itemSellPrice;
end

local fp_itemtype = nil;
local fp_subtype = nil;

function FishLib:GetPoleType()
	if ( not fp_itemtype ) then
		_,_,_,_,fp_itemtype,fp_subtype = self:GetItemInfo(6256);
		if ( not fp_itemtype ) then
			C_Timer.After(3, function() FishLib:GetPoleType() end)
			return
		end
	end
	return fp_itemtype, fp_subtype;
end

local UNDERLIGHT_ANGLER_ITEM_ID = 133755
function FishLib:IsFishingPole(itemLink)
	if (not itemLink) then
		itemLink = GetInventoryItemLink("player", INVSLOT_MAINHAND);
	end
	if ( itemLink ) then
		if (GetInventoryItemID("player", INVSLOT_MAINHAND) == UNDERLIGHT_ANGLER_ITEM_ID) then
			return true;
		end
		local _,_,_,_,itemtype,subtype = self:GetItemInfo(itemLink);
		if ( fp_itemtype and fp_subtype ) then
			return (itemtype == fp_itemtype) and (subtype == fp_subtype);
		end
	end
	return false;
end

function FishLib:ForceGearCheck()
	self.gearcheck = true;
	self.hasgear = false;
end

function FishLib:IsFishingReady(partial)
	if ( partial ) then
		return true
	else
		return self:IsFishingPole();
	end
end

local ACTIONDOUBLEWAIT = 0.4;
local MINACTIONDOUBLECLICK = 0.05;

function FishLib:WatchBobber(flag)
	self.watchBobber = flag;
end

-- look for double clicks
function FishLib:CheckForDoubleClick(button)
	if (button and button ~= self:GetSAMouseButton()) then
		return false;
	end
	if ( not LootFrame:IsShown() and self.lastClickTime ) then
		local pressTime = GetTime();
		local doubleTime = pressTime - self.lastClickTime;
		if ( (doubleTime < ACTIONDOUBLEWAIT) and (doubleTime > MINACTIONDOUBLECLICK) ) then
			if ( not self.watchBobber ) then
				self.lastClickTime = nil;
				return true;
			end
		end
	end
	self.lastClickTime = GetTime();

	return false;
end

-- Find an action bar for fishing, if there is one
local FISHINGTEXTURE = 136245;
function FishLib:GetFishingActionBarID(force)
	if ( force or not self.ActionBarID ) then
		for slot=1,72 do
			local tex = GetActionTexture(slot);
			if ( tex and tex == FISHINGTEXTURE ) then
				self.ActionBarID = slot;
				break;
			end
		end
	end
	return self.ActionBarID;
end

-- Secure action button
local SABUTTONNAME = "LibFishingSAButton";

function FishLib:ResetOverride()
	local btn = self.sabutton;
	if ( btn ) then
		btn.holder:Hide();
		ClearOverrideBindings(btn);
	end
end

local function ClickHandled(self)
	self.fl:ResetOverride();
	if ( self.postclick ) then
		self.postclick();
	end
end

function FishLib:CreateSAButton()
	local btn = getglobal(SABUTTONNAME);
	if ( not btn ) then
		local holder = CreateFrame("Frame", nil, UIParent);
		btn = CreateFrame("Button", SABUTTONNAME, holder, "SecureActionButtonTemplate");
		btn.holder = holder;
		btn:EnableMouse(true);
		btn:RegisterForClicks(nil);
		btn:Show();

		holder:SetPoint("LEFT", UIParent, "RIGHT", 10000, 0);
		holder:SetFrameStrata("LOW");
		holder:Hide();
	end
	if (not self.buttonevent) then
		self.buttonevent = "RightButtonUp";
	end
	btn:SetScript("PostClick", ClickHandled);
	btn:RegisterForClicks(self.buttonevent);
	self.sabutton = btn;
	btn.fl = self;
end

FishLib.MOUSE1 = "RightButtonUp";
FishLib.MOUSE2 = "Button4Up";
FishLib.MOUSE3 = "Button5Up";
FishLib.CastButton = {};
FishLib.CastButton[FishLib.MOUSE1] = "RightButton";
FishLib.CastButton[FishLib.MOUSE2] = "Button4";
FishLib.CastButton[FishLib.MOUSE3] = "Button5";
FishLib.CastKey = {};
FishLib.CastKey[FishLib.MOUSE1] = "BUTTON2";
FishLib.CastKey[FishLib.MOUSE2] = "BUTTON4";
FishLib.CastKey[FishLib.MOUSE3] = "BUTTON5";

function FishLib:GetSAMouseEvent()
	if (not self.buttonevent) then
		self.buttonevent = "RightButtonUp";
	end
	return self.buttonevent;
end

function FishLib:GetSAMouseButton()
	return self.CastButton[self:GetSAMouseEvent()];
end

function FishLib:GetSAMouseKey()
	return self.CastKey[self:GetSAMouseEvent()];
end

function FishLib:SetSAMouseEvent(buttonevent)
	if (not buttonevent) then
		buttonevent = "RightButtonUp";
	end
	if (self.CastButton[buttonevent]) then
		self.buttonevent = buttonevent;
		local btn = getglobal(SABUTTONNAME);
		if ( btn ) then
			btn:RegisterForClicks(nil);
			btn:RegisterForClicks(self.buttonevent);
		end
		return true;
	end
	-- return nil;
end

function FishLib:InvokeFishing(useaction)
	local btn = self.sabutton;
	if ( not btn ) then
		return;
	end
	local id, name = self:GetFishingSkillInfo();
	local findid = self:GetFishingActionBarID();
	if ( not useaction or not findid ) then
		btn:SetAttribute("type", "spell");
		btn:SetAttribute("spell", id);
		btn:SetAttribute("action", nil);
	else
		btn:SetAttribute("type", "action");
		btn:SetAttribute("action", findid);
		btn:SetAttribute("spell", nil);
	end
	btn:SetAttribute("item", nil);
	btn:SetAttribute("target-slot", nil);
	btn.postclick = nil;
end

function FishLib:InvokeLuring(id)
	local btn = self.sabutton;
	if ( not btn ) then
		return;
	end
	btn:SetAttribute("type", "item");
	if ( id ) then
		btn:SetAttribute("item", "item:"..id);
		btn:SetAttribute("target-slot", INVSLOT_MAINHAND);
	else
		btn:SetAttribute("item", nil);
		btn:SetAttribute("target-slot", nil);
	end
	btn:SetAttribute("spell", nil);
	btn:SetAttribute("action", nil);
	btn.postclick = nil;
end

function FishLib:OverrideClick(postclick)
	local btn = self.sabutton;
	if ( not btn ) then
		return;
	end
	local buttonkey = self:GetSAMouseKey();
	fishlibframe.fl = self;
	btn.fl = self;
	btn.postclick = postclick;
	SetOverrideBindingClick(btn, true, buttonkey, SABUTTONNAME);
	btn.holder:Show();
end

function FishLib:ClickSAButton()
	local btn = self.sabutton;
	if ( not btn ) then
		return;
	end
	btn:Click(self:GetSAMouseButton());
end

-- if we have a fishing pole, return the bonus from the pole
-- and the bonus from a lure, if any, separately
function FishLib:GetPoleBonus()
	if (self:IsFishingPole()) then
		local mhEnch,_,_,mhID = GetWeaponEnchantInfo();
		if mhEnch and LureEffects[mhID] then
			return LureEffects[mhID]
		else
			return 0
		end
	end
	return 0
end