local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local S = E.Skins
local Tools = SLE.Toolbars

--GLOBALS: CreateFrame, hooksecurefunc, UIParent
local _G = _G
local format = format

local size
local Zcheck = false
local GameTooltip = GameTooltip
local DeleteCursorItem = DeleteCursorItem

local C_Container_GetItemCooldown = C_Container.GetItemCooldown
local C_Container_PickupContainerItem = C_Container.PickupContainerItem
local C_Item_GetItemInfo = C_Item.GetItemInfo

Tools.RegisteredAnchors = {}
Tools.buttoncounts = {} --To kepp number of items

--Checking for changes in inventory (e.g. item counts)
function Tools:InventoryUpdate(event)
	--Not updating in combat. Cause taints
	if InCombatLockdown() then
		Tools:RegisterEvent('PLAYER_REGEN_ENABLED', 'InventoryUpdate')
		return
	else
		Tools:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end

	local updateRequired = false
	--Running an inventory check for all anchors created.
	for name, anchor in pairs(Tools.RegisteredAnchors) do
		if not anchor.InventroyCheck then assert(false, "Anchor named "..name.."doesn't have inventory update.") return end
		if anchor.InventroyCheck() then updateRequired = true; break end
	end

	if event and event ~= "BAG_UPDATE_COOLDOWN" and updateRequired == true then
		Tools:UpdateLayout() --Update everything!
	end
end

--The function to update layout of the bar. Generally used as anchor.UpdateBarLayout function
Tools.UpdateBarLayout = function(bar, anchor, buttons, category, db)
	if not db.enable then return end
	local count = 0

	bar:ClearAllPoints()
	bar:Point('LEFT', anchor, 'LEFT', 0, 0)
	for i, button in ipairs(buttons) do
		button:ClearAllPoints()
		if not button.items then Tools:InventoryUpdate() end
		if not db.active or button.items > 0 then
			button:Point('TOPLEFT', bar, 'TOPLEFT', (count * (db.buttonsize+(2 - E.Spacing)))+(1 - E.Spacing), -1)
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

--Update cooldowns for passed anchor
local function UpdateCooldown(anchor)
	if not anchor.ShouldShow() then return end --Don't do shit if anchor is not supposed to be seen anyways

	for i = 1, anchor.NumBars do
		local bar = anchor.Bars[anchor.BarsName..i]
		for _, button in ipairs(bar.Buttons) do
			if button.cooldown then button.cooldown:SetCooldown(C_Container_GetItemCooldown(button.itemId)) end
		end
	end
end

local function UpdateBar(bar, layoutfunc, zonecheck, anchor, buttons, category, returnDB)
	local db = returnDB()
	if not db.enable then bar:Hide() return end
	bar:Show()

	local count = layoutfunc(bar, anchor, buttons, category, db)
	if (db.enable and (count and count > 0) and zonecheck() and not InCombatLockdown()) then
		bar:Show()
	else
		bar:Hide()
	end
end

function Tools:BAG_UPDATE_COOLDOWN()
	Tools:InventoryUpdate()
	for name, anchor in pairs(Tools.RegisteredAnchors) do
		UpdateCooldown(anchor)
	end
end

local function Zone(event)
	local shouldShow = false
	for name, anchor in pairs(Tools.RegisteredAnchors) do
		if anchor.ReturnDB().enable and (not anchor.ShouldShow or anchor.ShouldShow()) then
			shouldShow = true
			break
		end
	end

	if shouldShow then
		Tools:RegisterEvent('BAG_UPDATE', 'InventoryUpdate')
		Tools:RegisterEvent('BAG_UPDATE_COOLDOWN')
		Tools:RegisterEvent('UNIT_QUEST_LOG_CHANGED', 'UpdateLayout')
		Tools:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', 'InventoryUpdate')

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

function Tools:UpdateLayout(event, unit) --don't touch
	--For updating borders after quest was complited. for some reason events fires before quest disappeares from log
	if event == 'UNIT_QUEST_LOG_CHANGED' then
		if unit == 'player' then E:Delay(1, Tools.UpdateLayout) else return end
	end
	--not in combat. now idea how this can happen, but still
	if InCombatLockdown() then
		Tools:RegisterEvent('PLAYER_REGEN_ENABLED', 'UpdateLayout')
		return
	else
		Tools:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
	--Update every single bar and mover
	for _, anchor in pairs(Tools.RegisteredAnchors) do
		if anchor.mover then
			if anchor.EnableMover() then
				E:EnableMover(anchor.mover:GetName())
				anchor.Resize(anchor)
			else
				E:DisableMover(anchor.mover:GetName())
			end
		end
		for i = 1, anchor.NumBars do
			local bar = anchor.Bars[anchor.BarsName..i]
			UpdateBar(bar, anchor.UpdateBarLayout, bar.zonecheck, anchor, bar.Buttons, bar.id, anchor.ReturnDB)
		end
	end
end

--What happens when you click on stuff
local function onClick(self, mousebutton)
	--Da left button
	if mousebutton == 'LeftButton' then
		--If in combat and this bar doesn't contain macro yet
		if InCombatLockdown() and not self.macro then
			SLE:Print(L["We are sorry, but you can't do this now. Try again after the end of this combat."])
			return
		end
		--Setting up a type for button. This what can't be done in combat
		self:SetAttribute('type', self.buttonType)
		self:SetAttribute(self.buttonType, self.sortname)
		local bar = self:GetParent()
		--If this bar was supposed to have auto target feature, then do it!
		if bar.Autotarget then bar.Autotarget(self) end
		--If cooldowns are supposed to be here
		if self.cooldown then
			self.cooldown:SetCooldown(C_Container_GetItemCooldown(self.itemId))
		end
		--Applying setup mark
		if not self.macro then self.macro = true end
	elseif mousebutton == 'RightButton' and self.allowDrop then --if right click and item is allowed to be destroied
		self:SetAttribute('type', 'click')
		local container, slot = SLE:BagSearch(self.itemId)
		if container and slot then
			C_Container_PickupContainerItem(container, slot)
			DeleteCursorItem()
		end
	end
	Tools:InventoryUpdate()
end

--OnEnter. Tooltips and stuff
local function onEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 2, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(' ')
	GameTooltip:SetItemByID(self.itemId)
	if self.allowDrop then
		GameTooltip:AddLine(L["Right-click to drop the item."])
	end
	GameTooltip:Show()
end

--Hide da tooltip
local function onLeave()
	GameTooltip:Hide()
end

--Creating the button
function Tools:CreateToolsButton(index, owner, buttonType, name, texture, allowDrop, db)
	size = db.buttonsize
	local button = CreateFrame('Button', format('ToolsButton%d', index), owner, 'SecureActionButtonTemplate')
	button:Size(size, size)
	S:HandleButton(button)

	button.sortname = name
	button.itemId = index
	button.allowDrop = allowDrop
	button.buttonType = buttonType
	button.macro = false

	button.icon = button:CreateTexture(nil, 'ARTWORK')
	button.icon:SetTexture(texture)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetInside()

	button.text = button:CreateFontString(nil, 'OVERLAY')
	button.text:FontTemplate(E.media.normFont, 12, 'OUTLINE')
	button.text:SetPoint('BOTTOMRIGHT', button, 1, 2)

	--If this thing has a cooldown
	if select(3, C_Container_GetItemCooldown(button.itemId)) == 1 then
		button.cooldown = CreateFrame('Cooldown', format('ToolsButton%dCooldown', index), button)
		button.cooldown:SetAllPoints(button)
		E:RegisterCooldown(button.cooldown)
	end

	button:HookScript('OnEnter', onEnter)
	button:HookScript('OnLeave', onLeave)
	button:SetScript('OnMouseDown', onClick)

	return button
end

--Putting stuff to the bar
function Tools:PopulateBar(bar)
	bar = _G[bar]
	if not bar then return end
	if not bar.Buttons then bar.Buttons = {} end
	for id, data in pairs(bar.Items) do
		tinsert(bar.Buttons, Tools:CreateToolsButton(id, bar, 'item', data.name, data.texture, true, E.db.sle.legacy.garrison.toolbar))
	end
	--This is my nightmare
	sort(bar.Buttons, function(a, b)
		if (not a or (a and not a.sortname)) and (not b or (b and not b.sortname)) then
			return false
		elseif (not a or (a and not a.sortname)) and b then
			return false
		elseif (not b or (b and not b.sortname)) and a then
			return true
		end

		return a.sortname < b.sortname
	end)
end

--Creating basically everything
function Tools:CreateFrames()
	for name, anchor in pairs(Tools.RegisteredAnchors) do
		if not anchor.Initialized then
			for bar, data in pairs(anchor.Bars) do
				Tools:PopulateBar(bar)
			end
			anchor.Initialized = true
		end
	end
	if not Tools.EventsRegistered then
		Tools:RegisterEvent('ZONE_CHANGED', Zone)
		Tools:RegisterEvent('ZONE_CHANGED_NEW_AREA', Zone)
		Tools:RegisterEvent('ZONE_CHANGED_INDOORS', Zone)
		Tools:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', 'InventoryUpdate')
		Tools.EventsRegistered = true
	end

	--Check if we are actually in da zone
	E:Delay(5, Zone)
end

--Rewriting init item IDs with actual item info
local function RecreateAnchor(anchor)
	for bar, data in pairs(anchor.Bars) do
		for id, info in pairs(data.Items) do
			if type(info) == 'number' and C_Item_GetItemInfo(id) == nil then
				E:Delay(5, function() RecreateAnchor(anchor) end)
				return
			else
				local itemName,_,_,_,_,_,_,_,_,itemIcon = C_Item_GetItemInfo(id)
				data.Items[id] = { name = itemName, texture = itemIcon }
			end
		end
	end

	if not anchor.Initialized then
		local name = anchor:GetName()
		Tools.RegisteredAnchors[name] = anchor
		Tools:CreateFrames()
	end
end

--Creating anchors. Passing function to actually create main frame at set up other nessesary functions
--Should be used in the file for actual submodule you want to add a toolbar for
function Tools:RegisterForBar(func)
	local anchor = func()

	RecreateAnchor(anchor)
end

function Tools:Initialize()
	if not SLE.initialized then return end

	-- E:Delay(3, function() Tools:UpdateLayout() end)
	Tools:UpdateLayout()

	function Tools:ForUpdateAll()
		Tools:UpdateLayout()
	end
end

SLE:RegisterModule(Tools:GetName())
