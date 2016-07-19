local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")

local ignore = {
	["partytarget"] = true,
	["partypet"] = true,
	["raidpet"] = true,
}

function SUF:Update_GroupFrames(frame)
	local group = frame.unitframeType
	if ignore[group] then return end
	if not frame.Offline then frame.Offline = SUF:Construct_Offline(frame, group) end
	local db = E.db.sle.unitframes.unit[group]
	if db.offline.enable then
		if not frame:IsElementEnabled('SLE_Offline') then
			frame:EnableElement('SLE_Offline')
		end
		frame.Offline:SetPoint("CENTER", frame, "CENTER", db.offline.xOffset, db.offline.yOffset)
		frame.Offline:SetSize(db.offline.size, db.offline.size)
		if db.offline.texture == "CUSTOM" then
			frame.Offline:SetTexture(db.offline.CustomTexture)
		else
			frame.Offline:SetTexture(SUF.OfflineTextures[db.offline.texture])
		end
	else
		if frame:IsElementEnabled('SLE_Offline') then
			frame:DisableElement('SLE_Offline')
		end
	end
	-- if frame.db.roleIcon.enable and frame.LFDRole then
		-- frame.LFDRole:ClearAllPoints()
		-- local x, y = self:GetPositionOffset(frame.db.roleIcon.position, 1)
		-- frame.LFDRole:ClearAllPoints()
		-- frame.LFDRole:Point(frame.db.roleIcon.position, frame.Health, frame.db.roleIcon.position, x + db.role.xoffset, y + db.role.yoffset)
	-- end
end