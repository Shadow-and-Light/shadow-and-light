local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Revision = 1.6
local _G = _G
local _
local ENI = _G["EnhancedNotifyInspect"] or CreateFrame('Frame', 'EnhancedNotifyInspect', UIParent)

local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local RequestInspectHonorData = RequestInspectHonorData
local C_TimerNewTicker = C_Timer.NewTicker

if not ENI.Revision or ENI.Revision < Revision then
	ENI.InspectList = {}
	ENI.Revision = Revision
	ENI.UpdateInterval = 1
	
	if not ENI.Original_BlizzardNotifyInspect then
		local BlizNotifyInspect = _G["NotifyInspect"]
		ENI.Original_BlizzardNotifyInspect = BlizNotifyInspect
	end
	
	ENI:SetScript('OnEvent', function(self, Event, ...)
		if self[Event] then
			self[Event](...)
		end
	end)
	ENI:SetScript('OnUpdate', function(self)
		if not self.HoldInspecting then
			self.NowInspecting = C_TimerNewTicker(self.UpdateInterval, self.TryInspect)
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
				
				if UnitID and T.UnitIsConnected(UnitID) and T.CanInspect(UnitID) and not (Count and Count <= 0) then
					ENI.CurrentInspectUnitGUID = T.UnitGUID(UnitID)
					
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
		if Unit ~= 'target' and T.UnitIsUnit(Unit, 'target') then
			Unit = 'target'
		end
		
		if Unit ~= 'focus' and T.UnitIsUnit(Unit, 'focus') then
			Unit = 'focus'
		end
		
		if T.UnitInParty(Unit) or T.UnitInRaid(Unit) then
			Unit = T.GetUnitName(Unit, true)
		end
		
		if T.UnitIsPlayer(Unit) and T.CanInspect(Unit) then
			local TableIndex = T.GetUnitName(Unit, true)
			local Check = not (Properties and T.type(Properties) == 'table' and Properties.Reservation)
			
			if not ENI.InspectList[TableIndex] then
				if Check then
					T.tinsert(ENI.InspectList, 1, TableIndex)
				else
					T.tinsert(ENI.InspectList, TableIndex)
				end
				
				ENI.InspectList[TableIndex] = { UnitID = Unit }
				
				if Properties and T.type(Properties) == 'table' then
					ENI.InspectList[TableIndex].InspectTryCount = Properties.InspectTryCount
					ENI.InspectList[TableIndex].CancelInspectByManual = Properties.CancelInspectByManual
				end
				
				if not ENI.HoldInspecting and (not ENI.NowInspecting or ENI.NowInspecting._cancelled) then
					ENI.NowInspecting = C_TimerNewTicker(ENI.UpdateInterval, ENI.TryInspect)
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
					T.tremove(ENI.InspectList, i)
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