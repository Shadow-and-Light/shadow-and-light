local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local RM = SLE:NewModule('RaidMarkers', 'AceHook-3.0');

--GLOBALS: CreateFrame
local _G = _G
local format = format
local GameTooltip = GameTooltip
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

--Visiblity state strings to use based on settings
RM.VisibilityStates = {
	["DEFAULT"] = "[noexists, nogroup] hide; show",
	["INPARTY"] = "[group] show; [petbattle] hide; hide",
	["ALWAYS"] = "[petbattle] hide; show",
}

local layouts = {
	[1] = {RT = 1, WM = 5}, -- Star
	[2] = {RT = 2, WM = 6}, -- Circle
	[3] = {RT = 3, WM = 3}, -- Diamond
	[4] = {RT = 4, WM = 2}, -- Triangle
	[5] = {RT = 5, WM = 7}, -- Moon
	[6] = {RT = 6, WM = 1}, -- Square
	[7] = {RT = 7, WM = 4}, -- Cross
	[8] = {RT = 8, WM = 8}, -- Skull
	[9] = {RT = 0, WM = 0}, -- clear target/worldmarker
}

--Creating stuff for keybinds
function RM:Make(name, command, description)
	_G["BINDING_NAME_CLICK "..name..":LeftButton"] = description
	local btn = CreateFrame("Button", name, nil, "SecureActionButtonTemplate")
	btn:SetAttribute("type", "macro")
	btn:SetAttribute("macrotext", command)
	btn:RegisterForClicks("AnyDown")
end

--On enter/leave functions
function RM:Bar_OnEnter()
	RM.frame:SetAlpha(1)
end

function RM:Bar_OnLeave()
	if RM.db.mouseover then RM.frame:SetAlpha(0) end
end


function RM:CreateButton(index)
	local info = layouts[index]
	local target, worldmarker = info.RT, info.WM
	local button = CreateFrame("Button", format("SLE_RaidMarkerBarButton%d", index), RM.frame, "SecureActionButtonTemplate")
	button:Size(E.db.sle.raidmarkers.buttonSize)
	button:SetTemplate('Transparent')

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
	button.icon:SetTexture(index == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or format("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d", index))

	if target then
		button:SetAttribute("type1", "macro")
		button:SetAttribute("macrotext1", format("/tm %d", index == 9 and 0 or index))
	end

	button:RegisterForClicks("AnyDown")

	return button
end

--So this is a big function to setup macro texts and stuff for all the buttons
function RM:UpdateWorldMarkersAndTooltips()
	for index = 1, 9 do
		local target, worldmarker = layouts[index].RT, layouts[index].WM
		local button = self.frame.buttons[index]

		if target and not worldmarker then
			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				if E.db.sle.raidmarkers.notooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(index == 9 and L["Click to clear the mark."] or L["Click to mark the target."], 1, 1, 1)
				GameTooltip:Show()
			end)
		else
			local modifier = E.db.sle.raidmarkers.modifier or "shift-"
			button:SetAttribute(format("%stype1", modifier), "macro")
			button.modifier = modifier
			button:SetAttribute(format("%smacrotext1", modifier), worldmarker == 0 and "/cwm 0" or format("/cwm %d\n/wm %d", worldmarker, worldmarker))

			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				RM.frame:SetAlpha(1)
				if E.db.sle.raidmarkers.notooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(index == 9 and format("%s\n%s", L["Click to clear the mark."], format(L["%sClick to remove all worldmarkers."], button.modifier:upper()))
					or format("%s\n%s", L["Click to mark the target."], format(L["%sClick to place a worldmarker."], button.modifier:upper())), 1, 1, 1)
				GameTooltip:Show()
			end)
		end

		button:SetScript("OnLeave", function(self)
			self:SetBackdropBorderColor(0, 0, 0)
			GameTooltip:Hide()
			if RM.db.mouseover then
				RM.frame:SetAlpha(0)
			end
		end)
	end
end

--Size and orientation updates
function RM:UpdateBar(update)
	local height, width

	if E.db.sle.raidmarkers.orientation == "VERTICAL" then
		width = E.db.sle.raidmarkers.buttonSize + 4
		height = (E.db.sle.raidmarkers.buttonSize * 9) + (E.db.sle.raidmarkers.spacing * 8) + 4
	else
		width = (E.db.sle.raidmarkers.buttonSize * 9) + (E.db.sle.raidmarkers.spacing * 8) + 4
		height = E.db.sle.raidmarkers.buttonSize + 4
	end

	self.frame:SetWidth(width)
	self.frame:SetHeight(height)
	local head, tail
	for index = 9, 1, -1 do
		local button = self.frame.buttons[index]
		local prev = self.frame.buttons[index + 1]
		button:ClearAllPoints()

		button:Size(E.db.sle.raidmarkers.buttonSize)

		if E.db.sle.raidmarkers.orientation == "VERTICAL" then
			head = E.db.sle.raidmarkers.reverse and "BOTTOM" or "TOP"
			tail = E.db.sle.raidmarkers.reverse and "TOP" or "BOTTOM"
			if index == 9 then
				button:SetPoint(head, 0, (E.db.sle.raidmarkers.reverse and 2 or -2))
			else
				button:SetPoint(head, prev, tail, 0, E.db.sle.raidmarkers.spacing*(E.db.sle.raidmarkers.reverse and 1 or -1))
			end
		else
			head = E.db.sle.raidmarkers.reverse and "RIGHT" or "LEFT"
			tail = E.db.sle.raidmarkers.reverse and "LEFT" or "RIGHT"
			if index == 9 then
				button:SetPoint(head, (E.db.sle.raidmarkers.reverse and -2 or 2), 0)
			else
				button:SetPoint(head, prev, tail, E.db.sle.raidmarkers.spacing*(E.db.sle.raidmarkers.reverse and -1 or 1), 0)
			end
		end
	end

	if E.db.sle.raidmarkers.enable then self.frame:Show() else self.frame:Hide() end
end

function RM:Visibility()
	local db = E.db.sle.raidmarkers
	if db.enable then
		RegisterStateDriver(self.frame, "visibility", db.visibility == 'CUSTOM' and db.customVisibility or RM.VisibilityStates[db.visibility])
		E:EnableMover(self.frame.mover:GetName())
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.frame.mover:GetName())
	end
end

function RM:UpdateMouseover()
	RM:Bar_OnEnter()
	RM:Bar_OnLeave()
end

function RM:Backdrop()
	if E.db.sle.raidmarkers.backdrop then
		self.frame.backdrop:Show()
	else
		self.frame.backdrop:Hide()
	end
end

function RM:Initialize()
	if not SLE.initialized then return end
	RM.db = E.db.sle.raidmarkers

	--Keybinds
	RM:Make("SLE_RaidFlare1", "/clearworldmarker 1\n/worldmarker 1", "Blue Flare")
	RM:Make("SLE_RaidFlare2", "/clearworldmarker 2\n/worldmarker 2", "Green Flare")
	RM:Make("SLE_RaidFlare3", "/clearworldmarker 3\n/worldmarker 3", "Purple Flare")
	RM:Make("SLE_RaidFlare4", "/clearworldmarker 4\n/worldmarker 4", "Red Flare")
	RM:Make("SLE_RaidFlare5", "/clearworldmarker 5\n/worldmarker 5", "Yellow Flare")
	RM:Make("SLE_RaidFlare6", "/clearworldmarker 6\n/worldmarker 6", "Orange Flare")
	RM:Make("SLE_RaidFlare7", "/clearworldmarker 7\n/worldmarker 7", "White Flare")
	RM:Make("SLE_RaidFlare8", "/clearworldmarker 8\n/worldmarker 8", "Skull Flare")
	RM:Make("SLE_ClearRaidFlares", "/clearworldmarker 0", "Clear All Flares")

	--Create mark frame
	self.frame = CreateFrame("Frame", "SLE_RaidMarkerBar", E.UIParent, "SecureHandlerStateTemplate")
	self.frame:SetResizable(false)
	self.frame:SetClampedToScreen(true)
	self.frame:SetFrameStrata('LOW')
	self.frame:CreateBackdrop('Transparent')
	self.frame.backdrop:SetAllPoints()
	self.frame:ClearAllPoints()
	self.frame:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -1, 200)
	self.frame.buttons = {}

	self:HookScript(self.frame, 'OnEnter', 'Bar_OnEnter');
	self:HookScript(self.frame, 'OnLeave', 'Bar_OnLeave');

	for index = 1, 9 do
		self.frame.buttons[index] = self:CreateButton(index)
	end
	self:UpdateWorldMarkersAndTooltips()

	E:CreateMover(self.frame, "RaidMarkerBarAnchor", L["Raid Marker Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")

	function RM:ForUpdateAll()
		RM.db = E.db.sle.raidmarkers
		self:Visibility()
		self:Backdrop()
		-- self:UpdateWorldMarkersAndTooltips()
		self:UpdateBar()
		self:UpdateMouseover()
	end

	self:ForUpdateAll()
end

SLE:RegisterModule(RM:GetName())
