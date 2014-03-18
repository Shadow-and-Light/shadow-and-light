--------------------------------------------------------------------------------
--<< AISM : Surpport Module for Armory Inspecting							>>--
--------------------------------------------------------------------------------
local AISM = _G['Armory_InspectSupportModule']

if not AISM then
	local ItemSetBonusKey = ITEM_SET_BONUS:gsub('%%s', '(.+)')
	local ProfessionLearnKey = ERR_LEARN_ABILITY_S:gsub('%%s', '(.+)')
	local ProfessionLearnKey2 = ERR_LEARN_RECIPE_S:gsub('%%s', '(.+)')
	local ProfessionUnlearnKey = ERR_SPELL_UNLEARNED_S:gsub('%%s', '(.+)')

	local playerName = UnitName('player')
	local playerRealm = GetRealmName()
	local _, playerClass, playerClassID = UnitClass('player')
	local playerRace, playerRaceID = UnitRace('player')
	local playerSex = UnitSex('player')
	local isHelmDisplayed = ShowingHelm() == 1
	local isCloakDisplayed = ShowingCloak() == 1

	--<< Create Core >>--
	AISM = CreateFrame('Frame', 'Armory_InspectSupportModule', UIParent)
	AISM.Version = 1.0
	AISM.Tooltip = CreateFrame('GameTooltip', 'AISM_Tooltip', nil, 'GameTooltipTemplate')
	AISM.Tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	AISM.Updater = CreateFrame('Frame', 'AISM_Updater', UIParent)

	AISM.SendMessageDelay = 2
	AISM.SendDataGroupUpdated = AISM.SendMessageDelay
	AISM.SendDataGuildUpdated = AISM.SendMessageDelay

	AISM.PlayerData = {}
	AISM.PlayerData_ShortString = {}
	AISM.GroupMemberData = {}
	AISM.GuildMemberData = {}
	AISM.CurrentInspectData = {}
	AISM.InspectRegistered = {}
	AISM.RemainMessage = {}
	AISM.RegisteredFunction = {}

	--<< Define Key Table >>--
	AISM.ProfessionList = {
		[GetSpellInfo(105206)] = 'AC', -- Alchemy
		[GetSpellInfo(110396)] = 'BS', -- BlackSmithing
		[GetSpellInfo(110400)] = 'EC', -- Enchanting
		[GetSpellInfo(110403)] = 'EG', -- Engineering
		[GetSpellInfo(110413)] = 'HB', -- Herbalism
		[GetSpellInfo(110417)] = 'IS', -- Inscription
		[GetSpellInfo(110420)] = 'JC', -- JewelCrafting
		[GetSpellInfo(102161)] = 'MN', -- Mining
		[GetSpellInfo(110423)] = 'LW', -- LeatherWorking
		[GetSpellInfo(102216)] = 'SK', -- Skinning
		[GetSpellInfo(110426)] = 'TL', -- Tailoring
	}
	AISM.GearList = {
		['HeadSlot'] = 'HE',
		['NeckSlot'] = 'NK',
		['ShoulderSlot'] = 'SD',
		['BackSlot'] = 'BK',
		['ChestSlot'] = 'CH',
		['ShirtSlot'] = 'ST',
		['TabardSlot'] = 'TB',
		['WristSlot'] = 'WR',
		['HandsSlot'] = 'HD',
		['WaistSlot'] = 'WA',
		['LegsSlot'] = 'LE',
		['FeetSlot'] = 'FE',
		['Finger0Slot'] = 'FG0',
		['Finger1Slot'] = 'FG1',
		['Trinket0Slot'] = 'TR0',
		['Trinket1Slot'] = 'TR1',
		['MainHandSlot'] = 'MH',
		['SecondaryHandSlot'] = 'SH',
	}
	AISM.CanTransmogrifySlot = {
		['HeadSlot'] = true,
		['ShoulderSlot'] = true,
		['BackSlot'] = true,
		['ChestSlot'] = true,
		['WristSlot'] = true,
		['HandsSlot'] = true,
		['WaistSlot'] = true,
		['LegsSlot'] = true,
		['FeetSlot'] = true,
		['MainHandSlot'] = true,
		['SecondaryHandSlot'] = true,
	}
	AISM.DataTypeTable = {
		['PLI'] = 'PlayerInfo',
		['GLD'] = 'GuildInfo',
		['PF1'] = 'Profession',
		['PF2'] = 'Profession',
		['ASP'] = 'ActiveSpec',
		['SID'] = 'SetItemData',
	}

	for groupNum = 1, MAX_TALENT_GROUPS do
		AISM.DataTypeTable['SP'..groupNum] = 'Specialization'
		AISM.DataTypeTable['GL'..groupNum] = 'Glyph'
	end

	for _, keyName in pairs(AISM.GearList) do
		AISM.DataTypeTable[keyName] = 'Gear'
	end

	--<< Player Data Updater Core >>--
	local needUpdate, SystemMessage, isPlayer
	AISM.Updater:SetScript('OnUpdate', function(self)
		AISM.UpdatedData = needUpdate and AISM.UpdatedData or {}
		needUpdate = nil

		if not self.ProfessionUpdated then
			needUpdate = AISM:GetPlayerProfessionSetting() or needUpdate
		end

		if not self.SpecUpdated then
			needUpdate = AISM:GetPlayerSpecSetting() or needUpdate
		end

		if not self.GlyphUpdated then
			needUpdate = AISM:GetPlayerGlyphString() or needUpdate
		end

		if not self.GearUpdated then
			needUpdate = AISM:GetPlayerGearString() or needUpdate
		end

		if not needUpdate then
			self:Hide()

			if self.Initialize then
				for _ in pairs(AISM.UpdatedData) do
					if AISM.CurrentGroupMode and AISM.CurrentGroupMode ~= 'NoGroup' and AISM.CurrentGroupType then
						AISM:SendData(AISM.UpdatedData)
					end
					break
				end
			end
		end
	end)

	AISM.Updater:SetScript('OnEvent', function(self, EventTag, ...)
		if Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			_, SystemMessage, _, _, _, _, _, _, isPlayer = ...

			if SystemMessage == 'ENCHANT_APPLIED' and isPlayer == playerName then
				self.GearUpdated = nil
				self:Show()
			end
		elseif Event == 'UNIT_INVENTORY_CHANGED' then
			isPlayer = ...

			if isPlayer == 'player' then
				self.GearUpdated = nil
				self:Show()
			end
		elseif Event == 'CHAT_MSG_SYSTEM' then
			SystemMessage = ...

			if SystemMessage:find(ProfessionLearnKey) or SystemMessage:find(ProfessionLearnKey2) or SystemMessage:find(ProfessionUnlearnKey) then
				self.ProfessionUpdated = nil
				self:Show()
			end
		elseif Event == 'ACTIVE_TALENT_GROUP_CHANGED' or Event == 'CHARACTER_POINTS_CHANGED' then
			self.SpecUpdated = nil
			self:Show()
		elseif Event == 'GLYPH_ADDED' or Event == 'GLYPH_REMOVED' or Event == 'GLYPH_UPDATED' then
			self.GlyphUpdated = nil
			self:Show()
		elseif Event == 'SOCKET_INFO_SUCCESS' or Event == 'PLAYER_EQUIPMENT_CHANGED' or Event == 'EQUIPMENT_SWAP_FINISHED' or Event == 'ITEM_UPGRADE_MASTER_UPDATE' or Event == 'TRANSMOGRIFY_UPDATE' then
			self.GearUpdated = nil
			self:Show()
		end
	end)

	AISM.UpdateHelmDisplaying = function(value)
		isHelmDisplayed = value == '1'
		AISM.Updater.GearUpdated = nil
		AISM.Updater:Show()
	end 
	hooksecurefunc('ShowHelm', AISM.UpdateHelmDisplaying)

	AISM.UpdateCloakDisplaying = function(value)
		isCloakDisplayed = value == '1'
		AISM.Updater.GearUpdated = nil
		AISM.Updater:Show()
	end
	hooksecurefunc('ShowCloak', AISM.UpdateCloakDisplaying)

	--<< Profession String >>--
	function AISM:GetPlayerProfessionSetting()
		local Profession1, Profession2 = GetProfessions()
		local Profession1_Level, Profession2_Level = 0, 0

		if Profession1 then
			Profession1, _, Profession1_Level = GetProfessionInfo(Profession1)

			if self.ProfessionList[Profession1] then
				Profession1 = self.ProfessionList[Profession1]..'/'..Profession1_Level
			else
				Profession1 = 'F'
			end
		end

		if Profession2 then
			Profession2, _, Profession2_Level = GetProfessionInfo(Profession2)

			if self.ProfessionList[Profession2] then
				Profession2 = self.ProfessionList[Profession2]..'/'..Profession2_Level
			else
				Profession2 = 'F'
			end
		end

		if self.PlayerData.Profession1 ~= Profession1 then
			self.PlayerData.Profession1 = Profession1
		end

		if self.PlayerData.Profession2 ~= Profession2 then
			self.PlayerData.Profession2 = Profession2
		end

		self.Updater.ProfessionUpdated = true
	end

	AISM.Updater:RegisterEvent('CHAT_MSG_SYSTEM')

	--<< Specialization String >>--
	function AISM:GetPlayerSpecSetting()
		local DataString, isSelected, selectedSlot
		local ActiveSpec = GetActiveSpecGroup()

		for groupNum = 1, MAX_TALENT_GROUPS do
			DataString = GetSpecialization(nil, nil, groupNum)

			if DataString then
				DataString = GetSpecializationInfo(DataString)
			else
				DataString = '0'
			end

			for i = 1, MAX_NUM_TALENT_TIERS do
				selectedSlot = '0'

				for k = 1, NUM_TALENT_COLUMNS do
					_, _, _, _, isSelected = GetTalentInfo((i - 1) * NUM_TALENT_COLUMNS + k, nil, groupNum)

					if isSelected then
						selectedSlot = k
						break
					end
				end

				DataString = DataString..'/'..selectedSlot
			end

			if self.PlayerData['Spec'..groupNum] ~= DataString then
				self.PlayerData['Spec'..groupNum] = DataString
			end
			
			if groupNum == ActiveSpec and self.PlayerData_ShortString.Spec1 ~= DataString then
				self.PlayerData_ShortString.Spec1 = DataString
				self.UpdatedData.Spec1 = DataString
			end
		end
		
		isSelected = GetActiveSpecGroup()
		
		if self.PlayerData.ActiveSpec ~= ActiveSpec then
			self.PlayerData.ActiveSpec = ActiveSpec
		end
		
		self.Updater.SpecUpdated = true
	end
	AISM.Updater:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	AISM.Updater:RegisterEvent('CHARACTER_POINTS_CHANGED')

	--<< Glyph String >>--
	function AISM:GetPlayerGlyphString()
		local ShortString, FullString
		local ActiveSpec = GetActiveSpecGroup()

		local SpellID, GlyphID
		for groupNum = 1, MAX_TALENT_GROUPS do
			ShortString, FullString = '', ''

			for slotNum = 1, NUM_GLYPH_SLOTS do
				_, _, _, SpellID, _, GlyphID = GetGlyphSocketInfo(slotNum, groupNum)
				
				ShortString = ShortString..(SpellID or '0')..(slotNum ~= NUM_GLYPH_SLOTS and '/' or '')
				FullString = FullString..(SpellID or '0')..'_'..(GlyphID or '0')..(slotNum ~= NUM_GLYPH_SLOTS and '/' or '')
			end

			if self.PlayerData['Glyph'..groupNum] ~= FullString then
				self.PlayerData['Glyph'..groupNum] = FullString
			end

			if groupNum == ActiveSpec and self.PlayerData_ShortString.Glyph1 ~= ShortString then
				self.PlayerData_ShortString.Glyph1 = ShortString
				self.UpdatedData.Glyph1 = ShortString
			end
		end

		self.Updater.GlyphUpdated = true
	end

	AISM.Updater:RegisterEvent('GLYPH_ADDED')
	AISM.Updater:RegisterEvent('GLYPH_REMOVED')
	AISM.Updater:RegisterEvent('GLYPH_UPDATED')

	--<< Gear String >>--
	function AISM:GetPlayerGearString()
		local ShortString, FullString
		local CurrentSetItem = {}

		local slotID, slotLink, isTransmogrified, transmogrifiedItemID, SetName, GeatSetCount, SetItemMax, colorR, colorG, colorB, checkSpace, SetItemOptionNum, tooltipText
		for slotName in pairs(self.GearList) do
			slotID = GetInventorySlotInfo(slotName)
			slotLink = GetInventoryItemLink('player', slotID)

			if slotLink and slotLink:find('%[%]') then -- sometimes itemLink is malformed so we need to update when crashed
				self.Updater.GearUpdated = nil

				return true
			end

			if slotLink and self.CanTransmogrifySlot[slotName] then
				isTransmogrified, _, _, _, _, transmogrifiedItemID = GetTransmogrifySlotInfo(slotID)
			else
				isTransmogrified = nil
			end

			if slotName == 'HeadSlot' or slotName == 'BackSlot' then
				--print(slotName..' : '..(slotName == 'HeadSlot' and not isHelmDisplayed and 'NotDisplayed' or slotName == 'BackSlot' and not isCloakDisplayed and 'NotDisplayed' or 'Displayed'))
			end

			ShortString = slotLink and select(2, strsplit(':', slotLink)) or 'F'
			FullString = (slotLink or 'F')..'/'..(slotName == 'HeadSlot' and not isHelmDisplayed and 'ND' or slotName == 'BackSlot' and not isCloakDisplayed and 'ND' or isTransmogrified and transmogrifiedItemID or '0')

			for i = 1, MAX_NUM_SOCKETS do
				FullString = FullString..'/'..(select(i, GetInventoryItemGems(slotID)) or 0)
			end

			if self.PlayerData[slotName] ~= FullString then
				self.PlayerData[slotName] = FullString
			end

			if self.PlayerData_ShortString[slotName] ~= ShortString then
				self.PlayerData_ShortString[slotName] = ShortString
				self.UpdatedData[slotName] = ShortString
			end

			if slotLink then
				self.Tooltip:ClearLines()
				self.Tooltip:SetInventoryItem('player', slotID)

				checkSpace = 2

				for i = 1, self.Tooltip:NumLines() do
					SetName, SetItemCount, SetItemMax = _G['AISM_TooltipTextLeft'..i]:GetText():match('^(.+) %((%d)/(%d)%)$') -- find string likes 'SetName (0/5)'

					if SetName then
						SetItemCount = tonumber(SetItemCount)
						SetItemMax = tonumber(SetItemMax)

						if SetItemCount > SetItemMax or SetItemMax == 1 then
							self.Updater.GearUpdated = nil

							return true
						elseif CurrentSetItem[SetName] then
							break
						else
							CurrentSetItem[SetName] = true
							ShortString = 0
							FullString = ''

							for k = 1, self.Tooltip:NumLines() do
								tooltipText = _G['AISM_TooltipTextLeft'..(i+k)]:GetText()

								if tooltipText == ' ' then
									checkSpace = checkSpace - 1

									if checkSpace == 0 then break end
								elseif checkSpace == 2 then
									colorR, colorG, colorB = _G['AISM_TooltipTextLeft'..(i+k)]:GetTextColor()

									if colorR > LIGHTYELLOW_FONT_COLOR.r - .01 and colorR < LIGHTYELLOW_FONT_COLOR.r + .01 and colorG > LIGHTYELLOW_FONT_COLOR.g - .01 and colorG < LIGHTYELLOW_FONT_COLOR.g + .01 and colorB > LIGHTYELLOW_FONT_COLOR.b - .01 and colorB < LIGHTYELLOW_FONT_COLOR.b + .01 then
										ShortString = ShortString + 1
										tooltipText = LIGHTYELLOW_FONT_COLOR_CODE..tooltipText
									else
										tooltipText = GRAY_FONT_COLOR_CODE..tooltipText
									end
								--print(tooltipText..' / '..SetItemCount..' / '..SetItemMax)

									FullString = FullString..'/'..tooltipText
								elseif tooltipText:find(ItemSetBonusKey) then
									FullString = FullString..'/'..(tooltipText:match("^%((%d)%)%s.+:%s.+$") or 'T')
								end
							end

							self.PlayerData.SetItem = self.PlayerData.SetItem or {}
							if self.PlayerData.SetItem[SetName] ~= FullString then
								self.PlayerData.SetItem[SetName] = FullString
							end

							self.PlayerData_ShortString.SetItem = self.PlayerData_ShortString.SetItem or {}
							if self.PlayerData_ShortString.SetItem[SetName] ~= ShortString then
								self.PlayerData_ShortString.SetItem[SetName] = ShortString

								self.UpdatedData.SetItem = self.UpdatedData.SetItem or {}
								self.UpdatedData.SetItem[SetName] = ShortString
							end

							break
						end
					end

					if checkSpace == 0 then break end
				end
			end
		end

		-- Clear cache when there's no gear set
		if self.PlayerData.SetItem then
			for SetName in pairs(self.PlayerData.SetItem) do
				if not CurrentSetItem[SetName] then
					self.PlayerData.SetItem[SetName] = nil

					self.PlayerData_ShortString.SetItem[SetName] = nil
					self.UpdatedData.SetItem = self.UpdatedData.SetItem or {}
					self.UpdatedData.SetItem[SetName] = 'F'
				end
			end
		end

		self.Updater.GearUpdated = true

		return nil
	end

	AISM.Updater:RegisterEvent('SOCKET_INFO_SUCCESS')
	AISM.Updater:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	--AISM.Updater:RegisterEvent('UNIT_INVENTORY_CHANGED')
	--AISM.Updater:RegisterEvent('EQUIPMENT_SWAP_FINISHED')
	AISM.Updater:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
	AISM.Updater:RegisterEvent('TRANSMOGRIFY_UPDATE')
	AISM.Updater:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')

	--<< Player Info >>--
	function AISM:SettingInspectData(TableToSave)
		local guildName, guildRankName = GetGuildInfo('player')
		
		TableToSave.PlayerInfo = playerName..'_'..UnitPVPName('player')..'/'..playerRealm..'/'..UnitLevel('player')..'/'..playerClass..'/'..playerClassID..'/'..playerRace..'/'..playerRaceID..'/'..playerSex..(guildName and '/'..guildName..'/'..guildRankName or '')
		
		if IsInGuild() then
			TableToSave.GuildInfo = GetGuildLevel()..'/'..GetNumGuildMembers()
			
			for _, DataString in ipairs({ GetGuildLogoInfo('player') }) do
				TableToSave.GuildInfo = TableToSave.GuildInfo..'/'..DataString
			end
		end
	end
	
	
	function AISM:SendData(InputData, Prefix, Channel, WhisperTarget)
		Channel = Channel or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(self.CurrentGroupMode)
		Prefix = Prefix or 'AISM'

		if not InputData or type(InputData) ~= 'table' or Channel == 'NOGROUP' then return end

		local Data = {}

		if InputData.Profession1 then
			Data[#Data + 1] = 'PF1:'..InputData.Profession1
		end

		if InputData.Profession2 then
			Data[#Data + 1] = 'PF2:'..InputData.Profession2
		end

		for groupNum = 1, MAX_TALENT_GROUPS do
			if InputData['Spec'..groupNum] then
				Data[#Data + 1] = 'SP'..groupNum..':'..InputData['Spec'..groupNum]
			end
		end

		if InputData.ActiveSpec then
			Data[#Data + 1] = 'ASP:'..InputData.ActiveSpec
		end

		for groupNum = 1, MAX_TALENT_GROUPS do
			if InputData['Glyph'..groupNum] then
				Data[#Data + 1] = 'GL'..groupNum..':'..InputData['Glyph'..groupNum]
			end
		end

		for slotName, keyName in pairs(self.GearList) do
			if InputData[slotName] then
				Data[#Data + 1] = keyName..':'..InputData[slotName]
			end
		end

		if InputData.SetItem then
			for SetName, DataString in pairs(InputData.SetItem) do
				Data[#Data + 1] = 'SID:'..SetName..(type(DataString) == 'number' and '/' or '')..DataString
			end
		end

		if InputData.PlayerInfo then
			Data[#Data + 1] = 'PLI:'..InputData.PlayerInfo
		end
		
		if InputData.GuildInfo then
			Data[#Data + 1] = 'GLD:'..InputData.GuildInfo
		end

		local DataString = ''
		local stringLength = 0
		local dataLength

		for dataTag, dataText in pairs(Data) do
			DataString = DataString..'{'..dataText..'}'
			dataLength = strlen(dataText) + 2

			if stringLength + dataLength <= 255 then
				stringLength = stringLength + dataLength
			else
				while strlen(DataString) > 255 do
					SendAddonMessage(Prefix, strsub(DataString, 1, 255), Channel, WhisperTarget)

					DataString = strsub(DataString, 256)
					stringLength = strlen(DataString)
				end
			end
		end

		if DataString ~= '' then
			SendAddonMessage(Prefix, DataString, Channel, WhisperTarget)
		end
	end

	function AISM:GetPlayerCurrentGroupMode()
		if not (IsInGroup() or IsInRaid()) or GetNumGroupMembers() == 1 then
			self.CurrentGroupMode = 'NoGroup'
			self.GroupMemberData = {}
		else
			if IsInRaid() then
				self.CurrentGroupMode = 'raid'
			else
				self.CurrentGroupMode = 'party'
			end

			for userName in pairs(self.GroupMemberData) do
				if not UnitExists(userName) or not UnitIsConnected(userName) then
					self.GroupMemberData[userName] = nil
				end
			end
		end
		
		return self.CurrentGroupMode
	end

	function AISM:GetCurrentInstanceType()
		local _, instanceType, difficultyID = GetInstanceInfo()

		if difficultyID == 8 then
			self.InstanceType = 'challenge'
		else
			self.InstanceType = instanceType == 'none' and 'field' or instanceType
		end
	end

	local LastSendGroupType = 'NoGroup'
	local LastSendInstanceType = 'field'
	AISM:SetScript('OnUpdate', function(self, elapsed)
		if not self.Initialize then
			SendAddonMessage('AISM', 'AISM_Initialize', 'WHISPER', playerName)
		else
			if self.CurrentGroupMode and self.InstanceType then
				if LastSendGroupType ~= self.CurrentGroupMode or LastSendInstanceType ~= self.InstanceType or self.needSendDataGroup ~= nil then
					LastSendGroupType = self.CurrentGroupMode
					LastSendInstanceType = self.InstanceType

					if self.CurrentGroupMode ~= 'NoGroup' then
						local Name, TableIndex

						for i = 1, MAX_RAID_MEMBERS do
							Name = UnitName(self.CurrentGroupMode..i)
							TableIndex = GetUnitName(self.CurrentGroupMode..i, true)

							if Name and not UnitIsUnit('player', self.CurrentGroupMode..i) then
								if Name == UNKNOWNOBJECT or Name == COMBATLOG_UNKNOWN_UNIT then
									if self.needSendDataGroup == nil then
										self.needSendDataGroup = false
									end
								elseif not UnitIsConnected(self.CurrentGroupMode..i) then
									if self.needSendDataGroup == nil then
										self.needSendDataGroup = 0
									elseif type(self.needSendDataGroup) == 'number' then
										self.needSendDataGroup = self.needSendDataGroup + 1
										
										if self.needSendDataGroup > 30 then
											self.needSendDataGroup = nil
										end
									end
									self.GroupMemberData[TableIndex] = nil
								elseif not self.GroupMemberData[TableIndex] then
									self.needSendDataGroup = true
									
									self.GroupMemberData[TableIndex] = true
								end
							end
						end
					else
						self.needSendDataGroup = nil
						self.SendDataGroupUpdated = self.SendMessageDelay
					end
				end

				if self.needSendDataGroup == true and self.Updater.SpecUpdated and self.Updater.GlyphUpdated and self.Updater.GearUpdated then
					self.SendDataGroupUpdated = self.SendDataGroupUpdated - elapsed
					
					if self.SendDataGroupUpdated < 0 then
						self.SendDataGroupUpdated = self.SendMessageDelay
						
						self:SendData(self.PlayerData_ShortString)
						self.needSendDataGroup = nil
					end
				end
			end
			
			if self.needSendDataGuild then
				self.SendDataGuildUpdated = self.SendDataGuildUpdated - elapsed
					
				if self.SendDataGuildUpdated < 0 then
					self.SendDataGuildUpdated = self.SendMessageDelay
					
					SendAddonMessage('AISM', 'AISM_GUILD_RegistME', 'GUILD')
					self.needSendDataGuild = nil
				end
			end
			
			if self.needSendDataGroup == nil and self.needSendDataGuild == nil then
				self:Hide() -- close function
			end
		end
	end)
	
	function AISM:PrepareTableSetting(Prefix, Sender)
		if Prefix == 'AISM' then
			local NeedResponse
			
			if type(self.GroupMemberData[Sender]) ~= 'table' then
				self.GroupMemberData[Sender] = {}
				
				NeedResponse = true
			end
			
			return self.GroupMemberData[Sender], NeedResponse
		else
			return self.CurrentInspectData[Sender]
		end
	end

	local SenderRealm
	function AISM:Receiver(Prefix, Message, Channel, Sender)
		Sender, SenderRealm = strsplit('-', Sender)
		Sender = Sender..(SenderRealm and SenderRealm ~= '' and SenderRealm ~= playerRealm and '-'..SenderRealm or '')

		--print('|cffceff00['..Channel..']|r|cff2eb7e4['..Prefix..']|r '..Sender..' : ')
		--print(Message)

		if Message == 'AISM_UnregistME' then
			self.GroupMemberData[Sender] = nil
		elseif Message == 'AISM_GUILD_RegistME' then
			self.GuildMemberData[Sender] = true
			SendAddonMessage('AISM', 'AISM_GUILD_RegistResponse', SenderRealm == playerRealm and 'WHISPER' or 'GUILD', Sender)
		elseif Message == 'AISM_GUILD_RegistResponse' then
			self.GuildMemberData[Sender] = true
		elseif Message == 'AISM_GUILD_UnregistME' then
			self.GuildMemberData[Sender] = nil
			self.CurrentInspectData[Sender] = nil
		elseif Message:find('AISM_DataRequestForInspecting:') then
			local needplayerName, needplayerRealm = Message:match('^.+:(.+)-(.+)$')
			
			if needplayerName == playerName and needplayerRealm == playerRealm then
				--local DataToSend = E:CopyTable({}, self.PlayerData)
				local TableToSend = {}

				for Index, Data in pairs(self.PlayerData) do
					TableToSend[Index] = Data
				end

				self:SettingInspectData(TableToSend)
				
				self:SendData(TableToSend, Prefix, Channel, Sender)
			end
		else
			local TableToSave, NeedResponse, Group, stringTable
			
			TableToSave, NeedResponse = self:PrepareTableSetting(Prefix, Sender)
			
			if not TableToSave then
				self.RemainMessage[Sender] = nil
				
				return
			else
				Message = (self.RemainMessage[Sender] or '')..Message

				for DataType, DataString in Message:gmatch('%{(.-):(.-)%}') do
					if self.DataTypeTable[DataType] then
						Message = string.gsub(Message, '%{'..DataType..':.-%}', '')
						Group = DataType:match('^.+(%d)$')
						stringTable = { strsplit('/', DataString) }

						for Index, Data in pairs(stringTable) do
							if tonumber(Data) then
								stringTable[Index] = tonumber(Data)
							end
						end

						if Group and self.DataTypeTable[DataType] ~= 'Gear' then -- Prepare group setting
							Group = tonumber(Group)
							TableToSave[(self.DataTypeTable[DataType])] = TableToSave[(self.DataTypeTable[DataType])] or {}
							TableToSave[(self.DataTypeTable[DataType])][Group] = TableToSave[(self.DataTypeTable[DataType])][Group] or {}
						end

						if self.DataTypeTable[DataType] == 'Profession' then
							if stringTable[1] == 'F' then
								--TableToSave.Profession[Group] = {}
								TableToSave.Profession[Group].Name = EMPTY
								TableToSave.Profession[Group].Level = 0
							else
								for localeName, Key in pairs(self.ProfessionList) do
									if Key == stringTable[1] then
										TableToSave.Profession[Group].Name = localeName
										break
									end
								end
								TableToSave.Profession[Group].Level = stringTable[2]
							end
						elseif self.DataTypeTable[DataType] == 'Specialization' then
							TableToSave.Specialization[Group].SpecializationID = stringTable[1]
							
							for i = 1, MAX_NUM_TALENT_TIERS do
								for k = 1, NUM_TALENT_COLUMNS do
									TableToSave.Specialization[Group]['Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] = k == stringTable[i + 1] and true or false
								end
							end
						elseif self.DataTypeTable[DataType] == 'ActiveSpec' then
							TableToSave.Specialization = TableToSave.Specialization or {}
							TableToSave.Specialization.ActiveSpec = tonumber(DataString)
						elseif self.DataTypeTable[DataType] == 'Glyph' then
							local SpellID, GlyphID
							for i = 1, #stringTable do
								SpellID, GlyphID = strsplit('_', stringTable[i])
								
								TableToSave.Glyph[Group]['Glyph'..i..'SpellID'] = tonumber(SpellID)
								TableToSave.Glyph[Group]['Glyph'..i..'ID'] = tonumber(GlyphID)
							end
						elseif self.DataTypeTable[DataType] == 'Gear' then
							TableToSave.Gear = TableToSave.Gear or {}
							
							for slotName, keyName in pairs(self.GearList) do
								if keyName == DataType then
									DataType = slotName
									break
								end
							end
							
							TableToSave.Gear[DataType] = {
								['ItemLink'] = stringTable[1] ~= 'F' and stringTable[1],
								['Transmogrify'] = stringTable[2] == 'ND' and 'NotDisplayed' or stringTable[2] ~= 0 and stringTable[2],
								['Gem1'] = stringTable[3] ~= 0 and stringTable[3],
								['Gem2'] = stringTable[4] ~= 0 and stringTable[4],
								['Gem3'] = stringTable[5] ~= 0 and stringTable[5],
							}
						elseif self.DataTypeTable[DataType] == 'SetItemData' then
							TableToSave.SetItem = TableToSave.SetItem or {}
							
							if stringTable[2] ~= 'F' then
								if type(stringTable[2]) == 'number' then
									TableToSave.SetItem[(stringTable[1])] = stringTable[2]
								else
									TableToSave.SetItem[(stringTable[1])] = {}
									
									for i = 2, #stringTable do
										if strlen(stringTable[i]) > 2 then
											TableToSave.SetItem[(stringTable[1])][i - 1] = stringTable[i]
										else
											for k = 1, #stringTable - i + 1 do
												TableToSave.SetItem[(stringTable[1])]['SetOption'..k] = stringTable[i + k - 1] == 'T' or stringTable[i + k - 1]
											end
											break
										end
									end
								end
							else
								TableToSave.SetItem[(stringTable[1])] = nil
							end
						elseif self.DataTypeTable[DataType] == 'PlayerInfo' then
							TableToSave.Name, TableToSave.Title = strsplit('_', stringTable[1])
							TableToSave.Realm = stringTable[2] ~= '' and stringTable[2] ~= playerRealm and stringTable[2] or nil
							TableToSave.Level = stringTable[3]
							TableToSave.Class = stringTable[4]
							TableToSave.ClassID = stringTable[5]
							TableToSave.Race = stringTable[6]
							TableToSave.RaceID = stringTable[7]
							TableToSave.GenderID = stringTable[8]
							TableToSave.guildName = stringTable[9]
							TableToSave.guildRankName = stringTable[10]
						elseif self.DataTypeTable[DataType] == 'GuildInfo' then
							TableToSave.guildLevel = stringTable[1]
							TableToSave.guildNumMembers = stringTable[2]
							
							for i = 3, #stringTable do
								TableToSave.guildEmblem = TableToSave.guildEmblem or {}
								TableToSave.guildEmblem[i - 2] = stringTable[i]
							end
						end
					end
				end

				if Message == '' then
					for funcName, func in pairs(self.RegisteredFunction) do
						func(Sender, TableToSave)
					end
					
					Message = nil
				end
				
				self.RemainMessage[Sender] = Message
				
				if NeedResponse then
					self:SendData(self.PlayerData_ShortString, 'AISM', SenderRealm == playerRealm and 'WHISPER' or nil, Sender)
				end
			end
		end
	end

	local prefix, message, channel, sender, needUpdate, updateData
	AISM:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'PLAYER_LOGIN' then
			self:GetPlayerCurrentGroupMode()
			self:GetCurrentInstanceType()
			isHelmDisplayed = ShowingHelm() == 1
			isCloakDisplayed = ShowingCloak() == 1
		elseif Event == 'PLAYER_GUILD_UPDATE' then
			if IsInGuild() then
				self.needSendDataGuild = true
				self:Show()
				self:UnregisterEvent('PLAYER_GUILD_UPDATE')
			end
		elseif Event == 'CHAT_MSG_ADDON' then
			Prefix, Message, Channel, Sender = ...
			
			if (Prefix == 'AISM' or Prefix == 'AISM_Inspect') and Sender ~= playerName..'-'..playerRealm then
				self:Receiver(Prefix, Message, Channel, Sender)
			elseif not self.Initialize and Prefix == 'AISM' and Message == 'AISM_Initialize' and Sender == playerName..'-'..playerRealm then
				self.Initialize = true
				
				if IsInGuild() then
					self.needSendDataGuild = true
					self:Show()
				else
					self:RegisterEvent('PLAYER_GUILD_UPDATE')
				end
			
			end
		elseif Event == 'PLAYER_LOGOUT' then
			if IsInGuild() then
				SendAddonMessage('AISM', 'AISM_GUILD_UnregistME', 'GUILD')
			end
			if self.CurrentGroupMode ~= 'NoGroup' then
				SendAddonMessage('AISM', 'AISM_UnregistME', IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(self.CurrentGroupMode))
			end
		elseif Event == 'GROUP_ROSTER_UPDATE' then
			self:GetPlayerCurrentGroupMode()
			self:Show()
		elseif Event == 'PLAYER_ENTERING_WORLD' or Event == 'ZONE_CHANGED_NEW_AREA' then
			self:GetCurrentInstanceType()
			self:Show()
		end
	end)
	AISM:RegisterEvent('PLAYER_LOGIN')
	AISM:RegisterEvent('PLAYER_LOGOUT')
	AISM:RegisterEvent('CHAT_MSG_ADDON')
	AISM:RegisterEvent('GROUP_ROSTER_UPDATE')
	AISM:RegisterEvent('PLAYER_ENTERING_WORLD')
	AISM:RegisterEvent('ZONE_CHANGED_NEW_AREA')

	function AISM:RegisterInspectDataRequest(Func, funcName, PreserveFunction)
		if type(Func) == 'function' then
			funcName = funcName or #self.RegisteredFunction + 1
			
			self.RegisteredFunction[funcName] = function(User, UserData)
				if Func(User, UserData) then
					if not PreserveFunction then
						self.RegisteredFunction[funcName] = nil
					end
				end
			end
		end
	end

	RegisterAddonMessagePrefix('AISM')
	RegisterAddonMessagePrefix('AISM_Inspect')
end