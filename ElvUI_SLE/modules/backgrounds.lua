local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local BG = SLE:NewModule('Backgrounds', 'AceHook-3.0');
local CreateFrame = CreateFrame
BG.pos = {
		[1] = {"BOTTOM", "BOTTOM", 0, 21},
		[2] = {"BOTTOMRIGHT", "BOTTOM", -((E.eyefinity or E.screenwidth)/4 + 32)/2 - 1, 21, 21},
		[3] = {"BOTTOMLEFT", "BOTTOM", ((E.eyefinity or E.screenwidth)/4 + 32)/2 + 1, 21},
		[4] = {"BOTTOM", "BOTTOM", 0, E.screenheight/6 + 9},
	}

function BG:CreateFrame(i)
	local frame = CreateFrame("Frame", "SLE_BG_"..i, E.UIParent)
	frame:SetFrameStrata("BACKGROUND")
	frame.texture = frame:CreateTexture(nil, 'OVERLAY')
	frame.texture:Point('TOPLEFT', frame, 'TOPLEFT', 2, -2)
	frame.texture:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 2)
	frame:Hide()

	frame.texture:SetAlpha(E.db.general.backdropfadecolor.a or 0.5) 
	return frame
end

function BG:Positions(i)
	local anchor, point, x, y = T.unpack(BG.pos[i])
	BG["Frame_"..i]:SetPoint(anchor, E.UIParent, point, x, y)
end

function BG:UpdateTexture(i)
	BG["Frame_"..i].texture:SetTexture(BG.db["bg"..i].texture)
end

function BG:FramesSize(i)
	BG["Frame_"..i]:SetSize(BG.db["bg"..i].width, BG.db["bg"..i].height)
end

function BG:Alpha(i)
	BG["Frame_"..i]:SetAlpha(BG.db["bg"..i].alpha)
end

function BG:FrameTemplate(i)
	BG["Frame_"..i]:SetTemplate(BG.db["bg"..i].template, true)
end

function BG:RegisterHide(i)
	if BG.db["bg"..i].pethide then
		E.FrameLocks[BG["Frame_"..i]] = true
	else
		E.FrameLocks[BG["Frame_"..i]] = nil
	end
end

function BG:FramesVisibility(i)
	if BG.db["bg"..i].enabled then
		BG["Frame_"..i]:Show()
		E:EnableMover(BG["Frame_"..i].mover:GetName())
	else
		BG["Frame_"..i]:Hide()
		E:DisableMover(BG["Frame_"..i].mover:GetName())
	end
end

function BG:MouseCatching(i)
	BG["Frame_"..i]:EnableMouse(not(BG.db["bg"..i].clickthrough))
end

function BG:CreateAndUpdateFrames()
	for i = 1, 4 do
		if not BG["Frame_"..i] then BG["Frame_"..i] = self:CreateFrame(i) end
		BG:Positions(i)
		BG:FramesSize(i)
		BG:FrameTemplate(i)
		BG:Alpha(i)
		if not E.CreatedMovers["SLE_BG_"..i.."_Mover"] then E:CreateMover(BG["Frame_"..i], "SLE_BG_"..i.."_Mover", L["SLE_BG_"..i], nil, nil, nil, "S&L,S&L BG") end
		BG:FramesVisibility(i)
		BG:MouseCatching(i)
		BG:UpdateTexture(i)
		BG:RegisterHide(i)
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