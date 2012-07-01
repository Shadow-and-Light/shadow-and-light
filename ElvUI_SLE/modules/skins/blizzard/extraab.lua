local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
	
local function PositionHookUpdate()
	--[[
	--For some reason the FocusTarget frame position won't stick unless I do this. UF positions are set in install.lua
	E:MoveUI(true, 'unitframes')
	E:MoveUI(false)
]]
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