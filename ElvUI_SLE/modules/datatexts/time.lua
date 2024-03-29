local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DT = E.DataTexts
local DTP = SLE.Datatexts
local LFR = SLE.LFR

--Put everything in function so nothing attempts to execute when time dt doesn't exist
function DTP:HookTimeDT()
	local enteredFrame = false

	local function OnEnter(self)
		if(not enteredFrame) then
			enteredFrame = true
		end
		if LFR.db.enabled then
			LFR:Show()
		end
		DT.tooltip:Show()
	end

	local function OnLeave(self)
		enteredFrame = false
	end

	local function OnEvent(self, event)
		if event == 'UPDATE_INSTANCE_INFO' and enteredFrame then
			OnEnter(self)
		end
	end

	local int = 3
	local function OnUpdate(self, t)
		int = int - t

		if int > 0 then return end

		if enteredFrame then
			OnEnter(self)
		end

		int = 5
	end

	hooksecurefunc(DT.RegisteredDataTexts['Time'], 'onEnter', OnEnter)
	hooksecurefunc(DT.RegisteredDataTexts['Time'], 'onLeave', OnLeave)
	hooksecurefunc(DT.RegisteredDataTexts['Time'], 'onUpdate', OnUpdate)
	hooksecurefunc(DT.RegisteredDataTexts['Time'], 'eventFunc', OnEvent)
end
