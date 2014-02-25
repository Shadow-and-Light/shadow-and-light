local E, L, V, P, G, _  = unpack(ElvUI)

-- Constants
SLArmoryConstants = {
	['ItemLevelKey'] = ITEM_LEVEL:gsub('%%d', '(.+)'),
	['ItemLevelKey_Alt'] = ITEM_LEVEL_ALT:gsub('%%d', '.+'):gsub('%(.+%)', '%%((.+)%%)'),
	['EnchantKey'] = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)'),
	['ItemSetBonusKey'] = ITEM_SET_BONUS:gsub('%%s', '(.+)'),
	['TransmogrifiedKey'] = TRANSMOGRIFIED:gsub('%%s', '(.+)'),
	
	['GearList'] = {
		'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
		'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
	},
	
	['EnchantableSlots'] = {
		['ShoulderSlot'] = true, ['BackSlot'] = true, ['ChestSlot'] = true, ['WristSlot'] = true, ['HandsSlot'] = true,
		['LegsSlot'] = true, ['FeetSlot'] = true, ['MainHandSlot'] = true, ['SecondaryHandSlot'] = true
	},
	
	['UpgradeColor'] = {
		[16] = '|cffff9614', [12] = '|cfff88ef4', [8] = '|cff2eb7e4', [4] = '|cffceff00'
	},
	
	['GemColor'] = {
		['RED'] = { 1, .2, .2, }, ['YELLOW'] = { .97, .82, .29, }, ['BLUE'] = { .47, .67, 1, }
	},
	
	['EmptySocketString'] = {
		[EMPTY_SOCKET_BLUE] = true, [EMPTY_SOCKET_COGWHEEL] = true, [EMPTY_SOCKET_HYDRAULIC] = true, [EMPTY_SOCKET_META] = true,
		[EMPTY_SOCKET_NO_COLOR] = true, [EMPTY_SOCKET_PRISMATIC] = true, [EMPTY_SOCKET_RED] = true, [EMPTY_SOCKET_YELLOW] = true
	},
	
	['ItemUpgrade'] = {
		['0'] = 0, ['1'] = 8,
		['373'] = 4, ['374'] = 8, ['375'] = 4, ['376'] = 4, ['377'] = 4, ['379'] = 4, ['380'] = 4,
		['445'] = 0, ['446'] = 4, ['447'] = 8, ['451'] = 0, ['452'] = 8, ['453'] = 0, ['454'] = 4,
		['455'] = 8, ['456'] = 0, ['457'] = 8, ['458'] = 0, ['459'] = 4, ['460'] = 8, ['461'] = 12,
		['462'] = 16, ['465'] = 0, ['466'] = 4, ['467'] = 8, ['468'] = 0, ['469'] = 4, ['470'] = 8,
		['471'] = 12, ['472'] = 16, ['476'] = 0, ['477'] = 4, ['478'] = 8, ['479'] = 0, ['480'] = 8,
		['491'] = 0, ['492'] = 4, ['493'] = 8, ['494'] = 0, ['495'] = 4, ['496'] = 8, ['497'] = 12, ['498'] = 16,
	},
	
	['ItemEnchant_Profession_Inscription'] = {
		['NeedLevel'] = 600,
		['4912'] = true, -- ?? ?? ????			Secret Ox Horn Inscription
		['4913'] = true, -- ?? ??? ????		Secret Crane Wing Inscription
		['4914'] = true, -- ?? ??? ?? ????	Secret Tiger Claw Inscription
		['4915'] = true, -- ?? ??? ??? ????	Secret Tiger Fang Inscription
	},
	
	['ItemEnchant_Profession_LeatherWorking'] = {
		['NeedLevel'] = 575,
		['4875'] = true, -- ?? ?? - ?				Fur Lining - Strength
		['4877'] = true, -- ?? ?? - ??			Fur Lining - Intellect
		['4878'] = true, -- ?? ?? - ??			Fur Lining - Stamina
		['4879'] = true, -- ?? ?? - ???			Fur Lining - Agility
	},
	
	['ItemEnchant_Profession_Tailoring'] = {
		['NeedLevel'] = 550,
		['4892'] = true, -- ??? ??					Lightweave Embroidery
		['4893'] = true, -- ??? ??					Darkglow Embroidery
		['4894'] = true, -- ?? ??					Swordguard Embroidery
	},
	
	['ProfessionList'] = {
		[GetSpellInfo(110396)] = 'BlackSmithing',
		[GetSpellInfo(110400)] = 'Enchanting',
		[GetSpellInfo(110403)] = 'Engineering',
		[GetSpellInfo(110417)] = 'Inscription',
		[GetSpellInfo(110420)] = 'JewelCrafting',
		[GetSpellInfo(110423)] = 'LeatherWorking',
		[GetSpellInfo(110426)] = 'Tailoring'
	},
	
	['CommonScript'] = {
		['OnEnter'] = function(self)
			if self.Link or self.Message then
				GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

				self:SetScript('OnUpdate', function()
					GameTooltip:ClearLines()

					if self.Link then
						GameTooltip:SetHyperlink(self.Link)
					end

					if self.Link and self.Message then GameTooltip:AddLine(' ') end -- Line space

					if self.Message then
						GameTooltip:AddLine(self.Message, 1, 1, 1)
					end

					GameTooltip:Show()
				end)
			end
		end,
		['OnLeave'] = function(self)
			self:SetScript('OnUpdate', nil)
			GameTooltip:Hide()
		end,
		['GemSocket_OnEnter'] = function(self)
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

			self = self:GetParent()

			if self.GemItemID then
				if type(self.GemItemID) == 'number' then
					GameTooltip:SetHyperlink(select(2, GetItemInfo(self.GemItemID)))
				else
					GameTooltip:ClearLines()
					GameTooltip:AddLine(self.GemItemID)
				end
			elseif self.GemType then
				GameTooltip:ClearLines()
				GameTooltip:AddLine(_G['EMPTY_SOCKET_'..self.GemType])
			end

			GameTooltip:Show()
		end
	},

	['Toolkit'] = {
		['Color_Value'] = function(InputText)
			return E:RGBToHex(E.media.rgbvaluecolor[1], E.media.rgbvaluecolor[2], E.media.rgbvaluecolor[3])..(InputText and InputText..'|r' or '')
		end,

		['Color_Class'] = function(Class, InputText)
			return (Class and '|c'..RAID_CLASS_COLORS[Class].colorStr or '')..(InputText and InputText..'|r' or '')
		end,

		['TextSetting'] = function(self, Text, Style, ...)
			if Style and Style.Tag then
				if not self[Style.Tag] then
					self[Style.Tag] = self:CreateFontString(nil, 'OVERLAY')
				end

				self = self[Style.Tag]
			else
				if not Style then
					Style = {}
				end
				
				if not self.text then
					self.text = self:CreateFontString(nil, 'OVERLAY')
				end
				
				self = self.text
			end
			
			self:FontTemplate(Style.Font and LibStub('LibSharedMedia-3.0'):Fetch('font', Style.Font), Style.FontSize, Style.FontOutline)
			self:SetJustifyH(Style.directionH or 'CENTER')
			self:SetJustifyV(Style.directionV or 'MIDDLE')
			self:SetText(Text)
			
			if ... then
				self:Point(...)
			else
				self:SetInside()
			end
		end,

		['CreateWidget_CheckButton'] = function(buttonName, buttonText, heightSize, fontInfo)
			if not _G[buttonName] then
				heightSize = heightSize or 24
				fontInfo = fontInfo or { ['FontStyle'] = 'OUTLINE', ['directionH'] = 'LEFT', }

				CreateFrame('Button', buttonName, E.UIParent)
				_G[buttonName]:SetHeight(heightSize)
				_G[buttonName]:EnableMouse(true)

				_G[buttonName].CheckButtonBG = CreateFrame('Frame', nil, _G[buttonName])
				_G[buttonName].CheckButtonBG:SetTemplate('Default', true)
				_G[buttonName].CheckButtonBG:Size(heightSize - 8)
				_G[buttonName].CheckButtonBG:SetPoint('LEFT')

				_G[buttonName].CheckButton = _G[buttonName].CheckButtonBG:CreateTexture(nil, 'OVERLAY')
				_G[buttonName].CheckButton:Size(heightSize)
				_G[buttonName].CheckButton:Point('CENTER', _G[buttonName].CheckButtonBG)
				_G[buttonName].CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')

				SLArmoryConstants.Toolkit.TextSetting(_G[buttonName], buttonText, fontInfo, 'LEFT', _G[buttonName].CheckButtonBG, 'RIGHT', 6, 0)

				_G[buttonName].hover = _G[buttonName]:CreateTexture(nil, 'HIGHLIGHT')
				_G[buttonName].hover:SetTexture('Interface\\Buttons\\UI-CheckBox-Highlight')
				_G[buttonName].hover:SetBlendMode('ADD')
				_G[buttonName].hover:SetAllPoints(_G[buttonName].CheckButtonBG)

				_G[buttonName]:SetHighlightTexture(_G[buttonName].hover)
				_G[buttonName]:SetWidth(_G[buttonName].text:GetWidth() + heightSize + 2)
				_G[buttonName]:SetScript('OnMouseDown', function(self) self.text:Point('LEFT', self.CheckButtonBG, 'RIGHT', 6, -2) end)
				_G[buttonName]:SetScript('OnMouseUp', function(self) self.text:Point('LEFT', self.CheckButtonBG, 'RIGHT', 6, 0) end)

				return _G[buttonName]
			end
		end,
	},
}
