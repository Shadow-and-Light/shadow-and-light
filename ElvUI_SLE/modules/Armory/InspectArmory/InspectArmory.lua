if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end
local _G = _G

local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
--GLOBALS: CreateFrame, SLE_ArmoryDB, NotifyInspect, InspectUnit, UIParent, hooksecurefunc, UIDROPDOWNMENU_MENU_LEVEL
local format = format
local GetBuildInfo = GetBuildInfo
local NUM_TALENT_COLUMNS,MAX_TALENT_GROUPS = NUM_TALENT_COLUMNS,MAX_TALENT_GROUPS
local MAX_TALENT_GROUPS, CLASS_TALENT_LEVELS,  MAX_TALENT_TIERS = MAX_TALENT_GROUPS, CLASS_TALENT_LEVELS,  MAX_TALENT_TIERS
local LIGHTYELLOW_FONT_COLOR_CODE = LIGHTYELLOW_FONT_COLOR_CODE
local TRANSMOGRIFIED_HEADER = TRANSMOGRIFIED_HEADER
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local LEVEL = LEVEL
local MAX_NUM_SOCKETS = MAX_NUM_SOCKETS
local ITEM_MOD_AGILITY_SHORT, ITEM_MOD_SPIRIT_SHORT, ITEM_MOD_STAMINA_SHORT, ITEM_MOD_STRENGTH_SHORT, ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_CRIT_RATING_SHORT, ITEM_SPELL_TRIGGER_ONUSE = ITEM_MOD_AGILITY_SHORT, ITEM_MOD_SPIRIT_SHORT, ITEM_MOD_STAMINA_SHORT, ITEM_MOD_STRENGTH_SHORT, ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_CRIT_RATING_SHORT, ITEM_SPELL_TRIGGER_ONUSE
local AGI, SPI, STA, STR, INT, CRIT_ABBR = AGI, SPI, STA, STR, INT, CRIT_ABBR
local LIGHTYELLOW_FONT_COLOR_CODE, GRAY_FONT_COLOR_CODE = LIGHTYELLOW_FONT_COLOR_CODE, GRAY_FONT_COLOR_CODE
local LIGHTYELLOW_FONT_COLOR = LIGHTYELLOW_FONT_COLOR
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local INSPECT_GUILD_NUM_MEMBERS = INSPECT_GUILD_NUM_MEMBERS
local STAT_AVERAGE_ITEM_LEVEL = STAT_AVERAGE_ITEM_LEVEL
local TRADE_SKILLS = TRADE_SKILLS
local PVP, ARENA_2V2, ARENA_3V3, ARENA_5V5, PVP_RATED_BATTLEGROUNDS, GUILD = PVP, ARENA_2V2, ARENA_3V3, ARENA_5V5, PVP_RATED_BATTLEGROUNDS, GUILD
local SendAddonMessage = SendAddonMessage
local ShowUIPanel, HideUIPanel = ShowUIPanel, HideUIPanel
local HandleModifiedItemClick = HandleModifiedItemClick
local AuctionFrameBrowse_Reset = AuctionFrameBrowse_Reset
local IsShiftKeyDown = IsShiftKeyDown
local SetItemRef = SetItemRef
local GetCursorPosition = GetCursorPosition
local PlaySound = PlaySound
local UIDropDownMenu_StopCounting, UIDropDownMenu_StartCounting = UIDropDownMenu_StopCounting, UIDropDownMenu_StartCounting
local UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton = UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton
local SetSmallGuildTabardTextures = SetSmallGuildTabardTextures
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local HasInspectHonorData = HasInspectHonorData
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInspectSpecialization = GetInspectSpecialization
local GetInspectArenaData, GetInspectRatedBGData, GetInspectHonorData = GetInspectArenaData, GetInspectRatedBGData, GetInspectHonorData
local GetGuildLogoInfo, GetInspectGuildInfo = GetGuildLogoInfo, GetInspectGuildInfo
local GetTalentLink = GetTalentLink
local next = next
local NotifyInspect = NotifyInspect


--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade Inspect Frame like Wow-Armory					>>--
--------------------------------------------------------------------------------
local IA = InspectArmory or CreateFrame('Frame', 'InspectArmory', E.UIParent)
local _
local ClientVersion = select(4, GetBuildInfo())
local AISM = _G['Armory_InspectSupportModule']
local ButtonName = INSPECT --L["Knight Inspect"]

local CORE_FRAME_LEVEL = 10
local SLOT_SIZE = 37
local TAB_HEIGHT = 22
local SIDE_BUTTON_WIDTH = 16
local SPACING = 3
local INFO_TAB_SIZE = 22
local TALENT_SLOT_SIZE = 26

local HeadSlotItem = 134110
local BackSlotItem = 134111
local InspectorInterval = 0.25

local Default_InspectUnit
local Default_InspectFrame

--<< Key Table >>--
IA.PageList = { Character = 'CHARACTER', Info = 'INFO', Spec = 'TALENTS' }
IA.InfoPageCategoryList = { 'Profession', 'PvP', 'Guild' }
IA.UnitPopupList = { FRIEND = true, GUILD = true, RAID = true, FOCUS = true, PLAYER = true, PARTY = true, RAID_PLAYER = true }
IA.ModelList = {
	Human =		{ RaceID = 1, 	[2] = { x = -.02, y = -.04, r = -5.76 }, 	[3] = { x = -.02, y = -.07, r = -5.74 }},
	Dwarf = 		{ RaceID = 3, 	[2] = { x = -.02 }, 								[3] = { x = -.05, y = -.09, r = -5.74 }},
	NightElf = 		{ RaceID = 4, 	[2] = { x = -.04, y = -.02, r = -5.74 }, 	[3] = { y = -.02, r = -5.74 }},
	Gnome = 		{ RaceID = 7, 	[2] = { y = -.1 },									[3] = { x = -.04, y = -.1 }},
	Draenei = 	{ RaceID = 11, 	[2] = { x = -.09, r = -5.76 }, 					[3] = { x = -.05, y = -.06, r = -5.7 }},
	Worgen = 	{ RaceID = 22, 	[2] = { y = .1 }, 									[3] = { x = -.14, r = -5.9 }},
	Orc = 			{ RaceID = 2, 	[2] = { y = -.02, r = -6.63 }, 					[3] = { x = .03, y = -.04, r = -6.86 }},
	Scourge = 	{ RaceID = 5, 	[2] = { x = -.01, y = -.06, r = -6.5 }, 		[3] = { y = -.04, r = -6.85 }},
	Tauren = 		{ RaceID = 6, 	[2] = { x = .08, y = .08, r = -6.79 }, 		[3] = { x = .1, y = -.16, r = -6.70 }},
	Troll = 			{ RaceID = 8, 	[2] = { r = -6.85 }, 								[3] = { x = .03, y = .03, r = -6.89 }},
	BloodElf = 	{ RaceID = 10, 	[2] = { x = -.02, y = -.01, r = -6.53 }, 	[3] = { x = .1, y = -.03, r = -6.89 }},
	Goblin = 		{ RaceID = 9, 	[2] = { x = .01, y = -.03, r = -6.57 }, 		[3] = { y = -.05, r = -6.61 }},
	Pandaren = 	{ RaceID = 24, 	[2] = { x = .08, r = -6.85 }, 					[3] = { x = .14, y = .06, r = -6.72 }}
}
IA.CurrentInspectData = {}
IA.Default_CurrentInspectData = {
	Gear = {
		HeadSlot = {}, NeckSlot = {}, ShoulderSlot = {}, BackSlot = {}, ChestSlot = {},
		ShirtSlot = {}, TabardSlot = {}, WristSlot = {}, MainHandSlot = {},
		
		HandsSlot = {}, WaistSlot = {}, LegsSlot = {}, FeetSlot = {}, Finger0Slot = {},
		Finger1Slot = {}, Trinket0Slot = {}, Trinket1Slot = {}, SecondaryHandSlot = {}
	},
	SetItem = {},
	Specialization = {
		[1] = {},	-- Current Specialization
		[2] = {}	-- PvP Talent
	},
	Profession = { [1] = {}, [2] = {} },
	PvP = {
		['2vs2'] = {},
		['3vs3'] = {},
		RB = {}
	}
}
--for i = 1, MAX_TALENT_GROUPS do
--	IA.Default_CurrentInspectData.Specialization[i] = {}
--end


-- IA.MainStats = {	-- STR, INT, AGI, 
-- 	WARRIOR = STR,
-- 	HUNTER = AGI,
-- 	SHAMAN = {
-- 		[(L["Spec_Shaman_Elemental"])] = INT,
-- 		[(L["Spec_Shaman_Enhancement"])] = AGI,
-- 		[(L["Spec_Shaman_Restoration"])] = INT
-- 	},
-- 	MONK = {
-- 		[(L["Spec_Monk_Brewmaster"])] = AGI,
-- 		[(L["Spec_Monk_Mistweaver"])] = INT,
-- 		[(L["Spec_Monk_Windwalker"])] = AGI
-- 	},
-- 	ROGUE = AGI,
-- 	DEATHKNIGHT = STR,
-- 	MAGE = INT,
-- 	DRUID = {
-- 		[(L["Spec_Druid_Balance"])] = INT,
-- 		[(L["Spec_Druid_Feral"])] = AGI,
-- 		[(L["Spec_Druid_Guardian"])] = AGI,
-- 		[(L["Spec_Druid_Restoration"])] = INT
-- 	},
-- 	PALADIN = {
-- 		[(L["Spec_Paladin_Holy"])] = INT,
-- 		[(L["Spec_Paladin_Protection"])] = STR,
-- 		[(L["Spec_Paladin_Retribution"])] = STR
-- 	},
-- 	PRIEST = INT,
-- 	WARLOCK = INT
-- }


do --<< Button Script >>--
	function IA:OnEnter()
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
	
	
	function IA:OnLeave()
		self:SetScript('OnUpdate', nil)
		_G["GameTooltip"]:Hide()
	end
	
	
	function IA:OnClick()
		if self.Link then
			if HandleModifiedItemClick(self.Link) then
			elseif self.EnableAuctionSearch and _G["BrowseName"] and _G["BrowseName"]:IsVisible() then
				AuctionFrameBrowse_Reset(_G["BrowseResetButton"])
				_G["BrowseName"]:SetText(self:GetParent().text:GetText())
				_G["BrowseName"]:SetFocus()
			end
		end
	end
	
	
	function IA:Button_OnEnter()
		self:SetBackdropBorderColor(T.unpack(E.media.rgbvaluecolor))
		self.text:SetText(KF:Color_Value(self.ButtonString))
	end
	
	
	function IA:Button_OnLeave()
		self:SetBackdropBorderColor(T.unpack(E.media.bordercolor))
		self.text:SetText(self.ButtonString)
	end
	
	
	function IA:EquipmentSlot_OnEnter()
		if Info.Armory_Constants.CanTransmogrifySlot[self.SlotName] and T.type(self.TransmogrifyLink) == 'number' and not T.GetItemInfo(self.TransmogrifyLink) then
			self:SetScript('OnUpdate', function()
				if T.GetItemInfo(self.TransmogrifyLink) then
					IA.EquipmentSlot_OnEnter(self)
					self:SetScript('OnUpdate', nil)
				end
			end)
			return
		end
		
		if self.Link then
			_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')
			_G["GameTooltip"]:SetHyperlink(self.Link)
			
			local CurrentLineText, SetName, TooltipText, CurrentTextType
			local CheckSpace = 2
			
			for i = 1, _G["GameTooltip"]:NumLines() do
				CurrentLineText = _G["GameTooltipTextLeft"..i]:GetText()
				
				SetName = CurrentLineText:match('^(.+) %((%d)/(%d)%)$')
				
				if SetName and type(IA.SetItem[SetName]) == 'table' then
					local SetCount, SetOptionCount = 0, 0
					
					for k = 1, _G["GameTooltip"]:NumLines() do
						TooltipText = _G['GameTooltipTextLeft'..(i+k)]:GetText()
						
						if TooltipText == ' ' then
							CheckSpace = CheckSpace - 1
							
							if CheckSpace == 0 then break end
						elseif CheckSpace == 2 then
							if IA.SetItem[SetName][k] then
								if IA.SetItem[SetName][k]:find(LIGHTYELLOW_FONT_COLOR_CODE) then
									SetCount = SetCount + 1
								end
								
								_G['GameTooltipTextLeft'..(i + k)]:SetText(IA.SetItem[SetName][k])
							end
						elseif TooltipText:find(Info.Armory_Constants.ItemSetBonusKey) then
							SetOptionCount = SetOptionCount + 1
							CurrentTextType = TooltipText:match("^%((%d)%)%s.+:%s.+$") or true
							
							if IA.SetItem[SetName]['SetOption'..SetOptionCount] and  IA.SetItem[SetName]['SetOption'..SetOptionCount] ~= CurrentTextType then
								if IA.SetItem[SetName]['SetOption'..SetOptionCount] == true and CurrentTextType ~= true then
									_G['GameTooltipTextLeft'..(i+k)]:SetText(GREEN_FONT_COLOR_CODE..(strsub(TooltipText, (strlen(CurrentTextType) + 4))))
								else
									_G['GameTooltipTextLeft'..(i+k)]:SetText(GRAY_FONT_COLOR_CODE..'('..IA.SetItem[SetName]['SetOption'..SetOptionCount]..') '..TooltipText)
								end
							end
						end
					end
					
					_G['GameTooltipTextLeft'..i]:SetText(string.gsub(CurrentLineText, ' %(%d/', ' %('..SetCount..'/', 1))
					
					break
				elseif Info.Armory_Constants.CanTransmogrifySlot[self.SlotName] and Info.Armory_Constants.ItemBindString[CurrentLineText] and self.TransmogrifyAnchor.Link then
					_G["GameTooltipTextLeft"..i]:SetText(E:RGBToHex(1, .5, 1)..TRANSMOGRIFIED_HEADER..'|n'..(T.GetItemInfo(self.TransmogrifyAnchor.Link) or self.TransmogrifyAnchor.Link)..'|r|n'..CurrentLineText)
				end
				
				if CheckSpace == 0 then break end
			end
			
			_G["GameTooltip"]:Show()
		end
	end
	
	
	function IA:ScrollFrame_OnMouseWheel(Spinning)
		local Page = self:GetScrollChild()
		local PageHeight = Page:GetHeight()
		local WindowHeight = self:GetHeight()
		
		if PageHeight > WindowHeight then
			self.Offset = (self.Offset or 0) - Spinning * 5
			
			Page:ClearAllPoints()
			if self.Offset > PageHeight - WindowHeight then
				self.Offset = PageHeight - WindowHeight
				
				Page:Point('BOTTOMLEFT', self)
				Page:Point('BOTTOMRIGHT', self)
				return
			elseif self.Offset < 0 then
				self.Offset = 0
			end
		else
			self.Offset = 0
		end
		
		Page:Point('TOPLEFT', self, 0, self.Offset)
		Page:Point('TOPRIGHT', self, 0, self.Offset)
	end
	
	
	function IA:Category_OnClick()
		self = self:GetParent()
		
		self.Closed = not self.Closed
		
		IA:ReArrangeCategory()
	end
	
	
	function IA:GemSocket_OnEnter()
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_RIGHT')
		
		local Parent = self:GetParent()
		
		if Parent.GemItemID then
			if T.type(Parent.GemItemID) == 'number' then
				if T.GetItemInfo(Parent.GemItemID) then
					_G["GameTooltip"]:SetHyperlink(T.select(2, T.GetItemInfo(Parent.GemItemID)))
					self:SetScript('OnUpdate', nil)
				else
					self:SetScript('OnUpdate', IA.GemSocket_OnEnter)
					return
				end
			else
				_G["GameTooltip"]:ClearLines()
				_G["GameTooltip"]:AddLine('|cffffffff'..Parent.GemItemID)
			end
		elseif Parent.GemType then
			_G["GameTooltip"]:ClearLines()
			_G["GameTooltip"]:AddLine('|cffffffff'.._G["EMPTY_SOCKET_"..Parent.GemType])
		end
		
		_G["GameTooltip"]:Show()
	end
	
	
	function IA:GemSocket_OnClick()
		self = self:GetParent()
		
		if self.GemItemID and T.type(self.GemItemID) == 'number' then
			local ItemName, ItemLink = T.GetItemInfo(self.GemItemID)
			
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
	end
	
	
	function IA:Transmogrify_OnEnter()
		self.Texture:SetVertexColor(1, .8, 1)
		
		if self.Link then
			if T.GetItemInfo(self.Link) then
				self:SetScript('OnUpdate', nil)
				_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
				_G["GameTooltip"]:SetHyperlink(T.select(2, T.GetItemInfo(self.Link)))
				_G["GameTooltip"]:Show()
			else
				self:SetScript('OnUpdate', IA.Transmogrify_OnEnter)
			end
		end
	end
	
	
	function IA:Transmogrify_OnLeave()
		self:SetScript('OnUpdate', nil)
		self.Texture:SetVertexColor(1, .5, 1)
		
		_G["GameTooltip"]:Hide()
	end
	
	
	function IA:Transmogrify_OnClick(Button)
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
end


function IA:ChangePage(Type)
	for PageType in T.pairs(self.PageList) do
		if self[PageType] then
			if Type == PageType..'Button' then
				Type = PageType
				self[PageType]:Show()
			else
				self[PageType]:Hide()
			end
		end
	end
	
	--self.MainHandSlot:ClearAllPoints()
	--self.SecondaryHandSlot:ClearAllPoints()
	if Type == 'Character' then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			if self[SlotName].ItemLevel then
				self[SlotName].ItemLevel:Hide()
				self[SlotName].Gradation:Show()
			end
		end
		--self.MainHandSlot:Point('BOTTOMRIGHT', self.BP, 'TOP', -2, SPACING)
		--self.SecondaryHandSlot:Point('BOTTOMLEFT', self.BP, 'TOP', 2, SPACING)
	else
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			if self[SlotName].ItemLevel then
				self[SlotName].ItemLevel:Show()
				self[SlotName].Gradation:Hide()
			end
		end
		--self.MainHandSlot:Point('BOTTOMLEFT', self.BP, 'TOPLEFT', 1, SPACING)
		--self.SecondaryHandSlot:Point('BOTTOMRIGHT', self.BP, 'TOPRIGHT', -1, SPACING)
	end
	
	self:DisplayMessage(Type)
end


function IA:DisplayMessage(Type)
	if self[Type].Message then
		self.Message:SetText(self[Type].Message)
		self.MessageFrame.Page:Width(self.Message:GetWidth())
		self.MessageFrame.UpdatedTime = nil
		self.MessageFrame.Offset = 0
		self.MessageFrame.Page:ClearAllPoints()
		self.MessageFrame.Page:Point('TOPLEFT', self.MessageFrame)
		self.MessageFrame.Page:Point('BOTTOMLEFT', self.MessageFrame)
		self.MessageFrame:Show()
	else
		self.MessageFrame:Hide()
	end
end


function IA:CreateInspectFrame()
	do --<< Core >>--
		self:Size(450, 480)
		self:CreateBackdrop('Transparent')
		self:SetFrameStrata('DIALOG')
		self:SetFrameLevel(CORE_FRAME_LEVEL)
		self:SetMovable(true)
		self:SetClampedToScreen(true)
		self:Point('CENTER', E.UIParent)
		self:SetScript('OnHide', function()
			PlaySound('igCharacterInfoClose')
			
			if self.CurrentInspectData.Name then
				local TableIndex = self.CurrentInspectData.Name..(IA.CurrentInspectData.Realm and IA.CurrentInspectData.Realm ~= '' and IA.CurrentInspectData.Realm ~= Info.MyRealm and '-'..IA.CurrentInspectData.Realm or '')
				
				if AISM then
					AISM.RegisteredFunction.InspectArmory = nil
				end
				
				--ENI.CancelInspect(TableIndex)
				IA:UnregisterEvent('INSPECT_READY')
				IA:UnregisterEvent('INSPECT_HONOR_UPDATE')
			end
			
			self.LastDataSetting = nil
			
			self.Model:ClearAllPoints()
			self.Model:Point('TOPLEFT', UIParent)
			self.Model:Point('BOTTOMRIGHT', UIParent, 'TOPLEFT')
		end)
		self:SetScript('OnShow', function() self.Model:Point('TOPRIGHT', self.HandsSlot) end)
		self:SetScript('OnEvent', function(self, Event, ...) if self[Event] then self[Event](Event, ...) end end)
		
		_G["UIPanelWindows"].InspectArmory = { area = 'left', pushable = 1, whileDead = 1 }
		
		self.DisplayUpdater = CreateFrame('Frame', nil, self)
		self.DisplayUpdater:SetScript('OnShow', function() if Info.InspectArmory_Activate then  self:Update_Display(true) end end)
		self.DisplayUpdater:SetScript('OnUpdate', function() if Info.InspectArmory_Activate then  self:Update_Display() end end)
	end
	
	do --<< Tab >>--
		self.Tab = CreateFrame('Frame', nil, self)
		self.Tab:Point('TOPLEFT', self, SPACING, -SPACING)
		self.Tab:Point('BOTTOMRIGHT', self, 'TOPRIGHT', -SPACING, -(SPACING + TAB_HEIGHT))
		self.Tab:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.Tab:SetBackdropBorderColor(0, 0, 0)
		KF:TextSetting(self.Tab, ' |cff2eb7e4Knight Inspect', { FontSize = 10, FontStyle = 'OUTLINE' }, 'LEFT', 6, 1)
		self.Tab:SetScript('OnMouseDown', function() self:StartMoving() end)
		self.Tab:SetScript('OnMouseUp', function() self:StopMovingOrSizing() end)
	end
	
	do --<< Close Button >>--
		self.Close = CreateFrame('Button', nil, self.Tab)
		self.Close:Size(TAB_HEIGHT - 8)
		self.Close:SetTemplate()
		self.Close.backdropTexture:SetVertexColor(0.1, 0.1, 0.1)
		self.Close:Point('RIGHT', -4, 0)
		KF:TextSetting(self.Close, 'X', { FontSize = 13, }, 'CENTER', 1, 0)
		self.Close:SetScript('OnEnter', self.Button_OnEnter)
		self.Close:SetScript('OnLeave', self.Button_OnLeave)
		self.Close:SetScript('OnClick', function() HideUIPanel(self) end)
		self.Close.ButtonString = 'X'
	end
	
	do --<< Bottom Panel >>--
		self.BP = CreateFrame('Frame', nil, self)
		self.BP:Point('TOPLEFT', self, 'BOTTOMLEFT', SPACING, SPACING + TAB_HEIGHT)
		self.BP:Point('BOTTOMRIGHT', self, -SPACING, SPACING)
		self.BP:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.BP:SetBackdropColor(0.09, 0.3, 0.45)
		self.BP:SetBackdropBorderColor(0, 0, 0)
		self.BP:SetFrameLevel(CORE_FRAME_LEVEL + 2)
		
		self.MessageFrame = CreateFrame('ScrollFrame', nil, self.BP)
		self.MessageFrame:Point('TOPLEFT', self.BP, SPACING * 2 + TAB_HEIGHT, 0)
		self.MessageFrame:Point('BOTTOMRIGHT', self.BP, -10, 1)
		self.MessageFrame.UpdateInterval = 3
		self.MessageFrame.ScrollSpeed = 1
		
		local PageWidth
		local VisibleWidth
		self.MessageFrame:SetScript('OnUpdate', function(self, Elapsed)
			PageWidth = self.Page:GetWidth()
			VisibleWidth = self:GetWidth()
			
			if PageWidth > VisibleWidth then
				self.UpdatedTime = (self.UpdatedTime or -self.UpdateInterval) + Elapsed
				
				if self.UpdatedTime > 0 then
					if self.Offset then
						self.Offset = self.Offset - self.ScrollSpeed
					else
						self.UpdatedTime = nil
						self.Offset = 0
					end
					
					self.Page:ClearAllPoints()
					if self.Offset < VisibleWidth - PageWidth then
						self.UpdatedTime = -self.UpdateInterval - 2
						self.Offset = nil
						self.Page:Point('TOPRIGHT', self)
						self.Page:Point('BOTTOMRIGHT', self)
					else
						self.Page:Point('TOPLEFT', self, self.Offset, 0)
						self.Page:Point('BOTTOMLEFT', self, self.Offset, 0)
					end
				end
			end
		end)
		
		self.MessageFrame.Icon = self.MessageFrame:CreateTexture(nil, 'OVERLAY')
		self.MessageFrame.Icon:Size(TAB_HEIGHT)
		self.MessageFrame.Icon:Point('TOPLEFT', self.BP, 'TOPLEFT', SPACING * 2, -1)
		self.MessageFrame.Icon:SetTexture('Interface\\HELPFRAME\\HelpIcon-ReportAbuse')
		
		self.MessageFrame.Page = CreateFrame('Frame', nil, self.MessageFrame)
		self.MessageFrame:SetScrollChild(self.MessageFrame.Page)
		self.MessageFrame.Page:Point('TOPLEFT', self.MessageFrame)
		self.MessageFrame.Page:Point('BOTTOMLEFT', self.MessageFrame)
		KF:TextSetting(self.MessageFrame.Page, '', { FontSize = 10, FontStyle = 'OUTLINE', directionH = 'LEFT' }, 'LEFT', self.MessageFrame.Page)
		
		self.Message = self.MessageFrame.Page.text
	end
	
	do --<< Background >>--
		self.BG = self:CreateTexture(nil, 'OVERLAY')
		self.BG:Point('TOPLEFT', self.Tab, 'BOTTOMLEFT', 0, -38)
		self.BG:Point('BOTTOMRIGHT', self.BP, 'TOPRIGHT')
	end
	
	do --<< Buttons >>--
		for ButtonName, ButtonString in T.pairs(self.PageList) do
			ButtonName = ButtonName..'Button'
			
			self[ButtonName] = CreateFrame('Button', nil, self.BP)
			self[ButtonName]:Size(70, 20)
			self[ButtonName]:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self[ButtonName]:SetBackdropBorderColor(0, 0, 0)
			self[ButtonName]:SetFrameLevel(CORE_FRAME_LEVEL + 1)
			KF:TextSetting(self[ButtonName], _G[ButtonString], { FontSize = 9, FontStyle = 'OUTLINE' })
			self[ButtonName]:SetScript('OnEnter', self.Button_OnEnter)
			self[ButtonName]:SetScript('OnLeave', self.Button_OnLeave)
			self[ButtonName]:SetScript('OnClick', function() IA:ChangePage(ButtonName) end)
			self[ButtonName].ButtonString = _G[ButtonString]
		end
		self.CharacterButton:Point('TOPLEFT', self.BP, 'BOTTOMLEFT', SPACING + 1, 2)
		self.InfoButton:Point('TOPLEFT', self.CharacterButton, 'TOPRIGHT', SPACING, 0)
		self.SpecButton:Point('TOPLEFT', self.InfoButton, 'TOPRIGHT', SPACING, 0)
	end
	
	do --<< Bookmark Star >>--
		self.Bookmark = CreateFrame('CheckButton', nil, self)
		self.Bookmark:Size(24)
		self.Bookmark:EnableMouse(true)
		self.Bookmark.NormalTexture = self.Bookmark:CreateTexture(nil, 'OVERLAY')
		self.Bookmark.NormalTexture:SetTexCoord(0.5, 1, 0, 0.5)
		self.Bookmark.NormalTexture:SetTexture('Interface\\Common\\ReputationStar.tga')
		self.Bookmark.NormalTexture:SetInside()
		self.Bookmark:SetNormalTexture(self.Bookmark.NormalTexture)
		self.Bookmark.HighlightTexture = self.Bookmark:CreateTexture(nil, 'OVERLAY')
		self.Bookmark.HighlightTexture:SetTexCoord(0, 0.5, 0.5, 1)
		self.Bookmark.HighlightTexture:SetTexture('Interface\\Common\\ReputationStar.tga')
		self.Bookmark.HighlightTexture:SetInside()
		self.Bookmark:SetHighlightTexture(self.Bookmark.HighlightTexture)
		self.Bookmark.CheckedTexture = self.Bookmark:CreateTexture(nil, 'OVERLAY')
		self.Bookmark.CheckedTexture:SetTexCoord(0, 0.5, 0, 0.5)
		self.Bookmark.CheckedTexture:SetTexture('Interface\\Common\\ReputationStar.tga')
		self.Bookmark.CheckedTexture:SetInside()
		self.Bookmark:SetCheckedTexture(self.Bookmark.CheckedTexture)
		self.Bookmark:Point('LEFT', self.Tab, 'BOTTOMLEFT', 7, -34)
		self.Bookmark:Hide()
	end
	
	do --<< Texts >>--
		KF:TextSetting(self, nil, { Tag = 'Name', FontSize = 22, FontStyle = 'OUTLINE', }, 'LEFT', self.Bookmark, 'RIGHT', 9, 0)
		KF:TextSetting(self, nil, { Tag = 'Title', FontSize = 9, FontStyle = 'OUTLINE', }, 'BOTTOMLEFT', self.Name, 'TOPLEFT', 2, 5)
		KF:TextSetting(self, nil, { Tag = 'LevelRace', FontSize = 10, directionH = 'LEFT', }, 'BOTTOMLEFT', self.Name, 'BOTTOMRIGHT', 5, 2)
		KF:TextSetting(self, nil, { Tag = 'Guild', FontSize = 10, directionH = 'LEFT', }, 'TOPLEFT', self.Name, 'BOTTOMLEFT', 4, -5)
		self.Guild:Point('RIGHT', self, -44, 0)
	end
	
	do --<< Class, Specialization Icon >>--
		for _, FrameName in T.pairs({ 'SpecIcon', 'ClassIcon', }) do
			self[FrameName..'Slot'] = CreateFrame('Frame', nil, self)
			self[FrameName..'Slot']:Size(24)
			self[FrameName..'Slot']:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self[FrameName] = self[FrameName..'Slot']:CreateTexture(nil, 'OVERLAY')
			self[FrameName]:SetTexCoord(T.unpack(E.TexCoords))
			self[FrameName]:SetInside()
		end
		self.ClassIconSlot:Point('RIGHT', self.Tab, 'BOTTOMRIGHT', -44, -35)
		self.SpecIconSlot:Point('RIGHT', self.ClassIconSlot, 'LEFT', -SPACING, 0)
	end
	
	do --<< Player Model >>--
		self.Model = CreateFrame('DressUpModel', nil, self)
		self.Model:SetFrameStrata('DIALOG')
		self.Model:SetFrameLevel(CORE_FRAME_LEVEL + 1)
		self.Model:EnableMouse(1)
		self.Model:EnableMouseWheel(1)
		self.Model:SetUnit('player')
		self.Model:TryOn(HeadSlotItem)
		self.Model:TryOn(BackSlotItem)
		self.Model:Undress()
		self.Model:SetLight(true, false, 0, 0, 0, 1, 1.0, 1.0, 1.0)
		self.Model:SetScript('OnMouseDown', function(self, button)
			self.StartX, self.StartY = GetCursorPosition()
			
			local EndX, EndY, Z, X, Y
			if button == 'LeftButton' then
				IA.Model:SetScript('OnUpdate', function(self)
					EndX, EndY = GetCursorPosition()
					
					self.rotation = (EndX - self.StartX) / 34 + self:GetFacing()
					self:SetFacing(self.rotation)
					
					self.StartX, self.StartY = GetCursorPosition()
				end)
			elseif button == 'RightButton' then
				IA.Model:SetScript('OnUpdate', function(self)
					EndX, EndY = GetCursorPosition()
					
					Z, X, Y = self:GetPosition(Z, X, Y)
					X = (EndX - self.StartX) / 45 + X
					Y = (EndY - self.StartY) / 45 + Y
					
					self:SetPosition(Z, X, Y)
					self.StartX, self.StartY = GetCursorPosition()
				end)
			end
		end)
		self.Model:SetScript('OnMouseUp', function(self)
			self:SetScript('OnUpdate', nil)
		end)
		self.Model:SetScript('OnMouseWheel', function(self, spining)
			local Z, X, Y = self:GetPosition()
			Z = (spining > 0 and Z + 0.5 or Z - 0.5)
			
			self:SetPosition(Z, X, Y)
		end)
	end
	
	do --<< Equipment Slots >>--
		self.Character = CreateFrame('Frame', nil, self)
		
		local Slot
		for i, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			-- Slot
			Slot = CreateFrame('Button', nil, self)
			Slot:Size(SLOT_SIZE)
			Slot:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			Slot:SetFrameLevel(CORE_FRAME_LEVEL + 3)
			Slot:SetScript('OnEnter', self.EquipmentSlot_OnEnter)
			Slot:SetScript('OnLeave', self.OnLeave)
			Slot:SetScript('OnClick', self.OnClick)
			KF:TextSetting(Slot, '', { FontSize = 12, FontStyle = 'OUTLINE' })
			
			Slot.SlotName = SlotName
			Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
			Slot.ID, Slot.EmptyTexture = T.GetInventorySlotInfo(SlotName)
			
			Slot.Texture = Slot:CreateTexture(nil, 'OVERLAY')
			Slot.Texture:SetTexCoord(T.unpack(E.TexCoords))
			Slot.Texture:SetInside()
			Slot.Texture:SetTexture(Slot.EmptyTexture)
			
			Slot.Highlight = Slot:CreateTexture('Frame', nil, self)
			Slot.Highlight:SetInside()
			--Slot.Highlight:SetTexture("Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\Gradation")
			--if Slot.Direction == 'LEFT' then
				--Slot.Highlight:SetTexCoord(0, 1, 0, 1)
			--else
				--Slot.Highlight:SetTexCoord(1, 0, 0, 1)
			--end
			--Slot.Highlight:SetAlpha(0.8)
			Slot.Highlight:SetColorTexture(1, 1, 1, 0.3)
			Slot:SetHighlightTexture(Slot.Highlight)
			
			if not (SlotName == 'MainHandSlot' or SlotName == 'SecondaryHandSlot') then
				KF:TextSetting(Slot, nil, { Tag = 'ItemLevel', FontSize = 10, FontStyle = 'OUTLINE', }, 'TOP', Slot, 0, -3)
			end
			
			-- Gradation
			Slot.Gradation = CreateFrame('Frame', nil, Slot)
			Slot.Gradation:Size(130, SLOT_SIZE + 4)
			Slot.Gradation:SetFrameLevel(CORE_FRAME_LEVEL + 2)
			Slot.Gradation:Point(Slot.Direction, Slot, Slot.Direction == 'LEFT' and -1 or 1, 0)
			Slot.Gradation.Texture = Slot.Gradation:CreateTexture(nil, 'OVERLAY')
			Slot.Gradation.Texture:SetInside()
			Slot.Gradation.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\Gradation')
			if Slot.Direction == 'LEFT' then
				Slot.Gradation.Texture:SetTexCoord(0, 1, 0, 1)
			else
				Slot.Gradation.Texture:SetTexCoord(1, 0, 0, 1)
			end
			
			if not E.db.sle.Armory.Inspect.Gradation.Display then
				Slot.Gradation.Texture:Hide()
			end
			
			if not (SlotName == 'ShirtSlot' or SlotName == 'TabardSlot') then
				-- Item Level
				KF:TextSetting(Slot.Gradation, nil, { Tag = 'ItemLevel',
					Font = E.db.sle.Armory.Inspect.Level.Font,
					FontSize = E.db.sle.Armory.Inspect.Level.FontSize,
					FontStyle = E.db.sle.Armory.Inspect.Level.FontStyle,
					directionH = Slot.Direction
				}, 'TOP'..Slot.Direction, Slot, 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)
				
				if E.db.sle.Armory.Inspect.Level.Display == 'Hide' then
					Slot.Gradation.ItemLevel:Hide()
				end
				
				-- Enchantment
				KF:TextSetting(Slot.Gradation, nil, { Tag = 'ItemEnchant',
					Font = E.db.sle.Armory.Inspect.Enchant.Font,
					FontSize = E.db.sle.Armory.Inspect.Enchant.FontSize,
					FontStyle = E.db.sle.Armory.Inspect.Enchant.FontStyle,
					directionH = Slot.Direction
				}, Slot.Direction, Slot, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 1)
				
				if E.db.sle.Armory.Inspect.Enchant.Display == 'Hide' then
					Slot.Gradation.ItemEnchant:Hide()
				end
				
				Slot.EnchantWarning = CreateFrame('Button', nil, Slot.Gradation)
				Slot.EnchantWarning:Size(E.db.sle.Armory.Inspect.Enchant.WarningSize)
				Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
				Slot.EnchantWarning.Texture:SetInside()
				Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\Warning-Small')
				Slot.EnchantWarning:Point(Slot.Direction, Slot.Gradation.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
				Slot.EnchantWarning:SetScript('OnEnter', self.OnEnter)
				Slot.EnchantWarning:SetScript('OnLeave', self.OnLeave)
				
				-- Gem Socket
				for i = 1, MAX_NUM_SOCKETS do
					Slot['Socket'..i] = CreateFrame('Frame', nil, Slot.Gradation)
					Slot["Socket"..i]:Size(E.db.sle.Armory.Inspect.Gem.SocketSize)
					Slot['Socket'..i]:SetBackdrop({
						bgFile = E.media.blankTex,
						edgeFile = E.media.blankTex,
						tile = false, tileSize = 0, edgeSize = E.mult,
						insets = { left = 0, right = 0, top = 0, bottom = 0}
					})
					Slot['Socket'..i]:SetBackdropColor(0, 0, 0, 1)
					Slot['Socket'..i]:SetBackdropBorderColor(0, 0, 0)
					Slot['Socket'..i]:SetFrameLevel(CORE_FRAME_LEVEL + 3)
					
					Slot['Socket'..i].Socket = CreateFrame('Button', nil, Slot['Socket'..i])
					Slot['Socket'..i].Socket:SetBackdrop({
						bgFile = E.media.blankTex,
						edgeFile = E.media.blankTex,
						tile = false, tileSize = 0, edgeSize = E.mult,
						insets = { left = 0, right = 0, top = 0, bottom = 0}
					})
					Slot['Socket'..i].Socket:SetInside()
					Slot['Socket'..i].Socket:SetFrameLevel(CORE_FRAME_LEVEL + 4)
					Slot['Socket'..i].Socket:SetScript('OnEnter', self.GemSocket_OnEnter)
					Slot['Socket'..i].Socket:SetScript('OnLeave', self.OnLeave)
					Slot['Socket'..i].Socket:SetScript('OnClick', self.GemSocket_OnClick)
					
					Slot['Socket'..i].Texture = Slot['Socket'..i].Socket:CreateTexture(nil, 'OVERLAY')
					Slot['Socket'..i].Texture:SetTexCoord(.1, .9, .1, .9)
					Slot['Socket'..i].Texture:SetInside()
				end
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 2)
				Slot.Socket2:Point(Slot.Direction, Slot.Socket1, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
				Slot.Socket3:Point(Slot.Direction, Slot.Socket2, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
				
				Slot.SocketWarning = CreateFrame('Button', nil, Slot.Gradation)
				Slot.SocketWarning:Size(E.db.sle.Armory.Inspect.Gem.WarningSize)
				Slot.SocketWarning.Texture = Slot.SocketWarning:CreateTexture(nil, 'OVERLAY')
				Slot.SocketWarning.Texture:SetInside()
				Slot.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\Warning-Small')
				Slot.SocketWarning:SetScript('OnEnter', self.OnEnter)
				Slot.SocketWarning:SetScript('OnLeave', self.OnLeave)
				
				if Info.Armory_Constants.CanTransmogrifySlot[SlotName] then
					Slot.TransmogrifyAnchor = CreateFrame('Button', nil, Slot.Gradation)
					Slot.TransmogrifyAnchor:Size(12)
					Slot.TransmogrifyAnchor:SetFrameLevel(CORE_FRAME_LEVEL + 4)
					Slot.TransmogrifyAnchor:Point('BOTTOM'..Slot.Direction, Slot, Slot.Direction == 'LEFT' and -3 or 3, -3)
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
				end
			end
			
			self[SlotName] = Slot
		end
		
		-- Slot Location : Left
		self.HeadSlot:Point('BOTTOMLEFT', self.NeckSlot, 'TOPLEFT', 0, SPACING)
		self.NeckSlot:Point('BOTTOMLEFT', self.ShoulderSlot, 'TOPLEFT', 0, SPACING)
		self.ShoulderSlot:Point('BOTTOMLEFT', self.BackSlot, 'TOPLEFT', 0, SPACING)
		self.BackSlot:Point('BOTTOMLEFT', self.ChestSlot, 'TOPLEFT', 0, SPACING)
		self.ChestSlot:Point('BOTTOMLEFT', self.ShirtSlot, 'TOPLEFT', 0, SPACING)
		self.ShirtSlot:Point('BOTTOMLEFT', self.TabardSlot, 'TOPLEFT', 0, SPACING)
		self.TabardSlot:Point('BOTTOMLEFT', self.WristSlot, 'TOPLEFT', 0, SPACING)
		self.WristSlot:Point('LEFT', self.BP, 1, 0)
		self.WristSlot:Point('BOTTOM', self.MainHandSlot, 'TOP', 0, SPACING)
		
		-- Slot Location : Right
		self.HandsSlot:Point('BOTTOMRIGHT', self.WaistSlot, 'TOPRIGHT', 0, SPACING)
		self.WaistSlot:Point('BOTTOMRIGHT', self.LegsSlot, 'TOPRIGHT', 0, SPACING)
		self.LegsSlot:Point('BOTTOMRIGHT', self.FeetSlot, 'TOPRIGHT', 0, SPACING)
		self.FeetSlot:Point('BOTTOMRIGHT', self.Finger0Slot, 'TOPRIGHT', 0, SPACING)
		self.Finger0Slot:Point('BOTTOMRIGHT', self.Finger1Slot, 'TOPRIGHT', 0, SPACING)
		self.Finger1Slot:Point('BOTTOMRIGHT', self.Trinket0Slot, 'TOPRIGHT', 0, SPACING)
		self.Trinket0Slot:Point('BOTTOMRIGHT', self.Trinket1Slot, 'TOPRIGHT', 0, SPACING)
		self.Trinket1Slot:Point('RIGHT', self.BP, -1, 0)
		self.Trinket1Slot:Point('BOTTOM', self.SecondaryHandSlot, 'TOP', 0, SPACING)
		
		self.MainHandSlot:Point('BOTTOMRIGHT', self.BP, 'TOP', -2, SPACING)
		self.SecondaryHandSlot:Point('BOTTOMLEFT', self.BP, 'TOP', 2, SPACING)
		
		-- ItemLevel
		KF:TextSetting(self.Character, nil, { Tag = 'AverageItemLevel', FontSize = 12 }, 'TOP', self.Model)
	end
	
	--self.Model:Point('TOPLEFT', self.HeadSlot)
	--self.Model:Point('TOPRIGHT', self.HandsSlot)
	--self.Model:Point('BOTTOM', self.BP, 'TOP', 0, SPACING)
	do --<< Information Page >>--
		self.Info = CreateFrame('ScrollFrame', nil, self)
		self.Info:SetFrameLevel(CORE_FRAME_LEVEL + 20)
		self.Info:EnableMouseWheel(1)
		self.Info:SetScript('OnMouseWheel', self.ScrollFrame_OnMouseWheel)
		
		self.Info.BG = CreateFrame('Frame', nil, self.Info)
		self.Info.BG:SetFrameLevel(CORE_FRAME_LEVEL + 10)
		self.Info.BG:Point('TOPLEFT', self.HeadSlot, 'TOPRIGHT', SPACING, 0)
		self.Info.BG:Point('RIGHT', self.Trinket1Slot, 'BOTTOMLEFT', -SPACING, 0)
		self.Info.BG:Point('BOTTOM', self.MainHandSlot, 'TOP', 0, SPACING)
		self.Info.BG:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.Info.BG:SetBackdropColor(0, 0, 0, .7)
		
		self.Info:Point('TOPLEFT', self.Info.BG, 4, -4)
		self.Info:Point('BOTTOMRIGHT', self.Info.BG, -4, 7)
		
		self.Info.Page = CreateFrame('Frame', nil, self.Info)
		self.Info:SetScrollChild(self.Info.Page)
		self.Info.Page:SetFrameLevel(CORE_FRAME_LEVEL + 11)
		self.Info.Page:Point('TOPLEFT', self.Info, 0, 2)
		self.Info.Page:Point('TOPRIGHT', self.Info, 0, 2)
		
		for _, CategoryType in T.pairs(IA.InfoPageCategoryList) do
			self.Info[CategoryType] = CreateFrame('ScrollFrame', nil, self.Info.Page)
			self.Info[CategoryType]:SetFrameLevel(CORE_FRAME_LEVEL + 12)
			self.Info[CategoryType]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Info[CategoryType]:SetBackdropColor(.08, .08, .08, .8)
			self.Info[CategoryType]:SetBackdropBorderColor(0, 0, 0)
			self.Info[CategoryType]:Point('LEFT', self.Info.Page)
			self.Info[CategoryType]:Point('RIGHT', self.Info.Page)
			self.Info[CategoryType]:Height(INFO_TAB_SIZE + SPACING * 2)
			
			self.Info[CategoryType].IconSlot = CreateFrame('Frame', nil, self.Info[CategoryType])
			self.Info[CategoryType].IconSlot:Size(INFO_TAB_SIZE)
			self.Info[CategoryType].IconSlot:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Info[CategoryType].IconSlot:Point('TOPLEFT', self.Info[CategoryType], SPACING, -SPACING)
			self.Info[CategoryType].Icon = self.Info[CategoryType].IconSlot:CreateTexture(nil, 'OVERLAY')
			self.Info[CategoryType].Icon:SetTexCoord(T.unpack(E.TexCoords))
			self.Info[CategoryType].Icon:SetInside()
			
			self.Info[CategoryType].Tab = CreateFrame('Frame', nil, self.Info[CategoryType])
			self.Info[CategoryType].Tab:Point('TOPLEFT', self.Info[CategoryType].IconSlot, 'TOPRIGHT', 1, 0)
			self.Info[CategoryType].Tab:Point('BOTTOMRIGHT', self.Info[CategoryType], 'TOPRIGHT', -SPACING, -(SPACING + INFO_TAB_SIZE))
			self.Info[CategoryType].Tab:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			
			self.Info[CategoryType].Tooltip = CreateFrame('Button', nil, self.Info[CategoryType])
			self.Info[CategoryType].Tooltip:Point('TOPLEFT', self.Info[CategoryType].Icon)
			self.Info[CategoryType].Tooltip:Point('BOTTOMRIGHT', self.Info[CategoryType].Tab)
			self.Info[CategoryType].Tooltip:SetFrameLevel(CORE_FRAME_LEVEL + 19)
			self.Info[CategoryType].Tooltip:SetScript('OnClick', IA.Category_OnClick)
			
			self.Info[CategoryType].Page = CreateFrame('Frame', nil, self.Info[CategoryType])
			self.Info[CategoryType]:SetScrollChild(self.Info[CategoryType].Page)
			self.Info[CategoryType].Page:SetFrameLevel(CORE_FRAME_LEVEL + 13)
			self.Info[CategoryType].Page:Point('TOPLEFT', self.Info[CategoryType].IconSlot, 'BOTTOMLEFT', 0, -SPACING)
			self.Info[CategoryType].Page:Point('BOTTOMRIGHT', self.Info[CategoryType], -SPACING, SPACING)
		end
		
		do -- Profession Part
			KF:TextSetting(self.Info.Profession.Tab, TRADE_SKILLS, { FontSize = 10 }, 'LEFT', 6, 1)
			self.Info.Profession.CategoryHeight = INFO_TAB_SIZE + 34 + SPACING * 3
			self.Info.Profession.Icon:SetTexture('Interface\\Icons\\Trade_BlackSmithing')
			
			for i = 1, 2 do
				self.Info.Profession['Prof'..i] = CreateFrame('Frame', nil, self.Info.Profession.Page)
				self.Info.Profession['Prof'..i]:Size(20)
				self.Info.Profession['Prof'..i]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Info.Profession['Prof'..i]:SetBackdropBorderColor(0, 0, 0)
				
				self.Info.Profession['Prof'..i].Icon = self.Info.Profession['Prof'..i]:CreateTexture(nil, 'OVERLAY')
				self.Info.Profession["Prof"..i].Icon:SetTexCoord(T.unpack(E.TexCoords))
				self.Info.Profession['Prof'..i].Icon:SetInside()
				
				self.Info.Profession['Prof'..i].BarFrame = CreateFrame('Frame', nil, self.Info.Profession['Prof'..i])
				self.Info.Profession['Prof'..i].BarFrame:Size(136, 5)
				self.Info.Profession['Prof'..i].BarFrame:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Info.Profession['Prof'..i].BarFrame:SetBackdropColor(0, 0, 0)
				self.Info.Profession['Prof'..i].BarFrame:SetBackdropBorderColor(0, 0, 0)
				self.Info.Profession['Prof'..i].BarFrame:Point('BOTTOMLEFT', self.Info.Profession['Prof'..i], 'BOTTOMRIGHT', SPACING, 0)
				
				self.Info.Profession['Prof'..i].Bar = CreateFrame('StatusBar', nil, self.Info.Profession['Prof'..i].BarFrame)
				self.Info.Profession['Prof'..i].Bar:SetInside()
				self.Info.Profession['Prof'..i].Bar:SetStatusBarTexture(E.media.normTex)
				self.Info.Profession['Prof'..i].Bar:SetMinMaxValues(0, 800)
				
				KF:TextSetting(self.Info.Profession['Prof'..i], nil, { Tag = 'Level', FontSize = 10 }, 'TOP', self.Info.Profession['Prof'..i].Icon)
				self.Info.Profession['Prof'..i].Level:Point('RIGHT', self.Info.Profession['Prof'..i].Bar)
				
				KF:TextSetting(self.Info.Profession['Prof'..i], nil, { Tag = 'Name', FontSize = 10, directionH = 'LEFT' }, 'TOP', self.Info.Profession['Prof'..i].Icon)
				self.Info.Profession['Prof'..i].Name:Point('LEFT', self.Info.Profession['Prof'..i].Bar)
				self.Info.Profession['Prof'..i].Name:Point('RIGHT', self.Info.Profession['Prof'..i].Level, 'LEFT', -SPACING, 0)
			end
			
			self.Info.Profession.Prof1:Point('TOPLEFT', self.Info.Profession.Page, 6, -7)
			self.Info.Profession.Prof2:Point('TOPLEFT', self.Info.Profession.Page, 'TOP', 6, -7)
		end
		
		do -- PvP Category
			KF:TextSetting(self.Info.PvP.Tab, PVP, { FontSize = 10 }, 'LEFT', 6, 1)
			self.Info.PvP.CategoryHeight = 182
			self.Info.PvP.Icon:SetTexture('Interface\\Icons\\achievement_bg_killxenemies_generalsroom')
			
			self.Info.PvP.Mark = CreateFrame('ScrollFrame', nil, self.Info.PvP.Page)
			self.Info.PvP.Mark:SetFrameLevel(CORE_FRAME_LEVEL + 11)
			self.Info.PvP.Mark:SetHeight(82)
			self.Info.PvP.Mark:Point('TOPLEFT', self.Info.PvP.Icon, 'BOTTOMLEFT', 0, -SPACING * 2)
			self.Info.PvP.Mark:Point('TOPRIGHT', self.Info.PvP.Tab, 'BOTTOMRIGHT', -SPACING, -SPACING * 2)
			
			self.Info.PvP.Mark.Display = self.Info.PvP.Mark:CreateTexture(nil, 'BACKGROUND', nil, 1)
			self.Info.PvP.Mark.Display:SetAtlas('titleprestige-title-bg')
			self.Info.PvP.Mark.Display:SetInside()
			
			self.Info.PvP.Mark.Icon = self.Info.PvP.Mark:CreateTexture(nil, 'BACKGROUND', nil, 2)
			
			self.Info.PvP.Mark.Circle = self.Info.PvP.Mark:CreateTexture(nil, 'BACKGROUND', nil, 3)
			self.Info.PvP.Mark.Circle:SetAtlas('Talent-RingWithDot')
			self.Info.PvP.Mark.Circle:Size(60)
			self.Info.PvP.Mark.Circle:Point('LEFT', self.Info.PvP.Display, 75, 8)
			self.Info.PvP.Mark.Icon:Point('TOPLEFT', self.Info.PvP.Mark.Circle, 9, -9)
			self.Info.PvP.Mark.Icon:Point('BOTTOMRIGHT', self.Info.PvP.Mark.Circle, -9, 9)
			
			self.Info.PvP.Mark.Wreath = self.Info.PvP.Mark:CreateTexture(nil, 'BACKGROUND', nil, 4)
			self.Info.PvP.Mark.Wreath:SetAtlas('titleprestige-wreath')
			self.Info.PvP.Mark.Wreath:SetBlendMode('BLEND')
			self.Info.PvP.Mark.Wreath:Size(80, 48)
			self.Info.PvP.Mark.Wreath:Point('BOTTOM', self.Info.PvP.Mark.Circle, 0, -10)
			
			KF:TextSetting(self.Info.PvP.Mark, '', { FontSize = 10, directionH = 'LEFT' }, 'LEFT', self.Info.PvP.Mark.Circle, 'RIGHT', 20, 0)
			self.Info.PvP.Mark.text:Point('TOPRIGHT', self.Info.PvP.Mark.Display, -16, -2)
			self.Info.PvP.Mark.text:Point('BOTTOMRIGHT', self.Info.PvP.Mark.Display, -16, 10)
			self.Info.PvP.Mark.text:SetSpacing(6)
			
			for _, Type in T.pairs({ '2vs2', '3vs3', 'RB' }) do
				self.Info.PvP[Type] = CreateFrame('Frame', nil, self.Info.PvP.Page)
				self.Info.PvP[Type]:SetFrameLevel(CORE_FRAME_LEVEL + 15)
				self.Info.PvP[Type]:Size(110, 60)
				
				self.Info.PvP[Type].Rank = self.Info.PvP.Page:CreateTexture(nil, 'OVERLAY')
				self.Info.PvP[Type].Rank:SetTexture('Interface\\ACHIEVEMENTFRAME\\UI-ACHIEVEMENT-SHIELDS')
				self.Info.PvP[Type].Rank:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].Rank:Size(83, 57)
				self.Info.PvP[Type].Rank:Point('CENTER', self.Info.PvP[Type])
				self.Info.PvP[Type].Rank:Hide()
				self.Info.PvP[Type].RankGlow = self.Info.PvP.Page:CreateTexture(nil, 'OVERLAY')
				self.Info.PvP[Type].RankGlow:SetTexture('Interface\\ACHIEVEMENTFRAME\\UI-ACHIEVEMENT-SHIELDS')
				self.Info.PvP[Type].RankGlow:SetBlendMode('ADD')
				self.Info.PvP[Type].RankGlow:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].RankGlow:Point('TOPLEFT', self.Info.PvP[Type].Rank)
				self.Info.PvP[Type].RankGlow:Point('BOTTOMRIGHT', self.Info.PvP[Type].Rank)
				self.Info.PvP[Type].RankGlow:Hide()
				self.Info.PvP[Type].RankNoLeaf = self.Info.PvP.Page:CreateTexture(nil, 'OVERLAY')
				self.Info.PvP[Type].RankNoLeaf:SetTexture('Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Progressive-Shield')
				self.Info.PvP[Type].RankNoLeaf:SetTexCoord(0, .66, 0, .77)
				self.Info.PvP[Type].RankNoLeaf:Point('CENTER', self.Info.PvP[Type].Rank, 0, 2)
				self.Info.PvP[Type].RankNoLeaf:SetVertexColor(.2, .4, 1)
				self.Info.PvP[Type].RankNoLeaf:Size(80, 65)
				
				KF:TextSetting(self.Info.PvP[Type], nil, { Tag = 'Type', FontSize = 10, FontStyle = 'OUTLINE' }, 'TOPLEFT', self.Info.PvP[Type])
				self.Info.PvP[Type].Type:Point('TOPRIGHT', self.Info.PvP[Type])
				self.Info.PvP[Type].Type:SetHeight(22)
				KF:TextSetting(self.Info.PvP[Type], nil, { Tag = 'Rating', FontSize = 22, FontStyle = 'OUTLINE' }, 'CENTER', self.Info.PvP[Type].Rank, 0, 3)
				KF:TextSetting(self.Info.PvP[Type], nil, { Tag = 'Record', FontSize = 10, FontStyle = 'OUTLINE' }, 'TOP', self.Info.PvP[Type].Rank, 'BOTTOM', 0, 12)
			end
			self.Info.PvP['2vs2']:Point('RIGHT', self.Info.PvP['3vs3'], 'LEFT', SPACING, 0)
			self.Info.PvP['2vs2'].Type:SetText(ARENA_2V2)
			
			self.Info.PvP['3vs3']:Point('TOP', self.Info.PvP.Mark, 'BOTTOM', 0, -SPACING)
			self.Info.PvP['3vs3'].Type:SetText(ARENA_3V3)
			
			self.Info.PvP.RB:Point('LEFT', self.Info.PvP['3vs3'], 'RIGHT', -SPACING, 0)
			self.Info.PvP.RB.Type:SetText(PVP_RATED_BATTLEGROUNDS)
		end
		
		do -- Guild Category
			KF:TextSetting(self.Info.Guild.Tab, GUILD, { FontSize = 10 }, 'LEFT', 6, 1)
			self.Info.Guild.CategoryHeight = INFO_TAB_SIZE + 66 + SPACING * 3
			self.Info.Guild.Icon:SetTexture('Interface\\Icons\\ACHIEVEMENT_GUILDPERK_MASSRESURRECTION')
			
			self.Info.Guild.Banner = CreateFrame('Frame', nil, self.Info.Guild.Page)
			self.Info.Guild.Banner:SetInside()
			self.Info.Guild.Banner:SetFrameLevel(CORE_FRAME_LEVEL + 13)
			
			self.Info.Guild.BG = self.Info.Guild.Banner:CreateTexture(nil, 'BACKGROUND')
			self.Info.Guild.BG:Size(33, 44)
			self.Info.Guild.BG:SetTexCoord(.00781250, .32812500, .01562500, .84375000)
			self.Info.Guild.BG:SetTexture('Interface\\GuildFrame\\GuildDifficulty')
			self.Info.Guild.BG:Point('TOP', self.Info.Guild.Page)
			
			self.Info.Guild.Border = self.Info.Guild.Banner:CreateTexture(nil, 'ARTWORK')
			self.Info.Guild.Border:Size(33, 44)
			self.Info.Guild.Border:SetTexCoord(.34375000, .66406250, .01562500, .84375000)
			self.Info.Guild.Border:SetTexture('Interface\\GuildFrame\\GuildDifficulty')
			self.Info.Guild.Border:Point('CENTER', self.Info.Guild.BG)
			
			self.Info.Guild.Emblem = self.Info.Guild.Banner:CreateTexture(nil, 'OVERLAY')
			self.Info.Guild.Emblem:Size(16)
			self.Info.Guild.Emblem:SetTexture('Interface\\GuildFrame\\GuildEmblems_01')
			self.Info.Guild.Emblem:Point('CENTER', self.Info.Guild.BG, 0, 2)
			
			KF:TextSetting(self.Info.Guild.Banner, nil, { Tag = 'Name', FontSize = 14 }, 'TOP', self.Info.Guild.BG, 'BOTTOM', 0, 7)
			KF:TextSetting(self.Info.Guild.Banner, nil, { Tag = 'LevelMembers', FontSize = 9 }, 'TOP', self.Info.Guild.Banner.Name, 'BOTTOM', 0, -2)
		end
	end
	
	do --<< Specialization Page >>--
		self.Spec = CreateFrame('ScrollFrame', nil, self)
		self.Spec:SetFrameLevel(CORE_FRAME_LEVEL + 16)
		self.Spec:EnableMouseWheel(1)
		self.Spec:SetScript('OnMouseWheel', self.ScrollFrame_OnMouseWheel)
		
		self.Spec.BGFrame = CreateFrame('Frame', nil, self.Spec)
		self.Spec.BGFrame:SetFrameLevel(CORE_FRAME_LEVEL + 12)
		self.Spec.BG = self.Spec.BGFrame:CreateTexture(nil, 'BACKGROUND')
		self.Spec.BG:Point('TOP', self.HeadSlot, 'TOPRIGHT', 0, -48-SPACING)
		self.Spec.BG:Point('LEFT', self.WristSlot, 'TOPRIGHT', SPACING, 0)
		self.Spec.BG:Point('RIGHT', self.Trinket1Slot, 'BOTTOMLEFT', -SPACING, 0)
		self.Spec.BG:Point('BOTTOM', self.MainHandSlot, 'TOP', 0, SPACING)
		self.Spec.BG:SetColorTexture(0, 0, 0, .7)
		
		self.Spec:Point('TOPLEFT', self.Spec.BG, 4, -4)
		self.Spec:Point('BOTTOMRIGHT', self.Spec.BG, -4, 7)
		
		self.Spec.Page = CreateFrame('Frame', nil, self.Spec)
		self.Spec:SetScrollChild(self.Spec.Page)
		self.Spec.Page:SetFrameLevel(CORE_FRAME_LEVEL + 13)
		self.Spec.Page:Point('TOPLEFT', self.Spec)
		self.Spec.Page:Point('TOPRIGHT', self.Spec)
		self.Spec.Page:Height((TALENT_SLOT_SIZE + SPACING * 3) * MAX_TALENT_TIERS + 18)
		
		self.Spec.BottomBorder = self.Spec:CreateTexture(nil, 'OVERLAY')
		self.Spec.BottomBorder:Point('TOPLEFT', self.Spec.BG, 'BOTTOMLEFT', 0, E.mult)
		self.Spec.BottomBorder:Point('BOTTOMRIGHT', self.Spec.BG)
		self.Spec.LeftBorder = self.Spec:CreateTexture(nil, 'OVERLAY')
		self.Spec.LeftBorder:Point('TOPLEFT', self.Spec.BG)
		self.Spec.LeftBorder:Point('BOTTOMLEFT', self.Spec.BottomBorder, 'TOPLEFT')
		self.Spec.LeftBorder:Width(E.mult)
		self.Spec.RightBorder = self.Spec:CreateTexture(nil, 'OVERLAY')
		self.Spec.RightBorder:Point('TOPRIGHT', self.Spec.BG)
		self.Spec.RightBorder:Point('BOTTOMRIGHT', self.Spec.BottomBorder, 'TOPRIGHT')
		self.Spec.RightBorder:Width(E.mult)
		
		do -- Specialization Tab
			for i in pairs(IA.Default_CurrentInspectData.Specialization) do
				self.Spec['Spec'..i] = CreateFrame('Button', nil, self.Spec)
				self.Spec['Spec'..i]:Size(120, 40)
				self.Spec['Spec'..i]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = 0,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Spec'..i]:SetBackdropColor(0, 0, 0, .7)
				self.Spec['Spec'..i]:SetBackdropBorderColor(0, 0, 0, 0)
				
				self.Spec['Spec'..i].Icon = CreateFrame('Frame', nil, self.Spec['Spec'..i])
				self.Spec['Spec'..i].Icon:Size(43, 37)
				self.Spec['Spec'..i].Icon:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Spec'..i].Icon:SetBackdropColor(0, 0, 0, .7)
				self.Spec['Spec'..i].Icon:Point('TOPRIGHT', self.Spec['Spec'..i], 'TOPLEFT', -SPACING, 0)
				
				self.Spec['Spec'..i].Click = CreateFrame('Button', nil, self.Spec)
				self.Spec['Spec'..i].Click:SetScript('OnClick', function() self:ToggleSpecializationTab(i, self.CurrentInspectData) end)
				self.Spec['Spec'..i].Click:Point('TOPLEFT', self.Spec['Spec'..i].Icon)
				self.Spec['Spec'..i].Click:Point('BOTTOMRIGHT', self.Spec['Spec'..i])
				self.Spec['Spec'..i].Click:SetFrameLevel(CORE_FRAME_LEVEL + 14)
				
				KF:TextSetting(self.Spec['Spec'..i], nil, { FontSize = 10, FontStyle = 'OUTLINE' }, 'TOPLEFT', self.Spec['Spec'..i].Icon, 'TOPRIGHT', SPACING, 0)
				self.Spec['Spec'..i].text:Point('BOTTOMRIGHT', 0, -4)
				
				self.Spec['Spec'..i].Texture = self.Spec['Spec'..i].Icon:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].Texture:SetTexCoord(.08, .92, .16, .84)
				self.Spec['Spec'..i].Texture:SetInside()
				
				self.Spec['Spec'..i].TopBorder = self.Spec['Spec'..i]:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].TopBorder:Point('TOPLEFT', self.Spec['Spec'..i])
				self.Spec['Spec'..i].TopBorder:Point('BOTTOMRIGHT', self.Spec['Spec'..i], 'TOPRIGHT', 0, -E.mult)
				
				self.Spec['Spec'..i].LeftBorder = self.Spec['Spec'..i]:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].LeftBorder:Point('TOPLEFT', self.Spec['Spec'..i].TopBorder, 'BOTTOMLEFT')
				self.Spec['Spec'..i].LeftBorder:Point('BOTTOMRIGHT', self.Spec['Spec'..i], 'BOTTOMLEFT', E.mult, 0)
				
				self.Spec['Spec'..i].RightBorder = self.Spec['Spec'..i]:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].RightBorder:Point('TOPLEFT', self.Spec['Spec'..i].TopBorder, 'BOTTOMRIGHT', -E.mult, 0)
				self.Spec['Spec'..i].RightBorder:Point('BOTTOMRIGHT', self.Spec['Spec'..i])
				
				self.Spec['Spec'..i].BottomLeftBorder = self.Spec['Spec'..i]:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].BottomLeftBorder:Point('TOPLEFT', self.Spec.BG, 0, E.mult)
				self.Spec['Spec'..i].BottomLeftBorder:Point('BOTTOMRIGHT', self.Spec['Spec'..i].LeftBorder, 'BOTTOMLEFT')
				
				self.Spec['Spec'..i].BottomRightBorder = self.Spec['Spec'..i]:CreateTexture(nil, 'OVERLAY')
				self.Spec['Spec'..i].BottomRightBorder:Point('TOPRIGHT', self.Spec.BG, 0, E.mult)
				self.Spec['Spec'..i].BottomRightBorder:Point('BOTTOMLEFT', self.Spec['Spec'..i].RightBorder, 'BOTTOMRIGHT')
			end
			self.Spec.Spec1:Point('BOTTOMRIGHT', self.Spec.BG, 'TOP', -4, 0)
			self.Spec.Spec2:Point('BOTTOMRIGHT', self.Spec.BG, 'TOPRIGHT', -8, 0)
		end
		
		for i = 1, MAX_TALENT_TIERS do
			self.Spec['TalentTier'..i] = CreateFrame('Frame', nil, self.Spec.Page)
			self.Spec['TalentTier'..i]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Spec['TalentTier'..i]:SetBackdropColor(.08, .08, .08)
			self.Spec['TalentTier'..i]:SetBackdropBorderColor(0, 0, 0)
			self.Spec['TalentTier'..i]:SetFrameLevel(CORE_FRAME_LEVEL + 13)
			self.Spec['TalentTier'..i]:Size(352, TALENT_SLOT_SIZE + SPACING * 2)
			
			for k = 1, NUM_TALENT_COLUMNS do
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] = CreateFrame('Frame', nil, self.Spec['TalentTier'..i])
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetFrameLevel(CORE_FRAME_LEVEL + 14)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:Size(114, TALENT_SLOT_SIZE)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon = CreateFrame('Frame', nil, self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)])
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:Size(20)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture = self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:CreateTexture(nil, 'OVERLAY')
				self.Spec["Talent"..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetTexCoord(T.unpack(E.TexCoords))
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetInside()
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:Point('LEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)], SPACING, 0)
				KF:TextSetting(self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)], nil, { FontSize = 9, directionH = 'LEFT' }, 'TOPLEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon, 'TOPRIGHT', SPACING, SPACING)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:Point('BOTTOMLEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon, 'BOTTOMRIGHT', SPACING, -SPACING)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:Point('RIGHT', -SPACING, 0)
				
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip = CreateFrame('Button', nil, self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)])
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetFrameLevel(CORE_FRAME_LEVEL + 15)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetInside()
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnClick', self.OnClick)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnEnter', self.OnEnter)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip:SetScript('OnLeave', self.OnLeave)
			end
			
			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 1)]:Point('RIGHT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)], 'LEFT', -2, 0)
			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)]:Point('CENTER', self.Spec['TalentTier'..i])
			self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 3)]:Point('LEFT', self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + 2)], 'RIGHT', 2, 0)
		end
	end
	
	do --<< Scanning Tooltip >>--
		self.ScanTTForInspecting = CreateFrame('GameTooltip', 'InspectArmoryScanTT_I', nil, 'GameTooltipTemplate')
		self.ScanTTForInspecting:SetOwner(UIParent, 'ANCHOR_NONE')
		self.ScanTT = CreateFrame('GameTooltip', 'InspectArmoryScanTT', nil, 'GameTooltipTemplate')
		self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
	end
	
	do --<< UnitPopup Setting >>--
		_G["InspectArmory_UnitPopup"].Highlight = _G["InspectArmory_UnitPopup"]:CreateTexture(nil, 'BACKGROUND')
		_G["InspectArmory_UnitPopup"].Highlight:SetTexture('Interface\\QuestFrame\\UI-QuestTitleHighlight')
		_G["InspectArmory_UnitPopup"].Highlight:SetBlendMode('ADD')
		_G["InspectArmory_UnitPopup"].Highlight:SetAllPoints()
		_G["InspectArmory_UnitPopup"]:SetHighlightTexture(_G["InspectArmory_UnitPopup"].Highlight)
		
		_G["InspectArmory_UnitPopup"]:SetScript('OnEnter', function()
			UIDropDownMenu_StopCounting(_G["DropDownList1"])
		end)
		_G["InspectArmory_UnitPopup"]:SetScript('OnLeave', function()
			UIDropDownMenu_StartCounting(_G["DropDownList1"])
		end)
		_G["InspectArmory_UnitPopup"]:SetScript('OnHide', function(self)
			if self.Anchored then
				self.Anchored = nil
				self.Data = nil
				self:SetParent(nil)
				self:ClearAllPoints()
				self:Hide()
			end
		end)
		_G["InspectArmory_UnitPopup"]:SetScript('OnClick', function(self)
			local SendChannel, InspectWork
			
			if AISM and AISM.AISMUserList[self.Data.TableIndex] then
				if self.Data.Realm == Info.MyRealm then
					SendChannel = 'WHISPER'
				elseif AISM.AISMUserList[self.Data.TableIndex] == 'GUILD' then
					SendChannel = 'GUILD'
				elseif Info.CurrentGroupMode ~= 'NoGroup' then
					SendChannel = T.IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or T.upper(Info.CurrentGroupMode)
				end
			end
			
			if self.Data.Unit then
				InspectWork = IA.InspectUnit(self.Data.Unit, { CancelInspectByManual = 'KnightInspect' })
			end
			
			if AISM and SendChannel then
				AISM.CurrentInspectData[self.Data.TableIndex] = {
					UnitID = self.Data.Unit
				}
				
				if not InspectWork then
					IA:UnregisterEvent('INSPECT_READY')
					
					IA.NeedModelSetting = true
					T.twipe(IA.CurrentInspectData)
					E:CopyTable(IA.CurrentInspectData, IA.Default_CurrentInspectData)
				end
				
				local TableIndex = self.Data.TableIndex
				
				AISM:RegisterInspectDataRequest(function(User, Prefix, UserData)
					if Prefix == 'AISM_Inspect' and User == TableIndex then
						E:CopyTable(IA.CurrentInspectData, UserData)
						
						if not InspectWork or IA:IsShown() and IA.LastDataSetting == TableIndex then
							IA:ShowFrame(IA.CurrentInspectData)
						end
						
						return true
					end
				end, 'InspectArmory', true)
				
				SendAddonMessage('AISM_Inspect', 'AISM_DataRequestForInspecting:'..self.Data.Name..'-'..self.Data.Realm..(InspectWork and '-true' or ''), SendChannel, self.Data.TableIndex)
			end
			
			_G["DropDownList1"]:Hide()
		end)
		_G["InspectArmory_UnitPopup"]:SetScript('OnUpdate', function(self)
			if not (self:GetPoint() and self:GetParent()) then
				self:Hide()
				return
			end
			
			if AISM and (T.type(AISM.GroupMemberData[self.Data.TableIndex]) == 'table' or AISM.AISMUserList[self.Data.TableIndex]) or self.Data.Unit and T.UnitIsVisible(self.Data.Unit) and T.UnitIsConnected(self.Data.Unit) and not T.UnitIsDeadOrGhost('player') then
				self:SetText(KF:Color_Value(ButtonName))
				self:Enable()
			else
				self:SetText(ButtonName)
				self:Disable()
			end
		end)
		
		_G["InspectArmory_UnitPopup"].CreateDropDownButton = function(Button, DataTable)
			if not Button then
				Button = UIDropDownMenu_CreateInfo()
				Button.notCheckable = 1
				UIDropDownMenu_AddButton(Button)
				
				Button = _G["DropDownList1Button".._G["DropDownList1"].numButtons]
			end
			
			Button.value = 'InspectArmory'
			Button:SetText((' '):rep(T.strlen(ButtonName)))
			
			_G["InspectArmory_UnitPopup"]:Show()
			_G["InspectArmory_UnitPopup"]:SetParent("DropDownList1")
			_G["InspectArmory_UnitPopup"]:SetFrameStrata(Button:GetFrameStrata())
			_G["InspectArmory_UnitPopup"]:SetFrameLevel(Button:GetFrameLevel() + 1)
			_G["InspectArmory_UnitPopup"]:ClearAllPoints()
			_G["InspectArmory_UnitPopup"]:Point('TOPLEFT', Button)
			_G["InspectArmory_UnitPopup"]:Point('BOTTOMRIGHT', Button)
			_G["InspectArmory_UnitPopup"].Anchored = true
			_G["InspectArmory_UnitPopup"].Data = DataTable
		end
		
		hooksecurefunc('UnitPopup_ShowMenu', function(Menu, Type, Unit, Name, ...)
			if Info.InspectArmory_Activate and IA.UnitPopupList[Type] and UIDROPDOWNMENU_MENU_LEVEL == 1 then
				local Button
				local DataTable = {
					Name = Menu.name or Name,
					Unit = T.UnitExists(Menu.name) and Menu.name or Unit,
					Realm = Menu.server ~= '' and Menu.server or Info.MyRealm
				}
				DataTable.TableIndex = DataTable.Unit and T.GetUnitName(DataTable.Unit, 1) or DataTable.Name..(DataTable.Realm and DataTable.Realm ~= '' and DataTable.Realm ~= Info.MyRealm and '-'..DataTable.Realm or '')
				
				if DataTable.Name == E.myname or DataTable.Unit and (T.UnitCanAttack('player', DataTable.Unit) or not T.UnitIsConnected(DataTable.Unit) or not T.UnitIsPlayer(DataTable.Unit)) then
					if AISM then
						AISM.AISMUserList[DataTable.TableIndex] = nil
						AISM.GroupMemberData[DataTable.TableIndex] = nil
					end
					
					return
				end
				
				for i = 1, _G["DropDownList1"].numButtons do
					if _G['DropDownList1Button'..i].value == 'INSPECT' then
						Button = _G['DropDownList1Button'..i]
						break
					end
				end
				
				if AISM and not (AISM.AISMUserList[DataTable.TableIndex] or AISM.GroupMemberData[DataTable.TableIndex]) then
					local isSending
					
					if DataTable.Unit and not (T.UnitCanAttack('player', DataTable.Unit) or not T.UnitIsConnected(DataTable.Unit) or not T.UnitIsPlayer(DataTable.Unit)) then
						if DataTable.Realm == Info.MyRealm or Info.CurrentGroupMode ~= 'NoGroup' then
							isSending = 'AISM_Response'
							
							SendAddonMessage('AISM', 'AISM_Check', DataTable.Realm == Info.MyRealm and 'WHISPER' or T.IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or T.upper(Info.CurrentGroupMode), DataTable.Name)
						end
					elseif Menu.which == 'GUILD' then
						isSending = 'AISM_GUILD_CheckResponse'
						
						SendAddonMessage('AISM', 'AISM_GUILD_Check', DataTable.Realm == Info.MyRealm and 'WHISPER' or 'GUILD', DataTable.Name)
					elseif DataTable.Realm == Info.MyRealm then
						isSending = 'AISM_Response'
						
						SendAddonMessage('AISM', 'AISM_Check', 'WHISPER', DataTable.Name)
					end
					
					if isSending then
						AISM:RegisterInspectDataRequest(function(User, _, Message)
							if User == DataTable.TableIndex and Message == isSending then
								_G["InspectArmory_UnitPopup"].CreateDropDownButton(Button, DataTable)
								
								return true
							end
						end, 'InspectArmory_Checking')
					end
				end
				
				if DataTable.Unit or Button or (AISM and (AISM.AISMUserList[DataTable.TableIndex] or AISM.GroupMemberData[DataTable.TableIndex]))then
					_G["InspectArmory_UnitPopup"].CreateDropDownButton(Button, DataTable)
				end
			end
		end)
	end
	
	do --<< Updater >>--
		self.Updater = CreateFrame('Frame')
		self.Updater:Hide()
	end
	
	do --<< Inspector >>--
		self.Inspector = CreateFrame('Frame')
		self.Inspector:SetScript('OnUpdate', function(_, elapsed)
			if Info.InspectArmory_Activate then
				self.Inspector.elapsed = (self.Inspector.elapsed or InspectorInterval) - elapsed
				
				if self.Inspector.elapsed < 0 then
					self.Inspector.elapsed = nil
					
					if self.CurrentInspectData then
						local UnitID = self.CurrentInspectData.UnitID
						
						if UnitID then
							local Name, Realm = UnitFullName(UnitID)
							Realm = Realm ~= '' and Realm ~= Info.MyRealm and Realm or nil
							
							if Name and Name == self.CurrentInspectData.Name and Realm == self.CurrentInspectData.Realm then
								NotifyInspect(UnitID)
								return
							else
								SLE:ErrorPrint(L['Inspect is canceled because target was changed or lost.'])
							end
						end
					end
					
					self.Inspector:Hide()
				end
			else
				self.Inspector:Hide()
			end
		end)
		self.Inspector:Hide()
	end
	
	HideUIPanel(self)
	self.CreateInspectFrame = nil
end


function IA:ClearTooltip(Tooltip)
	local TooltipName = Tooltip:GetName()
	
	Tooltip:ClearLines()
	for i = 1, 10 do
		_G[TooltipName..'Texture'..i]:SetTexture(nil)
		_G[TooltipName..'Texture'..i]:ClearAllPoints()
		_G[TooltipName..'Texture'..i]:Point('TOPLEFT', Tooltip)
	end
end


function IA:INSPECT_HONOR_UPDATE()
	local Rating, Played, Won
	
	for i, Type in pairs({ '2vs2', '3vs3' }) do
		Rating, Played, Won = GetInspectArenaData(i)
		IA.CurrentInspectData.PvP[Type] = IA.CurrentInspectData.PvP[Type] or {}
		
		IA.CurrentInspectData.PvP[Type][1] = Rating
		IA.CurrentInspectData.PvP[Type][2] = Played
		IA.CurrentInspectData.PvP[Type][3] = Won
	end
	
	Rating, Played, Won = GetInspectRatedBGData()
	IA.CurrentInspectData.PvP.RB = IA.CurrentInspectData.PvP.RB or {}
	IA.CurrentInspectData.PvP.RB[1] = Rating
	IA.CurrentInspectData.PvP.RB[2] = Played
	IA.CurrentInspectData.PvP.RB[3] = Won
	
	IA.CurrentInspectData.PvP.Honor = T.select(5, GetInspectHonorData())
	
	if not IA.ForbidUpdatePvPInformation then
		IA:InspectFrame_PvPSetting(IA.CurrentInspectData)
	end
end


function IA:INSPECT_READY(InspectedUnitGUID)
	local TableIndex = IA.CurrentInspectData.Name..(IA.CurrentInspectData.Realm and '-'..IA.CurrentInspectData.Realm or '')
	local UnitID = TableIndex
	local Name, Realm = T.UnitFullName(UnitID)
	
	if not Name then
		UnitID = IA.CurrentInspectData.UnitID
		Name, Realm = T.UnitFullName(UnitID)
	end
	
	if not Name then
		_, _, _, _, _, Name, Realm = GetPlayerInfoByGUID(InspectedUnitGUID)
	end
	
	if not (IA.CurrentInspectData.Name == Name and IA.CurrentInspectData.Realm == Realm) then
		return
	else
		RequestInspectHonorData()
		IA:INSPECT_HONOR_UPDATE()
	end
	
	_, _, IA.CurrentInspectData.Race, IA.CurrentInspectData.RaceID, IA.CurrentInspectData.GenderID = GetPlayerInfoByGUID(InspectedUnitGUID)
	
	local NeedReinspect
	local CurrentSetItem = {}
	local Slot, SlotTexture, SlotLink, CheckSpace, R, G, B, TooltipText, TransmogrifiedItem, SetName, SetItemCount, SetItemMax, SetOptionCount
	for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
		Slot = IA[SlotName]
		IA.CurrentInspectData.Gear[SlotName] = IA.CurrentInspectData.Gear[SlotName] or {}
		
		SlotTexture = GetInventoryItemTexture(UnitID, Slot.ID)
		
		if SlotTexture and SlotTexture..'.blp' ~= Slot.EmptyTexture then
			SlotLink = T.GetInventoryItemLink(UnitID, Slot.ID)
			
			if not SlotLink then
				NeedReinspect = true
			else
				IA.CurrentInspectData.Gear[SlotName].ItemLink = SlotLink
				
				IA:ClearTooltip(IA.ScanTTForInspecting)
				IA.ScanTTForInspecting:SetInventoryItem(UnitID, Slot.ID)
				
				TransmogrifiedItem = nil
				CheckSpace = 2
				SetOptionCount = 1
				
				for i = 1, IA.ScanTTForInspecting:NumLines() do
					TooltipText = _G['InspectArmoryScanTT_ITextLeft'..i]:GetText()
					
					if not TransmogrifiedItem and TooltipText:match(TRANSMOGRIFIED_HEADER) then -- TooltipText:match(Info.Armory_Constants.TransmogrifiedKey)
						if T.type(IA.CurrentInspectData.Gear[SlotName].Transmogrify) ~= 'number' then
							IA.CurrentInspectData.Gear[SlotName].Transmogrify = _G['InspectArmoryScanTT_ITextLeft'..(i + 1)]:GetText() --TooltipText:match(Info.Armory_Constants.TransmogrifiedKey)
						end
						
						TransmogrifiedItem = true
					end
					
					SetName, SetItemCount, SetItemMax = TooltipText:match('^(.+) %((%d)/(%d)%)$') -- find string likes 'SetName (0/5)'
					if SetName then
						SetItemCount = T.tonumber(SetItemCount)
						SetItemMax = T.tonumber(SetItemMax)
						
						if (SetItemCount > SetItemMax or SetItemMax == 1) then
							NeedReinspect = true
							
							break
						else
							if not (CurrentSetItem[SetName] or IA.CurrentInspectData.SetItem[SetName]) then
								NeedReinspect = true
							end
							
							CurrentSetItem[SetName] = CurrentSetItem[SetName] or {}
							
							for k = 1, IA.ScanTTForInspecting:NumLines() do
								TooltipText = _G['InspectArmoryScanTT_ITextLeft'..(i+k)]:GetText()
								
								if TooltipText == ' ' then
									CheckSpace = CheckSpace - 1
									
									if CheckSpace == 0 then break end
								elseif CheckSpace == 2 then
									R, G, B = _G['InspectArmoryScanTT_ITextLeft'..(i+k)]:GetTextColor()
									
									if R > LIGHTYELLOW_FONT_COLOR.r - .01 and R < LIGHTYELLOW_FONT_COLOR.r + .01 and G > LIGHTYELLOW_FONT_COLOR.g - .01 and G < LIGHTYELLOW_FONT_COLOR.g + .01 and B > LIGHTYELLOW_FONT_COLOR.b - .01 and B < LIGHTYELLOW_FONT_COLOR.b + .01 then
										TooltipText = LIGHTYELLOW_FONT_COLOR_CODE..TooltipText
									else
										TooltipText = GRAY_FONT_COLOR_CODE..TooltipText
									end
									
									if CurrentSetItem[SetName][k] and CurrentSetItem[SetName][k] ~= TooltipText then
										NeedReinspect = true
									end
									
									CurrentSetItem[SetName][k] = TooltipText
								elseif TooltipText:find(Info.Armory_Constants.ItemSetBonusKey) then
									--TooltipText = (E:RGBToHex(_G['InspectArmoryScanTT_ITextLeft'..(i+k)]:GetTextColor()))..TooltipText..'|r'
									TooltipText = TooltipText:match("^%((%d)%)%s.+:%s.+$") or true
									
									if CurrentSetItem[SetName]['SetOption'..SetOptionCount] and CurrentSetItem[SetName]['SetOption'..SetOptionCount] ~= TooltipText then
										NeedReinspect = true
									end
									
									CurrentSetItem[SetName]['SetOption'..SetOptionCount] = TooltipText
									SetOptionCount = SetOptionCount + 1
								end
							end
							IA.CurrentInspectData.SetItem[SetName] = CurrentSetItem[SetName]
							
							break
						end
					end
					
					if CheckSpace == 0 then break end
				end
			end
		end
	end
	
	if IA.CurrentInspectData.SetItem then
		local SetOptionText
		
		for SetName in T.pairs(IA.CurrentInspectData.SetItem) do
			for i = 1, 99 do
				SetOptionText = IA.CurrentInspectData.SetItem[SetName]['SetOption'..i]
				
				if SetOptionText then
					if type(SetOptionText) == 'number' and #IA.CurrentInspectData.SetItem[SetName] < SetOptionText then
						NeedReinspect = true
					end
				else
					break
				end
			end
			
			if not CurrentSetItem[SetName] then
				IA.CurrentInspectData.SetItem[SetName] = nil
			end
		end
	end
	
	-- Specialization / PvP Talents
	local CurrentSpec = GetInspectSpecialization(UnitID)
	IA.CurrentInspectData.Specialization[1].SpecializationID = CurrentSpec
	SLE_ArmoryDB[ClientVersion] = SLE_ArmoryDB[ClientVersion] or { Specialization = {}, PvPTalent = {} }
	SLE_ArmoryDB[ClientVersion].Specialization[CurrentSpec] = SLE_ArmoryDB[ClientVersion].Specialization[CurrentSpec] or {}
	
	local TalentID, isSelected
	for i = 1, MAX_TALENT_TIERS do
		for k = 1, NUM_TALENT_COLUMNS do
			TalentID, _, _, isSelected = T.GetTalentInfo(i, k, 1, true, UnitID)
			
			TalentID = TalentID or SLE_ArmoryDB[ClientVersion].Specialization[CurrentSpec][((i - 1) * NUM_TALENT_COLUMNS + k)]
			isSelected = isSelected or false
			
			if TalentID then
				SLE_ArmoryDB[ClientVersion].Specialization[CurrentSpec][((i - 1) * NUM_TALENT_COLUMNS + k)] = TalentID
				
				IA.CurrentInspectData.Specialization[1]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] = { TalentID, isSelected }
			else
				NeedReinspect = true
			end
		end
	end
	
	SLE_ArmoryDB[ClientVersion].PvPTalent = SLE_ArmoryDB[ClientVersion].PvPTalent or {}
	SLE_ArmoryDB[ClientVersion].PvPTalent[CurrentSpec] = SLE_ArmoryDB[ClientVersion].PvPTalent[CurrentSpec] or {}
	for i = 1, MAX_PVP_TALENT_TIERS do
		for k = 1, MAX_PVP_TALENT_COLUMNS do
			TalentID, _, _, isSelected = GetPvpTalentInfo(i, k, 1, true, UnitID)
			
			TalentID = TalentID or SLE_ArmoryDB[ClientVersion].PvPTalent[CurrentSpec][((i - 1) * MAX_PVP_TALENT_COLUMNS + k)]
			isSelected = isSelected or false
			
			if TalentID then
				SLE_ArmoryDB[ClientVersion].PvPTalent[CurrentSpec][((i - 1) * MAX_PVP_TALENT_COLUMNS + k)] = TalentID
				
				IA.CurrentInspectData.Specialization[2]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] = { TalentID, isSelected }
			else
				NeedReinspect = true
			end
		end
	end
	
	
	-- Guild
	IA.CurrentInspectData.guildPoint, IA.CurrentInspectData.guildNumMembers = GetInspectGuildInfo(UnitID)
	IA.CurrentInspectData.guildEmblem = { GetGuildLogoInfo(UnitID) }
	
	if NeedReinspect then
		return
	end
	
	IA.ForbidUpdatePvPInformation = nil
	IA:ShowFrame(IA.CurrentInspectData)
	
	if IA.ReinspectCount > 0 then
		IA.ReinspectCount = IA.ReinspectCount - 1
	else
		IA:UnregisterEvent('INSPECT_READY')
	end
end


IA.InspectUnit = function(UnitID)
	if UnitID == 'mouseover' and not T.UnitExists('mouseover') and T.UnitExists('target') or UnitID ~= 'target' and T.UnitIsUnit(UnitID, 'target') then
		UnitID = 'target'
	end
	
	if UnitID ~= 'focus' and T.UnitIsUnit(UnitID, 'focus') then
		UnitID = 'focus'
	end
	
	if T.UnitInParty(UnitID) or T.UnitInRaid(UnitID) then
		UnitID = GetUnitName(UnitID, true)
	end
	
	if not T.UnitIsPlayer(UnitID) then
		return
	elseif T.UnitIsDeadOrGhost('player') then
		SLE:ErrorPrint(L["You can't inspect while dead."])
		return
	elseif not T.UnitIsVisible(UnitID) then
		
		return
	else
		T.twipe(IA.CurrentInspectData)
		E:CopyTable(IA.CurrentInspectData, IA.Default_CurrentInspectData)
		
		IA.CurrentInspectData.UnitID = UnitID
		IA.CurrentInspectData.Title = T.UnitPVPName(UnitID)
		IA.CurrentInspectData.Level = T.UnitLevel(UnitID)
		IA.CurrentInspectData.HonorLevel = T.UnitHonorLevel(UnitID)
		IA.CurrentInspectData.PrestigeLevel = UnitPrestige(UnitID)
		IA.CurrentInspectData.Name, IA.CurrentInspectData.Realm = T.UnitFullName(UnitID)
		_, IA.CurrentInspectData.Class, IA.CurrentInspectData.ClassID = T.UnitClass(UnitID)
		IA.CurrentInspectData.guildName, IA.CurrentInspectData.guildRankName = T.GetGuildInfo(UnitID)
		
		IA.CurrentInspectData.Realm = IA.CurrentInspectData.Realm ~= '' and IA.CurrentInspectData.Realm ~= Info.MyRealm and IA.CurrentInspectData.Realm or nil
		
		IA.ReinspectCount = 0
		IA.NeedModelSetting = true
		IA.ForbidUpdatePvPInformation = true
		IA:RegisterEvent('INSPECT_READY')
		IA:RegisterEvent('INSPECT_HONOR_UPDATE')
		
		SLE:Print(format(L["Try inspecting %s. Sometimes this work will take few second for waiting server's response."], '|c'..RAID_CLASS_COLORS[IA.CurrentInspectData.Class].colorStr..IA.CurrentInspectData.Name..(IA.CurrentInspectData.Realm and '-'..IA.CurrentInspectData.Realm or '')..'|r')..(UnitID == 'mouseover' and ' '..L['Mouseover Inspect must hold your mouse position until inspect is over.'] or ''))
		IA.Inspector:Show()
		
		return true
	end
end


function IA:ShowFrame(DataTable)
	self.GET_ITEM_INFO_RECEIVED = nil
	self:UnregisterEvent('GET_ITEM_INFO_RECEIVED')
	
	for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
		if DataTable.Gear[SlotName] and DataTable.Gear[SlotName].ItemLink and not T.GetItemInfo(DataTable.Gear[SlotName].ItemLink) then
			if not self.GET_ITEM_INFO_RECEIVED then
				self.GET_ITEM_INFO_RECEIVED = function() self:ShowFrame(DataTable) end
			end
		end
	end
	
	if self.GET_ITEM_INFO_RECEIVED then
		self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
		return
	end
	
	self.Updater:Show()
	self.Updater:SetScript('OnUpdate', function()
		if not self:InspectFrame_DataSetting(DataTable) then
			self.Updater:SetScript('OnUpdate', nil)
			self.Updater:Hide()
			self.Inspector:Hide()
			
			self:InspectFrame_PvPSetting(DataTable)
			ShowUIPanel(_G["InspectArmory"])
		end
	end)
end


function IA:InspectFrame_DataSetting(DataTable)
	local SpecTab = DataTable.Specialization.SpecTab or 1
	local Slot, ErrorDetected, NeedUpdate, NeedUpdateList, R, G, B
	local ItemCount, ItemTotal = 0, 0
	
	do	--<< Specialization Page Setting >>--
		local Name, Texture
		
		if DataTable.Specialization[1].SpecializationID and DataTable.Specialization[1].SpecializationID ~= 0 then
			_, Name, _, Texture = GetSpecializationInfoByID(DataTable.Specialization[1].SpecializationID)
			
			if Name then
				if Info.ClassRole[DataTable.Class][Name] then
					self.SpecIcon:SetTexture(Texture)
					self.Spec.Spec1.Texture:SetTexture(Texture)
				end
			end
		end
		
		if not Name then
			self.SpecIcon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
			self.Spec.Spec1.Texture:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
		end
		
		if DataTable.PrestigeLevel > 0 then
			self.Spec.Spec2.Texture:SetTexture(GetPrestigeInfo(DataTable.PrestigeLevel))
		else
			self.Spec.Spec2.Texture:SetTexture('Interface\\Icons\\achievement_bg_killxenemies_generalsroom')
		end
	end
	
	do	--<< Equipment Slot and Enchant, Gem Setting >>--
		local ItemData, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, CurrentUpgrade, MaxUpgrade, ItemType, ItemTexture, CurrentLineText, GemID, GemCount_Default, GemCount_Enable, GemCount_Now, GemCount
		
		-- Setting except shirt and tabard
		for _, SlotName in T.pairs(T.type(self.GearUpdated) == 'table' and self.GearUpdated or Info.Armory_Constants.GearList) do
			Slot = self[SlotName]
			ErrorDetected, ItemRarity, ItemTexture, R, G, B = nil, nil, nil, 0, 0, 0
			
			if SlotName ~= 'ShirtSlot' and SlotName ~= 'TabardSlot' then
				do --<< Clear Setting >>--
					NeedUpdate, TrueItemLevel, ItemUpgradeID, CurrentUpgrade, MaxUpgrade, ItemType = nil, nil, nil, nil, nil, nil
					
					Slot.Link = nil
					Slot.ILvL = nil
					Slot.IsEnchanted = nil
					Slot.Gradation.ItemLevel:SetText(nil)
					Slot.Gradation.ItemEnchant:SetText(nil)
					for i = 1, MAX_NUM_SOCKETS do
						Slot['Socket'..i].Texture:SetTexture(nil)
						Slot['Socket'..i].GemItemID = nil
						Slot['Socket'..i].GemType = nil
						Slot['Socket'..i]:Hide()
					end
					Slot.EnchantWarning:Hide()
					Slot.EnchantWarning.Message = nil
					Slot.SocketWarning:Point(Slot.Direction, Slot.Socket1)
					Slot.SocketWarning:Hide()
					Slot.SocketWarning.Link = nil
					Slot.SocketWarning.Message = nil
					if Slot.TransmogrifyAnchor then
						Slot.TransmogrifyAnchor.Link = nil
						Slot.TransmogrifyAnchor:Hide()
					end
					
					if Slot.ItemLevel then
						Slot.ItemLevel:SetText(nil)
					end
				end
				
				if DataTable.Gear[SlotName].ItemLink then
					-- _, Slot.Link = T.GetItemInfo(DataTable.Gear[SlotName].ItemLink)
					Slot.Link = DataTable.Gear[SlotName].ItemLink

					if Slot.Link then
						do --<< Gem Parts >>--
							ItemData = { T.split(':', Slot.Link) }
							
							if DataTable.Specialization[SpecTab].SpecializationID and DataTable.Specialization[SpecTab].SpecializationID ~= 0 then
								ItemData[11] = DataTable.Specialization[SpecTab].SpecializationID
								
								Slot.Link = ItemData[1]
								
								for i = 2, #ItemData do
									Slot.Link = Slot.Link..':'..ItemData[i]
								end
							end
							
							ItemData.FixedLink = ItemData[1]
							
							for i = 2, #ItemData do
								if i == 4 or i == 5 or i ==6 or i ==7 then
									ItemData.FixedLink = ItemData.FixedLink..':'..0
								else
									ItemData.FixedLink = ItemData.FixedLink..':'..ItemData[i]
								end
							end
							
							self:ClearTooltip(self.ScanTT)
							self.ScanTT:SetHyperlink(ItemData.FixedLink)
							
							GemCount_Default, GemCount_Now, GemCount = 0, 0, 0
							
							-- First, Counting default gem sockets
							for i = 1, MAX_NUM_SOCKETS do
								ItemTexture = _G['InspectArmoryScanTTTexture'..i]:GetTexture()
								
								if ItemTexture and ItemTexture:find('Interface\\ItemSocketingFrame\\') then
									GemCount_Default = GemCount_Default + 1
									Slot["Socket"..GemCount_Default].GemType = T.upper(gsub(ItemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
								end
							end
							
							-- Second, Check if slot's item enable to adding a socket
							GemCount_Enable = GemCount_Default
							--[[
							if (SlotName == 'WaistSlot' and DataTable.Level >= 70) or -- buckle
								((SlotName == 'WristSlot' or SlotName == 'HandsSlot') and (DataTable.Profession[1].Name == GetSpellInfo(110396) and DataTable.Profession[1].Level >= 550 or DataTable.Profession[2].Name == GetSpellInfo(110396) and DataTable.Profession[2].Level >= 550)) then -- BlackSmith
								
								GemCount_Enable = GemCount_Enable + 1
								Slot['Socket'..GemCount_Enable].GemType = 'PRISMATIC'
							end
							]]
							
							
							self:ClearTooltip(self.ScanTT)
							self.ScanTT:SetHyperlink(Slot.Link)
							
							-- Apply current item's gem setting
							for i = 1, MAX_NUM_SOCKETS do
								ItemTexture = _G['InspectArmoryScanTTTexture'..i]:GetTexture()
								GemID = ItemData[i + 3] ~= '' and tonumber(ItemData[i + 3]) or 0
								
								if Slot['Socket'..i].GemType and Info.Armory_Constants.GemColor[Slot['Socket'..i].GemType] then
									R, G, B = unpack(Info.Armory_Constants.GemColor[Slot['Socket'..i].GemType])
									Slot['Socket'..i].Socket:SetBackdropColor(R, G, B, .5)
									Slot['Socket'..i].Socket:SetBackdropBorderColor(R, G, B)
								else
									Slot['Socket'..i].Socket:SetBackdropColor(1, 1, 1, .5)
									Slot['Socket'..i].Socket:SetBackdropBorderColor(1, 1, 1)
								end
								
								if ItemTexture then
									if E.db.sle.Armory.Inspect.Gem.Display == 'Always' or E.db.sle.Armory.Inspect.Gem.Display == 'MouseoverOnly' and Slot.Mouseovered or E.db.sle.Armory.Inspect.Gem.Display == 'MissingOnly' then
										Slot['Socket'..i]:Show()
										Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
									end
									
									GemCount_Now = GemCount_Now + 1
									
									if GemID ~= 0 then
										GemCount = GemCount + 1
										Slot['Socket'..i].GemItemID = GemID
										
										_, Slot['Socket'..i].Socket.Link, _, _, _, _, _, _, _, ItemTexture = T.GetItemInfo(GemID)
										
										if ItemTexture then
											Slot['Socket'..i].Texture:SetTexture(ItemTexture)
										else
											NeedUpdate = true
										end
									end
								end
								
								--[[
								CurrentLineText = select(2, _G['InspectArmoryScanTTTexture'..i]:GetPoint())
								CurrentLineText = DataTable.Gear[SlotName]['Gem'..i] or CurrentLineText ~= self.ScanTT and CurrentLineText.GetText and CurrentLineText:GetText():gsub('|cff......', ''):gsub('|r', '') or nil
								
								if CurrentLineText then
									if KF.db.Modules.Armory.Inspect.Gem.Display == 'Always' or KF.db.Modules.Armory.Inspect.Gem.Display == 'MouseoverOnly' and Slot.Mouseovered or KF.db.Modules.Armory.Inspect.Gem.Display == 'MissingOnly' then
										Slot['Socket'..i]:Show()
										Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
									end
									
									GemCount_Now = GemCount_Now + 1
									
									ItemTexture = ItemTexture or DataTable.Gear[SlotName]['Gem'..i] and select(10, GetItemInfo(DataTable.Gear[SlotName]['Gem'..i])) or nil
									
									if not ItemTexture then
										NeedUpdate = true
									elseif not Info.Armory_Constants.EmptySocketString[CurrentLineText] then
										GemCount = GemCount + 1
										Slot['Socket'..i].GemItemID = CurrentLineText
										Slot['Socket'..i].Texture:SetTexture(ItemTexture)
									end
								end
								]]
							end
							
							if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
								NeedUpdate = true
							end
						end
						
						_, _, ItemRarity, BasicItemLevel, _, _, _, _, ItemType, ItemTexture = T.GetItemInfo(Slot.Link)
						R, G, B = GetItemQualityColor(ItemRarity)
						
						--<< Enchant Parts >>--
						for i = 1, self.ScanTT:NumLines() do
							CurrentLineText = _G['InspectArmoryScanTTTextLeft'..i]:GetText()
							
							if CurrentLineText:find(Info.Armory_Constants.ItemLevelKey_Alt) then
								TrueItemLevel = tonumber(CurrentLineText:match(Info.Armory_Constants.ItemLevelKey_Alt))
							elseif CurrentLineText:find(Info.Armory_Constants.ItemLevelKey) then
								TrueItemLevel = tonumber(CurrentLineText:match(Info.Armory_Constants.ItemLevelKey))
							elseif CurrentLineText:find(Info.Armory_Constants.EnchantKey) then
								if E.db.sle.Armory.Inspect.Enchant.Display ~= 'Hide' then
									CurrentLineText = CurrentLineText:match(Info.Armory_Constants.EnchantKey) -- Get enchant string
									CurrentLineText = gsub(CurrentLineText, ITEM_MOD_AGILITY_SHORT, AGI)
									CurrentLineText = gsub(CurrentLineText, ITEM_MOD_SPIRIT_SHORT, SPI)
									CurrentLineText = gsub(CurrentLineText, ITEM_MOD_STAMINA_SHORT, STA)
									CurrentLineText = gsub(CurrentLineText, ITEM_MOD_STRENGTH_SHORT, STR)
									CurrentLineText = gsub(CurrentLineText, ITEM_MOD_INTELLECT_SHORT, INT)
									CurrentLineText = gsub(CurrentLineText, ITEM_MOD_CRIT_RATING_SHORT, CRIT_ABBR) -- Critical is too long
									CurrentLineText = gsub(CurrentLineText, ' + ', '+') -- Remove space
									
									if L.Armory_ReplaceEnchantString and T.type(L.Armory_ReplaceEnchantString) == 'table' then
										for Old, New in T.pairs(L.Armory_ReplaceEnchantString) do
											CurrentLineText = gsub(CurrentLineText, Old, New)
										end
									end
									
									for Old, New in T.pairs(SLE_ArmoryDB.EnchantString) do
										CurrentLineText = T.gsub(CurrentLineText, Old, New)
									end
									
									Slot.Gradation.ItemEnchant:SetText('|cffceff00'..CurrentLineText)
								end
								
								Slot.IsEnchanted = true
							elseif CurrentLineText:find(ITEM_UPGRADE_TOOLTIP_FORMAT) then
								CurrentUpgrade, MaxUpgrade = CurrentLineText:match(Info.Armory_Constants.ItemUpgradeKey)
							end
						end
						
						--<< ItemLevel Parts >>--
						ItemUpgradeID = ItemData[12]
						
						if BasicItemLevel then
							if ItemUpgradeID then
								if ItemUpgradeID == '' or not E.db.sle.Armory.Inspect.Level.ShowUpgradeLevel and ItemRarity == 7 then
									ItemUpgradeID = nil
								elseif CurrentUpgrade or MaxUpgrade then
									ItemUpgradeID = TrueItemLevel - BasicItemLevel
								else
									ItemUpgradeID = nil
								end
							end
							
							Slot.ILvL = TrueItemLevel or BasicItemLevel
							
							if Slot.ItemLevel then
								Slot.ItemLevel:SetText((ItemUpgradeID and (Info.Armory_Constants.UpgradeColor[ItemUpgradeID] or '|cffffffff') or '')..TrueItemLevel)
							end
							
							Slot.Gradation.ItemLevel:SetText(
								(not TrueItemLevel or BasicItemLevel == TrueItemLevel) and BasicItemLevel
								or
								E.db.sle.Armory.Inspect.Level.ShowUpgradeLevel and (Slot.Direction == 'LEFT' and TrueItemLevel..' ' or '')..(ItemUpgradeID and (Info.Armory_Constants.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r' or '')..(Slot.Direction == 'RIGHT' and ' '..TrueItemLevel or '')
								or
								TrueItemLevel
							)
						end
						
						-- Check Error
						--[[
						if (not Slot.IsEnchanted and Info.Armory_Constants.EnchantableSlots[SlotName]) or ((SlotName == 'Finger0Slot' or SlotName == 'Finger1Slot') and (DataTable.Profession[1].Name == GetSpellInfo(110400) and DataTable.Profession[1].Level >= 550 or DataTable.Profession[2].Name == GetSpellInfo(110400) and DataTable.Profession[2].Level >= 550) and not Slot.IsEnchanted) then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.Gradation.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
						elseif SlotName == 'ShoulderSlot' and KF.Table.ItemEnchant_Profession_Inscription and (DataTable.Profession[1].Name == GetSpellInfo(110417) and DataTable.Profession[1].Level >= KF.Table.ItemEnchant_Profession_Inscription.NeedLevel or DataTable.Profession[2].Name == GetSpellInfo(110417) and DataTable.Profession[2].Level >= KF.Table.ItemEnchant_Profession_Inscription.NeedLevel) and not KF.Table.ItemEnchant_Profession_Inscription[enchantID] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110400)..'|r : '..L['This is not profession only.']
						elseif SlotName == 'WristSlot' and KF.Table.ItemEnchant_Profession_LeatherWorking and (DataTable.Profession[1].Name == GetSpellInfo(110423) and DataTable.Profession[1].Level >= KF.Table.ItemEnchant_Profession_LeatherWorking.NeedLevel or DataTable.Profession[2].Name == GetSpellInfo(110423) and DataTable.Profession[2].Level >= KF.Table.ItemEnchant_Profession_LeatherWorking.NeedLevel) and not KF.Table.ItemEnchant_Profession_LeatherWorking[enchantID] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110423)..'|r : '..L['This is not profession only.']
						elseif SlotName == 'BackSlot' and KF.Table.ItemEnchant_Profession_Tailoring and (DataTable.Profession[1].Name == GetSpellInfo(110426) and DataTable.Profession[1].Level >= KF.Table.ItemEnchant_Profession_Tailoring.NeedLevel or DataTable.Profession[2].Name == GetSpellInfo(110426) and DataTable.Profession[2].Level >= KF.Table.ItemEnchant_Profession_Tailoring.NeedLevel) and not KF.Table.ItemEnchant_Profession_Tailoring[enchantID] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110426)..'|r : '..L['This is not profession only.']
						end
						]]
						
						if E.db.sle.Armory.Inspect.NoticeMissing ~= false then
							if not Slot.IsEnchanted and Info.Armory_Constants.EnchantableSlots[SlotName] and not (SlotName == 'SecondaryHandSlot' and ItemType ~= 'INVTYPE_WEAPON' and ItemType ~= 'INVTYPE_WEAPONOFFHAND' and ItemType ~= 'INVTYPE_RANGEDRIGHT') then
								ErrorDetected = true
								Slot.EnchantWarning:Show()
								
									if not E.db.sle.Armory.Character.Enchant.WarningIconOnly then
									Slot.Gradation.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
								end
							end
							
							if GemCount_Enable > GemCount_Now or GemCount_Enable > GemCount or GemCount_Now > GemCount then
								ErrorDetected = true
								
								Slot.SocketWarning:Show()
								Slot.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L['Empty Socket']
								
								--[[
								if GemCount_Enable > GemCount_Now then
									if SlotName == 'WaistSlot' then
										if TrueItemLevel < 300 then
											_, Slot.SocketWarning.Link = GetItemInfo(41611)	
										elseif TrueItemLevel < 417 then
											_, Slot.SocketWarning.Link = GetItemInfo(55054)
										else
											_, Slot.SocketWarning.Link = GetItemInfo(90046)
										end
										
										Slot.SocketWarning.Message = L['Missing Buckle']
										
										Slot.SocketWarning:SetScript('OnClick', function(self)
											local itemName, itemLink
											
											if TrueItemLevel < 300 then
												itemName, itemLink = GetItemInfo(41611)
											elseif TrueItemLevel < 417 then
												itemName, itemLink = GetItemInfo(55054)
											else
												itemName, itemLink = GetItemInfo(90046)
											end
											
											if HandleModifiedItemClick(itemLink) then
											elseif IsShiftKeyDown() and BrowseName and BrowseName:IsVisible() then
												AuctionFrameBrowse_Reset(BrowseResetButton)
												BrowseName:SetText(itemName)
												BrowseName:SetFocus()
											end
										end)
									elseif SlotName == 'HandsSlot' then
										Slot.SocketWarning.Link = GetSpellLink(114112)
										Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
									elseif SlotName == 'WristSlot' then
										Slot.SocketWarning.Link = GetSpellLink(113263)
										Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
									end
								else
									Slot.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L['Empty Socket']
								end
								]]
							end
						end
						
						--<< Transmogrify Parts >>--
						if Slot.TransmogrifyAnchor then
							Slot.TransmogrifyAnchor.Link = DataTable.Gear[SlotName].Transmogrify ~= 'NotDisplayed' and DataTable.Gear[SlotName].Transmogrify or nil
							
							if T.type(Slot.TransmogrifyAnchor.Link) == 'number' then
								Slot.TransmogrifyAnchor:Show()
							end
						end
					else
						NeedUpdate = true
					end
				end
				
				Slot.Texture:SetTexture(ItemTexture or Slot.EmptyTexture)
				
				if NeedUpdate then
					NeedUpdateList = NeedUpdateList or {}
					NeedUpdateList[#NeedUpdateList + 1] = SlotName
				end
			else
				Slot.Link = DataTable.Gear[SlotName].ItemLink
				
				if Slot.Link then
					_, _, ItemRarity, _, _, _, _, _, _, ItemTexture = T.GetItemInfo(Slot.Link)
					
					if ItemRarity then
						R, G, B = T.GetItemQualityColor(ItemRarity)
					else
						NeedUpdateList = NeedUpdateList or {}
						NeedUpdateList[#NeedUpdateList + 1] = SlotName
					end
				end
				
				Slot.Texture:SetTexture(ItemTexture or self[SlotName].EmptyTexture)
			end
			
			-- Change Gradation
			if Slot.Link and E.db.sle.Armory.Inspect.Gradation.Display then
				Slot.Gradation.Texture:Show()
			else
				Slot.Gradation.Texture:Hide()
			end
			
			if ErrorDetected and E.db.sle.Armory.Inspect.NoticeMissing then
				Slot.Gradation.Texture:SetVertexColor(1, 0, 0)
				Slot.Gradation.Texture:Show()
			else
				Slot.Gradation.Texture:SetVertexColor(T.unpack(E.db.sle.Armory.Inspect.Gradation.Color))
			end
			Slot:SetBackdropBorderColor(R, G, B)
		end
		
		self.SetItem = E:CopyTable({}, self.CurrentInspectData.SetItem)
	end
	
	if NeedUpdateList then
		self.GearUpdated = NeedUpdateList
		
		return true
	end
	self.GearUpdated = nil
	
	do	--<< Average ItemLevel >>--
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			if SlotName ~= 'ShirtSlot' and SlotName ~= 'TabardSlot' then
				Slot = self[SlotName]
				
				if Slot.ILvL then
					ItemCount = ItemCount + 1
					ItemTotal = ItemTotal + Slot.ILvL
				end
			end
		end
		self.Character.AverageItemLevel:SetText('|c'..RAID_CLASS_COLORS[DataTable.Class].colorStr..STAT_AVERAGE_ITEM_LEVEL..'|r : '..format('%.2f', ItemTotal / ItemCount))
	end
	
	R, G, B = RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b
	
	do	--<< Basic Information >>--
		local Realm = DataTable.Realm and DataTable.Realm ~= Info.MyRealm and DataTable.Realm or ''
		local Title = DataTable.Title and gsub(DataTable.Title, DataTable.Name, '') or ''
		
		self.Title:SetText(Realm..(Realm ~= '' and Title ~= '' and ' / ' or '')..(Title ~= '' and '|cff93daff'..Title or ''))
		self.Guild:SetText(DataTable.guildName and '<|cff2eb7e4'..DataTable.guildName..'|r>  [|cff2eb7e4'..DataTable.guildRankName..'|r]' or '')
	end
	
	do	--<< Information Page Setting >>--
		do	-- Profession
			for i = 1, 2 do
				if DataTable.Profession[i].Name then
					self.Info.Profession:Show()
					self.Info.Profession['Prof'..i].Bar:SetValue(DataTable.Profession[i].Level)
					
					if Info.Armory_Constants.ProfessionList[DataTable.Profession[i].Name] then
						self.Info.Profession['Prof'..i].Name:SetText('|cff77c0ff'..DataTable.Profession[i].Name)
						self.Info.Profession['Prof'..i].Icon:SetTexture(Info.Armory_Constants.ProfessionList[DataTable.Profession[i].Name].Texture)
						self.Info.Profession['Prof'..i].Level:SetText(DataTable.Profession[i].Level)
					else
						self.Info.Profession['Prof'..i].Name:SetText('|cff808080'..DataTable.Profession[i].Name)
						self.Info.Profession['Prof'..i].Icon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
						self.Info.Profession['Prof'..i].Level:SetText(nil)
					end
				else
					self.Info.Profession:Hide()
					break
				end
			end
		end
		
		do	-- Guild
			if DataTable.guildName and DataTable.guildPoint and DataTable.guildNumMembers then
				self.Info.Guild:Show()
				self.Info.Guild.Banner.Name:SetText('|cff2eb7e4'..DataTable.guildName)
				self.Info.Guild.Banner.LevelMembers:SetText('|cff77c0ff'..DataTable.guildPoint..'|r Points'..(DataTable.guildNumMembers > 0 and ' / '..format(INSPECT_GUILD_NUM_MEMBERS:gsub('%%d', '%%s'), '|cff77c0ff'..DataTable.guildNumMembers..'|r ') or ''))
				SetSmallGuildTabardTextures('player', self.Info.Guild.Emblem, self.Info.Guild.BG, self.Info.Guild.Border, DataTable.guildEmblem)
			else
				self.Info.Guild:Hide()
			end
		end
		
		self:ReArrangeCategory()
	end
	
	do	--<< Model and Frame Setting When InspectUnit Changed >>--
		if self.NeedModelSetting then
			self.Model:ClearAllPoints()
			self.Model:Point('TOPLEFT', self.HeadSlot)
			self.Model:Point('TOPRIGHT', self.HandsSlot)
			self.Model:Point('BOTTOM', self.BP, 'TOP', 0, SPACING)
			
			if DataTable.UnitID and UnitIsVisible(DataTable.UnitID) then
				self.Model:SetUnit(DataTable.UnitID)
				
				self.Character.Message = nil
			else
				self.Model:SetUnit('player')
				self.Model:SetCustomRace(self.ModelList[DataTable.RaceID].RaceID, DataTable.GenderID - 2)
				self.Model:TryOn(HeadSlotItem)
				self.Model:TryOn(BackSlotItem)
				self.Model:Undress()
				
			for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
				if T.type(DataTable.Gear[SlotName].Transmogrify) == 'number' then
						self.Model:TryOn(DataTable.Gear[SlotName].Transmogrify)
					elseif DataTable.Gear[SlotName].ItemLink and not (DataTable.Gear[SlotName].Transmogrify and DataTable.Gear[SlotName].Transmogrify == 'NotDisplayed') then
						self.Model:TryOn(DataTable.Gear[SlotName].ItemLink)
					else
						self.Model:UndressSlot(self[SlotName].ID)
					end
				end
				
				self.Character.Message = L['Character model may differ because it was constructed by the inspect data.']
			end
			
			self.NeedModelSetting = nil
		end
		
		if not (self.LastDataSetting and self.LastDataSetting == DataTable.Name..(DataTable.Realm and '-'..DataTable.Realm or '')) then
			--<< Initialize Inspect Page >>--
			self.Name:SetText('|c'..RAID_CLASS_COLORS[DataTable.Class].colorStr..DataTable.Name)
			self.LevelRace:SetText(format('|cff%02x%02x%02x%s|r '..LEVEL..'|n%s', GetQuestDifficultyColor(DataTable.Level).r * 255, GetQuestDifficultyColor(DataTable.Level).g * 255, GetQuestDifficultyColor(DataTable.Level).b * 255, DataTable.Level, DataTable.Race))
			self.ClassIcon:SetTexture('Interface\\ICONS\\ClassIcon_'..DataTable.Class)
			
			self.Model:SetPosition(-0.5, self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].x or 0, self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].y or 0)
			self.Model:SetFacing(self.ModelList[DataTable.RaceID][DataTable.GenderID] and self.ModelList[DataTable.RaceID][DataTable.GenderID].r or -5.9)
			self.Model:SetPortraitZoom(1)
			self.Model:SetPortraitZoom(0)
			
			self:ChangePage('CharacterButton')
			
			do --<< Color Setting >>--
				self.ClassIconSlot:SetBackdropBorderColor(R, G, B)
				self.SpecIconSlot:SetBackdropBorderColor(R, G, B)
				
				self.Info.BG:SetBackdropBorderColor(R, G, B)
				
				self.Info.Profession.IconSlot:SetBackdropBorderColor(R, G, B)
				self.Info.Profession.Tab:SetBackdropColor(R, G, B, .3)
				self.Info.Profession.Tab:SetBackdropBorderColor(R, G, B)
				self.Info.Profession.Prof1.Bar:SetStatusBarColor(R, G, B)
				self.Info.Profession.Prof2.Bar:SetStatusBarColor(R, G, B)
				
				self.Info.Guild.IconSlot:SetBackdropBorderColor(R, G, B)
				self.Info.Guild.Tab:SetBackdropColor(R, G, B, .3)
				self.Info.Guild.Tab:SetBackdropBorderColor(R, G, B)
				
				self.Info.PvP.IconSlot:SetBackdropBorderColor(R, G, B)
				self.Info.PvP.Tab:SetBackdropColor(R, G, B, .3)
				self.Info.PvP.Tab:SetBackdropBorderColor(R, G, B)
				
				self.Spec.BottomBorder:SetColorTexture(R, G, B)
				self.Spec.LeftBorder:SetColorTexture(R, G, B)
				self.Spec.RightBorder:SetColorTexture(R, G, B)
			end
			
			self:ToggleSpecializationTab(DataTable.Specialization.SpecTab or 1, DataTable)
		elseif not (self.LastSpecTab and self.LastSpecTab == (DataTable.Specialization.SpecTab or 1)) then
			self:ToggleSpecializationTab(DataTable.Specialization.SpecTab or 1, DataTable)
		end
	end
	
	self.LastDataSetting = DataTable.Name..(DataTable.Realm and '-'..DataTable.Realm or '')
	
	self:Update_Display(true)
end


function IA:InspectFrame_PvPSetting(DataTable)
	local Arg1, Arg2, Arg3
	local NeedExpand = 0
	
	for i, Type in pairs({ '2vs2', '3vs3', 'RB' }) do
		if DataTable.PvP[Type] and DataTable.PvP[Type][2] > 0 then
			--Arg1 = i == 1 and 2000 or i == 2 and 1750 or 1550
			Arg1 = DataTable.PvP[Type][1] or 0	-- Rating
			Arg2 = DataTable.PvP[Type][2] or 0	-- Played
			Arg3 = DataTable.PvP[Type][3] or 0	-- Won
			
			if Arg1 >= 2000 then
				Arg1 = '|cffffe65a'..Arg1
				self.Info.PvP[Type].Rank:Show()
				self.Info.PvP[Type].Rank:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].Rank:SetBlendMode('ADD')
				self.Info.PvP[Type].Rank:SetVertexColor(1, 1, 1)
				self.Info.PvP[Type].RankGlow:Show()
				self.Info.PvP[Type].RankGlow:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].RankNoLeaf:Hide()
			elseif Arg1 >= 1750 then
				self.Info.PvP[Type].Rank:Show()
				self.Info.PvP[Type].Rank:SetTexCoord(.5, 1, 0, .5)
				self.Info.PvP[Type].Rank:SetBlendMode('ADD')
				self.Info.PvP[Type].Rank:SetVertexColor(1, 1, 1)
				self.Info.PvP[Type].RankGlow:Show()
				self.Info.PvP[Type].RankGlow:SetTexCoord(.5, 1, 0, .5)
				self.Info.PvP[Type].RankNoLeaf:Hide()
			elseif Arg1 >= 1550 then
				Arg1 = '|cffc17611'..Arg1
				self.Info.PvP[Type].Rank:Show()
				self.Info.PvP[Type].Rank:SetTexCoord(0, .5, 0, .5)
				self.Info.PvP[Type].Rank:SetBlendMode('BLEND')
				self.Info.PvP[Type].Rank:SetVertexColor(.6, .5, 0)
				self.Info.PvP[Type].RankGlow:Hide()
				self.Info.PvP[Type].RankNoLeaf:Hide()
			else
				Arg1 = '|cff2eb7e4'..Arg1
				self.Info.PvP[Type].Rank:Hide()
				self.Info.PvP[Type].RankGlow:Hide()
				self.Info.PvP[Type].RankNoLeaf:Show()
			end
			
			self.Info.PvP[Type].Rating:SetText(Arg1)
			self.Info.PvP[Type].Record:SetText('|cff77c0ff'..Arg3..'|r / |cffB24C4C'..(Arg2 - Arg3))
			
			NeedExpand = NeedExpand < 182 and 182 or NeedExpand
		else
			self.Info.PvP[Type].Rank:Hide()
			self.Info.PvP[Type].RankGlow:Hide()
			self.Info.PvP[Type].RankNoLeaf:Hide()
			
			self.Info.PvP[Type].Rating:SetText('|cff8080800')
			self.Info.PvP[Type].Record:SetText(nil)
			
			NeedExpand = NeedExpand < 164 and 164 or NeedExpand
		end
	end
	
	-- Arg1 : Prestige Texture
	-- Arg2 : Prestige Name
	
	if DataTable.PrestigeLevel > 0 then
		Arg1, Arg2 = GetPrestigeInfo(DataTable.PrestigeLevel)
		
		self.Info.PvP.Mark.Icon:SetTexture(Arg1)
		Arg2 = '* '..KF:Color_Class(DataTable.Class, Arg2)..'|n'
	else
		SetPortraitToTexture(self.Info.PvP.Mark.Icon, 'Interface\\Icons\\achievement_bg_killxenemies_generalsroom')
		Arg2 = ''
	end
	
	Arg2 = Arg2..'* '..format(Info.Armory_Constants.HonorLevel, KF:Color_Class(DataTable.Class, DataTable.HonorLevel))..'|n* '..SCORE_HONORABLE_KILLS..' : '..KF:Color_Class(DataTable.Class, DataTable.PvP.Honor)
	
	self.Info.PvP.Mark.text:SetText(Arg2)
	
	self.Info.PvP.CategoryHeight = NeedExpand > 0 and NeedExpand or INFO_TAB_SIZE + SPACING * 2
	self:ReArrangeCategory()
end


function IA:ReArrangeCategory()
	local InfoPage_Height = 0
	local PrevCategory
	
	for _, CategoryType in T.pairs(self.InfoPageCategoryList) do
		if self.Info[CategoryType]:IsShown() then
			if self.Info[CategoryType].Closed then
				self.Info[CategoryType].Page:Hide()
				InfoPage_Height = InfoPage_Height + INFO_TAB_SIZE + SPACING * 2
				self.Info[CategoryType]:Height(INFO_TAB_SIZE + SPACING * 2)
			else
				self.Info[CategoryType].Page:Show()
				InfoPage_Height = InfoPage_Height + self.Info[CategoryType].CategoryHeight
				self.Info[CategoryType]:Height(self.Info[CategoryType].CategoryHeight)
			end
			
			if PrevCategory then
				InfoPage_Height = InfoPage_Height + SPACING * 2
				self.Info[CategoryType]:Point('TOP', PrevCategory, 'BOTTOM', 0, -SPACING * 2)
			else
				self.Info[CategoryType]:Point('TOP', self.Info.Page)
			end
			
			PrevCategory = self.Info[CategoryType]
		end
	end
	
	self.Info.Page:Height(InfoPage_Height)
	self.ScrollFrame_OnMouseWheel(self.Info, 0)
end


function IA:ToggleSpecializationTab(Tab, DataTable)
	local Name, Arg1, Arg2, R, G, B
	local LevelTable = CLASS_TALENT_LEVELS[DataTable.Class] or CLASS_TALENT_LEVELS.DEFAULT
	
	self.Spec.Message = nil
	
	for i in pairs(IA.Default_CurrentInspectData.Specialization) do
		if i == 1 then	-- Current Spec
			if DataTable.Specialization[1].SpecializationID and DataTable.Specialization[1].SpecializationID ~= 0 then
				_, Name, _, _, _, Arg1 = GetSpecializationInfoByID(DataTable.Specialization[1].SpecializationID)
				
				if Name then
					if Info.ClassRole[DataTable.Class][Name] then
						Name = (i == Tab and Info.ClassRole[DataTable.Class][Name].Color or '')..Name..'|n'
						
						if Arg1 == 'TANK' then
							Name = Name..'|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:16:16:-3:0|t'..(i == Tab and '|cffffffff' or '').._G[Arg1]
						elseif Arg1 == 'HEALER' then
							Name = Name..'|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:16:16:-3:-1|t'..(i == Tab and '|cffffffff' or '').._G[Arg1]
						else
							Name = Name..'|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:16:16:-2:-1|t'..(i == Tab and '|cffffffff' or '').._G[Arg1]
						end
					else
						self.Spec.Message = L['Specialization data seems to be crashed. Please inspect again.']
					end
				end
			end
			
			if not Name then
				Name = L['No Specialization']
			end
		elseif i == 2 then	-- PvP Talent
			Name = PVP_TALENTS..'|n'..format(Info.Armory_Constants.HonorLevel, i == Tab and KF:Color_Class(DataTable.Class, DataTable.HonorLevel) or DataTable.HonorLevel)
		end
		
		if i == Tab then
			R, G, B = RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b
			
			self.Spec['Spec'..i].BottomLeftBorder:Show()
			self.Spec['Spec'..i].BottomRightBorder:Show()
			self.Spec['Spec'..i]:SetFrameLevel(CORE_FRAME_LEVEL + 13)
			self.Spec['Spec'..i].text:SetText(Name)
			self.Spec['Spec'..i].text:Point('BOTTOMRIGHT', 0, -6)
			self.Spec['Spec'..i].Texture:SetDesaturated(false)
		else
			R, G, B = .4, .4, .4
			
			self.Spec['Spec'..i].BottomLeftBorder:Hide()
			self.Spec['Spec'..i].BottomRightBorder:Hide()
			self.Spec['Spec'..i]:SetFrameLevel(CORE_FRAME_LEVEL + 12)
			self.Spec['Spec'..i].text:SetText('|cff808080'..Name)
			self.Spec['Spec'..i].text:Point('BOTTOMRIGHT', 0, 2)
			self.Spec['Spec'..i].Texture:SetDesaturated(true)
		end
		
		self.Spec['Spec'..i].TopBorder:SetColorTexture(R, G, B)
		self.Spec['Spec'..i].LeftBorder:SetColorTexture(R, G, B)
		self.Spec['Spec'..i].RightBorder:SetColorTexture(R, G, B)
		self.Spec['Spec'..i].BottomLeftBorder:SetColorTexture(R, G, B)
		self.Spec['Spec'..i].BottomRightBorder:SetColorTexture(R, G, B)
		self.Spec['Spec'..i].Icon:SetBackdropBorderColor(R, G, B)
	end
	
	R, G, B = RAID_CLASS_COLORS[DataTable.Class].r, RAID_CLASS_COLORS[DataTable.Class].g, RAID_CLASS_COLORS[DataTable.Class].b
	
	if Tab == 1 then	-- Current Spec
		for i = 1, MAX_TALENT_TIERS do
			for k = 1, NUM_TALENT_COLUMNS do
				Arg1, Name, Arg2 = GetTalentInfoByID(DataTable.Specialization[Tab]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)][1], 1)
				
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetTexture(Arg2)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetText(Name)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip.Link = GetTalentLink(Arg1)
				self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip.Message = nil
				
				if DataTable.Specialization[Tab]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)][2] == true then
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropColor(R, G, B, .3)
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropBorderColor(R, G, B)
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:SetBackdropBorderColor(R, G, B)
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetDesaturated(false)
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetTextColor(1, 1, 1)
				else
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropColor(.1, .1, .1)
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)]:SetBackdropBorderColor(0, 0, 0)
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon:SetBackdropBorderColor(0, 0, 0)
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Icon.Texture:SetDesaturated(true)
					
					if DataTable.Level < LevelTable[i] then
						self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetTextColor(.7, .3, .3)
						self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip.Message = '|cffff0000'..UNLOCKED_AT_LEVEL:format(LevelTable[i])
					else
						self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].text:SetTextColor(.5, .5, .5)
					end
				end
			end
			
			self.Spec['TalentTier'..i]:Point('TOP', self.Spec['TalentTier'..(i - 1)], 'BOTTOM', 0, -SPACING-2)
			self.Spec['TalentTier'..i]:Show()
		end
		
		self.Spec.TalentTier1:Point('TOP', self.Spec.Page, 0, -2)
	elseif Tab == 2 then	-- PvP Talents
		for i = 1, MAX_PVP_TALENT_TIERS do
			for k = 1, MAX_PVP_TALENT_COLUMNS do
				if self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)] then
					Arg1, Name, Arg2 = GetPvpTalentInfoByID(DataTable.Specialization[Tab]['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)][1], 1)
					
					self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].Icon.Texture:SetTexture(Arg2)
					self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].text:SetText(Name)
					self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].Tooltip.Link = GetPvpTalentLink(Arg1)
					self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip.Message = nil
					
					if DataTable.Specialization[Tab]['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)][2] == true then
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)]:SetBackdropColor(R, G, B, .3)
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)]:SetBackdropBorderColor(R, G, B)
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].Icon:SetBackdropBorderColor(R, G, B)
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].Icon.Texture:SetDesaturated(false)
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].text:SetTextColor(1, 1, 1)
					else
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)]:SetBackdropColor(.1, .1, .1)
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)]:SetBackdropBorderColor(0, 0, 0)
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].Icon:SetBackdropBorderColor(0, 0, 0)
						self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].Icon.Texture:SetDesaturated(true)
						
						if DataTable.Level < MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_LEVEL_CURRENT] or DataTable.HonorLevel < Info.Armory_Constants.PvPTalentRequireLevel[(i - 1) * MAX_PVP_TALENT_COLUMNS + k] then
							self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].text:SetTextColor(.7, .3, .3)
							self.Spec['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)].Tooltip.Message = '|cffff0000'..UNLOCKED_AT_HONOR_LEVEL:format(Info.Armory_Constants.PvPTalentRequireLevel[(i - 1) * MAX_PVP_TALENT_COLUMNS + k])
						else
							self.Spec['Talent'..((i - 1) * MAX_PVP_TALENT_COLUMNS + k)].text:SetTextColor(.5, .5, .5)
						end
					end
				end
			end
			
			self.Spec['TalentTier'..i]:Point('TOP', self.Spec['TalentTier'..(i - 1)], 'BOTTOM', 0, -SPACING-7)
			
			if DataTable.Level < MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_LEVEL_CURRENT] then
				self.Spec.Message = format(L['PvP talents become available at level %s.'], E:RGBToHex(1, .5, .5)..'110|r')
				IA:ChangePage('SpecButton')
			end
		end
		
		if MAX_TALENT_TIERS > MAX_PVP_TALENT_TIERS then
			for i = MAX_PVP_TALENT_TIERS + 1, MAX_TALENT_TIERS do
				self.Spec['TalentTier'..i]:Hide()
			end
		end
		
		self.Spec.TalentTier1:Point('TOP', self.Spec.Page, 0, -7)
	end
	
	self:DisplayMessage('Spec')
	self.LastSpecTab = Tab
end


function IA:Update_BG()
	if E.db.sle.Armory.Inspect.Backdrop.SelectedBG == 'HIDE' then
		self.BG:SetTexture(nil)
	elseif E.db.sle.Armory.Inspect.Backdrop.SelectedBG == 'CUSTOM' then
		self.BG:SetTexture(E.db.sle.Armory.Inspect.Backdrop.CustomAddress)
	else
		self.BG:SetTexture(Info.Armory_Constants.BlizzardBackdropList[E.db.sle.Armory.Inspect.Backdrop.SelectedBG] or 'Interface\\AddOns\\ElvUI_SLE\\modules\\Armory\\Media\\Textures\\'..E.db.sle.Armory.Inspect.Backdrop.SelectedBG)
	end
end


function IA:Update_Display(Force)
	local Slot, Mouseover, SocketVisible
	
	if (self:IsMouseOver() and (E.db.sle.Armory.Inspect.Level.Display == 'MouseoverOnly' or E.db.sle.Armory.Inspect.Enchant.Display == 'MouseoverOnly' or E.db.sle.Armory.Inspect.Gem.Display == 'MouseoverOnly')) or Force then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			Slot = self[SlotName]
			Mouseover = Slot.Gradation:IsMouseOver()
			
			if Slot.Gradation.ItemLevel then
				if E.db.sle.Armory.Inspect.Level.Display == 'Always' or Mouseover and E.db.sle.Armory.Inspect.Level.Display == 'MouseoverOnly' then
					Slot.Gradation.ItemLevel:Show()
				else
					Slot.Gradation.ItemLevel:Hide()
				end
			end
			
			if Slot.Gradation.ItemEnchant then
				if E.db.sle.Armory.Inspect.Enchant.Display == 'Always' or Mouseover and E.db.sle.Armory.Inspect.Enchant.Display == 'MouseoverOnly' then
					Slot.Gradation.ItemEnchant:Show()
				elseif E.db.sle.Armory.Inspect.Enchant.Display ~= 'Always' and not (E.db.sle.Armory.Inspect.NoticeMissing and not Slot.IsEnchanted) then
					Slot.Gradation.ItemEnchant:Hide()
				end
			end
			
			SocketVisible = nil
			
			if Slot.Socket1 then
				for i = 1, MAX_NUM_SOCKETS do
					if E.db.sle.Armory.Inspect.Gem.Display == 'Always' or Mouseover and E.db.sle.Armory.Inspect.Gem.Display == 'MouseoverOnly' then
						if Slot['Socket'..i].GemType then
							Slot['Socket'..i]:Show()
						end
					else
						if SocketVisible == nil then
							SocketVisible = false
						end
						
						if Slot["Socket"..i].GemType and E.db.sle.Armory.Inspect.NoticeMissing and not Slot["Socket"..i].GemItemID then
							SocketVisible = true
						end
					end
				end
				
				if SocketVisible then
					for i = 1, MAX_NUM_SOCKETS do
						if Slot['Socket'..i].GemType then
							Slot['Socket'..i]:Show()
							Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
						end
					end
				elseif SocketVisible == false then
					for i = 1, MAX_NUM_SOCKETS do
						Slot['Socket'..i]:Hide()
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

function IA:UpdateSettings(part)
	local db = E.db.sle.Armory.Inspect
	if not db.Enable then return end
	if db.Enable and _G["InspectArmory"].CreateInspectFrame then _G["InspectArmory"]:CreateInspectFrame() end
	if part == "ilvl" or part == "all" then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			if _G["InspectArmory"][SlotName] and _G["InspectArmory"][SlotName].Gradation and _G["InspectArmory"][SlotName].Gradation.ItemLevel then
				_G["InspectArmory"][SlotName].Gradation.ItemLevel:FontTemplate(E.LSM:Fetch('font', db.Level.Font),db.Level.FontSize,db.Level.FontStyle)
			end
		end
	end
	if part == "ench" or part == "all" then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			if _G["InspectArmory"][SlotName] and _G["InspectArmory"][SlotName].Gradation and _G["InspectArmory"][SlotName].Gradation.ItemEnchant then
				_G["InspectArmory"][SlotName].Gradation.ItemEnchant:FontTemplate(E.LSM:Fetch('font', db.Enchant.Font),db.Enchant.FontSize,db.Enchant.FontStyle)
			end
			if _G["InspectArmory"][SlotName] and _G["InspectArmory"][SlotName].EnchantWarning then
				_G["InspectArmory"][SlotName].EnchantWarning:Size(db.Enchant.WarningSize)
			end
		end
	end
	if part == "gem" or part == "all" then
		for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
			for i = 1, MAX_NUM_SOCKETS do
				if _G["InspectArmory"][SlotName] and _G["InspectArmory"][SlotName]["Socket"..i] then
					_G["InspectArmory"][SlotName]["Socket"..i]:Size(db.Gem.SocketSize)
				else
					break
				end
			end
			for _, SlotName in T.pairs(Info.Armory_Constants.GearList) do
				if _G["InspectArmory"][SlotName] and _G["InspectArmory"][SlotName].SocketWarning then
					_G["InspectArmory"][SlotName].SocketWarning:Size(db.Gem.WarningSize)
				end
			end
		end
	end
end

KF.Modules[#KF.Modules + 1] = 'InspectArmory'
KF.Modules.InspectArmory = function()
	if E.db.sle.Armory.Inspect.Enable ~= false and not Info.InspectArmory_Activate then
		--Default_NotifyInspect = NotifyInspect
		Default_InspectUnit = InspectUnit
		Default_InspectFrame = _G.InspectFrame
		
		if IA.CreateInspectFrame then
			IA:CreateInspectFrame()
		end
		IA:Update_BG()
		
		InspectUnit = IA.InspectUnit
		InspectFrame = IA.Inspector
		
		Info.InspectArmory_Activate = true
	elseif Info.InspectArmory_Activate then
		InspectUnit = Default_InspectUnit
		InspectFrame = Default_InspectFrame
		
		Info.InspectArmory_Activate = nil
	end
end