--Russian localization
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "ruRU")

if not L then return; end

--General--
L["Shadow & Light"] = "Тень и Свет"
L["SLE_DESC"] = [=[Это редакция ElvUI добавляет некоторые новые функции к оригинальному аддону и изменяет функционал некоторых старых опций.
Эта редакция ни в коем виде не изменяет оригинальные файлы, так что вы можете спокойно отключить ее в вашем менеджере аддонов по желанию.]=]
L["LFR Lockout"] = "Состояние ЛФР"
L["Show/Hide LFR lockout info in the time datatext's tooltip."] = "Отображать/скрывать информацию о сохранении ЛФР"
L["PvP Auto Release"] = "Автоматический выход из тела"
L["Automatically release body when killed inside a battleground."] = "Автоматически выходить из тела на полях боя."
L["Pet autocast corners"] = "Автокаст питомца"
L["Show/hide triangles in corners of autocastable buttons."] = "Показать/скрыть треугольники в углах кнопок с автоматически применяемыми заклинаниями питомца."
L["Loot History"] = "История добычи"
L["Auto hide"] = "Автоматически скрывать"
L["Automaticaly hide Blizzard loot histroy frame when leaving the instance."] = "Автоматически скрывать окно истории добычи Blizzard при выходе из подземелья."
L["Sets alpha of loot histroy frame."] = "Устанавливает прозрачность окна истории добычи"
L["SLE_LOGIN_MSG"] = [=[Вы используете редакцию ElvUI под названием |cff1784d1"Тень и Свет"|r версия |cff1784d1%s%s|r.
Если вы хотите использовать оригинальный ElvUI, просто отключите плагин этой редакции в вашем менеджере аддонов.
Приятной игры.]=]
L["Your version of ElvUI is older than recommended to use with Shadow & Light Edit. Please, download the latest version from tukui.org."] = "Ваша версия ElvUI старее, чем рекомендованная для использования с редакцией Тень и Свет. Пожалуйста, скачайте последнюю версию с tukui.org."
L["Reset All"] = "Сбросить все"
L["Reset all Shadow & Light options and movers to their defaults"] = "Сбросить все настройки и фиксаторы редакции на умолчания"
L["Reset these options to defaults"] = "Восстановить умолчания для этих опций"

--Install--
L["Shadow & Light Settings"] = "Установки Тени и Света"
L["You can now choose if you what to use one of authors' set of options. This will change not only the positioning of some elements but also change a bunch of other options."] = "Вы можете выбрать использование одного из набора конфигурации от авторов. Это изменит не только расположение ваших рамок и панелей, но и некоторого количества других опций."
L["SLE_Install_Text2"] = [=[Этот шаг опционален и должен использоваться только в случае, если Вы хотите использовать одну из наших конфигураций. 
|cffFF0000Внимание:|r Пожалуйста помните, что авторы могут не использовать тему/роль, которую вы выбрали, и потому результат не всегда будет хорошим.]=]
L["Darth's Config"] = "Опции Darth'а"
L["Darth's Defaults Set"] = "Установлены настройки Darth'а"
L["Repooc's Config"] = "Опции Repooc'а"
L["Repooc's Defaults Set"] = "Установлены настройки Repooc'а"
L["Affinitii's Config"] = "Опции  Affinitii"
L["Affinitii's Defaults Set"] = "Установлены настройки Affinitii"

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
L["Hide in Pet Batlle"] = "Прятать в битвах питомцев"
L["Show/Hide this frame during Pet Battles."] = "Показать/скрыть этот фрейм в битвах питомцев"

--Character Frame Options--
L["CFO_DESC"] = "Дополнительные опции окна персонажа.  Вы можете включить отображение уровня и прочности предметов."
L["Character Frame Options"] = "Настройки окна персонажа"
L['Font'] = "Шрифт"  --L['Fonts'] is localized in elvui but not Font
L["The font that the item level will use."] = "Шрифт уровня предметов."
L["Set the font size that the item level will use."] = "Размер шрифта уровня предметов."
L["Set the font outline that the item level will use."] = "Граница шрифта уровня предметов."
L["The font that the item durability will use."] = "Шрифт прочности предметов."
L["Set the font size that the item durability will use."] = "Размер шрифта прочности предметов."
L["Set the font outline that the item durability will use."] = "Граница шрифта прочности предметов."

--Chat--
L["Chat Options"] = "Настройки чата"
L["Chat Editbox History"] = "История чата"
L["Amount of messages to save. Set to 0 to disable."] = "Количество сообщений, введенных вами, которое будет сохранено между сеансами"

--Datatexts--
L["Panels & Dashboard"] = "Панели инфо-текстов"
L["Bosses killed: "] = "Боссов убито: "
L["You didn't select any instance to track."] = "Вы не выбрали подземелья для отслеживания"
L["This LFR isn't available for your level/gear."] = "Это подземелье не доступно для Вашего уровня или экипировки."
L["SLE_AUTHOR_INFO"] = "Редакция \"Тень и Свет\" от Darth Predator и Repooc"
L["SLE_CONTACTS"] = [=[При возникновении вопросов, предложений и прочего обращаться:
- Личное сообщение на форуме TukUI (tukui.org), ник Darth Predator или Repooc
- Страница/система тикетов на curse.com
- Форумы tukui.org, раздел Addons/Help
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
L['Hide panel background'] = "Скрыть фон панели"
L["Don't show this panel, only datatexts assinged to it"] = "Не показывать саму панель, а только назначенные на нее инфо-тексты"
L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information. Please use the dropdown box to select which datatext you would like to configure."] = "Некоторые инфо-тексты Тени и Света имеют настройки, которые могут изменить отображаемую информацию. Используйте выпадающий список для выбора инфо-текста, который Вы хотите настроить."
L["S&L Friends"] = true
L["Show total friends in the datatext."] = "Показывать общее кол-во друзей на инфо-тексте."
L["Show total guild members in the datatext."] = "Показывать общее кол-во членов гильдии на инфо-тексте."
L["These options are for modifing the Shadow & Light Friends datatext."] = "Опции для настройки инфо-текста S&L Friends."
L["S&L Guild"] = true
L["Show Totals"] = "Показывать общее"
L["Expand RealID"] = "Развернуть RealID"
L["Display realid with two lines to view broadcasts."] = "Отображать информацию друрей по RealID в две строки для отображения рассылки."
L["Hide Hints"] = "Скрыть управление"
L["Hide the hints in the tooltip."] = "Скрывать инструкцию по управлению в подсказке инфо-текста"
L["Autohide Delay:"] = "Задержка скрывания"
L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."] = "Устанавливает время исчезновения подсказки, после ухода курсора с инфо-текста."
L["S&L Datatexts"] = "Инфо-тексты S&L"
L["Datatext Options"] = "Опции инфо-текстов"
L["These options are for modifing the Shadow & Light Guild datatext."] = "Опции для настройки инфо-текста S&L Guild."
L["Hide MOTD"] = "Скрыть сообщение дня"
L["Hide the guild's Message of the Day in the tooltip."] = "Скрывает сообщение дня гильдии на подсказке."
L["Hide Guild Name"] = "Скрыть название гильдии"
L["Hide the guild's name in the tooltip."] = "Скрывает название гильдии на подсказке."
L["Hide In Combat"] = "Скрывать в бою"
L["Will not show the tooltip while in combat."] = "Не отображать подсказки инфо-текста в бою."

--Exp/Rep Bar--
L["Xp-Rep Text"] = "Текст Опыта/Репутации"
L["Full value on Exp Bar"] = "Полное значение опыта"
L["Changes the way text is shown on exp bar."] = "Изменяет отображение значений опыта на полосе."
L["Full value on Rep Bar"] = "Полное значение репутации"
L["Changes the way text is shown on rep bar."] = "Изменяет отображение значений репутации на полосе."
L["Auto Track Reputation"] = "Автоматически отслеживать репутацию"
L["Automatically sets reputation tracking to the most recent reputation change."] = "Автоматически изменять отслеживаемую репутацию на последнюю фракцию, чье отношение к Вам изменилось."

--Equip Manager--
L['Equipment Manager'] = "Менеджер экипировки"
L["EM_DESC"] = "Этот модуль предоставляет различные опции для автоматической смены комплектов экипировки при переключении набора талантов или попадании в определенную локацию."
L['Spam Throttling'] = "Подавление спама"
L["Removes the spam from chat stating what talents were learned or unlearned during spec change."] = "Удаляет спам об изученных/забытых заклинаниях при смене талантов."
L["Here you can choose what equipment sets to use in different situations."] = "Здесь Вы можете выбрать какие комплекты экипировки использовать в различных случаях."
L["Equip this set when switching to primary talents."] = "Надеть этот набор при переключении на основной набор талантов."
L["Equip this set when switching to secondary talents."] = "Надеть этот набор при переключении на дополнительный набор талантов."
L["Equip this set after entering dungeons or raids."] = "Надеть этот набор при попадании в подземелье или рейд."
L["Equip this set after entering battlegrounds or arens."] = "Надеть этот набор при попадании на поля боя или арены."

--Farm--
L['Farm'] = "Ферма"
L["FARM_DESC"] = [[Дополнительные панели с семенами, инструментами и порталами для Фермы Солнечной Песни.
Они будут отображаться только если Вы находитесь на ферме или рынке Полугорья.]]
L['Only active buttons'] = "Только активные"
L['Only show the buttons for the seeds, portals, tools you have in your bags.'] = "Отображать только кнопки для тех семян/инструментов/порталов, которые есть у Вас в сумках."
L["Seed Bars"] = "Панели семян"
L["Auto Planting"] = "Автоматическая посадка"
L["Automatically plant seeds to the nearest tilled soil if one is not already selected."] = "Автоматически высаживать указанное растение на ближайшую возделанную змелю, если не выбрана другая."
L["Drop Seeds"] = "Удалять семена"
L["Allow seeds to be destroyed from seed bars."] = "Позволить удаление семян при помощи панелей."
L["Quest Glow"] = "Свечение заданий"
L["Show glowing border on seeds needed for any quest in your log."] = "Показывать светящуюся границу на семенах, необходимых на какое-либо из взятых заданий из Вашего журнала."
L["Dock Buttons To"] = "Прикрепить кнопки к"
L["Change the position from where seed bars will grow."] = "Изменить сторону, с которой будут расти панели семян."
L["Bottom"] = "Низ"
L["Top"] = "Верх"
L["Farm Seed Bars"] = "Панели семян"
L["Farm Tool Bar"] = "Панель инструментов"
L["Farm Portal Bar"] = "Панель порталов"
L["Tilled Soil"] = "Возделанная земля"
L['Right-click to drop the item.'] = "ПКМ для уничтожения предмета."
L["We are sorry, but you can't do this now. Try again after the end of this combat."] = "Извините, но Вы не можете этого сделать сейчас. Попробуйте снова после окончания текущего боя."

--Marks--
L["Raid Marks"] = "Рейдовые Метки"
L["Show/Hide raid marks."] = "Показать/скрыть фрейм рейдовых меток."
L["Show only in instances"] = "Только в подземельях"
L["Selecting this option will have the Raid Markers appear only while in a raid or dungeon."] = "При активации будет отображать полосу меток только в подземельях и рейдах."
L["Sets size of buttons"] = "Устанавливает размер кнопок" --Also used in UI buttons
L["Direction"] = "Направление"
L["Change the direction of buttons growth from the skull marker"] = "Изменяет направление роста кнопок от метки \"череп\"."
L["Raid Flares"] = "Рейдовые маркеры"
L["Show/Hide Raid Flares."] = "Показать/скрыть маркеры."
L["Selecting this option will have the Raid Flares appear only while in a raid or dungeon."] = "При включении будет показывать панель маркеров только в подземельях."
L["Show Tooltip"] = "Показывать подсказку"
L["Change the direction of buttons growth from the square marker"] = 'Изменить направление роса кнопок от метки "квадрат"'
L["Square World Marker"] = "Маркер квадрат"
L["Triangle World Marker"] = "Маркер треугольник"
L["Diamond World Marker"] = "Маркер ромб"
L["Cross World Marker"] = "Маркер крест"
L["Star World Marker"] = "Маркер звезда"
L["Clear World Markers"] = "Удалить маркеры"

--Import Section
L["SLE_IMPORTS"] = "|cffFF0000Важно:|r Используйте импортирование фильтров осторожно, так как они удалят ваши собсвенные фильтры!\nИмпортирование классового фильтра перезапишет любые изменения, которые Вы в него вносили."
L["Import Options"] = "Импорт Настроек"
L["Author Specific Imports"] = "Импорт специфических настроек авторов"
L['Select Author'] = "Выберите автора"
L["Please be aware that importing any of the filters will require a reload of the UI for the settings to take effect.\nOnce you click a filter button, your screen will reload automatically."] = "Пожалуйста, учтите, что импортирование любого фильтра потребует перезагрузки интерфейса для вступления в силу.\nКак только вы нажмете на кнопку, Ваш интерфейс перезагрузится автоматически."
L["Import"] = "Импорт"
L["This will import non class specific filters from this author."] = "Это импортирует не привязанные к классу фильтры этого автора."
L["This will import All Class specific filters from this author."] = "Это импортирует все классовые фильтры этого автора."
L['Import All'] = "Импорт всего"

--Loot--
L['Loot Announcer'] = "Оповещение о добыче"
L["LOOT_DESC"] = [[Этот модуль будет выводить список выпавшей добычи при открытии окна добычи.
Вывод осуществляется только если Вы лидер, помощник или ответственный за добычу или при зажатии левой клавиши control при осмотре трупа для принудительного вывода.]]
L["Auto Announce"] = "Авто оповещение"
L["Automatically announce in selected chat channel."] = "Автоматически выводить список добычи в выбранный канал чата"
L["Loot Quality"] = "Качество добычи"
L["Set the minimum quality of an item to announce."] = "Минимальное качество предмета, для вывода в чате."
L["Announce loot to the selected channel."] = "Канал чата, для вывода сообщений."
L["Loot Dropped:"] = "Список добычи:"

--Minimap--
L["Minimap Options"] = "Опции миникарты"
L['MINIMAP_DESC'] = "Эти опции влияют на различные функции миникарты.  Некоторые опции погут не работать, если вы отключите миникарты в основных настройках ElvUI."
L["Minimap Coordinates"] = "Координаты на миникарте"
L['Coords Display'] = "Отображение координат"
L['Change settings for the display of the coordinates that are on the minimap.'] = "Укажите условие отображения координат на миникарте."
L["Coords Location"] = "Позиция координат"
L['This will determine where the coords are shown on the minimap.'] = "Определяет место, в котором будут отображаться координаты на миникарте"
L['Bottom Corners'] = "Нижние углы"
L['Bottom Center'] = "Внизу по центру"
L["Minimap Buttons"] = "Иконки у миникарты"
L['Enable/Disable minimap button skinning.'] = "Включить/выключить стилизацию иконок у миникарты."
L['Anchor Setting'] = "Настрокий расположения"
L['Anchor mode for displaying the minimap buttons are skinned.'] = "Место расположения иконок аддонов, когда они стилизованы."
L['Horizontal Bar'] = "Горизонтальная панель"
L['Vertical Bar'] = "Вертикальная панель"
L['The size of the minimap buttons when not anchored to the minimap.'] = "Размер иконок, когда они не прикреплены к миникарте."
L['Show minimap buttons on mouseover.'] = "Отображать иконпри при наведении мыши."


--Mover groups
L["S&L: All"] = "S&L: Все"
L["S&L: Datatexts"] = "S&L: Инфо-тексты"
L["S&L: Backgrounds"] = "S&L: Фоновые фреймы"
L["S&L: Misc"] = "S&L: Прочее"

--Raid Utility--
L["Raid Utility"] = "Управление рейдом"

--Skins--
L["This options require ElvUI AddOnSkins pack to work."] = "Эти опции требуют наличие пака ElvUI AddOnSkins для работы"
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
L["Power Text Position"] = "Позиция текста ресурса"
L["Position power text on this bar of chosen frame"] = "Позиционировать текст ресурса относительно выбранной полосы на каждой рамке"

--Credits--
L["ELVUI_SLE_CREDITS"] = "Мы бы хотели отметить следующих людей, которые помогли нас сделать этот аддон посредством тестирования, кода и прочего."
L["Submodules and Coding:"] = "Субмодули и кодинг:"
L["ELVUI_SLE_CODERS"] = [=[Elv
Tukz
Affinitii
Azilroka
Blazeflack
Boradan
Camealion
Omega1970
Pvtschlag
Sinaris
Sortokk
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

--Changelog
L["Changelog"] = "Изменения"
L["CHANGE_LOG"] = [=[|cff1784d1v1.5|r
- Исправлены некоторые опечатки
- Панели инфо-текстов теперь могут быть прозрачными
- У фоновых фреймов больше нет опции смещения, теперь у них есть собственные фиксаторы
- Тип фона для фоновых фреймов теперь опция профиля и не требует перезагрузки интерфейса
- Фиксаторы, создаваемые S&L теперь группируются по собственным категориям аналогично оригинальному ElvUI (фиксаторы фоновых фреймов доступны ТОЛЬКО в этоих группах)
- Рейдовые метки теперь корректно обновляют настройки при смене профиля
- У основной панели рейдовых меток теперь можно скрыть фон
- Добавлен показ уровня на предметах в окне игрока
- Добавлен показ прочности на предметах в окне игрока
- Добавлен менеджер экипировки по специализации/зоне
- Добавлен модуль фермы для улучшения жизни огородников
- Добавлена стилизация иконок у миникарты
- Добавлено отображение текущих координат на миникарте
- Слежение за убитыми боссами в ЛФР теперь позволяет выбрать какие подземелья Вы хотите отслеживать.
- Информация на верхней панели инфо-текстов теперь может быть изменена пользователем
- Вы будете получать текстовое сообщение в чате, если в вашей группе/рейде есть человек с более новой версией
- Добавлены настройки Affinitii (Blood Legion)
- Настройки Дарта обновлены
- Добавлена функция оповещения о добыче
]=]