local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if SLE._Compatibility["ElvUI_NihilistUI"] then return end
local ES = SLE:NewModule('EnhancedShadows', 'AceEvent-3.0')
local MM = E:GetModule('Minimap')

--GLOBALS: hooksecurefunc
local _G = _G
local UnitAffectingCombat = UnitAffectingCombat
local SIDE_BUTTON = E.db.chat.hideChatToggles and 0 or 19
local Border
local Abars = 10

--Registered shadows table
ES.CreatedShadows = {}
ES.DummyPanels = {}

--The table for frames groupped based on similariy
ES.FramesToShadow = {
	["Datapanels"] = {
		["leftchat"] = "LeftChatDataPanel",
		["rightchat"] = "RightChatDataPanel",
	},
	["databars"] = {
		["honorbar"] = "ElvUI_HonorBar",
		["expbar"] = "ElvUI_ExperienceBar",
		["repbar"] = "ElvUI_ReputationBar",
		["azeritebar"] = "ElvUI_AzeriteBar",
	},
}

--Updating all shadows
function ES:UpdateShadows()
	if UnitAffectingCombat('player') then ES:RegisterEvent('PLAYER_REGEN_ENABLED', ES.UpdateShadows) return end
	ES:UnregisterEvent('PLAYER_ENTERING_WORLD')

	for frame, _ in pairs(ES.CreatedShadows) do
		ES:UpdateShadow(frame)
	end
end

--Update specific shadow
function ES:UpdateShadow(shadow)
	local shadowcolor = E.db.sle.shadows.shadowcolor
	local r, g, b = shadowcolor.r, shadowcolor.g, shadowcolor.b

	local size = E.db.sle.shadows.size
	shadow:SetOutside(shadow:GetParent(), size, size)
	shadow:SetBackdrop({
		edgeFile = Border, edgeSize = size > 3 and size or 3,
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(r, g, b, 0)
	shadow:SetBackdropBorderColor(r, g, b, 0.9)
end

--Regestering shadows and putting them to a table for easy tracking since they don't have actual names
function ES:RegisterShadow(shadow)
	if not shadow or shadow.isRegistered then return end
	ES.CreatedShadows[shadow] = true
	shadow.isRegistered = true
end

--Creating shadows for provided frame
function ES:CreateFrameShadow(frame, parent)
	if not frame then return end

	frame:CreateShadow()
	frame.EnhShadow = frame.shadow
	frame.shadow = nil
	ES:RegisterShadow(frame.EnhShadow)
	if parent and parent ~= "none" then
		frame.EnhShadow:SetParent(parent)
	elseif not parent then
		frame.EnhShadow:SetParent(frame)
	end
end

function ES:CreateShadows()
	--Actionbars--
	do
		for i=1, Abars do
			if E.private.sle.module.shadows.actionbars["bar"..i] then
				ES:CreateFrameShadow( _G["ElvUI_Bar"..i],  _G["ElvUI_Bar"..i].backdrop)
			end
			if E.private.sle.module.shadows.actionbars["bar"..i.."buttons"] then
				for j = 1, 12 do
					ES:CreateFrameShadow(_G["ElvUI_Bar"..i.."Button"..j], _G["ElvUI_Bar"..i.."Button"..j].backdrop)
				end
			end
		end
		if E.private.sle.module.shadows.actionbars.stancebar then ES:CreateFrameShadow(_G["ElvUI_StanceBar"], _G["ElvUI_StanceBar"].backdrop) end
		if E.private.sle.module.shadows.actionbars.stancebarbuttons then
			for i = 1, 12 do
				if not _G["ElvUI_StanceBarButton"..i] then break end
				ES:CreateFrameShadow(_G["ElvUI_StanceBarButton"..i], _G["ElvUI_StanceBarButton"..i].backdrop)
			end
		end
		if E.private.sle.module.shadows.actionbars.microbar then ES:CreateFrameShadow(_G["ElvUI_MicroBar"], "none") end
		if E.private.sle.module.shadows.actionbars.microbarbuttons then
			for i=1, (#MICRO_BUTTONS) do
				if not _G[MICRO_BUTTONS[i]] then break end
				ES:CreateFrameShadow(_G[MICRO_BUTTONS[i]], _G[MICRO_BUTTONS[i]].backdrop)
			end
		end
		if E.private.sle.module.shadows.actionbars.petbar then ES:CreateFrameShadow(_G["ElvUI_BarPet"], _G["ElvUI_BarPet"].backdrop) end
		if E.private.sle.module.shadows.actionbars.petbarbuttons then
			for i = 1, 12 do
				if not _G["PetActionButton"..i] then break end
				ES:CreateFrameShadow(_G["PetActionButton"..i], _G["PetActionButton"..i].backdrop)
			end
		end
	end

	--Datatexts--
	for panel, enabled in pairs(E.private.sle.module.shadows.datatexts) do
		if enabled then
			if panel == "leftchat" then
				ES.DummyPanels.LeftChat = CreateFrame("Frame", nil, _G[ES.FramesToShadow.Datapanels[panel]])
				ES.DummyPanels.LeftChat:Point("TOPLEFT", _G[ES.FramesToShadow.Datapanels[panel]], "TOPLEFT", -SIDE_BUTTON, 0)
				ES.DummyPanels.LeftChat:Point("BOTTOMRIGHT", _G[ES.FramesToShadow.Datapanels[panel]], "BOTTOMRIGHT", 0, 0)
				ES.DummyPanels.LeftChat:SetFrameStrata("LOW")
				if not E.private.sle.module.shadows.chat.left then
					_G["LeftChatToggleButton"]:SetFrameStrata('LOW')
					_G["LeftChatToggleButton"]:SetFrameLevel(0)
					_G[ES.FramesToShadow.Datapanels[panel]]:SetFrameStrata('LOW')
					_G[ES.FramesToShadow.Datapanels[panel]]:SetFrameLevel(0)
				end

				ES:CreateFrameShadow(ES.DummyPanels.LeftChat, "none")

			elseif panel == "rightchat" then
				ES.DummyPanels.RightChat = CreateFrame("Frame", nil, _G[ES.FramesToShadow.Datapanels[panel]])
				ES.DummyPanels.RightChat:Point("TOPRIGHT", _G[ES.FramesToShadow.Datapanels[panel]], "TOPRIGHT", SIDE_BUTTON, 0)
				ES.DummyPanels.RightChat:Point("BOTTOMLEFT", _G[ES.FramesToShadow.Datapanels[panel]], "BOTTOMLEFT", 0, 0)
				ES.DummyPanels.RightChat:SetFrameStrata("LOW")
				if not E.private.sle.module.shadows.chat.right then
					_G["RightChatToggleButton"]:SetFrameStrata('LOW')
					_G["RightChatToggleButton"]:SetFrameLevel(0)
					_G[ES.FramesToShadow.Datapanels[panel]]:SetFrameStrata('LOW')
					_G[ES.FramesToShadow.Datapanels[panel]]:SetFrameLevel(0)
				end

				ES:CreateFrameShadow(ES.DummyPanels.RightChat, "none")
			elseif (panel ~= leftchat) or (panel ~= rightchat) then
				ES:CreateFrameShadow(_G[ES.FramesToShadow.Datapanels[panel]], "none")
			end
		end
	end

	--Databars Examples: Honor, Reputation, Experience, Azerite
	for panel, enabled in pairs(E.private.sle.module.shadows.databars) do
		if enabled then
			ES:CreateFrameShadow(_G[ES.FramesToShadow.databars[panel]], "none")
		end
	end

	--Misc--
	do
		if E.private.sle.module.shadows.minimap and E.private.general.minimap.enable then
			if E.private.sle.minimap.rectangle then
				ES.DummyPanels.Minimap = CreateFrame("Frame", nil, _G["MMHolder"])
				ES:UpdateMinimap()

				ES:CreateFrameShadow(ES.DummyPanels.Minimap, "none")
			else
				ES:CreateFrameShadow(_G["MMHolder"], "none")
			end
			hooksecurefunc(MM, "UpdateSettings", ES.UpdateMinimap)
		end
		if E.private.sle.module.shadows.chat.left then
			if not E.private.sle.module.shadows.datatexts.leftchat then
				_G["LeftChatToggleButton"]:SetFrameStrata('BACKGROUND')
				_G["LeftChatToggleButton"]:SetFrameLevel(0)
				_G["LeftChatDataPanel"]:SetFrameStrata('BACKGROUND')
				_G["LeftChatDataPanel"]:SetFrameLevel(0)
			end
			ES:CreateFrameShadow(_G.LeftChatPanel, _G.LeftChatPanel.backdrop)
		end
		if E.private.sle.module.shadows.chat.right then
			if not E.private.sle.module.shadows.datatexts.rightchat then
				_G["RightChatToggleButton"]:SetFrameStrata('BACKGROUND')
				_G["RightChatToggleButton"]:SetFrameLevel(0)
				_G["RightChatDataPanel"]:SetFrameStrata('BACKGROUND')
				_G["RightChatDataPanel"]:SetFrameLevel(0)
			end
			ES:CreateFrameShadow(_G.RightChatPanel, _G.RightChatPanel.backdrop)
		end
	end
end

function ES:UpdateMinimap()
	if not E.private.sle.minimap.rectangle then return end

	ES.DummyPanels.Minimap:Point('TOPLEFT', _G.Minimap, 'TOPLEFT', -1, -(E.MinimapSize/6.1)+1)
	if E.db.datatexts.panels.MinimapPanel.enable then
		ES.DummyPanels.Minimap:Point('BOTTOMRIGHT', _G.MinimapPanel, 'BOTTOMRIGHT', 0, 0)
	else
		ES.DummyPanels.Minimap:Point('BOTTOMRIGHT', _G.Minimap, 'BOTTOMRIGHT', 1, (E.MinimapSize/6.1)-1)
	end
end

function ES:Initialize()
	if not SLE.initialized then return end
	Border = E.LSM:Fetch('border', 'ElvUI GlowBorder')

	self:RegisterEvent('PLAYER_ENTERING_WORLD', ES.UpdateShadows)

	ES:CreateShadows()
	ES:UpdateShadows()
	function ES:ForUpdateAll()
		ES:UpdateShadows()
	end
end

--Compatibility thing
_G.EnhancedShadows = ES;

SLE:RegisterModule(ES:GetName())
