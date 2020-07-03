local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');

-- GLOBALS: unpack, select, random, UnitGroupRolesAssigned, UnitIsConnected, pairs

function SUF:UpdateRoleIcon()
	local lfdrole = self.GroupRoleIndicator
	if not self.db then return; end
	local db = self.db.roleIcon;
	if (not db) or (db and not db.enable) then
		lfdrole:Hide()
		return
	end

	local role = UnitGroupRolesAssigned(self.unit)
		if self.isForced and role == 'NONE' then
			local rnd = random(1, 3)
			role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
		end
	if (self.isForced or UnitIsConnected(self.unit)) and ((role == "DAMAGER" and db.damager) or (role == "HEALER" and db.healer) or (role == "TANK" and db.tank)) then
		lfdrole:SetTexture(SLE.rolePaths[E.db.sle.unitframes.roleicons][role])
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end

function SUF:SetRoleIcons()
	for _, header in pairs(UF.headers) do
		local name = header.groupName
		local db = UF.db["units"][name]
		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
				if unitbutton.GroupRoleIndicator and unitbutton.GroupRoleIndicator.Override and not unitbutton.GroupRoleIndicator.sleRoleSetup then
					unitbutton.GroupRoleIndicator.Override = SUF.UpdateRoleIcon
					unitbutton:UnregisterEvent("UNIT_CONNECTION")
					unitbutton:RegisterEvent("UNIT_CONNECTION", SUF.UpdateRoleIcon)
					unitbutton.GroupRoleIndicator.sleRoleSetup = true
				end
			end
		end
	end
	UF:UpdateAllHeaders()
end