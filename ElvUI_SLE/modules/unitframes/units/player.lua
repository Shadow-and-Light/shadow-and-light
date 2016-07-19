local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');
--GLOBALS: CreateFrame, UIParent
local _G = _G
local C_TimerNewTimer = C_Timer.NewTimer

SUF.CombatTextures = {
	["DEFAULT"] = [[Interface\CharacterFrame\UI-StateIcon]],
	["PLATINUM"] = [[Interface\Challenges\ChallengeMode_Medal_Platinum]],
	["ATTACK"] = [[Interface\CURSOR\Attack]],
	["ALERT"] = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
	["ARTHAS"] = [[Interface\LFGFRAME\UI-LFR-PORTRAIT]],
	["SKULL"] = [[Interface\LootFrame\LootPanel-Icon]],
	["SVUI"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SVUI-StateIcon]],
}
SUF.RestedTextures = {
	["DEFAULT"] = [[Interface\CharacterFrame\UI-StateIcon]],
	["SVUI"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SVUI-StateIcon]],
}

function SUF:CombatIcon_PostUpdate(inCombat)
	local frame = self:GetParent()
	self:ClearAllPoints()
	self:SetTexture(SUF.CombatTextures[E.db.sle.unitframes.unit.player.combatico.texture])
	if E.db.sle.unitframes.unit.player.combatico.texture == "DEFAULT" or E.db.sle.unitframes.unit.player.combatico.texture == "SVUI" then self:SetTexCoord(.5, 1, 0, .49) else self:SetTexCoord(0,1,0,1) end
	self:Size(E.db.sle.unitframes.unit.player.combatico.size)
	self:Point("CENTER", frame.Health, "CENTER", E.db.sle.unitframes.unit.player.combatico.xoffset, E.db.sle.unitframes.unit.player.combatico.yoffset)
	if not E.db.sle.unitframes.unit.player.combatico.red then self:SetVertexColor(1, 1, 1) end
end

function SUF:TestCombat()
	if SUF.CombatTest.Timer then SUF.CombatTest.Timer:Cancel() end

	SUF.CombatTest:Point("CENTER", _G["ElvUF_Player"].Combat)
	SUF.CombatTest:Size(E.db.sle.unitframes.unit.player.combatico.size)

	SUF.CombatTest.texture:SetTexture(SUF.CombatTextures[E.db.sle.unitframes.unit.player.combatico.texture])
	if E.db.sle.unitframes.unit.player.combatico.texture == "DEFAULT" or E.db.sle.unitframes.unit.player.combatico.texture == "SVUI" then SUF.CombatTest.texture:SetTexCoord(.5, 1, 0, .49) else SUF.CombatTest.texture:SetTexCoord(0,1,0,1) end
	if not E.db.sle.unitframes.unit.player.combatico.red then SUF.CombatTest.texture:SetVertexColor(1, 1, 1) else SUF.CombatTest.texture:SetVertexColor(0.69, 0.31, 0.31) end
	SUF.CombatTest:Show()
	SUF.CombatTest.Timer = C_TimerNewTimer(10, function() SUF.CombatTest:Hide() end)
end

function SUF:UpdateRested(frame)
	local rIcon = frame.Resting
	local db = frame.db
	local Sdb = E.db.sle.unitframes.unit.player.rested
	if db.restIcon then
		rIcon:ClearAllPoints()
		if frame.ORIENTATION == "RIGHT" then
			rIcon:Point("CENTER", frame.Health, "TOPLEFT", -3 + Sdb.xoffset, 6 + Sdb.yoffset)
		else
			if frame.USE_PORTRAIT and not frame.USE_PORTRAIT_OVERLAY then
				rIcon:Point("CENTER", frame.Portrait, "TOPLEFT", -3 + Sdb.xoffset, 6 + Sdb.yoffset)
			else
				rIcon:Point("CENTER", frame.Health, "TOPLEFT", -3 + Sdb.xoffset, 6 + Sdb.yoffset)
			end
		end
		rIcon:Size(Sdb.size)
		if Sdb.texture ~= "CUSTOM" then
			rIcon:SetTexture(SUF.CombatTextures[Sdb.texture])
			if Sdb.texture == "DEFAULT" or Sdb.texture == "SVUI" then rIcon:SetTexCoord(0, .5, 0, .421875) else rIcon:SetTexCoord(0,1,0,1) end
		else
			rIcon:SetTexture(Sdb.customTexture)
		end
	end
end

function SUF:InitPlayer()
	SUF.CombatTest = CreateFrame("Frame", "SLE_CombatIconTest", UIParent)
	SUF.CombatTest:Point("CENTER", _G["ElvUF_Player"].Combat)
	SUF.CombatTest.texture = SUF.CombatTest:CreateTexture(nil, "OVERLAY")
	SUF.CombatTest.texture:SetAllPoints()
	SUF.CombatTest:Hide()
	_G["ElvUF_Player"].Combat.PostUpdate = SUF.CombatIcon_PostUpdate
	
	hooksecurefunc(UF, "Configure_RestingIndicator", SUF.UpdateRested)
end