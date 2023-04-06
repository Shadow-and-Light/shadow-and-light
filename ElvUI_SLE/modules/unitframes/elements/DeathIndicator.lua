local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local SUF = SLE.UnitFrames

SUF.DeadTextures = {
	["SKULL"] = [[Interface\LootFrame\LootPanel-Icon]],
	["SKULL1"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SKULL]],
	["SKULL2"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SKULL1]],
	["SKULL3"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SKULL2]],
	["SKULL4"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SKULL3]],
}

function SUF:Construct_DeathIndicator(frame)
	local SL_DeathIndicator = frame.RaisedElementParent.TextureParent:CreateTexture(nil, 'OVERLAY', nil, 7)

	SL_DeathIndicator:Point('CENTER', frame, 'CENTER', 0, 0)
	SL_DeathIndicator:Size(36)

	return SL_DeathIndicator
end

function SUF:Configure_DeathIndicator(frame)
	local SL_DeathIndicator = frame.SL_DeathIndicator
	local db = E.db.sle.unitframe.units[frame.unitframeType].deathIndicator

	frame.db.SL_DeathIndicator = db

	local width = db.size
	local height = db.keepSizeRatio and db.size or db.height

	SL_DeathIndicator:ClearAllPoints()
	SL_DeathIndicator:Point('CENTER', frame, db.anchorPoint, db.xOffset, db.yOffset)

	if db.texture ~= 'CUSTOM' and SLE:TextureExists(SUF.DeadTextures[db.texture]) then
		SL_DeathIndicator:SetTexture(SUF.DeadTextures[db.texture])
	elseif SLE:TextureExists(db.custom) then
		SL_DeathIndicator:SetTexture(db.custom)
	else
		SL_DeathIndicator:SetTexture([[Interface\LootFrame\LootPanel-Icon]])
	end

	SL_DeathIndicator:Size(width, height)
	-- SL_DeathIndicator:SetFrameStrata()
	-- SL_DeathIndicator:SetFrameLevel()

	if db.enable and not frame:IsElementEnabled('SL_DeathIndicator') then
		frame:EnableElement('SL_DeathIndicator')
	elseif not db.enable and frame:IsElementEnabled('SL_DeathIndicator') then
		frame:DisableElement('SL_DeathIndicator')
	end
end
