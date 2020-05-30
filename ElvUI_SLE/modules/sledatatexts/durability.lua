local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local DTP = SLE:GetModule('Datatexts')

local HEADSLOT, SHOULDERSLOT, CHESTSLOT, WRISTSLOT, HANDSSLOT, WAISTSLOT, LEGSSLOT, FEETSLOT, MAINHANDSLOT, SECONDARYHANDSLOT = HEADSLOT, SHOULDERSLOT, CHESTSLOT, WRISTSLOT, HANDSSLOT, WAISTSLOT, LEGSSLOT, FEETSLOT, MAINHANDSLOT, SECONDARYHANDSLOT
local ToggleCharacter = ToggleCharacter
local DURABILITY = DURABILITY
local InCombatLockdown = InCombatLockdown
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemLink = GetInventoryItemLink
local GetMoneyString = GetMoneyString

function DTP:HookDurabilityDT()
	local displayString, lastPanel = DURABILITY..": %s%d%%|r"
	local displayStringa = ""
	local repairCostString = REPAIR_COST
	local tooltipString = "%d%%"
	local invDurability = {}
	local totalDurability = 0

	local slots = {
		[1] = _G.INVTYPE_HEAD,
		[3] = _G.INVTYPE_SHOULDER,
		[5] = _G.INVTYPE_CHEST,
		[6] = _G.INVTYPE_WAIST,
		[7] = _G.INVTYPE_LEGS,
		[8] = _G.INVTYPE_FEET,
		[9] = _G.INVTYPE_WRIST,
		[10] = _G.INVTYPE_HAND,
		[16] = _G.INVTYPE_WEAPONMAINHAND,
		[17] = _G.INVTYPE_WEAPONOFFHAND,
	}

	local function OnEvent(self, event, ...)
		lastPanel = self
		totalDurability = 100
		totalRepairCost = 0

		for index in pairs(slots) do
			local current, max = GetInventoryItemDurability(index)

			if current then
				invDurability[index] = (current/max)*100

				if ((current/max) * 100) < totalDurability then
					totalDurability = (current/max) * 100
				end

				totalRepairCost = totalRepairCost + select(3, E.ScanTooltip:SetInventoryItem("player", index))
			end
		end

		if totalDurability <= E.db.sle.dt.durability.threshold then
			E:Flash(self, 0.53, true)
		else
			E:StopFlash(self)
		end

		if E.db.sle.dt.durability.gradient then
			local r,g,b = E:ColorGradient(totalDurability * .01, .9,.2,.2, .9,.9,.2, .2,.9,.2)
			local hex = E:RGBToHex(r,g,b)

			self.text:SetFormattedText(displayString, hex, totalDurability)
		else
			self.text:SetFormattedText(displayStringa, totalDurability)
		end
	end

	local function Click()
		if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end
		ToggleCharacter("PaperDollFrame")
	end

	local function OnEnter(self)
		DT:SetupTooltip(self)

		for slot, durability in pairs(invDurability) do
			DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t  %s', GetInventoryItemTexture("player", slot), GetInventoryItemLink("player", slot)), format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, 0, 0, 1, 1, 0, 0, 1, 0))
		end

		if totalRepairCost > 0 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine(repairCostString, GetMoneyString(totalRepairCost), .6, .8, 1, 1, 1, 1)
		end

		DT.tooltip:Show()
	end

	local function ValueColorUpdate(hex, r, g, b)
		displayStringa = strjoin("", DURABILITY, ": ", hex, "%d%%|r")

		if lastPanel ~= nil then
			OnEvent(lastPanel, 'ELVUI_COLOR_UPDATE')
		end
	end
	E.valueColorUpdateFuncs[ValueColorUpdate] = true

	DT:RegisterDatatext('Durability', 'S&L', {'LOADING_SCREEN_DISABLED', "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW"}, OnEvent, nil, Click, OnEnter)
end
