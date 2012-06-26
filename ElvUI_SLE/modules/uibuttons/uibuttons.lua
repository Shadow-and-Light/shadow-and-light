local E, L, V, P, G =  unpack(ElvUI); --Engine
local UB = E:NewModule('UIButtons', 'AceHook-3.0', 'AceEvent-3.0');

local UIBFrame = CreateFrame('Frame', "UIBFrame", E.UIParent);
local Cbutton = CreateFrame("Button", "ConfigUIButton", UIBFrame, "SecureActionButtonTemplate")
local Rbutton = CreateFrame("Button", "ReloadUIButton", UIBFrame, "SecureActionButtonTemplate")
local Mbutton = CreateFrame("Button", "MoveUIButton", UIBFrame, "SecureActionButtonTemplate")
local Bbutton = CreateFrame("Button", "Bbutton", UIBFrame, "SecureActionButtonTemplate")
local Abutton = CreateFrame("Button", "Abutton", UIBFrame, "SecureActionButtonTemplate")

function UB:CreateFrame()
	UIBFrame:SetFrameLevel(5);
	UIBFrame:SetFrameStrata('BACKGROUND');
	UIBFrame:Point("LEFT", E.UIParent, "LEFT", -2, 0); 
	
	UIBFrame:SetScript("OnUpdate", function(self,event,...)
		UB:Mouseover()
	end)
end

function UB:CreateButtons()
	--Config
	Cbutton:CreateBackdrop()
	Cbutton:SetAttribute("type1", "macro")
	Cbutton:SetAttribute("macrotext1", "/ec")
		
	local Cbutton_text = Cbutton:CreateFontString(nil, 'OVERLAY')
	Cbutton_text:SetFont(E["media"].normFont, 10)
	Cbutton_text:SetText("C")
	Cbutton_text:SetPoint("CENTER", Cbutton, "CENTER")
	
	Cbutton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 30,0)
		GameTooltip:AddLine(L["ElvUI Config"], .6, .6, .6, .6, .6, 1)
		GameTooltip:AddLine(L["Click to toggle config window"], 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	
	Cbutton:SetScript("OnLeave", function(self) 
		GameTooltip:Hide() 
	end)
	
	--Reload
	Rbutton:CreateBackdrop()
	Rbutton:SetAttribute("type1", "macro")
	Rbutton:SetAttribute("macrotext1", "/rl")
		
	local Rbutton_text = Rbutton:CreateFontString(nil, 'OVERLAY')
	Rbutton_text:SetFont(E["media"].normFont, 10)
	Rbutton_text:SetText("R")
	Rbutton_text:SetPoint("CENTER", Rbutton, "CENTER")
	
	Rbutton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 30,0)
		GameTooltip:AddLine(L["Reload UI"], .6, .6, .6, .6, .6, 1)
		GameTooltip:AddLine(L["Click to reload your interface"], 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	
	Rbutton:SetScript("OnLeave", function(self) 
		GameTooltip:Hide() 
	end)
	
	--Move UI
	Mbutton:CreateBackdrop()
	Mbutton:SetAttribute("type1", "macro")
	Mbutton:SetAttribute("macrotext1", "/moveui")
		
	local Mbutton_text = Mbutton:CreateFontString(nil, 'OVERLAY')
	Mbutton_text:SetFont(E["media"].normFont, 10)
	Mbutton_text:SetText("M")
	Mbutton_text:SetPoint("CENTER", Mbutton, "CENTER")
	
	Mbutton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 30,0)
		GameTooltip:AddLine(L["Move UI"], .6, .6, .6, .6, .6, 1)
		GameTooltip:AddLine(L["Click to unlock moving ElvUI elements"], 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	
	Mbutton:SetScript("OnLeave", function(self) 
		GameTooltip:Hide() 
	end)
	
	--Boss Mod
	Bbutton:CreateBackdrop()
	if IsAddOnLoaded("DXE_Loader") then
		Bbutton:SetAttribute("type1", "macro")
		Bbutton:SetAttribute("macrotext1", "/dxe config")
	elseif IsAddOnLoaded("Bigwigs") then
		Bbutton:SetAttribute("type1", "macro")
		Bbutton:SetAttribute("macrotext1", "/bigwigs")
	elseif IsAddOnLoaded("DBM-Core") then
		Bbutton:SetAttribute("type1", "macro")
		Bbutton:SetAttribute("macrotext1", "/dbm options")
	end
		
	local Bbutton_text = Bbutton:CreateFontString(nil, 'OVERLAY')
	Bbutton_text:SetFont(E["media"].normFont, 10)
	Bbutton_text:SetText("B")
	Bbutton_text:SetPoint("CENTER", Bbutton, "CENTER")
	
	Bbutton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 30,0)
		GameTooltip:AddLine(L["Boss Mod"], .6, .6, .6, .6, .6, 1)
		GameTooltip:AddLine(L["Click to toogle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."], 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	
	Bbutton:SetScript("OnLeave", function(self) 
		GameTooltip:Hide() 
	end)
		
	--Addon Manager
	Abutton:CreateBackdrop()
	if IsAddOnLoaded("ACP") then
		Abutton:SetAttribute("type1", "macro")
		Abutton:SetAttribute("macrotext1", "/acp")
	else
		Abutton:SetAttribute("type1", "macro")
		Abutton:SetAttribute("macrotext1", "/stam")
	end
		
	local Abutton_text = Mbutton:CreateFontString(nil, 'OVERLAY')
	Abutton_text:SetFont(E["media"].normFont, 10)
	Abutton_text:SetText("A")
	Abutton_text:SetPoint("CENTER", Abutton, "CENTER")
	
	Abutton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 30,0)
		GameTooltip:AddLine(L["AddOns Manager"], .6, .6, .6, .6, .6, 1)
		GameTooltip:AddLine(L["Click to toogle the AddOn Managerframe (stAddOnManager or ACP) you have enabled."], 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	
	Abutton:SetScript("OnLeave", function(self) 
		GameTooltip:Hide() 
	end)
end

function UB:FrameSize()
	if E.db.dpe.uibuttons.position == "uib_vert" then
		UIBFrame:SetWidth(E.db.dpe.uibuttons.size + 8)
		UIBFrame:SetHeight((E.db.dpe.uibuttons.size + 5) * 5 + 3)
	else
		UIBFrame:SetWidth((E.db.dpe.uibuttons.size + 5) * 5 + 3)
		UIBFrame:SetHeight(E.db.dpe.uibuttons.size + 8)
	end
	
	Cbutton:Size(E.db.dpe.uibuttons.size)
	Rbutton:Size(E.db.dpe.uibuttons.size)
	Mbutton:Size(E.db.dpe.uibuttons.size)
	Bbutton:Size(E.db.dpe.uibuttons.size)
	Abutton:Size(E.db.dpe.uibuttons.size)
	
	UB:Positioning()
end	

function UB:Positioning()
	Cbutton:ClearAllPoints()
	Rbutton:ClearAllPoints()
	Mbutton:ClearAllPoints()
	Bbutton:ClearAllPoints()
	Abutton:ClearAllPoints()
	--position check
	if E.db.dpe.uibuttons.position == "uib_vert" then
		Cbutton:Point("TOP", UIBFrame, "TOP", 0, -4)
		Rbutton:Point("TOP", Cbutton, "BOTTOM", 0, -5)
		Mbutton:Point("TOP", Rbutton, "BOTTOM", 0, -5)
		Bbutton:Point("TOP", Mbutton, "BOTTOM", 0, -5)
		Abutton:Point("TOP", Bbutton, "BOTTOM", 0, -5)
	else
		Cbutton:Point("LEFT", UIBFrame, "LEFT", 4, 0)
		Rbutton:Point("LEFT", Cbutton, "RIGHT", 5, 0)
		Mbutton:Point("LEFT", Rbutton, "RIGHT", 5, 0)
		Bbutton:Point("LEFT", Mbutton, "RIGHT", 5, 0)
		Abutton:Point("LEFT", Bbutton, "RIGHT", 5, 0)
	end
end

function UB:MoverSize()
	if E.db.dpe.uibuttons.position == "uib_vert" then
		UIBFrame.mover:SetWidth(E.db.dpe.uibuttons.size + 8)
		UIBFrame.mover:SetHeight((E.db.dpe.uibuttons.size + 5) * 5 + 3)
	else
		UIBFrame.mover:SetWidth((E.db.dpe.uibuttons.size + 5) * 5 + 3)
		UIBFrame.mover:SetHeight(E.db.dpe.uibuttons.size + 8)
	end
end

function UB:Start()
	if E.db.dpe.uibuttons.enable then
		UIBFrame:Show()
	else
		UIBFrame:Hide()
	end
end

function UB:Mouseover()
	if E.db.dpe.uibuttons.mouse then
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
	UB:MoverSize()
	UB:Start()
end

function UB:Initialize()
	UB:CreateFrame()
	UB:FrameSize()
	UB:CreateButtons()
	UB:Start()
	
	E:CreateMover(UIBFrame, "UIBFrameMover", L["UI Buttons"])
	UB:MoverSize()
end

E:RegisterModule(UB:GetName())