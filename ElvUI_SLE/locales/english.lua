-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "enUS", true);

if not L then return; end

--General--
L["Below you can see option groups presented by Shadow & Light."] = true
L["General options of Shadow & Light."] = true
L["SLE_DESC"] = [=[This is an edit of ElvUI that adds some functionality to the original addon and changes some previously existed options.
The edit doesn't change original files in any respect so you can freely disable it any time from your addon manager without any risk.]=]
L["LFR Lockout"] = true
L["Show/Hide LFR lockout info in the time datatext's tooltip."] = true
L["PvP Auto Release"] = true
L["Automatically release body when killed inside a battleground."] = true
L["Pet autocast corners"] = true
L["Show/hide triangles in corners of autocastable buttons."] = true
L["Options to tweak Loot History window behaviour."] = true
L["Auto hide"] = true
L["SLE_LOGIN_MSG"] = [=[You are using |cff1784d1Shadow & Light|r version |cff1784d1%s%s|r for ElvUI.
If you wish to use the original ElvUI addon, disable this edit's plugin in your Addons manager.
Have a nice day.]=]
L['MSG_OUTDATED'] = "Your version of ElvUI is older than recommended to use with Shadow & Light. Your version is |cff1784d1%s|r (recommended is |cff1784d1%s|r). Please update your ElvUI."
-- L["Your version of ElvUI is older than recommended to use with Shadow & Light. Please, download the latest version from tukui.org."] = true
L["Reset All"] = true
L["Reset all Shadow & Light options and movers to their defaults"] = true
L["Reset these options to defaults"] = true
L['Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable.'] =  true

--Install--
L["You can now choose if you what to use one of authors' set of options. This will change the positioning of most elements but also change a bunch of other options within ElvUI's config."] = true
L["SLE_Install_Text2"] = [=[This step is optional and only to be used if you are wanting to use one of our configurations. 
|cffFF0000Warning:|r Please note that the authors' may or may not use any of the layout/theme you have selected as they may not have utilized the options.]=]
L["Darth's Config"] = true
L["Darth's Defaults Set"] = true
L["Repooc's Config"] = true
L["Repooc's Defaults Set"] = true
L["Affinitii's Config"] = true
L["Affinitii's Defaults Set"] = true

--Auras--
L["Options for customizing auras near the minimap."] = true
L["Caster Name"] = true
L["Enabling this will show caster name in the buffs and debuff icons."] = true

--Backgroungds--
L["Backgrounds"] = true
L["Additional Background Panels"] = true
L["BG_DESC"] = "Module for creating additional frames that can be used as backgrounds for anything."
L["Bottom BG"] = true
L["Left BG"] = true
L["Right BG"] = true
L["Actionbar BG"] = true
L["Show/Hide this frame."] = true
L["Sets width of the frame"] = true
L["Sets height of the frame"] = true
L["Sets X offset of the frame"] = true
L["Sets Y offset of the frame"] = true
L["Texture"] = true
L["Set the texture to use in this frame.  Requirements are the same as the chat textures."] = true
L["Backdrop Template"] = true
L["Change the template used for this backdrop."] = true
L["Default"] = true
L["Hide in Pet Battle"] = true --also in square minimap buttons
L["Show/Hide this frame during Pet Battles."] = true --also in square minimap buttons

--Character Frame Options
L["CFO_DESC"] = "This section will added different options/features to the character sheet.  Here you can show item level and durability of your items for a quick glance."
L["Character Frame Options"] = true
L["Decoration"] = true
L["Show Equipment Gradients"] = true
L["Shows gradient effect for all equipment slots."] = true
L["Show Error Gradients"] = true
L["Highlights equipment slot if an error has been found."] = true
L["Show Background Image"] = true
L['Background picture'] = true
L["Custom"] = true
L['Font'] = true
L["Show Item Level"] = true
L["The font that the item level will use."] = true
L["Set the font size that the item level will use."] = true
L["Set the font outline that the item level will use."] = true
L["Show Durability"] = true
L["The font that the item durability will use."] = true
L["Set the font size that the item durability will use."] = true
L["Set the font outline that the item durability will use."] = true
L["Enchanting"] = true
L["Show Durability"] = true
L["Show Enchants"] = true
L["Show Item Level"] = true
L["Show the enchantment effect near the enchanted item"] = true
L["Show the enchantment effect near the enchanted item (not the item itself) when mousing over."] = true
L["Show Warning"] = true
L["Warning Size"] = true
L["Set the icon size that the warning notification will use."] = true
L["The font that the enchant notification will use."] = true
L["Set the font size that the enchant notification will use."] = true
L["Set the font outline that the enchant notification will use."] = true
L["Gem Sockets"] = true
L["Show Gems"] = true
L["Show gem slots near the item"] = true
L["Socket Size"] = true
L["Set the size of sockets to show."] = true

--Character Frame--
L["Armory Mode"] = true
L["Not Enchanted"] = true
L['Missing Tinkers'] = true
L['This is not profession only.'] = true
L['Missing Buckle'] = true
L['Missing Socket'] = true
L['Empty Socket'] = true
L['Average'] = true
L["Inspect Frame Options"] = true

--Chat--
L["Chat Options"] = true
L["Chat Editbox History"] = true
L["Amount of messages to save. Set to 0 to disable."] = true

--Datatexts--
L["Panels & Dashboard"] = true
L["Bosses killed: "] = true
L["You didn't select any instance to track."] = true
L["This LFR isn't available for your level/gear."] = true
L["Key to the Palace of Lei Shen:"] = true
L["Trove of the Thunder King:"] = true
L["Looted"] = true
L["Not looted"] = true
L["SLE_AUTHOR_INFO"] = "Shadow & Light by Darth Predator & Repooc"
L["SLE_CONTACTS"] = [=[If you have suggestions or a bug report,
please submit ticket at http://git.tukui.org/repooc/elvui-shadowandlight]=]
L["DP_1"] = "DT Panel 1"
L["DP_2"] = "DT Panel 2"
L["DP_3"] = "DT Panel 3"
L["DP_4"] = "DT Panel 4"
L["DP_5"] = "DT Panel 5"
L["DP_6"] = "DT Panel 6"
L["Bottom_Panel"] = "Bottom Panel"
L["Top_Center"] = "Top Panel"
L["Left Chat"] = true
L["Right Chat"] = true
L["Datatext Panels"] = true
L["Additional Datatext Panels"] = true
L["DP_DESC"] = [=[Additional Datatext Panels.
8 panels with 20 datatext points total and a dashboard with 4 status bars.
You can't disable chat panels.]=]
L["Dashboard"] = true
L["Show/Hide dashboard."] = true
L["Dashboard Panels Width"] = true
L["Sets size of dashboard panels."] = true
L["Show/Hide this panel."] = true
L["Sets size of this panel"] = true
L['Hide panel background'] = true
L["Don't show this panel, only datatexts assinged to it"] = true
L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information. Please use the dropdown box to select which datatext you would like to configure."] = true
L["S&L Friends"] = true
L["Show total friends in the datatext."] = true
L["Show total guild members in the datatext."] = true
L["These options are for modifing the Shadow & Light Friends datatext."] = true
L["S&L Guild"] = true
L["Show Totals"] = true
L["Expand RealID"] = true
L["Display realid with two lines to view broadcasts."] = true
L["Hide Hints"] = true
L["Hide the hints in the tooltip."] = true
L["Autohide Delay:"] = true
L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."] = true
L["S&L Mail"] = true
L["These options are for modifing the Shadow & Light Mail datatext."] = true
L["Minimap icon"] = true
L["If enabled will show new mail icon on minimap."] = true
L["S&L Datatexts"] = true
L["Datatext Options"] = true
L["These options are for modifing the Shadow & Light Guild datatext."] = true
L["Hide MOTD"] = true
L["Hide the guild's Message of the Day in the tooltip."] = true
L["Hide Guild Name"] = true
L["Hide the guild's name in the tooltip."] = true
L["Hide In Combat"] = true
L["Will not show the tooltip while in combat."] = true
L["World Loot"] = true
L["Show/Hide the status of Key to the Palace of Lei Shen and Trove of the Thunder King."] = true
L["Time Played"] = true
L["Account Time Played"] = true
L["D"] = true
L["Previous Level:"] = true
L['Current:'] = true
L['Weekly:'] = true
L['ElvUI Improved Currency Options'] = true
L['Show Archaeology Fragments'] = true
L['Show Jewelcrafting Tokens'] = true
L['Show Player vs Player Currency'] = true
L['Show Dungeon and Raid Currency'] = true
L['Show Cooking Awards'] = true
L['Show Miscellaneous Currency'] = true
L['Show Zero Currency'] = true
L['Show Icons'] = true
L['Show Faction Totals'] = true
L['Show Unsed Currency'] = true


--Exp/Rep Bar--
L["Xp-Rep Text"] = true
L["Full value on Exp Bar"] = true
L["Changes the way text is shown on exp bar."] = true
L["Full value on Rep Bar"] = true
L["Changes the way text is shown on rep bar."] = true
L["Auto Track Reputation"] = true
L["Automatically sets reputation tracking to the most recent reputation change."] = true

--Equip Manager--
L['Equipment Manager'] = true
L["EM_DESC"] = "This module provides different options to automatically change your equipment sets on spec change or entering certain locations."
L['Spam Throttling'] = true
L["Removes the spam from chat stating what talents were learned or unlearned during spec change."] = true
L['Equipment Set Overlay'] = true
L['Show the associated equipment sets for the items in your bags (or bank).'] = true
L["Here you can choose what equipment sets to use in different situations."] = true
L["Equip this set when switching to primary talents."] = true
L["Equip this set when switching to secondary talents."] =true
L["Equip this set after entering dungeons or raids."] = true
L["Equip this set after entering battlegrounds or arens."] = true
L['Equipment Set Overlay'] = true
L['Show the associated equipment sets for the items in your bags (or bank).'] = true

--Farm--
L['Farm'] = true
L["Farm Options"] = true
L["FARM_DESC"] = [[Additional actionbars for the Sunsong Ranch containing seeds, tools and portals.
They will appear only if you are on the Ranch or The Halfhill Market.]]
L['Only active buttons'] = true
L['Only show the buttons for the seeds, portals, tools you have in your bags.'] = true
L["Seed Bars"] = true
L["Auto Planting"] = true
L["Automatically plant seeds to the nearest tilled soil if one is not already selected."] = true
L["Drop Seeds"] = true
L["Allow seeds to be destroyed from seed bars."] = true
L["Quest Glow"] = true
L["Show glowing border on seeds needed for any quest in your log."] = true
L["Dock Buttons To"] = true
L["Change the position from where seed bars will grow."] = true
L["Bottom"] = true
L["Top"] = true
L["Farm Seed Bars"] = true
L["Farm Tool Bar"] = true
L["Farm Portal Bar"] = true
L["Tilled Soil"] = true
L['Right-click to drop the item.'] = true
L["We are sorry, but you can't do this now. Try again after the end of this combat."] = true

--Import Section
L["SLE_IMPORTS"] = "|cffFF0000Note:|r Use the filter imports with caution as these will overwrite any custom ones made!\nImporting a class filter will overwrite any modifications you have made to that class filter."
L["Import Options"] = true
L["Author Specific Imports"] = true
L['Select Author'] = true
L["Please be aware that importing any of the filters will require a reload of the UI for the settings to take effect.\nOnce you click a filter button, your screen will reload automatically."] = true
L["Import"] = true
L["This will import non class specific filters from this author."] = true
L["This will import All Class specific filters from this author."] = true
L['Import All'] = true

--Loot--
L["Auto Announce"] = true
L["Automaticaly hides Loot Roll Histroy frame when leaving the instance."] = true
L["AUTOANNOUNCE_DESC"] = "When enabled, will automatically announce the loot when the loot window opens.\n\n|cffFF0000Note:|r Raid Lead, Assist, & Master Looter Only."
L['Loot Announcer'] = true
L["LOOT_DESC"] = "Will announce loot to specified chat channel at the selected loot threshold."
L["LOOTH_DESC"] = "These are options for tweaking the Loot Roll History window."
L["Loot Dropped:"] = true
L["Loot Roll History"] = true
L["Loot Quality"] = true
L["Automatically announce in selected chat channel."] = true
L["Select chat channel to announce loot to."] = true
L["Sets the alpha of Loot Roll Histroy frame."] = true
L["Sets the minimum loot threshold to announce."] = true

--Marks--
L['Options for panels providing fast access to raid markers and flares.'] = true
L["Raid Marks"] = true
L["Show/Hide raid marks."] = true
L["Show only in instances"] = true
L["Selecting this option will have the Raid Markers appear only while in a raid or dungeon."] = true
L["Sets size of buttons"] = true --Also used in UI buttons
L["Direction"] = true
L["Change the direction of buttons growth from the skull marker"] = true
L["Raid Flares"] = true
L["Show/Hide Raid Flares."] = true
L["Selecting this option will have the Raid Flares appear only while in a raid or dungeon."] = true
L["Show Tooltip"] = true
L["Change the direction of buttons growth from the square marker"] = true
L["Square World Marker"] = true
L["Triangle World Marker"] = true
L["Diamond World Marker"] = true
L["Cross World Marker"] = true
L["Star World Marker"] = true
L["Clear World Markers"] = true

--Nameplates--
L["Target Count"] = true
L["Display the number of party / raid members targetting the nameplate unit."] = true
L["Threat Text"] = true
L["Display threat level as text on targeted, boss or mouseover nameplate."] = true

--Minimap--
L["Minimap Options"] = true
L['MINIMAP_DESC'] = "These options effect various aspects of the minimap.  Some options may not work if you disable minimap in the General section of ElvUI config."
L["Minimap Coordinates"] = true
L['Coords Display'] = true
L['Change settings for the display of the coordinates that are on the minimap.'] = true
L["Coords Location"] = true
L['This will determine where the coords are shown on the minimap.'] = true
L['Bottom Corners'] = true
L['Bottom Center'] = true
L["Minimap Buttons"] = true
L["Bar Enable"] = true
L['Enable/Disable Square Minimap Bar'] = true
L['Skin Dungeon'] = true
L['Skin dungeon icon.'] = true
L['Skin Mail'] = true
L['Skin mail icon.'] = true
L['Icons Per Row'] = true
L['The number of icons per row for Square Minimap Bar.'] = true
L['Anchor Setting'] = true
L['Anchor mode for displaying the minimap buttons are skinned.'] = true
L['Horizontal Bar'] = true
L['Vertical Bar'] = true
L['The size of the minimap buttons.'] = true
L['Show minimap buttons on mouseover.'] = true

--Enhanced Vehicle Bar--
L["Enhanced Vehicle Bar"] = true
L["A different look/feel vehicle bar based on work by Azilroka"] = true

--Raid Utility--
L["Raid Utility"] = true

--Skins--
L["This options require ElvUI AddOnSkins pack to work."] = true
L["Sets font size on DBM bars"] = true
L["Ground"] = true
L["Flying"] = true
L["Flying & Ground"] = true
L["Swimming"] = true

--Tooltip--
L["Tooltip enhancements"] = true
L["Faction Icon"] = true
L["Tooltip Cursor Offset"] = true
L["Show faction icon to the left of player's name on tooltip."] = true
L["Tooltip X-offset"] = true
L["Offset the tooltip on the X-axis."] = true
L["Tooltip Y-offset"] = true
L["Offset the tooltip on the Y-axis."] = true

--UI buttons--
L["UI Buttons"] = true
L["Additional menu with useful buttons"] = true
L["Show/Hide UI buttons."] = true
L["Mouse over"] = true
L["Show on mouse over."] = true
L["Buttons position"] = true
L["Layout for UI buttons."] = true
L["Click to reload your interface"] = true
L["Click to toggle config window"] = true
L["Click to toggle the AddOn Manager frame (stAddOnManager, Ampere or ACP) you have enabled."] = true
L["Click to toggle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."] = true
L["Click to unlock moving ElvUI elements"] = true
L["ElvUI Config"] = true
L["Move UI"] = true
L["Reload UI"] = true
L["AddOns Manager"] = true
L["Boss Mod"] = true
L["Click to toggle iFilger's config UI"] = true

--Unitframes--
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = true
L["Player Frame Indicators"] = true
L["Combat Icon"] = true
L["Show/Hide combat icon on player frame."] = true
L["Combat Position"] = true
L["Set the point to show combat icon"] = true
L["Classbar Energy"] = true
L["Show/hide the text with exact number of energy (Solar/Lunar or Demonic Fury) on your Classbar."] = true
L["Classbar Offset"] = true
L["This options will allow you to detach your classbar from player's frame and move it in other location."] = true
L["Power Text Position"] = true
L["Position power text on this bar of chosen frame"] = true

--Links--
L['About/Help'] = true
L["LINK_DESC"] = [[Following links will direct you to the Shadow & Light's pages on various sites.]]
L['TukUI GitLab / Report Errors'] = true

--Credits--
L["ELVUI_SLE_CREDITS"] = "We would like to point out the following people for helping us create this addon with testing, coding, and other stuff."
L["Submodules and Coding:"] = true
L["ELVUI_SLE_CODERS"] = [=[Elv
Tukz
Affinitii
Arstraea
Azilroka
Blazeflack
Boradan
Camealion
Omega1970
Pvtschlag
Simpy
Sinaris
Sortokk
Swordyy
]=]
L["Other Support:"] = true
L["ELVUI_SLE_MISC"] = [=[BuG - for being french lol
TheSamaKutra
The rest of TukUI community
]=]

--Tutorials--
L["To enable full values of health/power on unitframes in Shadow & Light add \":sl\" to the end of the health/power tag.\nExample: [health:current:sl]."] = true

--Movers--
L["Pet Battle AB"] = true
L["Ghost Frame"] = true