local E, L, V, P, G = unpack(ElvUI);
local LastUpdate = 1

board[4].Status:SetScript("OnUpdate", function(self, elapsed)
	LastUpdate = LastUpdate - elapsed

	if(LastUpdate < 0) then
		self:SetMinMaxValues(0, 200)
		local value = (select( 3, GetNetStats()))
		local max = 200
		self:SetValue(value)
		board[4].Text:SetText("MS: " .. value)

		if( value * 100 / max <= 35) then
			self:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
		elseif value * 100 / max > 35 and value * 100 / max < 75 then
			self:SetStatusBarColor(1, 180 / 255, 0, .8)
		else
			self:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
		end
		LastUpdate = 1
	end
end)