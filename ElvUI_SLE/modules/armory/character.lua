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

--Changing the looks of the window
function CA:BuildLayout()
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
	_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('TOPLEFT', _G["CharacterModelFrame"], -8, 0)
	_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('BOTTOMRIGHT', _G["CharacterModelFrame"], 8, 0)

	--<< Background >>--
	_G["PaperDollFrame"].SLE_Armory_BG = _G["PaperDollFrame"]:CreateTexture(nil, 'OVERLAY')
	_G["PaperDollFrame"].SLE_Armory_BG:Point('TOPLEFT', _G["CharacterModelFrame"], -4, 5)
	_G["PaperDollFrame"].SLE_Armory_BG:Point('BOTTOMRIGHT', _G["CharacterModelFrame"], 4, 0)
	CA:Update_BG()
	
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

		-- Azerite
		hooksecurefunc(_G["Character"..SlotName], "SetAzeriteItem", function(self, itemLocation)
			-- if not CA[SlotName].AzeriteAnchor then return end
			if not itemLocation then
				-- CA[SlotName].AzeriteAnchor:Hide()
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
				return
			end
			-- self.AzeriteTexture:Hide()
			-- self.AvailableTraitFrame:Hide()
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
		if Slot.iLvlText then
			local a,b,c,d,e = Slot.iLvlText:GetPoint()
			Slot.iLvlText:Point(a,b,c,d,e + 100)
			a,b,c,d,e = Slot.textureSlot1:GetPoint()
			Slot.textureSlot1:Point(a,b,c,d,e + 200)
		end
	end
	
	--<<<Hooking some shit!>>>--

	-- hooksecurefunc('CharacterFrame_Collapse', function() if Info.CharacterArmory_Activate and _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(448) end end)
	-- hooksecurefunc('CharacterFrame_Expand', function() if Info.CharacterArmory_Activate and _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(650) end end)
	hooksecurefunc('CharacterFrame_Collapse', function()
		if not E.db.sle.armory.character.enable then return end
		if _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(448) end
	end)
	hooksecurefunc('CharacterFrame_Expand', function()
		if not E.db.sle.armory.character.enable then return end
		if _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(650) end
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
	--[[hooksecurefunc('PaperDollFrame_SetLevel', function()
		-- if Info.CharacterArmory_Activate then 
		_G["CharacterLevelText"]:SetText(_G["CharacterLevelText"]:GetText())
			--_G["PaperDollFrame"] was self in old days
			_G["CharacterFrameTitleText"]:ClearAllPoints()
			_G["CharacterFrameTitleText"]:Point('TOP', _G["PaperDollFrame"], 0, 35)
			_G["CharacterFrameTitleText"]:SetParent(_G["PaperDollFrame"])
			_G["CharacterLevelText"]:ClearAllPoints()
			_G["CharacterLevelText"]:SetPoint('TOP', _G["CharacterFrameTitleText"], 'BOTTOM', 0, 2)
			_G["CharacterLevelText"]:SetParent(_G["PaperDollFrame"])
		-- end
	end)]]
end

--Changing shit back
function CA:UnbuildLayout()
	-- Setting frame to default
	_G["CharacterFrame"]:SetHeight(424)
	_G["CharacterFrame"]:SetWidth(_G["PaperDollFrame"]:IsShown() and _G["CharacterFrame"].Expanded and CHARACTERFRAME_EXPANDED_WIDTH or PANEL_DEFAULT_WIDTH)
	--print(_G["CharacterFrame"]:GetWidth())
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
		if Armory.Constants.CA_Defaults[SlotName] then
			for element, points in T.pairs(Armory.Constants.CA_Defaults[SlotName]) do
				Slot[element]:Point(T.unpack(points))
			end
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

function CA:ElvOverlayToggle() --Toggle dat Overlay
	if E.db.sle.armory.character.background.overlay then
		_G["CharacterModelFrameBackgroundOverlay"]:Show()
	else
		_G["CharacterModelFrameBackgroundOverlay"]:Hide()
	end
end

function CA:LoadAndSetup()
		if E.db.sle.armory.character.enable then
			CA:BuildLayout()
			-- CA:ElvOverlayToggle()
		else
			CA:UnbuildLayout()
		end

	print("Woooooooooooooooo")
end