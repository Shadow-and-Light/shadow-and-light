local type, tinsert = type, tinsert
local ENI = _G['EnhancedNotifyInspectFrame']

if not ENI then
	local BlizzardNotifyInspect = _G['NotifyInspect']
	local playerRealm = GetRealmName()
	
	ENI = CreateFrame('Frame', 'EnhancedNotifyInspectFrame', UIParent)
	ENI.UpdatedTime = 0
	ENI.UpdateInterval = 1
	ENI.InspectList = {}
	ENI:SetScript('OnEvent', function(self, Event, ...)
		if self[Event] then
			self[Event](...)
		end
	end)
	ENI:Hide()

	ENI.TryInspect = function()
		if ENI.InspectList[1] and ENI.InspectList[(ENI.InspectList[1])] then
			local CurrentUnitGUID = UnitGUID(ENI.InspectList[(ENI.InspectList[1])].UnitID)

			if CurrentUnitGUID and not (ENI.CurrentInspectUnitGUID and CurrentUnitGUID ~= ENI.CurrentInspectUnitGUID) then
				ENI.CurrentInspectUnitGUID = CurrentUnitGUID
				BlizzardNotifyInspect(ENI.InspectList[(ENI.InspectList[1])].UnitID)
			else
				ENI.CancelInspect(ENI.InspectList[1])
			end
			return
		end

		ENI.UpdatedTime = 0
		ENI:Hide()
	end

	ENI.NotifyInspect = function(Unit, InspectFirst)
		if Unit ~= 'target' and UnitIsUnit(Unit, 'target') then
			Unit = 'target'
		end
		
		if Unit ~= 'focus' and UnitIsUnit(Unit, 'focus') then
			Unit = 'focus'
		end
		
		if UnitInParty(Unit) or UnitInRaid(Unit) then
			Unit = GetUnitName(Unit, true)
		end

		if UnitIsPlayer(Unit) and CanInspect(Unit) then
			local TableIndex = GetUnitName(Unit, true)

			if not ENI.InspectList[TableIndex] then
				if InspectFirst then
					tinsert(ENI.InspectList, 1, TableIndex)
				else
					tinsert(ENI.InspectList, TableIndex)
				end

				ENI.InspectList[TableIndex] = {
					['Index'] = InspectFirst and 1 or #ENI.InspectList,
					['UnitID'] = Unit,
					['CancelInspectByManual'] = InspectFirst,
				}
				ENI.CurrentInspectUnitGUID = UnitGUID(Unit)
				--ENI.TryInspect()
				ENI:Show()
			elseif InspectFirst and ENI.InspectList[TableIndex] then
				ENI.CancelInspect(TableIndex)
				ENI.NotifyInspect(Unit, InspectFirst)
			end
		end

		return Unit
	end

	ENI.CancelInspect = function(Unit)
		if ENI.InspectList[Unit] then
			if ENI.InspectList[Unit].Index == 1 then
				ENI.CurrentInspectUnitGUID = nil
			end
			
			tremove(ENI.InspectList, ENI.InspectList[Unit].Index)
			ENI.CurrentInspectUnitGUID = nil
			ENI.InspectList[Unit] = nil
		end
	end

	ENI.INSPECT_READY = function(InspectedUnitGUID)
		if InspectedUnitGUID == ENI.CurrentInspectUnitGUID then
			local Name, Realm
			_, _, _, _, _, Name, Realm = GetPlayerInfoByGUID(InspectedUnitGUID)
			Name = Name..(Realm and Realm ~= '' and Realm ~= playerRealm and '-'..Realm or '')

			if ENI.InspectList[Name] then
				if ENI.InspectList[Name].CancelInspectByManual then
					return
				end
				
				ENI.CancelInspect(Name)
				ENI.UpdatedTime = 0
			end
			
			ENI.CurrentInspectUnitGUID = nil
		end
	end
	ENI:RegisterEvent('INSPECT_READY')

	ENI.Updater = function(_, elapsed)
		ENI.UpdatedTime = ENI.UpdatedTime + elapsed

		if ENI.UpdatedTime < 0 then
			return
		else
			ENI.UpdatedTime = -ENI.UpdateInterval
		end

		ENI.TryInspect()
	end

	ENI:SetScript('OnUpdate', ENI.Updater)
end