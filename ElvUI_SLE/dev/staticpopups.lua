local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

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