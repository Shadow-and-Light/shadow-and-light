local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SMB = E:NewModule('SquareMinimapButtons', 'AceHook-3.0', 'AceEvent-3.0');

local sub, len, find = string.sub, string.len, string.find
local ignoreButtons = {
	"AsphyxiaUIMinimapHelpButton",
	"AsphyxiaUIMinimapVersionButton",
	"ElvConfigToggle",
	"ElvUIConfigToggle",
	"ElvUI_ConsolidatedBuffs",
	"GameTimeframe",
	"HelpOpenTicketButton",
	"MMHolder",
	"QueueStatusMinimapButton",
	"TimeManagerClockButton",
}
local genericIgnores = {
	"Archy",
	"GatherMatePin",
	"GatherNote",
	"GuildInstance",
	"HandyNotesPin",
	"MinimMap",
	"Spy_MapNoteList_mini",
	"ZGVMarker",
}
local partialIgnores = {
	"Node",
	"Note",
	"Pin",
}
local whiteList = {
	"LibDBIcon",
}
local moveButtons = {}
local mmbuttonsAnchor, minimapButtonBar

local function OnEnter()
	if not E.db.sle.minimap.buttons.mouseover then return end
	UIFrameFadeIn(MinimapButtonBar, 0.2, MinimapButtonBar:GetAlpha(), 1)
end

local function OnLeave()
	if not E.db.sle.minimap.buttons.mouseover then return end
	UIFrameFadeOut(MinimapButtonBar, 0.2, MinimapButtonBar:GetAlpha(), 0)
end

function SMB:SkinButton(frame)
	if frame == nil or frame:GetName() == nil or (frame:GetObjectType() ~= "Button") or not frame:IsVisible() then return end
	
	local name = frame:GetName()
	local validIcon = false
	
	for i = 1, #whiteList do
		if sub(name, 1, len(whiteList[i])) == whiteList[i] then validIcon = true break end
	end
	
	if not validIcon then
		for i = 1, #ignoreButtons do
			if name == ignoreButtons[i] then return end
		end
		
		for i = 1, #genericIgnores do
			if sub(name, 1, len(genericIgnores[i])) == genericIgnores[i] then return end
		end
		
		for i = 1, #partialIgnores do
			if find(name, partialIgnores[i]) ~= nil then return end
		end
	end
	
	frame:SetPushedTexture(nil)
	frame:SetHighlightTexture(nil)
	frame:SetDisabledTexture(nil)
	if name == "DBMMinimapButton" then frame:SetNormalTexture("Interface\\Icons\\INV_Helmet_87") end
	if name == "SmartBuff_MiniMapButton" then frame:SetNormalTexture(select(3, GetSpellInfo(12051))) end

	if not frame.isSkinned then
		frame:HookScript('OnEnter', OnEnter)
		frame:HookScript('OnLeave', OnLeave)
		frame:HookScript('OnClick', SMB.UpdateLayout)

		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			frame.original = {}
			frame.original.Width, frame.original.Height = frame:GetSize()
			frame.original.Point, frame.original.relativeTo, frame.original.relativePoint, frame.original.xOfs, frame.original.yOfs = frame:GetPoint()
			frame.original.Parent = frame:GetParent()
			frame.original.FrameStrata = frame:GetFrameStrata()
			if frame:HasScript("OnDragStart") then
				frame.original.DragStart = frame:GetScript("OnDragStart")
			end
			if frame:HasScript("OnDragEnd") then
				frame.original.DragEnd = frame:GetScript("OnDragEnd")
			end
			
			if (region:GetObjectType() == "Texture") then
				local texture = region:GetTexture()
			
				if (texture and (texture:find("Border") or texture:find("Background") or texture:find("AlphaMask"))) then
					region:SetTexture(nil)
				else
					region:ClearAllPoints()
					region:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
					region:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
					region:SetTexCoord( 0.1, 0.9, 0.1, 0.9 )
					region:SetDrawLayer( "ARTWORK" )
					if (name == "PS_MinimapButton") then
						region.SetPoint = function() end
					end
				end
			end
		end
		frame:SetTemplate("Default")

		tinsert(moveButtons, name)
		frame.isSkinned = true
	end
end

function SMB:UpdateLayout()
	if not E.minimapbuttons then return end
	
	minimapButtonBar:SetPoint("CENTER", mmbuttonsAnchor, "CENTER", 0, 0)
	minimapButtonBar:Height(E.db.sle.minimap.buttons.size + 4)
	minimapButtonBar:Width(E.db.sle.minimap.buttons.size + 4)

	local lastFrame, anchor1, anchor2, offsetX, offsetY
	for i = 1, #moveButtons do
		local frame =	_G[moveButtons[i]]
		
		if E.db.sle.minimap.buttons.anchor == 'NOANCHOR' then
			frame:SetParent(frame.original.Parent)
			if frame.original.DragStart then
				frame:SetScript("OnDragStart", frame.original.DragStart)
			end
			if frame.original.DragEnd then
				frame:SetScript("OnDragStop", frame.original.DragEnd)
			end

			frame:ClearAllPoints()
			frame:Size(E.db.sle.minimap.buttons.size)
			frame:SetPoint(frame.original.Point, frame.original.relativeTo, frame.original.relativePoint, frame.original.xOfs, frame.original.yOfs)
			frame:SetFrameStrata(frame.original.FrameStrata)
			frame:SetMovable(true)
		else
			frame:SetParent(minimapButtonBar)
			frame:SetMovable(false)
			frame:SetScript("OnDragStart", nil)
			frame:SetScript("OnDragStop", nil)
			
			frame:ClearAllPoints()
			frame:SetFrameStrata("LOW")
			frame:Size(E.db.sle.minimap.buttons.size)
			if E.db.sle.minimap.buttons.anchor == 'HORIZONTAL' then
				anchor1 = 'RIGHT'
				anchor2 = 'LEFT'
				offsetX = -2
				offsetY = 0
			else
				anchor1 = 'TOP'
				anchor2 = 'BOTTOM'
				offsetX = 0
				offsetY = -2
			end
			
			if not lastFrame then
				frame:SetPoint(anchor1, minimapButtonBar, anchor1, offsetX, offsetY)
			else
				frame:SetPoint(anchor1, lastFrame, anchor2, offsetX, offsetY)
			end
		end
		lastFrame = frame
	end
	
	if E.db.sle.minimap.buttons.anchor ~= 'NOANCHOR' and #moveButtons > 0 then
		if E.db.sle.minimap.buttons.anchor == "HORIZONTAL" then
			minimapButtonBar:Width((E.db.sle.minimap.buttons.size * #moveButtons) + (2 * #moveButtons + 1) + 1)
		else
			minimapButtonBar:Height((E.db.sle.minimap.buttons.size * #moveButtons) + (2 * #moveButtons + 1) + 1)
		end
		mmbuttonsAnchor:SetSize(minimapButtonBar:GetSize())
		minimapButtonBar:Show()
	else
		minimapButtonBar:Hide()
	end	
end

function SMB:ChangeMouseOverSetting()
	if E.db.sle.minimap.buttons.mouseover then
		minimapButtonBar:SetAlpha(0)
	else
		minimapButtonBar:SetAlpha(1)
	end
end

function SMB:SkinMinimapButtons()
	SMB:RegisterEvent("ADDON_LOADED", "DelaySkinning")

	for i = 1, Minimap:GetNumChildren() do
		self:SkinButton(select(i, Minimap:GetChildren()))
	end
	SMB:UpdateLayout()
end

function SMB:DelaySkinning()
	SMB:UnregisterEvent("ADDON_LOADED")

	E:Delay(20, SMB:SkinMinimapButtons())	
end

function SMB:CreateMinimapButtonFrames()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	mmbuttonsAnchor = CreateFrame("Frame", "MMButtonsAnchor", E.UIParent)
	mmbuttonsAnchor:Point("TOPRIGHT", ElvConfigToggle, "BOTTOMRIGHT", -2, -2)
	mmbuttonsAnchor:Size(200, 32)
	mmbuttonsAnchor:SetFrameStrata("BACKGROUND")
	
	E:CreateMover(mmbuttonsAnchor, "MMButtonsMover", L["Minimap Button Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")

	minimapButtonBar = CreateFrame("Frame", "MinimapButtonBar", UIParent)
	minimapButtonBar:SetFrameStrata("BACKGROUND")
	minimapButtonBar:SetTemplate("Transparent")
	minimapButtonBar:CreateShadow()
	minimapButtonBar:SetPoint("CENTER", mmbuttonsAnchor, "CENTER", 0, 0)
	minimapButtonBar:SetScript("OnEnter", OnEnter)
	minimapButtonBar:SetScript("OnLeave", OnLeave)

	self:ChangeMouseOverSetting()
	self:DelaySkinning()
end

function SMB:Initialize()
	if not E.private.sle.minimap.buttons.enable then return end

	E.minimapbuttons = SMB
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CreateMinimapButtonFrames")
end

E:RegisterModule(SMB:GetName())