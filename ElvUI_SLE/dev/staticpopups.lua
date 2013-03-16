local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

E.PopupDialogs["VERSION_MISMATCH"] = {
	text = L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."],
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3,
}