-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "enUS", true);

if not L then return; end

--General--
L["Shadow & Light Edit"] = true
L["Shadow & Light Edit of ElvUI"] = true
L["SLE_DESC"] = [=[This is and edit of ElvUI that adds some functionality to the original addon and changes some previously existed options.
The edit doesn't change original files in any respect so you can freely disable it any time from your addon manager without any risk.]=]
L["LFR Lockdown"] = true
L["Show/Hide LFR lockdown info in time datatext's tooltip."] = true
L["PvP Auto Release"] = true
L["Automatically release body when killed inside a battleground."] = true
L["Errors in combat"] = true
L["Show/hide error messages in combat."] = true
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

--Auras--
L["Options for customizing auras near the minimap."] = true
L["Caster Name"] = true
L["Enabling this will show caster name in the buffs and debuff icons."] = true

--Backgroungds--
L["Backgrounds"] = true
L["Additional Background Panels"] = true
L["BG_DESC"] = true
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
L["Transparent"] = true
L["Hide in Pet Batlle"] = true
L["Show/Hide this frame during Pet Battles."] = true

--Chat--
L["Chat Options"] = true
L["Chat Editbox History"] = true
L["Amount of messages to save. Set to 0 to disable."] = true

--Datatexts--
L["LFR Dragon Soul"] = true
L["LFR Mogu'shan Vaults"] = true
L["LFR Heart of Fear"] = true
L["LFR Terrace of Endless Spring"] = true
L["Bosses killed: "] = true
L["SLE_AUTHOR_INFO"] = "Shadow & Light Edit by Darth Predator & Repooc"
L["SLE_CONTACTS"] = [=[Bug reports, suggestions and other stuff accepted via:
- Private Massage on TukUI.org to Darth Predator or Repooc
- AddOn's page/ticket system on curse.com
- Forums on tukui.org, Addons/Help section
- AddOn's repo github.com]=]
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

--Exp/Rep Bar--
L["Xp-Rep Text"] = true
L["Full value on Exp Bar"] = true
L["Changes the way text is shown on exp bar."] = true
L["Full value on Rep Bar"] = true
L["Changes the way text is shown on rep bar."] = true

--Marks--
L["Raid Marks"] = true
L["Show/Hide raid marks."] = true
L["Show only in instances"] = true
L["Selecting this option will have the Raid Markers appear only while in a raid or dungeon."] = true
L["Sets size of buttons"] = true --Also used in UI buttons
L["Direction"] = true
L["Change the direction of buttons growth from the skull marker"] = true

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
Azilroka
Blazeflack
Boradan
Camealion
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
L["CHANGE_LOG"] = [=[|cff1784d1v1.3|r (Not released, patch 5.1 stuff)
- Authors' layouts have been changed
- Mount serach was deleted, Blizzard added that themselves
- Some adjustions for pixel perfect mode to make things look good
- Caster name in auras' tooltips is now profile based option
- An option added to chosee if you want your power text to be on power bar or health bar (health by default as in normal ElvUI)
- Raid Utility options removed. Now it's fully movable with it's own mover
- Added a mover for world/BG pvp score - Hellfire towers, AV reinforcements, AB resources, etc. (Darth grow tired of using MoveAnything)
- Capture bar is now docked to the bottom of a new mover
- Show errors in combat is now profile based option
- Added S&L version number to version datatext, login message and config
- Buttons for resetting all S&L options or just desired group's options have been added
- You can now see changelog in game

|cff1784d1v1.22|r (November 8, 2012)
- Fixed our settings packs in installation
- You will be able to see your castbar and other stuff while in vehicle again (apparently it was there for ages and no one reported that o_O)
- The option to hide combat indicator was removed. You can choose to hide it in it's positioning dropdown list now.
- Fixed some issues with loading that resulted in disappearing of S&L mover group in config mode.

|cff1784d1v1.21|r (November 1, 2012)
- Fixed small error

|cff1784d1v1.20|r (November 1, 2012)
- Code catch up with ElvUI
- Some code restructure to reduce memory
- Small fixes/tweaks

|cff1784d1v1.19|r (October 24, 2012)
- Code catch up with ElvUI
- Added show/hide option for errors in combat (out of LoS, on cooldown, etc)
- Changed the way reputation is shown on bar
- Added Ampere Addon Control Panel to UI Buttons
- Fixed wrong rested percent with cur-percent mode of experience bar (195000000% of rested? Easy)
- Added new options for loot history frame
- Add ability to show Raid Markers only in the instance.

|cff1784d1v1.18|r (October 9, 2012)
- Fixed red flying could not showing in the mount list

|cff1784d1v1.17|r (September 30, 2012)
- Fixed Mount Search bug when skinning was disabled.
- Fixed Background Panels & Pet Battle Bar having frame level issues.
- Fixed left chat being to close to the edge of the frame.
- Added ability to show/hide background panels during pet battles

|cff1784d1v1.16|r (September 24, 2012)
- Added Search Feature for Mount Window by p3lim
- Fixed lua error about missing locale for ElvUI Hud during install process(It was mistyped)
- Fixed Raid Marker not toggling off

|cff1784d1v1.15|r (September 7, 2012)
- Fix Curse Ticket #3

|cff1784d1v1.14|r (September 5, 2012)
- Updated Install to catch up with ElvUI
- Updated Repooc Settings to more current setup

|cff1784d1v1.13|r (September 1, 2012)
- Fixed Combat Icon Error when ElvUI Unitframes were disabled.
- Updated Install file to ElvUI additions

|cff1784d1v1.12|r (August 31, 2012)
- Fixed Time Datatext error

|cff1784d1v1.11|r (August 30, 2012)
- Fixrd editbox positioning when ElvUI chat is disabled

|cff1784d1v1.1|r (August 28, 2012)
- (Backend) Optimize Druid Resource
- (Backend) Private options now use Elv's popus
- Added Demonic Fury number on warlock classbar
- Added debuff resizing
- Added hiding for combat ico
- Readded castername in buff/debuff icon due to darth rewriting auras.lua and not doing his job
- Moved options for auras to its own category
- Removed some skinning of addons as we are now working with Azilroka on the skinning package.
- Removed embed right fix due it being removed from ElvUI
- Fixed the chat text going over the panel's border
- Options for full values on hp/power text changed due to ElvUI's changes in text formatting. Now you can use tags. Just add a ":sl" at the end of the health or power tag to get full value. Doesn't work with percent.
- Background frames now have an option for transparancy
- Exp/Rep bar text options were changed to show full or short values
- Added an option to move editbox for chat pannels
- PvP text options were removed, ElvUI now has it's own
- Removed Skada and DBM skins
- Removed Pet Autocast option
- Changed positions of some options

|cff1784d1v1.03|r (July 25, 2012)
- Fixed Combatlog not anchoring correctly in right panel as the only chat window
- Fixed Microbar Bug (Leave combat issue)
- Added the vengeance bar for tanks (without options atm)
- Deleted keywords sounds (Elv has his own)
- Increased the recommended version number

|cff1784d1v1.02|r (July 15, 2012)
- Updated Repooc install
- Added Poisner Skin
- Added Outfitter skin
- Fixed Microbar Bug
- Fixed RaidUtility button not changing position on profile change

|cff1784d1v1.01|r (July 11, 2012)
- Skada/Recount embedright tweaked
- Minor install tweaks
- Added Alphabet layout to Microbar

|cff1784d1v1.0|r (July 7, 2012)
- Inital Release
]=]