local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local BG = SLE.Backgrounds
local CreateFrame = CreateFrame

--Default positions table. ID is passed everywhere so when positioning stuff I can just unpack by id and not writing a line for every BG.
BG.pos = {
		[1] = {'BOTTOM', 'BOTTOM', 0, 21},
		[2] = {'BOTTOMRIGHT', 'BOTTOM', -((E.eyefinity or E.ultrawide or E.physicalWidth)/4 + 32)/2 - 1, 21, 21},
		[3] = {'BOTTOMLEFT', 'BOTTOM', ((E.eyefinity or E.ultrawide or E.physicalWidth)/4 + 32)/2 + 1, 21},
		[4] = {'BOTTOM', 'BOTTOM', 0, E.physicalHeight/6 + 9},
	}

function BG:CreateFrame(id)
	local frame = CreateFrame('Frame', 'SLE_BG_'..id, E.UIParent, 'BackdropTemplate')
	frame:SetFrameStrata('BACKGROUND')
	frame.texture = frame:CreateTexture(nil, 'OVERLAY')
	frame.texture:Point('TOPLEFT', frame, 'TOPLEFT', 2, -2)
	frame.texture:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 2)
	frame:Hide()

	frame.texture:SetAlpha(E.db.general.backdropfadecolor.a or 0.5)
	return frame
end

function BG:Positions(id)
	local anchor, point, x, y = unpack(BG.pos[id])
	BG['Frame_'..id]:SetPoint(anchor, E.UIParent, point, x, y)
end

function BG:UpdateTexture(id)
	BG['Frame_'..id].texture:SetTexture(BG.db['bg'..id].texture)
end

function BG:FramesSize(id)
	BG['Frame_'..id]:SetSize(BG.db['bg'..id].width, BG.db['bg'..id].height)
end

function BG:Alpha(id)
	BG['Frame_'..id]:SetAlpha(BG.db['bg'..id].alpha)
end

function BG:FrameTemplate(id)
	BG['Frame_'..id]:SetTemplate(BG.db['bg'..id].template, true)
end

function BG:RegisterHide(id)
	if BG.db['bg'..id].pethide then
		E:RegisterPetBattleHideFrames(BG['Frame_'..id], E.UIParent, 'BACKGROUND')
	else
		E:UnregisterPetBattleHideFrames(BG['Frame_'..id])
	end
end

function BG:FramesVisibility(id)
	if BG.db['bg'..id].enabled then
		BG['Frame_'..id]:Show()
		E:EnableMover(BG['Frame_'..id].mover:GetName())
		RegisterStateDriver(BG['Frame_'..id], 'visibility', BG.db['bg'..id].visibility)
	else
		BG['Frame_'..id]:Hide()
		E:DisableMover(BG['Frame_'..id].mover:GetName())
		UnregisterStateDriver(BG['Frame_'..id], 'visibility')
	end
end

function BG:MouseCatching(id)
	BG['Frame_'..id]:EnableMouse(not(BG.db['bg'..id].clickthrough))
end

function BG:CreateAndUpdateFrames()
	for id = 1, 4 do
		if not BG['Frame_'..id] then BG['Frame_'..id] = self:CreateFrame(id) BG:Positions(id) end
		BG:FramesSize(id)
		BG:FrameTemplate(id)
		BG:Alpha(id)
		if not E.CreatedMovers['SLE_BG_'..id..'_Mover'] then E:CreateMover(BG['Frame_'..id], 'SLE_BG_'..id..'_Mover', L["SLE_BG_"..id], nil, nil, nil, 'S&L,S&L BG') end
		BG:FramesVisibility(id)
		BG:MouseCatching(id)
		BG:UpdateTexture(id)
		BG:RegisterHide(id)
	end
end

function BG:Initialize()
	if not SLE.initialized then return end

	function BG:ForUpdateAll()
		BG.db = E.db.sle.backgrounds
		BG:CreateAndUpdateFrames()
	end

	BG:ForUpdateAll()
end

SLE:RegisterModule(BG:GetName())
