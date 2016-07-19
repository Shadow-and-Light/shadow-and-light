-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "enUS", true);

if not L then return; end
--Popups
L["MSG_SLE_ELV_OUTDATED"] = "Your version of ElvUI is older than recommended to use with |cff9482c9Shadow & Light|r. Your version is |cff1784d1%.2f|r (recommended is |cff1784d1%.2f|r). Please update your ElvUI."
L["This will clear your chat history and reload your UI.\nContinue?"] = true
L["This will clear your editbox history and reload your UI.\nContinue?"] = true
L["Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable."] = true
L["You have got Loot Confirm and Shadow & Light both enabled at the same time. Select an addon to disable."] = true
L["You have got OneClickEnchantScroll and Shadow & Light both enabled at the same time. Select an addon to disable."] = true
L["You have got ElvUI Transparent Actionbar Backdrops and Shadow & Light both enabled at the same time. Select an addon to disable."] = true
L["SLE_ADVANCED_POPUP_TEXT"] = [[Do you swear that you are an experienced user,
can read tooltips for options and will not cry for help if you
horribly break your UI by utilizing additional options?

If yes, you'll be allowed to enable this option.
]]

--Install--
L["Moving Frames"] = true
L["Author Presets"] = true
L["|cff9482c9Shadow & Light|r Installation"] = true
L["Welcome to |cff9482c9Shadow & Light|r version %s!"] = true
L["SLE_INSTALL_WELCOME"] = [[This will take you through a quick install process to setup some Shadow & Light features.
If you choose to not setup any options through this config, click Skip Process button to finish the installation.

Note that steps to the right marked with * are optional steps unavailable without selecting something in previous steps.]]
L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."] = true
L["SLE_ARMORY_INSTALL"] = "Enable S&L Armory\n(Detailed Character & Inspect frames)."
L["Shadow & Light Imports"] = true
L["You can now choose if you want to use one of the authors' set of options. This will change the positioning of some elements as well of other various options."] = true
L["SLE_Install_Text_AUTHOR"] = [=[This step is optional and only to be used if you are wanting to use one of our configurations. In some cases settings may differ depending on layout options you chose in ElvUI installation.
Not selecting anything will cause you to skip next step of the installation. 

A |cff1784d1"%s"|r role was chosen.

|cffFF0000Warning:|r Please note that the authors' may or may not use any of the layouts/themes you have selected as they may have changed their setup more recently. Also switching between layouts in here may cause some unpredictable and weird results.]=]
L["Darth's Config"] = true
L["Repooc's Config"] = true
L["Darth's Default Set"] = true
L["Repooc's Default Set"] = true
L["Layout & Settings Import"] = true
L["You have selected to use %s."] = true
L["SLE_INSTALL_LAYOUT_TEXT2"] = [[Following buttons will import layout/addon settings for the selected config and role.
Please not that this configs may include some settings you may not yet being familiar with.

Also it may reset/change some options you set in previous steps.]]
L["|cff1784d1%s|r role was chosen"] = true
L["Author Presets"] = true
L["Moving Frames"] = true
L["Import Profile"] = true
L["AFK Mode"] = true
L["You have selected to use %s and role %s."] = true

--Config replacements
L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."] = true

--Core
L["SLE_LOGIN_MSG"] = "|cff9482c9Shadow & Light|r version |cff1784d1%s%s|r for ElvUI is loaded. Thanks for the usage."
L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."] = true
L["Resets all movers & options for S&L."] = true
L["Reset these options to defaults"] = true
L["Modules designed for older expantions"] = true
L["Game Menu Buttons"] = true
L["Adds |cff9482c9Shadow & Light|r buttons to main game menu."] = true
L["SLE_Advanced_Desc"] = [[Folowing options provide acces to additional customization settings in various modules.
Is not reccomended to new players or people not experienced in addons' configuration.]]
L["Allow Advanced Options"] = true
L["Change Elv's options limits"] = true
L["Allow |cff9482c9Shadow & Light|r to change some of ElvUI's options limits."] = true
L["Cyrillics Support"] = true
L["SLE_CYR_DESC"] = [[If you happen to ocasionaly (or constantly) use Russian alphabet (Cyrillics) for your messages
and always forget to switch input language afterward when entering slash commands then these options will help you.
They enable a set of ElvUI's commands to be usable even with wrong input.
]]
L["Commands"] = true
L["SLE_CYR_COM_DESC"] = [[Allows the usage of these common commands with ru input:
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
L["Dev Commands"] = true
L["SLE_CYR_DEVCOM_DESC"] = [[Allows the usage of these commands with ru input:
- /luaerror
- /frame
- /framelist
- /texlist
- /cpuimpact
- /cpuusage
- /enableblizzard

These are usually used for developing and testing purposes or are extremely rare used by general user.]]

--Config groups
L["S&L: All"] = true
L["S&L: Datatexts"] = true
L["S&L: Backgrounds"] = true
L["S&L: Misc"] = true

--Actionbars
L["OOR as Bind Text"] = true
L["Out Of Range indication will use keybind text instead of the whole icon."] = true
L["Checked Texture"] = true
L["Highlight the button of the spell with areal effect untill the area is selected."] = true
L["Checked Texture Color"] = true
L["Transparent Backdrop"] = true
L["Sets actiobars' backgrounds to transparent template."] = true
L["Transparent Buttons"] = true
L["Sets actiobars buttons' backgrounds to transparent template."] = true

--Armory
L["Average"] = true
L["Not Enchanted"] = true
L["Empty Socket"] = true
L["KF"] = true
L["You can't inspect while dead."] = true
L["Specialization data seems to be crashed. Please inspect again."] = true
L["No Specialization"] = true
L["Character model may differ because it was constructed by the inspect data."] = true
L["Armory Mode"] = true
L["Enchant String"] = true
L["String Replacement"] = true
L["List of Strings"] = true
L["Original String"] = true
L["New String"] = true
L["Character Armory"] = true
L["Show Missing Enchants or Gems"] = true
L["Show Warning Icon"] = true
L["Select Image"] = true
L["Custom Image Path"] = true
L["Gradient"] = true
L["Gradient Texture Color"] = true
L["Upgrade Level"] = true
L["Warning Size"] = true
L["Warning Only As Icons"] = true
L["Only Damaged"] = true
L["Gem Sockets"] = true
L["Socket Size"] = true
L["Inspect Armory"] = true

--AFK
L["You Are Away From Keyboard for"] = true
L["Take care of yourself, Master!"] = true
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
L["Crest Size"] = true
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

--Auras
L["Hide Buff Timer"] = true
L["This hides the time remaining for your buffs."] = true
L["Hide Debuff Timer"] = true
L["This hides the time remaining for your debuffs."] = true

--Backgrounds
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

--Equip Manager
L["Equipment Manager"] = true
L["EM_DESC"] = "This module provides different options to automatically change your equipment sets on spec change or entering certain locations. All options are character based."
L["Equipment Set Overlay"] = true
L["Show the associated equipment sets for the items in your bags (or bank)."] = true
L["Here you can choose what equipment sets to use in different situations."] = true
L["Equip this set when switching to specialization %s."] = true
L["Equip this set for open world/general use."] = true
L["Equip this set after entering dungeons or raids."] = true
L["Equip this set after entering battlegrounds or arens."] = true
L["Use a dedicated set for instances and raids."] = true
L["Use a dedicated set for PvP situations."] = true
L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."] = true

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
L["Update Throttle"] = true
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = true
L["Full Location"] = true
L["Color Type"] = true
L["Reaction"] = true
L["Teleports"] = true
L["Portals"] = true
L["Link Position"] = true
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = true
L["Relocation Menu"] = true
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = true
L["Custom Width"] = true
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = true
L["Justify Text"] = true


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
L['Scroll'] = true

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
L["SLE_SKINS_QUESTKING_DESC"] = [[Following options controls additional features for Quest King addon. Settings are character based.
Due to the way of how that addon works it is mostly impossible to hook into its functions.
Affected options are:
- Tooltip positioning and scale
- Clicks processing
- Quest tagging
- Award frame is now following Objective tracker opions of ElvUI
- Quest names are following header settings from S&L's objective tracker skin
- Quest King's position is now controlled by ElvUI's objectives mover
- A lot of lines are now pulled from the client instead of being hardcoded
- Tracked quest icon is larger]]
L["Tooltip Anchor"] = true
L["Tooltip Scale"] = true
L["Quest Type Indications"] = true
L["Clicks Registration"] = true
L["SLE_SKINS_QUESTKING_TEMPLATE_DESC"] = [[|cff9482c9Quest King|r
Original Quest King's controls:
Left Click to open quest info
Alt + Right Click to untrack
Alt + Left Click to collapce quest
Right Click to set quest watch

|cff9482c9Blizzlike|r
Controls of standart Blizzard quest log:
Left Click to open quest info
Shift + Left Click to untrack
Right Click to set uest follow
Ctrl + Left Click to collapce]]
L["SLE_QUESTKING_Required"] = "  Required: "
L["ElvUI Objective Tracker"] = true
L["ElvUI Skins"] = true

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

--Tooltip
L["Faction Icon"] = true
L["Show faction icon to the left of player's name on tooltip."] = true
L["TTOFFSET_DESC"] = "This adds the ability to have the tooltip offset from the cursor.  Make sure to have the \"Cursor Anchor\" option enabled in ElvUI's Tooltip section to use this feature."
L["Tooltip X-offset"] = true
L["Offset the tooltip on the X-axis."] = true
L["Tooltip Y-offset"] = true
L["Offset the tooltip on the Y-axis."] = true
L["RAID_HFC"] = "HFC"
L["RAID_BRF"] = "BRF"
L["RAID_HM"] = "HM"
L["Raid Progression"] = true
L["Show raid experience of character in tooltip (requires holding shift)."] = true

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
L["Custom"] = true
L["UB_DESC"] = "This adds a small bar with some useful buttons which acts as a small menu for common things."
L["Minimum Roll Value"] = true
L["The lower limit for custom roll button."] = true
L["Maximum Roll Value"] = true
L["The higher limit for custom roll button."] = true
L["Quick Action"] = true
L["Use quick access (on right click) for this button."] = true
L["Function"] = true
L["Function called by quick access."] = true

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
