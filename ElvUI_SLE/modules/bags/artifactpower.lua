local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local AP = SLE:NewModule("ArtifactPowerBags", 'AceHook-3.0', 'AceEvent-3.0')
local B, DB = SLE:GetElvModules("Bags", "DataBars")

--GLOBALS: CreateFrame, hooksecurefunc
local _G = _G
local tooltipScanner
local tooltipName = "SLE_ArtifactPowerTooltipScanner"
local arcanePower
local pcall = pcall
local GetItemSpell = GetItemSpell

local shortValueDec
local function MoreShortValue(v)
	shortValueDec = format("%%.%df", E.db.general.decimalLength or 1)
	if E.db.general.numberPrefixStyle == "METRIC" then
		if abs(v) >= 1e9 then
			return format(shortValueDec.."G", v / 1e9)
		elseif abs(v) >= 10e7 then
			return format(shortValueDec.."G", v / 1e9)
		else
			return format(shortValueDec.."M", v / 1e6)
		end
	elseif E.db.general.numberPrefixStyle == "GERMAN" then
		if abs(v) >= 1e9 then
			return format(shortValueDec.."Mrd", v / 1e9)
		elseif abs(v) >= 10e7 then
			return format(shortValueDec.."Mrd", v / 1e9)
		else
			return format(shortValueDec.."Mio", v / 1e6)
		end
	else
		if abs(v) >= 1e9 then
			return format(shortValueDec.."B", v / 1e9)
		elseif abs(v) >= 10e7 then
			return format(shortValueDec.."B", v / 1e9)
		else
			return format(shortValueDec.."M", v / 1e6)
		end
	end
end

local function SlotUpdate(self, bagID, slotID)
	if (not bagID or not slotID) or bagID == -3 then return end
	if not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return;
	end
	
	local frame = self.Bags[bagID][slotID]
	if (not frame.artifactpowerinfo) and E.db.sle.bags.artifactPower.enable then
		frame.artifactpowerinfo = frame:CreateFontString(nil, 'OVERLAY')
		frame.artifactpowerinfo:Point("BOTTOMLEFT", 2, 2)
	end
	if (not frame.petLevelInfo) and E.db.sle.bags.petLevel.enable then
		frame.petLevelInfo = frame:CreateFontString(nil, 'OVERLAY')
		frame.petLevelInfo:Point("BOTTOMLEFT", 2, 2)
	end

	if E.db.sle.bags.artifactPower.enable then
		frame.artifactpowerinfo:FontTemplate(E.LSM:Fetch("font", E.db.sle.bags.artifactPower.fonts.font), E.db.sle.bags.artifactPower.fonts.size, E.db.sle.bags.artifactPower.fonts.outline)
		frame.artifactpowerinfo:SetText("")
		local r,g,b = E.db.sle.bags.artifactPower.color.r, E.db.sle.bags.artifactPower.color.g, E.db.sle.bags.artifactPower.color.b
		frame.artifactpowerinfo:SetTextColor(r, g, b)

		if (frame.artifactpowerinfo) then
			local ID = T.select(10, T.GetContainerItemInfo(bagID, slotID))
			local slotLink = T.GetContainerItemLink(bagID,slotID)
			if (ID and slotLink) then
				local arcanePower = DB:GetAPForItem(slotLink)
				if E.db.sle.bags.artifactPower.short and arcanePower and (arcanePower ~= "0" and arcanePower ~= 0) then
					if abs(arcanePower) >= 10e7 and E.db.bags.bagSize <= 37 and (E.db.general.numberPrefixStyle ~= "CHINESE" and E.db.general.numberPrefixStyle ~= "KOREAN") then
						arcanePower = MoreShortValue(arcanePower)
					else
						arcanePower = E:ShortValue(arcanePower)
					end
					frame.artifactpowerinfo:SetText(arcanePower)
				end
			end
		end
	elseif not E.db.sle.bags.artifactPower.enable and frame.artifactpowerinfo then
		frame.artifactpowerinfo:SetText("")
	end
	
	if E.db.sle.bags.petLevel.enable then 
		frame.petLevelInfo:FontTemplate(E.LSM:Fetch("font", E.db.sle.bags.petLevel.fonts.font), E.db.sle.bags.petLevel.fonts.size, E.db.sle.bags.petLevel.fonts.outline)
		frame.petLevelInfo:SetText("")
		local r,g,b = E.db.sle.bags.petLevel.color.r, E.db.sle.bags.petLevel.color.g, E.db.sle.bags.petLevel.color.b
		frame.petLevelInfo:SetTextColor(r, g, b)
		
		local itemLink, _, _, ID = T.select(7, T.GetContainerItemInfo(bagID, slotID))
		if not ID then return end
		local itemSubType = T.select(7,T.GetItemInfo(ID))
		if itemSubType == AP.PetSubType then
			local itemString = T.gsub(itemLink, "|H", "")
			local _, _, level = T.split(":", itemString)
			frame.petLevelInfo:SetText(level)
		else
			frame.petLevelInfo:SetText("")
		end
	elseif not E.db.sle.bags.petLevel.enable and frame.petLevelInfo then
		frame.petLevelInfo:SetText("")
	end
end

function AP:GET_ITEM_INFO_RECEIVED(event, ID)
	if ID ~= 82800 then return end
	AP.PetSubType = T.select(7,T.GetItemInfo(82800))
	if not itemName then AP:RegisterEvent("GET_ITEM_INFO_RECEIVED") return end
	if event == "GET_ITEM_INFO_RECEIVED" then AP:UnregisterEvent("GET_ITEM_INFO_RECEIVED") end
end

function AP:Initialize()
	if not SLE.initialized or not E.private.bags.enable then return end

	tooltipScanner = CreateFrame("GameTooltip", tooltipName, nil, "GameTooltipTemplate")
	tooltipScanner:SetOwner(E.UIParent, "ANCHOR_NONE")
	
	--Getting battle pet subtype
	AP:GET_ITEM_INFO_RECEIVED(nil, 82800)

	hooksecurefunc(B,"UpdateSlot", SlotUpdate)
	hooksecurefunc(_G["ElvUI_ContainerFrame"],"UpdateSlot", SlotUpdate)
	self:RegisterEvent("BANKFRAME_OPENED", function()
		AP:UnregisterEvent("BANKFRAME_OPENED")
		B:Layout()
	end)
end
SLE:RegisterModule(AP:GetName())