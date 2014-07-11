local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local Vtext = ""
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

E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'] = {
	text = gsub(L["INCOMPATIBLE_ADDON"], "ElvUI", "Shadow & Light"),
	OnAccept = function(self) DisableAddOn(E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].addon); ReloadUI(); end,
	OnCancel = function(self) E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].optiontable[E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].value] = false; ReloadUI(); end,
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}

E.PopupDialogs['SLE_CHAT_HISTORY'] = {
	text = "This will clear your chat history, you will no longer be able to see messages shown before executing after reload.\nContinue?",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self) if ElvCharacterDB.ChatLog then ElvCharacterDB.ChatLog = {} end end,
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}

E.PopupDialogs['SLE_EDIT_HISTORY'] = {
	text = "This will clear your editbox history and reload UI.\nContinue?",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self) if ElvCharacterDB.ChatEditHistory then ElvCharacterDB.ChatEditHistory = {}; ReloadUI() end end,
	timeout = 0,
	whileDead = 1,	
	hideOnEscape = false,	
}