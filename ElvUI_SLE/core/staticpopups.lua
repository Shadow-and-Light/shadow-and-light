local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local CLOSE = CLOSE
local ACCEPT = ACCEPT
local CANCEL = CANCEL
local ReloadUI = ReloadUI

--Version check
E.PopupDialogs['VERSION_MISMATCH'] = {
	text = format(L["MSG_SLE_ELV_OUTDATED"], SLE.elvV, SLE.elvR),
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
}

--Do you sware you are not an idiot
E.PopupDialogs['SLE_ADVANCED_POPUP'] = {
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
	OnCancel = E.noop
}

--Incompatibility messages
E.PopupDialogs['ENHANCED_SLE_INCOMPATIBLE'] = {
	text = L["Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable."],
	OnAccept = function() DisableAddOn('ElvUI_Enhanced'); ReloadUI() end,
	OnCancel = function() DisableAddOn('ElvUI_SLE'); ReloadUI() end,
	button1 = 'ElvUI Enhanced',
	button2 = 'Shadow & Light',
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs['LOOTCONFIRM_SLE_INCOMPATIBLE'] = {
	text = L["You have got Loot Confirm and Shadow & Light both enabled at the same time. Select an addon to disable."],
	OnAccept = function() DisableAddOn('LootConfirm'); ReloadUI() end,
	OnCancel = function() DisableAddOn('ElvUI_SLE'); ReloadUI() end,
	button1 = 'Loot Confirm',
	button2 = 'Shadow & Light',
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs['TRANSAB_SLE_INCOMPATIBLE'] = {
	text = L["You have got ElvUI Transparent Actionbar Backdrops and Shadow & Light both enabled at the same time. Select an addon to disable."],
	OnAccept = function() DisableAddOn('ElvUITransparentActionbars'); ReloadUI() end,
	OnCancel = function() DisableAddOn('ElvUI_SLE'); ReloadUI() end,
	button1 = 'Transparent Actionbar Backdrops',
	button2 = 'Shadow & Light',
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'] = {
	text = gsub(L["INCOMPATIBLE_ADDON"], 'ElvUI', 'Shadow & Light'),
	OnAccept = function() DisableAddOn(E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].addon); ReloadUI() end,
	OnCancel = function() E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].optiontable[E.PopupDialogs['SLE_INCOMPATIBLE_ADDON'].value] = false; ReloadUI() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs['SLE_APPLY_FONT_WARNING'] = {
	text = L["Are you sure you want to apply this font to all ElvUI elements?"],
	OnAccept = function()
		-- local font = E.db.general.font
		-- local fontSize = E.db.general.fontSize
		local font = E.PopupDialogs['SLE_APPLY_FONT_WARNING'].font
		local fontSize = E.PopupDialogs['SLE_APPLY_FONT_WARNING'].fontSize
		local fontOutline = E.PopupDialogs['SLE_APPLY_FONT_WARNING'].fontOutline

		E.db.sle.minimap.coords.font = font
		E.db.sle.minimap.coords.fontSize = fontSize
		E.db.sle.minimap.coords.fontOutline = fontOutline

		E.db.sle.minimap.instance.font = font
		E.db.sle.minimap.instance.fontSize = fontSize
		E.db.sle.minimap.instance.fontOutline = fontOutline

		E.db.sle.minimap.locPanel.font = font
		E.db.sle.minimap.locPanel.fontSize = fontSize
		E.db.sle.minimap.locPanel.fontOutline = fontOutline

		E.db.sle.nameplates.threat.font = font
		E.db.sle.nameplates.threat.size = fontSize
		E.db.sle.nameplates.threat.fontOutline = fontOutline

		E.db.sle.nameplates.targetcount.font = font
		E.db.sle.nameplates.targetcount.size = fontSize
		E.db.sle.nameplates.targetcount.fontOutline = fontOutline

		-- E.db.sle.afk.title.font = font
		-- E.db.sle.afk.title.size = fontSize
		-- E.db.sle.afk.title.outline = fontOutline

		-- E.db.sle.afk.subtitle.font = font
		-- E.db.sle.afk.subtitle.size = fontSize
		-- E.db.sle.afk.subtitle.outline = fontOutline

		-- E.db.sle.afk.date.font = font
		-- E.db.sle.afk.date.size = fontSize
		-- E.db.sle.afk.date.outline = fontOutline

		-- E.db.sle.afk.player.font = font
		-- E.db.sle.afk.player.size = fontSize
		-- E.db.sle.afk.player.outline = fontOutline

		-- E.db.sle.afk.tips.font = font
		-- E.db.sle.afk.tips.size = fontSize
		-- E.db.sle.afk.tips.outline = fontOutline

		E.db.sle.skins.merchant.list.nameFont = font
		E.db.sle.skins.merchant.list.nameSize = fontSize
		E.db.sle.skins.merchant.list.nameOutline = fontOutline

		E.db.sle.skins.merchant.list.subFont = font
		E.db.sle.skins.merchant.list.subSize = fontSize
		E.db.sle.skins.merchant.list.subOutline = fontOutline

		E.db.sle.skins.merchant.list.nameFont = font
		E.db.sle.skins.merchant.list.nameSize = fontSize
		E.db.sle.skins.merchant.list.nameOutline = fontOutline

		E.db.sle.armory.character.ilvl.font = font
		E.db.sle.armory.character.ilvl.fontSize = fontSize
		E.db.sle.armory.character.ilvl.fontStyle = fontOutline

		E.db.sle.armory.character.enchant.font = font
		E.db.sle.armory.character.enchant.fontStyle = fontOutline

		E.db.sle.armory.stats.itemLevel.font = font
		E.db.sle.armory.stats.itemLevel.fontSize = fontSize
		E.db.sle.armory.stats.itemLevel.fontOutline = fontOutline

		E.db.sle.armory.stats.statLabels.font = font
		E.db.sle.armory.stats.statLabels.fontSize = fontSize
		E.db.sle.armory.stats.statLabels.fontOutline = fontOutline

		E.db.sle.armory.stats.statHeaders.font = font
		E.db.sle.armory.stats.statHeaders.fontSize = fontSize
		E.db.sle.armory.stats.statHeaders.fontOutline = fontOutline

		E.db.sle.armory.inspect.ilvl.font = font
		E.db.sle.armory.inspect.ilvl.fontSize = fontSize
		E.db.sle.armory.inspect.ilvl.fontStyle = fontOutline

		E.db.sle.armory.inspect.enchant.font = font
		E.db.sle.armory.inspect.enchant.fontStyle = fontOutline

		-- E.db.sle.armory.inspect.tabsText.Font = font
		-- E.db.sle.armory.inspect.tabsText.FontSize = fontSize
		-- E.db.sle.armory.inspect.tabsText.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.Name.Font = font
		-- E.db.sle.armory.inspect.Name.FontSize = fontSize
		-- E.db.sle.armory.inspect.Name.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.Title.Font = font
		-- E.db.sle.armory.inspect.Title.FontSize = fontSize
		-- E.db.sle.armory.inspect.Title.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.LevelRace.Font = font
		-- E.db.sle.armory.inspect.LevelRace.FontSize = fontSize
		-- E.db.sle.armory.inspect.LevelRace.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.Guild.Font = font
		-- E.db.sle.armory.inspect.Guild.FontSize = fontSize
		-- E.db.sle.armory.inspect.Guild.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.infoTabs.Font = font
		-- E.db.sle.armory.inspect.infoTabs.FontSize = fontSize
		-- E.db.sle.armory.inspect.infoTabs.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.pvpText.Font = font
		-- E.db.sle.armory.inspect.pvpText.FontSize = fontSize
		-- E.db.sle.armory.inspect.pvpText.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.pvpType.Font = font
		-- E.db.sle.armory.inspect.pvpType.FontSize = fontSize
		-- E.db.sle.armory.inspect.pvpType.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.pvpRating.Font = font
		-- E.db.sle.armory.inspect.pvpRating.FontSize = fontSize
		-- E.db.sle.armory.inspect.pvpRating.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.pvpRecord.Font = font
		-- E.db.sle.armory.inspect.pvpRecord.FontSize = fontSize
		-- E.db.sle.armory.inspect.pvpRecord.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.guildName.Font = font
		-- E.db.sle.armory.inspect.guildName.FontSize = fontSize
		-- E.db.sle.armory.inspect.guildName.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.guildMembers.Font = font
		-- E.db.sle.armory.inspect.guildMembers.FontSize = fontSize
		-- E.db.sle.armory.inspect.guildMembers.FontStyle = fontOutline

		-- E.db.sle.armory.inspect.Spec.Font = font
		-- E.db.sle.armory.inspect.Spec.FontSize = fontSize
		-- E.db.sle.armory.inspect.Spec.FontStyle = fontOutline

		E:UpdateAll(true)
	end,
	OnCancel = function() E:StaticPopup_Hide('SLE_APPLY_FONT_WARNING') end,
	button1 = YES,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs['SLE_RESET_ALL'] = {
	text = L["WARNING: This will reset all movers & options for S&L and reload the screen."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() SLE:Reset('all') end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs['SLE_CONVERSION_COMPLETE'] = {
	text = L["SLE_DB_CONVERT_COMPLETE_TEXT"],
	button1 = OKAY,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}
