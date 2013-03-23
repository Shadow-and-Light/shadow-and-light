local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DTP = E:NewModule('DTPanels', 'AceHook-3.0', 'AceEvent-3.0');
local DT = E:GetModule('DataTexts');
local LO = E:GetModule('Layout');
local dp1 = CreateFrame('Frame', "DP_1", E.UIParent)
local dp2 = CreateFrame('Frame', "DP_2", E.UIParent)
local top = CreateFrame('Frame', "Top_Center", E.UIParent)
local dp3 = CreateFrame('Frame', "DP_3", E.UIParent)
local dp4 = CreateFrame('Frame', "DP_4", E.UIParent)
local dp5 = CreateFrame('Frame', "DP_5", E.UIParent)
local bottom = CreateFrame('Frame', "Bottom_Panel", E.UIParent)
local dp6 = CreateFrame('Frame', "DP_6", E.UIParent)

local panels = {
	--Panel = short, name, point, x, panel, slot
	DP_1 = {"dp1", "DP_1", "TOPLEFT", 0, DP_1, 3},
	DP_2 = {"dp2", "DP_2", "TOP", -(E.screenwidth/5), DP_2, 3},
	Top_Center = {"top", "Top_Center", "TOP", 0, Top_Center, 1},
	DP_3 = {"dp3", "DP_3", "TOP", (E.screenwidth/5), DP_3, 3},
	DP_4 = {"dp4", "DP_4", "TOPRIGHT", 0, DP_4, 3},
	DP_5 = {"dp5", "DP_5", "BOTTOM", -(E.screenwidth/6 - 15), DP_5, 3},
	Bottom_Panel = {"bottom", "Bottom_Panel", "BOTTOM", 0, Bottom_Panel, 1},
	DP_6 = {"dp6", "DP_6", "BOTTOM", (E.screenwidth/6 - 15), DP_6, 3},
}

--Added function to create new panels
LO.InitializeSLE = LO.Initialize
function LO:Initialize()
	LO.InitializeSLE(self)
	for _,v in pairs(panels) do
		DTP:CreateDataPanels(v[5], v[2], v[3], v[4], v[6], v[1])
	end
	DTP:Resize()
	
	for _,v in pairs(panels) do
		E:CreateMover(v[5], v[2].."_Mover", L[v[2]], nil, nil, nil, "ALL,S&L,S&L DT")
	end
end

-- New panels
function DTP:CreateDataPanels(panel, name, point, x, slot, short)
	panel:SetFrameStrata('LOW')
	panel:Point(point, E.UIParent, point, x, 0); 
	DT:RegisterPanel(panel, slot, 'ANCHOR_BOTTOM', 0, -4)
	panel:Hide()
end

function DTP:Resize()
	local db = E.db.sle.datatext
	for _,v in pairs(panels) do
		v[5]:Size(db[v[1]].width, 20)
	end
	DT:UpdateAllDimensions()
end

function DTP:ChatResize()
	LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1))
	RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - E.db.sle.datatext.chatright.width - 16, (E.PixelMode and -19 or -21))
end

--Showing panels
function DTP:ExtraDataBarSetup()
	local db = E.db.sle.datatext
	for _,v in pairs(panels) do
		if db[v[1]].enabled then
			v[5]:Show()
		else
			v[5]:Hide()
		end
		if not E.private.sle.datatext[v[1].."hide"] then
			if db[v[1]].transparent then
				v[5]:SetTemplate("Transparent")
			else
				v[5]:SetTemplate("Default", true)
			end
		end
	end
end

function DTP:Update()
	DTP:ExtraDataBarSetup()
	DTP:Resize()
end

function DTP:RegisterHide()
	local db = E.db.sle.datatext
	for k,v in pairs(panels) do
		if db[v[1]].pethide then
			E.FrameLocks[k] = true
		else
			E.FrameLocks[k] = nil
		end
	end
end

--Renew panels after loading screens
function DTP:PLAYER_ENTERING_WORLD(...)
DTP:ExtraDataBarSetup()
DTP:RegisterHide()
self:UnregisterEvent("PLAYER_ENTERING_WORLD");
end
DTP:RegisterEvent('PLAYER_ENTERING_WORLD')

E:RegisterModule(DTP:GetName())