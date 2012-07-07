-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L 
if UnitName('player') ~= 'Elv' then
	L = AceLocale:NewLocale("ElvUI", "enUS", true, true);
else
	L = AceLocale:NewLocale("ElvUI", "enUS", true);
end

if not L then return; end

L["2 rows"] = "2 rows"
L["3 rows"] = "3 rows"
L["4 rows"] = "4 rows"
L["6 rows"] = "6 rows"
L["Actionbar BG"] = "Actionbar BG"
L["Additional Background Panels"] = "Additional Background Panels"
L["Additional Datatext Panels"] = "Additional Datatext Panels"
L["Additional menu with useful buttons"] = "Additional menu with useful buttons"
L["Additional unit frames options"] = "Additional unit frames options"
L["AddOns Manager"] = "AddOns Manager"
L["Amount of messages to save. Set to 0 to disable."] = "Amount of messages to save. Set to 0 to disable."
L["Aura Size"] = "Aura Size"
L["Automatically release body when killed inside a battleground."] = "Automatically release body when killed inside a battleground."
L["Backgrounds"] = "Backgrounds"
L["Balance Power Text"] = "Balance Power Text"
L["BG_DESC"] = "Module to create additional frames which can be used as backgrounds for something."
L["Boss Mod"] = "Boss Mod"
L["Bottom BG"] = "Bottom BG"
L["Bottom_Panel"] = "Bottom Panel"
L["Buttons position"] = "Buttons position"
L["Change the direction of buttons growth from the skull marker"] = "Change the direction of buttons growth from the skull marker"
L["Change the positioning of buttons on Microbar."] = "Change the positioning of buttons on Microbar."
L["Chat Editbox History"] = "Chat Editbox History"
L["Chat Fade"] = "Chat Fade"
L["Chat Options"] = "Chat Options"
L["Classbar Offset"] = "Classbar Offset"
L["Click to reload your interface"] = "Click to reload your interface"
L["Click to toggle config window"] = "Click to toggle config window"
L["Click to toogle the AddOn Managerframe (stAddOnManager or ACP) you have enabled."] = "Click to toogle the AddOn Managerframe (stAddOnManager or ACP) you have enabled."
L["Click to toogle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."] = "Click to toogle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."
L["Click to unlock moving ElvUI elements"] = "Click to unlock moving ElvUI elements"
L["Combat Position"] = "Combat Position"
L["Darth's Config"] = "Darth's Config"
L["Darth's Defaults Set"] = "Darth's Defaults Set"
L["Datatext Panels"] = "Datatext Panels"
L["Detailed"] = "Detailed"
L["Detailed Options"] = "Detailed Options"
L["Direction"] = "Direction"
L["DP_1"] = "DT Panel 1"
L["DP_2"] = "DT Panel 2"
L["DP_3"] = "DT Panel 3"
L["DP_4"] = "DT Panel 4"
L["DP_5"] = "DT Panel 5"
L["DP_6"] = "DT Panel 6"
L["DP_DESC"] = [=[Additional Datatext Panels.
8 panels with 20 datatext points total.
You can't disable Top Panel and chat panels.]=]
L["Elv's Defaults"] = "Elv's Defaults"
L["Elv's Defaults Set"] = "Elv's Defaults Set"
L["ElvUI Config"] = "ElvUI Config"
L["ELVUI_SLE_CODERS"] = [=[Benik - core of exp/rep bars' text
Tukz - helping with oUF
Elv - for making creation of this edit much easier
Pvtschlag - Necrotic Strike oUF plugin
Blazeflack - helping hooking, modules and profiles
Camealion - teaching Darth Predator the art of skining
Swordyy - idea of ui buttons
Azilroka@US-Daggerspine - core of ExtVendor and Altoholic skins, help with MoveAnything skin
Pat - skinning options dropdowns and checkboxes missed by Elv
Boradan - the idea of classbar movement
]=]
L["ELVUI_SLE_CREDITS"] = "I would like to point out the following people for helping me create this addon with testing, coding, and other stuff."
L["ELVUI_SLE_MISC"] = [=[BuG - for being french lol
TheSamaKutra - some good ideas
The rest of TukUI community - the existance of community itself
]=]
L["Enable/Disable the text fading in the chat window."] = "Enable/Disable the text fading in the chat window."
L["Enable Sound"] = "Enable Sound"
L["Enabling this will show exact hp numbers on player, focus, focus target, target of target, party, boss, arena and raid frames."] = "Enabling this will show exact hp numbers on player, focus, focus target, target of target, party, boss, arena and raid frames."
L["Enabling this will show exact hp numbers on target frame."] = "Enabling this will show exact hp numbers on target frame."
L["Enabling this will show exact power numbers on player, boss, arena, party and raid frames."] = "Enabling this will show exact power numbers on player, boss, arena, party and raid frames."
L["Enabling this will show exact power numbers on target of target, focus and focus target frames."] = "Enabling this will show exact power numbers on target of target, focus and focus target frames."
L["Full value"] = "Full value"
L["Health Values"] = "Health Values"
L["Hide in Combat"] = "Hide in Combat"
L["Hide Microbar in combat."] = "Hide Microbar in combat."
L["Hide microbar unless you mouse over it."] = "Hide microbar unless you mouse over it."
L["Layout for UI buttons."] = "Layout for UI buttons."
L["Left BG"] = "Left BG"
L["Left Chat"] = "Left Chat"
L["LFR Dragon Soul"] = "LFR Dragon Soul"
L["LFR Lockdown"] = "LFR Lockdown"
L["Microbar"] = "Microbar"
L["Microbar Layout"] = "Microbar Layout"
L["Module for adding micromenu to ElvUI."] = "Module for adding micromenu to ElvUI."
L["More XP-Rep Info. Shown only when bars are on top."] = "More XP-Rep Info. Shown only when bars are on top."
L["Mouse over"] = "Mouse over"
L["Move UI"] = "Move UI"
L["Name Highlight"] = "Name Highlight"
L["Normal Frames"] = "Normal Frames"
L["On Mouse Over"] = "On Mouse Over"
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = "Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."
L["Other Support:"] = "Other Support:"
L["Pet autocast corners"] = "Pet autocast corners"
L["Player Frame Indicators"] = "Player Frame Indicators"
L["Play sound when keyword is mentioned in chat."] = "Play sound when keyword is mentioned in chat."
L["Positioning"] = "Positioning"
L["Power Values"] = "Power Values"
L["PvP Auto Release"] = "PvP Auto Release"
L["PvP Position"] = "PvP Position"
L["PvP text on mouse over"] = "PvP text on mouse over"
L["Raid Marks"] = "Raid Marks"
L["Raid Utility"] = "Raid Utility"
L["Raid Utility Coordinates"] = "Raid Utility Coordinates"
L["Reaction Name"] = "Reaction Name"
L["Reload UI"] = "Reload UI"
L["Repooc's Config"] = "Repooc's Config"
L["Repooc's Defaults Set"] = "Repooc's Defaults Set"
L["Rested Value"] = "Rested Value"
L["Reversed Frames"] = "Reversed Frames"
L["Right BG"] = "Right BG"
L["Right Chat"] = "Right Chat"
L["RU_DESC"] = [=[This config group allows you to freely move your Raid Utility button starting position.
Moving Raid Utility with mouse is disabled.  Use the sliders to move the button around.]=]
L["Set Alpha"] = "Set Alpha"
L["Sets alpha of the microbar"] = "Sets alpha of the microbar"
L["Set Scale"] = "Set Scale"
L["Sets font size on DBM bars"] = "Sets font size on DBM bars"
L["Sets height of the frame"] = "Sets height of the frame"
L["Sets Scale of the microbar"] = "Sets Scale of the microbar"
L["Sets size of auras. This setting is character based."] = "Sets size of auras. This setting is character based."
L["Sets size of buttons"] = "Sets size of buttons"
L["Sets size of this panel"] = "Sets size of this panel"
L["Sets width of the frame"] = "Sets width of the frame"
L["Sets X offset for microbar buttons"] = "Sets X offset for microbar buttons"
L["Sets X offset of the frame"] = "Sets X offset of the frame"
L["Sets X position of Raid Utility button."] = "Sets X position of Raid Utility button."
L["Sets Y offset for microbar buttons"] = "Sets Y offset for microbar buttons"
L["Sets Y offset of the frame"] = "Sets Y offset of the frame"
L["Sets Y position of Raid Utility button."] = "Sets Y position of Raid Utility button."
L["Set the point to show combat icon"] = "Set the point to show combat icon"
L["Set the point to show pvp text"] = "Set the point to show pvp text"
L["Set the texture to use in this frame.  Requirements are the same as the chat textures."] = "Set the texture to use in this frame.  Requirements are the same as the chat textures."
L["Shadow & Light Edit"] = "Shadow & Light Edit"
L["Shadow & Light Edit of ElvUI"] = "Shadow & Light Edit of ElvUI"
L["Shadow & Light Settings"] = "Shadow & Light Settings"
L["Show backdrop for micromenu"] = "Show backdrop for micromenu"
L["Show/Hide LFR lockdown info in time datatext's tooltip."] = "Show/Hide LFR lockdown info in time datatext's tooltip."
L["Show/Hide raid marks."] = "Show/Hide raid marks."
L["Show/Hide Reaction status on bar."] = "Show/Hide Reaction status on bar."
L["Show/Hide Rested value."] = "Show/Hide Rested value."
L["Show/Hide Skada backdrop."] = "Show/Hide Skada backdrop."
L["Show/hide the text with exact number of your Solar/Lunar energy on your Classbar."] = "Show/hide the text with exact number of your Solar/Lunar energy on your Classbar."
L["Show/Hide this frame."] = "Show/Hide this frame."
L["Show/Hide this panel."] = "Show/Hide this panel."
L["Show/hide tringles in corners of autocastable buttons."] = "Show/hide tringles in corners of autocastable buttons."
L["Show/Hide UI buttons."] = "Show/Hide UI buttons."
L["Show/Hide XP-Rep Info."] = "Show/Hide XP-Rep Info."
L["Show on mouse over."] = "Show on mouse over."
L["Show PvP text on mouse over player frame."] = "Show PvP text on mouse over player frame."
L["Skada Backdrop"] = "Skada Backdrop"
L["SLE_AUTHOR_INFO"] = "Shadow & Light Edit by Darth Predator & Repooc"
L["SLE_CONTACTS"] = [=[Bug reports, suggestions and other stuff accepted via:
- Private Massage on TukUI.org to Darth Predator or Repooc
- AddOn's page/ticket system on curse.com
- AddOn's thread on tukui.org
- AddOn's repo github.com]=]
L["SLE_DESC"] = [=[This is and edit of ElvUI that adds some functionality to the original addon and changes some previously existed options.
The edit doesn't change original files in any respect so you can freely disable it any time from youe addon manager without any risk.]=]
L["SLE_Install_Text2"] = [=[Elv's Defaults button only needs to be clicked if you set one of our configurations and wish to reverse this choise. 
|cffFF0000Warning:|r this will reset everything to the high resolution normal layout.]=]
L["SLE_LOGIN_MSG"] = [=[You are using |cff1784d1Shadow & Light Edit|r for ElvUI.
If you wish to use the original ElvUI addon, disable this edit's plugin in your Addons manager.
Have a nice day.]=]
L["Sound that will be played."] = "Sound that will be played."
L["Sound will be played only once in this number of seconds."] = "Sound will be played only once in this number of seconds."
L["Submodules and Coding:"] = "Submodules and Coding:"
L["Target full value"] = "Target full value"
L["Texture"] = "Texture"
L["This options will allow you to detach your classbar from player's frame and move it in other location."] = "This options will allow you to detach your classbar from player's frame and move it in other location."
L["Timer"] = "Timer"
L["TOON_DESC"] = "Sound options for the ElvUI's keyword coloring feature."
L["Top_Center"] = "Top Panel"
L["UI Buttons"] = "UI Buttons"
L["X Position"] = "X Position"
L["Xp-Rep Text"] = "Xp-Rep Text"
L["XP-Rep Text mod by Benik"] = "XP-Rep Text mod by Benik"
L["You can now choose if you what to use one of authors' set of options. This will change not only the positioning of some elements but also change a bunch of other options."] = "You can now choose if you what to use one of authors' set of options. This will change not only the positioning of some elements but also change a bunch of other options."
L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."] = "Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."
L["Y Position"] = "Y Position"
