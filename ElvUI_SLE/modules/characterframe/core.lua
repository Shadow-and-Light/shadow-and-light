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
	
	['ProfessionList'] = {},
	
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

--Get Profession Information
local ProfessionName, ProfessionTexture
for ProfessionSkillID, Key in pairs({
	[105206] = 'Alchemy',
	[110396] = 'BlackSmithing',
	[110400] = 'Enchanting',
	[110403] = 'Engineering',
	[110417] = 'Inscription',
	[110420] = 'JewelCrafting',
	[110423] = 'LeatherWorking',
	[110426] = 'Tailoring',

	[110413] = 'Herbalism',
	[102161] = 'Mining',
	[102216] = 'Skinning'
})
do
	ProfessionName, _, ProfessionTexture = GetSpellInfo(ProfessionSkillID)

	SLArmoryConstants.ProfessionList[ProfessionName] = {
		['Key'] = Key,
		['Texture'] = ProfessionTexture
	}
end

--Colorize Class Name and localize specialization name
local ClassName = {}
FillLocalizedClassList(ClassName)

L['Warrior'] = SLArmoryConstants.Toolkit.Color_Class('WARRIOR', ClassName['WARRIOR'])
_, L['Spec_Warrior_Arms'] = GetSpecializationInfoByID(71)
_, L['Spec_Warrior_Fury'] = GetSpecializationInfoByID(72)
_, L['Spec_Warrior_Protection'] = GetSpecializationInfoByID(73)

L['Hunter'] = SLArmoryConstants.Toolkit.Color_Class('HUNTER', ClassName['HUNTER'])
_, L['Spec_Hunter_Beast'] = GetSpecializationInfoByID(253)
_, L['Spec_Hunter_Marksmanship'] = GetSpecializationInfoByID(254)
_, L['Spec_Hunter_Survival'] = GetSpecializationInfoByID(255)

L['Shaman'] = SLArmoryConstants.Toolkit.Color_Class('SHAMAN', ClassName['SHAMAN'])
_, L['Spec_Shaman_Elemental'] = GetSpecializationInfoByID(262)
_, L['Spec_Shaman_Enhancement'] = GetSpecializationInfoByID(263)
_, L['Spec_Shaman_Restoration'] = GetSpecializationInfoByID(264)

L['Monk'] = SLArmoryConstants.Toolkit.Color_Class('MONK', ClassName['MONK'])
_, L['Spec_Monk_Brewmaster'] = GetSpecializationInfoByID(268)
_, L['Spec_Monk_Mistweaver'] = GetSpecializationInfoByID(270)
_, L['Spec_Monk_Windwalker'] = GetSpecializationInfoByID(269)

L['Rogue'] = SLArmoryConstants.Toolkit.Color_Class('ROGUE', ClassName['ROGUE'])
_, L['Spec_Rogue_Assassination'] = GetSpecializationInfoByID(259)
_, L['Spec_Rogue_Combat'] = GetSpecializationInfoByID(260)
_, L['Spec_Rogue_Subtlety'] = GetSpecializationInfoByID(261)

L['DeathKnight'] = SLArmoryConstants.Toolkit.Color_Class('DEATHKNIGHT', ClassName['DEATHKNIGHT'])
_, L['Spec_DeathKnight_Blood'] = GetSpecializationInfoByID(250)
_, L['Spec_DeathKnight_Frost'] = GetSpecializationInfoByID(251)
_, L['Spec_DeathKnight_Unholy'] = GetSpecializationInfoByID(252)

L['Mage'] = SLArmoryConstants.Toolkit.Color_Class('MAGE', ClassName['MAGE'])
_, L['Spec_Mage_Arcane'] = GetSpecializationInfoByID(62)
_, L['Spec_Mage_Fire'] = GetSpecializationInfoByID(63)
_, L['Spec_Mage_Frost'] = GetSpecializationInfoByID(64)

L['Druid'] = SLArmoryConstants.Toolkit.Color_Class('DRUID', ClassName['DRUID'])
_, L['Spec_Druid_Balance'] = GetSpecializationInfoByID(102)
_, L['Spec_Druid_Feral'] = GetSpecializationInfoByID(103)
_, L['Spec_Druid_Guardian'] = GetSpecializationInfoByID(104)
_, L['Spec_Druid_Restoration'] = GetSpecializationInfoByID(105)

L['Paladin'] = SLArmoryConstants.Toolkit.Color_Class('PALADIN', ClassName['PALADIN'])
_, L['Spec_Paladin_Holy'] = GetSpecializationInfoByID(65)
_, L['Spec_Paladin_Protection'] = GetSpecializationInfoByID(66)
_, L['Spec_Paladin_Retribution'] = GetSpecializationInfoByID(70)

L['Priest'] = SLArmoryConstants.Toolkit.Color_Class('PRIEST', ClassName['PRIEST'])
_, L['Spec_Priest_Discipline'] = GetSpecializationInfoByID(256)
_, L['Spec_Priest_Holy'] = GetSpecializationInfoByID(257)
_, L['Spec_Priest_Shadow'] = GetSpecializationInfoByID(258)

L['Warlock'] = SLArmoryConstants.Toolkit.Color_Class('WARLOCK', ClassName['WARLOCK'])
_, L['Spec_Warlock_Affliction'] = GetSpecializationInfoByID(265)
_, L['Spec_Warlock_Demonology'] = GetSpecializationInfoByID(266)
_, L['Spec_Warlock_Destruction'] = GetSpecializationInfoByID(267)


SLArmoryConstants['ClassRole'] = {
	['WARRIOR'] = {
		[L['Spec_Warrior_Arms']] = {		--무기
			['Color'] = '|cff9a9a9a',
			['Role'] = 'Melee',
		},
		[L['Spec_Warrior_Fury']] = {		--분노
			['Color'] = '|cffb50000',
			['Role'] = 'Melee',
		},
		[L['Spec_Warrior_Protection']] = {	--방어
			['Color'] = '|cff088fdc',
			['Role'] = 'Tank',
		},
	},
	['HUNTER'] = {
		[L['Spec_Hunter_Beast']] = {		--야수
			['Color'] = '|cffffdb00',
			['Role'] = 'Melee',
		},
		[L['Spec_Hunter_Marksmanship']] = {	--사격
			['Color'] = '|cffea5455',
			['Role'] = 'Melee',
		},
		[L['Spec_Hunter_Survival']] = {		--생존
			['Color'] = '|cffbaf71d',
			['Role'] = 'Melee',
		},
	},
	['SHAMAN'] = {
		[L['Spec_Shaman_Elemental']] = {	--정기
			['Color'] = '|cff2be5fa',
			['Role'] = 'Caster',
		},
		[L['Spec_Shaman_Enhancement']] = {	--고양
			['Color'] = '|cffe60000',
			['Role'] = 'Melee',
		},
		[L['Spec_Shaman_Restoration']] = {	--복원
			['Color'] = '|cff00ff0c',
			['Role'] = 'Healer',
		},
	},
	['MONK'] = {
		[L['Spec_Monk_Brewmaster']] = {		--양조
			['Color'] = '|cffbcae6d',
			['Role'] = 'Tank',
		},
		[L['Spec_Monk_Mistweaver']] = {		--운무
			['Color'] = '|cffb6f1b7',
			['Role'] = 'Healer',
		},
		[L['Spec_Monk_Windwalker']] = {		--풍운
			['Color'] = '|cffb2c6de',
			['Role'] = 'Melee',
		},
	},
	['ROGUE'] = {
		[L['Spec_Rogue_Assassination']] = {	--암살
			['Color'] = '|cff129800',
			['Role'] = 'Melee',
		},
		[L['Spec_Rogue_Combat']] = {		--전투
			['Color'] = '|cffbc0001',
			['Role'] = 'Melee',
		},
		[L['Spec_Rogue_Subtlety']] = {		--잠행
			['Color'] = '|cfff48cba',
			['Role'] = 'Melee',
		},
	},
	['DEATHKNIGHT'] = {
		[L['Spec_DeathKnight_Blood']] = {	--혈기
			['Color'] = '|cffbc0001',
			['Role'] = 'Tank',
		},
		[L['Spec_DeathKnight_Frost']] = {	--냉기
			['Color'] = '|cff1784d1',
			['Role'] = 'Melee',
		},
		[L['Spec_DeathKnight_Unholy']] = {	--부정
			['Color'] = '|cff00ff10',
			['Role'] = 'Melee',
		},
	},
	['MAGE'] = {
		[L['Spec_Mage_Arcane']] = {			--비전
			['Color'] = '|cffdcb0fb',
			['Role'] = 'Caster',
		},
		[L['Spec_Mage_Fire']] = {			--화염
			['Color'] = '|cffff3615',
			['Role'] = 'Caster',
		},
		[L['Spec_Mage_Frost']] = {			--냉기
			['Color'] = '|cff1784d1',
			['Role'] = 'Caster',
		},		
	},
	['DRUID'] = {
		[L['Spec_Druid_Balance']] = {		--조화
			['Color'] = '|cffff7d0a',
			['Role'] = 'Caster',
		},
		[L['Spec_Druid_Feral']] = {			--야성
			['Color'] = '|cffffdb00',
			['Role'] = 'Melee',
		},
		[L['Spec_Druid_Guardian']] = {		--수호
			['Color'] = '|cff088fdc',
			['Role'] = 'Tank',
		},
		[L['Spec_Druid_Restoration']] = {	--회복
			['Color'] = '|cff64df62',
			['Role'] = 'Healer',
		},
	},
	['PALADIN'] = {
		[L['Spec_Paladin_Holy']] = {		--신성
			['Color'] = '|cfff48cba',
			['Role'] = 'Healer',
		},		
		[L['Spec_Paladin_Protection']] = {	--보호
			['Color'] = '|cff84e1ff',
			['Role'] = 'Tank',
		},
		[L['Spec_Paladin_Retribution']] = {	--징벌
			['Color'] = '|cffe60000',
			['Role'] = 'Melee',
		},
	},
	['PRIEST'] = {
		[L['Spec_Priest_Discipline']] = {	--수양
			['Color'] = '|cffffffff',
			['Role'] = 'Healer',
		},
		[L['Spec_Priest_Holy']] = {			--신성
			['Color'] = '|cff6bdaff',
			['Role'] = 'Healer',
		},
		[L['Spec_Priest_Shadow']] = {		--암흑
			['Color'] = '|cff7e52c1',
			['Role'] = 'Caster',
		},
	},
	['WARLOCK'] = {
		[L['Spec_Warlock_Affliction']] = {	--고통
			['Color'] = '|cff00ff10',
			['Role'] = 'Caster',
		},
		[L['Spec_Warlock_Demonology']] = {	--악마
			['Color'] = '|cff9482c9',
			['Role'] = 'Caster',
		},
		[L['Spec_Warlock_Destruction']] = {	--파괴
			['Color'] = '|cffba1706',
			['Role'] = 'Caster',
		},
	},
}