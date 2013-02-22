-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "enUS", true);

if not L then return; end

--General--
L["Shadow & Light Edit"] = true
L["Shadow & Light Edit of ElvUI"] = true
L["SLE_DESC"] = [=[This is and edit of ElvUI that adds some functionality to the original addon and changes some previously existed options.
The edit doesn't change original files in any respect so you can freely disable it any time from your addon manager without any risk.]=]
L["LFR Lockout"] = true
L["Show/Hide LFR lockout info in the time datatext's tooltip."] = true
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
L["Hide in Pet Batlle"] = true
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
L["Bosses killed: "] = true
L["You didn't select any instance to track."] = true
L["This LFR isn't available for your lever/gear."] = true
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

--Marks--
L["Raid Marks"] = true
L["Show/Hide raid marks."] = true
L["Show only in instances"] = true
L["Selecting this option will have the Raid Markers appear only while in a raid or dungeon."] = true
L["Sets size of buttons"] = true --Also used in UI buttons
L["Direction"] = true
L["Change the direction of buttons growth from the skull marker"] = true

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
L["CHANGE_LOG"] = [=[|cff1784d1v1.37|r
- Decimals are once again shown for hp/power texts on unit frames

|cff1784d1v1.36|r
- Some tweaks to better work with ElvUI 5.20

|cff1784d1v1.35|r
- Fixed compatibility with full Location Plus version

|cff1784d1v1.34|r
Fixed rune bar error when using classbar offset

|cff1784d1v1.33|r
- Fixed errors on auras tooltips
- Fixed health bar height with classbar offset enabled

|cff1784d1v1.32|r
- Config updated

|cff1784d1v1.31|r
- Repooc config updated

|cff1784d1v1.3|r
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
- Added alternative mene regen datatext called "MP5". It shows an "mp5" title instead of "mana regen"
]=]