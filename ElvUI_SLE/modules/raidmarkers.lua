local E, L, V, P, G = unpack(ElvUI);
local RM = E:GetModule('SLE_RaidMarkers');

BINDING_HEADER_RAIDFLARE = "|cff1784d1Shadow & Light|r"

local function make(name, command, description)
	_G["BINDING_NAME_CLICK "..name..":LeftButton"] = description
	local btn = CreateFrame("Button", name, nil, "SecureActionButtonTemplate")
	btn:SetAttribute("type", "macro")
	btn:SetAttribute("macrotext", command)
	btn:RegisterForClicks("AnyDown")
end

make("RaidFlare1", "/clearworldmarker 1\n/worldmarker 1", "Blue Flare")
make("RaidFlare2", "/clearworldmarker 2\n/worldmarker 2", "Green Flare")
make("RaidFlare3", "/clearworldmarker 3\n/worldmarker 3", "Purple Flare")
make("RaidFlare4", "/clearworldmarker 4\n/worldmarker 4", "Red Flare")
make("RaidFlare5", "/clearworldmarker 5\n/worldmarker 5", "Yellow Flare")
make("RaidFlare6", "/clearworldmarker 6\n/worldmarker 6", "Orange Flare")
make("RaidFlare7", "/clearworldmarker 7\n/worldmarker 7", "White Flare")
make("RaidFlare8", "/clearworldmarker 8\n/worldmarker 8", "Skull Flare")

make("ClearRaidFlares", "/clearworldmarker 0", "Clear All Flares")

local layouts = {
	[1] = {RT = 1, WM = 5},	-- Star
	[2] = {RT = 2, WM = 6},	-- Circle
	[3] = {RT = 3, WM = 3},	-- Diamond
	[4] = {RT = 4, WM = 2},	-- Triangle
	[5] = {RT = 5, WM = 7},	-- Moon
	[6] = {RT = 6, WM = 1},	-- Square
	[7] = {RT = 7, WM = 4},	-- Cross
	[8] = {RT = 8, WM = 8},	-- Skull
	[9] = {RT = 0, WM = 0},	-- clear target/worldmarker
}

function RM:CreateButtons()
	for k, layout in ipairs(layouts) do
		local button = CreateFrame("Button", ("RaidMarkerBarButton%d"):format(k), self.frame, "SecureActionButtonTemplate")
		button:SetHeight(self.db.buttonSize)
		button:SetWidth(self.db.buttonSize)
		button:SetTemplate('Transparent')

		local image = button:CreateTexture(nil, "ARTWORK")
		image:SetAllPoints()
		image:SetTexture(k == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or ("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(k))

		local target, worldmarker = layout.RT, layout.WM

		if target then
			button:SetAttribute("type1", "macro")
			button:SetAttribute("macrotext1", ("/tm %d"):format(k == 9 and 0 or k))
		end

		button:RegisterForClicks("AnyDown")
		self.frame.buttons[k] = button
	end
end

function RM:UpdateWorldMarkersAndTooltips()
	for i = 1, 9 do
		local target, worldmarker = layouts[i].RT, layouts[i].WM
		local button = self.frame.buttons[i]

		if target and not worldmarker then
			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(k == 9 and L["Click to clear the mark."] or L["Click to mark the target."], 1, 1, 1)
				GameTooltip:Show()
			end)
		else
			local modifier = self.db.modifier or "shift-"
			button:SetAttribute(("%stype1"):format(modifier), "macro")
			button.modifier = modifier
			button:SetAttribute(("%smacrotext1"):format(modifier), worldmarker == 0 and "/cwm all" or ("/cwm %d\n/wm %d"):format(worldmarker, worldmarker))	

			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(k == 9 and ("%s\n%s"):format(L["Click to clear the mark."], (L["%sClick to remove all worldmarkers."]):format(button.modifier:upper()))
					or ("%s\n%s"):format(L["Click to mark the target."], (L["%sClick to place a worldmarker."]):format(button.modifier:upper())), 1, 1, 1)
				GameTooltip:Show()
			end)			
		end

		button:SetScript("OnLeave", function(self)
			self:SetBackdropBorderColor(0, 0, 0)
			GameTooltip:Hide() 
		end)	
	end
end

function RM:UpdateBar(update)
	if update then self.db = E.db.sle.raidmarkers end
	local height, width

	if self.db.orientation == "VERTICAL" then
		width = self.db.buttonSize + 4
		height = (self.db.buttonSize * 9) + (self.db.spacing * 8) + 4
	else
		width = (self.db.buttonSize * 9) + (self.db.spacing * 8) + 4
		height = self.db.buttonSize + 4
	end

	self.frame:SetWidth(width)
	self.frame:SetHeight(height)
	local head, tail
	for i = 9, 1, -1 do
		local button = self.frame.buttons[i]
		local prev = self.frame.buttons[i + 1]
		button:ClearAllPoints()

		button:SetWidth(self.db.buttonSize)
		button:SetHeight(self.db.buttonSize)
		
		if self.db.orientation == "VERTICAL" then
			head = self.db.reverse and "BOTTOM" or "TOP"
			tail = self.db.reverse and "TOP" or "BOTTOM"
			if i == 9 then
				button:SetPoint(head, 0, (self.db.reverse and 2 or -2))
			else
				button:SetPoint(head, prev, tail, 0, self.db.spacing*(self.db.reverse and 1 or -1))
			end
		else
			head = self.db.reverse and "RIGHT" or "LEFT"
			tail = self.db.reverse and "LEFT" or "RIGHT"
			if i == 9 then
				button:SetPoint(head, (self.db.reverse and -2 or 2), 0)
			else
				button:SetPoint(head, prev, tail, self.db.spacing*(self.db.reverse and -1 or 1), 0)
			end
		end
	end

	if self.db.enable then self.frame:Show() else self.frame:Hide() end
end

function RM:ToggleSettings()
	if self.db.enable then
		RegisterStateDriver(self.frame, "visibility", self.db.visibility == 'DEFAULT' and '[noexists, nogroup] hide; show' or self.db.visibility == 'ALWAYS' and '[petbattle] hide; show' or self.db.visibility == 'CUSTOM' and self.db.customVisibility or '[group] show; [petbattle] hide; hide')
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
	end
	if self.db.backdrop then
		self.frame.backdrop:Show()
	else
		self.frame.backdrop:Hide()
	end

	self:UpdateBar()
	self:UpdateWorldMarkersAndTooltips()
end

function RM:Initialize()
	self.db = E.db.sle.raidmarkers

	self.frame = CreateFrame("Frame", "RaidMarkerBar", E.UIParent, "SecureHandlerStateTemplate")
	self.frame:SetResizable(false)
	self.frame:SetClampedToScreen(true)
	self.frame:SetFrameStrata('LOW')
	self.frame:CreateBackdrop('Transparent')
	self.frame:ClearAllPoints()
	self.frame:Point("BOTTOMRIGHT", E.UIParent, "TOPRIGHT", -1, 200)
	self.frame.buttons = {}

	self.frame.backdrop:SetAllPoints()

	E:CreateMover(self.frame, "RaidMarkerBarAnchor", L['Raid Marker Bar'], nil, nil, nil, "ALL,S&L,S&L MISC")

	self:CreateButtons()
	self:ToggleSettings()
end