-- German localisation file for deDE
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "deDE")
if not L then return end

--General--
L["Shadow & Light Edit"] = "Schatten & Licht Edit"
L["Shadow & Light Edit of ElvUI"] = "Schatten & Licht Edit von ElvUI"
L["SLE_DESC"] = [=[Das ist ein Edit von ElvUI das einige Funktionen zum Original Addon hinzufügt und bereits existierende Optionen ändert.
Der Edit ändert in keiner Hinsicht Originale Dateien so das du es ohne Probleme aus deinem Addon Manager deaktivieren kannst.]=]
L["LFR Lockdown"] = "LFR Abklingzeiten"
L["Show/Hide LFR lockdown info in time datatext's tooltip."] = "Zeige/Verstecke die LFR Abklingzeiten Info im Zeit Infotext Tooltip."
L["PvP Auto Release"] = "PvP Auto Freilassen"
L["Automatically release body when killed inside a battleground."] = "Geist automatisch freilassen wenn man innerhalb eines Schlachtfeldes stirbt."
L["Pet autocast corners"] = "Begleiter autozauber Ecken"
L["Show/hide triangles in corners of autocastable buttons."] = "Zeige/Verstecke dreiecke in den Ecken der automatisch zaubernden Tasten."
L["SLE_LOGIN_MSG"] = [=[Du benutzt |cff1784d1Schatten & Licht Edit|r v|cff1784d1%s%s|r für ElvUI.
Möchtest du das Original ElvUI Addon benutzen, deaktiviere das Edit Plugin aus deinem Addon Manager.
Habt einen schönen Tag.]=]
L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."] = "Deine Version von Elvui ist älter als die empfohlene zum benutzen mit Schatten & Licht Edit. Bitte, downloade die letzte Version von tukui.org."
L["Reset All"] = true
L["Reset all Shadow & Light options and movers to their defaults"] = true
L["Reset these options to defaults"] = true

--Install--
L["Shadow & Light Settings"] = "Schatten & Licht Einstellungen"
L["You can now choose if you what to use one of authors' set of options. This will change not only the positioning of some elements but also change a bunch of other options."] = "Du kannst nun eine Einstellugen eines Authors wählen. Das wird nicht nur die Postitionierung von einigen Elementen sondern auch eine reihe anderer Optionen geändert."
L["SLE_Install_Text2"] = [=[Elv's Standart Taste muss nur angeklickt werden um eine unserer Konfigurationen rückgängig zu machen.
|cffFF0000Warnung:|r das wird alles zurücksetzen auf das Hohe Auflösungs Layout.]=]
L["Darth's Config"] = "Darth's Einstellungen"
L["Darth's Defaults Set"] = "Darth's Standarts gesetzt"
L["Elv's Defaults"] = "Elv's Standarts"
L["Elv's Defaults Set"] = "Elv's Standarts gesetzt"
L["Repooc's Config"] = "Repooc's Einstellungen"
L["Repooc's Defaults Set"] = "Repooc's Standarts gesetzt"

--Auras--
L["Auras Options"] = "Auren Optionen"
L["Additional Auras Options"] = "Zusätzliche Auren Optionen"
L["Options for customizing auras near the minimap."] = "Optionen für anpassungen der Auren nahe der Minimap."
L["Caster Name"] = "Zauber Name"
L["Enabling this will show caster name in the buffs and debuff icons."] = "Bei aktivierung wird der Name des zaubernden in den Stärkungs und Schwächungs Symbolen angezeigt."

--Backgroungds--
L["Backgrounds"] = "Hintergründe"
L["Additional Background Panels"] = "Zusätzliche Hintergrund Leisten"
L["BG_DESC"] = "BG_DESC"
L["Bottom BG"] = "Unten BG"
L["Left BG"] = "Linker BG"
L["Right BG"] = "Rechter BG"
L["Actionbar BG"] = "Aktionsleisten BG"
L["Show/Hide this frame."] = "Zeige/Verstecke dieses Fenster."
L["Sets width of the frame"] = "Wähle die breite dieses Fensters"
L["Sets height of the frame"] = "Wähle die höhe dieses Fensters"
L["Sets X offset of the frame"] = "Wähle den X Versatz für dieses Fenster"
L["Sets Y offset of the frame"] = "Wähle den Y Versatz für dieses Fenster"
L["Texture"] = "Textur"
L["Set the texture to use in this frame.  Requirements are the same as the chat textures."] = "Wähle die Textur die für dieses Fenster benutzt wird. Empfohlen wird die selbe wie die Chat Textur."
L["Backdrop Template"] = "Hintergrund Template"
L["Change the template used for this backdrop."] = "Wähle das Template das für den Hintergrund benutzt wird."
L["Default"] = "Standart"
L["Transparent"] = "Transparent"

--Chat--
L["Chat Options"] = "Chat Optionen"
L["Chat Editbox History"] = "Chat Editbox History"
L["Amount of messages to save. Set to 0 to disable."] = "Anzahl der Nachrichten die gespeichert werden. Wähle 0 zum deaktivieren."

--Datatexts--
L["LFR Dragon Soul"] = "LFR Drachenseele"
L["LFR Mogu'shan Vaults"] = true
L["LFR Heart of Fear"] = true
L["LFR Terrace of Endless Spring"] = true
L["Bosses killed: "] = true
L["SLE_AUTHOR_INFO"] = "Schatten & Licht Edit von Darth Predator & Repooc"
L["SLE_CONTACTS"] = [=[Bug berichte, Vorschläge und andere Sachen akzeptiert via:
- Privat Nachricht auf TukUI.org zu Darth Predator oder Repooc
- AddOn's Seite/ticket system auf curse.com
- AddOn's repo github.com]=]
L["DP_1"] = "Infotext Leiste 1"
L["DP_2"] = "Infotext Leiste 2"
L["DP_3"] = "Infotext Leiste 3"
L["DP_4"] = "Infotext Leiste 4"
L["DP_5"] = "Infotext Leiste 5"
L["DP_6"] = "Infotext Leiste 6"
L["Bottom_Panel"] = "Untere Leiste"
L["Top_Center"] = "Obere Leise"
L["Left Chat"] = "Linker Chat"
L["Right Chat"] = "Rechter Chat"
L["Datatext Panels"] = "Infotext Leisten"
L["Additional Datatext Panels"] = "Zusätzliche Infotext Leisten"
L["DP_DESC"] = [=[Zusätzliche Infotext Leisten.
8 Leisten mit 20 Infotext Punkten ingesamt und ein dashboard mit 4 Status Leisten.
You can't disable chat panels.]=]
L["Dashboard"] = "Dashboard"
L["Show/Hide dashboard."] = "Zeige/Verstecke dashboard."
L["Dashboard Panels Width"] = "Dashboard Leisten Breite"
L["Sets size of dashboard panels."] = "Wähle die Größe der dashboard Leisten."
L["Show/Hide this panel."] = "Zeige/Verstecke diese Leiste."
L["Sets size of this panel"] = "Wähle die Größe dieser Leiste"
L['Hide panel background'] = true
L["Don't show this panel, only datatexts assinged to it"] = true

--Exp/Rep Bar--
L["Xp-Rep Text"] = "Xp-Rruf Text"
L["Additional options for XP/Rep bars text"] = "Zusätzliche Optionen für XP/Ruf Leisten Text"
L["Full value on Exp Bar"] = "Voller Wert auf Exp Leiste"
L["Changes the way text is shown on exp bar."] = "Ändert die Art der Anzeige für die Exp Leiste."
L["Full value on Rep Bar"] = "Voller Wert auf Ruf Leiste"
L["Changes the way text is shown on rep bar."] = "Ändert die Art der Anzeige für die Ruf Leiste."

--Marks--
L["Raid Marks"] = "Schlachtzugs Markierungen"
L["Show/Hide raid marks."] = "Zeige/Verstecke Schlachtzugs Markierungen"
L["Sets size of buttons"] = "Wähle die größe der Tasten" --Also used in UI buttons
L["Direction"] = "Richtung"
L["Change the direction of buttons growth from the skull marker"] = "Wähle die Richtung des Tasten wachstums von der Totenkopf Markierung"

--Skins--
L["This options require ElvUI AddOnSkins pack to work."] = "Diese Option benötigt ElvUI AddOnSkins Packet zum funktionieren."
L["Sets font size on DBM bars"] = "Wähle die Schriftgröße der DBM Leisten"

--UI buttons--
L["UI Buttons"] = "UI tasten"
L["Additional menu with useful buttons"] = "Zusätzliches Menü mit nützlichen Tasten"
L["Show/Hide UI buttons."] = "Zeige/Verstecke die UI Tasten."
L["Mouse over"] = "Mouse over"
L["Show on mouse over."] = "Zeige auf mouse over."
L["Buttons position"] = "Tasten Position"
L["Layout for UI buttons."] = "Layout für die UI tasten."
L["Click to reload your interface"] = "Klicken zum neuladen deines Interface"
L["Click to toggle config window"] = "Klicken zum umschalten des Konfigurations Fensters"
L["Click to toggle the AddOn Manager frame (stAddOnManager, Ampere or ACP) you have enabled."] = "Klick zum umschalten des AddOn Manager Fensters (stAddOnManager, Ampere oder ACP) wenn du es aktiviert hast."
L["Click to toggle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."] = "Klicke zum umschalten des Konfigurations/Options Fenster von dem Bossmodul (DXE, DBM oder Bigwigs) wenn du es aktiviert hast."
L["Click to unlock moving ElvUI elements"] = "Klicke um die ElvUI Elemente zu bewegen"
L["ElvUI Config"] = "ElvUI Konfiguration"
L["Move UI"] = "Bewege UI"
L["Reload UI"] = "UI neuladen"
L["AddOns Manager"] = "AddOns Manager"
L["Boss Mod"] = "Boss Modul"

--Unitframes--
L["Additional unit frames options"] = "Zusätzliche Einheitenfenster Optionen"
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = "Optionen für anpassung der Einheitenfenster. Bitte ändere diese Einstellungen nicht wenn ElvUI's Test Fenster für Bosse und Arena Fenster angezeigt werden. Das macht sie unsichtbar bis zum wieder umschalten."
L["Player Frame Indicators"] = "Spieler Fenster Indikator"
L["Combat Icon"] = "Kampf Symbol"
L["Show/Hide combat icon on player frame."] = "Zeige/Verstecke das Kampf Symbol auf dem Spieler Fenster."
L["Combat Position"] = "Kampf Position"
L["Set the point to show combat icon"] = "Wähle den Punkt zum anzeigen des Kampf Symboles"
L["Classbar Energy"] = "Klassenleisten Energie"
L["Show/hide the text with exact number of energy (Solar/Lunar or Demonic Fury) on your Classbar."] = "Zeige/Verstecke den Text mit exakten Nummern der Energie (Solar/Lunar oder Demonischer Furor) auf deiner Klassenleiste."
L["Classbar Offset"] = "Klassenleisten Versatz"
L["This options will allow you to detach your classbar from player's frame and move it in other location."] = "Diese Option wird deine Klassenleiste von dem Spieler Fenster abheften und bewege diese zu einer anderen Lage."

--Credits--
L["ELVUI_SLE_CREDITS"] = "Wir möchten an diesem Punkt folgenden Personen für ihre Unterstützung danken für Prüfung, Programmierung und anderen Sachen."
L["Submodules and Coding:"] = "Submodule und Programmierung:"
L["ELVUI_SLE_CODERS"] = [=[Elv
Tukz
Azilroka
Blazeflack
Boradan
Camealion
Pvtschlag
Sinaris
Sortokk
Swordyy
]=]
L["Other Support:"] = "Anderer Support:"
L["ELVUI_SLE_MISC"] = [=[BuG - für französisch sein lol
TheSamaKutra
Der Rest der TukUI community
]=]

--Tutorials--
L["To enable full values of health/power on unitframes in Shadow & Light add \":sl\" to the end of the health/power tag.\nExample: [health:current:sl]."] = "Zum aktivieren des vollen Wertes von Leben/Kraft auf den Einheitenfestern in Schatten & Licht füge folgendes hinzu \":sl\" an das ende des Leben/Kraft tags.\nBeispiel: [health:current:sl]."

--Movers--
L["Pet Battle AB"] = "Haustierkampf AB"
