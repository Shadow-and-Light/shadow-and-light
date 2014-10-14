-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "enUS", true);

if not L then return; end

--General--
L["SLE_DESC"] = [=[This is an edit of ElvUI that adds some functionality to the original addon and changes some previously existed options.
The edit doesn't change original files in any respect so you can freely disable it any time from your addon manager without any risk.]=]
L["LFR Lockout"] = true
L["Show/Hide LFR lockout info in time datatext's tooltip."] = true
L["PvP Auto Release"] = true
L["Automatically release body when killed inside a battleground."] = true
L["Auto hide"] = true
L["SLE_LOGIN_MSG"] = [=[You are using |cff1784d1Shadow & Light|r version |cff1784d1%s%s|r for ElvUI.
If you wish to use the original ElvUI addon, disable this edit's plugin in your Addons manager.
Have a nice day.]=]
L['MSG_OUTDATED'] = "Your version of ElvUI is older than recommended to use with Shadow & Light. Your version is |cff1784d1%.2f|r (recommended is |cff1784d1%.2f|r). Please update your ElvUI."
L["Reset All"] = true
L["Reset these options to defaults"] = true
L['Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable.'] =  true

--Install--
L["SLE_Install_Text2"] = [=[This step is optional and only to be used if you are wanting to use one of our configurations. 
|cffFF0000Warning:|r Please note that the authors' may or may not use any of the layouts/themes you have selected as they may have changed their setup more recently.]=]


--Auras--


--Backgroungds--
L["BG_DESC"] = "Module for creating additional frames that can be used as backgrounds for anything."

--Character Frame Options
L["CFO_DESC"] = "This section will added different options/features to the character sheet.  Here you can show item level and durability of your items for a quick glance."
L['IFO_DESC'] = "This section will disable default inspect frame and use a custom one that S&L provides.  Please note that this is in a very early beta and we know there may be issues.  We will be adding customization in later releases, please make sure to check for updates for new features and fixes."


--Character Frame--


--Chat--


--Datatexts--
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
L["DP_DESC"] = [=[Additional Datatext Panels.
8 panels with 20 datatext points total and a dashboard with 4 status bars.
You can't disable chat panels.]=]


--Exp/Rep Bar--


--Equip Manager--

L["EM_DESC"] = "This module provides different options to automatically change your equipment sets on spec change or entering certain locations."


--Farm--
L["FARM_DESC"] = [[Additional actionbars for the Sunsong Ranch containing seeds, tools and portals.
They will appear only if you are on the Ranch or The Halfhill Market.]]

--Marks--


--Import Section
L["SLE_IMPORTS"] = "|cffFF0000Note:|r Use the filter imports with caution as these will overwrite any custom ones made!\nImporting a class filter will overwrite any modifications you have made to that class filter."

--Loot--
L["AUTOANNOUNCE_DESC"] = "When enabled, will automatically announce the loot when the loot window opens.\n\n|cffFF0000Note:|r Raid Lead, Assist, & Master Looter Only."
L["LOOT_DESC"] = "Will announce loot to specified chat channel at the selected loot threshold."
L["LOOTH_DESC"] = "These are options for tweaking the Loot Roll History window."




--Nameplates--


--Minimap--
L['MINIMAP_DESC'] = "These options effect various aspects of the minimap.  Some options may not work if you disable minimap in the General section of ElvUI config."


--Enhanced Vehicle Bar--


--Raid Utility--


--Skins--

--Tooltip--
L["TTOFFSET_DESC"] = "This adds the ability to have the tooltip offset from the cursor.  Make sure to have the \"Cursor Anchor\" option enabled in ElvUI's Tooltip section to use this feature."


--UI buttons--
L["UB_DESC"] = "This adds a small bar with some useful buttons which acts as a small menu for common things."


--Unitframes--


--Links--
L["LINK_DESC"] = [[Following links will direct you to the Shadow & Light's pages on various sites.]]

--Credits--
L["ELVUI_SLE_CREDITS"] = "We would like to point out the following people for helping us create this addon with testing, coding, and other stuff."
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
L["ELVUI_SLE_MISC"] = [=[BuG - for being french lol
TheSamaKutra
The rest of TukUI community
]=]

--Tutorials--

--Movers--
