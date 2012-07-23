local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
--CharacterFrame:HookScript("OnShow", function( self ) PaperDollSidebarTabs:SetPoint("BOTTOMRIGHT", CharacterFrameInsetRight, "TOPRIGHT", -5, 0) end)
OutfitterFrame:HookScript("OnShow", function( self ) 
	self:StripTextures()
	self:SetTemplate("Transparent")
	OutfitterFrameTab1:Size(60,25)
	OutfitterFrameTab2:Size(60,25)
	OutfitterFrameTab3:Size(60,25)
	for i = 0,13 do
		if _G["OutfitterItem"..i.."OutfitMenu"] then 
			S:HandleNextPrevButton(_G["OutfitterItem"..i.."OutfitMenu"])
			_G["OutfitterItem"..i.."OutfitMenu"]:Size(16)
		end
		if _G["OutfitterItem"..i.."OutfitSelected"] then 
			S:HandleButton(_G["OutfitterItem"..i.."OutfitSelected"])
			_G["OutfitterItem"..i.."OutfitSelected"]:ClearAllPoints()
			_G["OutfitterItem"..i.."OutfitSelected"]:Size(16)
			_G["OutfitterItem"..i.."OutfitSelected"]:Point("LEFT", _G["OutfitterItem"..i.."Outfit"], "LEFT", 8, 0)
		end
	end
	end)

OutfitterMainFrame:StripTextures()
OutfitterMainFrameScrollbarTrench:StripTextures()
OutfitterFrameTab1:StripTextures()
OutfitterFrameTab2:StripTextures()
OutfitterFrameTab3:StripTextures()
OutfitterFrameTab1:ClearAllPoints()
OutfitterFrameTab2:ClearAllPoints()
OutfitterFrameTab3:ClearAllPoints()
OutfitterFrameTab1:Point("TOPLEFT", OutfitterFrame, "BOTTOMRIGHT", -65, -2)
OutfitterFrameTab2:Point("LEFT", OutfitterFrameTab1, "LEFT", -65, 0)
OutfitterFrameTab3:Point("LEFT", OutfitterFrameTab2, "LEFT", -65, 0)
S:HandleButton(OutfitterFrameTab1, true)
OutfitterFrameTab1:Size(60,25)
S:HandleButton(OutfitterFrameTab2, true)
OutfitterFrameTab2:Size(60,25)
S:HandleButton(OutfitterFrameTab3, true)
S:HandleButton(OutfitterButton, true)
OutfitterButton:ClearAllPoints()
OutfitterButton:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", -8, -30)
PaperDollSidebarTab3:ClearAllPoints()
PaperDollSidebarTab3:Point("RIGHT", OutfitterButton, "LEFT", -6, 0)

S:HandleScrollBar(OutfitterMainFrameScrollFrameScrollBar)
S:HandleCloseButton(OutfitterCloseButton)
S:HandleButton(OutfitterNewButton, true)
S:HandleButton(OutfitterEnableNone, true)
S:HandleButton(OutfitterEnableAll, true)

function cDesaturate(f, point)
	for i=1, f:GetNumRegions() do
		local region = select(i, f:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetDesaturated(1)
			
			if region:GetTexture() == "Interface\\DialogFrame\\UI-DialogBox-Corner" then
				region:Kill()
			end
		end
	end	
	
	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end
cDesaturate(OutfitterButton)

OutfitterButton:SetHighlightTexture(nil)
OutfitterSlotEnables:SetFrameStrata("HIGH")
OutfitterButton:StripTextures()
OutfitterButton:Size(32, 20)
OutfitterButton.tex = OutfitterButton:CreateTexture(nil, 'OVERLAY')
OutfitterButton.tex:Point('TOPLEFT', OutfitterButton, 'TOPLEFT', 1, -1)
OutfitterButton.tex:Point('BOTTOMRIGHT', OutfitterButton, 'BOTTOMRIGHT', -1, 1)
OutfitterButton.tex:SetTexture("Interface\\AddOns\\ElvUI_SLE\\textures\\outfitter")
OutfitterSlotEnables:SetFrameStrata("HIGH")
OutfitterShowOutfitBar:Point("TOPLEFT", OutfitterAutoSwitch, "BOTTOMLEFT", 0, -5)

	local CheckBoxButtons = {
		"OutfitterEnableHeadSlot",
		"OutfitterEnableNeckSlot",
		"OutfitterEnableShoulderSlot",
		"OutfitterEnableBackSlot",
		"OutfitterEnableChestSlot",
		"OutfitterEnableShirtSlot",
		"OutfitterEnableTabardSlot",
		"OutfitterEnableWristSlot",
		"OutfitterEnableMainHandSlot",
		"OutfitterEnableSecondaryHandSlot",
		"OutfitterEnableRangedSlot",
		"OutfitterEnableHandsSlot",
		"OutfitterEnableWaistSlot",
		"OutfitterEnableLegsSlot",
		"OutfitterEnableFeetSlot",
		"OutfitterEnableFinger0Slot",
		"OutfitterEnableFinger1Slot",
		"OutfitterEnableTrinket0Slot",
		"OutfitterEnableTrinket1Slot",
	}

	for _, object in pairs(CheckBoxButtons) do
		S:HandleCheckBox(_G[object])
		print("pooc test")
		_G[object]:SetFrameStrata("HIGH")
		_G[object]:SetFrameLevel(5)
	end

	local BoxButtons = {
		"OutfitterItemComparisons",
		"OutfitterTooltipInfo",
		"OutfitterShowHotkeyMessages",
		"OutfitterShowMinimapButton",
		"OutfitterShowOutfitBar",
		"OutfitterAutoSwitch",
	}
	for _, object in pairs(BoxButtons) do
		S:HandleCheckBox(_G[object])
		_G[object]:Size(20)
	end
end

S:RegisterSkin('Outfitter', LoadSkin)