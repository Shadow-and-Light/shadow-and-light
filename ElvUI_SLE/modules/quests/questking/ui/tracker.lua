local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local function Replace()
	local QuestKing = _G["QuestKing"]
	local Tracker = QuestKing.Tracker
	function Tracker:ToggleDrag()
		DEFAULT_CHAT_FRAME:AddMessage(T.format("|cff99ccffQuestKing|cff6090ff:|r This option is no longer available"))
		return true
	end

	function Tracker:CheckDrag()
		self.titlebarText2:Hide()
		self:EnableMouse(false)
		self:SetMovable(false)
		self:RegisterForDrag()
		self:SetScript("OnDragStart", nil)
		self:SetScript("OnDragStop", nil)
	end

	Tracker.titlebar:ClearAllPoints()
	Tracker.titlebar:SetPoint("TOP", ObjectiveFrameHolder)
	Tracker:CheckDrag()
end

T.tinsert(QK.Replaces, Replace)