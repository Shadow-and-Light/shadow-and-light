local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Fishing = SLE.Fishing
local FishLib = LibStub('LibFishing-1.0')

local IsFishingLoot = IsFishingLoot
local GetNumLootItems = GetNumLootItems

local lastLure, castTime
local castingLure = false

local function HideAwayAll()
	if not castTime then
		castTime = Fishing:ScheduleRepeatingTimer('PostCastUpdate', 1)
	end
end

local key_actions = {
	--* Try alt as an option maybe?
	-- ['none'] = function(mouse) return mouse ~= 'right' end,
	['shift'] = function(mouse) return IsShiftKeyDown() end,
	['control'] = function(mouse) return IsControlKeyDown() end,
	['alt'] = function(mouse) return IsAltKeyDown() end
}

local function CastingKeys()
	local castKey = E.db.sle.professions.fishing.castKey
	local mouseButton = E.db.sle.professions.fishing.mouseButton

	if castKey and key_actions[castKey] then
		return key_actions[castKey](mouseButton)
	else
		return false
	end
end

local function HijackCheck()
	if InCombatLockdown() then return end
	
	if CastingKeys() or FishLib:IsFishingReady() then
		return true
	end
end

local function SetupLure()
	if not E.db.sle.professions.fishing.useLure or castingLure then return end

	if FishLib:IsFishingPole() then
		local pole, enchant = FishLib:GetPoleBonus()
		local state, bestLure = FishLib:FindBestLure(enchant, 0, true)
		if state and bestLure then
			FishLib:InvokeLuring(bestLure.id)
			castingLure = true
			lastLure = bestLure

			return true
		end
	end

	return false
end

function Fishing:PostCastUpdate()
	local stop = true
	if InCombatLockdown() then return end

	if castingLure then
		local spellName = UnitChannelInfo('player')
		local _, lure = FishLib:GetPoleBonus()
		if not spellName or (lure and lure == lastLure.b) then
			castingLure = false
			FishLib:UpdateLureInventory()
		else
			stop = false
		end
	end
	if stop and castTime then
		Fishing:CancelTimer(castTime)
		castTime = nil
	end
end

function Fishing:ButtonOptions()
	local ButtonOptions ={
		right = 'RightButtonUp',
		button4 = 'Button4Up',
		button5 = 'Button5Up'
	}
	return ButtonOptions[E.db.sle.professions.fishing.mouseButton] or 'RightButtonUp'
end

function Fishing:GLOBAL_MOUSE_DOWN(...)
	local button = select(2, ...)
	
	if FishLib:CheckForDoubleClick(button) and HijackCheck() then
		if IsMouselooking() then MouselookStop() end

		if not SetupLure() then
			FishLib:InvokeFishing()
		end

		FishLib:OverrideClick(HideAwayAll)
	end
end

function Fishing:LOOT_OPENED()
	if not IsFishingLoot() then return end

	if E.db.sle.professions.fishing.autoLoot and (GetCVar('autoLootDefault') ~= '1' ) then
		for index = 1, GetNumLootItems(), 1 do
			LootSlot(index)
		end
	end

	FishLib:ExtendDoubleClick()
	LureState = 0
end

Fishing.EventsRegistered = {
	GLOBAL_MOUSE_DOWN = false,
	LOOT_OPENED = false,
}

function Fishing:ToggleOptions()
	if E.db.sle.professions.fishing.easyCast and not Fishing.EventsRegistered['GLOBAL_MOUSE_DOWN'] then
		Fishing:RegisterEvent('GLOBAL_MOUSE_DOWN')
		Fishing.EventsRegistered['GLOBAL_MOUSE_DOWN'] = true
	elseif not E.db.sle.professions.fishing.easyCast and Fishing.EventsRegistered['GLOBAL_MOUSE_DOWN'] then
		Fishing:UnregisterEvent('GLOBAL_MOUSE_DOWN')
		Fishing.EventsRegistered['GLOBAL_MOUSE_DOWN'] = false
	end
	
	if E.db.sle.professions.fishing.autoLoot and not Fishing.EventsRegistered['LOOT_OPENED'] then
		Fishing:RegisterEvent('LOOT_OPENED')
		Fishing.EventsRegistered['LOOT_OPENED'] = true
	elseif not E.db.sle.professions.fishing.autoLoot and Fishing.EventsRegistered['LOOT_OPENED'] then
		Fishing:UnregisterEvent('LOOT_OPENED')
		Fishing.EventsRegistered['LOOT_OPENED'] = false
	end
end

function Fishing:Initialize()
	if not SLE.initialized then return end

	Fishing:ToggleOptions()
	FishLib:CreateSAButton()
	FishLib:SetSAMouseEvent(Fishing:ButtonOptions())
end
SLE:RegisterModule('Fishing')
