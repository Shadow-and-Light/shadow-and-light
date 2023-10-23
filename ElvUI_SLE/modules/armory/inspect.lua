local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Armory = SLE.Armory_Core
local IA = SLE.Armory_Inspect
local M = E.Misc

local _G = _G

--Adding new stuffs for armory only
function IA:BuildLayout()
	InspectGuildFrameBanner:ClearAllPoints()
	InspectGuildFrameBanner:Point('TOP', InspectFrameInset, 'TOP', 0, -4)

	--<< Background >>--
	if not _G.InspectPaperDollFrame.SLE_Armory_BG then
		_G.InspectPaperDollFrame.SLE_Armory_BG = _G.InspectPaperDollFrame:CreateTexture(nil, 'OVERLAY')
		_G.InspectPaperDollFrame.SLE_Armory_BG:Point('TOPLEFT', _G.InspectModelFrame, -4, 0)
		_G.InspectPaperDollFrame.SLE_Armory_BG:Point('BOTTOMRIGHT', _G.InspectModelFrame, 4, 0)
	end
	_G.InspectPaperDollFrame.SLE_Armory_BG:Hide()

	for _, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G['Inspect'..SlotName]
		Slot.ID = GetInventorySlotInfo(SlotName)

		--<<Create gems>>--
		for t = 1, Armory.Constants.MaxGemSlots do
			if Slot['textureSlot'..t] then
				Slot['SLE_Gem'..t] = CreateFrame('Frame', nil, Slot)
				Slot['SLE_Gem'..t]:SetPoint('TOPLEFT', Slot['textureSlot'..t])
				Slot['SLE_Gem'..t]:SetPoint('BOTTOMRIGHT', Slot['textureSlot'..t])
				Slot['SLE_Gem'..t]:SetScript('OnEnter', Armory.Gem_OnEnter)
				Slot['SLE_Gem'..t]:SetScript('OnLeave', Armory.Tooltip_OnLeave)
				--Variables for use in some stuff
				Slot['SLE_Gem'..t].frame = 'inspect'
			end
		end

		--<<Gradation>>--
		if Slot.iLvlText then
			Slot.SLE_Gradient = Slot:CreateTexture(nil, 'BACKGROUND')
			Slot.SLE_Gradient:SetPoint(Slot.Direction, Slot, Slot.Direction, 0, 0)
			Slot.SLE_Gradient:Size(132, 41)
			Slot.SLE_Gradient:SetTexture(Armory.Constants.GradientTexture)
			Slot.SLE_Gradient:SetVertexColor(unpack(E.db.sle.armory.inspect.gradient.color))
			if Slot.Direction == 'LEFT' then
				Slot.SLE_Gradient:SetTexCoord(0, 1, 0, 1)
			else
				Slot.SLE_Gradient:SetTexCoord(1, 0, 0, 1)
			end
			Slot.iLvlText:SetTextColor(1, 1, 1)
			Slot.SLE_Gradient:Hide()
		end

		--<<Missing Warning>>--
		Slot.SLE_Warning = CreateFrame('Frame', nil, Slot)
		if SlotName == 'MainHandSlot' or SlotName == 'SecondaryHandSlot' then
			Slot.SLE_Warning:Size(41, 8)
			Slot.SLE_Warning:SetPoint('TOP', Slot, 'BOTTOM', 0, 0)
		else
			Slot.SLE_Warning:Size(8, 41)
			Slot.SLE_Warning:SetPoint(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot, Slot.Direction, 0, 0)
		end
		Slot.SLE_Warning.frame = 'inspect'

		Slot.SLE_Warning.texture = Slot.SLE_Warning:CreateTexture(nil, 'BACKGROUND')
		Slot.SLE_Warning.texture:SetInside()
		Slot.SLE_Warning.texture:SetTexture(Armory.Constants.WarningTexture)
		Slot.SLE_Warning.texture:SetVertexColor(unpack(E.db.sle.armory.inspect.gradient.warningColor))

		Slot.SLE_Warning:SetScript('OnEnter', Armory.Warning_OnEnter)
		Slot.SLE_Warning:SetScript('OnLeave', Armory.Tooltip_OnLeave)
		Slot.SLE_Warning:Hide()

		--<<Transmog>>--
		if Armory.Constants.CanTransmogrify[SlotName] then
			Slot.TransmogInfo = CreateFrame('Button', SlotName..'_SLE_TransmogInfo', Slot)
			Slot.TransmogInfo:Size(12)
			Slot.TransmogInfo:SetFrameLevel(Slot:GetFrameLevel() + 2)
			Slot.TransmogInfo:Point('BOTTOM'..Slot.Direction, Slot, Slot.Direction == 'LEFT' and -2 or 2, -1)
			Slot.TransmogInfo:SetScript('OnEnter', Armory.Transmog_OnEnter)
			Slot.TransmogInfo:SetScript('OnLeave', Armory.Transmog_OnLeave)
			Slot.TransmogInfo:SetScript('OnClick', Armory.Transmog_OnClick)

			Slot.TransmogInfo.Texture = Slot.TransmogInfo:CreateTexture(nil, 'OVERLAY')
			Slot.TransmogInfo.Texture:SetInside()
			Slot.TransmogInfo.Texture:SetTexture(Armory.Constants.TransmogTexture)
			Slot.TransmogInfo.Texture:SetVertexColor(1, 0.5, 1)

			Slot.TransmogInfo.isInspect = true

			if Slot.Direction == 'LEFT' then
				Slot.TransmogInfo.Texture:SetTexCoord(0, 1, 0, 1)
			else
				Slot.TransmogInfo.Texture:SetTexCoord(1, 0, 0, 1)
			end

			Slot.TransmogInfo:Hide()
		end
	end

	do --<<Check Transmog>>--
		_G.InspectFrame.SLE_TransmogViewButton = CreateFrame('Button', nil, _G.InspectPaperDollFrame, 'BackdropTemplate')
		_G.InspectFrame.SLE_TransmogViewButton:Size(30)
		_G.InspectFrame.SLE_TransmogViewButton:Point('BOTTOMRIGHT', _G.InspectHandsSlot, 'TOPRIGHT', 0, 4)
		_G.InspectFrame.SLE_TransmogViewButton:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		_G.InspectFrame.SLE_TransmogViewButton.texture = _G.InspectFrame.SLE_TransmogViewButton:CreateTexture(nil, 'OVERLAY')
		_G.InspectFrame.SLE_TransmogViewButton.texture:SetInside()
		_G.InspectFrame.SLE_TransmogViewButton.texture:SetTexture([[Interface\ICONS\INV_Misc_Desecrated_PlateChest]])
		_G.InspectFrame.SLE_TransmogViewButton.texture:SetTexCoord(unpack(E.TexCoords))

		_G.InspectFrame.SLE_TransmogViewButton:SetScript('OnEnter', function(frame)
			frame:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
			GameTooltip:SetOwner(frame, 'ANCHOR_TOP')
			GameTooltip:SetText(VIEW_IN_DRESSUP_FRAME)
			GameTooltip:Show()
		end)
		_G.InspectFrame.SLE_TransmogViewButton:SetScript('OnLeave', function(frame)
			frame:SetBackdropBorderColor(1, 1, 1)
			_G.GameTooltip:Hide()
		end)
		_G.InspectFrame.SLE_TransmogViewButton:SetScript('OnClick', function()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			DressUpItemTransmogInfoList(C_TransmogCollection.GetInspectItemTransmogInfoList())
		end)
	end
end

function IA:Update_BG()
	if not (_G.InspectPaperDollFrame or E.db.sle.armory.inspect.enable) then return end
	if E.db.sle.armory.inspect.background.selectedBG == 'HIDE' then
		_G.InspectPaperDollFrame.SLE_Armory_BG:SetTexture(nil)
	elseif E.db.sle.armory.inspect.background.selectedBG == 'CUSTOM' then
		_G.InspectPaperDollFrame.SLE_Armory_BG:SetTexture(E.db.sle.armory.inspect.background.customTexture)
	elseif E.db.sle.armory.inspect.background.selectedBG == 'CLASS' then
		local class = UnitExists('target') and select(2, UnitClass('target')) or E.myclass
		_G.InspectPaperDollFrame.SLE_Armory_BG:SetAtlas('dressingroom-background-'..class)
	elseif E.db.sle.armory.inspect.background.selectedBG == 'Covenant' then
		local covenant = SLE.ArmoryConfigBackgroundValues.Covenants[C_Covenants.GetActiveCovenantID()]
		local bgtexture = SLE:TextureExists([[Interface\AddOns\ElvUI_SLE\media\textures\armory\Cov_]]..covenant) and [[Interface\AddOns\ElvUI_SLE\media\textures\armory\Cov_]]..covenant or nil

		_G.InspectPaperDollFrame.SLE_Armory_BG:SetTexture(bgtexture)
	elseif E.db.sle.armory.inspect.background.selectedBG == 'Covenant2' then
		local covenant = SLE.ArmoryConfigBackgroundValues.Covenants[C_Covenants.GetActiveCovenantID()]
		local bgtexture = (SLE:TextureExists([[Interface\AddOns\ElvUI_SLE\media\textures\armory\Cov_]]..covenant..'2') and [[Interface\AddOns\ElvUI_SLE\media\textures\armory\Cov_]]..covenant..'2') or (SLE:TextureExists([[Interface\AddOns\ElvUI_SLE\media\textures\armory\Cov_]]..covenant) and [[Interface\AddOns\ElvUI_SLE\media\textures\armory\Cov_]]..covenant) or nil

		_G.InspectPaperDollFrame.SLE_Armory_BG:SetTexture(bgtexture)
	else
		_G.InspectPaperDollFrame.SLE_Armory_BG:SetTexture(SLE.ArmoryConfigBackgroundValues.BlizzardBackdropList[E.db.sle.armory.inspect.background.selectedBG] or [[Interface\AddOns\ElvUI_SLE\media\textures\armory\]]..E.db.sle.armory.inspect.background.selectedBG)
	end

	--CA:AdditionalTextures_Update()
end

function IA:Update_ItemLevel()
	for _, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G['Inspect'..SlotName]
		if not Slot then return end

		if Slot.iLvlText then
			Slot.iLvlText:ClearAllPoints()
			Slot.iLvlText:Point('TOP'..Slot.Direction, _G['Inspect'..SlotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2+E.db.sle.armory.inspect.ilvl.xOffset or -2-E.db.sle.armory.inspect.ilvl.xOffset, -1+E.db.sle.armory.inspect.ilvl.yOffset)
		end
	end
end

function IA:Update_Enchant()
	for _, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G['Inspect'..SlotName]
		if not Slot then return end

		if Slot.enchantText then
			Slot.enchantText:ClearAllPoints()
			Slot.enchantText:Point(Slot.Direction, _G['Inspect'..SlotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2+E.db.sle.armory.inspect.enchant.xOffset or -2-E.db.sle.armory.inspect.enchant.xOffset, 1+E.db.sle.armory.inspect.enchant.yOffset)
		end
	end
end

function IA:Update_Gems()
	for _, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G['Inspect'..SlotName]
		if not Slot then return end

		if Slot.textureSlot1 then
			Slot.textureSlot1:ClearAllPoints()
			Slot.textureSlot1:Point('BOTTOM'..Slot.Direction, _G['Inspect'..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2+E.db.sle.armory.inspect.gem.xOffset or -2-E.db.sle.armory.inspect.gem.xOffset, 2+E.db.sle.armory.inspect.gem.yOffset)
			for i = 1, Armory.Constants.MaxGemSlots do Slot['textureSlot'..i]:Size(E.db.sle.armory.inspect.gem.size) end
		end
	end
end

function IA:ElvOverlayToggle() --Toggle dat Overlay
	if not _G.InspectFrame then return end
	if E.db.sle.armory.inspect.background.overlay then
		_G.InspectModelFrameBackgroundOverlay:Show()
	else
		_G.InspectModelFrameBackgroundOverlay:Hide()
	end
end

function IA:Enable()
	if not _G.InspectFrame then return end
	_G.InspectFrame:Size(450, 444)

	_G.InspectFrame.ItemLevelText:ClearAllPoints()
	_G.InspectFrame.ItemLevelText:Point('BOTTOM',_G.InspectModelFrame, 'TOP', 0, 2)

	-- Move bottom equipment slots
	_G.InspectMainHandSlot:SetPoint('BOTTOMLEFT', _G.InspectPaperDollItemsFrame, 'BOTTOMLEFT', 185, 14)

	--Making model frame big enough
	_G.InspectModelFrame:ClearAllPoints()
	_G.InspectModelFrame:SetPoint('TOPLEFT', _G.InspectHeadSlot, 0, 5)
	_G.InspectModelFrame:SetPoint('RIGHT', _G.InspectHandsSlot)
	_G.InspectModelFrame:SetPoint('BOTTOM', _G.InspectMainHandSlot)

	_G.InspectPaperDollFrame.ViewButton:Hide()
	_G.InspectFrame.SLE_TransmogViewButton:Show()

	--This will hide default background stuff. I could make it being shown, but not feeling like figuring out how to stretch the damn texture.
	if _G.InspectModelFrame and _G.InspectModelFrame.BackgroundTopLeft and _G.InspectModelFrame.BackgroundTopLeft:IsShown() then
		_G.InspectModelFrame.BackgroundTopLeft:Hide()
		_G.InspectModelFrame.BackgroundTopRight:Hide()
		_G.InspectModelFrame.BackgroundBotLeft:Hide()
		_G.InspectModelFrame.BackgroundBotRight:Hide()
		if _G.InspectModelFrame.backdrop then
			_G.InspectModelFrame.backdrop:Hide()
		end
	end

	_G.InspectModelFrameBackgroundOverlay:SetPoint('TOPLEFT', _G.InspectModelFrame, -4, 0)
	_G.InspectModelFrameBackgroundOverlay:SetPoint('BOTTOMRIGHT', _G.InspectModelFrame, 4, 0)

	--Activating background and updating stuff
	_G.InspectPaperDollFrame.SLE_Armory_BG:Show()
	IA:Update_BG()
	IA:Update_ItemLevel()
	IA:Update_Enchant()
	IA:Update_Gems()

	if E.db.general.itemLevel.displayInspectInfo then M:UpdateInspectInfo() end
end

function IA:Disable()
	if not _G.InspectFrame then return end
	_G.InspectFrame:Size(338, 424)

	-- Move bottom equipment slots to default position
	_G.InspectMainHandSlot:SetPoint('BOTTOMLEFT', _G.InspectPaperDollItemsFrame, 'BOTTOMLEFT', 130, 16)

	-- Model Frame
	_G.InspectModelFrame:ClearAllPoints()
	_G.InspectModelFrame:Size(231, 320)
	_G.InspectModelFrame:SetPoint('TOPLEFT', _G.InspectPaperDollFrame, 'TOPLEFT', 52, -66)
	_G.InspectModelFrame.BackgroundTopLeft:Show()
	_G.InspectModelFrame.BackgroundTopRight:Show()
	_G.InspectModelFrame.BackgroundBotLeft:Show()
	_G.InspectModelFrame.BackgroundBotRight:Show()
	_G.InspectModelFrame.backdrop:Show()

	_G.InspectPaperDollFrame.ViewButton:Show()
	_G.InspectFrame.SLE_TransmogViewButton:Hide()

	for _, SlotName in pairs(Armory.Constants.GearList) do
		local Slot = _G['Inspect'..SlotName]
		if Armory.Constants.Inspect_Defaults[SlotName] then
			for element, points in pairs(Armory.Constants.Inspect_Defaults[SlotName]) do
				Slot[element]:ClearAllPoints()
				Slot[element]:Point(unpack(points))
			end
		end
		if Slot.textureSlot1 then
			for i = 1, Armory.Constants.MaxGemSlots do Slot['textureSlot'..i]:Size(14) end
		end
		if Slot.SLE_Warning then Slot.SLE_Warning:Hide() end
	end

	if _G.InspectPaperDollFrame.SLE_Armory_BG then _G.InspectPaperDollFrame.SLE_Armory_BG:Hide() end
	_G.InspectFrame.ItemLevelText:ClearAllPoints()
	_G.InspectFrame.ItemLevelText:Point('BOTTOMLEFT', 6, 6)
end

function IA:ToggleArmory()
	if E.db.sle.armory.inspect.enable then
		IA:Enable()
	else
		IA:Disable()
	end
	M:UpdateInspectPageFonts('Inspect')
end

function IA:PreSetup()
	IA:RegisterEvent('INSPECT_READY', function()
		if not E.db.general.itemLevel.displayInspectInfo then
			Armory:UpdateInspectInfo()
			IA:UnregisterEvent('INSPECT_READY')
			M:ClearPageInfo(_G.InspectFrame, 'Inspect')
		end
	end)
end

function IA:LoadAndSetup()
	IA:BuildLayout()
	IA:ToggleArmory()
	IA:ElvOverlayToggle()
	--For future use. I may consider returning to cache for inspect. Cause it actually never broke
	-- _G["InspectFrame"]:UnregisterEvent("PLAYER_TARGET_CHANGED")
end
