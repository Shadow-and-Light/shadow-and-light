--Russian localization
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "ruRU")

if not L then return; end

--General--
L["Shadow & Light Edit"] = "Редакция Тень и Свет"
L["Shadow & Light Edit of ElvUI"] = "Редакция Тень и Свет для ElvUI"
L["SLE_DESC"] = [=[Это редакция ElvUI добавляет некоторые новые функции к оригинальному аддону и изменяет функционал некоторых старых опций.
Эта редакция ни в коем виде не изменяет оригинальные файлы, так что вы можете спокойно отключить ее в вашем менеджере аддонов по желанию.]=]
L["LFR Lockdown"] = "Состояние ЛФР"
L["Show/Hide LFR lockdown info in time datatext's tooltip."] = "Отображать/скрывать информацию о сохранении ЛФР"
L["PvP Auto Release"] = "Автоматический выход из тела"
L["Automatically release body when killed inside a battleground."] = "Автоматически выходить из тела на полях боя."
L["Errors in combat"] = "Ошибки в бою"
L["Show/hide error messages in combat."] = "Показать/скрыть сообщения об ошибках в бою"
L["Pet autocast corners"] = "Автокаст питомца"
L["Show/hide triangles in corners of autocastable buttons."] = "Показать/скрыть треугольники в углах кнопок с автоматически применяемыми заклинаниями питомца."
L["Loot History"] = "История добычи"
L["Auto hide"] = "Автоматически скрывать"
L["Automaticaly hide Blizzard loot histroy frame when leaving the instance."] = "Автоматически скрывать окно истории добычи Blizzard при выходе из подземелья."
L["Sets alpha of loot histroy frame."] = "Устанавливает прозрачность окна истории добычи"
L["SLE_LOGIN_MSG"] = [=[Вы используете редакцию ElvUI под названием |cff1784d1"Тень и Свет"|r.
Если вы хотите использовать оригинальный ElvUI, просто отключите плагин этой редакции в вашем менеджере аддонов.
Приятной игры.]=]
L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."] = "Ваша версия ElvUI старее, чем рекомендованная для использования с редакцией Тень и Свет. Пожалуйста, скачайте последнюю версию с tukui.org."

--Install--
L["Shadow & Light Settings"] = "Установки Тени и Света"
L["You can now choose if you what to use one of authors' set of options. This will change the positioning of most elements but also change a bunch of other options within ElvUI's config."] = "Вы можете выбрать использование одного из набора конфигурации от авторов. Это изменит не только расположение ваших рамок и панелей, но и некоторого количества других опций."
L["SLE_Install_Text2"] = [=[Этот шаг опционален и должен использоваться только в случае, если Вы хотите использовать одну из наших конфигураций. 
|cffFF0000Внимание:|r Пожалуйста помните, что авторы могут не использовать тему/роль, которую вы выбрали, и потому результат не всегда будет хорошим.]=]
L["Darth's Config"] = "Опции Darth'а"
L["Darth's Defaults Set"] = "Установлены настройки Darth'а"
L["Repooc's Config"] = "Опции Repooc'а"
L["Repooc's Defaults Set"] = "Установлены настройки Repooc'а"

--Auras--
L["Options for customizing auras near the minimap."] = "Опции для настройки аур около миникарты"
L["Caster Name"] = "Имя заклинателя"
L["Enabling this will show caster name in the buffs and debuff icons."] = "При включении будет отображать в подсказке к ауре имя того, кто наложил ее"

--Backgroungds--
L["Backgrounds"] = "Фоновые фреймы"
L["Additional Background Panels"] = "Дополнительные фреймы для фонов"
L["BG_DESC"] = "Модуль для создания дополнительных фреймов, которые могут использоваться в качестве фонов для чего-нибудь."
L["Bottom BG"] = "Нижний фон"
L["Left BG"] = "Левый фон"
L["Right BG"] = "Правый фон"
L["Actionbar BG"] = "Верхний фон"
L["Show/Hide this frame."] = "Показать/скрыть этот фрейм."
L["Sets width of the frame"] = "Устанавливает ширину фрейма"
L["Sets height of the frame"] = "Устанавливает высоту фрейма"
L["Sets X offset of the frame"] = "Устанавливает смещение по оси X"
L["Sets Y offset of the frame"] = "Устанавливает смещение по оси Y"
L["Texture"] = "Текстура"
L["Set the texture to use in this frame.  Requirements are the same as the chat textures."] = "Устанавливает текстуру этого фрейма. Требования к текстуре такие же, как для текстур чата."
L["Backdrop Template"] = "Тип фона"
L["Change the template used for this backdrop."] = "Измените шаблон, используемый при создании этого фона"
L["Default"] = "Обычный"
L["Transparent"] = "Прозрачный"
L["Hide in Pet Batlle"] = "Прятать в битвах питомцев"
L["Show/Hide this frame during Pet Battles."] = "Показать/скрыть этот фрейм в битвах питомцев"

--Chat--
L["Chat Options"] = "Настройки чата"
L["Chat Editbox History"] = "История чата"
L["Amount of messages to save. Set to 0 to disable."] = "Количество сообщений, введенных вами, которое будет сохранено между сеансами"

--Datatexts--
L["LFR Dragon Soul"] = "Душа Дракона ЛФР"
L["LFR Mogu'shan Vaults"] = "Подземелья Могу'шан ЛФР"
L["LFR Heart of Fear"] = "Сердце Страха ЛФР"
L["LFR Terrace of Endless Spring"] = "Терраса Вечной Весны ЛФР"
L["Bosses killed: "] = "Боссов убито: "
L["SLE_AUTHOR_INFO"] = "Редакция \"Тень и Свет\" от Darth Predator и Repooc"
L["SLE_CONTACTS"] = [=[При возникновении вопросов, предложений и прочего обращаться:
- Личное сообщение на форуме TukUI (tukui.org), ник Darth Predator или Repooc
- Страница/система тикетов на curse.com
- Тема аддона на tukui.org
- Репозиторий проекта на github.com]=]
L["DP_1"] = "Панель 1"
L["DP_2"] = "Панель 2"
L["DP_3"] = "Панель 3"
L["DP_4"] = "Панель 4"
L["DP_5"] = "Панель 5"
L["DP_6"] = "Панель 6"
L["Bottom_Panel"] = "Нижняя панель"
L["Top_Center"] = "Верхняя панель"
L["Left Chat"] = "Левый чат"
L["Right Chat"] = "Правый чат"
L["Datatext Panels"] = "Панели инфо-текстов"
L["Additional Datatext Panels"] = "Дополнительные панели инфо-текстов"
L["DP_DESC"] = [=[Дополнительные панели под информационные тексты.
Всего здесь 8 дополнительных панелей и 20 дополнительных слотов под инфо-тексты, а также панель состояния с 4мя индикаторами.
Панели на чатах отключить нельзя.]=]
L["Dashboard"] = "Панель состояния"
L["Show/Hide dashboard."] = "Показать/скрыть панель состояния."
L["Dashboard Panels Width"] = "Ширина панелей"
L["Sets size of dashboard panels."] = "Устанавливает размер полос панели состояния."
L["Show/Hide this panel."] = "Показать/скрыть эту панель."
L["Sets size of this panel"] = "Установить ширину панели"

--Exp/Rep Bar--
L["Xp-Rep Text"] = "Текст Опыта/Репутации"
L["Full value on Exp Bar"] = "Полное значение опыта"
L["Changes the way text is shown on exp bar."] = "Изменяет отображение значений опыта на полосе."
L["Full value on Rep Bar"] = "Полное значение репутации"
L["Changes the way text is shown on rep bar."] = "Изменяет отображение значений репутации на полосе."

--Marks--
L["Raid Marks"] = "Рейдовые Метки"
L["Show/Hide raid marks."] = "Показать/скрыть фрейм рейдовых меток."
L["Show only in instances"] = "Только в подземельях"
L["Selecting this option will have the Raid Markers appear only while in a raid or dungeon."] = "При активации будет отображать полосу меток только в подземельях и рейдах."
L["Sets size of buttons"] = "Устанавливает размер кнопок" --Also used in UI buttons
L["Direction"] = "Направление"
L["Change the direction of buttons growth from the skull marker"] = "Изменяет направление роста кнопок от метки \"череп\"."

--Raid Utility--
L["Raid Utility"] = "Управление рейдом"
L["Raid Utility Coordinates"] = "Позиция Управления Рейдом"
L["RU_DESC"] = [=[Эти опции позволяют вам свободно перемещать кнопку Управления Рейдом.
Передвижение кнопки при помощи мыши отключено. Для задания положения используйте бегунки ниже.]=]
L["X Position"] = "Позиция X"
L["Y Position"] = "Позиция Y"
L["Sets X position of Raid Utility button."] = "Задает координаты Управления рейдом по оси X."
L["Sets Y position of Raid Utility button."] = "Задает координаты Управления рейдом по оси Y."
L["Show Button"] = "Показать кнопку"
L["Show/hide Raid Utility button.\nThis option is not permanent. The button will act as normal when joining/leaving groups."] = "Показать/скрыть кнопку управления рейдом.\nОпция не постоянная. Кнопка быдет действовать в соответствии с нормлй при вступлении в группу, а также при выходе из нее."

--Skins--
L["This options require Azilroka's skin pack to work."] = "Эти опции требуют наличие пака скинов от Azilroka для работы"
L["Sets font size on DBM bars"] = "Устанавливает размер текста на полосах DBM"
L["Ground"] = "Наземные"
L["Flying"] = "Летающие"
L["Flying & Ground"] = "Наземные и Летающие"
L["Swimming"] = "Водные"

--UI buttons--
L["UI Buttons"] = "Меню интерфейса"
L["Additional menu with useful buttons"] = "Дополнительное меню с полезными кнопками"
L["Show/Hide UI buttons."] = "Показать/скрыть меню"
L["Mouse over"] = "При наведении"
L["Show on mouse over."] = "Отображать при наведении мыши."
L["Buttons position"] = "Положение кнопок"
L["Layout for UI buttons."] = "Режим положения кнопок"
L["Click to reload your interface"] = "Нажмите для перезагрузки интерфейса"
L["Click to toggle config window"] = "Нажмите для отображения окна настроек"
L["Click to toggle the AddOn Manager frame (stAddOnManager, Ampere or ACP) you have enabled."] = "Нажмите для отображения окна менеджера аддонов. Поддерживаются stAddOnManager, ACP, Ampere"
L["Click to toggle the Configuration/Option Window from the Bossmod (DXE, DBM or Bigwigs) you have enabled."] = "Нажмите для отображения окна настроек включенного босс мода. Поддерживаются DXE, DBM, Bigwigs."
L["Click to unlock moving ElvUI elements"] = "Нажмите для входа в режим перемещения элементов"
L["ElvUI Config"] = "Настройка ElvUI"
L["Move UI"] = "Разблокировать элементы"
L["Reload UI"] = "Перезагрузить интерфейс"
L["AddOns Manager"] = "Менеджер аддонов"
L["Boss Mod"] = "Босс мод"
L["Click to toggle iFilger's config UI"] = "Нажмите для отображения настроек iFilger"

--Unitframes--
L["Additional unit frames options"] = "Дополнительные опции рамок юнитов"
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = "Опции для дополнительной настройки рамок юнитов. Пожалуйста, не изменяйте эти настройки в то же время, кода включен тестовый режим рамок боссов и арены в ElvUI. Это сделает их невидимыми до повторного включения."
L["Player Frame Indicators"] = "Индикаторы игрока"
L["Combat Icon"] = "Иконка боя"
L["Show/Hide combat icon on player frame."] = "Отображать/скрывать иконку в бою."
L["Combat Position"] = "Позиция иконки боя"
L["Set the point to show combat icon"] = "Устанавливает позицию индикатора боя."
L["Classbar Energy"] = "Текст энергии полосы класса"
L["Show/hide the text with exact number of energy (Solar/Lunar or Demonic Fury) on your Classbar."] = "Показать/скрыть текст с точным значением энергии (Лунной/Солнечной или Демонической Ярости) на полосе класса."
L["Classbar Offset"] = "Отступ полосы класса"
L["This options will allow you to detach your classbar from player's frame and move it in other location."] = "Эти опции позволят вам открепить полосу класса от рамки игрока и передвинуть ее в другое место."

--Credits--
L["ELVUI_SLE_CREDITS"] = "Мы бы хотели отметить следующих людей, которые помогли нас сделать этот аддон посредством тестирования, кода и прочего."
L["Submodules and Coding:"] = "Субмодули и кодинг:"
L["ELVUI_SLE_CODERS"] = [=[Elv
Tukz
Azilroka
Blazeflack
Boradan
Camealion
Pvtschlag
Sinaris
Swordyy
]=]
L["Other Support:"] = "Прочая поддержка:"
L["ELVUI_SLE_MISC"] = [=[BuG - за то, что он француз :D
TheSamaKutra
Сообщество TukUI
]=]

--Tutorials--
L["To enable full values of health/power on unitframes in Shadow & Light add \":sl\" to the end of the health/power tag.\nExample: [health:current:sl]."] = "Чтобы включить отображение полного значения здоровья/ресурса при использовании Тени и Света, нужно добавить \":sl\" в конец нужного тэга.\nПример: [health:current:sl]."

--Movers--
L["Pet Battle AB"] = "Панель боев питомцев"