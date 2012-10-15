local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local S = E:GetModule('Skins')

local function LoadSkin()

	--if E.private.skins.notes.enable ~= true then return end

	local StripAllTextures = {
                "NotesFrame",
                "NotesFrameScrollFrame",
				"EditNotesFrame",
				"ConfigNotesFrame",
				"TextScrollFrame",
	}


	for _, object in pairs(StripAllTextures) do
							_G[object]:StripTextures()
				end

	--Handling buttons, frames, etc			
	S:HandleButton(NotesFrameCreateNoteButton, true)
	S:HandleButton(ConfigNotesFrame, true)
	S:HandleButton(Notes_AddActQuestInfo, true)
	S:HandleButton(NotesFrameCopyNoteButton, true)
	S:HandleButton(NotesFrameDeleteNoteButton, true)
	S:HandleButton(NotesFrameSendNoteButton, true)
	S:HandleButton(NotesFrameCancelButton, true)
	S:HandleScrollBar(NotesFrameScrollFrameScrollBar)
	S:HandleScrollBar(TextScrollFrameScrollBar)
	S:HandleCloseButton(NotesFrameCloseButton, true)
	S:HandleDropDownBox(Notes_AddQuestInfoDropDown)
	S:HandleDropDownBox(Notes_TypeDropDown)

	--Setting themplates. All transparent cause I like it
	NotesFrame:SetTemplate("Transparent")
	NotesFrameScrollFrame:SetTemplate("Transparent")
	TextScrollFrame:SetTemplate("Transparent")
	
	--Setting text color for uor notes
	TextBodyEditBox:SetTextColor(1, 1, 1)
	
	--Setting new sizes for buttons, dropdowns, etc
	--Clear points
	NotesFrameScrollFrame:ClearAllPoints()
	TextScrollFrame:ClearAllPoints()
	NotesFrameScrollFrameScrollBar:ClearAllPoints()
	TextScrollFrameScrollBar:ClearAllPoints()
	NotesFrameCreateNoteButton:ClearAllPoints()
	NotesFrameCopyNoteButton:ClearAllPoints()
	NotesFrameDeleteNoteButton:ClearAllPoints()
	NotesFrameSendNoteButton:ClearAllPoints()
	ConfigNotesFrame:ClearAllPoints()
	Notes_TypeDropDown:ClearAllPoints()
	--Sizes
	NotesFrameScrollFrame:SetSize(305, 336)
	TextScrollFrame:SetSize(290, 336)
	NotesFrameScrollFrameScrollBar:SetSize(20, 308)
	TextScrollFrameScrollBar:SetSize(20, 304)
	NotesFrameCreateNoteButton:SetSize(80, 21)
	NotesFrameCopyNoteButton:SetSize(80, 21)
	NotesFrameDeleteNoteButton:SetSize(80, 21)
	NotesFrameSendNoteButton:SetSize(80, 21)
	ConfigNotesFrame:SetSize(654, 40)
	Notes_TypeDropDown:SetSize(160, 20)
	
	--Setting new positions for buttons, dropdowns, etc
	NotesFrameScrollFrame:Point("BOTTOMLEFT", NotesFrame, "BOTTOMLEFT", 15, 38)
	TextScrollFrame:Point("LEFT", NotesFrameScrollFrameScrollBar, "RIGHT", 20, 0)
	NotesFrameScrollFrameScrollBar:Point("LEFT", NotesFrameScrollFrame, "RIGHT", 0, 0)
	TextScrollFrameScrollBar:Point("LEFT", TextScrollFrame, "RIGHT", 0, 0)
	NotesFrameCreateNoteButton:Point("TOPLEFT", NotesFrameScrollFrame, "BOTTOMLEFT", 0, -4)
	NotesFrameCopyNoteButton:Point("LEFT", NotesFrameCreateNoteButton, "RIGHT", 2, 0)
	NotesFrameDeleteNoteButton:Point("LEFT", NotesFrameCopyNoteButton, "RIGHT", 2, 0)
	NotesFrameSendNoteButton:Point("LEFT", NotesFrameDeleteNoteButton, "RIGHT", 2, 0)
	ConfigNotesFrame:Point("BOTTOMLEFT", NotesFrameScrollFrame, "TOPLEFT", 0, 2)
	Notes_TypeDropDown:Point("RIGHT", ConfigNotesFrame, "RIGHT", -5, -4)
end

S:RegisterSkin("Notes", LoadSkin)