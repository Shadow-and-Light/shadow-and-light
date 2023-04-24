local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local B = SLE.Blizzard
local _G = _G

function B:ErrorFrameSize()
	_G.UIErrorsFrame:SetSize(B.db.errorframe.width, B.db.errorframe.height) --512 x 60
end

function B:SLTalkingHead()
	if not _G.TalkingHeadFrame.mover then return end
	if E.db.sle.skins.talkinghead.hide then
		E:DisableMover(_G.TalkingHeadFrame.mover:GetName())
	else
		E:EnableMover(_G.TalkingHeadFrame.mover:GetName())
	end
end

function B:UpdateAll()
	B.db = E.db.sle.blizzard
	B:ErrorFrameSize()
	B:SLTalkingHead()
end

function B:Initialize()
	B.db = E.db.sle.blizzard
	if not SLE.initialized then return end

	PVPReadyDialog:Hide()

	B:ErrorFrameSize()
	B:SLTalkingHead()
	hooksecurefunc(TalkingHeadFrame, 'PlayCurrent', function(frame)
		if E.db.sle.skins.talkinghead.hide then
			frame:Close()
			frame:Hide()
		end
	end)
end

SLE:RegisterModule(B:GetName())
