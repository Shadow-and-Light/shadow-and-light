local E, L, V, P, G = unpack(ElvUI); 
local LastUpdate = 1

board[2].Status:SetScript("OnUpdate", function(self)
	local free, total, used = 0, 0, 0
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free
	value = (used * 120 / total)

	self:SetMinMaxValues(0, total)
	self:SetValue(used)
		board[2].Text:SetText(L["Bags"]..": " .. used .. " /" .. total)
	if(used * 100 / total >= 75) then
		self:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
	elseif used * 100 / total < 75 and used * 100 / total > 40 then
		self:SetStatusBarColor(1, 180 / 255, 0, .8)
	else
		self:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
	end
end)

board[2].Status:RegisterEvent("BAG_UPDATE")