local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");
--GLOBALS: hooksecurefunc
local _G = _G
local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES

SUF.powerbars = {}

--PowerBar Texture
function SUF:BuildStatusTable()
	T.twipe(SUF.powerbars)

	for _, unitName in T.pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = T.gsub(frameNameUnit, "t(arget)", "T%1")
		
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.Power then SUF.powerbars[unitframe.Power] = true end
	end

	for unit, unitgroup in T.pairs(UF.groupunits) do
		local frameNameUnit = E:StringTitle(unit)
		frameNameUnit = T.gsub(frameNameUnit, "t(arget)", "T%1")
		
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.Power then SUF.powerbars[unitframe.Power] = true end
	end
end

--Castbar
function SUF:PostCast(unit)
	local castTexture = LSM:Fetch("statusbar", E.db.sle.unitframes.statusTextures.castTexture)
	self:SetStatusBarTexture(castTexture)
end

function SUF:CastBarHook()
	local units = {"Player", "Target", "Focus"}
	for _, unit in T.pairs(units) do
		local unitframe = _G["ElvUF_"..unit];
		local castbar = unitframe and unitframe.Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", SUF.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", SUF.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", SUF.PostCast)
		end
	end

	for i = 1, 5 do
		local castbar = _G["ElvUF_Arena"..i].Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", SUF.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", SUF.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", SUF.PostCast)
		end
	end

	for i = 1, MAX_BOSS_FRAMES do
		local castbar = _G["ElvUF_Boss"..i].Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", SUF.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", SUF.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", SUF.PostCast)
		end
	end
end

--Aurabars
function SUF:AuraHook()
	local auraTexture = LSM:Fetch("statusbar", E.db.sle.unitframes.statusTextures.auraTexture)
	local bars = self.bars
	if not bars then return end
	for index = 1, #bars do
		local frame = bars[index]
		frame.statusBar:SetStatusBarTexture(auraTexture)
	end
end

--Classbars
function SUF:UpdateClass(frame)
	local bars = frame[frame.ClassBar]
	local texture = LSM:Fetch("statusbar", E.db.sle.unitframes.statusTextures.classTexture)
	if (frame.ClassBar == 'ClassIcons' or frame.ClassBar == 'Runes') then
		for i = 1, (UF.classMaxResourceBar[E.myclass] or 0) do
			if i <= frame.MAX_CLASS_BAR then
				bars[i]:SetStatusBarTexture(texture)
			end
		end
	end
end

function SUF:UpdateStatusBars()
	if E.private.sle.unitframe.statusbarTextures.power then
		local powerTexture = LSM:Fetch("statusbar", E.db.sle.unitframes.statusTextures.powerTexture)

		for powerbar in T.pairs(SUF.powerbars) do
			if powerbar and powerbar:GetObjectType() == "StatusBar" and not powerbar.isTransparent then
				powerbar:SetStatusBarTexture(powerTexture)
			elseif powerbar and powerbar:GetObjectType() == "Texture" then
				powerbar:SetTexture(powerTexture)
			end
		end
	end
	if E.private.sle.unitframe.statusbarTextures.class then UF:CreateAndUpdateUF('player') end
end

function SUF:InitStatus()
	if E.private.sle.unitframe.statusbarTextures.power or E.private.sle.unitframe.statusbarTextures.class then
		hooksecurefunc(UF, "Update_StatusBars", SUF.UpdateStatusBars)
	end
	if E.private.sle.unitframe.statusbarTextures.power then
		SUF:BuildStatusTable()
		hooksecurefunc(UF, "CreateAndUpdateUF", SUF.UpdateStatusBars)
		hooksecurefunc(UF, "CreateAndUpdateUFGroup", SUF.UpdateStatusBars)
		hooksecurefunc(UF, "CreateAndUpdateHeaderGroup", SUF.UpdateStatusBars)
		hooksecurefunc(UF, "ForceShow", SUF.UpdateStatusBars)
	end
	if E.private.sle.unitframe.statusbarTextures.aura then
		hooksecurefunc(_G["ElvUF_Player"].AuraBars, "PostUpdate", SUF.AuraHook)
		hooksecurefunc(_G["ElvUF_Target"].AuraBars, "PostUpdate", SUF.AuraHook)
		hooksecurefunc(_G["ElvUF_Focus"].AuraBars, "PostUpdate", SUF.AuraHook)
	end
	if E.private.sle.unitframe.statusbarTextures.class then
		hooksecurefunc(UF, "Configure_ClassBar", SUF.UpdateClass)
	end
end