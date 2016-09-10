if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end

local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
--GLOBALS: CreateFrame, UIParent, SLE_ArmoryDB, hooksecurefunc, GetInventoryItemGems
local _G = _G
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

local format = format

--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade Character Frame's Item Info like Wow-Armory		>>--
--------------------------------------------------------------------------------
local CA = CharacterArmory or CreateFrame('Frame', 'CharacterArmory', _G["PaperDollFrame"])

local IsGemType = LE_ITEM_CLASS_GEM
local SlotIDList = {}
local InsetDefaultPoint = { _G["CharacterFrameInsetRight"]:GetPoint() }

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
	
	
	function CA:GemSocket_OnEnter()
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')
		
		local Parent = self:GetParent()
		
		if Parent.GemItemID then
			if T.type(Parent.GemItemID) == 'number' then
				if T.GetItemInfo(Parent.GemItemID) then
					_G["GameTooltip"]:SetHyperlink(T.select(2, T.GetItemInfo(Parent.GemItemID)))
					self:SetScript('OnUpdate', nil)
				else
					self:SetScript('OnUpdate', CA.GemSocket_OnEnter)
					return
				end
			else
				_G["GameTooltip"]:ClearLines()
				_G["GameTooltip"]:AddLine("|cffffffff"..Parent.GemItemID)
			end
		elseif Parent.GemType then
			_G["GameTooltip"]:ClearLines()
			_G["GameTooltip"]:AddLine("|cffffffff".._G["EMPTY_SOCKET_"..Parent.GemType])
		end
		
		_G["GameTooltip"]:Show()
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
			
			if not IsShiftKeyDown() then
				SetItemRef(ItemLink, ItemLink, 'LeftButton')
			else
				if Button == 'RightButton' then
					SocketInventoryItem(T.GetInventorySlotInfo(self.SlotName))
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
			
			if CursorType == 'item' and T.select(6, T.GetItemInfo(ItemLink)) == IsGemType then
				SocketInventoryItem(T.GetInventorySlotInfo(self.SlotName))
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
end


function CA:Setup_CharacterArmory()
	--<< Core >>--
	self:Point('TOPLEFT', _G["CharacterFrameInset"], 10, 20)
	self:Point('BOTTOMRIGHT', _G["CharacterFrameInsetRight"], 'BOTTOMLEFT', -10, 5)
	
	--<< Updater >>--
	local args
	self:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'SOCKET_INFO_SUCCESS' or Event == 'ITEM_UPGRADE_MASTER_UPDATE' or Event == 'TRANSMOGRIFY_SUCCESS' or Event == 'PLAYER_ENTERING_WORLD' or Event == 'PLAYER_EQUIPMENT_CHANGED' then
			self.GearUpdated = nil
			self:SetScript('OnUpdate', self.ScanData)
		elseif Event == 'UNIT_INVENTORY_CHANGED' then
			args = ...
			
			if args == 'player' then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.ScanData)
			end
		elseif Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			_, Event, _, _, _, _, _, _, args = ...
			
			if Event == 'ENCHANT_APPLIED' and args == E.myname then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.ScanData)
			end
		elseif Event == 'UPDATE_INVENTORY_DURABILITY' then
			self.DurabilityUpdated = nil
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
			_G["CharacterFrameInsetRight"]:SetPoint(T.unpack(InsetDefaultPoint))
		end
	end)
	hooksecurefunc('PaperDollFrame_SetLevel', function()
		if Info.CharacterArmory_Activate then 
			_G["CharacterLevelText"]:SetText('|c'..RAID_CLASS_COLORS[E.myclass].colorStr.._G["CharacterLevelText"]:GetText())

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
	self.BG:SetPoint('TOPLEFT', self)
	self.BG:SetPoint('BOTTOMRIGHT', self)
	self:Update_BG()
	
	--<< Change Model Frame's frameLevel >>--
	_G["CharacterModelFrame"]:SetFrameLevel(self:GetFrameLevel() + 2)
	
	-- Create each equipment slots gradation, text, gem socket icon.
	local Slot
	for i, SlotName in T.pairs(Info.Armory_Constants.GearList) do
		-- Equipment Tag
		Slot = CreateFrame('Frame', nil, self)
		Slot:Size(130, 41)
		Slot:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 1)
		Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
		Slot.ID, Slot.EmptyTexture = T.GetInventorySlotInfo(SlotName)
		Slot:Point(Slot.Direction, _G["Character"..SlotName], Slot.Direction == 'LEFT' and -1 or 1, 0)
		
		-- Grow each equipment slot's frame level
		_G["Character"..SlotName]:SetFrameLevel(Slot:GetFrameLevel() + 1)
		
		-- Gradation
		Slot.Gradation = Slot:CreateTexture(nil, 'OVERLAY')
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
			KF:TextSetting(Slot, nil, { Tag = 'ItemLevel',
				Font = E.db.sle.Armory.Character.Level.Font,
				FontSize = E.db.sle.Armory.Character.Level.FontSize,
				FontStyle = E.db.sle.Armory.Character.Level.FontStyle,
				directionH = Slot.Direction
			}, 'TOP'..Slot.Direction, _G["Character"..SlotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)
			
			if E.db.sle.Armory.Character.Level.Display == 'Hide' then
				Slot.ItemLevel:Hide()
			end
			
			-- Enchantment Name
			KF:TextSetting(Slot, nil, { Tag = 'ItemEnchant',
				Font = E.db.sle.Armory.Character.Enchant.Font,
				FontSize = E.db.sle.Armory.Character.Enchant.FontSize,
				FontStyle = E.db.sle.Armory.Character.Enchant.FontStyle,
				directionH = Slot.Direction
			}, Slot.Direction, _G["Character"..SlotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 1)
			
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
			KF:TextSetting(Slot, nil, { Tag = 'Durability',
				Font = E.db.sle.Armory.Character.Durability.Font,
				FontSize = E.db.sle.Armory.Character.Durability.FontSize,
				FontStyle = E.db.sle.Armory.Character.Durability.FontStyle,
				directionH = Slot.Direction
			}, 'BOTTOM'..Slot.Direction, _G["Character"..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 3)
			
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
				Slot["Socket"..i]:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 1)
				
				Slot["Socket"..i].SlotName = SlotName
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

	if _G["PawnUI_InventoryPawnButton"] then
		_G["PawnUI_InventoryPawnButton"]:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 1)
	end

	self.Setup_CharacterArmory = nil
end

local function DCS_Check()
	if _G["DCS_ExpandCheck"] then
		_G["DCS_ExpandCheck"]:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 2)
		DCS_Check = nil
	end
end
function CA:ScanData(...)
	self.NeedUpdate = nil
	
	if not self.DurabilityUpdated then
		self.NeedUpdate = self:Update_Durability() or self.NeedUpdate
	end
	
	if self.GearUpdated ~= true then
		self.NeedUpdate = self:Update_Gear() or self.NeedUpdate
	end
	
	if not self.NeedUpdate and self:IsShown() then
		self:SetScript('OnUpdate', nil)
	elseif self.NeedUpdate then
		self:SetScript('OnUpdate', self.ScanData)
	end

	if DCS_Check then DCS_Check() end
end


function CA:Update_Durability()
	local Slot, R, G, B, CurrentDurability, MaxDurability
	
	for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
		Slot = self[SlotName]
		CurrentDurability, MaxDurability = T.GetInventoryItemDurability(Slot.ID)
		
		if CurrentDurability and MaxDurability and not (E.db.sle.Armory.Character.Durability.Display == 'DamagedOnly' and CurrentDurability == MaxDurability) then
			R, G, B = E:ColorGradient((CurrentDurability / MaxDurability), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			Slot.Durability:SetFormattedText("%s%.0f%%|r", E:RGBToHex(R, G, B), (CurrentDurability / MaxDurability) * 100)
			
			if (E.db.sle.Armory.Character.Durability.Display == 'MouseoverOnly' and not Slot:IsMouseOver()) or E.db.sle.Armory.Character.Durability.Display == 'Hide' then
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G["Character"..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 2)
			else
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot.Durability, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Durability:GetText() and (Slot.Direction == 'LEFT' and 3 or -1) or 0, Slot.Durability:GetText() and -1 or 0)
			end
		elseif Slot.Durability then
			Slot.Durability:SetText('')
			Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G["Character"..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 3)
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
	local Slot, ItemLink, ItemData, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, ItemType, ItemTexture, UsableEffect, CurrentLineText, GemID, GemCount_Default, GemCount_Enable, GemCount_Now, GemCount, IsTransmogrified
	
	for _, SlotName in T.pairs(T.type(self.GearUpdated) == 'table' and self.GearUpdated or Info.Armory_Constants.GearList) do
		Slot = self[SlotName]
		ItemLink = T.GetInventoryItemLink('player', Slot.ID)
		ErrorDetected = nil
		
		if not (SlotName == 'ShirtSlot' or SlotName == 'TabardSlot') then
			do --<< Clear Setting >>--
				NeedUpdate, TrueItemLevel, UsableEffect, ItemUpgradeID, ItemType, ItemTexture, IsTransmogrified = nil, nil, nil, nil, nil, nil, nil

				Slot.ItemLevel:SetText(nil)
				Slot.IsEnchanted = nil
				Slot.ItemEnchant:SetText(nil)
				for i = 1, MAX_NUM_SOCKETS do
					Slot["Socket"..i].Texture:SetTexture(nil)
					Slot["Socket"..i].Socket.Link = nil
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
				end
				
				if Slot.IllusionAnchor then
					Slot.IllusionAnchor.Link = nil
					Slot.IllusionAnchor:Hide()
				end
			end
			
			if ItemLink then
				if not ItemLink:find('%[%]') then -- sometimes itemLink is malformed so we need to update when crashed
					do --<< Gem Parts >>--
						ItemData = { T.split(':', ItemLink) }

						for i = 1, #ItemData do
							if i == 4 or i == 5 or i ==6 or i ==7 then
								ItemData.FixedLink = (ItemData.FixedLink and ItemData.FixedLink..':' or '')..0
							else
								ItemData.FixedLink = (ItemData.FixedLink and ItemData.FixedLink..':' or '')..ItemData[i]
							end
						end
						
						self:ClearTooltip(self.ScanTT)
						self.ScanTT:SetHyperlink(ItemData.FixedLink)
						
						GemCount_Default, GemCount_Now, GemCount = 0, 0, 0
						
						-- First, Counting default gem sockets
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G["Knight_CharacterArmory_ScanTTTexture"..i]:GetTexture()
							
							if ItemTexture and ItemTexture:find('Interface\\ItemSocketingFrame\\') then
								GemCount_Default = GemCount_Default + 1
								Slot["Socket"..GemCount_Default].GemType = T.upper(T.gsub(ItemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
							end
						end
						
						-- Second, Check if slot's item enable to adding a socket
						GemCount_Enable = GemCount_Default
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
							ItemTexture = _G["Knight_CharacterArmory_ScanTTTexture"..i]:GetTexture()

							local _, GemLink = GetItemGem(ItemLink, i)
							GemID = ItemData[i + 3]

							if Slot["Socket"..i].GemType and Info.Armory_Constants.GemColor[Slot["Socket"..i].GemType] then
								R, G, B = T.unpack(Info.Armory_Constants.GemColor[Slot["Socket"..i].GemType])
								Slot["Socket"..i].Socket:SetBackdropColor(R, G, B, .5)
								Slot["Socket"..i].Socket:SetBackdropBorderColor(R, G, B)
							else
								Slot["Socket"..i].Socket:SetBackdropColor(1, 1, 1, .5)
								Slot["Socket"..i].Socket:SetBackdropBorderColor(1, 1, 1)
							end

							if ItemTexture or GemLink then
								if E.db.sle.Armory.Character.Gem.Display == 'Always' or E.db.sle.Armory.Character.Gem.Display == 'MouseoverOnly' and Slot.Mouseovered or E.db.sle.Armory.Character.Gem.Display == 'MissingOnly' then
									Slot["Socket"..i]:Show()
									Slot.SocketWarning:Point(Slot.Direction, Slot["Socket"..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
								end

								GemCount_Now = GemCount_Now + 1

								if GemID then
									GemCount = GemCount + 1
									Slot["Socket"..i].GemItemID = GemID
									Slot["Socket"..i].Socket.Link = GemLink

									ItemTexture = T.select(10, T.GetItemInfo(GemID))

									if ItemTexture then
										Slot["Socket"..i].Texture:SetTexture(ItemTexture)
									else
										NeedUpdate = true
									end
								end
							end
						end
						
						--print(SlotName..' : ', GemCount_Default, GemCount_Enable, GemCount_Now, GemCount)
						if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
							NeedUpdate = true
						end
					end
					
					_, _, ItemRarity, BasicItemLevel, _, _, _, _, ItemType, ItemTexture = T.GetItemInfo(ItemLink)
					R, G, B = T.GetItemQualityColor(ItemRarity)

					--<< Enchant Parts >>--
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
							else
								ItemUpgradeID = TrueItemLevel - BasicItemLevel
							end
						end
						
						Slot.ItemLevel:SetText(
							(not TrueItemLevel or BasicItemLevel == TrueItemLevel) and BasicItemLevel
							or
							E.db.sle.Armory.Character.Level.ShowUpgradeLevel and (Slot.Direction == 'LEFT' and TrueItemLevel..' ' or '')..(ItemUpgradeID and (Info.Armory_Constants.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r' or '')..(Slot.Direction == 'RIGHT' and ' '..TrueItemLevel or '')
							or
							TrueItemLevel
						)
					end
					
					if E.db.sle.Armory.Character.NoticeMissing ~= false then
						if not Slot.IsEnchanted and Info.Armory_Constants.EnchantableSlots[SlotName] then 
							local isValid = false
							local isWeapon = Info.Armory_Constants.WeaponTypes[ItemType]
							local isArtifact = (ItemRarity == 6)
							-- print(isArtifact, ItemRarity)
							if (isWeapon and not isArtifact) or (SlotName ~= 'SecondaryHandSlot' and not isWeapon) then
								isValid = true
							end
							if isValid then
								ErrorDetected = true
								Slot.EnchantWarning:Show()
								
								if not E.db.sle.Armory.Character.Enchant.WarningIconOnly then
									Slot.ItemEnchant:SetText('|cffff0000'..L["Not Enchanted"])
								end
							end
						end
						
						if GemCount_Enable > GemCount_Now or GemCount_Enable > GemCount or GemCount_Now > GemCount then
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
						Slot.TransmogrifyAnchor:Show()
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
				else
					NeedUpdate = true
				end
			end
			
			if NeedUpdate then
				NeedUpdateList = NeedUpdateList or {}
				NeedUpdateList[#NeedUpdateList + 1] = SlotName
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
		else
			Slot.Gradation:SetVertexColor(T.unpack(E.db.sle.Armory.Character.Gradation.Color))
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
	else
		self.BG:SetTexture(Info.Armory_Constants.BlizzardBackdropList[E.db.sle.Armory.Character.Backdrop.SelectedBG] or 'Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\'..E.db.sle.Armory.Character.Backdrop.SelectedBG)
	end
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
			end
			
			if Slot.ItemEnchant then
				if E.db.sle.Armory.Character.Enchant.Display == 'Always' or Mouseover and E.db.sle.Armory.Character.Enchant.Display == 'MouseoverOnly' then
					Slot.ItemEnchant:Show()
				elseif E.db.sle.Armory.Character.Enchant.Display ~= 'Always' and not (E.db.sle.Armory.Character.NoticeMissing and not Slot.IsEnchanted) then
					Slot.ItemEnchant:Hide()
				end
			end
			
			if Slot.Durability then
				if E.db.sle.Armory.Character.Durability.Display == 'Always' or Mouseover and E.db.sle.Armory.Character.Durability.Display == 'MouseoverOnly' or E.db.sle.Armory.Character.Durability.Display == 'DamagedOnly' then
					Slot.Durability:Show()
					
					if Slot.Socket1 then
						if Slot.Durability:GetText() == '' or E.db.sle.Armory.Character.Durability.Display == 'MouseoverOnly' and not Mouseover then
							Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G["Character"..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 2)
						else
							Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot.Durability, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Durability:GetText() and (Slot.Direction == 'LEFT' and 3 or -1) or 0, Slot.Durability:GetText() and -1 or 0)
						end
					end
				else
					Slot.Durability:Hide()
					
					Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G["Character"..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 2)
				end
			end
			
			
			SocketVisible = nil
			
			if Slot.Socket1 then
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
		_G["CharacterArmory"]:Update_Gear()
		_G["CharacterArmory"]:Update_Display(true)
	end
end

function CA:UpdateIlvlFont()
	local db = E.db.sle.Armory.Character.ItemLevel
	_G["CharacterStatsPane"].ItemLevelFrame.Value:FontTemplate(E.LSM:Fetch('font', db.font), db.size or 12, db.outline)
	_G["CharacterStatsPane"].ItemLevelFrame:SetHeight((db.size or 12) + 4)
	_G["CharacterStatsPane"].ItemLevelFrame.Background:SetHeight((db.size or 12) + 4)
	if _G["CharacterStatsPane"].ItemLevelFrame.leftGrad then
		_G["CharacterStatsPane"].ItemLevelFrame.leftGrad:SetHeight((db.size or 12) + 4)
		_G["CharacterStatsPane"].ItemLevelFrame.rightGrad:SetHeight((db.size or 12) + 4)
	end
end

KF.Modules[#KF.Modules + 1] = 'CharacterArmory'
KF.Modules.CharacterArmory = function()
	if E.private.sle.Armory then E.db.sle.Armory.Character.ItemLevel = E.private.sle.Armory.ItemLevel; E.db.sle.Armory.ItemLevel = nil end --DB converts
	if E.db.sle.Armory.Character.Enable ~= false then
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
		_G["CharacterModelFrame"].BackgroundTopLeft:Hide()
		_G["CharacterModelFrame"].BackgroundTopRight:Hide()
		_G["CharacterModelFrame"].BackgroundBotLeft:Hide()
		_G["CharacterModelFrame"].BackgroundBotRight:Hide()
		
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
		CA:RegisterEvent('PLAYER_ENTERING_WORLD')
		
		--[[
		KF_KnightArmory.CheckButton:Show()
		KF_KnightArmory_NoticeMissing:EnableMouse(true)
		KF_KnightArmory_NoticeMissing.text:SetTextColor(1, 1, 1)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')
		]]
	elseif Info.CharacterArmory_Activate then
		Info.CharacterArmory_Activate = nil
		
		-- Setting frame to default
		_G["CharacterFrame"]:SetHeight(424)
		_G["CharacterFrame"]:SetWidth(_G["PaperDollFrame"]:IsShown() and _G["CharacterFrame"].Expanded and CHARACTERFRAME_EXPANDED_WIDTH or PANEL_DEFAULT_WIDTH)
		_G["CharacterFrameInsetRight"]:SetPoint(T.unpack(InsetDefaultPoint))
		
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
		
		-- Turn off ArmoryFrame
		CA:Hide()
		CA:UnregisterAllEvents()
		
		--[[
		KF_KnightArmory.CheckButton:Hide()
		KF_KnightArmory_NoticeMissing:EnableMouse(false)
		KF_KnightArmory_NoticeMissing.text:SetTextColor(0.31, 0.31, 0.31)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
		]]
	end
	if SLE._Compatibility["DejaCharacterStats"] then return end
	--Resize and reposition god damned ilevel text
	_G["CharacterStatsPane"].ItemLevelFrame:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelCategory, "BOTTOM", 0, 6)
	CA:UpdateIlvlFont()
	hooksecurefunc("PaperDollFrame_UpdateStats", CA.PaperDollFrame_UpdateStats)
	-- PaperDollFrame_UpdateStats = CA.PaperDollFrame_UpdateStats()
	CA:ToggleStats()
end