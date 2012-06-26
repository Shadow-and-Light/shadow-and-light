local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local AB = E:GetModule('ActionBars');
--[[	
AB["barDefaults"] = {
	["bar1"] = {
		['page'] = 1,
		['bindButtons'] = "ACTIONBUTTON",
		['conditions'] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
		['position'] = "BOTTOM,ElvUIParent,BOTTOM,0,21",
	},
	["bar2"] = {
		['page'] = 5,
		['bindButtons'] = "MULTIACTIONBAR2BUTTON",
		['conditions'] = "",
		['position'] = "BOTTOM,ElvUI_Bar1,TOP,0,2",
	},
	["bar3"] = {
		['page'] = 6,
		['bindButtons'] = "MULTIACTIONBAR1BUTTON",
		['conditions'] = "",
		['position'] = "LEFT,ElvUI_Bar1,RIGHT,4,0",
	},
	["bar4"] = {
		['page'] = 4,
		['bindButtons'] = "MULTIACTIONBAR4BUTTON",
		['conditions'] = "",
		['position'] = "RIGHT,ElvUIParent,RIGHT,-4,0",
	},
	["bar5"] = {
		['page'] = 3,
		['bindButtons'] = "MULTIACTIONBAR3BUTTON",
		['conditions'] = "",
		['position'] = "RIGHT,ElvUI_Bar1,LEFT,-4,0",
	},	
}	
]]
 --Will do something with this after i found how defaults for it are set.
	--local function PositionStanceBar()
	--ElvUI_BarShapeShift:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -4);
		--[[AB.movers['barShapeShift']["p"] = "BOTTOMRIGHT"
		AB.movers['barShapeShift']["p2"] = LeftChatPanel
		AB.movers['barShapeShift']["p3"] = "TOPRIGHT"
		AB.movers['barShapeShift']["p4"] = 2
		AB.movers['barShapeShift']["p5"] = -3]]
	--end
	
	local function PositionGMMover() --Still works lol O_o
		if not E:HasMoverBeenMoved('GMMover') then
			GMMover:ClearAllPoints()
			GMMover:Point("TOPLEFT", E.UIParent, "TOPLEFT", 310, -1)
		end
	end

local function PositionHookUpdate()
	
	--For some reason the FocusTarget frame position won't stick unless I do this. UF positions are set in install.lua
	E:MoveUI(true, 'unitframes')
	E:MoveUI(false)

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