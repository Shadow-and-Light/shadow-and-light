local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local UF = E:GetModule('UnitFrames');
local SUF = SLE:NewModule("UnitFrames")
local RC = LibStub("LibRangeCheck-2.0")
--GLOBALS: hooksecurefunc, CreateFrame
local _G = _G

function SUF:NewTags()
	_G["ElvUF"].Tags.Methods["range:sl"] = function(unit)
		local name, server = T.UnitName(unit)
		local rangeText = ''
		local min, max = RC:GetRange(unit)
		local curMin = min
		local curMax = max

		if(server and server ~= "") then
			name = T.format("%s-%s", name, server)
		end

		if min and max and (name ~= T.UnitName('player')) then
			rangeText = curMin.."-"..curMax
		end
		return rangeText
	end

	_G["ElvUF"].Tags.Events['absorbs:sl-short'] = 'UNIT_ABSORB_AMOUNT_CHANGED'
	_G["ElvUF"].Tags.Methods['absorbs:sl-short'] = function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb == 0 then
			return 0
		else
			return E:ShortValue(absorb)
		end
	end

	_G["ElvUF"].Tags.Events['absorbs:sl-full'] = 'UNIT_ABSORB_AMOUNT_CHANGED'
	_G["ElvUF"].Tags.Methods['absorbs:sl-full'] = function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb == 0 then
			return 0
		else
			return absorb
		end
	end
end

function SUF:ConfiguePortrait(frame, dontHide)
	local db = E.db.sle.unitframes.unit
	local portrait = frame.Portrait
	if not portrait.SLEHooked then
		hooksecurefunc(portrait, "PostUpdate", SUF.PortraitUpdate)
		portrait.SLEHooked = true
	end
	if (db[frame.unitframeType] and db[frame.unitframeType].higherPortrait) and frame.USE_PORTRAIT_OVERLAY then
		if not frame.Health.HigherPortrait then
			frame.Health.HigherPortrait = CreateFrame("Frame", frame:GetName().."HigherPortrait", frame)
			frame.Health.HigherPortrait:SetFrameLevel(frame.Health:GetFrameLevel() + 4)
			frame.Health.HigherPortrait:SetAllPoints(frame.Health)
		end
		portrait:ClearAllPoints()
		if frame.db.portrait.style == '3D' then portrait:SetFrameLevel(frame.Health.HigherPortrait:GetFrameLevel()) end
		portrait:SetAllPoints(frame.Health.HigherPortrait)
		frame.Health.bg:SetParent(frame.Health)
	end
end

function SUF:PortraitUpdate(unit)
	local frame = self:GetParent()
	local dbElv = frame.db
	if not dbElv then return end
	local db = E.db.sle.unitframes.unit
	local portrait = dbElv.portrait
	if db[frame.unitframeType] and portrait.enable and self:GetParent().USE_PORTRAIT_OVERLAY then
		self:SetAlpha(0);
		self:SetAlpha(db[frame.unitframeType].portraitAlpha);
	end
end

local function UpdateFillBar(frame, previousTexture, bar, amount)
	if ( amount == 0 ) then
		bar:Hide();
		return previousTexture;
	end

	local orientation = frame.Health:GetOrientation()
	local first = false
	bar:ClearAllPoints()
	if previousTexture == frame.Health:GetStatusBarTexture() then first = true end
	if orientation == 'HORIZONTAL' then
		bar:Point("TOPLEFT", previousTexture, "TOPRIGHT");
		bar:Point("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT",0,first and -1 or 0);
	else
		bar:Point("BOTTOMRIGHT", previousTexture, "TOPRIGHT");
		bar:Point("BOTTOMLEFT", previousTexture, "TOPLEFT");
	end

	local totalWidth, totalHeight = frame.Health:GetSize();
	if orientation == 'HORIZONTAL' then
		bar:Width(totalWidth);
	else
		bar:Height(totalHeight);
	end

	return bar:GetStatusBarTexture();
end

function SUF:UpdateHealComm(unit, myIncomingHeal, allIncomingHeal, totalAbsorb)
	local frame = self.parent
	local previousTexture = frame.Health:GetStatusBarTexture();

	previousTexture = UpdateFillBar(frame, previousTexture, self.myBar, myIncomingHeal);
	previousTexture = UpdateFillBar(frame, previousTexture, self.otherBar, allIncomingHeal);
	previousTexture = UpdateFillBar(frame, previousTexture, self.absorbBar, totalAbsorb);
end

function SUF:HealthPredictUpdate(frame)
	if frame.HealPrediction and (not frame.HealPrediction.SLEPredicHook and frame.HealPrediction.PostUpdate) then
		frame.HealPrediction.PostUpdate = SUF.UpdateHealComm
		frame.HealPrediction.SLEPredicHook = true
	end
end

function SUF:Initialize()
if not SLE.initialized then return end
	SUF:NewTags()
	SUF:InitPlayer()

	--Raid stuff
	SUF.specNameToRole = {}
	for i = 1, T.GetNumClasses() do
		local _, class, classID = T.GetClassInfo(i)
		SUF.specNameToRole[class] = {}
		for j = 1, T.GetNumSpecializationsForClassID(classID) do
			local _, spec, _, _, _, role = T.GetSpecializationInfoForClassID(classID, j)
			SUF.specNameToRole[class][spec] = role
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		SUF:SetRoleIcons()
		if E.private.sle.unitframe.statusbarTextures.cast then SUF:CastBarHook() end
	end)

	--Hooking to group frames
	hooksecurefunc(UF, "Update_PartyFrames", SUF.Update_GroupFrames)
	hooksecurefunc(UF, "Update_RaidFrames", SUF.Update_GroupFrames)
	hooksecurefunc(UF, "Update_Raid40Frames", SUF.Update_GroupFrames)
	--Portrait overlay
	hooksecurefunc(UF, "Configure_Portrait", SUF.ConfiguePortrait)
	-- hooksecurefunc(UF, "PortraitUpdate", SUF.PortraitUpdate)
	if E.private.sle.unitframe.resizeHealthPrediction then
		hooksecurefunc(UF, "Configure_HealthBar", SUF.HealthPredictUpdate)
	end

	SUF:InitStatus()

	function SUF:ForUpdateAll()
		UF:UpdateAllHeaders()
		if E.private.sle.unitframe.statusbarTextures.power then SUF:BuildStatusTable() end
	end
end

SLE:RegisterModule(SUF:GetName())