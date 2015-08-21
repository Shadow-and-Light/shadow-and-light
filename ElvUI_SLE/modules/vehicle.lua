local E, L, V, P, G = unpack(ElvUI);
local EVB = E:GetModule("SLE_EnhancedVehicleBar")
local AB = E:GetModule("ActionBars");
local LAB = LibStub("LibActionButton-1.0-ElvUI")

-- Regular Button for these bars are 52. 52 * .71 = ~37.. I just rounded it up to 40 and called it good.
function EVB:Animate(bar, x, y, duration)
	bar.anim = bar:CreateAnimationGroup('Move_In')
	bar.anim.in1 = bar.anim:CreateAnimation('Translation')
	bar.anim.in1:SetDuration(0)
	bar.anim.in1:SetOrder(1)
	bar.anim.in2 = bar.anim:CreateAnimation('Translation')
	bar.anim.in2:SetDuration(duration)
	bar.anim.in2:SetOrder(2)
	bar.anim.in2:SetSmoothing('OUT')
	bar.anim.out1 = bar:CreateAnimationGroup('Move_Out')
	bar.anim.out2 = bar.anim.out1:CreateAnimation('Translation')
	bar.anim.out2:SetDuration(duration)
	bar.anim.out2:SetOrder(1)
	bar.anim.out2:SetSmoothing('IN')
	bar.anim.in1:SetOffset(x, y)
	bar.anim.in2:SetOffset(-x, -y)
	bar.anim.out2:SetOffset(x, y)
	bar.anim.out1:SetScript('OnFinished', function() bar:Hide() end)
end

function EVB:AnimSlideIn(bar)
	if not bar.anim then
		Animate(bar)
	end

	bar.anim.out1:Stop()
	bar.anim:Play()
end

function EVB:AnimSlideOut(bar)
	if bar.anim then
		bar.anim:Finish()
	end

	bar.anim:Stop()
	bar.anim.out1:Play()
end

function EVB:CreateExtraButtonSet()
	local bar = self.bar
	bar.buttons = {}
	for i = 1, 7 do
		i = i == 7 and 12 or i

		bar.buttons[i] = LAB:CreateButton(i, format(bar:GetName().."Button%d", i), bar, nil);
		bar.buttons[i]:SetState(0, "action", i);
		
		for k = 1, 14 do
			bar.buttons[i]:SetState(k, "action", (k - 1) * 12 + i)
		end

		if i == 12 then
			bar.buttons[i]:SetState(12, "custom", AB.customExitButton)
		end	

		bar.buttons[i]:Size(self.size);

		if (i == 1) then
			bar.buttons[i]:SetPoint('BOTTOMLEFT', self.spacing, self.spacing)
		else
			local prev = i == 12 and bar.buttons[6] or bar.buttons[i-1];
			bar.buttons[i]:SetPoint('LEFT', prev, 'RIGHT', self.spacing, 0)
		end

		AB:StyleButton(bar.buttons[i], nil, nil, true);
		bar.buttons[i]:SetCheckedTexture("")
		RegisterStateDriver(bar.buttons[i], 'visibility', '[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] show; hide')

	end
end

function EVB:Initialize()
	if (not E.private.sle.vehicle.enable) then return end;

	local visibility = "[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] hide;"
	local page = format("[vehicleui] %d; [possessbar] %d; [overridebar] %d; [shapeshift] 13;", GetVehicleBarIndex(), GetVehicleBarIndex(), GetOverrideBarIndex());
	local bindButtons = "ACTIONBUTTON";

	hooksecurefunc(AB, "PositionAndSizeBar", function(self, barName)
		local bar = self["handledBars"][barName]
		if (self.db[barName].enabled) and (barName == "bar1") then
			UnregisterStateDriver(bar, 'visibility');
			RegisterStateDriver(bar, 'visibility', visibility..self.db[barName].visibility);
		end
	end);

	local size = 40;
	local spacing = E:Scale(AB.db["bar1"].buttonspacing);
	local bar = CreateFrame("Frame", "ElvUISLEEnhancedVehicleBar", UIParent, "SecureHandlerStateTemplate");

	self.size = size;
	self.spacing = spacing;

	bar:SetWidth((size * 7) + (spacing * 8));
	bar:SetHeight(size + (spacing * 2));
	bar:SetTemplate("Transparent");
	bar:CreateShadow();
	if (E:GetModule("EnhancedShadows", true)) then
		E:GetModule("EnhancedShadows"):RegisterShadow(bar.shadow);
	end

	bar:SetPoint("BOTTOM", 0, 34);
	bar:HookScript("OnShow", function(frame) self:AnimSlideIn(frame) end);
	RegisterStateDriver(bar, 'visibility', '[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] show; hide');
	RegisterStateDriver(bar, 'page', page);

	bar:SetAttribute("_onstate-page", [[
		if HasTempShapeshiftActionBar() and self:GetAttribute("hasTempBar") then
			newstate = GetTempShapeshiftBarIndex() or newstate
		end	

		if newstate ~= 0 then
			self:SetAttribute("state", newstate)
			control:ChildUpdate("state", newstate)
		else
			local newCondition = self:GetAttribute("newCondition")
			if newCondition then
				newstate = SecureCmdOptionParse(newCondition)
				self:SetAttribute("state", newstate)
				control:ChildUpdate("state", newstate)
			end
		end
	]]);

	self:Animate(bar, 0, -(bar:GetHeight()), 1);

	self.bar = bar;

	self:CreateExtraButtonSet();

	AB:UpdateButtonConfig(bar, bindButtons);
end