local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins')

-- Credit: Azilroka (As most of our skins are based off his work.)
local function LoadSkin()
	PoisonerOptions_SettingsFrame:StripTextures()
	PoisonerOptions_SettingsFrame:SetTemplate("Transparent")

	S:HandleButton(PoisonerOptions_MenuSortingButton)
	S:HandleButton(PoisonerOptions_SettingsSave)
	S:HandleButton(PoisonerOptions_SettingsClose)
	S:HandleButton(PoisonerOptions_ResetFBPosition)

	S:HandleCheckBox(PoisonerOptions_ChkBox_Enable)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MBShow)
	S:HandleCheckBox(PoisonerOptions_ChkBox_FBShow)
	S:HandleCheckBox(PoisonerOptions_ChkBox_FBLock)
	S:HandleCheckBox(PoisonerOptions_ChkBox_PoisonWeaponChatOuput)
	S:HandleCheckBox(PoisonerOptions_ChkBox_ShowOnMouseover)
	S:HandleCheckBox(PoisonerOptions_ChkBox_AutoHide_inCombat)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MenuParentOwn)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MenuParentMinimap)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MPTopLeft)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MPTop)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MPTopRight)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MPLeft)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MPRight)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MPBottomLeft)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MPBottom)
	S:HandleCheckBox(PoisonerOptions_ChkBox_MPBottomRight)
	S:HandleCheckBox(PoisonerOptions_ChkBox_ToolTipFull)
	S:HandleCheckBox(PoisonerOptions_ChkBox_ToolTipName)
	S:HandleCheckBox(PoisonerOptions_ChkBox_OverwritePreset)
	S:HandleCheckBox(PoisonerOptions_ChkBox_ShowTimer)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_IgnoreWhileFishing)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_OnlyInstanced)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_MainHand)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_OffHand)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_ThrowWeapon)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_Audio)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_Chat)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_Aura)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_ErrorFrame)
	S:HandleCheckBox(PoisonerOptions_ChkBox_TimerOutput_Aura_Lock)
	S:HandleCheckBox(PoisonerOptions_ChkBox_AutoBuy)
	S:HandleCheckBox(PoisonerOptions_ChkBox_AutoBuy_Prompt)
	S:HandleCheckBox(PoisonerOptions_ChkBox_AutoBuy_Check)
	S:HandleCheckBox(PoisonerOptions_ChkBox_QuickButton_Lock)

	PoisonerOptions_SettingsFrameTab1:Point("TOPLEFT", PoisonerOptions_SettingsFrame, "BOTTOMLEFT", 0, 2)

	for i = 1, 5 do
		S:HandleTab(_G["PoisonerOptions_SettingsFrameTab"..i])
	end
end

function Poisoner_CheckQuickButton()
	if InCombatLockdown() then PoisonerStateHeader.needUpdate = true; return end
	if (POISONER_CONFIG.Enabled == 1) then
		if ((Poisoner_Poison16.Name ~= nil and Poisoner_Poison16.Name ~= "") and (Poisoner_Poison17.Name ~= nil and Poisoner_Poison17.Name ~= "") --[[and (Poisoner_Poison18.Name ~= nil and Poisoner_Poison18.Name ~= "")]]) then
			if (Poisoner_QuickButtonVisible == 0) then
				Poisoner_CreateQuickButton()
			elseif (Poisoner_QuickButtonVisible == 1) then
				Poisoner_UpdateQuickButton()
			end
		elseif ((Poisoner_Poison16.Name == nil or Poisoner_Poison16.Name == "") and (Poisoner_Poison17.Name == nil or Poisoner_Poison17.Name == "") --[[and (Poisoner_Poison18.Name == nil or Poisoner_Poison18.Name == "")]]) then
			Poisoner_QuickButton_Overlay:StripTextures();
			Poisoner_QuickButton:Hide();
		end
	elseif (POISONER_CONFIG.Enabled == 0) then
		Poisoner_QuickButton_Overlay:StripTextures();
		Poisoner_QuickButton:Hide();
	end
end

function Poisoner_UpdateQuickButton()
	local btn = Poisoner_QuickButton
	local icon = Poisoner_QuickButtonIcon
		if MSQ and Poisoner_Masque_Initiated == true then
			MSQ:Group("Poisoner", "QuickButton"):AddButton(btn)
			MSQ:Group("Poisoner", "QuickButton"):ReSkin()
		end
	btn:SetAttribute("type", "macro");
	btn:SetAttribute("macrotext", "/use [nomodifier,button:3] "..Poisoner_Poison18.Name.."\n/use [modifier:shift,button:3] "..Poisoner_Poison18_SHIFT.Name.."\n/use [modifier:ctrl,button:3] "..Poisoner_Poison18_CTRL.Name.."\n/use [modifier:alt,button:3] "..Poisoner_Poison18_ALT.Name.."\n/use [button:3] 18\n/use [nomodifier,button:2] "..Poisoner_Poison17.Name.."\n/use [modifier:shift,button:2] "..Poisoner_Poison17_SHIFT.Name.."\n/use [modifier:ctrl,button:2] "..Poisoner_Poison17_CTRL.Name.."\n/use [modifier:alt,button:2] "..Poisoner_Poison17_ALT.Name.."\n/use [button:2] 17\n/use [nomodifier,button:1] "..Poisoner_Poison16.Name.."\n/use [modifier:shift,button:1] "..Poisoner_Poison16_SHIFT.Name.."\n/use [modifier:ctrl,button:1] "..Poisoner_Poison16_CTRL.Name.."\n/use [modifier:alt,button:1] "..Poisoner_Poison16_ALT.Name.."\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()");
	Poisoner_GetToolTipTexture()
	-- Tooltip layout
	local COLOR_GREEN = "|cff00ff00";
	local COLOR_GREY = "|cff808080";
	local COLOR_END = "|r";
	Poisoner_QuickButton_Text_MH = "|T"..Poisoner_Poison16.Texture..":0|t |T"..Poisoner_Poison16_SHIFT.Texture..":0|t |T"..Poisoner_Poison16_CTRL.Texture..":0|t |T"..Poisoner_Poison16_ALT.Texture..":0|t "
	Poisoner_QuickButton_Text_OH = "|T"..Poisoner_Poison17.Texture..":0|t |T"..Poisoner_Poison17_SHIFT.Texture..":0|t |T"..Poisoner_Poison17_CTRL.Texture..":0|t |T"..Poisoner_Poison17_ALT.Texture..":0|t "
	Poisoner_QuickButton_Text_TW = "|T"..Poisoner_Poison18.Texture..":0|t |T"..Poisoner_Poison18_SHIFT.Texture..":0|t |T"..Poisoner_Poison18_CTRL.Texture..":0|t |T"..Poisoner_Poison18_ALT.Texture..":0|t "
	Poisoner_QuickButton_Text_Slots = ""..INVTYPE_WEAPONMAINHAND..": \n"..INVTYPE_WEAPONOFFHAND..": \n"..INVTYPE_THROWN..": "
	Poisoner_QuickButton_Text_Textures = ""..Poisoner_QuickButton_Text_MH.."\n"..Poisoner_QuickButton_Text_OH.."\n"..Poisoner_QuickButton_Text_TW..""
	Poisoner_QuickButton_Overlay:SetTemplate("Transparent")	
	Poisoner_QuickButton:Show();
end

S:RegisterSkin("Poisoner", LoadSkin)