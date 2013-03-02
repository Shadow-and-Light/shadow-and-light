local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

E.PopupDialogs["ELVUI_SLE_AFFINITII"] = {
	text = L["Would you like to load additional addon settings from this profile's author? Note: This will add a new profile in the addons that he has settings for and set your current profile to the newly made profile."],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		E:AffinitiiSetup(true)
	end,
	OnCancel = function(self)
		E:AffinitiiSetup(false)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["ELVUI_SLE_DARTH"] = {
	text = L["Would you like to load additional addon settings from this profile's author? Note: This will add a new profile in the addons that he has settings for and set your current profile to the newly made profile."],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		E:DarthSetup(true)
	end,
	OnCancel = function(self)
		E:DarthSetup(false)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["ELVUI_SLE_REPOOC"] = {
	text = L["Repooc configuration requires PixelPerfect to be enabled. Hit accept to enable Pixel Perfect, hit cancel to not use Repooc's Config."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		E:SetupPixelPerfect(true)
		E:RepoocSetup()
	end,
	timeout = 0,
	whileDead = 1,
}

E.PopupDialogs["VERSION_MISMATCH"] = {
	text = L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."],
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3,
}