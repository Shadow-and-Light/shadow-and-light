local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");

local abs = math.abs
local _, ns = ...
local ElvUF = ns.oUF

UF.Update_FocusFrameDPE = UF.Update_FocusFrame
function UF:Update_FocusFrame(frame, db)
	self:Update_FocusFrameDPE(frame, db)
	
	local power = frame.Power
	--Text
			if db.power.text then
				power.value:Show()
				
				local x, y = self:GetPositionOffset(db.power.position)
				power.value:ClearAllPoints()
				power.value:Point(db.power.position, frame.Power, db.power.position, x, y)			
			else
				power.value:Hide()
			end
	
	frame:UpdateAllElements()
end

UF:Update_AllFrames()