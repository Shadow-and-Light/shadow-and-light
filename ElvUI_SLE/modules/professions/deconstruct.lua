local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Pr = SLE.Professions
local B = E.Bags
local lib = LibStub('LibProcessable')
local LCG = E.Libs.CustomGlow

--GLOBALS: unpack, select, CreateFrame, VIDEO_OPTIONS_ENABLED, VIDEO_OPTIONS_DISABLED
local _G = _G
local format, strfind, strsplit, gsub, type, tostring = format, strfind, strsplit, gsub, type, tostring
local GetTradeTargetItemLink = GetTradeTargetItemLink
local InCombatLockdown = InCombatLockdown
local LOCKED = LOCKED
local ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow, AutoCastShine_AutoCastStart = ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow, AutoCastShine_AutoCastStart

local C_Container_GetContainerItemLink = C_Container.GetContainerItemLink
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo

local C_Spell_GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local C_Item_GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local C_Item_GetItemCount = C_Item and C_Item.GetItemCount or GetItemCount

Pr.DeconstructMode = false
local relicItemTypeLocalized, relicItemSubTypeLocalized
Pr.ItemTable = {
	--Stuff that can't be DEed or should not be by default
	['DoNotDE']={
		['49715'] = true, --Rose helm
		['44731'] = true, --Rose offhand
		['21524'] = true, --Red winter veil hat
		['51525'] = true, --Green winter vail hat
		['70923'] = true, --Sweater
		['34486'] = true, --Orgri achieve fish
		['11287'] = true, --Lesser Magic Wand
		['11288'] = true, --Greater Magic Wand
		['116985'] = true, --Archeology Mail Hat
		['136629'] = true, --Eng reagent rifle
		['136630'] = true, --Eng reagent rifle 2
		['201160'] = true, --Ench crafted toy
		['201161'] = true, --Ench crafted toy
		['200472'] = true, --Ench crafted toy
		['200535'] = true, --Ench crafted toy
	},
	--Bnet bound treasures in Pandaria
	['PandariaBoA'] = {
		['85776'] = true,['85777'] = true,['86124'] = true,['86196'] = true,['86198'] = true,
		['86199'] = true,['86218'] = true,['86394'] = true,['86518'] = true,['86519'] = true,
		['86520'] = true,['86521'] = true,['86522'] = true,['86523'] = true,['86524'] = true,
		['86527'] = true,['86529'] = true,['88723'] = true,
		['86525'] = true, --Not really a BoA but still a powerful shit
		['86526'] = true, --Not really a BoA but still a powerful shit
	},
	--Stuff with cooking bonus
	['Cooking'] = {
		['46349'] = true, --Chef's Hat
		['86559'] = true, --Frying Pan
		['86558'] = true, --Rolling Pin
		['86468'] = true, --Apron
	},
	--Stuff for fishing
	['Fishing'] = {
		['33820'] = true, --Weather-Beaten Fishing Hat
		['118393'] = true, --Tentacled Hat
		['19022'] = true, --Nat Pagle's Extreme Angler FC-5000
		['19970'] = true, --Arcanite Fishing Pole
		['25978'] = true, --Seth's Graphite Fishing Pole
		['44050'] = true, --Mastercraft Kalu'ak Fishing Pole
		['45858'] = true, --Nat's Lucky Fishing Pole
		['45991'] = true, --Bone Fishing Pole
		['45992'] = true, --Jeweled Fishing Pole
	},
}
Pr.Keys = {
	[C_Spell_GetSpellInfo(195809)] = true, -- jeweled lockpick
	[C_Spell_GetSpellInfo(130100)] = true, -- Ghostly Skeleton Key
	[C_Spell_GetSpellInfo(94574)] = true, -- Obsidium Skeleton Key
	[C_Spell_GetSpellInfo(59403)] = true, -- Titanium Skeleton Key
	[C_Spell_GetSpellInfo(59404)] = true, -- Colbat Skeleton Key
	[C_Spell_GetSpellInfo(20709)] = true, -- Arcanite Skeleton Key
	[C_Spell_GetSpellInfo(19651)] = true, -- Truesilver Skeleton Key
	[C_Spell_GetSpellInfo(19649)] = true, -- Golden Skeleton Key
	[C_Spell_GetSpellInfo(19646)] = true, -- Silver Skeleton Key
}
Pr.BlacklistDE = {}
Pr.BlacklistLOCK = {}

local function HaveKey()
	for key in pairs(Pr.Keys) do
		if(C_Item_GetItemCount(key) > 0) then
			return key
		end
	end
end

function Pr:Blacklisting(skill)
	local ignoreItems = E.global.sle[skill].Blacklist
	ignoreItems = gsub(ignoreItems, ',%s', ',') --remove spaces that follow a comma
	Pr['BuildBlacklist'..skill](self, strsplit(',', ignoreItems))
end

function Pr:BuildBlacklistDE(...)
	wipe(Pr.BlacklistDE)
	for index = 1, select('#', ...) do
		local name = select(index, ...)
		local isLink = C_Item_GetItemInfo(name)
		if isLink then
			Pr.BlacklistDE[isLink] = true
		end
	end
end

function Pr:BuildBlacklistLOCK(...)
	wipe(Pr.BlacklistLOCK)
	for index = 1, select('#', ...) do
		local name = select(index, ...)
		local isLink = C_Item_GetItemInfo(name)
		if isLink then
			Pr.BlacklistLOCK[isLink] = true
		end
	end
end

function Pr:ApplyDeconstruct(itemLink, itemId, spell, spellType, r, g, b, slot)
	if not slot then return end
	if slot == Pr.DeconstructionReal then return end

	local bag = slot:GetParent():GetID()
	if not _G.ElvUI_ContainerFrame.Bags[bag] then return end
	Pr.DeconstructionReal.Bag = bag
	Pr.DeconstructionReal.Slot = slot:GetID()
	local color = {r,g,b,1}

	if (E.global.sle.LOCK.TradeOpen and GetTradeTargetItemLink(7) == itemLink and _G.GameTooltip:GetOwner():GetName() == 'TradeRecipientItem7ItemButton') then
		Pr.DeconstructionReal.ID = itemId
		Pr.DeconstructionReal:SetAttribute('type1', 'macro')
		Pr.DeconstructionReal:SetAttribute('macrotext', format('/cast %s\n/run ClickTargetTradeButton(7)', spell))
		Pr.DeconstructionReal:SetAllPoints(_G.TradeRecipientItem7ItemButton)
		Pr.DeconstructionReal:Show()

		if E.private.sle.professions.deconButton.style == 'BIG' then
			ActionButton_ShowOverlayGlow(Pr.DeconstructionReal)
		elseif E.private.sle.professions.deconButton.style == 'SMALL' then
			AutoCastShine_AutoCastStart(Pr.DeconstructionReal, color, 5,nil,2)
		end
	elseif (C_Container_GetContainerItemLink(bag, slot:GetID()) == itemLink) and Pr.PROSPECTname == spell then
		Pr.DeconstructionReal.ID = itemId
		Pr.DeconstructionReal:SetAttribute('type1', 'macro')
		Pr.DeconstructionReal:SetAttribute('macrotext', format('/run C_TradeSkillUI.CraftRecipe(374627, 1, {})\n/click %s', format('ElvUI_ContainerFrameBag%dSlot%d', Pr.DeconstructionReal.Bag, Pr.DeconstructionReal.Slot)))
		Pr.DeconstructionReal:SetAllPoints(slot)
		Pr.DeconstructionReal:Show()
		if E.private.sle.professions.deconButton.style == 'BIG' then
			ActionButton_ShowOverlayGlow(Pr.DeconstructionReal)
		elseif E.private.sle.professions.deconButton.style == 'SMALL' then
			-- AutoCastShine_AutoCastStart(Pr.DeconstructionReal, r, g, b)
			LCG.AutoCastGlow_Start(Pr.DeconstructionReal, color, 5, nil, 2)
		elseif E.private.sle.professions.deconButton.style == 'PIXEL' then
			LCG.PixelGlow_Start(Pr.DeconstructionReal, color, nil, nil, nil, 4)
		end
	elseif (C_Container_GetContainerItemLink(bag, slot:GetID()) == itemLink) then
		Pr.DeconstructionReal.ID = itemId
		Pr.DeconstructionReal:SetAttribute('type1', spellType)
		Pr.DeconstructionReal:SetAttribute(spellType, spell)
		Pr.DeconstructionReal:SetAttribute('target-bag', Pr.DeconstructionReal.Bag)
		Pr.DeconstructionReal:SetAttribute('target-slot', Pr.DeconstructionReal.Slot)
		Pr.DeconstructionReal:SetAllPoints(slot)
		Pr.DeconstructionReal:Show()

		if E.private.sle.professions.deconButton.style == 'BIG' then
			ActionButton_ShowOverlayGlow(Pr.DeconstructionReal)
		elseif E.private.sle.professions.deconButton.style == 'SMALL' then
			-- AutoCastShine_AutoCastStart(Pr.DeconstructionReal, r, g, b)
			LCG.AutoCastGlow_Start(Pr.DeconstructionReal, color, 5, nil, 2)
		elseif E.private.sle.professions.deconButton.style == 'PIXEL' then
			LCG.PixelGlow_Start(Pr.DeconstructionReal, color, nil, nil, nil, 4)
		end
	end
end

function Pr:IsBreakable(itemId, itemName, itemQuality, equipSlot)
	if not itemId then return false end
	if type(itemId) == "number" then itemId = tostring(itemId) end
	if (E.global.sle.DE.IgnoreTabards and equipSlot == 'INVTYPE_TABARD') or (Pr.ItemTable['DoNotDE'][itemId]) or (Pr.ItemTable['PandariaBoA'][itemId] and E.global.sle.DE.IgnorePanda) or (Pr.ItemTable['Cooking'][itemId] and E.global.sle.DE.IgnoreCooking) or (Pr.ItemTable['Fishing'][itemId] and E.global.sle.DE.IgnoreFishing) or Pr.BlacklistDE[itemName] then return false end
	return true
end

function Pr:IsUnlockable(itemLink)
	local workLink
	if _G.TradeFrame:IsShown() then
		workLink = GetTradeTargetItemLink(7)
	else
		local slot = GetMouseFoci()[1]
		local bag = slot:GetParent():GetID()
		local itemInfo = C_Container_GetContainerItemInfo(bag, slot:GetID())
		workLink = itemInfo.hyperlink
	end
	if(workLink == itemLink) then
		for index = 2, 5 do
			local info = _G['GameTooltipTextLeft' .. index]:GetText()
			if strfind(info, LOCKED) then
				return true
			end
		end
	end
	return false
end

function Pr:DeconstructParser(data)
	if not Pr.DeconstructMode or not data then return end
	if (self ~= GameTooltip and self ~= _G.ShoppingTooltip1 and self ~= _G.ShoppingTooltip1) or self:IsForbidden() then return end

	local owner = self:GetOwner()
	local ownerName = owner and owner.GetName and owner:GetName()
	if ownerName and (strfind(ownerName, 'ElvUI_Container') or strfind(ownerName, 'ElvUI_BankContainer')) then
		local itemId = data and data.id
		if not itemId or itemId == '' then return end

		local hyperlink
		if data.guid then
			hyperlink = C_Item.GetItemLinkByGUID(data.guid)
		elseif data.hyperlink then
			hyperlink = data.hyperlink;
		end

		if not hyperlink then return end

		if(itemId and not InCombatLockdown()) and (Pr.DeconstructMode == true or (E.global.sle.LOCK.TradeOpen and self:GetOwner():GetName() == 'TradeRecipientItem7ItemButton')) then
			local r, g, b
			if lib:IsOpenable(itemId) and Pr:IsUnlockable(hyperlink) then
				r, g, b = 0, 1, 1
				Pr:ApplyDeconstruct(hyperlink, itemId, Pr.LOCKname, 'spell', r, g, b, owner)
			elseif lib:IsOpenableProfession(itemId) and Pr:IsUnlockable(hyperlink) then
				r, g, b = 0, 1, 1
				local hasKey = HaveKey()
				Pr:ApplyDeconstruct(hyperlink, itemId, hasKey, 'item', r, g, b, owner)
			elseif lib:IsProspectable(itemId) then
				r, g, b = 1, 0, 0
				Pr:ApplyDeconstruct(hyperlink, itemId, Pr.PROSPECTname, 'macro', r, g, b, owner)
			elseif lib:IsMillable(itemId) then
				r, g, b = 1, 0, 0
				Pr:ApplyDeconstruct(hyperlink, itemId, Pr.MILLname, 'spell', r, g, b, owner)
			elseif Pr.DEname then
				local isArtRelic
				local itemName, _, itemQuality, _, _, itemClass, itemSubclass, _, equipSlot = GetItemInfo(itemId)
				local normalItem = (lib:IsDisenchantable(itemId) and Pr:IsBreakable(itemId, itemName, itemQuality, equipSlot))
				if not normalItem then
					isArtRelic = (itemClass == relicItemTypeLocalized and itemSubclass == relicItemSubTypeLocalized)
				end
				if normalItem or isArtRelic then
					r, g, b = 1, 0, 0
					Pr:ApplyDeconstruct(hyperlink, itemId, Pr.DEname, 'spell', r, g, b, owner)
				end
			end
		end
	end
end

function Pr:GetDeconMode()
	local text
	if Pr.DeconstructMode then
		text = '|cff00FF00 '..VIDEO_OPTIONS_ENABLED..'|r'
	else
		text = '|cffFF0000 '..VIDEO_OPTIONS_DISABLED..'|r'
	end
	return text
end

function Pr:Construct_BagButton()
	Pr.DeconstructButton = CreateFrame('Button', 'SLE_DeconButton', _G.ElvUI_ContainerFrame, 'BackdropTemplate')
	Pr.DeconstructButton:SetSize(16 + E.Border, 16 + E.Border)
	Pr.DeconstructButton:SetTemplate()
	Pr.DeconstructButton.ttText = L["Deconstruct Mode"]
	Pr.DeconstructButton.ttText2 = format(L["Allow you to disenchant/mill/prospect/unlock items.\nClick to toggle.\nCurrent state: %s."], Pr:GetDeconMode())
	Pr.DeconstructButton:SetScript('OnEnter', B.Tooltip_Show)
	Pr.DeconstructButton:SetScript('OnLeave', GameTooltip_Hide)
	Pr.DeconstructButton:SetPoint('RIGHT', _G.ElvUI_ContainerFrame.bagsButton, 'LEFT', -5, 0)
	Pr.DeconstructButton:SetNormalTexture([[Interface\ICONS\INV_Rod_Cobalt]])
	Pr.DeconstructButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	Pr.DeconstructButton:GetNormalTexture():SetInside()

	Pr.DeconstructButton:StyleButton(nil, true)
	Pr.DeconstructButton:SetScript('OnClick', function(frame)
		Pr.DeconstructMode = not Pr.DeconstructMode
		if Pr.DeconstructMode then
			Pr.DeconstructButton:SetNormalTexture([[Interface\ICONS\INV_Rod_EnchantedCobalt]])
			if E.private.sle.professions.deconButton.buttonGlow then ActionButton_ShowOverlayGlow(Pr.DeconstructButton) end
		else
			Pr.DeconstructButton:SetNormalTexture([[Interface\ICONS\INV_Rod_Cobalt]])
			ActionButton_HideOverlayGlow(Pr.DeconstructButton)
		end
		Pr.DeconstructButton.ttText2 = format(L["Allow you to disenchant/mill/prospect/unlock items.\nClick to toggle.\nCurrent state: %s."], Pr:GetDeconMode())
		B.Tooltip_Show(frame)
	end)
	--Moving Elv's stuff
	_G.ElvUI_ContainerFrame.vendorGraysButton:SetPoint('RIGHT', Pr.DeconstructButton, 'LEFT', -5, 0)
end

function Pr:ConstructRealDecButton()
	Pr.DeconstructionReal = CreateFrame('Button', 'SLE_DeconReal', E.UIParent, 'SecureActionButtonTemplate')
	Pr.DeconstructionReal:SetScript('OnEvent', function(obj, event, ...) obj[event](obj, ...) end)
	Pr.DeconstructionReal:RegisterForClicks('AnyUp', 'AnyDown')
	Pr.DeconstructionReal:SetFrameStrata('TOOLTIP')

	Pr.DeconstructionReal.OnLeave = function(frame)
		if InCombatLockdown() then
			frame:SetAlpha(0)
			frame:RegisterEvent('PLAYER_REGEN_ENABLED')
		else
			frame:ClearAllPoints()
			frame:SetAlpha(1)
			if _G.GameTooltip then _G.GameTooltip:Hide() end
			LCG.AutoCastGlow_Stop(frame)
			LCG.PixelGlow_Stop(frame)
			ActionButton_HideOverlayGlow(frame)
			frame:Hide()
		end
	end

	Pr.DeconstructionReal.SetTip = function(f)
		_G.GameTooltip:SetOwner(f,'ANCHOR_LEFT',0,4)
		_G.GameTooltip:ClearLines()
		_G.GameTooltip:SetBagItem(f.Bag, f.Slot)
	end

	Pr.DeconstructionReal:SetScript('OnEnter', Pr.DeconstructionReal.SetTip)
	Pr.DeconstructionReal:SetScript('OnLeave', function() Pr.DeconstructionReal:OnLeave() end)
	Pr.DeconstructionReal:Hide()

	function Pr.DeconstructionReal:PLAYER_REGEN_ENABLED()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		Pr.DeconstructionReal:OnLeave()
	end
end

local function Get_ArtRelic()
	local noItem = false
	if select(2, C_Item_GetItemInfo(132342)) == nil then noItem = true end
	if noItem then
		E:Delay(5, Get_ArtRelic)
	else
		relicItemTypeLocalized, relicItemSubTypeLocalized = select(6, C_Item_GetItemInfo(132342))
	end
end

function Pr:InitializeDeconstruct()
	if not E.private.bags.enable then return end
	Pr:Construct_BagButton()
	Pr:ConstructRealDecButton()

	local function OnHide()
		Pr.DeconstructMode = false
		Pr.DeconstructButton:SetNormalTexture([[Interface\ICONS\INV_Rod_Cobalt]])
		ActionButton_HideOverlayGlow(Pr.DeconstructButton)
		Pr.DeconstructionReal:OnLeave()
	end

	_G.ElvUI_ContainerFrame:HookScript('OnHide', OnHide)
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, Pr.DeconstructParser)

	Pr:Blacklisting('DE')
	Pr:Blacklisting('LOCK')

	Get_ArtRelic()
end
