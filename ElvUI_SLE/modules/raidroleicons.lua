local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local B = E:GetModule("SLE_BlizzRaid")
local GetNumGroupMembers, IsInGroup, IsInRaid = GetNumGroupMembers, IsInGroup, IsInRaid
local PLAYER_REALM = gsub(E.myrealm,'[%s%-]','')

function B:CreateAndUpdateIcons()
	local members = GetNumGroupMembers()
	for i = 1, members do
		local frame = _G["RaidGroupButton"..i]
		if (frame and not frame.subframes) or not E.db.sle.raidmanager then E:Delay(1, B.CreateAndUpdateIcons); return end
		local parent = E.db.sle.raidmanager.level and frame.subframes.level or frame.subframes.class
		if E.db.sle.raidmanager.level then
			frame.subframes.level:Show()
		else
			frame.subframes.level:Hide()
		end
		if not frame.sleicon then
			frame.sleicon = CreateFrame("Frame", nil, frame)
			frame.sleicon:SetSize(14, 14)
			RaiseFrameLevel(frame.sleicon)

			frame.sleicon.texture = frame.sleicon:CreateTexture(nil, "OVERLAY")
			frame.sleicon.texture:SetAllPoints(frame.sleicon)
		end
		frame.sleicon:SetPoint("RIGHT", parent, "LEFT", 2, 0)
		local unit = IsInRaid() and "raid" or "party"
		local role = UnitGroupRolesAssigned(unit..i)
		local name, realm = UnitName(unit..i)
		local texture = ""
		if (role and role ~= "NONE") and name and E.db.sle.roleicons and E.db.sle.raidmanager.roles then
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

if not SLE.oraenabled then
	B:RegisterEvent("ADDON_LOADED", "RaidLoaded")
end

