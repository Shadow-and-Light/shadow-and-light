local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if SLE._Compatibility["ElvUI_KitUI"] then return end
local ES = SLE:NewModule('EnhancedShadows', 'AceEvent-3.0')
local AB, UF = SLE:GetElvModules("ActionBars", "UnitFrames")
local ClassColor = RAID_CLASS_COLORS[E.myclass]
local Border, LastSize
local Abars = SLE._Compatibility["ElvUI_ExtraActionBars"] and 10 or 6
--GLOBALS: hooksecurefunc
local _G = _G
local UnitAffectingCombat = UnitAffectingCombat

ES.shadows = {}

local UFrames = {
	{"player", "Player"},
	{"target", "Target"},
	{"targettarget", "TargetTarget"},
	{"focus", "Focus"},
	{"focustarget", "FocusTarget"},
	{"pet", "Pet"},
	{"pettarget", "PetTarget"},
}

local UGroups = {
	{"boss", "Boss", 5},
	{"arena", "Arena", 5},
}

function ES:UpdateShadows()
	if UnitAffectingCombat('player') then ES:RegisterEvent('PLAYER_REGEN_ENABLED', ES.UpdateShadows) return end

	for frame, _ in T.pairs(ES.shadows) do
		ES:UpdateShadow(frame)
	end
end

function ES:RegisterShadow(shadow)
	if shadow.isRegistered then return end
	ES.shadows[shadow] = true
	shadow.isRegistered = true
end

function ES:UpdateFrame(frame, db)
	if not frame or not frame.EnhShadow then return end
	local size = E.db.sle.shadows.size
	if frame.USE_MINI_POWERBAR then
		frame.EnhShadow:SetOutside(frame.Health, size, size)
	else
		frame.EnhShadow:SetOutside(frame, size, size)
	end
end

function ES:CreateShadows()
	for i = 1, #UFrames do
		local unit, name = T.unpack(UFrames[i])
		if E.private.sle.module.shadows[unit] then
			local frame = _G["ElvUF_"..name]
			frame:CreateShadow()
			frame.EnhShadow = frame.shadow
			frame.shadow = nil
			ES:RegisterShadow(frame.EnhShadow)
			hooksecurefunc(UF, "Update_"..name.."Frame", ES.UpdateFrame)
		end
	end
	for i = 1, #UGroups do
		local unit, name, num = T.unpack(UGroups[i])
		if E.private.sle.module.shadows[unit] then
			for j = 1, num do
				local frame = _G["ElvUF_"..name..j]
				frame:CreateShadow()
				frame.EnhShadow = frame.shadow
				frame.shadow = nil
				ES:RegisterShadow(frame.EnhShadow)
				hooksecurefunc(UF, "Update_"..name.."Frames", ES.UpdateFrame)
			end
		end
	end
	for i=1, Abars do
		if E.private.sle.module.shadows.actionbars["bar"..i] then
			local frame = _G["ElvUI_Bar"..i]
			frame:CreateShadow()
			frame.EnhShadow = frame.shadow
			frame.shadow = nil
			ES:RegisterShadow(frame.EnhShadow)
		end
	end
	if E.private.sle.module.shadows.actionbars.stancebar then
		local frame = _G["ElvUI_StanceBar"]
		frame:CreateShadow()
		frame.EnhShadow = frame.shadow
		frame.shadow = nil
		ES:RegisterShadow(frame.EnhShadow)
	end
	if E.private.sle.module.shadows.actionbars.microbar then
		local frame = _G["ElvUI_MicroBar"]
		frame:CreateShadow()
		frame.EnhShadow = frame.shadow
		frame.shadow = nil
		ES:RegisterShadow(frame.EnhShadow)
	end
	if E.private.sle.module.shadows.actionbars.petbar then
		local frame = _G["ElvUI_BarPet"]
		frame:CreateShadow()
		frame.EnhShadow = frame.shadow
		frame.shadow = nil
		ES:RegisterShadow(frame.EnhShadow)
	end
end

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

function ES:Initialize()
	if not SLE.initialized then return end
	Border = E.LSM:Fetch('border', 'ElvUI GlowBorder')
	ES:CreateShadows()
	ES:UpdateShadows()
	function ES:ForUpdateAll()
		ES:UpdateShadows()
	end
end

SLE:RegisterModule(ES:GetName())