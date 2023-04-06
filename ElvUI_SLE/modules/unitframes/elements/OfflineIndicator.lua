local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

SUF.OfflineTextures = {
	["ALERT"] = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
	["ARTHAS"] = [[Interface\LFGFRAME\UI-LFR-PORTRAIT]],
	["SKULL"] = [[Interface\LootFrame\LootPanel-Icon]],
	["PASS"] = [[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]],
	["NOTREADY"] = [[Interface\RAIDFRAME\ReadyCheck-NotReady]],
}

function SUF:Construct_OfflineIndicator(frame)
	-- print('Construct_OfflineIndicator: ', frame:GetName())
	local SL_OfflineIndicator = frame.RaisedElementParent.TextureParent:CreateTexture(nil, 'OVERLAY', nil, 7)

	SL_OfflineIndicator:Point('CENTER', frame, 'CENTER', 0, 0)
	SL_OfflineIndicator:Size(36)

	return SL_OfflineIndicator
end

function SUF:Configure_OfflineIndicator(frame)
	-- print('Configure_OfflineIndicator: ', frame:GetName())
	local SL_OfflineIndicator = frame.SL_OfflineIndicator
	local db = E.db.sle.unitframe.units[frame.unitframeType].offlineIndicator

	frame.db.SL_OfflineIndicator = db

	local width = db.size
	local height = db.keepSizeRatio and db.size or db.height

	SL_OfflineIndicator:ClearAllPoints()
	SL_OfflineIndicator:Point('CENTER', frame, db.anchorPoint, db.xOffset, db.yOffset)

	if db.texture ~= 'CUSTOM' and SLE:TextureExists(SUF.OfflineTextures[db.texture]) then
		SL_OfflineIndicator:SetTexture(SUF.OfflineTextures[db.texture])
	elseif SLE:TextureExists(db.custom) then
		SL_OfflineIndicator:SetTexture(db.custom)
	else
		SL_OfflineIndicator:SetTexture([[Interface\LootFrame\LootPanel-Icon]])
	end

	SL_OfflineIndicator:Size(width, height)
	-- SL_OfflineIndicator:SetFrameStrata()
	-- SL_OfflineIndicator:SetFrameLevel()

	if db.enable and not frame:IsElementEnabled('SL_OfflineIndicator') then
		frame:EnableElement('SL_OfflineIndicator')
	elseif not db.enable and frame:IsElementEnabled('SL_OfflineIndicator') then
		frame:DisableElement('SL_OfflineIndicator')
	end
end
