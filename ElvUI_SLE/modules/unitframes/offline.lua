local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")

SUF.OfflineTextures = {
	["ALERT"] = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
	["ARTHAS"] = [[Interface\LFGFRAME\UI-LFR-PORTRAIT]],
	["SKULL"] = [[Interface\LootFrame\LootPanel-Icon]],
	["PASS"] = [[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]],
	["NOTREADY"] = [[Interface\RAIDFRAME\ReadyCheck-NotReady]],
}

function SUF:Construct_Offline(frame, group)
	local db = E.db.sle.unitframes.unit[group].offline
	local offline = frame:CreateTexture(frame:GetName().."Offline", "OVERLAY")
	offline:SetSize(db.size, db.size)
	offline:SetPoint("CENTER", frame, "CENTER", db.xOffset, db.yOffset)
	offline.Group = "ElvUF_"..T.StringToUpper(group)
	offline:Hide()

	return offline
end