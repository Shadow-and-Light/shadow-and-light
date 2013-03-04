--Russian localization
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "ruRU")

if not L then return; end

L[" - Plugins Loaded  (Green means you have current version, Red means out of date)"] = " - загруженные плагины (зеленый означает, что у вас последняя версия, красный - устаревшая)"
L["Plugins"] = "Плагины"
L["Your version of "] = "Ваша версия "
L[" is out of date. You can download the latest version from http://www.tukui.org"] = " устарела. Вы можете скачать последнюю версию на http://www.tukui.org"
L["by"] = "от"
L[" (Newest: "] = " (Последняя: "

