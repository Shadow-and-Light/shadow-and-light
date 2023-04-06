local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local B = SLE.BlizzRaid

--GLOBALS: CreateFrame, hooksecurefunc
local _G = _G
local UnitName = UnitName
local RaiseFrameLevel = RaiseFrameLevel

--Actually make dem icons
function B:CreateAndUpdateIcons()
	if not SLE.initialized then return end
	local members = GetNumGroupMembers()
	for i = 1, members do
		local frame = _G['RaidGroupButton'..i]
		--if the frame doesn't exist then wait a bit
		if not frame or (frame and not frame.subframes) or not E.db.sle.raidmanager then E:Delay(1, B.CreateAndUpdateIcons); return end
		--if level is shown then attach icons there, otherwise to class
		local parent = E.db.sle.raidmanager.level and frame.subframes.level or frame.subframes.class
		if E.db.sle.raidmanager.level then
			frame.subframes.level:Show()
		else
			frame.subframes.level:Hide()
		end
		--if the icon is not created for this frame then make that shit
		if not frame.sleicon then
			frame.sleicon = CreateFrame('Frame', nil, frame)
			frame.sleicon:SetSize(14, 14)
			RaiseFrameLevel(frame.sleicon)

			frame.sleicon.texture = frame.sleicon:CreateTexture(nil, 'OVERLAY')
			frame.sleicon.texture:SetAllPoints(frame.sleicon)
		end
		frame.sleicon:SetPoint('RIGHT', parent, 'LEFT', 2, 0)
		--Deciding on what texture to use
		local unit = IsInRaid() and 'raid' or 'party'
		local role = UnitGroupRolesAssigned(unit..i)
		local name = UnitName(unit..i)
		local rolePath = SLE.rolePaths[E.db.sle.unitframes.roleIcons.icons] or SLE.rolePaths['ElvUI']
		local texture = ''

		if (role and role ~= 'NONE') and name and E.db.sle.unitframes.roleIcons.enable and E.db.sle.raidmanager.roles then
			--  TODO:  Some reason name is assigned but not used?
			-- name = (realm and realm ~= '') and name..'-'..realm or name ..'-'..PLAYER_REALM
			texture = rolePath[role]
		end
		frame.sleicon.texture:SetTexture(texture)
	end
end

--When raid manager is loaded. do stuff
function B:RaidLoaded(event, addon)
	if addon == 'Blizzard_RaidUI' then
		B:CreateAndUpdateIcons()
		hooksecurefunc('RaidGroupFrame_Update', B.CreateAndUpdateIcons)
		self:UnregisterEvent(event)
	end
end

--if oRA is not present, then we are doing shit
if not SLE._Compatibility['oRA3'] then
	B:RegisterEvent('ADDON_LOADED', 'RaidLoaded')
end

function B:Initialize()
	if not SLE.initialized then return end
end

SLE:RegisterModule(B:GetName())
