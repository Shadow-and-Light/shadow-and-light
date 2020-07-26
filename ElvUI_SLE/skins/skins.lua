local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Sk = SLE:NewModule("Skins")

--GLOBALS: CreateFrame
local _G = _G

Sk.additionalTextures = {}

function Sk:CreateUnderline(frame, texture, shadow, height)
	local line = CreateFrame("Frame", nil, frame)
	if line then
		line:SetPoint('BOTTOM', frame, -1, 1)
		line:SetSize(frame:GetWidth(), height or 1)
		line.Texture = line:CreateTexture(nil, 'OVERLAY')
		line.Texture:SetTexture(texture)
		if shadow then
			if shadow == "backdrop" then
				line:CreateShadow()
			else
				line:CreateBackdrop()
			end
		end
		line.Texture:SetAllPoints(line)
	end
	return line
end

function Sk:Media()
	if E.private.skins.blizzard.enable == true and E.private.skins.blizzard.merchant == true and E.private.sle.skins.merchant.enable == true and E.private.sle.skins.merchant.style == "List" then
		for i = 1, 10 do
			local button = _G["SLE_ListMerchantFrame_Button"..i]
			if not button then break end
			button.itemname:SetFont(E.LSM:Fetch('font', E.db.sle.skins.merchant.list.nameFont), E.db.sle.skins.merchant.list.nameSize, E.db.sle.skins.merchant.list.nameOutline)
			button.iteminfo:SetFont(E.LSM:Fetch('font', E.db.sle.skins.merchant.list.subFont), E.db.sle.skins.merchant.list.subSize, E.db.sle.skins.merchant.list.subOutline)
		end
	end
end

function Sk:UpdateObjectiveFrameLogos()
	Sk:UpdateAdditionalTexture(Sk.additionalTextures["ScenarioLogo"], SLE.ScenarioBlockLogos[E.private.sle.skins.objectiveTracker.skinnedTextureLogo] or E.private.sle.skins.objectiveTracker.customTextureLogo)
	Sk:UpdateAdditionalTexture(Sk.additionalTextures["ChallengeModeLogo"], SLE.ScenarioBlockLogos[E.private.sle.skins.objectiveTracker.skinnedTextureLogo] or E.private.sle.skins.objectiveTracker.customTextureLogo)
	if Sk.additionalTextures["WarfrontLogo"] then Sk:UpdateAdditionalTexture(Sk.additionalTextures["WarfrontLogo"], SLE.ScenarioBlockLogos[E.private.sle.skins.objectiveTracker.skinnedTextureLogo] or E.private.sle.skins.objectiveTracker.customTextureLogo) end
end

function Sk:UpdateAdditionalTexture(textureObject, newTexture)
	if textureObject then textureObject:SetTexture(newTexture) end
end

function Sk:Initialize()
	function Sk:ForUpdateAll()
		Sk:Update_ObjectiveTrackerUnderlinesVisibility()
		Sk:Update_ObjectiveTrackerUnderlinesColor()
		Sk:Media()
	end
end

SLE:RegisterModule(Sk:GetName())