local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local B = E:GetModule("SLE_BlizzRaid")
local GetNumGroupMembers, IsInGroup, IsInRaid = GetNumGroupMembers, IsInGroup, IsInRaid
local PLAYER_REALM = gsub(E.myrealm,'[%s%-]','')

function B:CreateAndUpdateIcons()
	-- if not IsInGroup() then return end
	local members = GetNumGroupMembers()
	for i = 1, members do
		local frame = _G["RaidGroupButton"..i]
		if frame and not frame.subframes then E:Delay(1, B.CreateAndUpdateIcons); return end
		if not frame.sleicon then
			frame.sleicon = CreateFrame("Frame", nil, frame)
			frame.sleicon:SetSize(14, 14)
			frame.sleicon:SetPoint("RIGHT", frame.subframes.level, "LEFT", 2, 0)
			RaiseFrameLevel(frame.sleicon)

			frame.sleicon.texture = frame.sleicon:CreateTexture(nil, "OVERLAY")
			frame.sleicon.texture:SetAllPoints(frame.sleicon)
		end
		local unit = IsInRaid() and "raid" or "party"
		local role = UnitGroupRolesAssigned(unit..i)
		local name, realm = UnitName(unit..i)
		local texture = ""
		if (role and role ~= "NONE") and name and E.db.sle.roleicons and E.db.sle.blizzraidroles then
			name = (realm and realm ~= '') and name..'-'..realm or name ..'-'..PLAYER_REALM;
			texture = SLE.rolePaths[E.db.sle.roleicons][role]
		end
		frame.sleicon.texture:SetTexture(texture)
	end
end

function B:RaidLoaded(event, addon)
	if addon == "Blizzard_RaidUI" then
		B:CreateAndUpdateIcons()
		hooksecurefunc("RaidGroupFrame_Update", B.CreateAndUpdateIcons)
		self:UnregisterEvent(event)
	end
end

B:RegisterEvent("ADDON_LOADED", "RaidLoaded")