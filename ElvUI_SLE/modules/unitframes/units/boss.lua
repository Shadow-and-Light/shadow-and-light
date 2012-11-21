local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");

local abs = math.abs
local _, ns = ...
local ElvUF = ns.oUF

UF.Update_BossFramesSLE = UF.Update_BossFrames
function UF:Update_BossFrames(frame, db)
	self:Update_BossFramesSLE(frame, db)
	
	if E.db.unitframe.units.boss.fixTo == "power" then
		local power = frame.Power
		--Text
		local x, y = self:GetPositionOffset(db.power.position)
		power.value:ClearAllPoints()
		power.value:Point(db.power.position, frame.Power, db.power.position, x, y)		
		frame:Tag(power.value, db.power.text_format)
	end
	
	frame:UpdateAllElements()
end

UF:Update_AllFrames()