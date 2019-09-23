local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end --Don't break korean code :D
local Armory = SLE:GetModule("Armory_Core")
local CA = SLE:NewModule("Armory_Character", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
local LCG = LibStub('LibCustomGlow-1.0')

local _G = _G
local HasAnyUnselectedPowers = C_AzeriteEmpoweredItem.HasAnyUnselectedPowers

--This is for elements we'll need original points for
local DefaultPosition = {
	InsetDefaultPoint = { _G["CharacterFrameInsetRight"]:GetPoint() },
	CharacterMainHandSlot = { _G["CharacterMainHandSlot"]:GetPoint() }
}
local PANEL_DEFAULT_WIDTH = PANEL_DEFAULT_WIDTH

CA.ElementsCreated = false

--Adding new stuffs for armory only
function CA:BuildLayout()

	--<< Background >>--
	if not _G["PaperDollFrame"].SLE_Armory_BG then
		_G["PaperDollFrame"].SLE_Armory_BG = _G["PaperDollFrame"]:CreateTexture(nil, 'OVERLAY')
		_G["PaperDollFrame"].SLE_Armory_BG:Point('TOPLEFT', _G["CharacterModelFrame"], -4, 0)
		_G["PaperDollFrame"].SLE_Armory_BG:Point('BOTTOMRIGHT', _G["CharacterModelFrame"], 4, 0)
	end
	_G["PaperDollFrame"].SLE_Armory_BG:Hide()
	
	--<<This may be unnessesary>>--
	--Change Model Frame's frameLevel. Cause background is not so back-ish
	-- _G["CharacterModelFrame"]:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 5)

	--So now gear slots are on the same level as background. Make then higher!
	-- for i, SlotName in T.pairs(Armory.Info.GearList) do
		-- local Slot = _G["Character"..SlotName]
		-- Slot:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 1)
	-- end
	
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		Slot.ID = T.GetInventorySlotInfo(SlotName)

		--<<Azerite>>--
		hooksecurefunc(_G["Character"..SlotName], "SetAzeriteItem", function(self, itemLocation)
			-- if not CA[SlotName].AzeriteAnchor then return end
			if not itemLocation then
				-- CA[SlotName].AzeriteAnchor:Hide()
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
				return
			end
			-- self.AzeriteTexture:Hide()
			if E.db.sle.armory.character.enable then self.AvailableTraitFrame:Hide() end
			local isAzeriteEmpoweredItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation);
			if isAzeriteEmpoweredItem then
				-- CA[SlotName].AzeriteAnchor:Show()
			else
				-- CA[SlotName].AzeriteAnchor:Hide()
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
			end
		end)

		hooksecurefunc(_G["Character"..SlotName], "DisplayAsAzeriteEmpoweredItem", function(self, itemLocation)
			if E.db.sle.armory.character.enable and HasAnyUnselectedPowers(itemLocation) then
				LCG.PixelGlow_Start(self, Armory.Constants.AzeriteTraitAvailableColor, nil,-0.25,nil, 3, nil,nil,nil, "_AzeriteTraitGlow")
			else
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
			end
		end)
		
		-- if SlotName == "NeckSlot" then
			-- Slot.RankFrame:StripTextures()
			-- Slot.RankFrame:SetTemplate("Transparent")
			-- Slot.RankFrame:SetSize(16, 16)
			-- Slot.RankFrame:SetPoint("BOTTOMLEFT", Slot, 0 + E.db.sle.Armory.Character.AzeritePosition.xOffset, 2 + E.db.sle.Armory.Character.AzeritePosition.yOffset)
			-- Slot.RankFrame.Label:SetPoint("CENTER", Slot.RankFrame, 1, 0)
		-- end
		
		--<<Transmog>>--
		if Armory.Constants.CanTransmogrify[SlotName] then
			Slot.TransmogInfo = CreateFrame('Button', SlotName.."_SLE_TransmogInfo", Slot)
			Slot.TransmogInfo:Size(12)
			Slot.TransmogInfo:SetFrameLevel(Slot:GetFrameLevel() + 2)
			Slot.TransmogInfo:Point('BOTTOM'..Slot.Direction, Slot, Slot.Direction == 'LEFT' and -2 or 2, -1)
			Slot.TransmogInfo:SetScript('OnEnter', self.Transmog_OnEnter)
			Slot.TransmogInfo:SetScript('OnLeave', self.Transmog_OnLeave)
			Slot.TransmogInfo:SetScript('OnClick', self.Transmog_OnClick)

			Slot.TransmogInfo.Texture = Slot.TransmogInfo:CreateTexture(nil, 'OVERLAY')
			Slot.TransmogInfo.Texture:SetInside()
			Slot.TransmogInfo.Texture:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\armory\anchor]])
			Slot.TransmogInfo.Texture:SetVertexColor(1, .5, 1)

			if Slot.Direction == 'LEFT' then
				Slot.TransmogInfo.Texture:SetTexCoord(0, 1, 0, 1)
			else
				Slot.TransmogInfo.Texture:SetTexCoord(1, 0, 0, 1)
			end

			Slot.TransmogInfo:Hide()
		end
	end
	
	--<<<Hooking some shit!>>>--
	hooksecurefunc('CharacterFrame_Collapse', function()
		if E.db.sle.armory.character.enable and _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(448) end
	end)
	hooksecurefunc('CharacterFrame_Expand', function()
		if E.db.sle.armory.character.enable and _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(650) end
	end)
	hooksecurefunc('ToggleCharacter', function(frameType)
		if not E.db.sle.armory.character.enable then return end
		if frameType ~= "PaperDollFrame" and frameType ~= "PetPaperDollFrame" then
			_G["CharacterFrame"]:SetWidth(PANEL_DEFAULT_WIDTH)
		-- elseif Info.CharacterArmory_Activate and frameType == "PaperDollFrame" then
		elseif frameType == "PaperDollFrame" then
			_G["CharacterFrameInsetRight"]:SetPoint('TOPLEFT', _G["CharacterFrameInset"], 'TOPRIGHT', 110, 0)
		else
			_G["CharacterFrameInsetRight"]:SetPoint(T.unpack(DefaultPosition.InsetDefaultPoint))
		end
	end)
end

--<<<<<Transmog functions>>>>>--
function CA:Transmog_OnEnter()
	self.Texture:SetVertexColor(1, .8, 1)

	_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	_G["GameTooltip"]:SetHyperlink(self.Link)
	_G["GameTooltip"]:Show()
end

function CA:Transmog_OnLeave()
	self.Texture:SetVertexColor(1, .5, 1)
	_G["GameTooltip"]:Hide()
end

function CA:Transmog_OnClick(button)

-- function CA:Transmogrify_OnClick(Button)
	local ItemName, ItemLink = T.GetItemInfo(self.Link)
	
	if not IsShiftKeyDown() then
		SetItemRef(ItemLink, ItemLink, 'LeftButton')
	else
		if HandleModifiedItemClick(ItemLink) then
		elseif _G["BrowseName"] and _G["BrowseName"]:IsVisible() then
			AuctionFrameBrowse_Reset(_G["BrowseResetButton"])
			_G["BrowseName"]:SetText(ItemName)
			_G["BrowseName"]:SetFocus()
		end
	end
end

--<<<<<Updating settings>>>>>--
function CA:Update_BG()
	if E.db.sle.armory.character.background.selectedBG == 'HIDE' then
		_G["PaperDollFrame"].SLE_Armory_BG:SetTexture(nil)
	elseif E.db.sle.armory.character.background.selectedBG == 'CUSTOM' then
		_G["PaperDollFrame"].SLE_Armory_BG:SetTexture(E.db.sle.armory.character.background.customTexture)
	elseif E.db.sle.armory.character.background.selectedBG == 'CLASS' then
		_G["PaperDollFrame"].SLE_Armory_BG:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\armory\]]..E.myclass)
	else
		_G["PaperDollFrame"].SLE_Armory_BG:SetTexture(SLE.ArmoryConfigBackgroundValues.BlizzardBackdropList[E.db.sle.armory.character.background.selectedBG] or [[Interface\AddOns\ElvUI_SLE\media\textures\armory\]]..E.db.sle.armory.character.background.selectedBG)
	end
	
	--CA:AdditionalTextures_Update()
end

function CA:Update_ItemLevel()
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		
		if Slot.iLvlText then
			Slot.iLvlText:ClearAllPoints()
			Slot.iLvlText:Point("TOP"..Slot.Direction, _G["Character"..SlotName], "TOP"..(Slot.Direction == "LEFT" and "RIGHT" or "LEFT"), Slot.Direction == "LEFT" and 2+E.db.sle.armory.character.ilvl.xOffset or -2-E.db.sle.armory.character.ilvl.xOffset, -1+E.db.sle.armory.character.ilvl.yOffset)
		end
	end
end

function CA:Update_Enchant()
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		
		if Slot.enchantText then
			Slot.enchantText:ClearAllPoints()
			Slot.enchantText:Point(Slot.Direction, _G["Character"..SlotName], Slot.Direction == "LEFT" and "RIGHT" or "LEFT", Slot.Direction == "LEFT" and 2+E.db.sle.armory.character.enchant.xOffset or -2-E.db.sle.armory.character.enchant.xOffset, 1+E.db.sle.armory.character.enchant.yOffset)
		end
	end
end

function CA:Update_Gems()
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		
		if Slot.textureSlot1 then
			Slot.textureSlot1:ClearAllPoints()
			Slot.textureSlot1:Point('BOTTOM'..Slot.Direction, _G["Character"..SlotName], "BOTTOM"..(Slot.Direction == "LEFT" and "RIGHT" or "LEFT"), Slot.Direction == "LEFT" and 2+E.db.sle.armory.character.gem.xOffset or -2-E.db.sle.armory.character.gem.xOffset, 2+E.db.sle.armory.character.gem.yOffset)
		end
	end
end

function CA:ElvOverlayToggle() --Toggle dat Overlay
	if E.db.sle.armory.character.background.overlay then
		_G["CharacterModelFrameBackgroundOverlay"]:Show()
	else
		_G["CharacterModelFrameBackgroundOverlay"]:Hide()
	end
end

function CA:Enable()
	-- Setting frame
	_G["CharacterFrame"]:SetHeight(444)

	-- Move right equipment slots
	_G["CharacterHandsSlot"]:SetPoint('TOPRIGHT', _G["CharacterFrameInsetRight"], 'TOPLEFT', -4, -2)

	-- Move bottom equipment slots
	_G["CharacterMainHandSlot"]:SetPoint('BOTTOMLEFT', _G["PaperDollItemsFrame"], 'BOTTOMLEFT', 185, 14)

	--Making model frame big enough
	_G["CharacterModelFrame"]:ClearAllPoints()
	_G["CharacterModelFrame"]:SetPoint('TOPLEFT', _G["CharacterHeadSlot"], 0, 5)
	_G["CharacterModelFrame"]:SetPoint('RIGHT', _G["CharacterHandsSlot"])
	_G["CharacterModelFrame"]:SetPoint('BOTTOM', _G["CharacterMainHandSlot"])

	if _G["PaperDollFrame"]:IsShown() then --Setting up width for the main frame
		_G["CharacterFrame"]:SetWidth(_G["CharacterFrame"].Expanded and 650 or 444)
		_G["CharacterFrameInsetRight"]:SetPoint('TOPLEFT', _G["CharacterFrameInset"], 'TOPRIGHT', 110, 0)
	end
	
	--This will hide default background stuff. I could make it being shown, but not feeling like figuring out how to stretch the damn texture.
	if _G["CharacterModelFrame"] and _G["CharacterModelFrame"].BackgroundTopLeft and _G["CharacterModelFrame"].BackgroundTopLeft:IsShown() then
		_G["CharacterModelFrame"].BackgroundTopLeft:Hide()
		_G["CharacterModelFrame"].BackgroundTopRight:Hide()
		_G["CharacterModelFrame"].BackgroundBotLeft:Hide()
		_G["CharacterModelFrame"].BackgroundBotRight:Hide()
		if _G["CharacterModelFrame"].backdrop then
			_G["CharacterModelFrame"].backdrop:Hide()
		end
	end

	--Overlay resize to match new width
	_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('TOPLEFT', _G["CharacterModelFrame"], -4, 0)
	_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('BOTTOMRIGHT', _G["CharacterModelFrame"], 4, 0)
	
	--Activating background
	_G["PaperDollFrame"].SLE_Armory_BG:Show()
	CA:Update_BG()
	CA:Update_ItemLevel()
	CA:Update_Enchant()
	CA:Update_Gems()
end

function CA:Disable()
	-- Setting frame to default
	_G["CharacterFrame"]:SetHeight(424)
	_G["CharacterFrame"]:SetWidth(_G["PaperDollFrame"]:IsShown() and _G["CharacterFrame"].Expanded and CHARACTERFRAME_EXPANDED_WIDTH or PANEL_DEFAULT_WIDTH)
	_G["CharacterFrameInsetRight"]:SetPoint(T.unpack(DefaultPosition.InsetDefaultPoint))
	
	-- Move rightside equipment slots to default position
	_G["CharacterHandsSlot"]:SetPoint('TOPRIGHT', _G["CharacterFrameInset"], 'TOPRIGHT', -4, -2)
	
	-- Move bottom equipment slots to default position
	_G["CharacterMainHandSlot"]:SetPoint('BOTTOMLEFT', _G["PaperDollItemsFrame"], 'BOTTOMLEFT', 130, 16)
	
	-- Model Frame
	_G["CharacterModelFrame"]:ClearAllPoints()
	_G["CharacterModelFrame"]:Size(231, 320)
	_G["CharacterModelFrame"]:SetPoint('TOPLEFT', _G["PaperDollFrame"], 'TOPLEFT', 52, -66)
	_G["CharacterModelFrame"].BackgroundTopLeft:Show()
	_G["CharacterModelFrame"].BackgroundTopRight:Show()
	_G["CharacterModelFrame"].BackgroundBotLeft:Show()
	_G["CharacterModelFrame"].BackgroundBotRight:Show()
	_G["CharacterModelFrame"].backdrop:Show()
	
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		-- if Slot.TransmogInfo then
			-- Slot.TransmogInfo:Hide()
			-- LCG.AutoCastGlow_Stop(Slot,"_TransmogGlow")
		-- end
		if Armory.Constants.CA_Defaults[SlotName] then
			for element, points in T.pairs(Armory.Constants.CA_Defaults[SlotName]) do
				Slot[element]:ClearAllPoints()
				Slot[element]:Point(T.unpack(points))
			end
		end
	end
	
	if _G["PaperDollFrame"].SLE_Armory_BG then _G["PaperDollFrame"].SLE_Armory_BG:Hide() end
end

function CA:ToggleArmory()
	if E.db.sle.armory.character.enable then
		CA:Enable()
	else
		CA:Disable()
	end
	for i, SlotName in T.pairs(Armory.Constants.AzeriteSlot) do PaperDollItemSlotButton_Update(_G["Character"..SlotName]) end
end

function CA:LoadAndSetup()
		CA:BuildLayout()
		CA:ToggleArmory()
		CA:ElvOverlayToggle()

end