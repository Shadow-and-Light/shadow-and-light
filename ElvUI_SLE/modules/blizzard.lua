local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local B = SLE.Blizzard
local _G = _G

function B:Initialize()
	B.db = E.db.sle.blizzard
	if not SLE.initialized then return end

	PVPReadyDialog:Hide()

	hooksecurefunc(TalkingHeadFrame, 'PlayCurrent', function(frame)
		if E.db.sle.skins.talkinghead.hide then
			frame:Hide()
		end
	end)
end

SLE:RegisterModule(B:GetName())
