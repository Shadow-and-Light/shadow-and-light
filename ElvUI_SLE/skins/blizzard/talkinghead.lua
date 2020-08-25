local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule('Blizzard')

local _G = _G

function B:SLETalkingHead()
	if E.db.sle.skins.talkinghead.hide then
		E:DisableMover(TalkingHeadFrame.mover:GetName())
	else
		E:EnableMover(_G.TalkingHeadFrame.mover:GetName())
	end
end

local function LoadHooks()
	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
		if E.db.sle.skins.talkinghead.hide then
			_G.TalkingHeadFrame:Hide()
		end
	end)
	B:SLETalkingHead()
end

hooksecurefunc(B, "ScaleTalkingHeadFrame", LoadHooks)
