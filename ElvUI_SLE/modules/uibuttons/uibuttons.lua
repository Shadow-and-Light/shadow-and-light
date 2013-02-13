local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local UB = E:NewModule('UIButtons', 'AceHook-3.0', 'AceEvent-3.0');
local Btemplate = "SecureActionButtonTemplate"
local NumBut = 5

local UIBFrame = CreateFrame('Frame', "UIBFrame", E.UIParent);
local Cbutton = CreateFrame("Button", "ConfigUIButton", UIBFrame, Btemplate)
local Rbutton = CreateFrame("Button", "ReloadUIButton", UIBFrame, Btemplate)
local Mbutton = CreateFrame("Button", "MoveUIButton", UIBFrame, Btemplate)
local Bbutton = CreateFrame("Button", "Bbutton", UIBFrame, Btemplate)
local Abutton = CreateFrame("Button", "Abutton", UIBFrame, Btemplate)
if IsAddOnLoaded("iFilger_ConfigUI") then
	local Fbutton = CreateFrame("Button", "Fbutton", UIBFrame, Btemplate)
	NumBut = 6
end

local ButtonTable = {
Cbutton,
Rbutton,
Mbutton,
Bbutton,
Abutton,
}

function UB:CreateFrame()
	UIBFrame:SetFrameLevel(5);
	UIBFrame:SetFrameStrata('BACKGROUND');
	UIBFrame:Point("LEFT", E.UIParent, "LEFT", -2, 0);
	
	UIBFrame:SetScript("OnUpdate", function(self,event,...)
		UB:Mouseover()
	end)
end

function UB:Create(button, symbol, text, name, desc)
	button:CreateBackdrop()
	local button_text = button:CreateFontString(nil, 'OVERLAY')
	button_text:SetFont(E["media"].normFont, 10)
	button_text:SetText(symbol)
	button_text:SetPoint("CENTER", button, "CENTER")
	button:SetAttribute("type1", "macro")
	if button == Bbutton then
		if IsAddOnLoaded("DXE_Loader") then
			button:SetAttribute("macrotext1", "/dxe config")
		elseif IsAddOnLoaded("Bigwigs") then
			button:SetAttribute("macrotext1", "/bigwigs")
		elseif IsAddOnLoaded("DBM-Core") then
			button:SetAttribute("macrotext1", "/dbm options")
		end
	elseif button == Abutton then
		if IsAddOnLoaded("ACP") then
			button:SetAttribute("macrotext1", "/acp")
		elseif IsAddOnLoaded("Ampere") then
			button:SetAttribute("macrotext1", "/ampere")
		else
			button:SetAttribute("macrotext1", "/stam")
		end
	else
		button:SetAttribute("macrotext1", text)
	end
	
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 30,0)
		GameTooltip:AddLine(name, .6, .6, .6, .6, .6, 1)
		GameTooltip:AddLine(desc, 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	
	button:SetScript("OnLeave", function(self) 
		GameTooltip:Hide() 
	end)
end

function UB:CreateButtons()
	UB:Create(Cbutton, "C", "/ec", L["ElvUI Config"], L["Click to toggle config window"]) --Config
	UB:Create(Rbutton, "R", "/rl", L["Reload UI"], L["Click to reload your interface"]) --Reload
	UB:Create(Mbutton, "M", "/moveui", L["Move UI"], L["Click to unlock moving ElvUI elements"]) --Move UI
	UB:Create(Bbutton, "B", nil, L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."])--Boss Mod
	UB:Create(Abutton, "A", nil, L["AddOns Manager"], L["Click to toggle the AddOn Manager frame (stAddOnManager, Ampere or ACP) you have enabled."])--Addon Manager
	if Fbutton then
		UB:Create(Fbutton, "F", "/ifilger", "iFilger", L["Click to toggle iFilger's config UI"])
	end
end

function UB:FrameSize()
	local db = E.db.sle.uibuttons
	UB:MoverSize()
	
	for i = 1, 5 do
		ButtonTable[i]:Size(db.size)
	end
	if Fbutton then
		Fbutton:Size(db.size)
	end
	
	UB:Positioning()
end	

function UB:Positioning()
	local db = E.db.sle.uibuttons
	for i = 1, 5 do
		ButtonTable[i]:ClearAllPoints()
	end
	if Fbutton then
		Fbutton:ClearAllPoints()
	end
	--position check
	if db.position == "uib_vert" then
		Cbutton:Point("TOP", UIBFrame, "TOP", 0, (E.PixelMode and -1 or -2))
		Rbutton:Point("TOP", Cbutton, "BOTTOM", 0, (E.PixelMode and -3 or -5))
		Mbutton:Point("TOP", Rbutton, "BOTTOM", 0, (E.PixelMode and -3 or -5))
		Bbutton:Point("TOP", Mbutton, "BOTTOM", 0, (E.PixelMode and -3 or -5))
		Abutton:Point("TOP", Bbutton, "BOTTOM", 0, (E.PixelMode and -3 or -5))
		if Fbutton then
			Fbutton:Point("TOP", Abutton, "BOTTOM", 0, (E.PixelMode and -3 or -5))
		end
	else
		Cbutton:Point("LEFT", UIBFrame, "LEFT", (E.PixelMode and 1 or 2), 0)
		Rbutton:Point("LEFT", Cbutton, "RIGHT", (E.PixelMode and 3 or 5), 0)
		Mbutton:Point("LEFT", Rbutton, "RIGHT", (E.PixelMode and 3 or 5), 0)
		Bbutton:Point("LEFT", Mbutton, "RIGHT", (E.PixelMode and 3 or 5), 0)
		Abutton:Point("LEFT", Bbutton, "RIGHT", (E.PixelMode and 3 or 5), 0)
		if Fbutton then
			Fbutton:Point("LEFT", Abutton, "RIGHT", (E.PixelMode and 3 or 5), 0)
		end
	end
end

function UB:MoverSize()
	local db = E.db.sle.uibuttons
	if db.position == "uib_vert" then
		UIBFrame:SetWidth(db.size + (E.PixelMode and 2 or 4))
		UIBFrame:SetHeight((db.size + (E.PixelMode and 3 or 5)) * NumBut -1)
	else
		UIBFrame:SetWidth((db.size + (E.PixelMode and 3 or 5)) * NumBut - 1)
		UIBFrame:SetHeight(db.size + (E.PixelMode and 2 or 4))
	end
end

function UB:Start()
	if E.db.sle.uibuttons.enable then
		UIBFrame:Show()
	else
		UIBFrame:Hide()
	end
end

function UB:Mouseover()
	if E.db.sle.uibuttons.mouse then
		if (MouseIsOver(UIBFrame)) then
			UIBFrame:SetAlpha(1)
		else	
			UIBFrame:SetAlpha(0)
		end
	else
		UIBFrame:SetAlpha(1)
	end
end

function UB:UpdateAll()
	UB:FrameSize()
	UB:Start()
end

function UB:Initialize()
	UB:CreateFrame()
	UB:FrameSize()
	UB:CreateButtons()
	UB:Start()
	
	E.FrameLocks['UIBFrame'] = true
	
	E:CreateMover(UIBFrame, "UIBFrameMover", L["UI Buttons"], nil, nil, nil, "ALL,S&L,S&L MISC")
	UB:MoverSize()
end

E:RegisterModule(UB:GetName())