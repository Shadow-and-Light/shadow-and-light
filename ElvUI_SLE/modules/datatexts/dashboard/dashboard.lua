--[[ Dashboard for ElvUI
Credits : Sinaris, Elv
made for ElvUI under Sinaris permission. Big thanks :)
]]

local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DTP = E:GetModule('DTPanels')
if E.db.sle == nil then E.db.sle = {} end
if E.db.sle.datatext == nil then E.db.sle.datatext = {} end
if E.db.sle.datatext.dashboard == nil then E.db.sle.datatext.dashboard = {} end
if E.db.sle.datatext.dashboard.width == nil then E.db.sle.datatext.dashboard.width = 100 end
local DTPANELS_WIDTH = E.db.sle.datatext.dashboard.width
local DTPANELS_HEIGHT = 20
local PANEL_SPACING = 1
local font = P.general.font
local fontsize = 10 

local board = {}

local bholder = CreateFrame("Frame", "BoardsHolder", E.UIParent)
bholder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 0, -21)
bholder:Size(((DTPANELS_WIDTH*4)+(PANEL_SPACING*3)), DTPANELS_HEIGHT)

E:CreateMover(BoardsHolder, "Dashboard", L["Dashboard"], nil, nil, nil, "ALL,S&L,S&L MISC")

local board = CreateFrame('frame', 'board', BoardsHolder)
	
for i = 1, 4 do
	board[i] = CreateFrame('frame', 'board'..i, bholder)
	board[i]:SetFrameLevel(2)
	board[i]:Size(DTPANELS_WIDTH, DTPANELS_HEIGHT)
	board[i]:SetTemplate('Default', true)
	board[i]:CreateShadow('Default')

	if i == 1 then
		board[i]:Point('TOPLEFT', bholder, 'TOPLEFT', 0, 0)
	else
		board[i]:Point('LEFT', board[i-1], 'RIGHT', PANEL_SPACING, 0)
	end
	
	board[i].Status = CreateFrame("StatusBar", "PanelStatus" .. i, board[i])
	board[i].Status:SetFrameLevel(12)
	board[i].Status:SetStatusBarTexture(E["media"].normTex)
	board[i].Status:SetMinMaxValues(0, 100)
	board[i].Status:SetStatusBarColor(.4, .4, .4, 1)
	board[i].Status:Point("TOPLEFT", board[i], "TOPLEFT", 2, -2)
	board[i].Status:Point("BOTTOMRIGHT", board[i], "BOTTOMRIGHT", -2, 2)

	board[i].Text = board[i].Status:CreateFontString( nil, "OVERLAY" )
	board[i].Text:FontTemplate()
	board[i].Text:SetFont(font, fontsize)
	board[i].Text:Point("LEFT", board[i], "LEFT", 3, 0)
	board[i].Text:SetJustifyV('MIDDLE')
	board[i].Text:SetShadowColor(0, 0, 0)
	board[i].Text:SetShadowOffset(1.25, -1.25)
end

function DTP:DashboardShow()
	if E.db.sle.datatext.dashboard.enable then
		E.FrameLocks['BoardsHolder'] = true
		BoardsHolder:Show()
	else
		E.FrameLocks['BoardsHolder'] = nil
		BoardsHolder:Hide()
	end
end

function DTP:DashWidth()
	for i = 1, 4 do
		board[i]:Size(E.db.sle.datatext.dashboard.width, DTPANELS_HEIGHT)
	end
	bholder:Size(((E.db.sle.datatext.dashboard.width*4)+(PANEL_SPACING*3)), DTPANELS_HEIGHT)
end