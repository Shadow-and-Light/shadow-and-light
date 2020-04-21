-- German localization file for deDE.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "deDE")

if not L then return; end
--Popups
L["MSG_SLE_ELV_OUTDATED"] = "Deine Version von ElvUI ist älter als die empfohlene, die mit |cff9482c9Shadow & Light|r benutzt werden sollte. Deine Version ist |cff1784d1%.2f|r (empfohlen ist |cff1784d1%.2f|r). Bitte update dein ElvUI."
L["This will clear your chat history and reload your UI.\nContinue?"] = "Dieses wird deinen Chatverlauf leeren und dein UI neuladen.\nFortfahren?"
L["This will clear your editbox history and reload your UI.\nContinue?"] = "Dieses wird dein Eingabeverlauf leeren und dein UI neuladen.\nFortfahren?"
L["Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Oh Gott, du hast ElvUI Enhanced und Shadow & Light gleichzeitig aktiviert. Wähle ein Addon zum Deaktivieren aus."
L["You have got Loot Confirm and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast Loot Confirm und Shadow & Light gleichzeitig aktiviert. Wähle ein Addon zum Deaktivieren aus."
L["You have got OneClickEnchantScroll and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast OneClickEnchantScroll und Shadow & Light gleichzeitig aktiviert. Wähle ein Addon zum Deaktivieren aus."
L["You have got ElvUI Transparent Actionbar Backdrops and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Du hast ElvUI Transparent Actionbar Backdrops und Shadow & Light gleichzeitig aktiviert. Wähle ein Addon zum Deaktivieren aus."
L["SLE_ADVANCED_POPUP_TEXT"] = [[Schwörst du, dass du ein erfahrener Benutzer bist,
du kannst Tooltips für Optionen lesen und wirst nicht um Hilfe schreien wenn
irgendetwas furchtbar schief mit deinem UI passiert mit diesen zusätzlichen Optionen?

Falls ja, ist es erlaubt fortzufahren.
]]
L["SLE_DB_CONVERT_COMPLETE_TEXT"] = "S&L converted outdated entries in its database.\n\n|cff14adcdFollowing profiles were updated:|r\n%s\n\n|cff14adcdPrivate settings were updated for the following characters:|r\n%s\n\nYou may now continue to play :)"

--Install
L["Moving Frames"] = "Bewegbare Fenster"
L["Author Presets"] = "Autor Voreinstellungen"
L["|cff9482c9Shadow & Light|r Installation"] = true
L["Welcome to |cff9482c9Shadow & Light|r version %s!"] = "Willkommen zu |cff9482c9Shadow & Light|r Version %s!"
L["SLE_INSTALL_WELCOME"] = [[Dieses führt dich durch ein Schnellinstallationsprozess um einige Shadow & Light Funktionalitäten einzustellen.
Wenn du keine Optionen in der Installation auswählen möchtest, klicke auf den Schritt Überspringen Knopf um die Installation zu beenden.

Beachte jedoch, dass die Schritte rechts mit * gekennzeichnet die vorherigen Schritte benötigen.]]
L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."] = "Dieses wird den S&L Armory Mode aktivieren, welcher detailliertere Informationen auf einen Blick anzeigt, wenn du einen Charakter inspizierst oder in deinem eigenen Charakter Fenster."
L["SLE_ARMORY_INSTALL"] = "Aktiviere S&L Armory\n(Detaillierte Charakter & Betrachten Fenster)."
L["AFK Mode in |cff9482c9Shadow & Light|r is additional settings/elements for standard |cff1784d1ElvUI|r AFK screen."] = "Der AFK Mode in |cff9482c9Shadow & Light|r erlaubt zusätzliche Einstellungen/Elemente für den Standard |cff1784d1ElvUI|r AFK Mode."
L["This option is bound to character and requires a UI reload to take effect."] = "Diese Option ist an den Charakter gebunden und benötigt ein neuladen des UI um aktiv zu werden."
L["Shadow & Light Imports"] = "Shadow & Light Importierungen"
L["You can now choose if you want to use one of the autors' set of options. This will change the positioning of some elements as well of other various options."] = "Du kannst jetzt auswählen ob du einige Einstellunge von den Autoren verwenden möchtest. Dieses wird die Positionierung von einigen Elementen verändern und auch einige Optionen."
L["SLE_Install_Text_AUTHOR"] = [=[Dieser Schritt ist optional und sollte nur ausgewählt werden, wenn du die Einstellungen von uns verwenden möchtest. In einigen Fällen sind die Einstellungen unterschiedlich, basierend auf den Layout Einstellungen die du in ElvUI gewählt hast.
Wenn du nichts auswählst, wird vorausgesetzt dass du den nächsten Installationsschritt überspringst.

|cff1784d1"%s"|r wurde ausgewählt.

|cffFF0000Achtung:|r Bitte beachte dass die Autoren vielleicht oder vielleicht auch nicht die Layouts/Themes die du ausgewählt hast nicht verwenden. Beachte auch, wenn du zwischen den Layouts hin und her wechselst könnte es auch zu ungewollten Resultaten führen.]=]
L["Darth's Config"] = "Darth's Einstellungen"
L["Repooc's Config"] = "Repooc's Einstellungen"
L["Affinitii's Config"] = "Affinitii's Einstellungen"
L["Darth's Default Set"] = "Darth's Standardeinstellungen"
L["Repooc's Default Set"] = "Repooc's Standardeinstellungen"
L["Affinitii's Default Set"] = "Affinitii's Standardeinstellungen"
L["Layout & Settings Import"] = "Layout & Einstellungsimportierung"
L["Layout Old"] = true
L["You have selected to use %s and role %s."] = "Du hast %s und Rolle %s ausgewählt."
L["SLE_INSTALL_LAYOUT_TEXT2"] = [[Folgende Knöpfe werden Layout/Addon Einstellungen für die gewählte Konfiguration und Rolle verwenden.
Bitte beachte dass diese Konfiguration vielleicht einige Einstellungen beinhaltet, mit denen du noch nicht vertraut bist.

Auch könnte es auch einige Optionen zurücksetzen/ändern die du den vorherigen Schritten ausgewählt hast.]]
L["|cff1784d1%s|r role was chosen"] = "|cff1784d1%s|r Rolle wurde ausgewählt"
L["Import Profile"] = "Profil importieren"
L["SLE_INSTALL_SETTINGS_LAYOUT_TEXT"] = [[Diese Aktion könnte bewirken dass du einige Einstellungen verlierst.
Fortfahren?]]
L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"] = [[Dieses wird ein Profil für diese Addons erstellen (wenn aktiviert) und zum erstellten Profil wechseln:
%s

Fortfahren?]]

--Config replacements
L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."] = "Diese Optione wurde durch Shadow & Light deaktiviert. Um sie wieder zu aktivieren, musst du die S&L Optionen deaktivieren. Klicke hier, um zu den Einstellungen zu gelangen."

--Core
L["SLE_LOGIN_MSG"] = "|cff9482c9Shadow & Light|r Version |cff1784d1%s%s|r für ElvUI ist geladen. Danke, dass du es benutzt."
L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."] = "Plugin für |cff1784d1ElvUI|r von\nDarth Predator und Repooc."
L["Reset All"] = "Alles zurücksetzen"
L["Resets all movers & options for S&L."] = "Setzt alle Movers & Optionen für S&L zurück."
L["WARNING: This will reset all movers & options for S&L and reload the screen."] = true
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

--Armory
L["SLE_Armory_Info"] = "Armory is designed to provide standard ElvUI item info in a different way. Keep in mind that display of enchantments, gems and item levels is only available when corresponding ElvUI option is enabled. Use button below to visit mentioned feature's config section."
L["SLE_Armory_SkinDisabled"] = "You disabled all the skins, so we disabled all Armory features to avoid graphics being broken as heck. What esle did you expect?"
L["Average"] = "Durschnitt"
L["Not Enchanted"] = "Nicht verzaubert"
L["Empty Socket"] = "Leerer Sockel"
L["You can't inspect while dead."] = "Du kannst nicht inspizieren während du tod bist."
L["Specialization data seems to be crashed. Please inspect again."] = "Spezialisierungsdaten sind wohl gecrashed. Bitte erneut inspizieren."
L["No Specialization"] = "Keine Spezialisierung"
L["Character model may differ because it was constructed by the inspect data."] = "Charakter Model könntet abweichen weil es auf den zu inspizierenden Daten aufbaut."
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
L["Color code item levels values. Equipped will be gradient, average - selected color."] = "Farbencode Itemlevel Werte. Ausgerüstet ist gradient, Durschnitt - gewählte Farbe."
L["Color of Average"] = "Farbe vom Durchschnitt"
L["Sets the color of average item level."] = "Setzt die Farbe vom Durchschnitts-Itemlevel"
L["Only Relevant Stats"] = "Nur relevante Werte"
L["Show only those primary stats relevant to your spec."] = "Zeigt nur primäre Werte die relevant für deinen Spec sind."
L["SLE_ARMORY_POINTS_AVAILABLE"] = "%s Punkt(e) verfügbar!!"
L["Show ElvUI skin's backdrop overlay"] = "Zeigt ElvUI-Skin Hintergrund Overlay"
L["Try inspecting %s. Sometimes this work will take few second for waiting server's response."] = "Versuche %s zu betrachten. Es könnte manchmal passieren das es ein paar sekunden dauert bis die Daten vom Server geladen werden."
L['Inspect is canceled because target was changed or lost.'] = "Betrachten wurde abgebrochen weil das Ziel geändert oder verloren wurde."
L["You can't inspect while dead."] = "Während du tod bist kannst du nicht betrachten."
L["Show Inspection message in chat"] = "Zeige Betrachten Nachricht im Chat"
L["Font Size"] = true
L["General Fonts"] = true
L["Title"] = true
L["Level and race"] = true
L["Info Fonts"] = true
L["Block names"] = true
L["PvP Type"] = true
L["Spec Fonts"] = true
L["Azerite Level Position"] = true
L["Transmog"] = true
L["Enable Glow"] = true
L["Enable Arrow"] = true
L["Enables a small arrow-like indicator on the item slot. Howering over this arrow will show the item this slot is transmogged into."] = true
L["Glow Number"] = true
L["Glow Offset"] = true
L["Categories"] = true
L["Decimals"] = true
L["Show stats with decimals."] = true
L["Corruption / Resist"] = true

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
L["Enable S&L's additional features for AFK screen."] = "Aktiviere S&L zusätzliche AFK Modus Funktionalitäten."
L["Button restrictions"] = "Tasten Beschränkungen"
L["Use ElvUI's restrictions for button presses."] = "Benutze ElvUI's Beschränkungen für Tastendruck."
L["Crest"] = "Wappen"
L["Faction Crest X-Offset"] = "Fraktions-Wappen X-Versatz"
L["Faction Crest Y-Offset"] = "Fraktions-Wappen Y-Versatz"
L["Race Crest X-Offset"] = "Rassen-Wappen X-Versatz"
L["Race Crest Y-Offset"] = "Rassen-Wappen Y-Versatz"
L["Texts Positions"] = "Textpositionen"
L["Date X-Offset"] = "Datums X-Versatz"
L["Date Y-Offset"] = "Datums Y-Versatz"
L["Player Info X-Offset"] = "Spielerinfo X-Versatz"
L["Player Info Y-Offset"] = "Spielerinfo Y-Versatz"
L["X-Pack Logo Size"] = "Erweiterung Logo Größe"
L["Template"] = "Vorlage"
L["Player Model"] = "Spieler Model"
L["Model Animation"] = "Model Animation"
L["Test"] = true
L["Shows a test model with selected animation for 10 seconds. Clicking again will reset timer."] = "Zeigt ein Test Model mit ausgewählter Animation. Der Timer wird resetted wenn du drauf klickst."
L["Misc"] = "Verschiedenes"
L["Bouncing"] = "Springend"
L["Use bounce on fade in animations."] = "Benutze springend auf verblassenden Animationen."
L["Animation time"] = "Animationszeit"
L["Time the fade in animation will take. To disable animation set to 0."] = "Zeit, die die verblassende Animation stattfindet. Um zu deaktiveren setze es auf 0."
L["Slide"] = "Gleiten"
L["Slide Sideways"] = "Seitwärts gleiten"
L["Fade"] = "Verblassen"
L["Tip time"] = "Hinweiszeit"
L["Number of seconds tip will be shown before changed to another."] = "Sekunden die der Hinweis angezeigt wird, bevor er wechselt."
L["Title font"] = "Titel Schriftart"
L["Subtitle font"] = "Untertitel Schriftart"
L["Date font"] = "Datums Schrifart"
L["Player info font"] = "Spielerinfo Schriftart"
L["Tips font"] = "Hinweis Schriftart"
L["Graphics"] = "Grafiken"

--Auras
L["Hide Buff Timer"] = "Verstecke Stärkungszauber Timer"
L["This hides the time remaining for your buffs."] = "Dieses wird den Timer für die Stärkungszauber verstecken."
L["Hide Debuff Timer"] = "Verstecke Schwächungszauber Timer"
L["This hides the time remaining for your debuffs."] = "Dieses wird den Timer für die Schwächungszauber verstecken."

--Backgrounds
L["Backgrounds"] = "Hintergründe"
L["SLE_BG_1"] = "Hintergrund 1"
L["SLE_BG_2"] = "Hintergrund 2"
L["SLE_BG_3"] = "Hintergrund 3"
L["SLE_BG_4"] = "Hintergrund 4"
L["Additional Background Panels"] = "Zusätzliche Hintergrundsleisten"
L["BG_DESC"] = "Modul zum erstellen von zusätzlichen Hintergründen. Diese können für alles verwendet werden."
L["Show/Hide this frame."] = "Zeige/Verstecke dieses Frame."
L["Sets width of the frame"] = "Setzt die Breite von dem Frame"
L["Sets height of the frame"] = "Setzt die Höhe von dem Frame"
L["Set the texture to use in this frame. Requirements are the same as the chat textures."] = "Setzt die Textur die mit diesem Frame benutzt wird. Anforderung ist die selbe von in Chat Texturen."
L["Backdrop Template"] = "Hintergrund Vorlage"
L["Change the template used for this backdrop."] = "Ändere die Vorlage für diesen Hintergrund."
L["Hide in Pet Battle"] = "Verstecke in Haustierkämpfen"
L["Show/Hide this frame during Pet Battles."] = "Zeige/Verstecke dieses Frame in Haustierkämpfen."

--Bags

--Blizzard
L["Move Blizzard frames"] = "Bewege Blizzard Fenster"
L["Allow some Blizzard frames to be moved around."] = "Erlaubt das Bewegen einiger Blizzard Fenster"
L["Remember"] = true
L["Remember positions of frames after moving them."] = true
L["Pet Battles skinning"] = "Haustierkampf Skin"
L["Make some elements of pet battles movable via toggle anchors."] = "Erlaubt das Verschieben einiger Haustierkampf Elemente via Anker umschalten."

--Chat
L["Reported by %s"] = "Berichtet von %s"
L["Reset Chat History"] = "Chatverlauf zurücksetzen"
L["Clears your chat history and will reload your UI."] = "Leert dein Chatverlauf und lädt das UI neu."
L["Reset Editbox History"] = "Eingabeverlauf zurücksetzen"
L["Clears the editbox history and will reload your UI."] = "Leert dein Eingabeverlauf und lädt das UI neu."
L["Guild Master Icon"] = "Gildenmeister Symbol"
L["Displays an icon near your Guild Master in chat.\n\n|cffFF0000Note:|r Some messages in chat history may disappear on login."] = "Zeigt ein Symbol vor dem Gildenmeister Namen im Chat.\n\n|cffFF0000Hinweis:|r Einige Nachrichten im Chatverlauf könnten verschwinden beim Login."
L["Chat Editbox History"] = "Chat Eingabeverlauf"
L["The amount of messages to save in the editbox history.\n\n|cffFF0000Note:|r To disable, set to 0."] = "Die Anzahl von Nachrichten die im Eingabeverlauf gespeichert werden.\n\n|cffFF0000Hinweis:|r Zum deaktivieren auf 0 setzen."
L["Filter DPS meters' Spam"] = "Filtere DPS Meter Spam"
L["Replaces long reports from damage meters with a clickable hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter the report of other things."] = "Ersetzt lange Berichte von Damage Metern mit einem klickbaren Hyperlink um Chatspam zu vermeiden.\nFunktioniert korrekt mit generellen Berichten wie DPS oder HPS. Könnte bei anderen Berichten nicht funktionieren."
L["Texture Alpha"] = "Textur Alpha"
L["Allows separate alpha setting for textures in chat"] = "Erlaubt zusätzliche Alpha Einstellungen für die Texturen im Chat."
L["Chat Frame Justify"] = "Chatfenster Ausrichtung"
L["Identify"] = "Identifizieren"
L["Shows the message in each chat frame containing frame's number."] = "Zeigt die Nachricht in jeden Fenster wo die Nummer zutrifft."
L["This is %sFrame %s|r"] = "Dies ist %sFenster %s|r"
L["Loot Icons"] = "Beute Symbol"
L["Shows icons of items looted/created near respective messages in chat. Does not affect usual messages."] = "Zeigt ein Symbol neben dem hergestellten/geplünderten Gegenstand im Chat. Wird nicht auf normale Nachrichten angewandt."
L["Frame 1"] = "Fenster 1"
L["Frame 2"] = "Fenster 2"
L["Frame 3"] = "Fenster 3"
L["Frame 4"] = "Fenster 4"
L["Frame 5"] = "Fenster 5"
L["Frame 6"] = "Fenster 6"
L["Frame 7"] = "Fenster 7"
L["Frame 8"] = "Fenster 8"
L["Frame 9"] = "Fenster 9"
L["Frame 10"] = "Fenster 10"
L["Chat Max Messages"] = "Maximale Chatnachrichten"
L["The amount of messages to save in chat window.\n\n|cffFF0000Warning:|r Can increase the amount of memory needed. Also changing this setting will clear the chat in all windows, leaving just lines saved in chat history."] = "Die Anzahl der Nachrichten die im Chatfenster gespeichert werden.\n\n|cffFF0000Warnung:|r Könnte den Speicherbedarf erhöhen. Wenn du diese Einstellungen änderst, wird dass alle Nacchrichten in allen Fenstern löschen."
L["Tabs"] = true
L["Selected Indicator"] = "Ausgewählt-Indikator"
L["Shows you which of docked chat tabs is currently selected."] = "Zeigt dir welcher Chat Tab gerade ausgewählt ist."
L["Chat history size"] = "Chatverlauf Größe"
L["Sets how many messages will be stored in history."] = "Setzt die Anzahl der Nachrichten die im Verlauf gespeichert werden."
L["Following options determine which channels to save in chat history.\nNote: disabling a channel will immediately delete saved info for that channel."] = "Folgende Optionen bestimmen aus welchem Kanal der Chatverlauf gespeichert wird.\nHinweis: Wenn ein Kanal deaktiviert wird, wird sofort die gespeicherten Infos gelöscht."
L["Alt-Click Invite"] = "Alt-Klick Einladung"
L["Allows you to invite people by alt-clicking their names in chat."] = "Erlaubt dir das Einladen mit Alt-Klick auf den Spielernamen im Chat."
L["Invite links"] = "Einladungslink"
L["Converts specified keywords to links that automatically invite message's author to group."] = "Wandelt spezifische Schlüsselwörter in Links um, die dass automatische Einladen erlaubt."
L["Link Color"] = "Link Farbe"
L["Invite Keywords"] = "Einladungs-Schlüsselwörter"
L["Chat Setup Delay"] = "Chateinstellung Verzögerung"
L["Manages the delay before S&L will execute hooks to ElvUI's chat positioning. Prevents some weird positioning issues."] = "Legt die Verzögerung fest, wann S&L die Chatposition vonn ElvUI verändert. Beugt ungewollten Positionen vor."
L["Title Width"] = true

--Databars
L["Full value on Exp Bar"] = "Voller Wert auf Erfahrungsleiste"
L["Changes the way text is shown on exp bar."] = "Ändert wie der Text auf der Erfahrungsleiste angezeigt wird."
L["Full value on Rep Bar"] = "Voller Wert auf Rufleiste"
L["Changes the way text is shown on rep bar."] = "Ändert wie der Text auf der Rufleiste angezeigt wird"
L["Auto Track Reputation"] = "Automatisches Rufverfolgen"
L["Automatically sets reputation tracking to the most recent reputation change."] = "Setzt automatisch die Rufverfolgung zur letzten Fraktion bei der Ruf bekommen wurde."
L["Ignore Guild Reputation"] = true
L["Ignore guild reputation gains when autotracking."] = true
L["Change the style of reputation messages."] = "Ändert den Stil der Rufnachrichten."
L["Reputation increase Style"] = "Rufgewinn Stil"
L["Reputation decrease Style"] = "Rufverlust Stil"
L["Output"] = "Ausgabe"
L["Determines in which frame reputation messages will be shown. Auto is for whatever frame has reputation messages enabled via Blizzard options."] = "Legt fest in welchem Fenster die Ruf Nachrichten angezeigt werden. Auto legt fest, wie es in den Blizzard Option ausgewählt wurde."
L["Change the style of experience gain messages."] = "Ändert den Stil der Erfahrungsgewinn Nachrichten."
L["Experience Style"] = "Erfahrungs Stil"
L["Full List"] = "Volle Liste"
L["Show all factions affected by the latest reputation change. When disabled only first (in alphabetical order) affected faction will be shown."] = "Zeigt alle Fraktion bei denen sich zuletzt der Ruf verändert hat. Wenn deaktiviert werden nur die ersten (in alphabetischer Reihenfolge) Fraktionen angezeigt bei denen sich was geändert hat."
L["Full value on Azerite Bar"] = true
L["Changes the way text is shown on azerite bar."] = true
L["Full value on Honor Bar"] = "Voller Wert auf der Ehrenleiste"
L["Changes the way text is shown on honor bar."] = "Ändert wie der Text auf der Ehrenleiste angezeigt wird."
L["Chat Filters"] = "Chatfilter"
L["Replace massages about honorable kills in chat."] = "Ersetzt Nachrichten über Ehrenhafte Siege im Chat."
L["Award"] = "Belohnung"
L["Replace massages about honor points being awarded."] = "Ersetzt Nachrichten über Ehrenpunkte"
L["Defines the style of changed string. Colored parts will be shown with your selected value color in chat."] = "Definiert den Stil des geänderten String. Farbige Teile werden mit der ausgewählten Farbe im Chat angezeigt."
L["Award Style"] = "Belohnungs Stil"
L["HK Style"] = "Ehrenhafte Siege Stil"
L["Honor Style"] = "Ehre Stil"

--Datatexts
L["D"] = true
L["Previous Level:"] = "Vorheriges Level:"
L["Account Time Played"] = "Zeit gespielt auf dem Account:"
L["SLE_DataPanel_1"] = "S&L Data Panel 1"
L["SLE_DataPanel_2"] = "S&L Data Panel 2"
L["SLE_DataPanel_3"] = "S&L Data Panel 3"
L["SLE_DataPanel_4"] = "S&L Data Panel 4"
L["SLE_DataPanel_5"] = "S&L Data Panel 5"
L["SLE_DataPanel_6"] = "S&L Data Panel 6"
L["SLE_DataPanel_7"] = "S&L Data Panel 7"
L["SLE_DataPanel_8"] = "S&L Data Panel 8"
L["This LFR isn't available for your level/gear."] = "Dieser LFR ist nicht verfügbar für dein(e) Level/Ausrüstung"
L["You didn't select any instance to track."] = "Du hast keine Instanz zum Verfolgen ausgewählt."
L["Bosses killed: "] = "Bosse getötet:"
L["Current:"] = "Aktuell:"
L["Weekly:"] = "Wöchentlich:"
L["|cffeda55fLeft Click|r to open the friends panel."] = "|cffeda55fLinks Klick|r um das Freundesfenster zu öffnen."
L["|cffeda55fRight Click|r to open configuration panel."] = "|cffeda55fRechts Klick|r um in die Einstellungen zu gelangen."
L["|cffeda55fLeft Click|r a line to whisper a player."] = "|cffeda55fLinks Klick|r auf eine Linie um einen Spieler zu flüstern."
L["|cffeda55fShift+Left Click|r a line to lookup a player."] = "|cffeda55fShift+Links Klick|r um Spielerinfos zu erhalten."
L["|cffeda55fCtrl+Left Click|r a line to edit a note."] = "|cffeda55fStrg+Links Klick|r auf eine Linie um die Notiz zu bearbeiten."
L["|cffeda55fMiddleClick|r a line to expand RealID."] = "|cffeda55fMittlerer-Klick|r auf eine Linie um die RealID zu erweitern."
L["|cffeda55fAlt+Left Click|r a line to invite."] = "|cffeda55fAlt+Links Klick|r auf eine Linie um einzuladen."
L["|cffeda55fLeft Click|r a Header to hide it or sort it."] = "|cffeda55fLinks Klick|r auf eine Überschrift um auszublenden oder sortieren."
L["|cffeda55fLeft Click|r to open the guild panel."] = "|cffeda55fLinks Klick|r um das Gildenfenster zu öffnen."
L["|cffeda55fCtrl+Left Click|r a line to edit note."] = "|cffeda55fStrg+Links Klick|r auf eine Linie um die Notiz zu bearbeiten."
L["|cffeda55fCtrl+Right Click|r a line to edit officer note."] = "|cffeda55fStrg+Rechts Klick|r auf eine Linie um die Offiziersnotiz zu bearbeiten."
L["New Mail"] = "Neue Post"
L["No Mail"] = "Keine Post"
L["Range"] = "Reichweite"
L["SLE_AUTHOR_INFO"] = "Shadow & Light von Darth Predator & Repooc"
L["SLE_CONTACTS"] = [=[Wenn du Vorschläge oder einen Fehlerreport hast,
eröffne bitte ein Ticket auf https://git.tukui.org/Darth_Predator/elvui-shadowandlight]=]
L["Additional Datatext Panels"] = "Zusätzliche Infotextleisten"
L["DP_DESC"] = [=[Zusätzliche Infotextleisten.
8 Leisten mit insgesamt 20 Infotexten.]=]
L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information."] = "Einige Infotexte die Shadow & Light bereitgestellt werden, haben Einstellungen die, die angezeigten Informationen abändern können."
L["Sets size of this panel"] = "Setzt die größe der Leiste"
L["Don't show this panel, only datatexts assigned to it."] = "Diese Leiste nicht anzeigen, ausser wenn ein Infotext zugewiesen ist"
L["Override Chat DT Panels"] = "Chat Infotextleisten überschreiben"
L["This will have S&L handle chat datatext panels and place them below the left & right chat panels.\n\n|cffFF0000Note:|r When you first enabled, you may need to move the chat panels up to see your datatext panels."] = "Dieses erlaubt das S&L die Chatinfotexte bearbeitet und sie unter dem rechten und linken Chatfenster positioniert.\n\n|cffFF0000Hinweis:|r Bei erstmaliger Aktivierung musst du vielleicht die Chatfenster nach oben bewegen um die Infotexte zu sehen."
L["S&L Datatexts"] = "S&L Infotexte"
L["Datatext Options"] = "Infotext Optionen"
L["LFR Lockout"] = "LFR Instanzzuweisung"
L["Show/Hide LFR lockout info in time datatext's tooltip."] = "Zeigt/Versteckt die LFR Instanzzuweisung im Zeit Infotext Tooltip."
L["ElvUI Improved Currency Options"] = "ElvUI Verbesserte Währungsoptionen"
L["Show Archaeology Fragments"] = "Zeige Archäologie Fragmente"
L["Show Jewelcrafting Tokens"] = "Zeige Juwelenschleifen Abzeichen"
L["Show Player vs Player Currency"] = "Zeige Spieler gegen Spieler Währung"
L["Show Dungeon and Raid Currency"] = "Zeige Instanz und Schlachtzugs Währung"
L["Show Cooking Awards"] = "Zeige Koch Abzeichen"
L["Show Miscellaneous Currency"] = "Zeige Verschiedene Währungen"
L["Show Zero Currency"] = "Zeige Null Währung"
L["Show Icons"] = "Zeige Symbol"
L["Show Faction Totals"] = "Zeige Fraktionen Total"
L["Show Unused Currencies"] = "Zeige ungenutzte Währung"
L["These options are for modifying the Shadow & Light Friends datatext."] = "Diese Optionen sind zum bearbeiten des Shadow & Light Freundes-Infotexts."
L["Hide In Combat"] = "Im Kampf verstecken"
L["Will not show the tooltip while in combat."] = "Währung du dich im Kampf befindest, wird der Tooltip nicht angezeigt."
L["Hide Friends"] = "Freunde verstecken"
L["Hide Title"] = "Überschrift verstecken"
L["Minimize the Friend Datatext."] = "Den Freundes-Infotext minimieren."
L["Show Totals"] = "Zeige Total"
L["Show total friends in the datatext."] = "Zeigt die Gesamtanzahl der Freunde im Freundesinfotext"
L["Hide Hints"] = "Hinweise verstecken"
L["Hide the hints in the tooltip."] = "Verstecke Hinweise im Tooltip"
L["Expand RealID"] = "RealID erweitern"
L["Display RealID with two lines to view broadcasts."] = "Zeigt die RealID in zwei Zeilen an, um die Statusnachrichten zu sehen."
L["Autohide Delay:"] = "Autoverstecken Verzögerung:"
L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."] = "Ändert die Tooltip"
L["S&L Guild"] = "S&L Gilde"
L["These options are for modifying the Shadow & Light Guild datatext."] = "Diese Optionen sind zum Verändern des Shadow & Light Gilden-Infotext"
L["Show total guild members in the datatext."] = "Zeige die Gesamtzahl der Gildenmitglieder im Infotext."
L["Hide MOTD"] = "Verstecke GNDT"
L["Hide the guild's Message of the Day in the tooltip."] = "Versteckt die Gildennachricht des Tages im Tooltip."
L["Hide Guild"] = "Gilde verstecken"
L["Minimize the Guild Datatext."] = "Minimiert den Gilden-Infotext."
L["Hide the Shadow & Light title in the tooltip."] = true
L["Hide the guild's name in the tooltip."] = "Versteckt den Gildennamen im Tooltip."
L["S&L Mail"] = "S&L Post"
L["These options are for modifying the Shadow & Light Mail datatext."] = "Diese Optionen sind zum Verändern des Shadow & Light Post-Infotext."
L["Minimap icon"] = "Minikarten Symbol"
L["If enabled will show new mail icon on minimap."] = "Wenn aktiviert, wird das Postsymbol an der Minikarte angezeigt."
L["Options below are for standard ElvUI's durability datatext."] = "Folgende Optionen sinnd für den Standard ElvUI Haltbarkeits-Infotext."
L["If enabled will color durability text based on it's value."] = "Wenn aktiviert, wer der Haltbarkeitstext nach dem Wert gefärbt."
L["Durability Threshold"] = "Haltbarkeitsschwelle"
L["Datatext will flash if durability shown will be equal or lower that this value. Set to -1 to disable"] = "Der Infotext wird blinken wenn der Wert kleiner oder auf den eingegebenen Wert zutrifft. Auf -1 setzen um zu deaktivieren."
L["Short text"] = "Kurzer Text"
L["Changes the text string to a shorter variant."] = "Ändert den Wert zu einer kürzeren Variante."
L["Delete character info"] = "Charakterinfo löschen"
L["Remove selected character from the stored gold values"] = "Ausgewählten Charakter Golddaten löschen"
L["Are you sure you want to remove |cff1784d1%s|r from currency datatexts?"] = "Bist du dir sicher dass du |cff1784d1%s|r vom Goldinfotext entfernen möchtest?"
L["Hide panel background"] = "Versteckt Leistenhintergrund"
L["SLE_DT_CURRENCY_WARNING_GOLD"] = [[Deine Infoleiste %s hat ElvUI's |cff3cbf27"Goldinfotext"|r aktiv während |cff3cbf27"S&L Währüngs-Infotext"|r irgendwo anders ausgewählt ist. Um sicher zu gehen das "S&L Währüngs-Infotext" ordentlich funktioniert, werden einige Funktionen vom "Gold" Infotext deaktiviert. Um den Konflikt zu umgehen, solltest du einen betroffenen Infotext ersetzen.]]
L["Gold Sorting"] = "Gold Sortierung"
L["Normal"] = true
L["Reversed"] = "Umgekehrt"
L["Amount"] = "Anzahl"
L["Order of each toon. Smaller numbers will go first"] = "Anordnung von jedem Twink. Kleiner Zahlen werden zu erst angezeigt."
L["Tracked"] = "Verfolgt"
L["Gold Throttle"] = true
L["Mode"] = true
L["Amount of gold needed on a character to show it in the list"] = true
L["Public Note Text Color"] = true
L["Officer Note Text Color"] = true

--Enhanced Shadows
L["Enhanced Shadows"] = "Erweiterte Schatten"
L["Use shadows on..."] = "Benutze Schatten auf..."
L["SLE_EnhShadows_BarButtons_Option"] = "Leiste %s Tasten"
L["SLE_EnhShadows_MicroButtons_Option"] = "Microbar Tasten"
L["SLE_EnhShadows_StanceButtons_Option"] = "Haltungsleistentasten"
L["SLE_EnhShadows_PetButtons_Option"] = "Begleitertasten"

--Equip Manager
L["Equipment Manager"] = "Ausrüstungsmanager"
L["EM_DESC"] = "Dieses Modul erlaubt dir verschiedene Einstellungen um automatisch dein Ausrüstungsset in verschiedenen Situationen zu benutzen. Alle Einstellungen sind Charakter basierend."
L["Equipment Set Overlay"] = "Ausrüstungsset Überblendung"
L["Show the associated equipment sets for the items in your bags (or bank)."] = "Zeigt die zugehörigen Ausrüstungssets für die Gegenstände in deiner Tasche (oder Bank)."
L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."] = "Unmöglich um zum dazugehörigen Ausrüstungsset zu wechseln im Kampf. Nach dem Kampf wird gewechselt."
L["SLE_EM_LOCK_TITLE"] = "|cff9482c9S&L|r"
L["SLE_EM_LOCK_TOOLTIP"] = [[Dieser Knopf ist zum vorübergehenden deaktiveren des
Ausrüstungsmanager automatischen wechseln.
Während gesperrt, (red colored state) wird das automatische Wechseln deaktiviert.]]
L["Block button"] = "Sperrtaste"
L["Create a button in character frame to allow temp blocking of auto set swap."] = "Erzeugt einen Knopf im Charakterfenster der erlaubt das Autowechseln vom Ausrüstungsset zu deaktivieren."
L["Ignore zone change"] = "Ignoriere Zonenwechsel"
L["Swap sets only on specialization change ignoring location change when. Does not influence entering/leaving instances and bg/arena."] = "Wechselt Ausrüstungssets nur wenn die Spezialisierung geändert wird. Beeinflusst nicht das betreten/verlassen von Instanzen und Schlachtfeld/Arena."
L["Equipment conditions"] = true
L["SLE_EM_SET_NOT_EXIST"] = "Equipment set |cff9482c9%s|r doesn't exist!"
L["SLE_EM_TAG_INVALID"] = "Invalid tag: %s"
L["SLE_EM_TAG_INVALID_TALENT_TIER"] = "Invalid argument for talent tag. Tier is |cff9482c9%s|r, should be from 1 to 7."
L["SLE_EM_TAG_INVALID_TALENT_COLUMN"] = "Invalid argument for talent tag. Column is |cff9482c9%s|r, should be from 1 to 3."
L["SLE_EM_TAG_DOT_WARNING"] = "Wrong separator for conditions detected. You need to use commas instead of dots."
L["SLE_EM_CONDITIONS_DESC"] = [[Determines conditions under which specified sets are equipped.
This works as macros and controlled by a set of tags as seen below.]]
L["SLE_EM_TAGS_HELP"] = [[Following tags and parameters are eligible for setting equip condition:
|cff3cbf27solo|r - when you are solo without any group;
|cff3cbf27party|r - when you are in a group of any description. Can be of specified size, e.g. [party:4] - if in a group of total size 4;
|cff3cbf27raid|r - when you are in a raid group. Can be of specified size like party option;
|cff3cbf27spec|r - specified spec. Usage [spec:<number>] number is the index of desired spec as seen in spec tab;
|cff3cbf27talent|r - specified talent. Usage [talent:<tier>/<column>] tier is the row going from 1 on lvl 15 to 7 and lvl 100, column is the column in said row from 1 to 3;
|cff3cbf27instance|r - if in instance. Can be of specified instance type - [instance:<type>]. Types are party, raid and scenario. If not specified will be true for any instance;
|cff3cbf27pvp|r - if on BG, arena or world pvp area. Available arguments: pvp, arena;
|cff3cbf27difficulty|r - defines the difficulty of the instance. Arguments are: normal, heroic, lfr, challenge, mythic;
|cff3cbf27effectivelevel|r - effective level refers to your level when you are scaled, e.g. timewalking

Example: [solo] Set1; [party:4, spec:3] Set2; [instance:raid, difficulty:heroic] Set3
]]

--Loot
L["Loot Dropped:"] = "Beute:"
L["Loot Auto Roll"] = "Aus Beute automatisch würfeln"
L["LOOT_AUTO_DESC"] = "Wählt automatisch eine angemessenen Wurf auf gefallene Beute."
L["Auto Confirm"] = "Automatische Bestätigung"
L["Automatically click OK on BOP items"] = "Klickt automatisch OK auf BOP Gegenstände"
L["Auto Greed"] = "Auto Gier"
L["Automatically greed uncommon (green) quality items at max level"] = "Wählt automatisch Gier auf ungewöhnliche (grüne) Gegenstände auf maximalem Level."
L["Auto Disenchant"] = "Automatisches entzaubern"
L["Automatically disenchant uncommon (green) quality items at max level"] = "Entzaubert automatisch ungewöhnliche (grüne) Gegenstände auf maximalem Level."
L["Loot Quality"] = "Beutequalität"
L["Sets the auto greed/disenchant quality\n\nUncommon: Rolls on Uncommon only\nRare: Rolls on Rares & Uncommon"] = "Setzt die Auto Gier/Entzaubern auf die Qualität\n\nUngewöhnlich: Rollt nur auf ungewöhnliche Gegenstände\nRare: Rollt auf rare & ungewöhnliche Gegenstände"
L["Roll based on level."] = "Wurf basierend auf Level."
L["This will auto-roll if you are above the given level if: You cannot equip the item being rolled on, or the iLevel of your equipped item is higher than the item being rolled on or you have an heirloom equipped in that slot"] = "Dieses wird automatisch auf Gegenstände würfeln über dem eingestelltem Level wenn: Du den Gegenstand nicht benutzen kannst oder das Itemlevel von deinem ausgerüstetem Gegenstand höher ist oder du ein Account Gegenstand auf dem Slot trägst."
L["Level to start auto-rolling from"] = "Level auf dem das Autowürfeln startet"
L["Loot Announcer"] = "Beute Ankündigung"
-- L["AUTOANNOUNCE_DESC"] = "When enabled, will automatically announce the loot when the loot window opens.\n\n|cffFF0000Note:|r Raid Lead, Assist, & Master Looter Only."
L["Auto Announce"] = "Automatische Ankündigung"
L["Manual Override"] = "Manuelle Überschreibung"
L["Sets the button for manual override."] = "Setzt die Taste für die manuelle Überschreibung."
L["No Override"] = "Keine Überschreibung"
L["Automatic Override"] = "Automatische Überschreibung"
L["Sets the minimum loot threshold to announce."] = "Setzt die mindest Schwelle um Beute anzukündigen."
L["Select chat channel to announce loot to."] = "Wählt den Kanal aus wo der Loot angekündigt wird."
L["Loot Roll History"] = "Würfelverlauf"
L["LOOTH_DESC"] = "Dieses sind Einstellungen um das Würfelverlauf Fenster zu bearbeiten."
L["Auto hide"] = "Automatisches Verstecken"
L["Automatically hides Loot Roll History frame when leaving the instance."] = "Versteckt automatisch das Würfelverlaufs Fenster wenn du eine Instanz verlässt."
L["Sets the alpha of Loot Roll History frame."] = "Setzt den alpha vom Würfelverlaufs Fenster"
L["Channels"] = "Kanäle"
L["Private channels"] = "Private Kanäle"
L["Incoming"] = "Eingehend"
L["Outgoing"] = "Ausgehend"

--Media
L["SLE_MEDIA_ZONES"] = {
	"Washington",
	"Moscow",
	"Moon Base",
	"Goblin Spa Resort",
	"Illuminati Headquarters",
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
L["Banner Big Text"] = true
L["Objective Tracker Header Text"] = true
L["Objective Tracker Text"] = true

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
L["Skin garrison"] = true
L["Skin garrison landing page button."] = true
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
L["Hide In Class Hall"] = true
L["Full Location"] = true
L["Color Type"] = true
L["Custom Color"] = true
L["Reaction"] = true
L["Location"] = true
L["Coordinates"] = "Koordinaten"
L["Teleports"] = true
L["Portals"] = true
L["Link Position"] = true
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = true
L["Relocation Menu"] = true
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = true
L["Custom Width"] = true
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = true
L["Justify Text"] = true
L["Hearthstone Location"] = "Ruhestein Position"
L["Show the name on location your Heathstone is bound to."] = true
L["Only Number"] = true
L["Horizontal Growth"] = true
L["Vertical Growth"] = true
L["Info for some items is not available yet. Please try again later"] = "Informationen für einige Gegenstände sind zur Zeit nicht verfügbar. Bitte später nocheinmal versuchen"
L["Update canceled."] = "Update abgebrochen."
L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."] = "Gegenstandsinformation ist nicht verfügbar. Dieses kann ein bisschen dauern um die Informationen zu sammeln. Das Menu wird automatisch geöffnet, wenn alle Informationen gesammelt sind. Nochmaliges aufrufen des Menus während des Updates, wird den Vorgang abbrechen."
L["Update complete. Opening menu."] = "Update komplett. Menu wird geöffnet."
L["Show hearthstones"] = true
L["Show hearthstone type items in the list."] = true
L["Show Toys"] = true
L["Show toys in the list. This option will affect all other display options as well."] = true
L["Show spells"] = true
L["Show relocation spells in the list."] = true
L["Show engineer gadgets"] = true
L["Show items used only by engineers when the profession is learned."] = true
L["Ignore missing info"] = true
L["SLE_LOCPANEL_IGNOREMISSINGINFO"] = [[Due to how client functions some item info may become unavailable for a period of time. This mostly happens to toys info.
When called the menu will wait for all information being available before showing up. This may resul in menu opening after some concidarable amount of time, depends on how fast the server will answer info requests.
By enabling this option you'll make the menu ignore items with missing info, resulting in them not showing up in the list.]]
L["HS Toys Order"] = true

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
L["Display the number of party / raid members targeting the nameplate unit."] = true
L["Threat Text"] = true
L["Display threat level as text on targeted, boss or mouseover nameplate."] = true

--Professions
L["Deconstruct Mode"] = true
L["Create a button in your bag frame to switch to deconstruction mode allowing you to easily disenchant/mill/prospect and pick locks."] = true
L["Actionbar Proc"] = true
L["Actionbar Autocast"] = true
L["Show glow on bag button"] = true
L["Show glow on the deconstruction button in bag when deconstruction mode is enabled.\nApplies on next mode toggle."] = true
L["Scroll"] = "Rolle"
L["Missing scroll item for spellID %d. Please report this at the Shadow&Light Ticket Tracker."] = "Fehlende Rollen Item für ZauberID %d. Bitte berichte es auf den Shadow&Light Ticket Tracker."
L["Sets style of glow around item available for deconstruction while in deconstruct mode. Autocast is less intense but also less noticeable."] = true
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
L["SLE_Prof_Relure_Error"] = "Can't use lure due to threshlod. Time left: %.1f seconds."
L["Re-lure Threshold"] = true
L["Time after the previous attemp to apply a lure before the next attempt will occure."] = true

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
L["Play sound when killing blows popup is shown."] = true

--Quests
L["Rested"] = true
L["Auto Reward"] = true
L["Automatically selects a reward with highest selling price when quest is completed. Does not really finish the quest."] = true
L["Quest Log Toggle"] = true

--Raid Marks
L["Raid Markers"] = "Schlachtzugs-Markierungen"
L["Click to clear the mark."] = "Klicken um die Marker zu löschen."
L["Click to mark the target."] = "Klicken um ein Ziel zu markieren."
L["%sClick to remove all worldmarkers."] = "%sKlicken um alle Weltmarkierungen zu entfernen."
L["%sClick to place a worldmarker."] = "%sKlicken um ein Weltmarker zu setzen."
L["Raid Marker Bar"] = "Schlachtzugs-Markierungs-Leiste"
L["Options for panels providing fast access to raid markers and flares."] = "Option für eine Schlachtzugs-Markierungs-Leiste um schnelleren Zugriff auf Schlachtzugsmarkierung und Weltmarker zu bekommen."
L["Show/Hide raid marks."] = "Zeige/Verstecke Schlachtzugsmarkierung"
L["Reverse"] = "Umkehren"
L["Modifier Key"] = "Modifier Taste"
L["Set the modifier key for placing world markers."] = "Setzt eine modifierungs Taste um eine Weltmarkierung zu setzen."
L["Visibility State"] = "Sichtbarkeit"
L["No tooltips"] = true

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
L["Hide the talking head frame at the top center of the screen."] = true

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
L["S&L: Farm Seed Bars"] = true
L["S&L: Farm Tool Bar"] = true
L["S&L: Farm Portal Bar"] = true
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
L["S&L: Garrison Tools Bar"] = true
L["Toolbar"] = true
--Class Hall
L["Class Hall"] = true
L["Auto Work Orders for equipment"] = true

--Tooltip
L["Always Compare Items"] = true
L["Faction Icon"] = true
L["Show faction icon to the left of player's name on tooltip."] = true
L["RAID_TOS"] = "ToS"
L["RAID_NH"] = "NH"
L["RAID_TOV"] = "ToV"
L["RAID_EN"] = "EN"
L["RAID_ANTO"] = "Antorus"
L["RAID_DAZALOR"] = "BfDA"
L["RAID_STORMCRUS"] = "SC"
L["RAID_ETERNALPALACE"] = "EP"
L["Raid Progression"] = true
L["Show raid experience of character in tooltip (requires holding shift)."] = true
L["Name Style"] = true
L["Difficulty Style"] = true
L["Short"] = true

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
L["Dead Indicator"] = true
L["Shows an icon on party or raid unitframes for people that are offline."] = true
L["Statusbars"] = true
L["Power Texture"] = true
L["Castbar Texture"] = true
L["Red Icon"] = true
L["Aura Bars Texture"] = true
L["Makes frame portrait visible regardless of health level when overlay portrait is set."] = true
L["Classbar Texture"] = true
L["Resize Health Prediction"] = true
L["Slightly changes size of health prediction bars."] = true
L["Always Compare Items"] = true

--Unitframes, tags
L["SLE_Tag_sl-pvptimer"] = "Slightly altered version of \"pvptimer\" tag. Features no \"PvP\" string in front of the timer."
L["SLE_Tag_sl-pvplevel"] = "Shows unit's honor level."
L["SLE_Tag_absorb-sl-short"] = "Slightly altered version of \"absorbs\" tag. Show 0 when no absorbs present. Value is shortened."
L["SLE_Tag_absorb-sl-full"] = "Slightly altered version of \"absorbs\" tag. Show 0 when no absorbs present. Absolute value."
-- L["SLE_Tag_health-current-rehok"] = true
L["SLE_Tag_range-sl"] = "Shows approximate range between you and the unit."

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
L["SLE_DESC"] = [=[|cff9482c9Shadow & Light|r is an extension of ElvUI. It adds:
- a lot of new features
- more customization options for existing ones

|cff3cbf27Note:|r It is compatible with most of addons and ElvUI plugins available. But some functions may be unavailable to avoid possible conflicts.]=]
L["Links"] = true
L["LINK_DESC"] = [[Following links will direct you to the Shadow & Light's pages on various sites.]]
L["Donate"] = true

--FAQ--
L["FAQ_DESC"] = "This section contains some questions about ElvUI and Shadow & Light."
L["FAQ_Elv_1"] = [[|cff30ee30Q: Where can I get ElvUI support?|r
|cff9482c9A:|r The best way would be the official forum - https://www.tukui.org/forum/
To report a bug, you can use the issue tracker located at https://git.tukui.org/elvui/elvui/issues]]
L["FAQ_Elv_2"] = [[|cff30ee30Q: Do I need to have good English in order to do so?|r
|cff9482c9A:|r English is the official language of the tukui.org forums, so most posts there are in English.
This doesn't mean it's the only language used there though. You will be able to find posts in Spanish, French, German, Russian, Italian, etc.
As long as you can follow some simple rules of common sense, like stating said language in the topic's title, everyone will be ok with you posting in your native language.
Keep in mind that you may still get an answer in English as the person answering you may not be able to speak your language.]]
L["FAQ_Elv_3"] = [[|cff30ee30Q: What information do I need to provide report a bug?|r
|cff9482c9A:|r First you need to ensure the error really comes from ElvUI.
To do so you need to disable all other addons except of ElvUI and ElvUI_OptionsUI.
You can do this by typing "/luaerror on" (without quotes).
If error didn't disappear, then you should send us a bug report.
In the report, you'll need to provide the ElvUI version ("latest" is not a valid version number), the text of the error, screenshot is possible.
The more info you give us on how to reproduce the error, the faster it is to possibly get it fixed.]]
L["FAQ_Elv_4"] = [[|cff30ee30Q: Why are some options not applied on other characters while using the same profile?|r
|cff9482c9A:|r ElvUI has three kinds of options.  First (profile) is stored in your profile, second (private) is stored on a character basis, third (global) are applied across all character regardless of profile used.
In this case you most likely came across the option of type two which is private and those options are based per character.]]
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
L["FAQ_sle_1"] = [[|cff30ee30Q: What do I do if I encounter an error is Shadow & Light?|r
|cff9482c9A:|r Pretty much the same as for ElvUI (see it's FAQ section) but you'll have to provide S&L version too.]]
L["FAQ_sle_2"] = [[|cff30ee30Q: Does Shadow & Light have the same language policy as ElvUI?|r
|cff9482c9A:|r Yes but S&L actually has two official languages - English and Russian.]]
L["FAQ_sle_3"] = [[|cff30ee30Q: Why are the layout's screenshots on download page different from what I see in the game?|r
|cff9482c9A:|r Because we just forgot to update those.]]
L["FAQ_sle_4"] = [[|cff30ee30Q: Why do I see some weird icons near some people's names in chat?|r
|cff9482c9A:|r Those icons are provided by S&L and are associated with people we'd like to highlight in any way.
For example: |TInterface\AddOns\ElvUI_SLE\media\textures\SLE_Chat_Logo:12:28|t is the main icon for development team of Shadow & Light, and |TInterface\AddOns\ElvUI_SLE\media\textures\SLE_Chat_Logo_Alt:14:14|t is another one that Repooc likes to use. |TInterface\AddOns\ElvUI_SLE\media\textures\Chat_Test:16:16|t is awarded to those who help find bugs.]]
L["FAQ_sle_5"] = [[|cff30ee30Q: How can I get in touch with you guys?|r
|cff9482c9A:|r For obvious reasons, we are not giving out our contact details freely. So your best bet is using tukui.org forums or even in our Discord. ]]

--Credits--
L["ELVUI_SLE_CREDITS"] = "We would like to point out the following people for helping us create this addon with testing, coding, and other stuff."
L["Submodules and Coding:"] = true
L["Other Support:"] = true
L["ELVUI_SLE_DONORS_TITLE"] = "Thanks to these awesome people for supporting our work via donations:"
L["ELVUI_SLE_PATREON_TITLE"] = "Many thanks to our awesome patrons, who provided financial support for the development of this addon:"
L["Patrons"] = true
L["Donors"] = true

L["SLE_BENIK_AF"] = [[Wegen zu viel Real Life Streß, hat das |cff9482c9Shadow & Light|r Team Urlaub genommen.

Während unserer Abwesenheit ist |cfffe7b2cBenik|r so nett und unsere Arbeit und des Support für |cff9482c9S&L|r!
Wenn irgendwelche Fehler bemerkst mit |cff9482c9S&L|r, poste sie bitte auf tukui.org in der BenikUI Sektion.
Und bedenke: Wenn irgendetwas nicht funktioniert, ist es Benik's Schuld! Benutze das Hashtag |cfffe7b2c#IBlameBenik|r wenn du Fehler postest!]]
L["SLE_ERRORS_AF"] = {
	"Ausversehen hat Merathilis zu viel getrunken und es hinbekommen zu viel Moonfire auf unsere Stromleitung zu spammen! Du musst das sofort beheben!",
	"Wir sind froh zu Berichten dass unsere #IBlameBenik Kampagne jede Minute erfolgreicher wird! Vergess bitte auch du nicht Benik zu flamen!",
	"WARNUNG! Darth hat einen nuklear Code gestohlen und verlangt jetzt 500 Millionen Gold und ein paar draeneische Jungfrauen. Versteckt euch im nähesten Bunker um Fallout IRL zu spielen!",
	"Irgendetwas stimmt mit deinem Interface nicht. Bitte warten, wir versuchen es zu reparieren! Wir übernehmen keine Verantwortung wenn die Dinge schlimmer werden.",
	"Der Imperiale Rat hat merkwürdiges Zeugs auf deinem PC gefunden! So dass dein Haus und der Planet Exterminatus überhändigt wird, im Namen des Imperators!",
	"BÄREN! Was zum Teufel suchen Bären in deiner UI?!",
	"Benik hat die Lokaliserung etwas verändert. Wir hoffen dass ihr Türkisch könnt!",
	"Der Eisberg ist geschmolzen! Unsere Server sind überflutet, tschuldigung für die Unannehmlichkeiten",
	"IHR WISST NICHT WAS EUCH ERWARTET!!!",
	"ElvUI hat eine ungewöhnliche hohe Anzahl von Rückmeldungen von den Servern bekommen und wird in kürze beendet. Bitte kontaktiere den nähesten Goblin Ingenieur um weiter Infos zu erhalten.",
	"Du nicht nehmen Kerze! Oder wir werden es Benik sagen!",
	"1 Fehler, 1 Gebet, bitte spendet für besoffene Coder.",
}
