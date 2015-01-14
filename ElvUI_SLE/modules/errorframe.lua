local E, L, V, P, G = unpack(ElvUI); 
local F = E:GetModule('SLE_ErrorFrame');

function F:SetSize()
	UIErrorsFrame:SetSize(E.db.sle.errorframe.width, E.db.sle.errorframe.height) --512 x 60
end

function F:Initialize()
	F:SetSize()
	E:CreateMover(UIErrorsFrame, "UIErrorsFrameMover", L["Error Frame"], nil, nil, nil, "ALL,S&L,S&L MISC")
end