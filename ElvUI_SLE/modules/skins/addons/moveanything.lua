local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()

	MAOptions:StripTextures()
	MAOptions:SetTemplate("Transparent")
	MANudger:StripTextures()
	MANudger:SetTemplate("Transparent")
	MAOptionsClose:StripTextures()
	
	S:HandleCheckBox(MAOptionsToggleModifiedFramesOnly)
	S:HandleCheckBox(MAOptionsToggleCategories)
	S:HandleCheckBox(MAOptionsToggleFrameStack)
	S:HandleCheckBox(MAOptionsToggleMovers)
	S:HandleCheckBox(MAOptionsToggleFrameEditors)
	
	S:HandleButton(MAOptionsClose, true)
	S:HandleButton(MAOptionsOpenBlizzardOptions, true)
	S:HandleButton(MAOptionsSync, true)
	
	--Buttons
	for i = 1, 100 do
        if _G["MAMove"..i.."Reset"] then S:HandleButton(_G["MAMove"..i.."Reset"], true) end
        if _G["MAMove"..i.."Reset"] then S:HandleButton(_G["MAMove"..i.."Reset"], true) end
        if _G["MAMove"..i.."Backdrop"] then _G["MAMove"..i.."Backdrop"]:StripTextures() end
        if _G["MAMove"..i.."Backdrop"] then _G["MAMove"..i.."Backdrop"]:SetTemplate() end
        if _G["MAMove"..i.."Move"] then S:HandleCheckBox(_G["MAMove"..i.."Move"]) end
        if _G["MAMove"..i.."Hide"] then S:HandleCheckBox(_G["MAMove"..i.."Hide"]) end
    end

	S:HandleButton(MANudger_CenterMe, true)
	S:HandleButton(MANudger_CenterH, true)
	S:HandleButton(MANudger_CenterV, true)
	S:HandleButton(MANudger_NudgeUp, true)
	S:HandleButton(MANudger_NudgeDown, true)
	S:HandleButton(MANudger_NudgeLeft, true)
	S:HandleButton(MANudger_NudgeRight, true)
	S:HandleButton(MANudger_Detach, true)
	S:HandleButton(MANudger_Hide, true)
		
	S:HandleScrollBar(MAScrollFrameScrollBar)
	S:HandleEditBox(MA_Search)
			
	S:HandleButton(GameMenuButtonMoveAnything, true)
	GameMenuButtonMoveAnything:CreateBackdrop()
	GameMenuButtonMoveAnything:ClearAllPoints()
	GameMenuButtonMoveAnything:Point("TOP", GameMenuFrame, "BOTTOM", 0, -3)
end

S:RegisterSkin("MoveAnything", LoadSkin)
