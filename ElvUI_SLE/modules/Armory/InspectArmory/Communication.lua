--------------------------------------------------------------------------------
--<< AISM : Armory Support Module for AddOn Communication Inspecting		>>--
--------------------------------------------------------------------------------
local Revision = 1.2
local _G = _G
local AISM = _G["Armory_InspectSupportModule"] or CreateFrame('Frame', 'Armory_InspectSupportModule', UIParent)

if not AISM.Revision or AISM.Revision < Revision then
	local ItemSetBonusKey = ITEM_SET_BONUS:gsub('%%s', '(.+)')
	local ProfessionLearnKey = ERR_LEARN_ABILITY_S:gsub('%%s', '(.+)')
	local ProfessionLearnKey2 = ERR_LEARN_RECIPE_S:gsub('%%s', '(.+)')
	local ProfessionUnlearnKey = ERR_SPELL_UNLEARNED_S:gsub('%%s', '(.+)')
	local GuildLeaveKey = ERR_GUILD_LEAVE_S:gsub('%%s', '(.+)')
	local PlayerOfflineKey = ERR_CHAT_PLAYER_NOT_FOUND_S:gsub('%%s', '(.+)')
	
	local playerName = UnitName('player')
	local playerRealm = gsub(GetRealmName(),'[%s%-]','')
	local _, playerClass, playerClassID = UnitClass('player')
	local playerRace, playerRaceID = UnitRace('player')
	local playerSex = UnitSex('player')
	local playerNumSpecGroup = GetNumSpecGroups()
	
	
	--<< Create Core >>--
	AISM.Revision = Revision
	
	AISM.Tooltip = _G["AISM_Tooltip"] or AISM.Tooltip or CreateFrame('GameTooltip', 'AISM_Tooltip', nil, 'GameTooltipTemplate')
	AISM.Tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	AISM.Updater = _G["AISM_Updater"] or AISM.Updater or CreateFrame('Frame', 'AISM_Updater', UIParent)
	AISM.Updater.elapsed = 0
	
	AISM.Delay = 2
	AISM.Delay_Updater = .5
	
	AISM.PlayerData = { SetItem = {} }
	AISM.PlayerData_ShortString = { SetItem = {} }
	AISM.AISMUserList = {}
	AISM.GroupMemberData = {}
	AISM.GuildMemberData = {}
	AISM.CurrentInspectData = {}
	AISM.InspectRegistered = {}
	AISM.RemainMessage = {}
	AISM.RegisteredFunction = {}
	
	
	--<< Define Key Table >>--
	local SlotIDList = {}
	AISM.ProfessionList = {
		[GetSpellInfo(105206)] = 'AC', -- Alchemy
		[GetSpellInfo(110396)] = 'BS', -- BlackSmithing
		[GetSpellInfo(110400)] = 'EC', -- Enchanting
		[GetSpellInfo(110403)] = 'EG', -- Engineering
		[GetSpellInfo(110417)] = 'IS', -- Inscription
		[GetSpellInfo(110420)] = 'JC', -- JewelCrafting
		[GetSpellInfo(110423)] = 'LW', -- LeatherWorking
		[GetSpellInfo(110426)] = 'TL', -- Tailoring
		
		[GetSpellInfo(110413)] = 'HB', -- Herbalism
		[GetSpellInfo(102161)] = 'MN', -- Mining
		[GetSpellInfo(102216)] = 'SK' -- Skinning
	}
	AISM.GearList = {
		HeadSlot = 'HE',
		NeckSlot = 'NK',
		ShoulderSlot = 'SD',
		BackSlot = 'BK',
		ChestSlot = 'CH',
		ShirtSlot = 'ST',
		TabardSlot = 'TB',
		WristSlot = 'WR',
		HandsSlot = 'HD',
		WaistSlot = 'WA',
		LegsSlot = 'LE',
		FeetSlot = 'FE',
		Finger0Slot = 'FG0',
		Finger1Slot = 'FG1',
		Trinket0Slot = 'TR0',
		Trinket1Slot = 'TR1',
		MainHandSlot = 'MH',
		SecondaryHandSlot = 'SH'
	}
	AISM.CanTransmogrifySlot = {
		HeadSlot = true,
		ShoulderSlot = true,
		BackSlot = true,
		ChestSlot = true,
		WristSlot = true,
		HandsSlot = true,
		WaistSlot = true,
		LegsSlot = true,
		FeetSlot = true,
		MainHandSlot = true,
		SecondaryHandSlot = true
	}
	AISM.DataTypeTable = {
		PLI = 'PlayerInfo',
		GLD = 'GuildInfo',
		PvP = 'PvPInfo',
		PF1 = 'Profession',
		PF2 = 'Profession',
		ASP = 'ActiveSpec',
		SID = 'SetItemData'
	}
	AISM.UncheckableDataList = {
		Profession1 = false,
		Profession2 = false
	}
	for groupNum = 1, MAX_TALENT_GROUPS do
		AISM.DataTypeTable["SP"..groupNum] = 'Specialization'
	end
	for slotName, keyName in pairs(AISM.GearList) do
		AISM.DataTypeTable[keyName] = 'Gear'
		SlotIDList[GetInventorySlotInfo(slotName)] = slotName
	end
	
	
	--<< Player Data Updater Core >>--
	local needUpdate, args
	AISM.Updater:SetScript('OnUpdate', function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		
		if self.elapsed > 0 then
			self.elapsed = -AISM.Delay_Updater
			
			AISM.UpdatedData = needUpdate and AISM.UpdatedData or {}
			needUpdate = nil
			
			if not self.ProfessionUpdated then
				needUpdate = AISM:GetPlayerProfessionSetting() or needUpdate
			end
			
			if not self.SpecUpdated then
				needUpdate = AISM:GetPlayerSpecSetting() or needUpdate
			end
			
			if self.GearUpdated ~= true then
				needUpdate = AISM:GetPlayerGearString() or needUpdate
			end
			
			if not needUpdate then
				self.elapsed = 0
				self:Hide()
				
				for _ in pairs(AISM.UpdatedData) do
					if AISM.CurrentGroupMode and AISM.CurrentGroupMode ~= 'NoGroup' and AISM.CurrentGroupType then
						AISM:SendData(AISM.UpdatedData)
					end
					break
				end
			end
		end
	end)
	AISM.Updater:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'SOCKET_INFO_SUCCESS' or Event == 'ITEM_UPGRADE_MASTER_UPDATE' or Event == 'TRANSMOGRIFY_UPDATE' then
			self.GearUpdated = nil
			self:Show()
		elseif Event == 'UNIT_INVENTORY_CHANGED' then
			args = ...
			
			if args == 'player' then
				self.GearUpdated = nil
				self:Show()
			end
		elseif Event == 'PLAYER_EQUIPMENT_CHANGED' then
			args = ...
			self.GearUpdated = type(self.GearUpdated) == 'table' and self.GearUpdated or {}
			self.GearUpdated[(SlotIDList[args])] = true
			self:Show()
		elseif Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			_, Event, _, _, _, _, _, _, args = ...
			
			if Event == 'ENCHANT_APPLIED' and args == playerName then
				self.GearUpdated = nil
				self:Show()
			end
		elseif Event == 'CHAT_MSG_SYSTEM' then
			args = ...
			
			if args:find(ProfessionLearnKey) or args:find(ProfessionLearnKey2) or args:find(ProfessionUnlearnKey) then
				self.ProfessionUpdated = nil
				self:Show()
			end
		elseif Event == 'ACTIVE_TALENT_GROUP_CHANGED' or Event == 'PLAYER_SPECIALIZATION_CHANGED' then
			self.SpecUpdated = nil
			self:Show()
		elseif Event == 'PLAYER_TALENT_UPDATE' then
			local args = GetNumSpecGroups()
			
			if playerNumSpecGroup ~= args then
				playerNumSpecGroup = args
				self.SpecUpdated = nil
				self:Show()
				
				if args == MAX_TALENT_GROUPS then
					self:UnregisterEvent('PLAYER_TALENT_UPDATE')
				end
			end
		end
	end)
	
	if playerNumSpecGroup ~= MAX_TALENT_GROUPS then
		AISM.Updater:RegisterEvent('PLAYER_TALENT_UPDATE')
	end
	
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
			self.UncheckableDataList.Profession1 = Profession1
		end
		
		if self.PlayerData.Profession2 ~= Profession2 then
			self.PlayerData.Profession2 = Profession2
			self.UncheckableDataList.Profession2 = Profession2
		end
		
		self.Updater.ProfessionUpdated = true
	end
	AISM.Updater:RegisterEvent('CHAT_MSG_SYSTEM')
	
	
	--<< Specialization String >>--
	local ActiveSpec = GetActiveSpecGroup()
	local SpecTable = {}
	local GroupArray = {}
	for i = 1, playerNumSpecGroup do
		tinsert(GroupArray, i)
	end
	if ActiveSpec ~= 1 then
		tremove(GroupArray, ActiveSpec)
		tinsert(GroupArray, 1, ActiveSpec)
	end
	
	function AISM:GetPlayerSpecSetting()
		local DataString, Spec, Talent, isSelected
		
		ActiveSpec = GetActiveSpecGroup()
		
		if self.PlayerData.ActiveSpec ~= ActiveSpec then
			self.PlayerData.ActiveSpec = ActiveSpec
			self.PlayerData_ShortString.ActiveSpec = ActiveSpec
			self.UpdatedData.ActiveSpec = ActiveSpec
			
			wipe(GroupArray)
			for i = 1, playerNumSpecGroup do
				tinsert(GroupArray, i)
			end
			if ActiveSpec ~= 1 then
				tremove(GroupArray, ActiveSpec)
				tinsert(GroupArray, 1, ActiveSpec)
			end
		end
		
		for Step, Group in pairs(GroupArray) do
			DataString = nil
			
			Spec = GetSpecialization(nil, nil, Group)
			Spec = Spec and GetSpecializationInfo(Spec) or '0'
			
			if not SpecTable["Spec"..Step] or SpecTable["Spec"..Step] ~= Spec then
				SpecTable["Spec"..Step] = Spec
				DataString = Spec
			end
			
			for i = 1, MAX_TALENT_TIERS do
				for k = 1, NUM_TALENT_COLUMNS do
					Talent, _, _, isSelected = GetTalentInfo(i, k, Group)
					
					Talent = ((i - 1) * NUM_TALENT_COLUMNS + k)..'_'..Talent..(isSelected == true and '_1' or '')
					
					Spec = Spec..'/'..Talent
					
					if not SpecTable["Spec"..Step..'_Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] or SpecTable["Spec"..Step..'_Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] ~= Talent then
						SpecTable["Spec"..Step..'_Talent'..((i - 1) * NUM_TALENT_COLUMNS + k)] = Talent
						DataString = (DataString and DataString..'/' or '')..Talent
					end
				end
			end
			
			if not self.PlayerData["Spec"..Step] or self.PlayerData["Spec"..Step] ~= Spec then
				self.PlayerData["Spec"..Step] = Spec
				self.PlayerData_ShortString["Spec"..Step] = Spec
				self.UpdatedData["Spec"..Step] = DataString
				
				if Step > 1 then
					self.UncheckableDataList["Spec"..Step] = Spec
				end
			end
		end
		
		self.Updater.SpecUpdated = true
	end
	AISM.Updater:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	AISM.Updater:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
	
	--<< Gear String >>--
	function AISM:GetPlayerGearString()
		local ShortString, FullString, needUpdate, needUpdateList
		local CurrentSetItem, GearSetIDList = {}, {}
		
		local slotID, slotLink, isTransmogrified, transmogrifiedItemID, SetName, GeatSetCount, SetItemMax, SetOptionCount, colorR, colorG, colorB, checkSpace, tooltipText
		for slotName in pairs(type(self.Updater.GearUpdated) == 'table' and self.Updater.GearUpdated or self.GearList) do
			needUpdate = nil
			
			self.UncheckableDataList[slotName] = nil
			
			slotID = GetInventorySlotInfo(slotName)
			slotLink = GetInventoryItemLink('player', slotID)
			
			if slotLink and slotLink:find('%[%]') then -- sometimes itemLink is malformed so we need to update when crashed
				needUpdate = true
			else
				if slotLink and self.CanTransmogrifySlot[slotName] then
					isTransmogrified = C_Transmog.GetSlotInfo(slotID, LE_TRANSMOG_TYPE_APPEARANCE);
					if (isTransmogrified) then
						local transmogLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(select(3, C_Transmog.GetSlotVisualInfo(slotID, LE_TRANSMOG_TYPE_APPEARANCE))));
						if (transmogLink) then
							transmogrifiedItemID = select(2, strsplit(':', string.match(slotLink, 'item[%-?%d:]+')));
						else
							isTransmogrified = nil
						end
					end
				else
					isTransmogrified = nil
				end
				
				ShortString = slotLink and select(2, strsplit(':', string.match(slotLink, 'item[%-?%d:]+'))) or 'F'	-- ITEM ID
				FullString = slotLink or 'F'
				
				if slotLink then
					self.UncheckableDataList[slotName] = slotName == 'HeadSlot' and 'ND' or slotName == 'BackSlot' and 'ND' or isTransmogrified and transmogrifiedItemID or '0'
					
					for i = 1, MAX_NUM_SOCKETS do
						self.UncheckableDataList[slotName] = self.UncheckableDataList[slotName]..'/'..(select(i, GetInventoryItemGems(slotID)) or 0)
					end
					
					FullString = FullString..'/'..self.UncheckableDataList[slotName]
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
					self.Tooltip:SetHyperlink(slotLink)
					
					checkSpace = 2
					SetOptionCount = 1
					
					for i = 1, self.Tooltip:NumLines() do
						SetName, SetItemCount, SetItemMax = _G["AISM_TooltipTextLeft"..i]:GetText():match('^(.+) %((%d)/(%d)%)$') -- find string likes 'SetName (0/5)'
						
						if SetName then
							SetItemCount = tonumber(SetItemCount)
							SetItemMax = tonumber(SetItemMax)
							
							if SetItemCount > SetItemMax or SetItemMax == 1 then
								needUpdate = true
								break
							else
								if not (CurrentSetItem[SetName] or self.PlayerData.SetItem or self.PlayerData.SetItem[SetName]) then
									needUpdate = true
								end
								
								CurrentSetItem[SetName] = CurrentSetItem[SetName] or {}
								
								ShortString = 0
								FullString = ''
								
								for k = 1, self.Tooltip:NumLines() do
									tooltipText = _G["AISM_TooltipTextLeft"..(i+k)]:GetText()
									
									if tooltipText == ' ' then
										checkSpace = checkSpace - 1
										
										if checkSpace == 0 then break end
									elseif checkSpace == 2 then
										colorR, colorG, colorB = _G["AISM_TooltipTextLeft"..(i+k)]:GetTextColor()
										
										if colorR > LIGHTYELLOW_FONT_COLOR.r - .01 and colorR < LIGHTYELLOW_FONT_COLOR.r + .01 and colorG > LIGHTYELLOW_FONT_COLOR.g - .01 and colorG < LIGHTYELLOW_FONT_COLOR.g + .01 and colorB > LIGHTYELLOW_FONT_COLOR.b - .01 and colorB < LIGHTYELLOW_FONT_COLOR.b + .01 then
											ShortString = ShortString + 1
											tooltipText = LIGHTYELLOW_FONT_COLOR_CODE..tooltipText
										else
											tooltipText = GRAY_FONT_COLOR_CODE..tooltipText
										end
										
										if CurrentSetItem[SetName][k] and CurrentSetItem[SetName][k] ~= tooltipText then
											needUpdate = true
										end
										
										CurrentSetItem[SetName][k] = tooltipText
										FullString = FullString..'/'..tooltipText
									elseif tooltipText:find(ItemSetBonusKey) then
										tooltipText = tooltipText:match("^%((%d)%)%s.+:%s.+$") or 'T'
										
										if CurrentSetItem[SetName]["SetOption"..SetOptionCount] and CurrentSetItem[SetName]["SetOption"..SetOptionCount] ~= tooltipText then
											needUpdate = true
										end
										
										CurrentSetItem[SetName]["SetOption"..SetOptionCount] = tooltipText
										FullString = FullString..'/'..tooltipText
										
										SetOptionCount = SetOptionCount + 1
									end
								end
								
								if self.PlayerData.SetItem[SetName] ~= FullString then
									self.PlayerData.SetItem[SetName] = FullString
								end
								
								if self.PlayerData_ShortString.SetItem[SetName] ~= ShortString then
									self.PlayerData_ShortString.SetItem[SetName] = ShortString
									
									self.UpdatedData.SetItem = self.UpdatedData.SetItem or {}
									self.UpdatedData.SetItem[SetName] = ShortString
								end
							end
						end
						
						if checkSpace == 0 then break end
					end
				end
			end
			
			if needUpdate then
				needUpdateList = needUpdateList or {}
				needUpdateList[slotName] = true
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
		
		if needUpdateList then
			self.Updater.GearUpdated = needUpdateList
			return true
		else
			self.Updater.GearUpdated = true
		end
	end
	AISM.Updater:RegisterEvent('SOCKET_INFO_SUCCESS')
	AISM.Updater:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	AISM.Updater:RegisterEvent('UNIT_INVENTORY_CHANGED')
	AISM.Updater:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
	AISM.Updater:RegisterEvent('TRANSMOGRIFY_UPDATE')
	AISM.Updater:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	
	
	--<< Player Info >>--
	function AISM:SettingInspectData(TableToSave)
		local guildName, guildRankName = GetGuildInfo('player')
		
		TableToSave.PlayerInfo = playerName..'_'..UnitPVPName('player')..'/'..playerRealm..'/'..UnitLevel('player')..'/'..playerClass..'/'..playerClassID..'/'..playerRace..'/'..playerRaceID..'/'..playerSex..(guildName and '/'..guildName..'/'..guildRankName or '')
		
		if IsInGuild() then
			TableToSave.GuildInfo = GetTotalAchievementPoints(true)..'/'..GetNumGuildMembers()
			
			for _, DataString in ipairs({ GetGuildLogoInfo('player') }) do
				TableToSave.GuildInfo = TableToSave.GuildInfo..'/'..DataString
			end
		end
		
		TableToSave.PvP = GetPVPLifetimeStats()
		
		local Rating, Played, Won
		for i, Type in pairs({ '2vs2', '3vs3', '5vs5', 'RB' }) do
			Rating, _, _, Played, Won = GetPersonalRatedInfo(i)
			
			if Played > 0 then
				TableToSave.PvP = TableToSave.PvP..'/'..Type..'_'..Rating..'_'..Played..'_'..Won
			end
		end
	end
	
	
	function AISM:SendData(InputData, Prefix, Channel, WhisperTarget)
		Channel = Channel or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(self.CurrentGroupMode)
		Prefix = Prefix or 'AISM'
		
		if not InputData or type(InputData) ~= 'table' or Channel == 'NOGROUP' then return end
		
		local Data = {}
		
		if InputData.PlayerInfo then
			Data[#Data + 1] = 'PLI:'..InputData.PlayerInfo
		end
		
		if InputData.GuildInfo then
			Data[#Data + 1] = 'GLD:'..InputData.GuildInfo
		end
		
		if InputData.PvP then
			Data[#Data + 1] = 'PvP:'..InputData.PvP
		end
		
		if InputData.Profession1 then
			Data[#Data + 1] = 'PF1:'..InputData.Profession1
		end
		
		if InputData.Profession2 then
			Data[#Data + 1] = 'PF2:'..InputData.Profession2
		end
		
		if InputData.ActiveSpec then
			Data[#Data + 1] = 'ASP:1'
		end
		
		for groupNum = 1, MAX_TALENT_GROUPS do
			if InputData["Spec"..groupNum] then
				Data[#Data + 1] = 'SP'..groupNum..':'..InputData["Spec"..groupNum]
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
			wipe(self.GroupMemberData)
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
	
	local needSendData, Name, TableIndex
	AISM:SetScript('OnUpdate', function(self, elapsed)
		self.elapsed = -(self.elapsed or self.Delay) + (elapsed > 1 and 0 or elapsed)
		
		if self.elapsed <= 0 then return end
		self.elapsed = nil
		
		if self.CurrentGroupMode ~= 'NoGroup' then
			for i = 1, MAX_RAID_MEMBERS do
				Name = UnitName(self.CurrentGroupMode..i)
				TableIndex = GetUnitName(self.CurrentGroupMode..i, true)
				
				if Name and not UnitIsUnit('player', self.CurrentGroupMode..i) then
					if Name == UNKNOWNOBJECT or Name == COMBATLOG_UNKNOWN_UNIT then
						self.AISMUserList[TableIndex] = nil
						self.GroupMemberData[TableIndex] = nil
					elseif self.GroupMemberData[TableIndex] and not UnitIsConnected(self.CurrentGroupMode..i) then
						if type(self.GroupMemberData[TableIndex]) ~= 'number' then
							self.GroupMemberData[TableIndex] = 0
						end
						
						self.GroupMemberData[TableIndex] = self.GroupMemberData[TableIndex] + 1
						
						if self.GroupMemberData[TableIndex] >= 5 then
							self.GroupMemberData[TableIndex] = nil
						end
					elseif not self.GroupMemberData[TableIndex] then
						needSendData = true
						self.GroupMemberData[TableIndex] = true
					end
				end
			end
		else
			needSendData = nil
			self.SendDataGroupUpdated = nil
		end
		
		if needSendData and self.Updater.SpecUpdated and self.Updater.GearUpdated then
			needSendData = nil
			self.SendDataGroupUpdated = nil
			
			self:SendData(self.PlayerData_ShortString)
		end
		
		if needSendData == nil then
			self:Hide() -- close function
		end
	end)
	
	
	function AISM:PrepareTableSetting(Prefix, Sender)
		self.AISMUserList[Sender] = self.AISMUserList[Sender] or true
		
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
	
	
	local SenderRealm, TableToSave, NeedResponse, Group, stringTable
	function AISM:Receiver(Prefix, Message, Channel, Sender)
		Sender, SenderRealm = strsplit('-', Sender)
		SenderRealm = SenderRealm and gsub(SenderRealm,'[%s%-]','') or nil
		Sender = Sender..(SenderRealm and SenderRealm ~= '' and SenderRealm ~= playerRealm and '-'..SenderRealm or '')
		
		--print('|cffceff00["..Channel.."]|r|cff2eb7e4["..Prefix.."]|r '..Sender..' : ')
		--print(Message)
		
		if Message:find('AISM_') then
			if Message:find('AISM_Check') then
				self.AISMUserList[Sender] = true
				
				SendAddonMessage('AISM', 'AISM_Response:'..self.Revision, 'WHISPER', Sender)
			elseif Message:find('AISM_Response') then
				local ver = tonumber(strsub(Message:gsub('AISM_Response', ''), 2))
				Message = 'AISM_Response'
				
				if type(ver) == 'number' then
					self.AISMUserList[Sender] = ver
				else
					self.AISMUserList[Sender] = true
				end
			elseif Message == 'AISM_UnregistME' then
				self.AISMUserList[Sender] = nil
				self.GroupMemberData[Sender] = nil
			elseif Message == 'AISM_GUILD_Check' then
				self.AISMUserList[Sender] = 'GUILD'
				SendAddonMessage('AISM', 'AISM_GUILD_CheckResponse', SenderRealm == playerRealm and 'WHISPER' or 'GUILD', Sender)
			elseif Message == 'AISM_GUILD_CheckResponse' then
				self.AISMUserList[Sender] = 'GUILD'
			elseif Message == 'AISM_GUILD_UnregistME' then
				self.AISMUserList[Sender] = nil
				self.CurrentInspectData[Sender] = nil
			elseif Message:find('AISM_DataRequestForInspecting:') then
				Message = Message:gsub('AISM_DataRequestForInspecting:', '')
				
				local needplayerName, needplayerRealm, NeedOnlyUncheckableData = strsplit('-', Message)
				
				if needplayerName == playerName and needplayerRealm == playerRealm then
					if not NeedOnlyUncheckableData then
						local TableToSend = {}
						
						for Index, Data in pairs(self.PlayerData) do
							TableToSend[Index] = Data
						end
						
						self:SettingInspectData(TableToSend)
						self:SendData(TableToSend, Prefix, Channel, Sender)
					else
						self:SendData(self.UncheckableDataList, Prefix, Channel, Sender)
					end
				end
			end
			
			for funcName, func in pairs(self.RegisteredFunction) do
				func(Sender, Prefix, Message)
			end
		else
			TableToSave, NeedResponse = self:PrepareTableSetting(Prefix, Sender)
			
			if not TableToSave then
				self.RemainMessage[Sender] = nil
				
				return
			else
				Message = (self.RemainMessage[Sender] or '')..Message
				
				for DataType, DataString in Message:gmatch('%{(.-):(.-)%}') do
					if self.DataTypeTable[DataType] then
						Message = Message:gsub('%{'..DataType..':.-%}', '')
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
							local Spec, Talent, isSelected
							
							for i = 1, #stringTable do
								Spec, Talent, isSelected = strsplit('_', stringTable[i])
								
								if not Talent then
									TableToSave.Specialization[Group].SpecializationID = stringTable[1]
								else
									TableToSave.Specialization[Group]["Talent"..Spec] = { Talent, isSelected and true or false }
								end
							end
						elseif self.DataTypeTable[DataType] == 'ActiveSpec' then
							TableToSave.Specialization = TableToSave.Specialization or {}
							TableToSave.Specialization.ActiveSpec = tonumber(DataString)
						elseif self.DataTypeTable[DataType] == 'Gear' then
							TableToSave.Gear = TableToSave.Gear or {}
							
							for slotName, keyName in pairs(self.GearList) do
								if keyName == DataType then
									DataType = slotName
									break
								end
							end
							
							if #stringTable == 1 or #stringTable == 2 + MAX_NUM_SOCKETS then
								TableToSave.Gear[DataType] = {
									ItemLink = stringTable[1] ~= 'F' and stringTable[1] or nil,
									Transmogrify = stringTable[2] == 'ND' and 'NotDisplayed' or stringTable[2] ~= 0 and stringTable[2] or nil
								}
								
								for i = 1, MAX_NUM_SOCKETS do
									TableToSave.Gear[DataType]["Gem"..i] = stringTable[i + 2] ~= 0 and stringTable[i + 2] or nil
								end
							else
								TableToSave.Gear[DataType] = {
									Transmogrify = stringTable[1] == 'ND' and 'NotDisplayed' or stringTable[1] ~= 0 and stringTable[1] or nil
								}
								
								for i = 1, MAX_NUM_SOCKETS do
									TableToSave.Gear[DataType]["Gem"..i] = stringTable[i + 1] ~= 0 and stringTable[i + 1] or nil
								end
							end
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
												TableToSave.SetItem[(stringTable[1])]["SetOption"..k] = stringTable[i + k - 1] == 'T' or stringTable[i + k - 1]
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
							TableToSave.guildPoint = stringTable[1]
							TableToSave.guildNumMembers = stringTable[2]
							
							for i = 3, #stringTable do
								TableToSave.guildEmblem = TableToSave.guildEmblem or {}
								TableToSave.guildEmblem[i - 2] = stringTable[i]
							end
						elseif self.DataTypeTable[DataType] == 'PvPInfo' then
							TableToSave.PvP = TableToSave.PvP or {}
							
							TableToSave.PvP.Honor = stringTable[1]
							
							local PvPType, Rating, Played, Won
							for i = 2, #stringTable do
								PvPType, Rating, Played, Won = strsplit('_', stringTable[i])
								TableToSave.PvP[PvPType] = { tonumber(Rating), tonumber(Played), tonumber(Won) }
							end
						end
					end
				end
				
				if Message == '' then
					for funcName, func in pairs(self.RegisteredFunction) do
						func(Sender, Prefix, TableToSave)
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
	
	
	local Prefix, Message, Channel, Sender, Type
	AISM:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'PLAYER_LOGIN' then
			self:GetPlayerCurrentGroupMode()
			self:GetCurrentInstanceType()
		elseif Event == 'PLAYER_LOGOUT' then
			if IsInGuild() then
				SendAddonMessage('AISM', 'AISM_GUILD_UnregistME', 'GUILD')
			end
			if self.CurrentGroupMode ~= 'NoGroup' then
				SendAddonMessage('AISM', 'AISM_UnregistME', IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(self.CurrentGroupMode))
			end
		elseif Event == 'CHAT_MSG_SYSTEM' then
			Message = ...
			Type = Message:find(GuildLeaveKey) and 'GUILD' or Message:find(PlayerOfflineKey) and 'OFFLINE' or nil
			
			if Type then
				local SenderRealm
				
				Sender = Message:match(GuildLeaveKey) or Message:match(PlayerOfflineKey)
				Sender = Sender:gsub('@', '-')
				Sender, SenderRealm = strsplit('-', Sender)
				SenderRealm = SenderRealm and gsub(SenderRealm, '[%s%-]', '') or nil
				Sender = Sender..(SenderRealm and SenderRealm ~= '' and SenderRealm ~= playerRealm and '-'..SenderRealm or '')
				
				for userName in pairs(self.AISMUserList) do
					if userName == Sender then
						self.AISMUserList[userName] = Type == 'GUILD' and true or nil
						
						return
					end
				end
			end
		elseif Event == 'CHAT_MSG_ADDON' then
			Prefix, Message, Channel, Sender = ...
			
			if (Prefix == 'AISM' or Prefix == 'AISM_Inspect') and Sender ~= playerName..'-'..playerRealm then
				self:Receiver(Prefix, Message, Channel, Sender)
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
	AISM:RegisterEvent('CHAT_MSG_SYSTEM')
	AISM:RegisterEvent('CHAT_MSG_ADDON')
	AISM:RegisterEvent('GROUP_ROSTER_UPDATE')
	AISM:RegisterEvent('PLAYER_ENTERING_WORLD')
	AISM:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	
	
	function AISM:RegisterInspectDataRequest(Func, funcName, PreserveFunction)
		if type(Func) == 'function' then
			funcName = funcName or #self.RegisteredFunction + 1
			
			self.RegisteredFunction[funcName] = function(User, Prefix, UserData)
				if Func(User, Prefix, UserData) then
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