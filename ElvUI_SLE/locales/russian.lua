--Russian localization
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "ruRU")

if not L then return; end

--General--
L["SLE_DESC"] = [=[Это редакция ElvUI добавляет некоторые новые функции к оригинальному аддону и изменяет функционал некоторых старых опций.
Эта редакция ни в коем виде не изменяет оригинальные файлы, так что вы можете спокойно отключить ее в вашем менеджере аддонов по желанию.]=]

L["SLE_LOGIN_MSG"] = [=[Вы используете редакцию ElvUI под названием |cff1784d1"Shadow & Light"|r версия |cff1784d1%s%s|r.
Если вы хотите использовать оригинальный ElvUI, просто отключите плагин этой редакции в вашем менеджере аддонов.
Приятной игры.]=]
L['MSG_OUTDATED'] = "Ваша версия ElvUI старее, чем рекомендованная для использования с Shadow & Light. У Вас версия |cff1784d1%.2f|r (рекомендованая |cff1784d1%.2f|r). Пожалуйста, обновите ElvUI."


--Install--
L["SLE_Install_Text2"] = [=[Этот шаг опционален и должен использоваться только в случае, если Вы хотите использовать одну из наших конфигураций. 
|cffFF0000Внимание:|r Пожалуйста помните, что авторы могут не использовать тему/роль, которую вы выбрали, и потому результат не всегда будет хорошим.]=]


--Auras--
L

--Backgroungds--

L["BG_DESC"] = "Модуль для создания дополнительных фреймов, которые могут использоваться в качестве фонов для чего-нибудь."


--Character Frame Options--
L["CFO_DESC"] = "Дополнительные опции окна персонажа.  Вы можете включить отображение уровня и прочности предметов."

--Character Frame--


--Chat--


--Datatexts--
L["SLE_AUTHOR_INFO"] = "\"Shadow & Light\" от Darth Predator и Repooc"
L["SLE_CONTACTS"] = [=[При возникновении вопросов, предложений и прочего обращаться:
http://git.tukui.org/repooc/elvui-shadowandlight]=]
L["DP_1"] = "Панель 1"
L["DP_2"] = "Панель 2"
L["DP_3"] = "Панель 3"
L["DP_4"] = "Панель 4"
L["DP_5"] = "Панель 5"
L["DP_6"] = "Панель 6"
L["Bottom_Panel"] = "Нижняя панель"
L["Top_Center"] = "Верхняя панель"
L["DP_DESC"] = [=[Дополнительные панели под информационные тексты.
Всего здесь 8 дополнительных панелей и 20 дополнительных слотов под инфо-тексты, а также панель состояния с 4мя индикаторами.
Панели на чатах отключить нельзя.]=]


--Exp/Rep Bar--


--Equip Manager--
L["EM_DESC"] = "Этот модуль предоставляет различные опции для автоматической смены комплектов экипировки при переключении набора талантов или попадании в определенную локацию."


--Farm--
L["FARM_DESC"] = [[Дополнительные панели с семенами, инструментами и порталами для Фермы Солнечной Песни.
Они будут отображаться только если Вы находитесь на ферме или рынке Полугорья.]]


--Marks--



--Import Section
L["SLE_IMPORTS"] = "|cffFF0000Важно:|r Используйте импортирование фильтров осторожно, так как они удалят ваши собсвенные фильтры!\nИмпортирование классового фильтра перезапишет любые изменения, которые Вы в него вносили."

--Loot--
L["LOOT_DESC"] = [[Этот модуль будет выводить список выпавшей добычи при открытии окна добычи.
Вывод осуществляется только если Вы лидер, помощник или ответственный за добычу или при зажатии левой клавиши control при осмотре трупа для принудительного вывода.]]
L["AUTOANNOUNCE_DESC"] = "When enabled, will automatically announce the loot when the loot window opens.\n\n|cffFF0000Note:|r Raid Lead, Assist, & Master Looter Only."
L["LOOTH_DESC"] = "These are options for tweaking the Loot Roll History window."

--Nameplates--

--Minimap--
L['MINIMAP_DESC'] = "Эти опции влияют на различные функции миникарты.  Некоторые опции погут не работать, если вы отключите миникарты в основных настройках ElvUI."


--Enhanced Vehicle Bar--


--Mover groups
L["S&L: All"] = "S&L: Все"
L["S&L: Datatexts"] = "S&L: Инфо-тексты"
L["S&L: Backgrounds"] = "S&L: Фоновые фреймы"
L["S&L: Misc"] = "S&L: Прочее"



--Raid Utility--


--Skins--


--Tooltip--
L["TTOFFSET_DESC"] = "This adds the ability to have the tooltip offset from the cursor.  Make sure to have the \"Cursor Anchor\" option enabled in ElvUI's Tooltip section to use this feature."

--UI buttons--
L["UB_DESC"] = "This adds a small bar with some useful buttons which acts as a small menu for common things."


--Unitframes--


--Links--
L["LINK_DESC"] = [[Сылки ниже ведуть на страницы Shadow & Light на различных сайтах.]]


--Credits--
L["ELVUI_SLE_CREDITS"] = "Мы бы хотели отметить следующих людей, которые помогли нас сделать этот аддон посредством тестирования, кода и прочего."
L["ELVUI_SLE_MISC"] = [=[BuG - за то, что он француз :D
TheSamaKutra
Сообщество TukUI
]=]

--Tutorials--

--Movers--
