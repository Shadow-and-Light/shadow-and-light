--Russian localization
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "ruRU")

if not L then return; end

--Tutorial--
L["To enable full values of health/power on unitframes in Shadow & Light add \":sl\" to the end of the health/power tag.\nExample: [health:current:sl]."] = "Чтобы включить отображение полного значения здоровья/ресурса при использовании Shadow & Light, нужно добавить \":sl\" в конец нужного тэга.\nПример: [health:current:sl]."

--Movers--
L["S&L: All"] = "S&L: Все"
L["S&L: Datatexts"] = "S&L: Инфо-тексты"
L["S&L: Backgrounds"] = "S&L: Фоновые фреймы"
L["S&L: Misc"] = "S&L: Прочее"

--General--
L["SLE_LOGIN_MSG"] = [=[Вы используете редакцию ElvUI под названием |cff1784d1"Shadow & Light"|r версия |cff1784d1%s%s|r.
Если вы хотите использовать оригинальный ElvUI, просто отключите плагин этой редакции в вашем менеджере аддонов.
Приятной игры.]=]
L["SLE_DESC"] = [=[Это редакция ElvUI добавляет некоторые новые функции к оригинальному аддону и изменяет функционал некоторых старых опций.
Эта редакция ни в коем виде не изменяет оригинальные файлы, так что вы можете спокойно отключить ее в вашем менеджере аддонов по желанию.]=]
L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."] = "Плагин для |cff1784d1ElvUI|r  от\nDarth Predator'а и Repooc'а"
L['MSG_OUTDATED'] = "Ваша версия ElvUI старее, чем рекомендованная для использования с Shadow & Light. У Вас версия |cff1784d1%.2f|r (рекомендованая |cff1784d1%.2f|r). Пожалуйста, обновите ElvUI."
L["Reset these options to defaults"] = "Восстановить умолчания для этих опций"
L["Reset All"] = "Сбросить все"
L["Resets all movers & options for S&L."] = "Сбросить все фиксаторы и опции S&L"

--Chat--
L["Reset Chat History"] = "Сбросить историю чата"
L["Clears your chat history and will reload your UI."] = "Очищает историю сохраненных сообщений в чате и перезагружет интерфейс."
L["Reset Editbox History"] = "Сбросить введенное"
L["Clears the editbox history and will reload your UI."] = "Очищает историю введенных сообщений и перезагружает интерфейс."
L["Chat Editbox History"] = "История ввода"
L["The amount of messages to save in the editbox history.\n\n|cffFF0000Note:|r To disable, set to 0."] = "Количество сообщений, введенных вами, которое будет сохранено между сеансами.\n\n|cffFF0000Напоминание:|r Для отключения, установите на 0."
L["Guild Master Icon"] = "Иконка Главы гильдии"
L["Displays an icon near your Guild Master in chat.\n\n|cffFF0000Note:|r Some messages in chat history may disappear on login."] = "Отображает иконку рядом с сообщениями главы вашей гильдии в чате.\n\n|cffFF0000Предупреждение:|r Некоторые сообщения в истории чата в истории чата могут исчезать при входе в игру."

--Install--
L["SLE_Install_Text2"] = [=[Этот шаг опционален и должен использоваться только в случае, если Вы хотите использовать одну из наших конфигураций. 
|cffFF0000Внимание:|r Пожалуйста помните, что авторы могут не использовать тему/роль, которую вы выбрали, и потому результат не всегда будет хорошим.]=]

--Auras--
L["Options for customizing auras near the minimap."] = "Опции для настройки аур около миникарты"
L["Hide Buff Timer"] = "Спрятать таймеры баффов"
L["This hides the time remaining for your buffs."] = "Скрывает текст оставшегося времени действия около баффов"
L["Hide Debuff Timer"] = "Спрятать таймеры дебаффов"
L["This hides the time remaining for your debuffs."] = "Скрывает текст оставшегося времени действия около дебаффов"

--Autoreleas--
L["PvP Auto Release"] = "Автоматический выход из тела"
L["Automatically release body when killed inside a battleground."] = "Автоматически выходить из тела на полях боя."

--Backgroungds--
L["Backgrounds"] = "Фоновые фреймы"
L["Additional Background Panels"] = "Дополнительные фоновые фреймы"
L["BG_DESC"] = "Модуль для создания дополнительных фреймов, которые могут использоваться в качестве фонов для чего-нибудь."
L["Show/Hide this frame."] = "Показать/скрыть этот фрейм."
L["Bottom BG"] = "Нижний фон"
L["Left BG"] = "Левый фон"
L["Right BG"] = "Правый фон"
L["Actionbar BG"] = "Верхний фон"
L["Sets width of the frame"] = "Устанавливает ширину фрейма"
L["Sets height of the frame"] = "Устанавливает высоту фрейма"
L["Sets X offset of the frame"] = "Устанавливает смещение по оси X"
L["Sets Y offset of the frame"] = "Устанавливает смещение по оси Y"
L["Texture"] = "Текстура"
L["Set the texture to use in this frame.  Requirements are the same as the chat textures."] = "Устанавливает текстуру этого фрейма. Требования к текстуре такие же, как для текстур чата."
L["Backdrop Template"] = "Тип фона"
L["Change the template used for this backdrop."] = "Измените шаблон, используемый при создании этого фона"
L["Default"] = "Обычный"
L["Hide in Pet Batlle"] = "Прятать в битвах питомцев"
L["Show/Hide this frame during Pet Battles."] = "Показать/скрыть этот фрейм в битвах питомцев"

--Character Frame Options--
L["Enable/Disable Character Frame Options"] = "Включить/выключить окно персонажа"
L["Enable/Disable Inspect Frame Options"] = "Включить/выключить окно осмотра"
L['The character frame and inspect frame have been redone and are still very much in beta.  Some fields are disabled because the options are not fully implemented and working just yet.  They will be re-enabled in future releases once we fix the issues.'] = "Окно персонажа и окно осмотра были переделаны и все еще находятся в ранней бете. Некоторые опции отключены, потому как еще не полностю работают. Они будут активированы в будущих версиях."
L["CFO_DESC"] = "Дополнительные опции окна персонажа.  Вы можете включить отображение уровня и прочности предметов."
L['IFO_DESC'] = "Этот раздел отключает стандартное окно осмота и использует собственное окно S&L. Пожалуйста, помните, что функция находится в стадии беты и может причинять проблемы. Дополнительные опции появятся в следующих версиях."
L["Character Frame Options"] = "Настройки окна персонажа"
L["Decoration"] = "Украшения"
L["Show Equipment Gradients"] = "Градиент экипировки"
L["Shows gradient effect for all equipment slots."] = "Показывать эффект градиента для всех ячеек экипировки."
L["Show Error Gradients"] = "Градиент ошибок"
L["Highlights equipment slot if an error has been found."] = "Подсвечивать слот, требующий улучшения, другим цветом."
L["Show Background Image"] = "Фоновое изображение"
L['Background picture'] = "Фоновое изображение"
L["Custom"] = "Своя"
L['Font'] = "Шрифт"  --L['Fonts'] is localized in elvui but not Font
L["Show Item Level"] = "Показывать ур. предметов"
L["The font that the item level will use."] = "Шрифт уровня предметов."
L["Set the font size that the item level will use."] = "Размер шрифта уровня предметов."
L["Set the font outline that the item level will use."] = "Граница шрифта уровня предметов."
L["Show Durability"] = "Показывать прочность"
L["The font that the item durability will use."] = "Шрифт прочности предметов."
L["Set the font size that the item durability will use."] = "Размер шрифта прочности предметов."
L["Set the font outline that the item durability will use."] = "Граница шрифта прочности предметов."
L["Enchanting"] = "Зачарование"
L["Show Enchants"] = "Текст чар"
L["Show the enchantment effect near the enchanted item (not the item itself) when mousing over."] = "Показывать эффект чар около предмета при наведении курсора в ту область."
L["Show the enchantment effect near the enchanted item"] = "Показывать наложенные чары рядом с предметом"
L["Show Warning"] = "Предупреждения"
L["Warning Size"] = "Размер предупредений"
L["Set the icon size that the warning notification will use."] = "Размер иконки, используемой предупреждением."
L["The font that the enchant notification will use."] = "Шрифт оповещения о чарах."
L["Set the font size that the enchant notification will use."] = "Размер шрифта оповещения о чарах."
L["Set the font outline that the enchant notification will use."] = "Граница шрифта оповещения о чарах"
L["Gem Sockets"] = "Слоты для камней"
L["Show Gems"] = "Показывать камни"
L["Show gem slots near the item"] = "Показывать слоты для камней около предмета"
L["Socket Size"] = "Размер слотов"
L["Set the size of sockets to show."] = "Размер отображаемых слотов для камней."

--Character Frame--
L["Armory Mode"] = "Оружейная"
L["Not Enchanted"] = "Нет чар"
L['Missing Tinkers'] = "Нет усиления"
L['This is not profession only.'] = "Не усиление от профессии"
L['Missing Buckle'] = "Нет пряжки"
L['Missing Socket'] = "Нет гнезда"
L['Empty Socket'] = "пустое гнездо"
L['Average'] = "Средний ур. предметов"
L["Inspect Frame Options"] = "Опции окна осмотра"

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

--Equip Manager--
L["EM_DESC"] = "Этот модуль предоставляет различные опции для автоматической смены комплектов экипировки при переключении набора талантов или попадании в определенную локацию."


--Farm--
L["FARM_DESC"] = [[Дополнительные панели с семенами, инструментами и порталами для Фермы Солнечной Песни.
Они будут отображаться только если Вы находитесь на ферме или рынке Полугорья.]]


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

--Tooltip--
L["TTOFFSET_DESC"] = "This adds the ability to have the tooltip offset from the cursor.  Make sure to have the \"Cursor Anchor\" option enabled in ElvUI's Tooltip section to use this feature."

--UI buttons--
L["UB_DESC"] = "This adds a small bar with some useful buttons which acts as a small menu for common things."

--Links--
L["LINK_DESC"] = [[Сылки ниже ведуть на страницы Shadow & Light на различных сайтах.]]


--Credits--
L["Submodules and Coding:"] = "Субмодули и помощ с кодом:"
L["Other Support:"] = "Прочая поддержка:"
L["ELVUI_SLE_CREDITS"] = "Мы бы хотели отметить следующих людей, которые помогли нас сделать этот аддон посредством тестирования, кода и прочего."
L["ELVUI_SLE_MISC"] = [=[BuG - за то, что он француз :D
TheSamaKutra
Сообщество TukUI
]=]