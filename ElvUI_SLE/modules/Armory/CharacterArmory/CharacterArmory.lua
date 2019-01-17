if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end

local _G = _G
local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local ElvUI_BagModule, ElvUI_DataBars = SLE:GetElvModules("Bags", "DataBars")
local Lib_Search = LibStub('LibItemSearch-1.2-ElvUI')
local LCG = LibStub('LibCustomGlow-1.0')
--GLOBALS: CreateFrame, UIParent, SLE_ArmoryDB, hooksecurefunc, GetInventoryItemGems

local _
local IsShiftKeyDown = IsShiftKeyDown
local SetItemRef = SetItemRef
local GetItemGem = GetItemGem
local GetCursorInfo, CursorHasItem = GetCursorInfo, CursorHasItem
local SocketInventoryItem = SocketInventoryItem
local HandleModifiedItemClick = HandleModifiedItemClick
local AuctionFrameBrowse_Reset = AuctionFrameBrowse_Reset
local ClickSocketButton = ClickSocketButton

local MAX_NUM_SOCKETS = MAX_NUM_SOCKETS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local PANEL_DEFAULT_WIDTH = PANEL_DEFAULT_WIDTH

local ITEM_MOD_AGILITY_SHORT, ITEM_MOD_SPIRIT_SHORT, ITEM_MOD_STAMINA_SHORT, ITEM_MOD_STRENGTH_SHORT, ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_CRIT_RATING_SHORT, ITEM_SPELL_TRIGGER_ONUSE = ITEM_MOD_AGILITY_SHORT, ITEM_MOD_SPIRIT_SHORT, ITEM_MOD_STAMINA_SHORT, ITEM_MOD_STRENGTH_SHORT, ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_CRIT_RATING_SHORT, ITEM_SPELL_TRIGGER_ONUSE
local AGI, SPI, STA, STR, INT, CRIT_ABBR = AGI, SPI, STA, STR, INT, CRIT_ABBR
local LE_TRANSMOG_TYPE_APPEARANCE, LE_TRANSMOG_TYPE_ILLUSION = LE_TRANSMOG_TYPE_APPEARANCE, LE_TRANSMOG_TYPE_ILLUSION
local STAT_AVERAGE_ITEM_LEVEL = STAT_AVERAGE_ITEM_LEVEL
local CHARACTERFRAME_EXPANDED_WIDTH = CHARACTERFRAME_EXPANDED_WIDTH

local C_Transmog_GetSlotInfo = C_Transmog.GetSlotInfo
local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local C_Transmog_GetSlotVisualInfo = C_Transmog.GetSlotVisualInfo
local C_TransmogCollection_GetIllusionSourceInfo = C_TransmogCollection.GetIllusionSourceInfo
local HasAnyUnselectedPowers = C_AzeriteEmpoweredItem.HasAnyUnselectedPowers
local AnimatedNumericFontStringMixin = AnimatedNumericFontStringMixin
local ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow = ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow

local format = format

--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade Character Frame's Item Info like Wow-Armory		>>--
--------------------------------------------------------------------------------
local CA = CharacterArmory or CreateFrame('Frame', 'CharacterArmory', _G["PaperDollFrame"])

local IsGemType = LE_ITEM_CLASS_GEM
local SlotIDList = {}
local DefaultPosition = {
	InsetDefaultPoint = { _G["CharacterFrameInsetRight"]:GetPoint() },
	CharacterMainHandSlot = { _G["CharacterMainHandSlot"]:GetPoint() }	
}

local linkCache = {};

function GetInventoryItemGems(slot)
	local link = T.GetInventoryItemLink("player", slot);
	
	if (link and linkCache[link]) then
		return T.unpack(linkCache[link]);
	end

	local gem1, gem2, gem3, gem4;

	if (link) then
		gem1, gem2, gem3, gem4 = T.select(7, T.find(link, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?"));
		if (gem1 == "") then gem1 = nil; end
		if (gem2 == "") then gem2 = nil; end
		if (gem3 == "") then gem3 = nil; end
		if (gem4 == "") then gem4 = nil; end
		linkCache[link] = {gem1, gem2, gem3, gem4};
	end

	

	return gem1, gem2, gem3, gem4;
end

do --<< Button Script >>--
	function CA:OnEnter()
		if self.Link or self.Message then
			_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')
			
			self:SetScript('OnUpdate', function()
				_G["GameTooltip"]:ClearLines()
				
				if self.Link then
					_G["GameTooltip"]:SetHyperlink(self.Link)
				end
				
				if self.Link and self.Message then _G["GameTooltip"]:AddLine(' ') end -- Line space
				
				if self.Message then
					_G["GameTooltip"]:AddLine(self.Message, 1, 1, 1)
				end
				
				_G["GameTooltip"]:Show()
			end)
		end
	end

	function CA:OnLeave()
		self:SetScript('OnUpdate', nil)
		_G["GameTooltip"]:Hide()
	end

	function CA:GemSocket_OnClick(Button)
		if CursorHasItem() then
			CA.GemSocket_OnRecieveDrag(self)
			return
		else
			self = self:GetParent()
		end
		
		if self.GemItemID then
			local ItemName, ItemLink = T.GetItemInfo(self.GemItemID)
			if self.Socket and self.Socket.Link then
				ItemLink = self.Socket.Link
			end
			if Button == 'LeftButton' and not IsShiftKeyDown() then
				SetItemRef(ItemLink, ItemLink, 'LeftButton')
			elseif IsShiftKeyDown() then
				if Button == 'RightButton' then
					ShowUIPanel(SocketInventoryItem(self.SlotID))
					--SocketInventoryItem(T.GetInventorySlotInfo(self.SlotName))
				elseif HandleModifiedItemClick(ItemLink) then
				elseif _G["BrowseName"] and _G["BrowseName"]:IsVisible() then
					AuctionFrameBrowse_Reset(_G["BrowseResetButton"])
					_G["BrowseName"]:SetText(ItemName)
					_G["BrowseName"]:SetFocus()
				end
			end
		end
	end

	function CA:GemSocket_OnRecieveDrag()
		self = self:GetParent()
		
		if CursorHasItem() then
			local CursorType, _, ItemLink = GetCursorInfo()
			local _, _, _, _, _, ItemType, ItemSubType = GetItemInfo(ItemLink)
				
			if CursorType == 'item' and T.select(6, T.GetItemInfo(ItemLink)) == AUCTION_CATEGORY_GEMS then
				ShowUIPanel(SocketInventoryItem(self.SlotID))

				ClickSocketButton(self.SocketNumber)
			end
		end
	end

	function CA:Transmogrify_OnEnter()
		self.Texture:SetVertexColor(1, .8, 1)
		
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
		_G["GameTooltip"]:SetHyperlink(self.Link)
		_G["GameTooltip"]:Show()
	end

	function CA:Transmogrify_OnLeave()
		self.Texture:SetVertexColor(1, .5, 1)
		
		_G["GameTooltip"]:Hide()
	end

	function CA:Transmogrify_OnClick(Button)
		local ItemName, ItemLink = T.GetItemInfo(self.Link)
		
		if not IsShiftKeyDown() then
			SetItemRef(ItemLink, ItemLink, 'LeftButton')
		else
			if HandleModifiedItemClick(ItemLink) then
			elseif _G["BrowseName"] and _G["BrowseName"]:IsVisible() then
				AuctionFrameBrowse_Reset(_G["BrowseResetButton"])
				_G["BrowseName"]:SetText(ItemName)
				_G["BrowseName"]:SetFocus()
			end
		end
	end

	function CA:Illusion_OnEnter()
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOM')
		_G["GameTooltip"]:AddLine(self.Link, 1, 1, 1)
		_G["GameTooltip"]:Show()
	end

	function CA:Illusion_OnLeave()
		_G["GameTooltip"]:Hide()
	end

	function CA:Illusion_OnClick(Button)
		if IsShiftKeyDown() then
			HandleModifiedItemClick(self.Link)
		end
	end

	-- function CA:GemSocket_OnEnter()
	-- 	_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')
		
	-- 	local Parent = self:GetParent()
		
	-- 	if Parent.GemItemID then
	-- 		if T.type(Parent.GemItemID) == 'number' then
	-- 			if T.GetItemInfo(Parent.GemItemID) then
	-- 				_G["GameTooltip"]:SetHyperlink(T.select(2, T.GetItemInfo(Parent.GemItemID)))
	-- 				self:SetScript('OnUpdate', nil)
	-- 			else
	-- 				self:SetScript('OnUpdate', CA.GemSocket_OnEnter)
	-- 				return
	-- 			end
	-- 		else
	-- 			_G["GameTooltip"]:ClearLines()
	-- 			_G["GameTooltip"]:AddLine("|cffffffff"..Parent.GemItemID)
	-- 		end
	-- 	elseif Parent.GemType then
	-- 		_G["GameTooltip"]:ClearLines()
	-- 		_G["GameTooltip"]:AddLine("|cffffffff".._G["EMPTY_SOCKET_"..Parent.GemType])
	-- 	end
		
	-- 	_G["GameTooltip"]:Show()
	-- end

end

function CA:Setup_CharacterArmory()
	local CharacterFrame_Level = CharacterModelFrame:GetFrameLevel()
	--<< Core >>--
	self:Point('TOPLEFT', _G["CharacterFrameInset"], 10, 20)
	self:Point('BOTTOMRIGHT', _G["CharacterFrameInsetRight"], 'BOTTOMLEFT', -10, 5)
	
	--<< Updater >>--
	local args
	self:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'SOCKET_INFO_SUCCESS' or Event == 'ITEM_UPGRADE_MASTER_UPDATE' or Event == 'TRANSMOGRIFY_SUCCESS' or Event == 'LOADING_SCREEN_DISABLED' then

			self.GearUpdated = nil
			self:SetScript('OnUpdate', self.ScanData)
		elseif Event == 'UNIT_INVENTORY_CHANGED' then
			args = ...
			
			if args == 'player' then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.ScanData)
			end
		elseif Event == 'PLAYER_EQUIPMENT_CHANGED' then
			if KF.DebugEnabled then print("PLAYER_EQUIPMENT_CHANGED") end
			args = ...
			args = SlotIDList[args]
			
			self.GearUpdated = type(self.GearUpdated) == 'table' and self.GearUpdated or {}
			table.insert(self.GearUpdated, args)
			
			self:SetScript('OnUpdate', self.ScanData)
		elseif Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			_, Event, _, _, _, _, _, _, args = ...
			
			if Event == 'ENCHANT_APPLIED' and args == E.myname then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.ScanData)
			end
		elseif Event == 'UPDATE_INVENTORY_DURABILITY' and self.DurabilityUpdated then
			self.DurabilityUpdated = nil
			-- self.GearUpdated = nil
			if KF.DebugEnabled then print("UPDATE_INVENTORY_DURABILITY") end
			self:SetScript('OnUpdate', self.ScanData)
		end
	end)
	self:SetScript('OnShow', self.ScanData)
	hooksecurefunc('CharacterFrame_Collapse', function() if Info.CharacterArmory_Activate and _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(448) end end)
	hooksecurefunc('CharacterFrame_Expand', function() if Info.CharacterArmory_Activate and _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(650) end end)
	hooksecurefunc('ToggleCharacter', function(frameType)
		if frameType ~= "PaperDollFrame" and frameType ~= "PetPaperDollFrame" then
			_G["CharacterFrame"]:SetWidth(PANEL_DEFAULT_WIDTH)
		elseif Info.CharacterArmory_Activate and frameType == "PaperDollFrame" then
			_G["CharacterFrameInsetRight"]:SetPoint('TOPLEFT', _G["CharacterFrameInset"], 'TOPRIGHT', 110, 0)
		else
			_G["CharacterFrameInsetRight"]:SetPoint(T.unpack(DefaultPosition.InsetDefaultPoint))
		end
	end)
	hooksecurefunc('PaperDollFrame_SetLevel', function()
		if Info.CharacterArmory_Activate then 
		_G["CharacterLevelText"]:SetText(_G["CharacterLevelText"]:GetText())

			_G["CharacterFrameTitleText"]:ClearAllPoints()
			_G["CharacterFrameTitleText"]:Point('TOP', self, 0, 35)
			_G["CharacterFrameTitleText"]:SetParent(self)
			_G["CharacterLevelText"]:ClearAllPoints()
			_G["CharacterLevelText"]:SetPoint('TOP', _G["CharacterFrameTitleText"], 'BOTTOM', 0, 2)
			_G["CharacterLevelText"]:SetParent(self)
		end
	end)
	
	self.DisplayUpdater = CreateFrame('Frame', nil, _G["PaperDollFrame"])
	self.DisplayUpdater:SetScript('OnShow', function() if Info.CharacterArmory_Activate then self:Update_Display(true) end end)
	self.DisplayUpdater:SetScript('OnUpdate', function() if Info.CharacterArmory_Activate then self:Update_Display() end end)
	
	--<< Background >>--
	self.BG = self:CreateTexture(nil, 'OVERLAY')
	self.BG:SetPoint('TOPLEFT', self, -8, 0)
	self.BG:SetPoint('BOTTOMRIGHT', self, 8, 0)
	self:Update_BG()
	
	--<< Change Model Frame's frameLevel >>--
	_G["CharacterModelFrame"]:SetFrameLevel(self:GetFrameLevel() + 2)

	--<< Average Item Level >>--
	-- KF:TextSetting(self, nil, { Tag = 'AverageItemLevel', FontSize = 12 }, 'BOTTOM', CharacterModelFrame, 'TOP', 0, 14)
	-- local function ValueColorUpdate()
		-- self.AverageItemLevel:SetText(KF:Color_Value(STAT_AVERAGE_ITEM_LEVEL)..' : '..format('%.2f', select(2, GetAverageItemLevel())))
	-- end
	-- E.valueColorUpdateFuncs[ValueColorUpdate] = true
	
	-- Create each equipment slots gradation, text, gem socket icon.
	local Slot
	for i, SlotName in T.pairs(Info.Armory_Constants.GearList) do
		-- Equipment Tag
		Slot = CreateFrame('Frame', nil, self)
		Slot:Size(130, 41)
		Slot:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 1)
		Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
		Slot.ID, Slot.EmptyTexture = T.GetInventorySlotInfo(SlotName)
		-- Slot:Point(Slot.Direction, _G["Character"..SlotName], Slot.Direction == 'LEFT' and -1 or 1, 0)
		Slot:Point(Slot.Direction, _G["Character"..SlotName], 0, 0)

		-- Azerite
		hooksecurefunc(_G["Character"..SlotName], "SetAzeriteItem", function(self, itemLocation)
			if not CA[SlotName].AzeriteAnchor then return end
			if not itemLocation then
				CA[SlotName].AzeriteAnchor:Hide()
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
				return
			end
			self.AzeriteTexture:Hide()
			self.AvailableTraitFrame:Hide()
			local isAzeriteEmpoweredItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation);
			if isAzeriteEmpoweredItem then
				CA[SlotName].AzeriteAnchor:Show()
			else
				CA[SlotName].AzeriteAnchor:Hide()
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
			end
		end)

		hooksecurefunc(_G["Character"..SlotName], "DisplayAsAzeriteEmpoweredItem", function(self, itemLocation)
			if HasAnyUnselectedPowers(itemLocation) then
				LCG.PixelGlow_Start(self, Info.Armory_Constants.AzeriteTraitAvailableColor, nil,-0.25,nil, 3, nil,nil,nil, "_AzeriteTraitGlow")
			else
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
			end
		end)

		_G["Character"..SlotName].RankFrame:StripTextures()
		_G["Character"..SlotName].RankFrame:SetTemplate("Transparent")
		_G["Character"..SlotName].RankFrame:SetSize(16, 16)
		_G["Character"..SlotName].RankFrame:SetPoint("BOTTOMLEFT", Slot, 0 + E.db.sle.Armory.Character.AzeritePosition.xOffset, 2 + E.db.sle.Armory.Character.AzeritePosition.yOffset)
		_G["Character"..SlotName].RankFrame.Label:SetPoint("CENTER", _G["Character"..SlotName].RankFrame, 1, 0)
		Slot.RankFrame = _G["Character"..SlotName].RankFrame

		-- Grow each equipment slot's frame level
		_G["Character"..SlotName]:SetFrameLevel(Slot:GetFrameLevel() + 1)

		-- Gradation
		Slot.Gradation = Slot:CreateTexture(nil, 'ARTWORK')
		Slot.Gradation:SetInside()
		Slot.Gradation:SetTexture('Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\Gradation')
		if Slot.Direction == 'LEFT' then
			Slot.Gradation:SetTexCoord(0, 1, 0, 1)
		else
			Slot.Gradation:SetTexCoord(1, 0, 0, 1)
		end
		
		if not E.db.sle.Armory.Character.Gradation.Display then
			Slot.Gradation:Hide()
		end
		
		if SlotName ~= 'ShirtSlot' and SlotName ~= 'TabardSlot' then
			-- Item Level
			KF:TextSetting(_G["Character"..SlotName], nil, { Tag = 'ItemLevel',
				Font = E.db.sle.Armory.Character.Level.Font,
				FontSize = E.db.sle.Armory.Character.Level.FontSize,
				FontStyle = E.db.sle.Armory.Character.Level.FontStyle,
				directionH = Slot.Direction
			}, 'TOP'..Slot.Direction, _G["Character"..SlotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 + E.db.sle.Armory.Character.Level.xOffset or -2-E.db.sle.Armory.Character.Level.xOffset, -1+E.db.sle.Armory.Character.Level.yOffset)
			
			Slot.ItemLevel = _G["Character"..SlotName].ItemLevel
			
			if E.db.sle.Armory.Character.Level.Display == 'Hide' then
				Slot.ItemLevel:Hide()
			end
			-- Enchantment Name
			KF:TextSetting(Slot, nil, { Tag = 'ItemEnchant',
				Font = E.db.sle.Armory.Character.Enchant.Font,
				FontSize = E.db.sle.Armory.Character.Enchant.FontSize,
				FontStyle = E.db.sle.Armory.Character.Enchant.FontStyle,
				directionH = Slot.Direction
			}, Slot.Direction, _G["Character"..SlotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 + E.db.sle.Armory.Character.Enchant.xOffset or -2 - E.db.sle.Armory.Character.Enchant.xOffset, 1 + E.db.sle.Armory.Character.Enchant.yOffset)
			
			if E.db.sle.Armory.Character.Enchant.Display == 'Hide' then
				Slot.ItemEnchant:Hide()
			end
			
			Slot.EnchantWarning = CreateFrame('Button', nil, Slot)
			Slot.EnchantWarning:Size(E.db.sle.Armory.Character.Enchant.WarningSize)
			Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
			Slot.EnchantWarning.Texture:SetInside()
			Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\Warning-Small')
			Slot.EnchantWarning:Point(Slot.Direction, Slot.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
			Slot.EnchantWarning:SetScript('OnEnter', self.OnEnter)
			Slot.EnchantWarning:SetScript('OnLeave', self.OnLeave)
			
			-- Durability
			KF:TextSetting(_G["Character"..SlotName], nil, { Tag = 'Durability',
				Font = E.db.sle.Armory.Character.Durability.Font,
				FontSize = E.db.sle.Armory.Character.Durability.FontSize,
				FontStyle = E.db.sle.Armory.Character.Durability.FontStyle,
				directionH = Slot.Direction
			}, 'TOP'..Slot.Direction, _G["Character"..SlotName], 'TOP'..Slot.Direction, Slot.Direction == 'LEFT' and 2 + E.db.sle.Armory.Character.Durability.xOffset or 0 - E.db.sle.Armory.Character.Durability.xOffset, -3 + E.db.sle.Armory.Character.Durability.yOffset)
			
			Slot.Durability = _G["Character"..SlotName].Durability
			
			-- Gem Socket
			for i = 1, MAX_NUM_SOCKETS do
				Slot["Socket"..i] = CreateFrame('Frame', nil, Slot)
				Slot["Socket"..i]:Size(E.db.sle.Armory.Character.Gem.SocketSize)
				Slot["Socket"..i]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot["Socket"..i]:SetBackdropColor(0, 0, 0, 1)
				Slot["Socket"..i]:SetBackdropBorderColor(0, 0, 0)
				Slot["Socket"..i]:SetFrameLevel(_G["Character"..SlotName]:GetFrameLevel() + 5)
				
				Slot["Socket"..i].SlotID = Slot.ID
				Slot["Socket"..i].SocketNumber = i
				
				Slot["Socket"..i].Socket = CreateFrame('Button', nil, Slot["Socket"..i])
				Slot["Socket"..i].Socket:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot["Socket"..i].Socket:SetInside()
				Slot["Socket"..i].Socket:SetFrameLevel(Slot["Socket"..i]:GetFrameLevel() + 1)
				Slot["Socket"..i].Socket:RegisterForClicks('AnyUp')
				Slot["Socket"..i].Socket:SetScript('OnEnter', self.OnEnter)
				Slot["Socket"..i].Socket:SetScript('OnLeave', self.OnLeave)
				Slot["Socket"..i].Socket:SetScript('OnClick', self.GemSocket_OnClick)
				Slot["Socket"..i].Socket:SetScript('OnReceiveDrag', self.GemSocket_OnRecieveDrag)
				
				Slot["Socket"..i].Texture = Slot["Socket"..i].Socket:CreateTexture(nil, 'OVERLAY')
				Slot["Socket"..i].Texture:SetTexCoord(.1, .9, .1, .9)
				Slot["Socket"..i].Texture:SetInside()
			end
			Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G["Character"..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 + E.db.sle.Armory.Character.Gem.xOffset or -2 - E.db.sle.Armory.Character.Gem.xOffset, 2 + E.db.sle.Armory.Character.Gem.yOffset)
			Slot.Socket2:Point(Slot.Direction, Slot.Socket1, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
			Slot.Socket3:Point(Slot.Direction, Slot.Socket2, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
			
			Slot.SocketWarning = CreateFrame('Button', nil, Slot)
			Slot.SocketWarning:Size(E.db.sle.Armory.Character.Enchant.WarningSize)
			Slot.SocketWarning:RegisterForClicks('AnyUp')
			Slot.SocketWarning.Texture = Slot.SocketWarning:CreateTexture(nil, 'OVERLAY')
			Slot.SocketWarning.Texture:SetInside()
			Slot.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\Warning-Small')
			Slot.SocketWarning:SetScript('OnEnter', self.OnEnter)
			Slot.SocketWarning:SetScript('OnLeave', self.OnLeave)
			
			-- Transmogrify
			if Info.Armory_Constants.CanTransmogrifySlot[SlotName] then
				Slot.TransmogrifyAnchor = CreateFrame('Button', nil, Slot)
				Slot.TransmogrifyAnchor:Size(12)
				Slot.TransmogrifyAnchor:SetFrameLevel(Slot:GetFrameLevel() + 2)
				Slot.TransmogrifyAnchor:Point('BOTTOM'..Slot.Direction, Slot, Slot.Direction == 'LEFT' and -2 or 2, -1)
				Slot.TransmogrifyAnchor:SetScript('OnEnter', self.Transmogrify_OnEnter)
				Slot.TransmogrifyAnchor:SetScript('OnLeave', self.Transmogrify_OnLeave)
				Slot.TransmogrifyAnchor:SetScript('OnClick', self.Transmogrify_OnClick)
				
				Slot.TransmogrifyAnchor.Texture = Slot.TransmogrifyAnchor:CreateTexture(nil, 'OVERLAY')
				Slot.TransmogrifyAnchor.Texture:SetInside()
				Slot.TransmogrifyAnchor.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\Anchor')
				Slot.TransmogrifyAnchor.Texture:SetVertexColor(1, .5, 1)
				
				if Slot.Direction == 'LEFT' then
					Slot.TransmogrifyAnchor.Texture:SetTexCoord(0, 1, 0, 1)
				else
					Slot.TransmogrifyAnchor.Texture:SetTexCoord(1, 0, 0, 1)
				end
				
				Slot.TransmogrifyAnchor:Hide()
			end

		-- Azerite
		if Info.Armory_Constants.AzeriteSlot[SlotName] then
			Slot.AzeriteAnchor = CreateFrame('Button', nil, Slot)
			Slot.AzeriteAnchor:Size(41)
			Slot.AzeriteAnchor:SetFrameLevel(Slot:GetFrameLevel() + 1)
			Slot.AzeriteAnchor:Point('TOP'..Slot.Direction, Slot, Slot.Direction == 'LEFT' and -2 or 2, -1)

			Slot.AzeriteAnchor.Texture = Slot.AzeriteAnchor:CreateTexture(nil, 'OVERLAY')
			Slot.AzeriteAnchor.Texture:SetAtlas("AzeriteIconFrame")
			Slot.AzeriteAnchor.Texture:SetTexCoord(0,1,0,1)
			Slot.AzeriteAnchor.Texture:SetInside()

			Slot.AzeriteAnchor:Hide()
		end

			-- Illusion
			if Info.Armory_Constants.CanIllusionSlot[SlotName] then
				Slot.IllusionAnchor = CreateFrame('Button', nil, Slot)
				Slot.IllusionAnchor:Size(18)
				Slot.IllusionAnchor:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot.IllusionAnchor:SetFrameLevel(Slot:GetFrameLevel() + 2)
				Slot.IllusionAnchor:Point('CENTER', _G['Character'..SlotName], 'BOTTOM', 0, -2)
				Slot.IllusionAnchor:SetScript('OnEnter', self.Illusion_OnEnter)
				Slot.IllusionAnchor:SetScript('OnLeave', self.Illusion_OnLeave)
				Slot.IllusionAnchor:SetScript('OnClick', self.Illusion_OnClick)
				hooksecurefunc(_G['Character'..SlotName].IconBorder, 'SetVertexColor', function(self, r, g, b)
					Slot.IllusionAnchor:SetBackdropBorderColor(r, g, b)
				end)
				
				Slot.IllusionAnchor.Texture = Slot.IllusionAnchor:CreateTexture(nil, 'OVERLAY')
				Slot.IllusionAnchor.Texture:SetInside()
				Slot.IllusionAnchor.Texture:SetTexCoord(.1, .9, .1, .9)
				Slot.IllusionAnchor:Hide()
			end
		end
		
		SlotIDList[Slot.ID] = SlotName
		self[SlotName] = Slot
	end
	
	-- _G["GameTooltip"] for counting gem sockets and getting enchant effects
	self.ScanTT = CreateFrame('GameTooltip', 'Knight_CharacterArmory_ScanTT', nil, 'GameTooltipTemplate')
	self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')

	-- if _G["PawnUI_InventoryPawnButton"] then
	-- 	_G["PawnUI_InventoryPawnButton"]:ClearAllPoints()
	-- 	_G["PawnUI_InventoryPawnButton"]:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 1)
	-- 	_G["PawnUI_InventoryPawnButton"]:SetPoint('BOTTOMRIGHT', _G["PaperDollFrame"], 'BOTTOMRIGHT', 0, 0)
	-- end

	self.Setup_CharacterArmory = nil
end

function CA:ScanData()
	self.NeedUpdate = nil
	if not self.DurabilityUpdated then
		if KF.DebugEnabled then print("Update_Durability: ", self:Update_Durability()) end
		self.NeedUpdate = self:Update_Durability() or self.NeedUpdate
	end
	if KF.DebugEnabled then print("1: ", self.NeedUpdate, self.GearUpdated) end
	if self.GearUpdated ~= true then
		if KF.DebugEnabled then print("Update_Gear: ", self:Update_Gear()) end
		self.NeedUpdate = self:Update_Gear() or self.NeedUpdate
	end
	if KF.DebugEnabled then print("2: ", self.NeedUpdate) end
	if not self.NeedUpdate and self:IsShown() then
		self:SetScript('OnUpdate', nil)
		self:Update_Display(true)
	elseif self.NeedUpdate then
		self:SetScript('OnUpdate', self.ScanData)
	end
	if KF.DebugEnabled then print("3: ", self.NeedUpdate) end
	if _G["CharacterModelFrame"] and _G["CharacterModelFrame"].BackgroundTopLeft and _G["CharacterModelFrame"].BackgroundTopLeft:IsShown() then
		_G["CharacterModelFrame"].BackgroundTopLeft:Hide()
		_G["CharacterModelFrame"].BackgroundTopRight:Hide()
		_G["CharacterModelFrame"].BackgroundBotLeft:Hide()
		_G["CharacterModelFrame"].BackgroundBotRight:Hide()
		if _G["CharacterModelFrame"].backdrop then
			_G["CharacterModelFrame"].backdrop:Hide()
		end
	end

	if _G["CharacterModelFrame"]:GetHeight() == 320 then
		_G["CharacterModelFrame"]:ClearAllPoints()
		_G["CharacterModelFrame"]:SetPoint('TOPLEFT', _G["CharacterHeadSlot"])
		_G["CharacterModelFrame"]:SetPoint('RIGHT', _G["CharacterHandsSlot"])
		_G["CharacterModelFrame"]:SetPoint('BOTTOM', _G["CharacterMainHandSlot"])

		_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('TOPLEFT', CharacterArmory, -8, 0)
		_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('BOTTOMRIGHT', CharacterArmory, 8, 0)
		CA:ElvOverlayToggle()
	end
end

function CA:Update_Durability()
	local Slot, R, G, B, CurrentDurability, MaxDurability
	
	for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
		Slot = self[SlotName]
		CurrentDurability, MaxDurability = T.GetInventoryItemDurability(Slot.ID)
		
		if CurrentDurability and MaxDurability and not (E.db.sle.Armory.Character.Durability.Display == 'DamagedOnly' and CurrentDurability == MaxDurability) then
			R, G, B = E:ColorGradient((CurrentDurability / MaxDurability), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			Slot.Durability:SetFormattedText("%s%.0f%%|r", E:RGBToHex(R, G, B), (CurrentDurability / MaxDurability) * 100)
		elseif Slot.Durability then
			Slot.Durability:SetText('')
		end
	end
	
	self.DurabilityUpdated = true
end

function CA:ClearTooltip(Tooltip)
	local TooltipName = Tooltip:GetName()
	
	Tooltip:ClearLines()
	for i = 1, 10 do
		_G[TooltipName..'Texture'..i]:SetTexture(nil)
		_G[TooltipName..'Texture'..i]:ClearAllPoints()
		_G[TooltipName..'Texture'..i]:Point('TOPLEFT', Tooltip)
	end
end

function CA:Update_Gear()
	--[[ Get Player Profession
	
	local Prof1, Prof2 = GetProfessions()
	local Prof1_Level, Prof2_Level = 0, 0
	self.PlayerProfession = {}
	
	if Prof1 then Prof1, _, Prof1_Level = GetProfessionInfo(Prof1) end
	if Prof2 then Prof2, _, Prof2_Level = GetProfessionInfo(Prof2) end
	if Prof1 and Info.Armory_Constants.ProfessionList[Prof1] then self.PlayerProfession[(Info.Armory_Constants.ProfessionList[Prof1].Key)] = Prof1_Level end
	if Prof2 and Info.Armory_Constants.ProfessionList[Prof2] then self.PlayerProfession[(Info.Armory_Constants.ProfessionList[Prof2].Key)] = Prof2_Level end
	]]
	local ErrorDetected, NeedUpdate, NeedUpdateList, R, G, B
	local Slot, ItemLink, ItemData, BasicItemLevel, TrueItemLevel, ItemUpgradeID, CurrentUpgrade, MaxUpgrade, ItemType, UsableEffect, CurrentLineText, GemID, GemLink, GemTexture, GemCount_Default, GemCount_Now, GemCount, ItemTexture, IsTransmogrified

	for _, SlotName in T.pairs(T.type(self.GearUpdated) == 'table' and self.GearUpdated or Info.Armory_Constants.GearList) do
		Slot = self[SlotName]
		ItemLink = T.GetInventoryItemLink('player', Slot.ID)
		-- if ItemLink then local DaName = GetItemInfo(ItemLink); print(DaName, GetDetailedItemLevelInfo(ItemLink)) end
		ErrorDetected = nil

		if not (SlotName == 'ShirtSlot' or SlotName == 'TabardSlot') then
			local ItemInfoAvailable
			if ItemLink then
				ItemInfoAvailable = T.GetItemInfo(ItemLink)
			end
			if not ItemLink or ItemInfoAvailable then --<< Clear Setting >>--
				NeedUpdate, TrueItemLevel, UsableEffect, ItemUpgradeID, CurrentUpgrade, MaxUpgrade, ItemType, ItemTexture, IsTransmogrified = nil, nil, nil, nil, nil, nil, nil, nil, nil
				Slot.ItemRarity = nil
				Slot.ItemLevel:SetText(nil)
				Slot.IsEnchanted = nil
				Slot.ItemEnchant:SetText(nil)
				Slot.ItemEnchant.Message = nil
				Slot.GemCount_Enable = nil
				for i = 1, MAX_NUM_SOCKETS do
					Slot["Socket"..i].Texture:SetTexture(nil)
					Slot["Socket"..i].Socket.Link = nil
					Slot["Socket"..i].Socket.Message = nil
					Slot["Socket"..i].GemItemID = nil
					Slot["Socket"..i].GemType = nil
					Slot["Socket"..i]:Hide()
				end
				Slot.EnchantWarning:Hide()
				Slot.EnchantWarning.Message = nil
				Slot.SocketWarning:Point(Slot.Direction, Slot.Socket1)
				Slot.SocketWarning:Hide()
				Slot.SocketWarning.Link = nil
				Slot.SocketWarning.Message = nil
				if Slot.TransmogrifyAnchor then
					Slot.TransmogrifyAnchor.SourceID = nil
					Slot.TransmogrifyAnchor.Link = nil
					Slot.TransmogrifyAnchor:Hide()
					LCG.AutoCastGlow_Stop(_G["Character"..SlotName],"_TransmogGlow")
				end
				
				if Slot.IllusionAnchor then
					Slot.IllusionAnchor.Link = nil
					Slot.IllusionAnchor:Hide()
				end
			else
				NeedUpdate = true
			end
			if ItemLink and ItemInfoAvailable then
				if not ItemLink:find('%[%]') then -- sometimes itemLink is malformed so we need to update when crashed

					ItemData = { T.split(':', ItemLink) }
					local ItemInfoAvailable

					_, _, Slot.ItemRarity, BasicItemLevel, _, _, _, _, ItemType = T.GetItemInfo(ItemLink)
					R, G, B = T.GetItemQualityColor(Slot.ItemRarity)

					do --<< Gem Parts >>--
						GemCount_Default, GemCount_Now, GemCount = 0, 0, 0
							
						-- First, Counting default gem sockets
						ItemData.FixedLink = ItemData[1]

						for i = 2, #ItemData do
							if i == 4 or i == 5 or i == 6 or i == 7 then
								ItemData.FixedLink = ItemData.FixedLink..':'..0
							else
								ItemData.FixedLink = ItemData.FixedLink..':'..ItemData[i]
							end
						end

						self:ClearTooltip(self.ScanTT)
						self.ScanTT:SetHyperlink(ItemData.FixedLink)

						-- First, Counting default gem sockets
						for i = 1, MAX_NUM_SOCKETS do
							GemTexture = _G["Knight_CharacterArmory_ScanTTTexture"..i]:GetTexture()
							if GemTexture and GemTexture:find('Interface\\ItemSocketingFrame\\') then
								GemCount_Default = GemCount_Default + 1
								Slot["Socket"..GemCount_Default].GemType = T.upper(T.gsub(GemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
							end
						end

						-- Second, Check if slot's item enable to adding a socket
						--[[
						if (SlotName == 'WaistSlot' and UnitLevel('player') >= 70) or -- buckle
							((SlotName == 'WristSlot' or SlotName == 'HandsSlot') and self.PlayerProfession.BlackSmithing and self.PlayerProfession.BlackSmithing >= 550) then -- BlackSmith

							GemCount_Enable = GemCount_Enable + 1
							Slot["Socket'..GemCount_Enable].GemType = 'PRISMATIC'
						end
						]]

						self:ClearTooltip(self.ScanTT)
						self.ScanTT:SetInventoryItem('player', Slot.ID)

						-- Apply current item's gem setting
						for i = 1, MAX_NUM_SOCKETS do
							GemTexture = _G['Knight_CharacterArmory_ScanTTTexture'..i]:GetTexture()
							GemID = ItemData[i + 3] ~= '' and tonumber(ItemData[i + 3]) or 0
							_, GemLink = GetItemGem(ItemLink, i)

							if Slot["Socket"..i].GemType and Info.Armory_Constants.GemColor[Slot["Socket"..i].GemType] then
								R, G, B = T.unpack(Info.Armory_Constants.GemColor[Slot["Socket"..i].GemType])
								Slot["Socket"..i].Socket:SetBackdropColor(R, G, B, .5)
								Slot["Socket"..i].Socket:SetBackdropBorderColor(R, G, B)
							else
								Slot["Socket"..i].Socket:SetBackdropColor(1, 1, 1, .5)
								Slot["Socket"..i].Socket:SetBackdropBorderColor(1, 1, 1)
							end

							if GemTexture or GemLink then
								if E.db.sle.Armory.Character.Gem.Display == 'Always' or E.db.sle.Armory.Character.Gem.Display == 'MouseoverOnly' and Slot.Mouseovered or E.db.sle.Armory.Character.Gem.Display == 'MissingOnly' then
									Slot["Socket"..i]:Show()
									Slot.SocketWarning:Point(Slot.Direction, Slot["Socket"..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
								end

								GemCount_Now = GemCount_Now + 1

								if GemID ~= 0 then
									GemCount = GemCount + 1
									Slot["Socket"..i].GemItemID = GemID
									Slot["Socket"..i].Socket.Link = GemLink

									GemTexture = T.select(10, T.GetItemInfo(GemID))

									if GemTexture then
										Slot["Socket"..i].Texture:SetTexture(GemTexture)
									else
										NeedUpdate = true
									end
								else
									if Slot['Socket'..i].GemType == nil then Slot['Socket'..i].GemType = 'PRISMATIC' GemCount_Default = GemCount_Default + 1 end
									Slot['Socket'..i].Socket.Message = '|cffffffff'.._G['EMPTY_SOCKET_'..Slot['Socket'..i].GemType]
								end
							end
						end

						--print(SlotName..' : ', GemCount_Default, GemCount_Enable, GemCount_Now, GemCount)
						if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
							NeedUpdate = true
						end
						Slot.GemCount_Enable = GemCount_Default
					end

					--<< Enchant Parts >>--
					Slot.ItemEnchant:SetText("")
					for i = 1, self.ScanTT:NumLines() do
						CurrentLineText = _G["Knight_CharacterArmory_ScanTTTextLeft"..i]:GetText()
						if CurrentLineText:find(Info.Armory_Constants.ItemLevelKey_Alt) then
								TrueItemLevel = T.tonumber(CurrentLineText:match(Info.Armory_Constants.ItemLevelKey_Alt))
						elseif CurrentLineText:find(Info.Armory_Constants.ItemLevelKey) then
							TrueItemLevel = T.tonumber(CurrentLineText:match(Info.Armory_Constants.ItemLevelKey))
						elseif CurrentLineText:find(Info.Armory_Constants.EnchantKey) then
							if E.db.sle.Armory.Character.Enchant.Display ~= 'Hide' then
								CurrentLineText = CurrentLineText:match(Info.Armory_Constants.EnchantKey) -- Get enchant string
								CurrentLineText = T.gsub(CurrentLineText, ITEM_MOD_AGILITY_SHORT, AGI)
								CurrentLineText = T.gsub(CurrentLineText, ITEM_MOD_SPIRIT_SHORT, SPI)
								CurrentLineText = T.gsub(CurrentLineText, ITEM_MOD_STAMINA_SHORT, STA)
								CurrentLineText = T.gsub(CurrentLineText, ITEM_MOD_STRENGTH_SHORT, STR)
								CurrentLineText = T.gsub(CurrentLineText, ITEM_MOD_INTELLECT_SHORT, INT)
								CurrentLineText = T.gsub(CurrentLineText, ITEM_MOD_CRIT_RATING_SHORT, CRIT_ABBR) -- Critical is too long
								CurrentLineText = T.gsub(CurrentLineText, ' + ', '+') -- Remove space
								
								if L.Armory_ReplaceEnchantString and T.type(L.Armory_ReplaceEnchantString) == 'table' then
									for Old, New in T.pairs(L.Armory_ReplaceEnchantString) do
										CurrentLineText = T.gsub(CurrentLineText, Old, New)
									end
								end

								for Name, _ in T.pairs(SLE_ArmoryDB.EnchantString) do
									if SLE_ArmoryDB.EnchantString[Name].original and SLE_ArmoryDB.EnchantString[Name].new then
										CurrentLineText = T.gsub(CurrentLineText, SLE_ArmoryDB.EnchantString[Name].original, SLE_ArmoryDB.EnchantString[Name].new)
									end
								end
								
								Slot.ItemEnchant:SetText('|cffceff00'..CurrentLineText)
							end
							
							Slot.IsEnchanted = true
						elseif CurrentLineText:find(ITEM_SPELL_TRIGGER_ONUSE) then
							UsableEffect = true
						end
					end

					--<< ItemLevel Parts >>--
					ItemUpgradeID = ItemData[12]
					if BasicItemLevel then
						if ItemUpgradeID then
							if ItemUpgradeID == '' or not E.db.sle.Armory.Character.Level.ShowUpgradeLevel and ItemRarity == 7 then
								ItemUpgradeID = nil
							elseif CurrentUpgrade or MaxUpgrade then
								ItemUpgradeID = TrueItemLevel - BasicItemLevel
							else
								ItemUpgradeID = nil
							end
						end
						
						Slot.ItemLevel:SetText(
							(not TrueItemLevel or BasicItemLevel == TrueItemLevel) and BasicItemLevel
							or
							E.db.sle.Armory.Character.Level.ShowUpgradeLevel and (Slot.Direction == 'LEFT' and TrueItemLevel..' ' or '')..(ItemUpgradeID and (Info.Armory_Constants.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r' or '')..(Slot.Direction == 'RIGHT' and ' '..TrueItemLevel or '')
							or
							TrueItemLevel
						)
						if E.db.sle.Armory.Character.Level.ItemColor then
							Slot.ItemLevel:SetTextColor(R, G, B)
						else
							Slot.ItemLevel:SetTextColor(1, 1, 1)
						end
					end

					if E.db.sle.Armory.Character.NoticeMissing ~= false then
						if not Slot.IsEnchanted and Info.Armory_Constants.EnchantableSlots[SlotName] and (ItemType ~= 'INVTYPE_SHIELD' and ItemType ~= 'INVTYPE_HOLDABLE') then
							ErrorDetected = true
							Slot.IsEnchanted = false
							Slot.EnchantWarning:Show()

							if not E.db.sle.Armory.Character.Enchant.WarningIconOnly then
								Slot.ItemEnchant:SetText('|cffff0000'..L["Not Enchanted"])
							end
						end
						
						if Slot.GemCount_Enable > GemCount_Now or Slot.GemCount_Enable > GemCount or GemCount_Now > GemCount then
							ErrorDetected = true
							
							Slot.SocketWarning:Show()
							Slot.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L["Empty Socket"]
						end
						if E.db.sle.Armory.Character.MissingIcon then
							Slot.EnchantWarning.Texture:Show()
							Slot.SocketWarning.Texture:Show()
						else
							Slot.EnchantWarning.Texture:Hide()
							Slot.SocketWarning.Texture:Hide()
						end
					end

					--<< Transmogrify Parts >>--
					if Slot.TransmogrifyAnchor and C_Transmog_GetSlotInfo(Slot.ID, LE_TRANSMOG_TYPE_APPEARANCE) then
						Slot.TransmogrifyAnchor.Link = T.select(6, C_TransmogCollection_GetAppearanceSourceInfo(T.select(3, C_Transmog_GetSlotVisualInfo(Slot.ID, LE_TRANSMOG_TYPE_APPEARANCE))));
						if E.db.sle.Armory.Character.Transmog.enableArrow then Slot.TransmogrifyAnchor:Show() end
						if E.db.sle.Armory.Character.Transmog.enableGlow then LCG.AutoCastGlow_Start(_G["Character"..SlotName],{1, .5, 1, 1},E.db.sle.Armory.Character.Transmog.glowNumber,0.25,1,E.db.sle.Armory.Character.Transmog.glowOffset,E.db.sle.Armory.Character.Transmog.glowOffset,"_TransmogGlow") end
					end
					--<< Illusion Parts >>--
					if Slot.IllusionAnchor then
						IsTransmogrified, _, _, _, _, _, _, ItemTexture = C_Transmog_GetSlotInfo(Slot.ID, LE_TRANSMOG_TYPE_ILLUSION)
						
						if IsTransmogrified then
							Slot.IllusionAnchor.Texture:SetTexture(ItemTexture)
							_, _, Slot.IllusionAnchor.Link = C_TransmogCollection_GetIllusionSourceInfo(T.select(3, C_Transmog_GetSlotVisualInfo(Slot.ID, LE_TRANSMOG_TYPE_ILLUSION)))
							
							Slot.IllusionAnchor:Show()
						end
					end
					--<<Azerite>>--
					if Slot.RankFrame:IsShown() then
						Slot.RankFrame:SetBackdropBorderColor(R, G, B)
					end
				else
					NeedUpdate = true
				end
			-- else
				-- print(SlotName)
				-- NeedUpdate = true
			end

			if NeedUpdate then
				if KF.DebugEnabled then print("Slot need update: ", SlotName) end
				NeedUpdateList = NeedUpdateList or {}
				table.insert(NeedUpdateList, SlotName)
			end
		end

		-- Change Gradation
		if ItemLink and E.db.sle.Armory.Character.Gradation.Display then
			Slot.Gradation:Show()
		else
			Slot.Gradation:Hide()
		end

		if ErrorDetected and E.db.sle.Armory.Character.NoticeMissing then
			Slot.Gradation:SetVertexColor(1, 0, 0)
			Slot.Gradation:Show()
		end

		if not NeedUpdate and Slot.Gradation then
			if ItemLink and E.db.sle.Armory.Character.Gradation.ItemQuality then
				_, _, Slot.ItemRarity, _, _, _, _, _, _ = T.GetItemInfo(ItemLink)
				if Slot.ItemRarity then
					R, G, B = T.GetItemQualityColor(Slot.ItemRarity)
					Slot.Gradation:SetVertexColor(R, G, B)
				else
					NeedUpdateList = NeedUpdateList or {}
					table.insert(NeedUpdateList, SlotName)
				end
			else
				Slot.Gradation:SetVertexColor(T.unpack(E.db.sle.Armory.Character.Gradation.Color))
			end
		end
	end

	if NeedUpdateList then
		self.GearUpdated = NeedUpdateList
		return true
	end

	self.GearUpdated = true
end

function CA:Update_BG()
	if E.db.sle.Armory.Character.Backdrop.SelectedBG == 'HIDE' then
		self.BG:SetTexture(nil)
	elseif E.db.sle.Armory.Character.Backdrop.SelectedBG == 'CUSTOM' then
		self.BG:SetTexture(E.db.sle.Armory.Character.Backdrop.CustomAddress)
	elseif E.db.sle.Armory.Character.Backdrop.SelectedBG == 'CLASS' then
		self.BG:SetTexture("Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\"..E.myclass)
	else
		self.BG:SetTexture(Info.Armory_Constants.BlizzardBackdropList[E.db.sle.Armory.Character.Backdrop.SelectedBG] or 'Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\'..E.db.sle.Armory.Character.Backdrop.SelectedBG)
	end
	
	--CA:AdditionalTextures_Update()
end

function CA:Update_Display(Force)
	local Slot, Mouseover, SocketVisible
	
	if (_G["PaperDollFrame"]:IsMouseOver() and (E.db.sle.Armory.Character.Level.Display == 'MouseoverOnly' or E.db.sle.Armory.Character.Enchant.Display == 'MouseoverOnly' or E.db.sle.Armory.Character.Durability.Display == 'MouseoverOnly' or E.db.sle.Armory.Character.Gem.Display == 'MouseoverOnly')) or Force then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			Slot = self[SlotName]
			Mouseover = Slot:IsMouseOver()
			
			if Slot.ItemLevel then
				if E.db.sle.Armory.Character.Level.Display == 'Always' or Mouseover and E.db.sle.Armory.Character.Level.Display == 'MouseoverOnly' then
					Slot.ItemLevel:Show()
				else
					Slot.ItemLevel:Hide()
				end
				Slot.ItemLevel:Point('TOP'..Slot.Direction, _G["Character"..SlotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 + E.db.sle.Armory.Character.Level.xOffset or -2-E.db.sle.Armory.Character.Level.xOffset, -1+E.db.sle.Armory.Character.Level.yOffset)
			end
			
			if Slot.ItemEnchant then
				if E.db.sle.Armory.Character.Enchant.Display == 'Always' or Mouseover and E.db.sle.Armory.Character.Enchant.Display == 'MouseoverOnly' then
					Slot.ItemEnchant:Show()
				elseif E.db.sle.Armory.Character.Enchant.Display ~= 'Always' and not (E.db.sle.Armory.Character.NoticeMissing and not Slot.IsEnchanted) then
					Slot.ItemEnchant:Hide()
				end
				Slot.ItemEnchant:Point(Slot.Direction, _G["Character"..SlotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 + E.db.sle.Armory.Character.Enchant.xOffset or -2 - E.db.sle.Armory.Character.Enchant.xOffset, 1 + E.db.sle.Armory.Character.Enchant.yOffset)
			end
			
			if Slot.Durability then
				if E.db.sle.Armory.Character.Durability.Display == 'Always' or Mouseover and E.db.sle.Armory.Character.Durability.Display == 'MouseoverOnly' or E.db.sle.Armory.Character.Durability.Display == 'DamagedOnly' then
					Slot.Durability:Show()
				else
					Slot.Durability:Hide()
				end
				Slot.Durability:Point('TOP'..Slot.Direction, _G["Character"..SlotName], 'TOP'..Slot.Direction, Slot.Direction == 'LEFT' and 2 + E.db.sle.Armory.Character.Durability.xOffset or 0 - E.db.sle.Armory.Character.Durability.xOffset, -3 + E.db.sle.Armory.Character.Durability.yOffset)
			end

			SocketVisible = nil

			if Slot.Socket1 then
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G["Character"..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 + E.db.sle.Armory.Character.Gem.xOffset or -2 - E.db.sle.Armory.Character.Gem.xOffset, 2 + E.db.sle.Armory.Character.Gem.yOffset)
				for i = 1, MAX_NUM_SOCKETS do
					if E.db.sle.Armory.Character.Gem.Display == 'Always' or Mouseover and E.db.sle.Armory.Character.Gem.Display == 'MouseoverOnly' then
						if Slot["Socket"..i].GemType then
							Slot["Socket"..i]:Show()
							Slot.SocketWarning:Point(Slot.Direction, Slot["Socket"..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
						end
					else
						if SocketVisible == nil then
							SocketVisible = false
						end
						
						if Slot["Socket"..i].GemType and E.db.sle.Armory.Character.NoticeMissing and not Slot["Socket"..i].GemItemID then
							SocketVisible = true
						end
					end
				end
				
				if SocketVisible then
					for i = 1, MAX_NUM_SOCKETS do
						if Slot["Socket"..i].GemType then
							Slot["Socket"..i]:Show()
							Slot.SocketWarning:Point(Slot.Direction, Slot["Socket"..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
						end
					end
				elseif SocketVisible == false then
					for i = 1, MAX_NUM_SOCKETS do
						Slot["Socket"..i]:Hide()
					end
					
					Slot.SocketWarning:Point(Slot.Direction, Slot.Socket1)
				end
			end
			
			if Force == SlotName then
				break
			end
		end
	end
end

function CA:UpdateSettings(part)
	local db = E.db.sle.Armory.Character
	if not db.Enable then return end
	if db.Enable and _G["CharacterArmory"].Setup_CharacterArmory then _G["CharacterArmory"]:Setup_CharacterArmory() end
	if part == "ilvl" or part == "all" then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			if _G["CharacterArmory"][SlotName] and _G["CharacterArmory"][SlotName].ItemLevel then
				_G["CharacterArmory"][SlotName].ItemLevel:FontTemplate(E.LSM:Fetch('font', db.Level.Font),db.Level.FontSize,db.Level.FontStyle)
			end
		end
	end
	if part == "ench" or part == "all" then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			if _G["CharacterArmory"][SlotName] then
				if _G["CharacterArmory"][SlotName].ItemEnchant then
					_G["CharacterArmory"][SlotName].ItemEnchant:FontTemplate(E.LSM:Fetch('font', db.Enchant.Font),db.Enchant.FontSize,db.Enchant.FontStyle)
				end
				if _G["CharacterArmory"][SlotName].EnchantWarning then
					_G["CharacterArmory"][SlotName].EnchantWarning:Size(db.Enchant.WarningSize)
				end
			end
		end
	end
	if part == "gem" or part == "all" then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			for i = 1, MAX_NUM_SOCKETS do
				if _G["CharacterArmory"][SlotName] and _G["CharacterArmory"][SlotName]["Socket"..i] then
					_G["CharacterArmory"][SlotName]["Socket"..i]:Size(db.Gem.SocketSize)
				else
					break
				end
			end
			if _G["CharacterArmory"][SlotName] and _G["CharacterArmory"][SlotName].SocketWarning then
				_G["CharacterArmory"][SlotName].SocketWarning:Size(db.Gem.WarningSize)
			end
		end
	end
	if part == "dur" or part == "all" then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			if _G["CharacterArmory"][SlotName] and _G["CharacterArmory"][SlotName].Durability then
				_G["CharacterArmory"][SlotName].Durability:FontTemplate(E.LSM:Fetch('font', db.Durability.Font),db.Durability.FontSize,db.Durability.FontStyle)
			end
		end
	end
	if (part == "bg" or part == "all") then
		_G["CharacterArmory"]:Update_BG()
	end
	if part == "gear" or part == "all" then
		_G["CharacterNeckSlot"].RankFrame:ClearAllPoints()
		_G["CharacterNeckSlot"].RankFrame:SetPoint("BOTTOMLEFT", CA["NeckSlot"], 0 + E.db.sle.Armory.Character.AzeritePosition.xOffset, 2 + E.db.sle.Armory.Character.AzeritePosition.yOffset)
		_G["CharacterArmory"]:Update_Gear()
		_G["CharacterArmory"]:Update_Display(true)
	end
end

function CA:UpdateIlvlFont()
	local db = E.db.sle.Armory.Character.Stats.ItemLevel
	_G["CharacterStatsPane"].ItemLevelFrame.Value:FontTemplate(E.LSM:Fetch('font', db.font), db.size or 12, db.outline)
	_G["CharacterStatsPane"].ItemLevelFrame:SetHeight((db.size or 12) + 4)
	_G["CharacterStatsPane"].ItemLevelFrame.Background:SetHeight((db.size or 12) + 4)
	if _G["CharacterStatsPane"].ItemLevelFrame.leftGrad then
		_G["CharacterStatsPane"].ItemLevelFrame.leftGrad:SetHeight((db.size or 12) + 4)
		_G["CharacterStatsPane"].ItemLevelFrame.rightGrad:SetHeight((db.size or 12) + 4)
	end
end

function CA:ElvOverlayToggle()
	if E.db.sle.Armory.Character.Backdrop.Overlay then
		_G["CharacterModelFrameBackgroundOverlay"]:Show()
	else
		_G["CharacterModelFrameBackgroundOverlay"]:Hide()
	end
end

KF.Modules[#KF.Modules + 1] = 'CharacterArmory'
KF.Modules.CharacterArmory = function()
	if E.private.sle.Armory then E.db.sle.Armory.Character.ItemLevel = E.private.sle.Armory.ItemLevel; E.db.sle.Armory.ItemLevel = nil end --DB converts

	if E.db.sle.Armory.Character.Enable then
		Info.CharacterArmory_Activate = true

		-- Setting frame
		_G["CharacterFrame"]:SetHeight(444)

		-- Move right equipment slots
		_G["CharacterHandsSlot"]:SetPoint('TOPRIGHT', _G["CharacterFrameInsetRight"], 'TOPLEFT', -4, -2)

		-- Move bottom equipment slots
		_G["CharacterMainHandSlot"]:SetPoint('BOTTOMLEFT', _G["PaperDollItemsFrame"], 'BOTTOMLEFT', 185, 14)

		if CA.Setup_CharacterArmory then
			CA:Setup_CharacterArmory()
		else
			CA:Show()
		end

		CA:ScanData()
		CA:Update_BG()

		-- Model Frame
		_G["CharacterModelFrame"]:ClearAllPoints()
		_G["CharacterModelFrame"]:SetPoint('TOPLEFT', _G["CharacterHeadSlot"])
		_G["CharacterModelFrame"]:SetPoint('RIGHT', _G["CharacterHandsSlot"])
		_G["CharacterModelFrame"]:SetPoint('BOTTOM', _G["CharacterMainHandSlot"])

		if _G["PaperDollFrame"]:IsShown() then
			_G["CharacterFrame"]:SetWidth(_G["CharacterFrame"].Expanded and 650 or 444)
			_G["CharacterFrameInsetRight"]:SetPoint('TOPLEFT', _G["CharacterFrameInset"], 'TOPRIGHT', 110, 0)
		end

		-- Run KnightArmory
		CA:RegisterEvent('SOCKET_INFO_SUCCESS')
		CA:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
		CA:RegisterEvent('UNIT_INVENTORY_CHANGED')
		CA:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
		CA:RegisterEvent('TRANSMOGRIFY_SUCCESS')
		CA:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		CA:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
		CA:RegisterEvent('LOADING_SCREEN_DISABLED')
		
		--[[
		KF_KnightArmory.CheckButton:Show()
		KF_KnightArmory_NoticeMissing:EnableMouse(true)
		KF_KnightArmory_NoticeMissing.text:SetTextColor(1, 1, 1)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')
		]]
		_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('TOPLEFT', CharacterArmory, -8, 0)
		_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('BOTTOMRIGHT', CharacterArmory, 8, 0)
	elseif Info.CharacterArmory_Activate then
		Info.CharacterArmory_Activate = nil
		
		-- Setting frame to default
		_G["CharacterFrame"]:SetHeight(424)
		_G["CharacterFrame"]:SetWidth(_G["PaperDollFrame"]:IsShown() and _G["CharacterFrame"].Expanded and CHARACTERFRAME_EXPANDED_WIDTH or PANEL_DEFAULT_WIDTH)
		--print(_G["CharacterFrame"]:GetWidth())
		_G["CharacterFrameInsetRight"]:SetPoint(T.unpack(DefaultPosition.InsetDefaultPoint))
		
		-- Move rightside equipment slots to default position
		_G["CharacterHandsSlot"]:SetPoint('TOPRIGHT', _G["CharacterFrameInset"], 'TOPRIGHT', -4, -2)
		
		-- Move bottom equipment slots to default position
		_G["CharacterMainHandSlot"]:SetPoint('BOTTOMLEFT', _G["PaperDollItemsFrame"], 'BOTTOMLEFT', 130, 16)
		
		-- Model Frame
		_G["CharacterModelFrame"]:ClearAllPoints()
		_G["CharacterModelFrame"]:Size(231, 320)
		_G["CharacterModelFrame"]:SetPoint('TOPLEFT', _G["PaperDollFrame"], 'TOPLEFT', 52, -66)
		_G["CharacterModelFrame"].BackgroundTopLeft:Show()
		_G["CharacterModelFrame"].BackgroundTopRight:Show()
		_G["CharacterModelFrame"].BackgroundBotLeft:Show()
		_G["CharacterModelFrame"].BackgroundBotRight:Show()
		_G["CharacterModelFrame"].backdrop:Show()
		
		-- Turn off ArmoryFrame
		CA:Hide()
		CA:UnregisterAllEvents()
		
		--[[
		KF_KnightArmory.CheckButton:Hide()
		KF_KnightArmory_NoticeMissing:EnableMouse(false)
		KF_KnightArmory_NoticeMissing.text:SetTextColor(0.31, 0.31, 0.31)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
		]]
		_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('TOPLEFT', CharacterModelFrame, 0, 0)
		_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('BOTTOMRIGHT', CharacterModelFrame, 0, 0)
	end

	CA:ElvOverlayToggle()
	if SLE._Compatibility["DejaCharacterStats"] then
		PaperDollFrame.ExpandButton:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 2)
		PaperDollFrame.ExpandButton:ClearAllPoints()
		PaperDollFrame.ExpandButton:SetPoint("TOPRIGHT", CA, 14, 8)
		PaperDollFrame.ExpandButton:SetSize(32, 32)
		return
	end

	--Resize and reposition god damned ilevel text
	_G["CharacterStatsPane"].ItemLevelFrame:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelCategory, "BOTTOM", 0, 6)

	CA:UpdateIlvlFont()

	hooksecurefunc("PaperDollFrame_UpdateStats", CA.PaperDollFrame_UpdateStats)

	CA:ToggleStats()
end