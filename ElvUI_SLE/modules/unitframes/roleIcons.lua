local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")
local UF = E:GetModule('UnitFrames');
local _G = _G

local function GetBattleFieldIndexFromUnitName(name)
	local nameFromIndex
	for index = 1, T.GetNumBattlefieldScores() do
		nameFromIndex = T.GetBattlefieldScore(index)
		if nameFromIndex == name then
			return index
		end
	end
	return nil
end

function SUF:UpdateRoleIcon()
	local lfdrole = self.LFDRole
	if not self.db then return; end
	local db = self.db.roleIcon;
	if (not db) or (db and not db.enable) then
		lfdrole:Hide()
		return
	end
	
	local isInstance, instanceType = T.IsInInstance()
	local role
	if isInstance and instanceType == "pvp" then
		local name = T.GetUnitName(self.unit, true)
		local index = GetBattleFieldIndexFromUnitName(name)
		if index then
			local _, _, _, _, _, _, _, _, classToken, _, _, _, _, _, _, talentSpec = T.GetBattlefieldScore(index)
			if classToken and talentSpec then
				role = SUF.specNameToRole[classToken][talentSpec]
			else
				role = T.UnitGroupRolesAssigned(self.unit) --Fallback
			end
		else
			role = T.UnitGroupRolesAssigned(self.unit) --Fallback
		end
	else
		role = T.UnitGroupRolesAssigned(self.unit)
		if self.isForced and role == 'NONE' then
			local rnd = T.random(1, 3)
			role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
		end
	end
	if (self.isForced or T.UnitIsConnected(self.unit)) and ((role == "DAMAGER" and db.damager) or (role == "HEALER" and db.healer) or (role == "TANK" and db.tank)) then
		lfdrole:SetTexture(SLE.rolePaths[E.db.sle.unitframes.roleicons][role])
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end

function SUF:SetRoleIcons()
	for _, header in T.pairs(UF.headers) do
		local name = header.groupName
		local db = UF.db["units"][name]
		for i = 1, header:GetNumChildren() do
			local group = T.select(i, header:GetChildren())
			for j = 1, group:GetNumChildren() do
			local unitbutton = T.select(j, group:GetChildren())
				if unitbutton.LFDRole and unitbutton.LFDRole.Override then
					unitbutton.LFDRole.Override = SUF.UpdateRoleIcon
				end
			end
		end
	end
	UF:UpdateAllHeaders()
end