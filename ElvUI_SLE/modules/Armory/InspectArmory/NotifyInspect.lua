local Revision = 1.6
local ENI = _G['EnhancedNotifyInspect'] or CreateFrame('Frame', 'EnhancedNotifyInspect', UIParent)

if not ENI.Revision or ENI.Revision < Revision then
	ENI.InspectList = {}
	ENI.Revision = Revision
	ENI.UpdateInterval = 1
	
	if not ENI.Original_BlizzardNotifyInspect then
		local BlizNotifyInspect = _G['NotifyInspect']
		ENI.Original_BlizzardNotifyInspect = BlizNotifyInspect
	end
	
	ENI:SetScript('OnEvent', function(self, Event, ...)
		if self[Event] then
			self[Event](...)
		end
	end)
	ENI:SetScript('OnUpdate', function(self)
		if not self.HoldInspecting then
			self.NowInspecting = C_Timer.NewTicker(self.UpdateInterval, self.TryInspect)
			self:Hide()
		end
	end)
	ENI:Hide()
	
	local playerRealm = gsub(GetRealmName(),'[%s%-]','')
	
	local UnitID, Count
	ENI.TryInspect = function()
		for i = 1, #ENI.InspectList do
			if ENI.InspectList[(ENI.InspectList[i])] then
				UnitID = ENI.InspectList[(ENI.InspectList[i])].UnitID
				Count = ENI.InspectList[(ENI.InspectList[i])].InspectTryCount
				
				if UnitID and UnitIsConnected(UnitID) and CanInspect(UnitID) and not (Count and Count <= 0) then
					ENI.CurrentInspectUnitGUID = UnitGUID(UnitID)
					
					if Count then
						ENI.InspectList[(ENI.InspectList[i])].InspectTryCount = ENI.InspectList[(ENI.InspectList[i])].InspectTryCount - 1
					end
					
					ENI.Original_BlizzardNotifyInspect(UnitID)
					
					if ENI.InspectList[(ENI.InspectList[i])].CancelInspectByManual then
						RequestInspectHonorData()
					end
					
					return
				elseif Count and Count <= 0 or not ENI.InspectList[(ENI.InspectList[i])].CancelInspectByManual then
					ENI.CancelInspect(ENI.InspectList[i])
					return
				end
			end
		end
		
		if ENI.NowInspecting and not ENI.NowInspecting._cancelled then
			ENI.NowInspecting:Cancel()
		end
	end
	
	--[[
		Properties = {
			Reservation = boolean,
			InspectTryCount = number,
			CancelInspectByManual = Canceller,
		}
	]]
	ENI.NotifyInspect = function(Unit, Properties)
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
			local Check = not (Properties and type(Properties) == 'table' and Properties.Reservation)
			
			if not ENI.InspectList[TableIndex] then
				if Check then
					tinsert(ENI.InspectList, 1, TableIndex)
				else
					tinsert(ENI.InspectList, TableIndex)
				end
				
				ENI.InspectList[TableIndex] = { UnitID = Unit }
				
				if Properties and type(Properties) == 'table' then
					ENI.InspectList[TableIndex].InspectTryCount = Properties.InspectTryCount
					ENI.InspectList[TableIndex].CancelInspectByManual = Properties.CancelInspectByManual
				end
				
				if not ENI.HoldInspecting and (not ENI.NowInspecting or ENI.NowInspecting._cancelled) then
					ENI.NowInspecting = C_Timer.NewTicker(ENI.UpdateInterval, ENI.TryInspect)
				elseif ENI.HoldInspecting then
					ENI:Show()
				end
			elseif Check then
				ENI.CancelInspect(TableIndex)
				ENI.NotifyInspect(Unit, Properties)
			end
		end
		
		return Unit
	end
	
	ENI.CancelInspect = function(Unit, Canceller)
		if ENI.InspectList[Unit] then
			for i = 1, #ENI.InspectList do
				if ENI.InspectList[i] == Unit and not (Canceller and ENI.InspectList[Unit].CancelInspectByManual and ENI.InspectList[Unit].CancelInspectByManual ~= Canceller) then
					tremove(ENI.InspectList, i)
					ENI.InspectList[Unit] = nil
					
					return
				end
			end
		end
	end
	
	ENI.INSPECT_READY = function(InspectedUnitGUID)
		local Name, Realm
		
		_, _, _, _, _, Name, Realm = GetPlayerInfoByGUID(InspectedUnitGUID)
		
		if Name then
			Name = Name..(Realm and Realm ~= '' and Realm ~= playerRealm and '-'..Realm or '')
			
			if ENI.InspectList[Name] then
				if ENI.InspectList[Name].CancelInspectByManual then
					return
				end
				
				ENI.CancelInspect(Name)
			end
		end
	end
	ENI:RegisterEvent('INSPECT_READY')
end