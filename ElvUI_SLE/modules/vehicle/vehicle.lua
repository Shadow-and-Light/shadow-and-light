local E, L, V, P, G = unpack(ElvUI);
local EVB = E:NewModule("EnhancedVehicleBar");
local AB = E:GetModule("ActionBars");

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
	bar:Show()
	bar.anim:Play()
end

function EVB:AnimSlideOut(bar)
	if bar.anim then
		bar.anim:Finish()
	end

	bar.anim:Stop()
	bar.anim.out1:Play()
end

function EVB:CreateExtraButtonSet(type, page, visibility)
	local barFrame = self.barFrame
	barFrame[type] = {}
	for i = 1, 6 do
		barFrame[type]['Button'..i] = CreateFrame('CheckButton', 'ElvUISLEEnhancedVehicleBar_'..type..i, barFrame, 'ActionBarButtonTemplate')
		barFrame[type]['Button'..i]:Size(self.size)
		barFrame[type]['Button'..i]:SetID(i)
		barFrame[type]['Button'..i]:SetAttribute('actionpage', page)
		barFrame[type]['Button'..i]:SetAttribute('action', i)
		AB:StyleButton(barFrame[type]['Button'..i]);
		RegisterStateDriver(barFrame[type]['Button'..i], 'visibility', '[petbattle] hide; '..visibility)

		if (i == 1) then
			barFrame[type]['Button'..i]:SetPoint('BOTTOMLEFT', self.spacing, self.spacing)
		else
			local prev = barFrame[type]['Button'..i-1]
			barFrame[type]['Button'..i]:SetPoint('LEFT', prev, 'RIGHT', self.spacing, 0)
		end
	end
end

function EVB:Initialize()
	if (not E.private.sle.vehicle.enable) then return end;

	local visibility = "[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] hide; show"

	hooksecurefunc(AB, "PositionAndSizeBar", function(self, barName)
		local bar = self["handledBars"][barName]
		if (self.db[barName].enabled) then
			UnregisterStateDriver(bar, 'visibility');
			RegisterStateDriver(bar, 'visibility', visibility);
		end
	end);

	local size = 40;
	local spacing = E:Scale(AB.db["bar1"].buttonspacing);
	local barFrame = CreateFrame("Frame", "ElvUISLEEnhancedVehicleBar", UIParent, "SecureHandlerStateTemplate");

	self.size = size;
	self.spacing = spacing;

	barFrame:SetWidth((size * 6) + (spacing * 7));
	barFrame:SetHeight(size + (spacing * 2));
	barFrame:SetTemplate("Transparent");
	barFrame:CreateShadow();
	if (E:GetModule("EnhancedShadows", true)) then
		E:GetModule("EnhancedShadows"):RegisterShadow(barFrame.shadow);
	end

	barFrame:SetPoint("BOTTOM", 0, 34);
	barFrame:HookScript("OnShow", function(frame) self:AnimSlideIn(frame) end);
	RegisterStateDriver(barFrame, 'visibility', '[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] show; hide');
	self:Animate(barFrame, 0, -(barFrame:GetHeight()), 1);

	self.barFrame = barFrame;

	self:CreateExtraButtonSet('vehicle', 12, '[vehicleui][possessbar] show; hide')
	self:CreateExtraButtonSet('shapeshit', 13, '[shapeshift] show; hide')
	self:CreateExtraButtonSet('override', 14, '[overridebar] show; hide')
end

E:RegisterModule(EVB:GetName())