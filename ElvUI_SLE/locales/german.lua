-- German localization file for deDE.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "deDE");

if not L then return; end
--Popups
L["MSG_SLE_ELV_OUTDATED"] = "Deine Version von ElvUI ist älter wie die empfohlene, die mit |cff9482c9Shadow & Light|r benutzt werden sollte. Deine Version ist |cff1784d1%.2f|r (empfohlen ist |cff1784d1%.2f|r). Bitte update dein ElvUI."
L["This will clear your chat history and reload your UI.\nContinue?"] = "Dieses wird deinen Chatverlauf leeren und dein UI neuladen.\nFortfahren?"
L["This will clear your editbox history and reload your UI.\nContinue?"] = "Dieses wird dein Eingabeverlauf leeren und dein UI neuladen.\nFortfahren?"
L["Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Oh gott, du hast ElvUI Enhanced und Shadow & Light gleichzeitig aktiviert. Wähle ein Addon zum Deaktivieren aus."
L["You have got Loot Confirm and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast Loot Confirm und Shadow & Light gleichzeitig aktiviert. Wähle ein Addon zum Deaktivieren aus."
L["You have got OneClickEnchantScroll and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast OneClickEnchantScroll und Shadow & Light gleichzeitig aktiviert. Wähle ein Addon zum Deaktivieren aus."
L["You have got ElvUI Transparent Actionbar Backdrops and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast ElvUI Transparent Actionbar Backdrops und Shadow & Light gleichzeitig aktiviert. Wähle ein Addon zum Deaktivieren aus."
L["SLE_ADVANCED_POPUP_TEXT"] = [[Schwörst du, dass du ein erfahrener Benutzer bist,
du kannst Tooltips für Optionen lesen und wirst nicht um Hilfe schreien wenn
irgendetwas furchtbar schief mit deinem UI passiert mit diesen zusätzlichen Optionen?

Falls ja, ist es erlaubt fortzufahren.
]]

--Install
L["Moving Frames"] = "Bewegbare Fenster"
L["Author Presets"] = "Author Voreinstellungen"
L["|cff9482c9Shadow & Light|r Installation"] = true
L["Welcome to |cff9482c9Shadow & Light|r version %s!"] = "Willkommen zu |cff9482c9Shadow & Light|r Version %s!"
L["SLE_INSTALL_WELCOME"] = [[Dieses führt dich durch ein schnell Installationsprozess um einige Shadow & Light Funktionalitäten einzustellen.
Wenn du keine Optionen in der Installation auswählen möchtest, klicke auf den Schritt Überspringen Knopf um die Installation zu beenden.

Beachte jedoch, dass die Schritte rechts mit * gekennzeichnet die vorherigen Schritte benötigen.]]
L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."] = "Dieses wird den S&L Armory Mode aktivieren, welcher mehr detaillierte Informationen auf einen Blick anzeigt, wenn du einen Charakter inspizierst oder auf deinem eigenen Charakter Fenster."
L["SLE_ARMORY_INSTALL"] = "Aktiviere S&L Armory\n(Detaillierte Charakter & Betrachten Fenster)."
L["AFK Mode in |cff9482c9Shadow & Light|r is additional settings/elements for standard |cff1784d1ElvUI|r AFK screen."] = "Der AFK Mode in |cff9482c9Shadow & Light|r erlaubt zusätzliche Einstellungen/Elemente für den Standard |cff1784d1ElvUI|r AFK Mode."
L["This option is bound to character and requires a UI reload to take effect."] = "Diese Option ist an den Charakter gebunden und benötigt ein neuladen des UI um aktiv zu werden."
L["Shadow & Light Imports"] = "Shadow & Light Importierungen"
L["You can now choose if you want to use one of the authors' set of options. This will change the positioning of some elements as well of other various options."] = "Du kannst jetzt auswählen ob du einige Einstellunge von den Authoren verwenden möchtest. Dieses wird die Positionierung von einigen Elementen verändern und auch einige Optionen."
L["SLE_Install_Text_AUTHOR"] = [=[Dieser Schritt ist optional und sollte nur ausgewählt werden wenn du die Einstellungen von uns verwenden möchtest. In einigen Fällen sind die Einstellungen unterschiedlich basierend auf den Layout Einstellungen die du in ElvUI gewählt hast.
Wenn du nichts auswählst, wird vorausgesetzt dass du den nächsten Installationsschritt überspringst. 

|cff1784d1"%s"|r wurde ausgewählt.

|cffFF0000Achtung:|r Bitte beachte dass die Authoren vielleicht oder vielleicht auch nicht die Layouts/Themes die du ausgewählt hast nicht verwenden. Beachte auch, wenn du zwischen den Layouts hin und her wechselst könnte es auch zu ungewollten Resultaten führen.]=]
L["Darth's Config"] = "Darth's Einstellungen"
L["Repooc's Config"] = "Repooc's Einstellungen"
L["Affinitii's Config"] = "Affinitii's Einstellungen"
L["Darth's Default Set"] = "Darth's Standardeinstellungen"
L["Repooc's Default Set"] = "Repooc's Standardeinstellungen"
L["Affinitii's Default Set"] = "Affinitii's Standardeinstellungen"
L["Layout & Settings Import"] = "Layout & Einstellungsimportierung"
L["You have selected to use %s and role %s."] = "Du hast ausgewählt %s und Rolle %s."
L["SLE_INSTALL_LAYOUT_TEXT2"] = [[Folgende Knöpfe werden Layout/Addon Einstellungen für die gewählte Konfiguration und Rolle verwenden.
Bitte beachte dass diese Konfiguration vielleicht einige Einstellungen beinhaltet, mit denen du noch nicht vertraut bist.

Auch könnte es auch einige Optionen zurücksetzen/ändern die du den vorherigen Schritten ausgewählt hast.]]
L["|cff1784d1%s|r role was chosen"] = "|cff1784d1%s|r Rolle wurde ausgewählt"
L["Import Profile"] = "Import Profil"
L["AFK Mode"] = true
L["SLE_INSTALL_SETTINGS_LAYOUT_TEXT"] = [[Diese Aktion könnte bewirken dass du einige Einstellungen verlierst.
Fortfahren?]]
L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"] = [[Dieses wird ein Profil für diese Addons erstellen (wenn aktiviert) und zum erstellten Profil wechseln:
%s

Fortfahren?]]

--Config replacements
L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."] = "Diese Optionen wurde durch Shadow & Light deaktiviert. Um siw wieder zu aktivieren musst du die S&L Optionen deaktivieren. Klicke hier um zu den Einstellungen zu gelangen."

--Core
L["SLE_LOGIN_MSG"] = "|cff9482c9Shadow & Light|r Version |cff1784d1%s%s|r für ElvUI ist geladen. Danke dass es benutzt."
L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."] = "Plugin für |cff1784d1ElvUI|r von\nDarth Predator und Repooc."
L["Reset All"] = "Alles zurücksetzen"
L["Resets all movers & options for S&L."] = "Setzt alle Movers & Optionen für S&L zurück."
L["Reset these options to defaults"] = "Setze die Optionen auf Standard zurück"
L["Modules designed for older expantions"] = "Module für die älteren Erweiterungen"
L["Game Menu Buttons"] = "Spielmenü Knopf"
L["Adds |cff9482c9Shadow & Light|r buttons to main game menu."] = "Füge einen |cff9482c9Shadow & Light|r Knopf zum Spielmeü hinzu."
L["Advanced Options"] = "Erweiterte Optionen"
L["SLE_Advanced_Desc"] = [[Folgende Optionen erlauben den Zugriff auf zusätzliche Einstellungen in den verschiedensten Modulen.
Neuen Spielern oder Spielern die nicht vertraut mit Addon Einstellungen sind, wird nicht geraten diese zu nutzen.]]
L["Allow Advanced Options"] = "Erlaube erweiterte Optionen"
L["Change Elv's options limits"] = "Ändere Elv's Optionsbegrenzung"
L["Allow |cff9482c9Shadow & Light|r to change some of ElvUI's options limits."] = "Erlaubt |cff9482c9Shadow & Light|r dass verändern von einigen ElvUI's Optionsbegrenzungen."
L["Cyrillics Support"] = "Kyrillischer Support"
L["SLE_CYR_DESC"] = [[Wenn du ständig (oder selten) das russische Alphabet (Kyrillisches Alphabet) für deine Nachrichten verwendest
und immer wieder vergisst deine Tastatur umzuschalten wenn du die Slash Befehle benutzt, wird dir diese Option dabei helfen.
Dieses aktiviert die Benutzung der ElvUI Befehle auch mit nicht umgeschalteter Tastatur.
]]
L["Commands"] = "Befehle"
L["SLE_CYR_COM_DESC"] = [[Erlaubt die Benutzung der Befehle mit russischer Eingabe:
- /rl
- /in
- /ec
- /elvui
- /bgstats
- /hellokitty
- /hellokittyfix
- /harlemshake
- /egrid
- /moveui
- /resetui
- /kb]]
L["Dev Commands"] = "Dev Befehle"
L["SLE_CYR_DEVCOM_DESC"] = [[Erlaubt die Benutzung von diesen Befehlen mit russischer Eingabe:
- /luaerror
- /frame
- /framelist
- /texlist
- /cpuimpact
- /cpuusage
- /enableblizzard

Diese Befehle werden mehr für das Testen oder die Entwicklung benutzt und werden daher eher selten von gewöhnlichen Nutzern verwendet.]]
L["Modules"] = "Module"
L["Options for different S&L modules."] = "Einstellungen für verschiedene S&L Module."

--Config groups
L["S&L: All"] = "S&L: Alles"
L["S&L: Datatexts"] = "S&L: Infotexte"
L["S&L: Backgrounds"] = "S&L: Hintergründe"
L["S&L: Misc"] = "S&L: Verschiedenes"

--Actionbars
L["OOR as Bind Text"] = "OOR als Text"
L["Out Of Range indication will use keybind text instead of the whole icon."] = "Außer Reichweiten Indikator wird nun den Tastaturbelegungstext anstatt das Symbol benutzen."
L["Checked Texture"] = "Gedrückte Textur"
L["Highlight the button of the spell with areal effect until the area is selected."] = "Hebt die Taste von Flächenzaubern hervor bis das Zielgebiet ausgewählt wurde."
L["Checked Texture Color"] = "Gedrückte Textur Farbe"
L["Transparent Backdrop"] = "Transparenter Hintergrund"
L["Sets actiobars' backgrounds to transparent template."] = "Setzt den Aktionsleisten Hintergrund transparent."
L["Transparent Buttons"] = "Transparente Tasten"
L["Sets actiobars buttons' backgrounds to transparent template."] = "Setzt die Aktionsleisten Tasten transparent."

--Armory
L["Average"] = "Durschnitt"
L["Not Enchanted"] = "Nicht verzaubert"
L["Empty Socket"] = "Leerer Sockel"
L["KF"] = true
L["You can't inspect while dead."] = "Du kannst nicht inspizieren während du tod bist."
L["Specialization data seems to be crashed. Please inspect again."] = "Spezialisierungsdaten sind wohl gecrashed. Bitte erneut inspizieren."
L["No Specialization"] = "Keine Spezialisierung"
L["Character model may differ because it was constructed by the inspect data."] = true
L["Armory Mode"] = true
L["Enchant String"] = "Verzauberungsstring"
L["String Replacement"] = "String Ersetzung"
L["List of Strings"] = "Liste von Strings"
L["Original String"] = "Originaler String"
L["New String"] = "Neuer String"
L["Character Armory"] = "Charakter Armory"
L["Show Missing Enchants or Gems"] = "Zeigt fehlende Verzauberungen oder Sockel"
L["Show Warning Icon"] = "Zeigt Warnungssymbol"
L["Select Image"] = "Bild auswählen"
L["Custom Image Path"] = "Benutzerdefinierter Bildpfad"
L["Gradient"] = "Verlauf"
L["Gradient Texture Color"] = "Verlaufs Textur Farbe"
L["Upgrade Level"] = "Upgrade Stufe"
L["Warning Size"] = "Warnungsgröße"
L["Warning Only As Icons"] = "Warnung nur als Symbol"
L["Only Damaged"] = "Nur beschädigte"
L["Gem Sockets"] = "Edelstein Sockel"
L["Socket Size"] = "Sockel Größe"
L["Inspect Armory"] = true
L["Full Item Level"] = "Volles Itemlevel"
L["Show both equipped and average item levels."] = "Zeigt angelegtes und durchschnittliches Itemlevel"
L["Item Level Coloring"] = "Itemlevel färbung"
L["Color code item levels values. Equipped will be gradient, avarage - selected color."] = true
L["Color of Average"] = "Farbe vom Durchschnitt"
L["Sets the color of avarage item level."] = "Setzt die Farbe vom Durchschnitts-Itemlevel"
L["Only Relevant Stats"] = "Nur relevante Werte"
L["Show only those primary stats relevant to your spec."] = "Zeigt nur primäre Werte die relevant für deinen Spec sind."
L["SLE_ARMORY_POINTS_AVAILABLE"] = "%s Punkt(e) Verfügbar!!"
L["Show ElvUI skin's backdrop overlay"] = "Zeigt ElvUI-Skin Hintergrund Overlay"

--AFK
L["You Are Away From Keyboard for"] = "Du bist nicht an der Tastatur für"
L["Take care of yourself, Master!"] = "Pass auf dich auf, Meister!"
L["SLE_TIPS"] = { --This doesn't need to be translated, every locale can has own tips
	"Don't stand in the fire!",
	"Elv: I just utilized my degree in afro engineering and fixed it",
	"Burn the heretic. Kill the mutant. Purge the unclean.",
	"Blood for the Blood God!",
	"Coffee for the Coffee God!",
	"Darth's most favorite change comment - \"Woops\"",
	"Affinity: Always blame the russian...",
	"Power Level of this guy is not OVER9000!!!!",
	"Need... More... Catgirls... Wait, what?!",
	"First Aid potions are better then Healthstones. WTF Blizzard?!",
}
L["Enable S&L's additional features for AFK screen."] = true
L["Button restrictions"] = true
L["Use ElvUI's restrictions for button presses."] = true
L["Crest"] = true
L["Faction Crest X-Offset"] = true
L["Faction Crest Y-Offset"] = true
L["Race Crest X-Offset"] = true
L["Race Crest Y-Offset"] = true
L["Texts Positions"] = true
L["Date X-Offset"] = true
L["Date Y-Offset"] = true
L["Player Info X-Offset"] = true
L["Player Info Y-Offset"] = true
L["X-Pack Logo Size"] = true
L["Template"] = true
L["Player Model"] = true
L["Model Animation"] = true
L["Test"] = true
L["Shows a test model with selected animation for 10 seconds. Clicking again will reset timer."] = true
L["Misc"] = true
L["Bouncing"] = true
L["Use bounce on fade in animations."] = true
L["Animation time"] = true
L["Time the fade in animation will take. To disable animation set to 0."] = true
L["Slide"] = true
L["Slide Sideways"] = true
L["Fade"] = true
L["Tip time"] = true
L["Number of seconds tip will be shown before changed to another."] = true
L["Title font"] = true
L["Subitle font"] = true
L["Date font"] = true
L["Player info font"] = true
L["Tips font"] = true
L["Graphics"] = true

--Auras
L["Hide Buff Timer"] = true
L["This hides the time remaining for your buffs."] = true
L["Hide Debuff Timer"] = true
L["This hides the time remaining for your debuffs."] = true

--Backgrounds
L["Backgrounds"] = true
L["SLE_BG_1"] = "Background 1"
L["SLE_BG_2"] = "Background 2"
L["SLE_BG_3"] = "Background 3"
L["SLE_BG_4"] = "Background 4"
L["Additional Background Panels"] = true
L["BG_DESC"] = "Module for creating additional frames that can be used as backgrounds for anything."
L["Show/Hide this frame."] = true
L["Sets width of the frame"] = true
L["Sets height of the frame"] = true
L["Set the texture to use in this frame. Requirements are the same as the chat textures."] = true
L["Backdrop Template"] = true
L["Change the template used for this backdrop."] = true
L["Hide in Pet Batlle"] = true
L["Show/Hide this frame during Pet Battles."] = true

--Bags
L["New Item Flash"] = true
L["Use the Shadow & Light New Item Flash instead of the default ElvUI flash"] = true
L["Transparent Slots"] = true
L["Apply transparent template on bag and bank slots."] = true

--Blizzard
L["Move Blizzard frames"] = true
L["Allow some Blizzard frames to be moved around."] = true
L["Pet Battles skinning"] = true
L["Make some elements of pet battles movable via toggle anchors."] = true
L["Vehicle Seat Scale"] = true

--Chat
L["Reported by %s"] = true
L["Reset Chat History"]= true
L["Clears your chat history and will reload your UI."] = true
L["Reset Editbox History"] = true
L["Clears the editbox history and will reload your UI."] = true
L["Guild Master Icon"] = true
L["Displays an icon near your Guild Master in chat.\n\n|cffFF0000Note:|r Some messages in chat history may disappear on login."] = true
L["Chat Editbox History"] = true
L["The amount of messages to save in the editbox history.\n\n|cffFF0000Note:|r To disable, set to 0."] = true
L["Filter DPS meters' Spam"] = true
L["Replaces long reports from damage meters with a clickeble hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter te report of other things"] = true
L["Texture Alpha"] = true
L["Allows separate alpha setting for textures in chat"] = true
L["Chat Frame Justify"] = true
L["Identify"] = true
L["Showes the message in each chat frame containing frame's number."] = true
L["This is %sFrame %s|r"] = true
L["Loot Icons"] = true
L["Showes icons of items looted/created near respective messages in chat. Does not affect usual messages."] = true
L["Frame 1"] = true
L["Frame 2"] = true
L["Frame 3"] = true
L["Frame 4"] = true
L["Frame 5"] = true
L["Frame 6"] = true
L["Frame 7"] = true
L["Frame 8"] = true
L["Frame 9"] = true
L["Frame 10"] = true
L["Chat Max Messages"] = true
L["The amount of messages to save in chat window.\n\n|cffFF0000Warning:|r Can increase the amount of memory needed. Also changing this setting will clear the chat in all windows, leaving just lines saved in chat history."] = true
L["Tabs"] = true
L["Selected Indicator"] = true
L["Shows you which of docked chat tabs is currently selected."] = true
L["Chat history size"] = true
L["Sets how many messages will be stored in history."] = true
L["Following options determine which channels to save in chat history.\nNote: disabling a channel will immideately delete saved info for that channel."] = true
L["Alt-Click Invite"] = true
L["Allows you to invite people by alt-clicking their names in chat."] = true
L["Invite links"] = true
L["Convets specified keywords to links that automatically invite message's author to group."] = true
L["Link Color"] = true
L["Invite Keywords"] = true
L["Chat Setup Delay"] = true
L["Manages the delay before S&L will execute hooks to ElvUI's chat positioning. Prevents some weird positioning issues."] = true

--Databars
L["Full value on Exp Bar"] = true
L["Changes the way text is shown on exp bar."] = true
L["Full value on Rep Bar"] = true
L["Changes the way text is shown on rep bar."] = true
L["Auto Track Reputation"] = true
L["Automatically sets reputation tracking to the most recent reputation change."] = true
L["Change the style of reputation messages."] = true
L["Reputation increase Style"] = true
L["Reputation decrease Style"] = true
L["Output"] = true
L["Determines in which frame reputation messages will be shown. Auto is for whatever frame has reputation messages enabled via Blizzard options."] = true
L["Change the style of experience gain messages."] = true
L["Experience Style"] = true
L["Full List"] = true
L["Show all factions affected by the latest reputation change. When disabled only first (in alphabetical order) affected faction will be shown."] = true
L["Full value on Artifact Bar"] = true
L["Changes the way text is shown on artifact bar."] = true
L["Full value on Honor Bar"] = true
L["Changes the way text is shown on honor bar."] = true
L["Chat Filters"] = true
L["Replace massages about honorable kills in chat."] = true
L["Award"] = true
L["Replace massages about honor points being awarded."] = true
L["Defines the style of changed string. Colored parts will be shown with your selected value color in chat."] = true
L["Award Style"] = true
L["HK Style"] = true

--Datatexts
L["D"] = true
L["Previous Level:"] = true
L["Account Time Played"] = true
L["SLE_DataPanel_1"] = "S&L Data Panel 1"
L["SLE_DataPanel_2"] = "S&L Data Panel 2"
L["SLE_DataPanel_3"] = "S&L Data Panel 3"
L["SLE_DataPanel_4"] = "S&L Data Panel 4"
L["SLE_DataPanel_5"] = "S&L Data Panel 5"
L["SLE_DataPanel_6"] = "S&L Data Panel 6"
L["SLE_DataPanel_7"] = "S&L Data Panel 7"
L["SLE_DataPanel_8"] = "S&L Data Panel 8"
L["This LFR isn't available for your level/gear."] = true
L["You didn't select any instance to track."] = true
L["Bosses killed: "] = true
L["Current:"] = true
L["Weekly:"] = true
L["|cffeda55fLeft Click|r to open the friends panel."] = true
L["|cffeda55fRight Click|r to open configuration panel."] = true
L["|cffeda55fLeft Click|r a line to whisper a player."] = true
L["|cffeda55fShift+Left Click|r a line to lookup a player."] = true
L["|cffeda55fCtrl+Left Click|r a line to edit a note."] = true
L["|cffeda55fMiddleClick|r a line to expand RealID."] = true
L["|cffeda55fAlt+Left Click|r a line to invite."] = true
L["|cffeda55fLeft Click|r a Header to hide it or sort it."] = true
L["|cffeda55fLeft Click|r to open the guild panel."] = true
L["|cffeda55fCtrl+Left Click|r a line to edit note."] = true
L["|cffeda55fCtrl+Right Click|r a line to edit officer note."] = true
L["New Mail"] = true
L["No Mail"] = true
L["Range"] = true
L["SLE_AUTHOR_INFO"] = "Shadow & Light by Darth Predator & Repooc"
L["SLE_CONTACTS"] = [=[If you have suggestions or a bug report,
please submit ticket at http://git.tukui.org/repooc/elvui-shadowandlight]=]
L["Additional Datatext Panels"] = true
L["DP_DESC"] = [=[Additional Datatext Panels.
8 panels with 20 datatext points total.]=]
L["Sets size of this panel"] = true
L["Don't show this panel, only datatexts assinged to it"] = true
L["Override Chat DT Panels"] = true
L["This will have S&L handle chat datatext panels and place them below the left & right chat panels.\n\n|cffFF0000Note:|r When you first enabled, you may need to move the chat panels up to see your datatext panels."] = true
L["S&L Datatexts"] = true
L["Datatext Options"] = true
L["LFR Lockout"] = true
L["Show/Hide LFR lockout info in time datatext's tooltip."] = true
L["ElvUI Improved Currency Options"] = true
L["Show Archaeology Fragments"] = true
L["Show Jewelcrafting Tokens"] = true
L["Show Player vs Player Currency"] = true
L["Show Dungeon and Raid Currency"] = true
L["Show Cooking Awards"] = true
L["Show Miscellaneous Currency"] = true
L["Show Zero Currency"] = true
L["Show Icons"] = true
L["Show Faction Totals"] = true
L["Show Unsed Currency"] = true
L["These options are for modifing the Shadow & Light Friends datatext."] = true
L["Hide In Combat"] = true
L["Will not show the tooltip while in combat."] = true
L["Hide Friends"] = true
L["Hide Title"] = true
L["Minimize the Friend Datatext."] = true
L["Show Totals"] = true
L["Show total friends in the datatext."] = true
L["Hide Hints"] = true
L["Hide the hints in the tooltip."] = true
L["Expand RealID"] = true
L["Display realid with two lines to view broadcasts."] = true
L["Autohide Delay:"] = true
L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."] = true
L["S&L Guild"] = true
L["These options are for modifing the Shadow & Light Guild datatext."] = true
L["Show total guild members in the datatext."] = true
L["Hide MOTD"] = true
L["Hide the guild's Message of the Day in the tooltip."] = true
L["Hide Guild"] = true
L["Minimize the Guild Datatext."] = true
L["Hide Guild Name"] = true
L["Hide the guild's name in the tooltip."] = true
L["S&L Mail"] = true
L["These options are for modifing the Shadow & Light Mail datatext."] = true
L["Minimap icon"] = true
L["If enabled will show new mail icon on minimap."] = true
L["Options below are for standard ElvUI's durability datatext."] = true
L["If enabled will color durability text based on it's value."] = true
L["Durability Threshold"] = true
L["Datatext will flash if durability shown will be equal or lower that this value. Set to -1 to disable"] = true
L["Short text"] = true
L["Changes the text string to a shorter variant."] = true
L["Delete character info"] = true
L["Remove selected character from the stored gold values"] = true
L["Are you sure you want to remove |cff1784d1%s|r from currency datatexts?"] = true
L["Hide panel background"] = true
L["Don't show this panel, only datatexts assinged to it"] = true
L["SLE_DT_CURRENCY_WARNING_GOLD"] = [[Your datapanel %s has ElvUI's "Gold" datatext active while "S&L Currency" datatext is selected elsewhere. To ensure the correct functioning of "S&L Currency" datatext we are disabling some functions of "Gold" datatext. To avoid this conflict you need to replace one of conflicting datatexts.]]
L["Gold Sorting"] = true
L["Normal"] = true
L["Reverced"] = true
L["Amount"] = true
L["Order of each toon. Smaller numbers will go first"] = true

--Enhnced Shadows
L["Enhanced Shadows"] = true
L["Use shadows on..."] = true

--Equip Manager
L["Equipment Manager"] = true
L["EM_DESC"] = "This module provides different options to automatically change your equipment sets on spec change or entering certain locations. All options are character based."
L["Equipment Set Overlay"] = true
L["Timewalking"] = true
L["Show the associated equipment sets for the items in your bags (or bank)."] = true
L["Here you can choose what equipment sets to use in different situations."] = true
L["Equip this set when switching to specialization %s."] = true
L["Equip this set for open world/general use."] = true
L["Equip this set after entering dungeons or raids."] = true
L["Equip this set after entering battlegrounds or arens."] = true
L["Equip this set after enetering a timewalking dungeon."] = true
L["Use Instance Set"] = true
L["Use a dedicated set for instances and raids."] = true
L["Use PvP Set"] = true
L["Use a dedicated set for PvP situations."] = true
L["Use Timewalking Set"] = true
L["Use a dedicated set for timewalking instances."] = true
L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."] = true
L["SLE_EM_LOCK_TITLE"] = "|cff9482c9S&L|r"
L["SLE_EM_LOCK_TOOLTIP"] = [[This button is designed for temporary disable
Equip Manager's auto switch gear sets.
While locked (red colored state) it will disable auto swap.]]
L["Block button"] = true
L["Create a button in character frame to allow temp blocking of auto set swap."] = true
L["Ignore zone change"] = true
L["Swap sets only on specialization change ignoring location change when. Does not influence entering/leaving instances and bg/arena."] = true

--Loot
L["Loot Dropped:"] = true
L["Loot Auto Roll"] = true
L["LOOT_AUTO_DESC"] = "Automatically selects an apropriate roll on dropped loot."
L["Auto Confirm"] = true
L["Automatically click OK on BOP items"] = true
L["Auto Greed"] = true
L["Automatically greed uncommon (green) quality items at max level"] = true
L["Auto Disenchant"] = true
L["Automatically disenchant uncommon (green) quality items at max level"] = true
L["Loot Quality"] = true
L["Sets the auto greed/disenchant quality\n\nUncommon: Rolls on Uncommon only\nRare: Rolls on Rares & Uncommon"] = true
L["Roll based on level."] = true
L["This will auto-roll if you are above the given level if: You cannot equip the item being rolled on, or the ilevel of your equipped item is higher than the item being rolled on or you have an heirloom equipped in that slot"] = true
L["Level to start auto-rolling from"] = true
L["Loot Announcer"] = true
L["AUTOANNOUNCE_DESC"] = "When enabled, will automatically announce the loot when the loot window opens.\n\n|cffFF0000Note:|r Raid Lead, Assist, & Master Looter Only."
L["Auto Announce"] = true
L["Manual Override"] = true
L["Sets the button for manual override."] = true
L["No Override"] = true
L["Automatic Override"] = true
L["Sets the minimum loot threshold to announce."] = true
L["Select chat channel to announce loot to."] = true
L["Loot Roll History"] = true
L["LOOTH_DESC"] = "These are options for tweaking the Loot Roll History window."
L["Auto hide"] = true
L["Automaticaly hides Loot Roll Histroy frame when leaving the instance."] = true
L["Sets the alpha of Loot Roll Histroy frame."] = true
L["Channels"] = true
L["Private channels"] = true
L["Incoming"] = true
L["Outgoing"] = true

--Media
L["SLE_MEDIA_ZONES"] = {
	"Washington",
	"Moscow",
	"Moon Base",
	"Goblin Spa Resort",
	"Illuminaty Headquaters",
	"Elv's Closet",
	"BlizzCon",
}
L["SLE_MEDIA_PVP"] = {
	"(Horde Territory)",
	"(Alliance Territory)",
	"(Contested Territory)",
	"(Russian Territory)",
	"(Aliens Territory)",
	"(Cats Territory)",
	"(Japanese Territory)",
	"(EA Territory)",
}
L["SLE_MEDIA_SUBZONES"] = {
	"Administration",
	"Hellhole",
	"Alley of Bullshit",
	"Dr. Pepper Storage",
	"Vodka Storage",
	"Last National Bank",
}
L["SLE_MEDIA_PVPARENA"] = {
	"(PvP)",
	"No Smoking!",
	"Only 5% Taxes",
	"Free For All",
	"Self destruction is in process",
}
L["SLE_MEDIA"] = "Options to change the look of several UI elements."
L["Zone Text"] = true
L["Subzone Text"] = true
L["PvP Status Text"] = true
L["Misc Texts"] = true
L["Mail Text"] = true
L["Chat Editbox Text"] = true
L["Gossip and Quest Frames Text"] = true

--Minimap
L["Minimap Options"] = true
L['MINIMAP_DESC'] = "These options effect various aspects of the minimap. Some options may not work if you disable minimap in the General section of ElvUI config."
L["Hide minimap in combat."] = true
L["Minimap Alpha"] = true
L["Minimap Coordinates"] = true
L["Enable/Disable Square Minimap Coords."] = true
L["Coords Display"] = true
L["Change settings for the display of the coordinates that are on the minimap."] = true
L["Coords Location"] = true
L["This will determine where the coords are shown on the minimap."] = true
L["Bottom Corners"] = true
L["Bottom Center"] = true
L["Minimap Buttons"] = true
L["Enable/Disable Square Minimap Buttons."] = true
L["Bar Enable"] = true
L["Enable/Disable Square Minimap Bar."] = true
L["Skin Dungeon"] = true
L["Skin dungeon icon."] = true
L["Skin Mail"] = true
L["Skin mail icon."] = true
L["The size of the minimap buttons when not anchored to the minimap."] = true
L["Icons Per Row"] = true
L["Anchor mode for displaying the minimap buttons are skinned."] = true
L["Show minimap buttons on mouseover."] = true
L["Instance indication"] = true
L["Show instance difficulty info as text."] = true
L["Show texture"] = true
L["Show instance difficulty info as default texture."] = true
L["Sets the colors for difficulty abbreviation"] = true
L["Location Panel"] = true
L["Automatic Width"] = true
L["Change width based on the zone name length."] = true
L["Update Throttle"] = true
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = true
L["Full Location"] = true
L["Color Type"] = true
L["Custom Color"] = true
L["Reaction"] = true
L["Location"] = true
L["Coordinates"] = true
L["Teleports"] = true
L["Portals"] = true
L["Link Position"] = true
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = true
L["Relocation Menu"] = true
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = true
L["Custom Width"] = true
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = true
L["Justify Text"] = true
L["Hearthstone Location"] = true
L["Show the name on location your Heathstone is bound to."] = true
L["Only Number"] = true
L["Horizontal Growth"] = true
L["Vertical Growth"] = true


--Miscs
L["Error Frame"] = true
L["Ghost Frame"] = true
L["Raid Utility Mouse Over"] = true
L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"] = true
L["Set the height of Error Frame. Higher frame can show more lines at once."] = true
L["Enabling mouse over will make ElvUI's raid utility show on mouse over instead of always showing."] = true
L["Adjust the position of the threat bar to any of the datatext panels in ElvUI & S&L."] = true
L["Enhanced Vehicle Bar"] = true
L["A different look/feel vehicle bar"] = true

--Nameplates
L["Target Count"] = true
L["Display the number of party / raid members targetting the nameplate unit."] = true
L["Threat Text"] = true
L["Display threat level as text on targeted, boss or mouseover nameplate."] = true

--Professions
L["Deconstruct Mode"] = true
L["Create a button in your bag frame to switch to deconstrution mode allowing you to easily disenchant/mill/prospect and pick locks."] = true
L["Actionbar Proc"] = true
L["Actionbar Autocast"] = true
L["Show glow on bag button"] = true
L["Show glow on the deconstruction button in bag when deconstruction mode is enabled.\nApplies on next mode toggle."] = true
L["Scroll"] = true
L["Sets style of glow around item available for deconstruction while in deconstruct mode. Autocast is less intence but also less noticeable."] = true
L["Enchant Scroll Button"] = true
L["Create a button for applying selected enchant on the scroll."] = true
L["Following options are global and will be applied to all characters on account."] = true
L["Deconstruction ignore"] = true
L["Items listed here will be ignored in deconstruction mode. Add names or item links, entries must be separated by comma."] = true
L["Ignore tabards"] = true
L["Deconstruction mode will ignore tabards."] = true
L["Ignore Pandaria BoA"] = true
L["Deconstruction mode will ignore BoA weapons from Pandaria."] = true
L["Ignore Cooking"] = true
L["Deconstruction mode will ignore cooking specific items."] = true
L["Ignore Fishing"] = true
L["Deconstruction mode will ignore fishing specific items."] = true
L["Unlock in trade"] = true
L["Apply unlocking skills in trade window the same way as in deconstruction mode for bags."] = true
L["Easy Cast"] = true
L["Allow to fish with double right-click."] = true
L["From Mount"] = true
L["Start fishing even if you are mounted."] = true
L["Apply Lures"] = true
L["Automatically apply lures."] = true
L["Ingore Poles"] = true
L["If enabled will start fishing even if you don't have fishing pole equipped. Will not work if you have fish key set to \"None\"."] = true
L["Fish Key"] = true
L["Hold this button while clicking to allow fishing action."] = true


--PvP
L["Functions dedicated to player versus player modes."] = true
L["PvP Auto Release"] = true
L["Automatically release body when killed inside a battleground."] = true
L["Check for rebirth mechanics"] = true
L["Do not release if reincarnation or soulstone is up."] = true
L["SLE_DuelCancel_REGULAR"] = "Duel request from %s rejected."
L["SLE_DuelCancel_PET"] = "Pet duel request from %s rejected."
L["Automatically cancel PvP duel requests."] = true
L["Automatically cancel pet battles duel requests."] = true
L["Announce"] = true
L["Announce in chat if duel was rejected."] = true
L["Show your PvP killing blows as a popup."] = true
L["KB Sound"] = true
L["Play sound when Kkilling blows popup is shown."] = true

--Quests
L["Rested"] = true
L["Auto Reward"] = true
L["Automatically selects areward with higherst selling price when quest is completed. Does not really finish the quest."] = true

--Raid Marks
L["Raid Markers"] = true
L["Click to clear the mark."] = true
L["Click to mark the target."] = true
L["%sClick to remove all worldmarkers."] = true
L["%sClick to place a worldmarker."] = true
L["Raid Marker Bar"] = true
L["Options for panels providing fast access to raid markers and flares."] = true
L["Show/Hide raid marks."] = true
L["Reverse"] = true
L["Modifier Key"] = true
L["Set the modifier key for placing world markers."] = true
L["Visibility State"] = true

--Raidroles
L["Options for customizing Blizzard Raid Manager \"O - > Raid\""] = true
L["Show role icons"] = true
L["Show level"] = true

--Skins
L["SLE_SKINS_DESC"] = [[This section is designed to enhance skins existing in ElvUI.

Please note that some of these options will not be available if corresponding skin is disabled in
main ElvUI skins section.]]
L["Pet Battle Status"] = true
L["Pet Battle AB"] = true
L["Sets the texture for statusbars in quest tracker, e.g. bonus objectives/timers."] = true
L["Statusbar Color"] = true
L["Class Colored Statusbars"] = true
L["Underline"] = true
L["Creates a cosmetic line under objective headers."] = true
L["Underline Color"] = true
L["Class Colored Underline"] = true
L["Underline Height"] = true
L["Header Text Color"] = true
L["Class Colored Header Text"] = true
L["Subpages"] = true
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = true
L["ElvUI Objective Tracker"] = true
L["ElvUI Skins"] = true
L["As List"] = true
L["List Style Fonts"] = true
L["Item Name Font"] = true
L["Item Name Size"] = true
L["Item Name Outline"] = true
L["Item Info Font"] = true
L["Item Info Size"] = true
L["Item Info Outline"] = true
L["Remove Parchment"] = true
L["Stage Background"] = true

--Toolbars
L["We are sorry, but you can't do this now. Try again after the end of this combat."] = true
L["Right-click to drop the item."] = true
L["Button Size"] = true
L["Only active buttons"] = true
--Farm
L["Tilled Soil"] = true
L["Farm Seed Bars"] = true
L["Farm Tool Bar"] = true
L["Farm Portal Bar"] = true
L["Farm"] = true
L["Only show the buttons for the seeds, portals, tools you have in your bags."] = true
L["Auto Planting"] = true
L["Automatically plant seeds to the nearest tilled soil if one is not already selected."] = true
L["Quest Glow"] = true
L["Show glowing border on seeds needed for any quest in your log."] = true
L["Dock Buttons To"] = true
L["Change the position from where seed bars will grow."] = true
--Garrison
L["Garrison Tools Bar"] = true
L["Auto Work Orders"] = true
L["Automatically queue maximum number of work orders available when visiting respected NPC."] = true
L["Auto Work Orders for Warmill"] = true
L["Automatically queue maximum number of work orders available for Warmill/Dwarven Bunker."] = true
L["Auto Work Orders for Trading Post"] = true
L["Automatically queue maximum number of work orders available for Trading Post."] = true
L["Auto Work Orders for Shipyard"] = true
L["Automatically queue maximum number of work orders available for Shipyard."] = true
--Class Hall
L["Class Hall"] = true
L["Auto Work Orders for equipment"] = true

--Tooltip
L["Always Compare Items"] = true
L["Faction Icon"] = true
L["Show faction icon to the left of player's name on tooltip."] = true
L["TTOFFSET_DESC"] = "This adds the ability to have the tooltip offset from the cursor.  Make sure to have the \"Cursor Anchor\" option enabled in ElvUI's Tooltip section to use this feature."
L["Tooltip Cursor Offset"] = true
L["Tooltip X-offset"] = true
L["Offset the tooltip on the X-axis."] = true
L["Tooltip Y-offset"] = true
L["Offset the tooltip on the Y-axis."] = true
L["RAID_NH"] = "NH"
L["RAID_TOV"] = "ToV"
L["RAID_EN"] = "EN"
L["Raid Progression"] = true
L["Show raid experience of character in tooltip (requires holding shift)."] = true
L["Name Style"] = true
L["Difficulty Style"] = true

--UI Buttons
L["S&L UI Buttons"] = true
L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."] = true
L["ElvUI Config"] = true
L["Click to toggle config window"] = true
L["S&L Config"] = true
L["Click to toggle Shadow & Light config group"] = true
L["Reload UI"] = true
L["Click to reload your interface"] = true
L["Move UI"] = true
L["Click to unlock moving ElvUI elements"] = true
L["AddOns"] = true
L["AddOns Manager"] = true
L["Click to toggle the AddOn Manager frame."] = true
L["Boss Mod"] = true
L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."] = true
L["UB_DESC"] = "This adds a small bar with some useful buttons which acts as a small menu for common things."
L["Minimum Roll Value"] = true
L["The lower limit for custom roll button."] = true
L["Maximum Roll Value"] = true
L["The higher limit for custom roll button."] = true
L["Quick Action"] = true
L["Use quick access (on right click) for this button."] = true
L["Function"] = true
L["Function called by quick access."] = true
L["UI Buttons Strata"] = true

--Unitframes
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = true
L["Player Frame Indicators"] = true
L["Combat Icon"] = true
L["LFG Icons"] = true
L["Choose what icon set will unitframes and chat use."] = true
L["Offline Indicator"] = true
L["Shows an icon on party or raid unitframes for people that are offline."] = true
L["Texture"] = true
L["Statusbars"] = true
L["Power Texture"] = true
L["Castbar Texture"] = true
L["Red Icon"] = true
L["Aura Bars Texture"] = true
L["Higher Overlay Portrait"] = true
L["Makes frame portrait visible regardles of health level when overlay portrait is set."] = true
L["Classbar Texture"] = true
L["Resize Health Prediction"] = true
L["Slightly chages size of health prediction bars."] = true
L["Always Compare Items"] = true


--Viewport
L["Viewport"] = true
L["Left Offset"] = true
L["Set the offset from the left border of the screen."] = true
L["Right Offset"] = true
L["Set the offset from the right border of the screen."] = true
L["Top Offset"] = true
L["Set the offset from the top border of the screen."] = true
L["Bottom Offset"] = true
L["Set the offset from the bottom border of the screen."] = true

--Help
L["About/Help"] = true
L["About"] = true
L["SLE_DESC"] = [=[|cff9482c9Shadow & Light|r is an extention of ElvUI. It adds:
- a lot of new features 
- more customization options for existing ones

|cff3cbf27Note:|r It is compatible with most of addons and ElvUI plugins available. But some functions may be unaccesable to avoid possible conflicts.]=]
L["Links"] = true
L["LINK_DESC"] = [[Following links will direct you to the Shadow & Light's pages on various sites.]]

--FAQ--
L["FAQ_DESC"] = "This section contains some questions about ElvUI and Shadow & Light."
L["FAQ_Elv_1"] = [[|cff30ee30Q: Where can I cat ElvUI support?|r
|cff9482c9A:|r Best way is official forum - tukui.org/forums/
For bug reports you can also use bug tracker - git.tukui.org/Elv/elvui/issues]]
L["FAQ_Elv_2"] = [[|cff30ee30Q: Do I need to have good English in order to do so?|r
|cff9482c9A:|r English is official language of tukui.org forums so most posts in there are in English.
But this doesn't mean it's the only language used there. You will be able to find posts in Spanish, French, German, Russian, Italian, etc.
While you follow some simple rules of common sense everyone will be ok with you posting in your native language. Like stating said language in the topic's title.
Keep in mind that you can still get an answer in English cause the person answering can be unable to speak your language.]]
L["FAQ_Elv_3"] = [[|cff30ee30Q: What info do I need to provide in a bug report?|r
|cff9482c9A:|r First you need to ensure the error really comes from ElvUI.
To do so you need to disable all other addons except of ElvUI and ElvUI_Config.
If error didn't disappear then you need to send us a bug report.
In it you'll need to provide ElvUI version ("latest" is not a valid version number), the text of the error, screenshot if needed.
The more info you'll give us on how to reproduce said error the faster it will be fixed.]]
L["FAQ_Elv_4"] = [[|cff30ee30Q: Why some options are not applied on other characters while using the same profile?|r
|cff9482c9A:|r ElvUI has three kinds of options. First (profile) is stored in your profile, second (private) is stored on a character basis, third (global) are applied across all character regardless of profile used.
In this case you most likely came across the option of type two.]]
L["FAQ_Elv_5"] = [[|cff30ee30Q: What are ElvUI slash (chat) commands?|r
|cff9482c9A:|r ElvUI has a lot of different chat commands used for different purposes. They are:
/ec or /elvui - Opening config window
/bgstats - Shows battleground specific datatexts if you are on battleground and closed those
/hellokitty - Want a pink kawaii UI? We got you covered!
/harlemshake - Need a shake? Just do it!
/luaerror - loads you UI in testing mode that is designed for making a proper bug report (see Q #3)
/egrid - Sets the size of a grid in toggle anchors mode
/moveui - Allows to move stuff around
/resetui - Resets your entire UI]]
L["FAQ_sle_1"] = [[|cff30ee30Q: What to do if I encounter an error is Shadow & Light?|r
|cff9482c9A:|r Pretty much the same as for ElvUI (see it's faq section ) but you'll have to provide S&L version too.]]
L["FAQ_sle_2"] = [[|cff30ee30Q: Does Shadow & Light have the same language policy as ElvUI?|r
|cff9482c9A:|r Yes. But S&L actually have two official languages - English and Russian.]]
L["FAQ_sle_3"] = [[|cff30ee30Q: Why are layouts' screenshots on download page are different from what I see in game?|r
|cff9482c9A:|r Because we just forgot to update those.]]
L["FAQ_sle_4"] = [[|cff30ee30Q: Why I see some weird icons near some peoples' names in chat?|r
|cff9482c9A:|r Those icons are provided by S&L and are associated with people we'd like to highlight in any way.
For example: |TInterface\AddOns\ElvUI_SLE\media\textures\SLE_Chat_LogoD:0:2|t is the icon for Darth's characters and |TInterface\AddOns\ElvUI_SLE\media\textures\SLE_Chat_Logo:0:2|t is for Repooc's. |TInterface\AddOns\ElvUI_SLE\media\textures\Chat_Test:16:16|t is awarded for help in finding bugs.]]
L["FAQ_sle_5"] = [[|cff30ee30Q: How can I get in touch with you guys?|r
|cff9482c9A:|r For obvious reasons we are not giving out our contacts freely. So your best bet is using tukui.org forums.]]

--Credits--
L["ELVUI_SLE_CREDITS"] = "We would like to point out the following people for helping us create this addon with testing, coding, and other stuff."
L["ELVUI_SLE_CODERS"] = [=[Elv
Tukz
Affinitii
Arstraea
Azilroka
Benik, The Slacker
Blazeflack
Boradan
Camealion
Nils Ruesch
Omega1970
Pvtschlag
Simpy, The Heretic
Sinaris
Sortokk
Swordyy
]=]
L["ELVUI_SLE_MISC"] = [=[BuG - for always hilariously breaking stuff
TheSamaKutra
The rest of TukUI community
]=]
