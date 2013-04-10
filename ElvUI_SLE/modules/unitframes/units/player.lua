local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
if not E.private.unitframe.enable then return end

local UF = E:GetModule('UnitFrames');
local SLE = E:GetModule('SLE');


function UF:Update_CombatIndicator()
	local CombatText = ElvUF_Player.Combat
	if E.db.sle.combatico.pos == "NONE" then
		CombatText:ClearAllPoints()
	else	
		local x, y = UF:GetPositionOffset(E.db.sle.combatico.pos)
		CombatText:ClearAllPoints()
		CombatText:Point(E.db.sle.combatico.pos, ElvUF_Player.Health, E.db.sle.combatico.pos, x, x)
	end
	SLE:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

UF.UpdatePlayerFrameAnchorsSLE = UF.UpdatePlayerFrameAnchors
function UF:UpdatePlayerFrameAnchors(frame, isShown)
	UF:UpdatePlayerFrameAnchorsSLE(frame, isShown)
	
	if E.myclass == "DRUID" then
		UF:EclipseTextSLE()
	end
	
	if E.myclass == "WARLOCK" then
		UF:DFTextSLE()
	end
end

function UF:ClassbarTextSLE()
	if E.myclass == "DRUID" then
		UF:EclipseTextSLE()
	elseif E.myclass == "WARLOCK" then
		UF:DFTextSLE()
	end
end

function UF:EclipseTextSLE()
	local eclipseBar = ElvUF_Player.EclipseBar
	local spower = UnitPower( PlayerFrame.unit, SPELL_POWER_ECLIPSE );
	if E.db.sle.powtext then
		eclipseBar.powtext:SetText(spower)
	else
		eclipseBar.powtext:SetText('')
	end
end

function UF:DFTextSLE()
	local ShardBar = ElvUF_Player.ShardBar
	local dfpower = UnitPower( PlayerFrame.unit, SPELL_POWER_DEMONIC_FURY );
	local hasspec = GetSpecialization(false, false)
	if hasspec == nil then return end
	local index = select(1, GetSpecializationInfo(GetSpecialization(false, false, active)), false, false)
	if index == 266 then --This crap is checking the spec.
		if E.db.sle.powtext then
			ShardBar.powtext:SetText(dfpower)
			if E.db.unitframe.units.player.classbar.fill == "spaced" then
				ShardBar.powtext:ClearAllPoints()
				ShardBar.powtext:SetPoint("LEFT", ShardBar, "RIGHT")
			else
				ShardBar.powtext:ClearAllPoints()
				ShardBar.powtext:SetPoint("CENTER", ShardBar, "CENTER")
			end
		else
			ShardBar.powtext:SetText('')
		end
	else
		ShardBar.powtext:SetText('')
	end
end

--Text for druid eclipse bar
if E.myclass == "DRUID" then
	local eclipseBar = ElvUF_Player.EclipseBar
	local lunarBar = eclipseBar.LunarBar

	eclipseBar.powtext = lunarBar:CreateFontString(nil, 'OVERLAY')
	eclipseBar.powtext:SetPoint("CENTER", eclipseBar, "CENTER")
	eclipseBar.powtext:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
end

if E.myclass == "WARLOCK" then
	local ShardBar = ElvUF_Player.ShardBar
	local dfbar = select(2, ShardBar:GetChildren())
	
	ShardBar.powtext = dfbar:CreateFontString(nil, 'OVERLAY')
	ShardBar.powtext:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
end