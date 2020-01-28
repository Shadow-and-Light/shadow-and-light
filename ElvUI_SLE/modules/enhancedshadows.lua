local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if SLE._Compatibility["ElvUI_NihilistUI"] then return end
local ES = SLE:NewModule('EnhancedShadows', 'AceEvent-3.0')
local AB, UF = SLE:GetElvModules("ActionBars", "UnitFrames")
local ClassColor = RAID_CLASS_COLORS[E.myclass]
local Border, LastSize
local Abars = 10
--GLOBALS: hooksecurefunc
local _G = _G
local UnitAffectingCombat = UnitAffectingCombat

--Registered shadows table
ES.CreatedShadows = {}

--The table for frames groupped based on similariy
ES.FramesToShadow = {
	["UFrames"] = {
		--unit, FrameName var
		{"player", "Player"},
		{"target", "Target"},
		{"targettarget", "TargetTarget"},
		{"focus", "Focus"},
		{"focustarget", "FocusTarget"},
		{"pet", "Pet"},
		{"pettarget", "PetTarget"},
	},
	["UGroups"] = {
		--unit, FrameName var, number of frames
		{"boss", "Boss", 5},
		{"arena", "Arena", 5},
	},
	["Datapanels"] = {
		["leftchat"] = "LeftChatDataPanel",
		["rightchat"] = "RightChatDataPanel",
		["panel1"] = "SLE_DataPanel_1",
		["panel2"] = "SLE_DataPanel_2",
		["panel3"] = "SLE_DataPanel_3",
		["panel4"] = "SLE_DataPanel_4",
		["panel5"] = "SLE_DataPanel_5",
		["panel6"] = "SLE_DataPanel_6",
		["panel7"] = "SLE_DataPanel_7",
		["panel8"] = "SLE_DataPanel_8",
		-- ["leftminipanel"] = "LeftMiniPanel",
		-- ["rightminipanel"] = "RightMiniPanel",
	},
}

--Updating all shadows
function ES:UpdateShadows()
	if UnitAffectingCombat('player') then ES:RegisterEvent('PLAYER_REGEN_ENABLED', ES.UpdateShadows) return end

	for frame, _ in T.pairs(ES.CreatedShadows) do
		ES:UpdateShadow(frame)
	end
end

--Update specific shadow
function ES:UpdateShadow(shadow)
	local ShadowColor = E.db.sle.shadows.shadowcolor
	local r, g, b = ShadowColor['r'], ShadowColor['g'], ShadowColor['b']
	if E.db.sle.shadows.classcolor then r, g, b = ClassColor['r'], ClassColor['g'], ClassColor['b'] end

	local size = E.db.sle.shadows.size
	shadow:SetOutside(shadow:GetParent(), size, size)
	shadow:SetBackdrop({
		edgeFile = Border, edgeSize = E:Scale(size > 3 and size or 3),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(r, g, b, 0)
	shadow:SetBackdropBorderColor(r, g, b, 0.9)
end

--Regestering shadows and putting them to a table for easy tracking since they don't have actual names
function ES:RegisterShadow(shadow)
	if not shadow or shadow.isRegistered then return end
	ES.CreatedShadows[shadow] = true
	shadow.isRegistered = true
end

--Update shadows for UF, hooked to UF's own update function
function ES:UpdateFrame(frame, db)
	if not frame then return end
	local size = E.db.sle.shadows.size
	if frame.Health and frame.Health.EnhShadow then
		frame.Health.EnhShadow:SetOutside(frame.Health, size, size)
	end
	if frame.Power and frame.Power.EnhShadow then
		frame.Power.EnhShadow:SetOutside(frame.Power, size, size)
	end
	if frame.EnhShadow then
		frame.EnhShadow:SetOutside(frame, size, size)
	end
end

--Creating shadows for provided frame
function ES:CreateFrameShadow(frame, parent, legacy)
	if not frame then return end
	if not legacy then --If using new style with health and power having separated shadows
		--UF Health
		if frame.Health then
			frame.Health:CreateShadow()
			frame.Health.EnhShadow = frame.Health.shadow
			frame.Health.shadow = nil
			ES:RegisterShadow(frame.Health.EnhShadow)
			frame.Health.EnhShadow:SetParent(frame.Health)
		end
		--UF Power
		if frame.Power then
			frame.Power:CreateShadow()
			frame.Power.EnhShadow = frame.Power.shadow
			frame.Power.shadow = nil
			ES:RegisterShadow(frame.Power.EnhShadow)
			frame.Power.EnhShadow:SetParent(frame.Power)
		end
	end
	--if it is not UF at all or old way is enabled
	if legacy or (not frame.Health and not frame.Power) then
		frame:CreateShadow()
		frame.EnhShadow = frame.shadow
		frame.shadow = nil
		ES:RegisterShadow(frame.EnhShadow)
		if parent and parent ~= "none" then
			frame.EnhShadow:SetParent(parent)
		elseif not parent then
			frame.EnhShadow:SetParent(frame)
		end
	end
end

function ES:CreateShadows()
	--Unitframes--
	do
		for i = 1, #ES.FramesToShadow.UFrames do
			local unit, name = T.unpack(ES.FramesToShadow.UFrames[i])
			if E.private.sle.module.shadows[unit] then
				ES:CreateFrameShadow(_G["ElvUF_"..name],_G["ElvUF_"..name], E.private.sle.module.shadows[unit.."Legacy"])
				hooksecurefunc(UF, "Update_"..name.."Frame", ES.UpdateFrame)
			end
		end
		for i = 1, #ES.FramesToShadow.UGroups do
			local unit, name, num = T.unpack(ES.FramesToShadow.UGroups[i])
			if E.private.sle.module.shadows[unit] then
				for j = 1, num do
					ES:CreateFrameShadow(_G["ElvUF_"..name..j], _G["ElvUF_"..name..j], E.private.sle.module.shadows[unit.."Legacy"])
					hooksecurefunc(UF, "Update_"..name.."Frames", ES.UpdateFrame)
				end
			end
		end
	end
	--Actionbars--
	do
		for i=1, Abars do
			if E.private.sle.module.shadows.actionbars["bar"..i] then ES:CreateFrameShadow( _G["ElvUI_Bar"..i],  _G["ElvUI_Bar"..i].backdrop) end
			if E.private.sle.module.shadows.actionbars["bar"..i.."buttons"] then
				for j = 1, 12 do ES:CreateFrameShadow(_G["ElvUI_Bar"..i.."Button"..j], _G["ElvUI_Bar"..i.."Button"..j].backdrop) end
			end
		end
		if E.private.sle.module.shadows.actionbars.stancebar then ES:CreateFrameShadow(_G["ElvUI_StanceBar"], _G["ElvUI_StanceBar"].backdrop) end
		if E.private.sle.module.shadows.actionbars.stancebarbuttons then
			for i = 1, 12 do
				if not _G["ElvUI_StanceBarButton"..i] then break end
				ES:CreateFrameShadow(_G["ElvUI_StanceBarButton"..i], _G["ElvUI_StanceBarButton"..i].backdrop)
			end
		end
		if E.private.sle.module.shadows.actionbars.microbar then ES:CreateFrameShadow(_G["ElvUI_MicroBar"], "none") end
		if E.private.sle.module.shadows.actionbars.microbarbuttons then
			for i=1, (#MICRO_BUTTONS) do
				if not _G[MICRO_BUTTONS[i]] then break end
				ES:CreateFrameShadow(_G[MICRO_BUTTONS[i]], _G[MICRO_BUTTONS[i]].backdrop)
			end
		end
		if E.private.sle.module.shadows.actionbars.petbar then ES:CreateFrameShadow(_G["ElvUI_BarPet"], _G["ElvUI_BarPet"].backdrop) end
		if E.private.sle.module.shadows.actionbars.petbarbuttons then
			for i = 1, 12 do
				if not _G["PetActionButton"..i] then break end
				ES:CreateFrameShadow(_G["PetActionButton"..i], _G["PetActionButton"..i].backdrop)
			end
		end
	end
	--Datatexts--
	for panel,enabled in T.pairs(E.private.sle.module.shadows.datatexts) do
		if enabled then ES:CreateFrameShadow(_G[ES.FramesToShadow.Datapanels[panel]],"none") end
	end
	--Misc--
	do
		if E.private.sle.module.shadows.minimap then ES:CreateFrameShadow(_G["MMHolder"], "none") end
		if E.private.sle.module.shadows.chat.left then ES:CreateFrameShadow(_G["LeftChatPanel"], "none") end
		if E.private.sle.module.shadows.chat.right then ES:CreateFrameShadow(_G["RightChatPanel"], "none") end
	end
end

function ES:Initialize()
	if not SLE.initialized then return end
	Border = E.LSM:Fetch('border', 'ElvUI GlowBorder')
	ES:CreateShadows()
	ES:UpdateShadows()
	function ES:ForUpdateAll()
		ES:UpdateShadows()
	end
end

--Compatibility thing
_G.EnhancedShadows = ES;

SLE:RegisterModule(ES:GetName())