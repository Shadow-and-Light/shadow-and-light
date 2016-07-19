local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local CLOSE = CLOSE
local ACCEPT = ACCEPT
local CANCEL = CANCEL
local _G = _G
local ReloadUI = ReloadUI

--Version check
E.PopupDialogs["VERSION_MISMATCH"] = {
	text = SLE:MismatchText(),
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
}

--Chat stuff
E.PopupDialogs["SLE_CHAT_HISTORY_CLEAR"] = {
	text = L["This will clear your chat history and reload your UI.\nContinue?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self) if _G["ElvCharacterDB"].ChatLog then T.twipe(_G["ElvCharacterDB"].ChatLog); ReloadUI() end end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["SLE_EDIT_HISTORY_CLEAR"] = {
	text = L["This will clear your editbox history and reload your UI.\nContinue?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self) if _G["ElvCharacterDB"].ChatEditHistory then T.twipe(_G["ElvCharacterDB"].ChatEditHistory); ReloadUI() end end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}
--Do you sware you are not an idiot
E.PopupDialogs["SLE_ADVANCED_POPUP"] = {
	text = L["SLE_ADVANCED_POPUP_TEXT"],
	button1 = L["I Swear"],
	button2 = DECLINE,
	OnAccept = function() 
		E.global.sle.advanced.confirmed = true
		E.global.sle.advanced.general = true
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

--Gold clear popup
E.PopupDialogs['SLE_CONFIRM_DELETE_CURRENCY_CHARACTER'] = {
	button1 = YES,
	button2 = NO,
	OnCancel = E.noop;
}

--Incompatibility messages
E.PopupDialogs["ENHANCED_SLE_INCOMPATIBLE"] = {
	text = L["Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable."],
	OnAccept = function() T.DisableAddOn("ElvUI_Enhanced"); ReloadUI() end,
	OnCancel = function() T.DisableAddOn("ElvUI_SLE"); ReloadUI() end,
	button1 = 'ElvUI Enhanced',
	button2 = 'Shadow & Light',
	button3 = L["Disable Warning"],
	OnAlt = function ()
		E.global.ignoreEnhancedIncompatible = true;
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["LOOTCONFIRM_SLE_INCOMPATIBLE"] = {
	text = L["You have got Loot Confirm and Shadow & Light both enabled at the same time. Select an addon to disable."],
	OnAccept = function() T.DisableAddOn("LootConfirm"); ReloadUI() end,
	OnCancel = function() T.DisableAddOn("ElvUI_SLE"); ReloadUI() end,
	button1 = 'Loot Confirm',
	button2 = 'Shadow & Light',
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["TRANSAB_SLE_INCOMPATIBLE"] = {
	text = L["You have got ElvUI Transparent Actionbar Backdrops and Shadow & Light both enabled at the same time. Select an addon to disable."],
	OnAccept = function() T.DisableAddOn("ElvUITransparentActionbars"); ReloadUI() end,
	OnCancel = function() T.DisableAddOn("ElvUI_SLE"); ReloadUI() end,
	button1 = 'Transparent Actionbar Backdrops',
	button2 = 'Shadow & Light',
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"] = {
	text = T.gsub(L["INCOMPATIBLE_ADDON"], "ElvUI", "Shadow & Light"),
	OnAccept = function(self) T.DisableAddOn(E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].addon); ReloadUI(); end,
	OnCancel = function(self) E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].optiontable[E.PopupDialogs["SLE_INCOMPATIBLE_ADDON"].value] = false; ReloadUI(); end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}