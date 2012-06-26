-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L 
if UnitName('player') ~= 'Elv' then
	L = AceLocale:NewLocale("ElvUI", "enUS", true, true);
else
	L = AceLocale:NewLocale("ElvUI", "enUS", true);
end

if not L then return; end

L['DPE_LOGIN_MSG'] = [=[You are using the edited version of ElvUI by Darth Predator.
If you wish to use original ElvUI disable this edit's plugin in your AddOns manager.
Have a nice day.]=]
---------------
--Main config--
---------------
L["Darth Predator's Edit"] = true
L["Darth Predator's edit of ElvUI"] = true
L['DPE_DESC'] = true

--LFR Lockdown
L["LFR Dragon Soul"] = true
L['LFR Lockdown'] = true
L["Show/Hide LFR lockdown info in time datatext's tooltip."] = true

--PvP Autorelease
L["PvP Auto Release"] = true
L['Automatically release body when killed inside a battleground.'] = true

--Auras
L['Aura Size'] = true
L['Sets size of auras. This setting is character based.'] = true

--Pet Autocast
L["Pet autocast corners"] = true
L['Show/hide tringles in corners of autocastable buttons.'] = true

--------------
--UnitFrames--
--------------
L["Additional unit frames options"] = true
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = true
L["Health Values"] = true
L["Full value"] = true
L["Enabling this will show exact hp numbers on player, focus, focus target, target of target, party, boss, arena and raid frames."] = true
L["Target full value"] = true
L["Enabling this will show exact hp numbers on target frame."] = true
L["Power Values"] = true
L["Normal Frames"] = true
L["Enabling this will show exact power numbers on target of target, focus and focus target frames."] = true
L["Reversed Frames"] = true
L["Enabling this will show exact power numbers on player, boss, arena, party and raid frames."] = true

--Player Frame Indicators
L["Player Frame Indicators"] = true
L["PvP text on mouse over"] = true
L['Show PvP text on mouse over player frame.'] = true
L["PvP Position"] = true
L['Set the point to show pvp text'] = true
L["Combat Position"] = true
L['Set the point to show combat icon'] = true

--Classbar offset
L["Classbar Offset"] = true
L["This options will allow you to detach your classbar from player's frame and move it in other location."] = true

----------------
--Exp/Rep Text--
----------------
L["Xp-Rep Text"] = true
L["XP-Rep Text mod by Benik"] = true
L['Show/Hide XP-Rep Info.'] = true
L['Detailed'] = true
L['More XP-Rep Info. Shown only when bars are on top.'] = true
L["Detailed options"] = true
L['Reaction Name'] = true
L['Show/Hide Reaction status on bar.'] = true
L['Rested Value'] = true
L['Show/Hide Rested value.'] = true

--------------
--UI Buttons--
--------------
L["UI Buttons"] = true
L["Additional menu with useful buttons"] = true
L["Show/Hide UI buttons."] = true
L["Mouse over"] = true
L["Show on mouse over."] = true
L["Buttons position"] = true
L["Layout for UI buttons."] = true

L["ElvUI Config"] = true
L["Click to toggle config window"] = true
L["Reload UI"] = true
L["Click to reload your interface"] = true
L["Move UI"] = true
L["Click to unlock moving ElvUI elements"] = true
L["Boss Mod"] = true
L["Click to toogle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."] = true
L["AddOns Manager"] = true
L["Click to toogle the AddOn Managerframe (stAddOnManager or ACP) you have enabled."] = true

------------
--Microbar--
------------
L["2 rows"] = true
L["3 rows"] = true
L["4 rows"] = true
L["6 rows"] = true
L["Change the positioning of buttons on Microbar."] = true
L["Hide in Combat"] = true
L["Hide Microbar in combat."] = true
L["Hide microbar unless you mouse over it."] = true
L["Microbar"] = true
L["Microbar Layout"] = true
L["Module for adding micromenu to ElvUI."] = true
L["On Mouse Over"] = true
L["Positioning"] = true
L["Set Alpha"] = true
L["Sets alpha of the microbar"] = true
L["Set Scale"] = true
L["Sets Scale of the microbar"] = true
L["Sets X offset for microbar buttons"] = true
L["Sets Y offset for microbar buttons"] = true
L["Show backdrop for micromenu"] = true


--------------
--Raid Marks--
--------------
L["Raid Marks"] = true
L["Show/Hide raid marks."] = true
L['Sets size of buttons'] = true
L["Direction"] = true
L['Change the direction of buttons growth from "skull" mark'] = true

-------------
--Datatexts--
-------------
L["Datatext panels"] = true
L["Additional Datatext Panels"] = true
L["DP_DESC"] = [=[Additional datatext panels.
8 panels with 20 datatext points total.
You can't disable Top Panel and chat panels.]=]
L["DP_1"] = "DT Panel 1"
L["DP_2"] = "DT Panel 2"
L["Top_Center"] = "Top Panel"
L["DP_3"] = "DT Panel 3"
L["DP_4"] = "DT Panel 4"
L["DP_5"] = "DT Panel 5"
L["Bottom_Panel"] = "Bottom Panel"
L["DP_6"] = "DT Panel 6"
L["Left Chat"] = true
L["Right Chat"] = true
L['Show/Hide this panel.'] = true
L['Sets size of this panel'] = true

---------
--Skins--
---------
L["Sets font size on DBM bars"] = true
L["Skada Backdrop"]= true
L['Show/Hide Skada backdrop.'] = true

--------
--Chat--
--------
L["Chat options"] = true
L["Chat Fade"] = true
L["Enable/disable the text fading in the chat window."] = true
L["Chat Editbox History"] = true
L["Amount of messages to save. Set to 0 to disable."] = true
L["Name Highlight"] = true
L["TOON_DESC"] = [=[The options for highlighting and sound warning if someone mentions your name in chat.
Names are stored character-based, so you can have different names lists on different characters.
Your current character's name will be on the list automaticaly.]=]
L["Enable sound"] = true
L["Play sound when your name is mentioned in chat."] = true
L["Sound that will play when your name is mentioned in chat."] = true
L['Timer'] = true
L['Sound will be played only once in this number of seconds.'] = true
L["Add a name different from your current character's to be looked for"] = true
L['Invalid name entered!'] = true
L['Name already exists!'] = true
L['Names list'] = true
L["You can delete selected name from the list here by clicking the button below"] = true
L["Delete this name from the list"] = true
L["Channels"] = true
L["Enable/disable checking of this channel."] = true
L["Defense"] = true
L['LFG'] = true
L['Add channel'] = true
L['Invalid channel entered!'] = true
L['Channel already exists!'] = true
L["Add a custom channel name."] = true
L['Channels list'] = true
L["You can delete selected channel from the list here by clicking the button below"] = true
L["Remove Channel"] = true
L["Delete this channel from the list"] = true


---------------
--Backgrounds--
---------------
L["Backgrounds"] = true
L["Additional Background Panels"] = true
L["BG_DESC"] = "Module to create additional frames which can be used as backgrounds for something."
L["Bottom BG"] = true
L["Left BG"] = true
L["Right BG"] = true
L["Actionbar BG"] = true
L['Show/Hide this frame.'] = true
L['Sets width of the frame'] = true
L['Sets height of the frame'] = true
L['Sets X offset of the frame'] = true
L['Sets Y offset of the frame'] = true
L["Texture"] = true
L["Set texture to use in this frame. Requirements are the same as for the chat textures."] = true

----------------
--Raid Utility--
----------------
L["Raid Utility"] = true
L["Raid Utility coordinates"] = true
L["RU_DESC"] = [=[This config group allows you to freely move your Raid Utility button starting position.
Moving Raid Utility with mouse is disabled. Use the sliders to move the button around.]=]
L['X Position'] = true
L['Sets X position of Raid Utility button.'] = true
L['Y Position'] = true
L['Sets Y position of Raid Utility button.'] = true

-----------------------
--Balance Power Frame--
-----------------------
L["Druid"] = true
L["Druid spesific options"] = true
L["Balance Power Frame"] = true
L["Show/hide the frame with exact number of your Solar/Lunar energy."] = true

-----------
--Credits--
-----------
L['ELVUI_DPE_CREDITS'] = "I would like to point out the following people for helping me creating this addon with testing, coding and other stuff."
L['Submodules and coding:'] = true
L['ELVUI_DPE_CODERS'] = [=[Benik - core of exp/rep bars' text
Repooc - core of auto release feature, some ideas, testing
Tukz - helping with oUF
Elv - for making creation of this edit much easier
Pvtschlag - Necrotic Strike oUF plugin
Blazeflack - helping hooking, modules and profiles
Camealion - teaching me the art of skining
Swordyy - idea of ui buttons
Azilroka@US-Daggerspine - core of ExtVendor and Altoholic skins
Pat - skinning options dropdowns and checkboxes missed by Elv
Boradan - the idea of classbar movement
Hydra - basic core of toon name highlight feature
]=]
L['Other support:'] = true
L['ELVUI_DPE_MISC'] = [=[BuG - brining fun to the chat while i was writing this
TheSamaKutra - some good ideas
The rest of TukUI community - the existance of community itself
My guild, Effect(Эффект)@RU-Soulflyer(Свежеватель Душ) - not kicking me out while I was slacking :D
]=]
L["DPE_AUTHOR_INFO"] = "Darth Predator's edit (Дартпредатор@RU-Свежеватель Душ(Soulflyer))"
L["DPE_CONTACTS"] = [=[Bug reports, suggestions and other stuff accepted via:
- In-game mail
- Private Massage on TukUI.org to Darth Predator
- Shadowmage.ru]=]