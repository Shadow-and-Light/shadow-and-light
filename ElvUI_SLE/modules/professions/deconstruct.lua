local SLE, _, E, L, _, _, _ = unpack(select(2, ...))
local Pr = SLE.Professions
local B = E.Bags
local lib = LibStub('LibProcessable')
local LCG = LibStub('LibCustomGlow-1.0')

--GLOBALS: unpack, select, CreateFrame, VIDEO_OPTIONS_ENABLED, VIDEO_OPTIONS_DISABLED
local _G = _G
local format, strfind, strmatch, strsplit, gsub = format, strfind, strmatch, strsplit, gsub
local GetItemInfo, GetContainerItemLink, GetContainerItemInfo, GetTradeTargetItemLink = GetItemInfo, GetContainerItemLink, GetContainerItemInfo, GetTradeTargetItemLink
local InCombatLockdown = InCombatLockdown
local LOCKED = LOCKED
local ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow, AutoCastShine_AutoCastStart = ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow, AutoCastShine_AutoCastStart

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
	--Quest dis
	-- ['Quest'] = {
	-- 	['137195'] = true, -- Highmountain armor  --in libprocess, test if we need this now
	-- 	['137221'] = true, -- Enchanted Raven Sigil  --in libprocess, test if we need this now
	-- 	['137286'] = true, -- Fel-Crusted Rune  --in libprocess, test if we need this now
	-- 	['181991'] = true, -- Antique Stalker's Bow
	-- 	['182021'] = true, -- Antique Kyrian Javelin
	-- 	['182067'] = true, -- Antique Duelist's Rapier
	-- 	['182043'] = true, -- Antique Necromancer's Staff
	-- },
}
Pr.Keys = {
	[GetSpellInfo(195809)] = true, -- jeweled lockpick
	[GetSpellInfo(130100)] = true, -- Ghostly Skeleton Key
	[GetSpellInfo(94574)] = true, -- Obsidium Skeleton Key
	[GetSpellInfo(59403)] = true, -- Titanium Skeleton Key
	[GetSpellInfo(59404)] = true, -- Colbat Skeleton Key
	[GetSpellInfo(20709)] = true, -- Arcanite Skeleton Key
	[GetSpellInfo(19651)] = true, -- Truesilver Skeleton Key
	[GetSpellInfo(19649)] = true, -- Golden Skeleton Key
	[GetSpellInfo(19646)] = true, -- Silver Skeleton Key
}
Pr.BlacklistDE = {}
Pr.BlacklistLOCK = {}

local function HaveKey()
	for key in pairs(Pr.Keys) do
		if(GetItemCount(key) > 0) then
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
		local isLink = GetItemInfo(name)
		if isLink then
			Pr.BlacklistDE[isLink] = true
		end
	end
end

function Pr:BuildBlacklistLOCK(...)
	wipe(Pr.BlacklistLOCK)
	for index = 1, select('#', ...) do
		local name = select(index, ...)
		local isLink = GetItemInfo(name)
		if isLink then
			Pr.BlacklistLOCK[isLink] = true
		end
	end
end

function Pr:ApplyDeconstruct(itemLink, spell, spellType, r, g, b)
	local slot = GetMouseFocus()
	if slot == Pr.DeconstructionReal then return end
	local bag = slot:GetParent():GetID()
	if not _G["ElvUI_ContainerFrame"].Bags[bag] then return end
	Pr.DeconstructionReal.Bag = bag
	Pr.DeconstructionReal.Slot = slot:GetID()
	local color = {r,g,b,1}
	if (E.global.sle.LOCK.TradeOpen and GetTradeTargetItemLink(7) == itemLink and _G["GameTooltip"]:GetOwner():GetName() == "TradeRecipientItem7ItemButton") then
			Pr.DeconstructionReal.ID = strmatch(itemLink, 'item:(%d+):')
			Pr.DeconstructionReal:SetAttribute('type1', 'macro')
			Pr.DeconstructionReal:SetAttribute('macrotext', format('/cast %s\n/run ClickTargetTradeButton(7)', spell))
			Pr.DeconstructionReal:SetAllPoints(_G["TradeRecipientItem7ItemButton"])
			Pr.DeconstructionReal:Show()

			if E.private.sle.professions.deconButton.style == "BIG" then
				ActionButton_ShowOverlayGlow(Pr.DeconstructionReal)
			elseif E.private.sle.professions.deconButton.style == "SMALL" then
				-- AutoCastShine_AutoCastStart(Pr.DeconstructionReal, r, g, b)
				AutoCastShine_AutoCastStart(Pr.DeconstructionReal, color, 5,nil,2)
			end
		-- end
	elseif (GetContainerItemLink(bag, slot:GetID()) == itemLink) then
		Pr.DeconstructionReal.ID = strmatch(itemLink, 'item:(%d+):')
		Pr.DeconstructionReal:SetAttribute("type1",spellType)
		Pr.DeconstructionReal:SetAttribute(spellType, spell)
		Pr.DeconstructionReal:SetAttribute('target-bag', bag)
		Pr.DeconstructionReal:SetAttribute('target-slot', slot:GetID())
		Pr.DeconstructionReal:SetAllPoints(slot)
		Pr.DeconstructionReal:Show()

		if E.private.sle.professions.deconButton.style == "BIG" then
			-- ActionButton_ShowOverlayGlow(Pr.DeconstructionReal)
			ActionButton_ShowOverlayGlow(Pr.DeconstructionReal)
		elseif E.private.sle.professions.deconButton.style == "SMALL" then
			-- AutoCastShine_AutoCastStart(Pr.DeconstructionReal, r, g, b)
			LCG.AutoCastGlow_Start(Pr.DeconstructionReal, color, 5,nil,2)
		elseif E.private.sle.professions.deconButton.style == "PIXEL" then
			LCG.PixelGlow_Start(Pr.DeconstructionReal, color, nil, nil, nil, 4)
		end
	end
end

function Pr:IsBreakable(link)
	if not link then return false end
	local name, _, quality, _, _, _, _, _, equipSlot = GetItemInfo(link)
	local item = strmatch(link, 'item:(%d+):')
	if(IsEquippableItem(link) and quality and quality > 1 and quality < 5 and equipSlot ~= "INVTYPE_BAG") then
		if E.global.sle.DE.IgnoreTabards and equipSlot == "INVTYPE_TABARD" then return false end
		if Pr.ItemTable["DoNotDE"][item] then return false end
		if Pr.ItemTable["PandariaBoA"][item] and E.global.sle.DE.IgnorePanda then return false end
		if Pr.ItemTable["Cooking"][item] and E.global.sle.DE.IgnoreCooking then return false end
		if Pr.ItemTable["Fishing"][item] and E.global.sle.DE.IgnoreFishing then return false end
		if Pr.BlacklistDE[name] then return false end
		return true
	end
	return false
end

function Pr:IsUnlockable(itemLink)
	local slot = GetMouseFocus()
	local bag = slot:GetParent():GetID()
	local item = _G["TradeFrame"]:IsShown() and GetTradeTargetItemLink(7) or select(7, GetContainerItemInfo(bag, slot:GetID()))
	if(item == itemLink) then
		for index = 2, 5 do
			local info = _G['GameTooltipTextLeft' .. index]:GetText()
			if strfind(info, LOCKED) then
				return true
			end
		end
	end
	return false
end

function Pr:DeconstructParser(tt)
	if not Pr.DeconstructMode then return end

	local item, link = tt:GetItem()
	if not link then return end

	local owner = tt:GetOwner()
	local ownerName = owner and owner.GetName and owner:GetName()
	if ownerName and (strfind(ownerName, 'ElvUI_Container') or strfind(ownerName, 'ElvUI_BankContainer')) then
		local itemString = strmatch(link, "item[%-?%d:]+")
		if not itemString then return end

		local _, id = strsplit(":", itemString)
		if not id or id == "" then return end

		if(item and not InCombatLockdown()) and (Pr.DeconstructMode == true or (E.global.sle.LOCK.TradeOpen and self:GetOwner():GetName() == "TradeRecipientItem7ItemButton")) then
			local r, g, b
			if lib:IsOpenable(id) and Pr:IsUnlockable(link) then
				r, g, b = 0, 1, 1
				Pr:ApplyDeconstruct(link, Pr.LOCKname, "spell", r, g, b)
			elseif lib:IsOpenableProfession(id) and Pr:IsUnlockable(link) then
				r, g, b = 0, 1, 1
				local hasKey = HaveKey()
				Pr:ApplyDeconstruct(link, hasKey, "item", r, g, b)
			elseif lib:IsProspectable(id) then
				r, g, b = 1, 0, 0
				Pr:ApplyDeconstruct(link, Pr.PROSPECTname, "spell", r, g, b)
			elseif lib:IsMillable(id) then
				r, g, b = 1, 0, 0
				Pr:ApplyDeconstruct(link, Pr.MILLname, "spell", r, g, b)
			elseif Pr.DEname then
				local isArtRelic, class, subclass
				local normalItem = (lib:IsDisenchantable(id) and Pr:IsBreakable(link))
				if not normalItem then
					class, subclass = select(6, GetItemInfo(item))
					isArtRelic = (class == relicItemTypeLocalized and subclass == relicItemSubTypeLocalized)
				end
				-- if normalItem or Pr.ItemTable["Quest"][id] or isArtRelic then
				if normalItem or isArtRelic then
					r, g, b = 1, 0, 0
					Pr:ApplyDeconstruct(link, Pr.DEname, "spell", r, g, b)
				end
			end
		end
	end
end

function Pr:GetDeconMode()
	local text
	if Pr.DeconstructMode then
		text = "|cff00FF00 "..VIDEO_OPTIONS_ENABLED.."|r"
	else
		text = "|cffFF0000 "..VIDEO_OPTIONS_DISABLED.."|r"
	end
	return text
end

function Pr:Construct_BagButton()
	Pr.DeconstructButton = CreateFrame("Button", "SLE_DeconButton", _G["ElvUI_ContainerFrame"], "BackdropTemplate")
	Pr.DeconstructButton:SetSize(16 + E.Border, 16 + E.Border)
	Pr.DeconstructButton:SetTemplate()
	Pr.DeconstructButton.ttText = L["Deconstruct Mode"]
	Pr.DeconstructButton.ttText2 = format(L["Allow you to disenchant/mill/prospect/unlock items.\nClick to toggle.\nCurrent state: %s."], Pr:GetDeconMode())
	Pr.DeconstructButton:SetScript("OnEnter", B.Tooltip_Show)
	Pr.DeconstructButton:SetScript("OnLeave", GameTooltip_Hide)
	Pr.DeconstructButton:SetPoint("RIGHT", _G["ElvUI_ContainerFrame"].bagsButton, "LEFT", -5, 0)
	Pr.DeconstructButton:SetNormalTexture("Interface\\ICONS\\INV_Rod_Cobalt")
	Pr.DeconstructButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	Pr.DeconstructButton:GetNormalTexture():SetInside()

	Pr.DeconstructButton:StyleButton(nil, true)
	Pr.DeconstructButton:SetScript("OnClick", function(frame)
		Pr.DeconstructMode = not Pr.DeconstructMode
		if Pr.DeconstructMode then
			Pr.DeconstructButton:SetNormalTexture("Interface\\ICONS\\INV_Rod_EnchantedCobalt")
			if E.private.sle.professions.deconButton.buttonGlow then ActionButton_ShowOverlayGlow(Pr.DeconstructButton) end
		else
			Pr.DeconstructButton:SetNormalTexture("Interface\\ICONS\\INV_Rod_Cobalt")
			ActionButton_HideOverlayGlow(Pr.DeconstructButton)
		end
		Pr.DeconstructButton.ttText2 = format(L["Allow you to disenchant/mill/prospect/unlock items.\nClick to toggle.\nCurrent state: %s."], Pr:GetDeconMode())
		B.Tooltip_Show(frame)
	end)
	--Moving Elv's stuff
	_G["ElvUI_ContainerFrame"].vendorGraysButton:SetPoint("RIGHT", Pr.DeconstructButton, "LEFT", -5, 0)
end

function Pr:ConstructRealDecButton()
	Pr.DeconstructionReal = CreateFrame('Button', "SLE_DeconReal", E.UIParent, 'SecureActionButtonTemplate, AutoCastShineTemplate')
	Pr.DeconstructionReal:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
	Pr.DeconstructionReal:RegisterForClicks('AnyUp')
	Pr.DeconstructionReal:SetFrameStrata("TOOLTIP")
	Pr.DeconstructionReal.TipLines = {}

	Pr.DeconstructionReal.OnLeave = function(frame)
		if(InCombatLockdown()) then
			frame:SetAlpha(0)
			frame:RegisterEvent('PLAYER_REGEN_ENABLED')
		else
			frame:ClearAllPoints()
			frame:SetAlpha(1)
			if _G["GameTooltip"] then _G["GameTooltip"]:Hide() end
			frame:Hide()
			LCG.AutoCastGlow_Stop(frame)
			LCG.ButtonGlow_Stop(frame)
			ActionButton_HideOverlayGlow(frame)
		end
	end

	Pr.DeconstructionReal.SetTip = function(f)
		_G["GameTooltip"]:SetOwner(f,"ANCHOR_LEFT",0,4)
		_G["GameTooltip"]:ClearLines()
		_G["GameTooltip"]:SetBagItem(f.Bag, f.Slot)
	end

	Pr.DeconstructionReal:SetScript("OnEnter", Pr.DeconstructionReal.SetTip)
	Pr.DeconstructionReal:SetScript("OnLeave", function() Pr.DeconstructionReal:OnLeave() end)
	Pr.DeconstructionReal:Hide()

	function Pr.DeconstructionReal:PLAYER_REGEN_ENABLED()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		Pr.DeconstructionReal:OnLeave()
	end
end

local function Get_ArtRelic()
	local noItem = false
	if select(2, GetItemInfo(132342)) == nil then noItem = true end
	if noItem then
		E:Delay(5, Get_ArtRelic)
	else
		relicItemTypeLocalized, relicItemSubTypeLocalized = select(6, GetItemInfo(132342))
	end
end

function Pr:InitializeDeconstruct()
	if not E.private.bags.enable then return end
	Pr:Construct_BagButton()
	Pr:ConstructRealDecButton()

	local function Hiding()
		Pr.DeconstructMode = false
		Pr.DeconstructButton:SetNormalTexture("Interface\\ICONS\\INV_Rod_Cobalt")
		ActionButton_HideOverlayGlow(Pr.DeconstructButton)
		Pr.DeconstructionReal:OnLeave()
	end

	_G["ElvUI_ContainerFrame"]:HookScript("OnHide", Hiding)

	self:SecureHookScript(GameTooltip, "OnTooltipSetItem", "DeconstructParser")

	Pr:Blacklisting("DE")
	Pr:Blacklisting("LOCK")

	Get_ArtRelic()
end
