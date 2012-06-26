local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "ruRU")
if not L then return; end


L['DPE_LOGIN_MSG'] = [=[Вы используете редакцию ElvUI от Darth Predator'а.
Если вы хотите использовать оригинальный ElvUI, просто отключите плагин этой редакции в вашем менеджере аддонов.
Приятной игры.]=]
---------------
--Main config--
---------------
L["Darth Predator's Edit"] = "Редакция Darth Predator'а"
L["Darth Predator's edit of ElvUI"] = "Редакция ElvUI от Darth Predator'а"
L['DPE_DESC'] = [=[Это плагин для изменения ElvUI в соответствии с моими вкусами. Для максимально полного и комфортного использования желательно наличие разрешения 1920х1080.

Данный плагин не изменяет изначальные фалы ElvUI, так что его отключение или удаление не повлечет за собой никаких последствий для основного аддона.
]=]

--LFR Lockdown
L["LFR Dragon Soul"] = "Душа Дракона ЛФР"
L['LFR Lockdown'] = "Состояние ЛФР"
L["Show/Hide LFR lockdown info in time datatext's tooltip."] = "Отображать/скрывать информацию о сохранении ЛФР"

--PvP Autorelease
L["PvP Auto Release"] = "Автоматический выход из тела"
L['Automatically release body when killed inside a battleground.'] = "Автоматически выходить из тела на полях боя."

--Auras
L['Aura Size'] = "Размер баффов"
L['Sets size of auras. This setting is character based.'] = "Устанавливает размер баффов в фрейме Blizzard. Эта настройка уникальна для персонажа"

--Pet Autocast
L["Pet autocast corners"] = "Автокаст питомца"
L['Show/hide tringles in corners of autocastable buttons.'] = "Показать/скрыть треугольники в углах кнопок с автоматически применяемыми заклинаниями питомца."

--------------
--UnitFrames--
--------------
L["Additional unit frames options"] = "Дополнительные опции рамок юнитов"
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = "Опции для дополнительной настройки рамок юнитов. Пожалуйста, не изменяйте эти настройки в то же время, кода включен тестовый режим рамок боссов и арены в ElvUI. Это сделает их невидимыми до повторного включения."
L["Health Values"] = "Значения здоровья"
L["Full value"] = "Полные значения"
L["Enabling this will show exact hp numbers on player, focus, focus target, target of target, party, boss, arena and raid frames."] = "Отобразить точное значение здоровья на рамках игрока, фокуса, цели фокуса, цели цели, боссов, арены, группы и рейда."
L["Target full value"] = "Полное значение у цели"
L["Enabling this will show exact hp numbers on target frame."] = "Отобразить точное значение здоровья цели"
L["Power Values"] = "Значения ресурса"
L["Normal Frames"] = "Нормальные рамки"
L["Enabling this will show exact power numbers on target of target, focus and focus target frames."] = "Отобразить точное значение ресурса для цели цели, фокуса и цели фокуса."
L["Reversed Frames"] = "Обратные рамки"
L["Enabling this will show exact power numbers on player, boss, arena, party and raid frames."] = "Отобразить точное значение ресурса для игрока, боссов, арены, группы и рейда"

--Player Frame Indicators
L["Player Frame Indicators"] = "Индикаторы игрока"
L["PvP text on mouse over"] = "ПвП текст при наведении"
L['Show PvP text on mouse over player frame.'] = "Отображать ПвП текст при наведении мыши на фрейм игрока. При отключении будет отображаться всегда."
L["PvP Position"] = "Позизия PvP"
L['Set the point to show pvp text'] = "Устанавливает позицию индикатора ПвП."
L["Combat Position"] = "Иконка боя"
L['Set the point to show combat icon'] = "Устанавливает позицию индикатора боя."

--Classbar offset
L["Classbar Offset"] = "Отступ полосы класса"
L["This options will allow you to detach your classbar from player's frame and move it in other location."] = "Эти опции позволят вам открепить полосу класса от рамки игрока и передвинуть ее в другое место."

----------------
--Exp/Rep Text--
----------------
L["Xp-Rep Text"] = "Текст Опыта/Репутации"
L["XP-Rep Text mod by Benik"] = "Мод текста опыта/репутации от Benik"
L['Show/Hide XP-Rep Info.'] = "Показать/скрыть текст на полосах."
L['Detailed'] = "Подробно"
L['More XP-Rep Info. Shown only when bars are on top.'] = "Более подробная информация в тексте. Отображается только при нахождении полос в верху экрана."
L["Detailed options"] = "Опции подробного текста"
L['Reaction Name'] = "Реакция"
L['Show/Hide Reaction status on bar.'] = "Отображает статус реакции на полосе в виде текста."
L['Rested Value'] = "Бодрость"
L['Show/Hide Rested value.'] = "Показать/скрыть значение бодрости."

--------------
--UI Buttons--
--------------
L["UI Buttons"] = "Меню интерфейса"
L["Additional menu with useful buttons"] = "Дополнительное меню с полезными кнопками"
L["Show/Hide UI buttons."] = "Показать/скрыть меню"
L["Mouse over"] = "При наведении"
L["Show on mouse over."] = "Отображать при наведении мыши."
L["Buttons position"] = "Положение кнопок"
L["Layout for UI buttons."] = "Режим положения кнопок"

L["ElvUI Config"] = "Настройка ElvUI"
L["Click to toggle config window"] = "Нажмите для отображения окна настроек"
L["Reload UI"] = "Перезагрузить интерфейс"
L["Click to reload your interface"] = "Нажмите для перезагрузки интерфейса"
L["Move UI"] = "Разблокировать элементы"
L["Click to unlock moving ElvUI elements"] = "Нажмите для входа в режим перемещения элементов"
L["Boss Mod"] = "Босс мод"
L["Click to toogle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."] = "Нажмите для отображения окна настроек включенного босс мода. Поддерживаются DXE, DBM, Bigwigs."
L["AddOns Manager"] = "Менеджер аддонов"
L["Click to toogle the AddOn Managerframe (stAddOnManager or ACP) you have enabled."] = "Нажмите для отображения окна менеджера аддонов. Поддерживаются stAddOnManager, ACP"

------------
--Microbar--
------------
L["2 rows"] = "В 2 ряда"
L["3 rows"] = "В 3 ряда"
L["4 rows"] = "В 4 ряда"
L["6 rows"] = "В 6 рядов"
L["Change the positioning of buttons on Microbar."] = "Изменяет позиционирование кнопок в микроменю."
L["Hide in Combat"] = "Скрывать в бою"
L["Hide Microbar in combat."] = "Скрывать микроменю в бою."
L["Hide microbar unless you mouse over it."] = "Показывать меню при наведении курсора."
L["Microbar"] = "Микроменю"
L["Microbar Layout"] = "Вид Микроменю"
L["Module for adding micromenu to ElvUI."] = "Модуль для добавления микроменю в ElvUI."
L["On Mouse Over"] = "При наведении"
L["Positioning"] = "Позиционирование"
L["Set Alpha"] = "Прозрачность"
L["Sets alpha of the microbar"] = "Устанавливает прозрачность меню"
L["Set Scale"] = "Масштаб"
L["Sets Scale of the microbar"] = "Устанавливает масштаб микроменю"
L["Sets X offset for microbar buttons"] = "Устанавливает отступ кнопок микроменю по оси Х"
L["Sets Y offset for microbar buttons"] = "Устанавливает отступ кнопок микроменю по оси Y"
L["Show backdrop for micromenu"] = "Показывать фон микроменю"

--------------
--Raid Marks--
--------------
L["Raid Marks"] = "Рейдовые Метки"
L["Show/Hide raid marks."] = "Показать/скрыть фрейм рейдовых меток."
L['Sets size of buttons'] = "Устанавливает размер кнопок"
L["Direction"] = "Направление"
L['Change the direction of buttons growth from "skull" mark'] = 'Изменяет направление роста кнопок от метки "череп".'

-------------
--Datatexts--
-------------
L["Datatext panels"] = "Панели инфо-текстов"
L["Additional Datatext Panels"] = "Дополнительные панели инфо-текстов"
L["DP_DESC"] = [=[Дополнительные панели под информационные тексты.
Всего здесь 8 дополнительных панелей и 20 дополнительных слотов под инфо-тексты.
Верхнюю панель отключить нельзя, ровно как и панели на чатах.]=]
L["DP_1"] = "Панель 1"
L["DP_2"] = "Панель 2"
L["Top_Center"] = "Верхняя панель"
L["DP_3"] = "Панель 3"
L["DP_4"] = "Панель 4"
L["DP_5"] = "Панель 5"
L["Bottom_Panel"] = "Нижняя панель"
L["DP_6"] = "Панель 6"
L["Left Chat"] = "Левый чат"
L["Right Chat"] = "Правый чат"
L['Show/Hide this panel.'] = "Показать/скрыть эту панель."
L['Sets size of this panel'] = "Установить ширину панели"

---------
--Skins--
---------
L["Sets font size on DBM bars"] = "Устанавливает размер текста на полосах DBM"
L["Skada Backdrop"]= "Фон Skada"
L['Show/Hide Skada backdrop.'] = "Показать/скрыть фон окон аддона Skada."

--------
--Chat--
--------
L["Chat options"] = "Настройки чата"
L["Chat Fade"] = "Затухание чата"
L["Enable/disable the text fading in the chat window."] = "Включит/выключить постепенное исчезновение строк чата со временем."
L["Chat Editbox History"] = "История чата"
L["Amount of messages to save. Set to 0 to disable."] = "Количество сообщений, введенных вами, которое будет сохранено между сеансами"
L["Name Highlight"] = "Выделение имени"
L["TOON_DESC"] = [=[Опции подсветки и звукового предупреждения, если кто-то называет ваше имя в чате. 
У каждого персонажа индивидуальное хранилище имен, так что вы можете иметь разные наборы на каждом из них.
Имя вашего текущего персонажа будет отслеживаться автоматически.]=]
L["Enable sound"] = "Включить звук"
L["Play sound when your name is mentioned in chat."] = "Проигрывать звук, когда ваше имя появляется в чате"
L["Sound that will play when your name is mentioned in chat."] = "Звук, который будет проигрываться, когда ваше имя появляется в чате"
L['Timer'] = "Таймер"
L['Sound will be played only once in this number of seconds.'] = "Звук будет проигрываться только единожды за установленный промежуток времени"
L["Add a name different from your current character's to be looked for"] = "Добавьте в список имя отличное от имени вашего текуущего персонажа для отслеживания в чате."
L['Invalid name entered!'] = "Неверное имя!"
L['Name already exists!'] = "Такое имя уже существует!"
L['Names list'] = "Список имен"
L["You can delete selected name from the list here by clicking the button below"] = "Здесь вы можете удалить выбранное имя из списка, нажав на кнопку ниже."
L["Delete this name from the list"] = "Удалить это имя из списка"
L["Channels"] = "Каналы"
L["Enable/disable checking of this channel."] = "Включить/выключить проверку этого канала"
L["Defense"] = "Оборона"
L['LFG'] = "Поиск спутников"
L['Add channel'] = "Добавить канал"
L['Invalid channel entered!'] = "Неверное имя канала!"
L['Channel already exists!'] = "Такой канал уже существует!"
L["Add a custom channel name."] = "Добавить имя пользовательского канала."
L['Channels list'] = "Список каналов"
L["You can delete selected channel from the list here by clicking the button below"] = "Здесь вы можете удалить выбранный канал из списка, нажав на кнопку ниже."
L["Remove Channel"] = "Удалить канал"
L["Delete this channel from the list"] = "Удалить этот канал из списка"

---------------
--Backgrounds--
---------------
L["Backgrounds"] = "Фоновые фреймы"
L["Additional Background Panels"] = "Дополнительные фреймы для фонов"
L["BG_DESC"] = "Модуль для создания дополнительных фреймов, которые могут использоваться в качестве фонов для чего-нибудь."
L["Bottom BG"] = "Нижний фон"
L["Left BG"] = "Левый фон"
L["Right BG"] = "Правый фон"
L["Actionbar BG"] = "Верхний фон"
L['Show/Hide this frame.'] = "Показать/скрыть этот фрейм."
L['Sets width of the frame'] = "Устанавливает ширину фрейма"
L['Sets height of the frame'] = "Устанавливает высоту фрейма"
L['Sets X offset of the frame'] = "Устанавливает смещение по оси X"
L['Sets Y offset of the frame'] = "Устанавливает смещение по оси Y"
L["Texture"] = "Текстура"
L["Set texture to use in this frame. Requirements are the same as for the chat textures."] = "Устанавливает текстуру этого фрейма. Требования к текстуре такие же, как для текстур чата."

----------------
--Raid Utility--
----------------
L["Raid Utility"] = "Управление рейдом"
L["Raid Utility coordinates"] = "Позиция Управления Рейдом"
L["RU_DESC"] = [=[Эти опции позволяют вам свободно перемещать кнопку Управления Рейдом.
Передвижение кнопки при поможи мыши отключено. Для задания положения используйте бегунки ниже.]=]
L['X Position'] = "Позиция X"
L['Sets X position of Raid Utility button.'] = "Задает координаты Управления рейдом по оси X."
L['Y Position'] = "Позиция Y"
L['Sets Y position of Raid Utility button.'] = "Задает координаты Управления рейдом по оси Y."

-----------------------
--Balance Power Frame--
-----------------------
L["Druid"] = "Друид"
L["Druid spesific options"] = "Настройки для друидов"
L["Balance Power Frame"] = "Фрейм Энергии Баланса"
L["Show/hide the frame with exact number of your Solar/Lunar energy."] = "Показать/скрыть фрейм с точным значением Лунной/Солнечной энергии."

-----------
--Credits--
-----------
L['ELVUI_DPE_CREDITS'] = "Я бы хотел отметить следующих людей, которые помогли мне сделать этот аддон посредством тестирования, кода и прочего."
L['Submodules and coding:'] = "Субмодули и кодинг:"
L['ELVUI_DPE_CODERS'] = [[Benik - ядро функции текста полос опыта/репутации
Repooc - ядро функции автоматического выхода из тела, несколько идей, тестирование
Tukz - помощь с oUF
Elv - значительное облегчение создания редакции
Pvtschlag - плагин Necrotic Strike для oUF
Blazeflack - помощь с хуками, модулями и профилями
Camealion - обучение меня созданию скинов
Swordyy - идея меню интерфейса
Azilroka@US-Daggerspine - ядро скинов для ExtVendor и Altoholic
Pat - скины меню и опций, пропущенных Элвом
Boradan - идея перемещения полос класса
Hydra - базовый код функции подсветки имени
]]
L['Other support:'] = "Прочая поддержка:"
L['ELVUI_DPE_MISC'] = [[BuG - веселье в чате, пока я писал это все
TheSamaKutra - пара хороших идей
Соббщество TukUI - просто тем, что оно есть 
Моя гильдия, Эффект@Свежеватель Душ - не выперли меня пока я нагло слакал :D
]]
L["DPE_AUTHOR_INFO"] = "Редакция от Darth Predator (Дартпредатор@Свежеватель Душ)"
L["DPE_CONTACTS"] = [=[При возникновении вопросов, предложений и прочего обращаться:
- Игровая почта
- Личное сообщение на форуме TukUI, ник Darth Predator
- Сайт Shadowmage.ru]=]