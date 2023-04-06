local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames
local UF = E.UnitFrames

function SUF:UpdateRoleIcon(event)
	if not self.db then return end
	local sldb = E.db.sle.unitframes.roleIcons
	if not sldb or not sldb.enable then return end

	local lfdrole = self.GroupRoleIndicator
	local db = self.db.roleIcon

	if not db or not db.enable then
		lfdrole:Hide()
		return
	end

	local role = UnitGroupRolesAssigned(self.unit)
	if self.isForced and role == 'NONE' then
		local rnd = random(1, 3)
		role = rnd == 1 and 'TANK' or (rnd == 2 and 'HEALER' or (rnd == 3 and 'DAMAGER'))
	end

	local shouldHide = ((event == 'PLAYER_REGEN_DISABLED' and db.combatHide and true) or false)

	if (self.isForced or UnitIsConnected(self.unit)) and ((role == 'DAMAGER' and db.damager) or (role == 'HEALER' and db.healer) or (role == 'TANK' and db.tank)) then
		lfdrole:SetTexture(SLE.rolePaths[sldb.icons][role])
		if not shouldHide then
			lfdrole:Show()
		else
			lfdrole:Hide()
		end
	else
		lfdrole:Hide()
	end
end
hooksecurefunc(UF, 'UpdateRoleIcon', SUF.UpdateRoleIcon)
