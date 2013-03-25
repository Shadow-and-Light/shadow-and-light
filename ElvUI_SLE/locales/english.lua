-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "enUS", true);

if not L then return; end

--General--
L["Shadow & Light"] = true
L["SLE_DESC"] = [=[This is an edit of ElvUI that adds some functionality to the original addon and changes some previously existed options.
The edit doesn't change original files in any respect so you can freely disable it any time from your addon manager without any risk.]=]
L["LFR Lockout"] = true
L["Show/Hide LFR lockout info in the time datatext's tooltip."] = true
L["PvP Auto Release"] = true
L["Automatically release body when killed inside a battleground."] = true
L["Pet autocast corners"] = true
L["Show/hide triangles in corners of autocastable buttons."] = true
L["Loot History"] = true
L["Auto hide"] = true
L["Automaticaly hide Blizzard loot histroy frame when leaving the instance."] = true
L["Sets alpha of loot histroy frame."] = true
L["SLE_LOGIN_MSG"] = [=[You are using |cff1784d1Shadow & Light Edit|r version |cff1784d1%s%s|r for ElvUI.
If you wish to use the original ElvUI addon, disable this edit's plugin in your Addons manager.
Have a nice day.]=]
L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."] = true
L["Reset All"] = true
L["Reset all Shadow & Light options and movers to their defaults"] = true
L["Reset these options to defaults"] = true

--Install--
L["Shadow & Light Settings"] = true
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
L["Hide in Pet Battle"] = true
L["Show/Hide this frame during Pet Battles."] = true

--Character Frame Options
L["CFO_DESC"] = "This section will added different options/features to the character sheet.  Here you can show item level and durability of your items for a quick glance."
L["Character Frame Options"] = true
L['Font'] = true
L["The font that the item level will use."] = true
L["Set the font size that the item level will use."] = true
L["Set the font outline that the item level will use."] = true
L["The font that the item durability will use."] = true
L["Set the font size that the item durability will use."] = true
L["Set the font outline that the item durability will use."] = true

--Chat--
L["Chat Options"] = true
L["Chat Editbox History"] = true
L["Amount of messages to save. Set to 0 to disable."] = true

--Datatexts--
L["Panels & Dashboard"] = true
L["Bosses killed: "] = true
L["You didn't select any instance to track."] = true
L["This LFR isn't available for your level/gear."] = true
L["SLE_AUTHOR_INFO"] = "Shadow & Light Edit by Darth Predator & Repooc"
L["SLE_CONTACTS"] = [=[Bug reports, suggestions and other stuff accepted via:
- Private Massage on TukUI.org to Darth Predator or Repooc
- AddOn's page/ticket system on curse.com
- Forums on tukui.org, Addons/Help section
- AddOn's repo on github.com]=]
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
L["S&L Datatexts"] = true
L["Datatext Options"] = true
L["These options are for modifing the Shadow & Light Guild datatext."] = true
L["Hide MOTD"] = true
L["Hide the guild's Message of the Day in the tooltip."] = true
L["Hide Guild Name"] = true
L["Hide the guild's name in the tooltip."] = true
L["Hide In Combat"] = true
L["Will not show the tooltip while in combat."] = true

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
L["Here you can choose what equipment sets to use in different situations."] = true
L["Equip this set when switching to primary talents."] = true
L["Equip this set when switching to secondary talents."] =true
L["Equip this set after entering dungeons or raids."] = true
L["Equip this set after entering battlegrounds or arens."] = true


--Farm--
L['Farm'] = true
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
L['Loot Announcer'] = true
L["LOOT_DESC"] = [[This module will announce loot dropped when you open the loot window.
This will work only if you are raid leadedr, assist or master looter or if you hold left control key while looting to manually announce the items in chat.]]
L["Auto Announce"] = true
L["Automatically announce in selected chat channel."] = true
L["Loot Quality"] = true
L["Set the minimum quality of an item to announce."] = true
L["Announce loot to the selected channel."] = true
L["Loot Dropped:"] = true

--Marks--
L["Raid Marks"] = true
L["Show/Hide raid marks."] = true
L["Show only in instances"] = true
L["Selecting this option will have the Raid Markers appear only while in a raid or dungeon."] = true
L["Sets size of buttons"] = true --Also used in UI buttons
L["Direction"] = true
L["Change the direction of buttons growth from the skull marker"] = true

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
L['Enable/Disable minimap button skinning.'] = true
L['Anchor Setting'] = true
L['Anchor mode for displaying the minimap buttons are skinned.'] = true
L['Horizontal Bar'] = true
L['Vertical Bar'] = true
L['The size of the minimap buttons when not anchored to the minimap.'] = true
L['Show minimap buttons on mouseover.'] = true

--Raid Utility--
L["Raid Utility"] = true

--Skins--
L["This options require ElvUI AddOnSkins pack to work."] = true
L["Sets font size on DBM bars"] = true
L["Ground"] = true
L["Flying"] = true
L["Flying & Ground"] = true
L["Swimming"] = true

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
L["Additional unit frames options"] = true
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

--Credits--
L["ELVUI_SLE_CREDITS"] = "We would like to point out the following people for helping us create this addon with testing, coding, and other stuff."
L["Submodules and Coding:"] = true
L["ELVUI_SLE_CODERS"] = [=[Elv
Tukz
Affinitii
Azilroka
Blazeflack
Boradan
Camealion
Omega1970
Pvtschlag
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


--Changelog--
L["Changelog"] = true
L["CHANGE_LOG"] = [=[|cff1784d1v1.5|r
- Some typos fixed
- Datatext panels can now be transparent
- Background frames no longer have offset options, now they have own movers
- Background frames template doesn't require reload and is a profile based option
- Movers created by S&L now are grouped by own categories just like in ElvUI itself (Note: background frames' movers are available ONLY in those groups)
- Raid Marks now properly update setting on profile change
- Raid Marks module now has an option to hide backdrop for it's main panel
- Added Item Level overlay on item slots
- Added Item Durability overlay on item slots
- Added Equipment Manager per spec/zone
- Added Farm module to make farming easier.
- Added skinning of minimap buttons
- Added coordinates to the minimap
- LFR Lockout tracking in time datatext now has options to choose what daungeons you want to show there
- Top datapanel info can now be changed by user
- You will now receive chat message if someone in your group/raid has newer version of S&L
- Add Affinitii's (Blood Legion) UI Layout
- Darth's Layout Modified
- Added loot announce function
]=]