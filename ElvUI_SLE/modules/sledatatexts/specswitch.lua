local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DT = E:GetModule('DataTexts')
local DTP = SLE:GetModule('Datatexts')

-- GLOBALS: PlayerTalentFrame, LoadAddOn
local format = string.format

local EasyMenu = EasyMenu
local GetLootSpecialization = GetLootSpecialization
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local HideUIPanel = HideUIPanel
local IsShiftKeyDown = IsShiftKeyDown
local ShowUIPanel = ShowUIPanel
local SetSpecialization = SetSpecialization
local SetLootSpecialization = SetLootSpecialization
local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT

local menuFrame = _G["LootSpecializationDatatextClickMenu"]
local menuList = {
	{ text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
	{ notCheckable = true, func = function() SetLootSpecialization(0) end },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true }
}
local specList = {
	{ text = SPECIALIZATION, isTitle = true, notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true }
}

function DTP:ReplaceSpecSwitch()
	DT.RegisteredDataTexts["Talent/Loot Specialization"].onClick = function(self, button)
		local specIndex = GetSpecialization();
		if not specIndex then return end

		if button == "LeftButton" then
			DT.tooltip:Hide()
			if not PlayerTalentFrame then
				LoadAddOn("Blizzard_TalentUI")
			end
			if IsShiftKeyDown() then 
				if not PlayerTalentFrame:IsShown() then
					ShowUIPanel(PlayerTalentFrame)
				else
					HideUIPanel(PlayerTalentFrame)
				end
			else
				for index = 1, 4 do
					local id, name, _, texture = GetSpecializationInfo(index);
					if ( id ) then
						specList[index + 1].text = format('|T%s:14:14:0:0:64:64:4:60:4:60|t  %s', texture, name)
						specList[index + 1].func = function() SetSpecialization(index) end
					else
						specList[index + 1] = nil
					end
				end
				EasyMenu(specList, menuFrame, "cursor", E.private.sle.dt.specswitch.xOffset, E.private.sle.dt.specswitch.yOffset, "MENU", 2)
			end
		else
			DT.tooltip:Hide()
			local _, specName = GetSpecializationInfo(specIndex);
			menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, specName);

			for index = 1, 4 do
				local id, name = GetSpecializationInfo(index);
				if ( id ) then
					menuList[index + 2].text = name
					menuList[index + 2].func = function() SetLootSpecialization(id) end
				else
					menuList[index + 2] = nil
				end
			end
			EasyMenu(menuList, menuFrame, "cursor", E.private.sle.dt.specswitch.xOffset, E.private.sle.dt.specswitch.yOffset, "MENU", 2)
		end
	end
end