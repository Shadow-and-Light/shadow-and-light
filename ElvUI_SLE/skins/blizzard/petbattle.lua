local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')
local _G = _G

local function PetBattle()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.petbattleui ~= true and E.private.sle.skins.petbattles.enable ~= true then return end
	local f = _G["PetBattleFrame"]
	local bar = _G["ElvUIPetBattleActionBar"]
	
	local a = CreateFrame("Frame", "ActiveAllyHolder", E.UIParent)
	a:Size(918, 68)
	a:Point("TOP", f)
	
	f.TopVersusText:ClearAllPoints()
	f.TopVersusText:SetPoint("CENTER", a)
	f.ActiveAlly.Icon:Point("BOTTOMLEFT", a, "BOTTOMLEFT", 0, 0)
	f.ActiveEnemy.Icon:Point("BOTTOMRIGHT", a, "BOTTOMRIGHT", 0, 0)
	f.AllyBuffFrame:Point("TOPLEFT", f.ActiveAlly.Icon, "BOTTOMLEFT", 0, -5)
	f.AllyPadBuffFrame:ClearAllPoints()
	f.AllyPadBuffFrame:Point("TOPLEFT", f.AllyBuffFrame, "TOPRIGHT", 2, 0)
	f.EnemyBuffFrame:Point("TOPRIGHT", f.ActiveEnemy.Icon, "BOTTOMRIGHT", 0, -5)
	f.EnemyPadBuffFrame:ClearAllPoints()
	f.EnemyPadBuffFrame:Point("TOPRIGHT", f.EnemyBuffFrame, "TOPLEFT", -2, 0)
	E:CreateMover(a, "PetBattleStatusMover", L["Pet Battle Status"], nil, nil, nil, "S&L,S&L MISC")
	E:CreateMover(bar, "PetBattleABMover", L["Pet Battle AB"], nil, nil, nil, "S&L,S&L MISC")
end

hooksecurefunc(S, "Initialize", PetBattle)