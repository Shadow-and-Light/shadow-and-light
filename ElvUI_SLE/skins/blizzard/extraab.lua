local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
	
local function PositionHookUpdate()
	-- hook the ExtraActionButton1 texture, idea by roth via WoWInterface forums
	-- code taken from Tukui
	local button = ExtraActionButton1
	local icon = button.icon
	local texture = button.style

	local function disableTexture(style, texture)
		if string.sub(texture,1,9) == "Interface" then
			style:SetTexture("")
		end
	end
	button.style:SetTexture("")
	hooksecurefunc(texture, "SetTexture", disableTexture)
end

local frame = CreateFrame("Frame", nil, nil)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent",function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		PositionHookUpdate()
		frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)	