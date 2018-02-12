local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local SUF = SLE:GetModule("UnitFrames")

SUF.DeadTextures = {
	["SKULL"] = [[Interface\LootFrame\LootPanel-Icon]],
	["SKULL1"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SKULL]],
	["SKULL2"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SKULL1]],
	["SKULL3"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SKULL2]],
	["SKULL4"] = [[Interface\AddOns\ElvUI_SLE\media\textures\SKULL3]],
}

function SUF:Construct_Dead(frame, group)
	local db = E.db.sle.unitframes.unit[group].dead
	local dead = frame.RaisedElementParent.TextureParent:CreateTexture(frame:GetName().."Dead", "OVERLAY")
	dead:SetSize(db.size, db.size)
	dead:SetPoint("CENTER", frame, "CENTER", db.xOffset, db.yOffset)
	dead.Group = "ElvUF_"..T.StringToUpper(group)
	dead:Hide()

	return dead
end
