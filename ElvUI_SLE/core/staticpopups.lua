local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE')

E.PopupDialogs["VERSION_MISMATCH"] = {
	text = SLE:MismatchText(),
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3,
}

E.PopupDialogs['ENHANCED_SLE_INCOMPATIBLE'] = {
	text = L['Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable.'],
	OnAccept = function() DisableAddOn("ElvUI_Enhanced"); ReloadUI() end,
	OnCancel = function() DisableAddOn("ElvUI_SLE"); ReloadUI() end,
	button1 = 'ElvUI Enhanced',
	button2 = 'Shadow & Light',	
	button3 = L['Disable Warning'],
	OnAlt = function ()
		E.global.ignoreEnhancedIncompatible = true;
	end,
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}

E.PopupDialogs['LOOTCONFIRM_SLE_INCOMPATIBLE'] = {
	text = L['You have got Loot Confirm and Shadow & Light both enabled at the same time. Select an addon to disable.'],
	OnAccept = function() DisableAddOn("LootConfirm"); ReloadUI() end,
	OnCancel = function() DisableAddOn("ElvUI_SLE"); ReloadUI() end,
	button1 = 'Loot Confirm',
	button2 = 'Shadow & Light',	
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}

E.PopupDialogs['ORA_SLE_INCOMPATIBLE'] = {
	text = L['You have got oRA3 and Shadow & Light both enabled at the same time. Select an addon to disable.'],
	OnAccept = function() DisableAddOn("oRA3"); ReloadUI() end,
	OnCancel = function() DisableAddOn("ElvUI_SLE"); ReloadUI() end,
	button1 = 'oRA3',
	button2 = 'Shadow & Light',	
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}

E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'] = {
	text = gsub(L["INCOMPATIBLE_ADDON"], "ElvUI", "Shadow & Light"),
	OnAccept = function(self) DisableAddOn(E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].addon); ReloadUI(); end,
	OnCancel = function(self) E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].optiontable[E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].value] = false; ReloadUI(); end,
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}

E.PopupDialogs['SLE_CHAT_HISTORY'] = {
	text = L["This will clear your chat history and reload your UI.\nContinue?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self) if ElvCharacterDB.ChatLog then ElvCharacterDB.ChatLog = {}; ReloadUI() end end,
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}

E.PopupDialogs['SLE_EDIT_HISTORY'] = {
	text = L["This will clear your editbox history and reload your UI.\nContinue?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self) if ElvCharacterDB.ChatEditHistory then ElvCharacterDB.ChatEditHistory = {}; ReloadUI() end end,
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}