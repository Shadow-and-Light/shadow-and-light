local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local S = E.Skins

--GLOBALS: CreateFrame
local _G = _G

local function PetBattle()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.petbattleui or not E.private.sle.skins.petbattles.enable then return end
	local frame = _G.PetBattleFrame
	local bar = _G.ElvUIPetBattleActionBar

	local holder = CreateFrame('Frame', 'ActiveAllyHolder', E.UIParent)
	holder:Size(918, 68)
	holder:Point('TOP', frame)

	frame.TopVersusText:ClearAllPoints()
	frame.TopVersusText:SetPoint('CENTER', holder)

	frame.ActiveAlly.Icon:ClearAllPoints()
	frame.ActiveAlly.Icon:Point('BOTTOMLEFT', holder, 'BOTTOMLEFT', 0, 0)

	frame.ActiveEnemy.Icon:ClearAllPoints()
	frame.ActiveEnemy.Icon:Point('BOTTOMRIGHT', holder, 'BOTTOMRIGHT', 0, 0)

	frame.AllyBuffFrame:ClearAllPoints()
	frame.AllyBuffFrame:Point('TOPLEFT', frame.ActiveAlly.Icon, 'BOTTOMLEFT', 0, -5)

	frame.AllyPadBuffFrame:ClearAllPoints()
	frame.AllyPadBuffFrame:Point('TOPLEFT', frame.AllyBuffFrame, 'TOPRIGHT', 2, 0)

	frame.EnemyBuffFrame:ClearAllPoints()
	frame.EnemyBuffFrame:Point('TOPRIGHT', frame.ActiveEnemy.Icon, 'BOTTOMRIGHT', 0, -5)

	frame.EnemyPadBuffFrame:ClearAllPoints()
	frame.EnemyPadBuffFrame:Point('TOPRIGHT', frame.EnemyBuffFrame, 'TOPLEFT', -2, 0)

	E:CreateMover(holder, 'PetBattleStatusMover', L["Pet Battle Status"], nil, nil, nil, 'S&L,S&L MISC')
	E:CreateMover(bar, 'PetBattleABMover', L["Pet Battle AB"], nil, nil, nil, 'S&L,S&L MISC')
end

hooksecurefunc(S, 'Initialize', PetBattle)
