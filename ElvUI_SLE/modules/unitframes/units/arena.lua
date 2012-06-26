local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");

local abs = math.abs
local _, ns = ...
local ElvUF = ns.oUF

--Here and in other units, moving power text to power bar
UF.Update_ArenaFramesDPE = UF.Update_ArenaFrames
function UF:Update_ArenaFrames(frame, db)
	self:Update_ArenaFramesDPE(frame, db)
	
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