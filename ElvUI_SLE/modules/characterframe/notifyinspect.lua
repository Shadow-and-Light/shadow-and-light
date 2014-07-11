local type, tinsert = type, tinsert
local ENI = _G['EnhancedNotifyInspectFrame']
local CurrentFileRevision = 1.0

if not ENI then
	ENI = CreateFrame('Frame', 'EnhancedNotifyInspectFrame', UIParent)
	ENI.UpdatedTime = 0
	ENI.InspectList = {}
	ENI:SetScript('OnEvent', function(self, Event, ...)
		if self[Event] then
			self[Event](...)
		end
	end)
	ENI:Hide()
end	

if not (ENI.Revision and ENI.Revision >= CurrentFileRevision) then
	ENI.Revision = CurrentFileRevision
	ENI.UpdateInterval = 1
	
	local BlizzardNotifyInspect = _G['NotifyInspect']
	local playerRealm = GetRealmName()
	
	local UnitID
	ENI.TryInspect = function()
		for i = 1, #ENI.InspectList do
			if ENI.InspectList[(ENI.InspectList[i])] then
				UnitID = ENI.InspectList[(ENI.InspectList[i])].UnitID
				
				if UnitID and UnitIsConnected(UnitID) and CanInspect(UnitID) then
					ENI.CurrentInspectUnitGUID = UnitGUID(UnitID)
					
					BlizzardNotifyInspect(UnitID)
					
					if ENI.InspectList[(ENI.InspectList[i])].CancelInspectByManual then
						RequestInspectHonorData()
					end
				else
					ENI.CancelInspect(ENI.InspectList[i])
				end
				return
			end
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
					['UnitID'] = Unit,
					['CancelInspectByManual'] = InspectFirst,
				}
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
			local Index
			
			for i = 1, #ENI.InspectList do
				if ENI.InspectList[i] == Unit then
					Index = i
					break
				end
			end
			
			tremove(ENI.InspectList, Index)
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
		else
			ENI.TryInspect()
			ENI.UpdatedTime = -ENI.UpdateInterval
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