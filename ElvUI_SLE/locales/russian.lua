-- English localization file for ruRU.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "ruRU");

if not L then return; end
--Popups
L["MSG_SLE_ELV_OUTDATED"] = "Ваша версия ElvUI старее, чем рекомендованная для использования с |cff9482c9Shadow & Light|r. У Вас версия |cff1784d1%.2f|r (рекомендованная |cff1784d1%.2f|r). Пожалуйста, обновите ElvUI."
L["This will clear your chat history and reload your UI.\nContinue?"] = "Это отчистит вашу историю чата и перезагрузит интерфейс.\nПродолжить?"
L["This will clear your editbox history and reload your UI.\nContinue?"] = "Это отчистит вашу историю введенных сообщений и перезагрузит интерфейс.\nПродолжить?"
L["Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Ешкин конь, одновременно включены ElvUI Enhanced и Shadow & Light. Выберите что отключить."
L['You have got Loot Confirm and Shadow & Light both enabled at the same time. Select an addon to disable.'] = "Одновременно активны Loot Confirm и Shadow & Light. Выберите что из них отключить."
L["You have got OneClickEnchantScroll and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Одновременно активны OneClickEnchantScroll и Shadow & Light. Выберите что из них отключить."
L["You have got ElvUI Transparent Actionbar Backdrops and Shadow & Light both enabled at the same time. Select an addon to disable."] = "Одновременно активны ElvUI Transparent Actionbar Backdrops и Shadow & Light. Выберите что из них отключить."
L["SLE_ADVANCED_POPUP_TEXT"] = [[Клянетесь ли вы, что являетесь опытным пользователем,
умеете читать подсказки и не будете разводить панику, если
жестоким образом обезобразите интерфейс ипри помощи дополнительных опций?

Если да, то вам дадут включить эту опцию.]]

--Install--
L["Moving Frames"] = "Перемещение фреймов"
L["Author Presets"] = "Пресеты авторов"
L["|cff9482c9Shadow & Light|r Installation"] = "Установка |cff9482c9Shadow & Light|r"
L["Welcome to |cff9482c9Shadow & Light|r version %s!"] = "Добро пожаловать в |cff9482c9Shadow & Light|r версии %s!"
L["SLE_INSTALL_WELCOME"] = [[Этот установщик позволит ван выбрать поведение некоторых функций Shadow & Light.
Если вы не хотите настраивать эти опции, то нажмите кнопку \"Пропустить установку\" для ее завершения немедленно.

Заметьте, что шаги отмеченные * являются опциональными и не будут отображены без соблюдения определенных условий в предыдущих шагах.]]
L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."] = "Активирует компоненты оружейной Shadow & Light, которые покажут вам более детальную информацию о вашем персонаже или игроке, которого вы осматриваете."
L["SLE_ARMORY_INSTALL"] = "Включить режим оружейной S&L\n(Детализированные окна персонажа и осмотра)."
L["Shadow & Light Imports"] = "Импорт Shadow & Light"
L["You can now choose if you want to use one of the authors' set of options. This will change the positioning of some elements as well of other various options."] = "Вы можете использовать набор настроек, используемый одним из представленных людей. Будут изменены положения элементов и другие настройки."
L["SLE_Install_Text_AUTHOR"] = [=[Этот шаг опционален и должен использоваться только в  случае, если вы собираетесь использовать одну из наших конфигурацй. В зависимости от выбланного расположения в установке ElvUI результат может отличться.
Если вы не выберете ни один из вариантов, то следующий шаг установки будет автоматически пропущен.

Была выбрана роль |cff1784d1"%s"|r.

|cffFF0000Внимание:|r Пожалуйста помните, что авторы могут не использовать тему/роль, которую вы выбрали, и потому результат не всегда будет хорошим. Также переключение между шаблонами здесь может привести к неоднозначным результатам.]=]
L["Darth's Config"] = "Опции Дарта"
L["Repooc's Config"] = "Опции Repooc'а"
L["Darth's Default Set"] = "Установлены настройки Дарта"
L["Repooc's Default Set"] = "Установлены настройки Repooc'а"
L["Layout & Settings Import"] = "Импорт расположений и настроек"
L["You have selected to use %s."] = "Вы выбрали %s"
L["SLE_INSTALL_LAYOUT_TEXT2"] = [[Данные опции импортируют расположения/настройки аддонов для выбранных опций и роли.
Учтите, что эти пресеты могут включать незнакомые вам настройки.

Также это пожет сбросить/изменить некоторые из опций, выбранных вами на предыдущих шагах.]]
L["|cff1784d1%s|r role was chosen"] = 'Была выбрана роль |cff1784d1"%s"|r.'
L["Import Profile"] = "Импорт профиля"
L["AFK Mode"] = "Режим АФК"
L["You have selected to use %s and role %s."] = "Вы выбрали %s для роли %s."

--Config replacements
L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."] = "Shadow & Light отключил эту опцию. Для ее возвращения нужно отключить соответственную опцию в S&L. Нажмите для перехода к ней."

--Core
L["SLE_LOGIN_MSG"] = "|cff9482c9Shadow & Light|r версии |cff1784d1%s%s|r для ElvUI загружен. Спасибо за использование."
L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."] = "Плагин для |cff1784d1ElvUI|r  от\nDarth Predator'а и Repooc'а"
L["Resets all movers & options for S&L."] = "Сбросить все фиксаторы и опции S&L"
L["Reset these options to defaults"] = "Восстановить умолчания для этих опций"
L["Modules designed for older expantions"] = "Модули для предыдущих дополнений"
L["Game Menu Buttons"] = "Кнопки главного меню"
L["Adds |cff9482c9Shadow & Light|r buttons to main game menu."] = "Добавляет кнопки |cff9482c9Shadow & Light|r в главное меню."
L["SLE_Advanced_Desc"] = [[Следующие опции дают доступ к дополнительным настройкам.
Не рекомендуется для использванием новичкам или людям без опыта настройки аддонов.]]
L["Allow Advanced Options"] = "Разрешить продвинутые настройки"
L["Change Elv's options limits"] = "Измениь пределы опций ElvUI"
L["Allow |cff9482c9Shadow & Light|r to change some of ElvUI's options limits."] = "Позволяет |cff9482c9Shadow & Light|r изменить пределы некоторых опций ElvUI."
L["Cyrillics Support"] = "Поддержка кириллицы"
L["SLE_CYR_DESC"] = [[Если вы иногда (или на постоянной основе) используете кириллицу при написании сообщений
и постоянно забываете переключить язык для ввода слэш команд, тогда эти опции для вас.
Они позволяют использовать команды ElvUI на неверной раскладке.
]]
L["Commands"] = "Команды"
L["SLE_CYR_COM_DESC"] = [[Позволяет использование следующих команд на русской раскладке:
- /rl
- /in
- /ec
- /elvui
- /bgstats
- /hellokitty
- /hellokittyfix
- /harlemshake
- /egrid
- /moveui
- /resetui
- /kb]]
L["Dev Commands"] = "Тех. команды"
L["SLE_CYR_DEVCOM_DESC"] = [[Позволяет использование следующих команд на русской раскладке:
- /luaerror
- /frame
- /framelist
- /texlist
- /cpuimpact
- /cpuusage
- /enableblizzard

Они обычно используются с целью тестирования или разработки и крайне редко применяются среднестатистическим игроком.]]

--Config groups
L["S&L: All"] = "S&L: Все"
L["S&L: Datatexts"] = "S&L: Инфо-тексты"
L["S&L: Backgrounds"] = "S&L: Фоновые фреймы"
L["S&L: Misc"] = "S&L: Прочее"

--Actionbars
L["OOR as Bind Text"] = "Вне радиуса на назначнии"
L["Out Of Range indication will use keybind text instead of the whole icon."] = "Индикация о слишком далекой цели будет окрашивать текст назначенной клавиши вместо всей иконки."
L["Checked Texture"] = "Текстура выделения"
L["Highlight the button of the spell with areal effect untill the area is selected."] = "Пдсвечивает кнопку с эффектом по области пока не будет выбрана точка применения."
L["Checked Texture Color"] = "Цвет выделения"
L["Transparent Backdrop"] = "Прозрачный фон"
L["Sets actiobars' backgrounds to transparent template."] = "Делает фон панелей команд прозрачным."
L["Transparent Buttons"] = "Прозрачные кнопки"
L["Sets actiobars buttons' backgrounds to transparent template."] = "Делает кнопки панелей команд прозрачными"

--Armory
L["Average"] = "Средний"
L["Not Enchanted"] = "Не зачаровано"
L["Empty Socket"] = "Пустой слот"
L["KF"] = true
L["You can't inspect while dead."] = "Вы не можете осматривать будучи трупом."
L["Specialization data seems to be crashed. Please inspect again."] = "Данные по специализации кажется исчезли. Пожалуйста, повторно осмотрите цель."
L["No Specialization"] = "Нет специализации"
L["Character model may differ because it was constructed by the inspect data."] = "Модель персонажа может отличаться, так как была составлена на основе данных осмотра."
L["Armory Mode"] = "Оружейная"
L["Enchant String"] = "Текст чар"
L["String Replacement"] = "Замена текста"
L["List of Strings"] = "Список строк"
L["Original String"] = "Оригинал"
L["New String"] = "Новый текст"
L["Character Armory"] = "Персонаж"
L["Show Missing Enchants or Gems"] = "Показывать отсутствие чар и камней"
L["Show Warning Icon"] = "Показывать иконку предупреждения"
L["Select Image"] = "Выберите изображение"
L["Custom Image Path"] = "Путь к своему изображению"
L["Gradient"] = "Градиент"
L["Gradient Texture Color"] = "Цвет градиента"
L["Upgrade Level"] = "Уровень улучшения"
L["Warning Size"] = "Размер предупреждения"
L["Warning Only As Icons"] = "Предупреждение только иконкой"
L["Only Damaged"] = "Только поврежденные"
L["Gem Sockets"] = "Слоты камней"
L["Socket Size"] = "Размер слотов"
L["Inspect Armory"] = "Осмотр"

--AFK
L["You Are Away From Keyboard for"] = "Вы отошли на"
L["Take care of yourself, Master!"] = "Возвращайтесь, хозяин!"
L["SLE_TIPS"] = { --This doesn't need to be translated, every locale can has own tips
	"Не стой в огне!",
	"Elv: I just utilized my degree in afro engineering and fixed it",
	"Сожги еретика. Убей мутанта. Преследуй нечисть.",
	"Кровь Богу Крови!",
	"Больше Кофе Богу Кофе!",
	"Любимый комментарий Дарта к обновлениям кода - \"Woops\"",
	"Сделал дейлик - спас китайца.",
	"Со для слабых! Пока ты спишь, враг качается!",
}
L["Enable S&L's additional features for AFK screen."] = "Активировать дополнительные опции для режима АФК."
L["Button restrictions"] = "Ограничения клавиш"
L["Use ElvUI's restrictions for button presses."] = "Использовать ограничения Elv'а на нажатия клавиш."
L["Crest Size"] = "Размер герба"
L["X-Pack Logo Size"] = "Размел иконки дополнения"
L["Template"] = "Шаблон"
L["Player Model"] = "Модель игрока"
L["Model Animation"] = "Анмиация модели"
L["Test"] = "Проверка"
L["Shows a test model with selected animation for 10 seconds. Clicking again will reset timer."] = "Показать тестовую модель с выбраной анимацией на 10 секунд. Повторное нажатие сбросит таймер."
L["Misc"] = "Прочее"
L["Bouncing"] = "Отскок"
L["Use bounce on fade in animations."] = "При появлении элементы будут отскакивать от краев экрана."
L["Animation time"] = "Время анимации"
L["Time the fade in animation will take. To disable animation set to 0."] = "Время, которое займет анимация появления. Для отключения установите на 0."
L["Slide"] = "Скольжение"
L["Slide Sideways"] = "Скольжение вбок"
L["Fade"] = "Появление"
L["Tip time"] = "Длительность подсказки"
L["Number of seconds tip will be shown before changed to another."] = "Кол-во секунд, которое будет показана каждая подсказка."

--Auras
L["Hide Buff Timer"] = "Скрыть время баффов"
L["This hides the time remaining for your buffs."] = "Скрывает оставшееся время действия баффов на вас."
L["Hide Debuff Timer"] = "Скрыть время дебаффов"
L["This hides the time remaining for your debuffs."] = "Скрывает оставшееся время действия дебаффов на вас."

--Backgrounds
L["SLE_BG_1"] = "Фон 1"
L["SLE_BG_2"] = "Фон 2"
L["SLE_BG_3"] = "Фон 3"
L["SLE_BG_4"] = "Фон 4"
L["Additional Background Panels"] = "Дополнительные фоновые панели"
L["BG_DESC"] = "Модуль для создания дополнительных фреймов, которые можно использовать в качестве фона для чего-нибудь."
L["Show/Hide this frame."] = "Показать/скрыть фрейм."
L["Sets width of the frame"] = "Установить ширину фрейма"
L["Sets height of the frame"] = "Установить высоту фрейма"
L["Set the texture to use in this frame. Requirements are the same as the chat textures."] = "Устанавливает текстуру этого фрейма. Требования к текстуре такие же, как для текстур чата."
L["Backdrop Template"] = "Тип фона"
L["Change the template used for this backdrop."] = "Измените шаблон, используемый при создании этого фона"
L["Hide in Pet Batlle"] = "Прятать в битвах питомцев"
L["Show/Hide this frame during Pet Battles."] = "Показать/скрыть этот фрейм в битвах питомцев"

--Bags
L["New Item Flash"] = "Мерцание новых предметов"
L["Use the Shadow & Light New Item Flash instead of the default ElvUI flash"] = "Использовать полное мерцание Shadow & Light вместо обычного из ElvUI."
L["Transparent Slots"] = "Прозрачные слоты"
L["Apply transparent template on bag and bank slots."] = "Использовать прозрачный фон для слотов в сумках и банке."

--Blizzard
L["Move Blizzard frames"] = "Перемещение фреймов Blizzard"
L["Allow some Blizzard frames to be moved around."] = "Разрешить перемещение некоторых фреймов Blizzard."
L["Pet Battles skinning"] = "Скин битв питомцев"
L["Make some elements of pet battles movable via toggle anchors."] = "Дает возможность перемещать некоторые элементы боев питомцев при пмощи фиксаторов."
L["Vehicle Seat Scale"] = "Масштаб фрейма транспорта."

--Chat
L["Reported by %s"] = "Отчет от %s"
L["Reset Chat History"] = "Сбросить историю чата"
L["Clears your chat history and will reload your UI."] = "Очищает историю сохраненных сообщений в чате и перезагружет интерфейс."
L["Reset Editbox History"] = "Сбросить введенное"
L["Clears the editbox history and will reload your UI."] = "Очищает историю введенных сообщений и перезагружает интерфейс."
L["Guild Master Icon"] = "Иконка Главы гильдии"
L["Displays an icon near your Guild Master in chat.\n\n|cffFF0000Note:|r Some messages in chat history may disappear on login."] = "Отображает иконку рядом с сообщениями главы вашей гильдии в чате.\n\n|cffFF0000Предупреждение:|r Некоторые сообщения в истории чата в истории чата могут исчезать при входе в игру."
L["Chat Editbox History"] = "История ввода"
L["The amount of messages to save in the editbox history.\n\n|cffFF0000Note:|r To disable, set to 0."] = "Количество сообщений, введенных вами, которое будет сохранено между сеансами.\n\n|cffFF0000Напоминание:|r Для отключения, установите на 0."
L["Filter DPS meters' Spam"] = "Фильтровать отчеты о УВС"
L["Replaces long reports from damage meters with a clickeble hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter te report of other things"] = "Заменяет длиные отчеты от аддонов для измерения УВС на гиперссылку, сокращая уровень спама в чате.\nКорректно работает с отчетами урона и исцеления. Может не отфильтровать другие специфические отчеты."
L["Texture Alpha"] = "Прозрачность текстур"
L["Allows separate alpha setting for textures in chat"] = "Включает отдельную настройку прозрачности для текстур в чате"
L["Chat Frame Justify"] = "Выравнивание текста"
L["Identify"] = "Определить"
L["Showes the message in each chat frame containing frame's number."] = "Оображает на каждой вкладке сообщеине с ее идентификатором."
L["This is %sFrame %s|r"] = "Это %sВкладка %s|r"
L["Loot Icons"] = "Иконки добычи"
L["Showes icons of items looted/created near respective messages in chat. Does not affect usual messages."] = "Отображает иконки созданных/полученных предметов в соответствующих сообщениях чата. Не влияет на обычные сообщения."
L["Frame 1"] = "Вкладка 1"
L["Frame 2"] = "Вкладка 2"
L["Frame 3"] = "Вкладка 3"
L["Frame 4"] = "Вкладка 4"
L["Frame 5"] = "Вкладка 5"
L["Frame 6"] = "Вкладка 6"
L["Frame 7"] = "Вкладка 7"
L["Frame 8"] = "Вкладка 8"
L["Frame 9"] = "Вкладка 9"
L["Frame 10"] = "Вкладка 10"
L["Chat Max Messages"] = "Максимум сообщений в чате"
L["The amount of messages to save in chat window.\n\n|cffFF0000Warning:|r Can increase the amount of memory needed. Also changing this setting will clear the chat in all windows, leaving just lines saved in chat history."] = "Кол-во сообщений хранащихся в окне чата.\n\n|cffFF0000Внимание:|r Может повысить количество необходимой памяти. Также изменение этой опции мгновенно очистит чат от сообщений, оставив только сохраненное в истории чата."
L["Tabs"] = "Вкладки"
L["Selected Indicator"] = "Индитакор активной"
L["Shows you which of docked chat tabs is currently selected."] = "Показывает какая из закрепленных вкладок сейчас активна."
L["Chat history size"] = "Размер истории чата"
L["Sets how many messages will be stored in history."] = "Кол-во сообщений, сохраняемых в истории чата."
L["Following options determine which channels to save in chat history.\nNote: disabling a channel will immideately delete saved info for that channel."] = "Следующие опции задают каналы, которые будут сохраняться в истории чата.\nОбратите внимание: отключение канала тутже отчистит историю чата от сообщений из этого канала."

--Databars
L["Full value on Exp Bar"] = "Полное значение опыта"
L["Changes the way text is shown on exp bar."] = "Изменяет отображение значений опыта на полосе."
L["Full value on Rep Bar"] = "Полное значение репутации"
L["Changes the way text is shown on rep bar."] = "Изменяет отображение значений репутации на полосе."
L["Auto Track Reputation"] = "Автоматически отслеживать репутацию"
L["Automatically sets reputation tracking to the most recent reputation change."] = "Автоматически изменять отслеживаемую репутацию на последнюю фракцию, чье отношение к Вам изменилось."
L["Change the style of reputation messages."] = "Изменяет стиль сообщений о получении репутации"
L["Reputation increase Style"] = "Стиль прибавки"
L["Reputation decrease Style"] = "Стиль уменьшения"
L["Output"] = "Вывод"
L["Determines in which frame reputation messages will be shown. Auto is for whatever frame has reputation messages enabled via Blizzard options."] = "Определяет вкладку, на которой будут выводиться сообщения. Авто будет выводить в соответствии с настроками Blizzard."
L["Change the style of experience gain messages."] = "Изменяет стиль сообщений о получении опыта."
L["Experience Style"] = "Стиль опыта"
L["Full List"] = "Полный список"
L["Show all factions affected by the latest reputation change. When disabled only first (in alphabetical order) affected faction will be shown."] = "Показывать все фракции, затронутые последним изменеием репутации. При отключении будет показываться только первая (в алфавитном порядке) фракция."
L["Full value on Artifact Bar"] = "Полное значение силы артефакта"
L["Changes the way text is shown on artifact bar."] = "Изменяет отображение значения силы артефакта на полосе."
L["Full value on Honor Bar"] = "Полное значение чести"
L["Changes the way text is shown on honor bar."] = "Изменяет отображение количества чести на полосе."
L["Chat Filters"] = "Фильтры чата"
L["Replace massages about honorable kills in chat."] = "Заменять сообщения о почетных победах в чате."
L["Award"] = "Награда"
L["Replace massages about honor points being awarded."] = "Заменять сообщения о наградной чести."
L["Defines the style of changed string. Colored parts will be shown with your selected value color in chat."] = "Определяет стил сообщения. Окрашенные элементы будут отображаться выбранным вами цветом значений."
L["Award Style"] = "Стиль наград"
L["HK Style"] = "Стиль почетной победы"

--Datatexts
L["D"] = "Дн"
L["Previous Level:"] = "Предыдущий уровень:"
L['Current:'] = "Текущее:"
L['Weekly:'] = "За неделю:"
L["Account Time Played"] = "Время в игре на аккаунте"
L["SLE_DataPanel_1"] = "S&L Инфо-панель 1"
L["SLE_DataPanel_2"] = "S&L Инфо-панель 2"
L["SLE_DataPanel_3"] = "S&L Инфо-панель 3"
L["SLE_DataPanel_4"] = "S&L Инфо-панель 4"
L["SLE_DataPanel_5"] = "S&L Инфо-панель 5"
L["SLE_DataPanel_6"] = "S&L Инфо-панель 6"
L["SLE_DataPanel_7"] = "S&L Инфо-панель 7"
L["SLE_DataPanel_8"] = "S&L Инфо-панель 8"
L["You didn't select any instance to track."] = "Вы не выбрали подземелья для отслеживания"
L["This LFR isn't available for your level/gear."] = "Это подземелье не доступно для Вашего уровня или экипировки."
L["Bosses killed: "] = "Боссов убито: "
L["|cffeda55fLeft Click|r to open the friends panel."] = "|cffeda55fЛКМ|r для открытия списка друзей"
L["|cffeda55fRight Click|r to open configuration panel."] = "|cffeda55fПКМ|r для открытия настроек"
L["|cffeda55fLeft Click|r a line to whisper a player."] = "|cffeda55fЛКМ|r на строке для сообщения игроку."
L["|cffeda55fShift+Left Click|r a line to lookup a player."] = true
L["|cffeda55fCtrl+Left Click|r a line to edit a note."] = "|cffeda55fCtrl+ЛКМ|r для редактирования заметки."
L["|cffeda55fMiddleClick|r a line to expand RealID."] = "|cffeda55fКлик клесиком|r по строке для разворота RealID."
L["|cffeda55fAlt+Left Click|r a line to invite."] = "|cffeda55fAlt+ЛКМ|r по строке для приглашения."
L["|cffeda55fLeft Click|r a Header to hide it or sort it."] = "|cffeda55fЛКМ|r по заголовку для скрытия или сортировки."
L["|cffeda55fLeft Click|r to open the guild panel."] = "|cffeda55fЛКМ|r для открытия окна гильдии."
L["|cffeda55fCtrl+Left Click|r a line to edit note."] = "|cffeda55fCtrl+ЛКМ|r по строке для редактирвоания заметки."
L["|cffeda55fCtrl+Right Click|r a line to edit officer note."] = "|cffeda55fCtrl+ПКМ|r по строке для редактирвоания офицерской заметки."
L["New Mail"] = "Новое письмо"
L["No Mail"] = "Нет писем"
L["Range"] = "Дальность"
L["SLE_AUTHOR_INFO"] = "\"Shadow & Light\" от Darth Predator'а и Repooc'а"
L["SLE_CONTACTS"] = [=[При возникновении вопросов, предложений и прочего обращаться:
http://git.tukui.org/repooc/elvui-shadowandlight]=]
L["Additional Datatext Panels"] = "Дополнительные панели инфо-текстов"
L["DP_DESC"] = [=[Дополнительные панели под информационные тексты.
Всего здесь 8 дополнительных панелей и 20 дополнительных слотов под инфо-тексты.]=]
L["Sets size of this panel"] = "Установить ширину панели"
L["Don't show this panel, only datatexts assinged to it"] = "Не показывать саму панель, а только назначенные на нее инфо-тексты"
L["Override Chat DT Panels"] = "Изменить инфо-панели чата"
L["This will have S&L handle chat datatext panels and place them below the left & right chat panels.\n\n|cffFF0000Note:|r When you first enabled, you may need to move the chat panels up to see your datatext panels."] = "S&L перенесет панели информации чатов. Информационные панели будут перемещены под панели чата. \n\n|cffFF0000Внимание:|r При первой активации может потребоваться вручную переместить панели чата, чтобы увидеть инфо-панели."
L["S&L Datatexts"] = "Инфо-тексты S&L"
L["Datatext Options"] = "Опции инфо-текстов"
L["LFR Lockout"] = "Состояние ЛФР"
L["Show/Hide LFR lockout info in time datatext's tooltip."] = "Отображать/скрывать информацию о сохранении ЛФР в инфо-тексте времени"
L["ElvUI Improved Currency Options"] = "Опции расширенного инфо-текста валюты"
L['Show Archaeology Fragments'] = "Показывать фрагменты археологии"
L['Show Jewelcrafting Tokens'] = "Показывать ювелирные значки"
L['Show Player vs Player Currency'] = "Показывать PvP валюту"
L['Show Dungeon and Raid Currency'] = "Показывать валюту подземелий"
L['Show Cooking Awards'] = "Показывать кулинарные значки"
L['Show Miscellaneous Currency'] = "Показывать прочую валюту"
L['Show Zero Currency'] = "Показывать отсутствующую валюту"
L['Show Icons'] = "Показывать иконки"
L['Show Faction Totals'] = "Показывать сумму по фракциям"
L['Show Unsed Currency'] = "Показывать неиспользуемую валюту"
L["These options are for modifing the Shadow & Light Friends datatext."] = "Опции для настройки инфо-текста S&L Friends."
L["Hide In Combat"] = "Скрывать в бою"
L["Will not show the tooltip while in combat."] = "Не отображать подсказки инфо-текста в бою."
L["Hide Friends"] = "Скрыть друзей"
L["Minimize the Friend Datatext."] = "Минимизировать список друзей"
L["Show Totals"] = "Показывать общее"
L["Show total friends in the datatext."] = "Показывать общее кол-во друзей на инфо-тексте."
L["Hide Hints"] = "Скрыть управление"
L["Hide the hints in the tooltip."] = "Скрывать инструкцию по управлению в подсказке инфо-текста."
L["Expand RealID"] = "Развернуть RealID"
L["Display realid with two lines to view broadcasts."] = "Отображать информацию друзей по RealID в две строки для отображения рассылки."
L["Autohide Delay:"] = "Задержка скрывания"
L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."] = "Устанавливает время исчезновения подсказки, после ухода курсора с инфо-текста."
L["S&L Guild"] = true
L["These options are for modifing the Shadow & Light Guild datatext."] = "Опции для настройки инфо-текста S&L Guild."
L["Show total guild members in the datatext."] = "Показывать общее кол-во членов гильдии на инфо-тексте."
L["Hide MOTD"] = "Скрыть сообщение дня"
L["Hide the guild's Message of the Day in the tooltip."] = "Скрывает сообщение дня гильдии на подсказке."
L["Hide Guild"] = "Скрыть гильдию"
L["Minimize the Guild Datatext."] = "Минимизировать состав гильдии."
L["Hide Guild Name"] = "Скрыть название гильдии"
L["Hide the guild's name in the tooltip."] = "Скрывает название гильдии на подсказке."
L["S&L Mail"] = true
L["These options are for modifing the Shadow & Light Mail datatext."] = "Опции для настройки инфо-текста S&L Mail"
L["Minimap icon"] = "Иконка на миникарте"
L["If enabled will show new mail icon on minimap."] = "Если включено, то иконка почты на миникарте будет отображаться."
L["Options below are for standard ElvUI's durability datatext."] = "Опции ниже предназначены для стандартного инфо-тектса прочности."
L["If enabled will color durability text based on it's value."] = "Если включено, будет окрашивать текст прочности в зависимости от его значения."
L["Durability Threshold"] = "Порог прочности"
L["Datatext will flash if durability shown will be equal or lower that this value. Set to -1 to disable"] = "Инфотекст начнет мигать, если показанная прочность будет меньшей либо равной заданному числу. Поставьте на -1 для отключения."
L["Short text"] = "Короткий текст"
L["Changes the text string to a shorter variant."] = "Зменяет текст на инфо-тексте более коротким вариантом."
L["Delete character info"] = "Удалить данные персонажа."
L["Remove selected character from the stored gold values"] = "Удалить выбранного персонажа из данных о золоте."
L["Are you sure you want to remove |cff1784d1%s|r from currency datatexts?"] = "Вы уверены, что хотите удалить |cff1784d1%s|r из инфо-текстов валют?л"
L["Time Played"] = "Времени в игре"
L["Account Time Played"] = "Время в игре на аккаунте"

--Equip Manager
L["Equipment Manager"] = "Менеджер экипировки"
L["EM_DESC"] = "Этот модуль предоставляет различные опции для автоматической смены комплектов экипировки при переключении набора талантов или попадании в определенную локацию."
L['Equipment Set Overlay'] = "Название комплекта"
L['Show the associated equipment sets for the items in your bags (or bank).'] = "Отображает название комплекта экипировки, к которому привязан предмет, на его иконке в сумках или банке."
L["Here you can choose what equipment sets to use in different situations."] = "Здесь Вы можете выбрать какие комплекты экипировки использовать в различных случаях."
L["Equip this set when switching to specialization %s."] = "Надеть этот комплект при переключении на специализацию %s."
L["Equip this set for open world/general use."] = "Использовать этот комплект для открытого мира/общего назначения."
L["Equip this set after entering dungeons or raids."] = "Использовать этот комплект после входа в подземелье или рейд."
L["Equip this set after entering battlegrounds or arens."] = "Использовать этот комплект на полях боя или арене."
L["Use a dedicated set for instances and raids."] = "Использовать отдельный комплект для подземелий и рейдов"
L["Use a dedicated set for PvP situations."] = "Использовать отдельный комплект для пвп"
L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."] = "Невзможно переключиться на подходящий комплект в бою. Переключение произойдет после окончания боя."

--Loot
L["Loot Dropped:"] = "Список добычи:"
L["Loot Auto Roll"] = "Автоматические броски"
L["LOOT_AUTO_DESC"] = "Автоматически выбирает вариант при розыгрыше добычи, основываясь на заданных настройках."
L["Auto Confirm"] = "Автоматически подтвердить"
L["Automatically click OK on BOP items"] = "Автоматически подтверждать поднятие/разрушение ПпП вещей"
L["Auto Greed"] = "Авто. не откажусь"
L["Automatically greed uncommon (green) quality items at max level"] = "Автоматически нажимать \"не откажусь\" на предметы зеленого качества на максимальном уровне."
L["Auto Disenchant"] = "Авто. распыление"
L["Automatically disenchant uncommon (green) quality items at max level"] = "Автоматически нажимать \"распылить\" на вещи зеленого качества на максимальном уровне."
L["Loot Quality"] = "Качество добычи"
L["Sets the auto greed/disenchant quality\n\nUncommon: Rolls on Uncommon only\nRare: Rolls on Rares & Uncommon"] = "Устанавливает качество предмета для автоматических бросков.\n\nНеобычное: разыгрывает только зеленые\nРедкие: разыгрывает синие и зеленые."
L["Roll based on level."] = "Уровень розыгрыша"
L["This will auto-roll if you are above the given level if: You cannot equip the item being rolled on, or the ilevel of your equipped item is higher than the item being rolled on or you have an heirloom equipped in that slot"] = "Автоматически разыгрывать добычу после установленного уровня, если: вы не можете надеть предмет, или надетый на вас предмет выше уровнем, или в этом слоте у вас фамильный предмет"
L["Level to start auto-rolling from"] = "Минимальный уровень розыгрыша"
L["Loot Announcer"] = "Оповещение о добыче"
L["AUTOANNOUNCE_DESC"] = "When enabled, will automatically announce the loot when the loot window opens.\n\n|cffFF0000Note:|r Raid Lead, Assist, & Master Looter Only."
L["Auto Announce"] = "Авто оповещение"
L["Manual Override"] = "Принудительно"
L["Sets the button for manual override."] = "Задает кнопку, при зажатии которой добыча будет анонсироватья."
L["No Override"] = "Нет принудительного"
L["Automatic Override"] = "Автоматически"
L["Sets the alpha of Loot Roll Histroy frame."] = "Устанавливает прозрачность окна истории добычи"
L["Sets the minimum loot threshold to announce."] = "Минимальное качество предмета, для вывода в чате."
L["Select chat channel to announce loot to."] = "Канал чата, для вывода сообщений."
L["Loot Roll History"] = "История добычи"
L["LOOTH_DESC"] = "Опции, задающие поведение окна истории добычи."
L["Auto hide"] = "Автоматически скрывать"
L["Automaticaly hides Loot Roll Histroy frame when leaving the instance."] = "Автоматически скрывать окно истории добычи Blizzard при выходе из подземелья."
L["Channels"] = "Каналы"
L["Private channels"] = "Личные сообщения"
L["Incoming"] = "Входящие"
L["Outgoing"] = "Исходящие"

--Media
L["SLE_MEDIA_ZONES"] = {
	"Москва",
	"Луна",
	"BlizzCon",
	"Деревня Гадюкино",
	"Нижние Балбуки",
	"Светлое Будущее",
}
L["SLE_MEDIA_PVP"] = {
	"(Территория Орды)",
	"(Территория Альянса)",
	"(Спорная территори)",
	"(Территория пришельцев)",
	"(Курилка)",
	"(Зана отдыха)",
}
L["SLE_MEDIA_SUBZONES"] = {
	"Администрация",
	"Склад водки",
	"Пожарный выход",
	"Кабинет директора",
}
L["SLE_MEDIA_PVPARENA"] = {
	"(PvP)",
	"Не курить!",
	"Самый низки наалог на доходы",
	"Свободная зона",
	"Идет самоуничтожение",
}
L["SLE_MEDIA"] = "Опции для изменения внешнего вида некоторых элементов интерфейса."
L["Zone Text"] = "Текст локации"
L["Subzone Text"] = "Название сублокации"
L["PvP Status Text"] = "PvP статус"
L["Misc Texts"] = "Прочие тексты"
L["Mail Text"] = "Текст письма"
L["Chat Editbox Text"] = "Текст поля ввода"
L["Gossip and Quest Frames Text"] = "Текст окон заданий и диалогов"

--Minimap
L["Minimap Options"] = "Опции миникарты"
L["MINIMAP_DESC"] = "Эти опции влияют на различные функции миникарты.  Некоторые опции погут не работать, если вы отключите миникарты в основных настройках ElvUI."
L["Hide minimap in combat."] = "Скрыть миникарту в бою"
L["Minimap Alpha"] = "Прозрачность миникарты"
L["Minimap Coordinates"] = "Координаты на миникарте"
L["Enable/Disable Square Minimap Coords."] = "Включить/выключить координаты на миникарте."
L["Coords Display"] = "Отображение координат"
L["Change settings for the display of the coordinates that are on the minimap."] = "Укажите условие отображения координат на миникарте."
L["Coords Location"] = "Позиция координат"
L["This will determine where the coords are shown on the minimap."] = "Определяет место, в котором будут отображаться координаты на миникарте"
L["Bottom Corners"] = "Нижние углы"
L["Bottom Center"] = "Внизу по центру"
L["Minimap Buttons"] = "Кнопки на миникарте"
L["Enable/Disable Square Minimap Buttons."] = "Включить/выключить квадратные иконки у миникарты."
L["Bar Enable"] = "Включить полосу"
L["Enable/Disable Square Minimap Bar."] = "Включить/выключить панель для иконок миникарты."
L["Skin Dungeon"] = "Иконка поиска"
L["Skin dungeon icon."] = "Забирать иконку поиска группы."
L["Skin Mail"] = "Иконка почты"
L["Skin mail icon."] = "Забирать иконку письма."
L["The size of the minimap buttons when not anchored to the minimap."] = "Размер конопок миникарты, когда они не прикреплены к нейй."
L["Icons Per Row"] = "Иконок в ряду"
L["Anchor mode for displaying the minimap buttons are skinned."] = "Место расположения иконок аддонов, когда они стилизованы."
L["Show minimap buttons on mouseover."] = "Отображать иконки при наведении мыши."
L["Instance indication"] = "Индикатор подземелья"
L["Show instance difficulty info as text."] = "Показывать информацию о сложности подземелья в виде текста"
L["Show texture"] = "Показывать текстуру"
L["Show instance difficulty info as default texture."] = "Показывать информацию о сложности подземелья в виде стандартной текстуры"
L["Sets the colors for difficulty abbreviation"] = "Устанавливает цвета для аббревиатур уровней сложности."
L["Location Panel"] = "Панель локации"
L["Update Throttle"] = "Частота обновления"
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = "Частота обновления координат и текста локации. Проверка проводится чаще с более низким значением."
L["Full Location"] = "Полный текст"
L["Color Type"] = "Тип окрашивания"
L["Reaction"] = "Отношение"
L["Teleports"] = "Телепорты"
L["Portals"] = "Порталы"
L["Link Position"] = "Сообщать координаты"
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = "Разрешить отправку ваших координат в поле ввода чата при нажатии shift+ПКМ на названии зоны."
L["Relocation Menu"] = "Меню переещений"
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = "ПКМ на панели локалии откроет меню с доступными вариантами перемещени (камни, порталы и т.д.)"
L["Custom Width"] = "Своя ширина"
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = "По умолчанию ширина меню будет равна ширине панели. Включение данной опции позволит установить свою ширину."
L["Justify Text"] = "Выравнивание тектса"


--Miscs
L["Error Frame"] = "Фрейм ошибок"
L["Ghost Frame"] = "Кнопка призрака"
L["Raid Utility Mouse Over"] = "Управление рейдом при наведении"
L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"] = "Устанавливает ширину фрейма ошибок. Если фрейм окажется слишком узким, текст будет разделен на несколько строк."
L["Set the height of Error Frame. Higher frame can show more lines at once."] = "Устанавливает высоту фрейма ошибок. Чем выше фрейм, тем больше строк может быть показано одновременно."
L["Enabling mouse over will make ElvUI's raid utility show on mouse over instead of always showing."] = "Включение позволит отображать кнопку управления рейдом только при наведении курсора."
L["Adjust the position of the threat bar to any of the datatext panels in ElvUI & S&L."] = "Позволяет поместить полосу угрозы на любой панели инфо-текстов."
L["Enhanced Vehicle Bar"] = "Улучшенный контроль машин"
L["A different look/feel vehicle bar"] = "Измененный вид панели техники"

--Nameplates
L["Target Count"] = "Число выделений"
L["Display the number of party / raid members targetting the nameplate unit."] = "Показывать количество членов группы/рейда, выбравших в цель этот юнит."
L["Threat Text"] = "Текст угрозы"
L["Display threat level as text on targeted, boss or mouseover nameplate."] = "Отображает текст угрозы на индикаторе цели, босса или юнита под курсором."

--Professions
L['Scroll'] = "Свиток"

--PvP
L["Functions dedicated to player versus player modes."] = "Функции для режима игрок Против Игрока."
L["PvP Auto Release"] = "Автоматический выход из тела"
L["Automatically release body when killed inside a battleground."] = "Автоматически выходить из тела на полях боя."
L["Check for rebirth mechanics"] = "Проверять перерождение"
L["Do not release if reincarnation or soulstone is up."] = "Не выходить из тела, если доступна реинкарнация или камень души."
L["SLE_DuelCancel_REGULAR"] = "Запрос дуэли от %s отклонен."
L["SLE_DuelCancel_PET"] = "Запрос дуэли питомцев от %s отклонен."
L["Automatically cancel PvP duel requests."] = "Автоматически отклонять вызовы на бой"
L["Automatically cancel pet battles duel requests."] = "Автоматически отклонять вызовы на бой питомцев"
L["Announce"] = "Сообщать"
L["Announce in chat if duel was rejected."] = "Сообщать в чат, когда запрос был отклонен."
L["Show your PvP killing blows as a popup."] = "Отображать смертельные удары в пвп всплывающим окном."
L["KB Sound"] = "Звук"
L["Play sound when Kkilling blows popup is shown."] = "Проигрывать звук при нанесении смертельного удара."

--Quests
L["Rested"] = "Отдых"
L["Auto Reward"] = "Автоматическая награда"
L["Automatically selects areward with higherst selling price when quest is completed. Does not really finish the quest."] = "Автоматическивыбирать награду с наивысшей стоимостью при сдаче квеста."

--Raid Marks
L["Raid Markers"] = "Рейдовые Метки"
L["Click to clear the mark."] = "Снять метку"
L["Click to mark the target."] = "Повесить метку"
L["%sClick to remove all worldmarkers."] = "%s+ЛКМ для удаления всех меток на земле."
L["%sClick to place a worldmarker."] = "%s+ЛКМ для установки метки на землю."
L["Raid Marker Bar"] = "Полоса меток"
L["Options for panels providing fast access to raid markers and flares."] = "Опции панелей, предоставляющих быстрый доступ к рейдовым меткам и маркерам на земле."
L["Show/Hide raid marks."] = "Показать/скрыть фрейм рейдовых меток."
L["Reverse"] = "Обратный порядок"
L["Modifier Key"] = "Модификатор"
L["Set the modifier key for placing world markers."] = "Модификатор для установки меток на земле."
L["Visibility State"] = "Видимость"

--Raidroles
L["Options for customizing Blizzard Raid Manager \"O - > Raid\""] = "Опции настройки менеджера рейда \"О -> Рейд\""
L["Show role icons"] = "Показывать иконки роли"
L["Show level"] = "Показывать уровень"

--Skins
L["SLE_SKINS_DESC"] = [[Эта секция предназанчена для модификации существующий в ElvUI скионв.

Некоторые опции могут быть недоступны, если отключен соответствующий скин в настройках ElvUI.]]
L["Pet Battle Status"] = "Статус битвы питомцев"
L["Pet Battle AB"] = "Панель команд битв питомцев"
L["Sets the texture for statusbars in quest tracker, e.g. bonus objectives/timers."] = "Устанавливает текстуру для полос состояния в списке заданий (бонусные миссии/таймеры)"
L["Statusbar Color"] = "Цвет полос состояния"
L["Class Colored Statusbars"] = "Полоса состояния по классу"
L["Underline"] = "Подчеркивание"
L["Creates a cosmetic line under objective headers."] = "Создает косметическую полосу под заголовками"
L["Underline Color"] = "Цвет подчеркивания"
L["Class Colored Underline"] = "По классу"
L["Underline Height"] = "Высота полосы"
L["Header Text Color"] = "Цвет текста заголовка"
L["Class Colored Header Text"] = "По классу"
L["Subpages"] = "Субстраницы"
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = "Субстраницы это блоки из 10 предметов. Эта опция показывает сколько субстраниц будет показано на одной странице."
-- L["SLE_SKINS_QUESTKING_DESC"] = [[Following options controls additional features for Quest King addon. Settings are character based.
-- Due to the way of how that addon works it is mostly impossible to hook into its functions.
-- Affected options are:
-- - Tooltip positioning and scale
-- - Clicks processing
-- - Quest tagging
-- - Award frame is now following Objective tracker opions of ElvUI
-- - Quest names are following header settings from S&L's objective tracker skin
-- - Quest King's position is now controlled by ElvUI's objectives mover
-- - A lot of lines are now pulled from the client instead of being hardcoded
-- - Tracked quest icon is larger]]
-- L["Tooltip Anchor"] = true
-- L["Tooltip Scale"] = true
-- L["Quest Type Indications"] = true
-- L["Clicks Registration"] = true
-- L["SLE_SKINS_QUESTKING_TEMPLATE_DESC"] = [[|cff9482c9Quest King|r
-- Original Quest King's controls:
-- Left Click to open quest info
-- Alt + Right Click to untrack
-- Alt + Left Click to collapce quest
-- Right Click to set quest watch

-- |cff9482c9Blizzlike|r
-- Controls of standart Blizzard quest log:
-- Left Click to open quest info
-- Shift + Left Click to untrack
-- Right Click to set uest follow
-- Ctrl + Left Click to collapce]]
-- L["SLE_QUESTKING_Required"] = "  Required: "
L["ElvUI Objective Tracker"] = "Список задач ElvUI"
L["ElvUI Skins"] = "Скины ElvUI"

--Toolbars
L["We are sorry, but you can't do this now. Try again after the end of this combat."] = "Извините, но Вы не можете этого сделать сейчас. Попробуйте снова после окончания текущего боя."
L["Right-click to drop the item."] = "ПКМ для уничтожения предмета."
L["Button Size"] = "Размер кнопок"
L["Only active buttons"] = "Только активные"
--Farm
L["Tilled Soil"] = "Возделанная земля"
L["Farm Seed Bars"] = "Панели семян"
L["Farm Tool Bar"] = "Панель инструментов"
L["Farm Portal Bar"] = "Панель порталов"
L["Farm"] = "Ферма"
L["Only show the buttons for the seeds, portals, tools you have in your bags."] = "Отображать только кнопки для тех семян/инструментов/порталов, которые есть у Вас в сумках."
L["Auto Planting"] = "Автоматическая посадка"
L["Automatically plant seeds to the nearest tilled soil if one is not already selected."] = "Автоматически высаживать указанное растение на ближайшую возделанную землю, если не выбрана другая."
L["Quest Glow"] = "Свечение заданий"
L["Show glowing border on seeds needed for any quest in your log."] = "Показывать светящуюся границу на семенах, необходимых на какое-либо из взятых заданий из Вашего журнала."
L["Dock Buttons To"] = "Прикрепить кнопки к"
L["Change the position from where seed bars will grow."] = "Изменить сторону, с которой будут расти панели семян."
--Garrison
L["Garrison Tools Bar"] = "Панель гарнизона"
L["Auto Work Orders"] = "Автоматические заказы"
L["Automatically queue maximum number of work orders available when visitin respected NPC."] = "Автоматически делать максимально возможное количество заказов при открытии соответствующего диалога."
L["Auto Work Orders for Warmill"] = "Авто. заказы на фабрике"
L["Automatically queue maximum number of work orders available for Warmill/Dwarven Bunker."] = "Автоматически делать максимальное количество заказов для военной фабрики/дворфийского бункера."
L["Auto Work Orders for Trading Post"] = "Авто. заказы в торговой лавке"
L["Automatically queue maximum number of work orders available for Trading Post."] = "Автоматически делать максимальное количество заказов для торговой лавки."
L["Auto Work Orders for Shipyard"] = "Авто. заказы на верфи"
L["Automatically queue maximum number of work orders available for Shipyard."] = "Автоматически делать максимальное количество заказов для верфи."

--Tooltip
L["Faction Icon"] = "Иконка фракции"
L["Show faction icon to the left of player's name on tooltip."] = "Отображать иконку фракции около имени игроков в подсказках"
L["TTOFFSET_DESC"] = "Добавляет возможность сделать отступ подсказки от курсора. Работает только при включенной опции \"Около курсора\" в ElvUI."
L["Tooltip X-offset"] = "Смещение подсказки по X"
L["Offset the tooltip on the X-axis."] = "Смещает подсказку по оси X относительно выбранной точки крепления."
L["Tooltip Y-offset"] = "Смещение подсказки по Y"
L["Offset the tooltip on the Y-axis."] = "Смещает подсказку по оси Y относительно выбранной точки крепления."
L["RAID_HFC"] = "ЦАП"
L["RAID_BRF"] = "ЛКЧГ"
L["RAID_HM"] = "ВМ"
L["Raid Progression"] = "Рейдовый прогресс"
L["Show raid experience of character in tooltip (requires holding shift)."] = "Отображает рейдовый опыт данного персонажа (требуется зажатый shift)"

--UI Buttons
L["S&L UI Buttons"] = "Меню S&L"
L["UB_DESC"] = "Добавляет небольшую полосу с кнопками, дающими доступ к набору полезных функций."
L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."] = "Пределы для броска указаны некорректно! Минимальное значение должно быть меньше максимального."
L["ElvUI Config"] = "Настройка ElvUI"
L["Move UI"] = "Разблокировать элементы"
L["Reload UI"] = "Перезагрузить интерфейс"
L["AddOns Manager"] = "Менеджер аддонов"
L["Boss Mod"] = "Босс мод"
L["AddOns"] = "Аддоны"
L["S&L Config"] = "Настройки Shadow & Light"
L["Click to toggle config window"] = "Нажмите для отображения окна настроек"
L["Click to toggle Shadow & Light config group"] = "Нажмите, чтобы открыть группу настроек Shadow & Light"
L["Click to reload your interface"] = "Нажмите для перезагрузки интерфейса"
L["Click to unlock moving ElvUI elements"] = "Нажмите для входа в режим перемещения элементов"
L["Click to toggle the AddOn Manager frame."] = "Нажмите для отображения окна менеджера аддонов."
L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."] = "Нажмите для отображения окна настроек включенного босс мода."
L["Custom"] = "Свое"
L["Minimum Roll Value"] = "Минимальное значение броска"
L["The lower limit for custom roll button."] = "Нижняя граница броска при использовании собственных установок."
L["Maximum Roll Value"] = "Масимальное значение броска"
L["The higher limit for custom roll button."] = "Верхняя граница броска при использовании собственных установок."
L["Quick Action"] = "Быстрое действие"
L["Use quick access (on right click) for this button."] = "Функция для быстрого действия. Вызывается нажатием ПКМ на кнопке открытия списка."
L["Function"] = "Функция"
L["Function called by quick access."] = "Функция для вызова быстрым действием"

--Unitframes
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = "Опции для дополнительной настройки рамок юнитов. Пожалуйста, не изменяйте эти настройки в то же время, кода включен тестовый режим рамок боссов и арены в ElvUI. Это сделает их невидимыми до повторного включения."
L["Player Frame Indicators"] = "Индикаторы игрока"
L["Combat Icon"] = "Иконка боя"
L["LFG Icons"] = "Иконки ЛФГ"
L["Choose what icon set will unitframes and chat use."] = "Набор иконок для использования на рамках юнитов и в чате."
L["Offline Indicator"] = "Не в сети"
L["Shows an icon on party or raid unitframes for people that are offline."] = "Показывает иконку на рамках членов группы или рейда, которые находятся не в сети"
L["Texture"] = "Текстура"
L["Statusbars"] = "Полосы состояния"
L["Power Texture"] = "Текстура ресурса"
L["Castbar Texture"] = "Текстура полосы заклинаний"
L["Red Icon"] = "Красная иконка"
L["Aura Bars Texture"] = "Текстура полос аур"
L["Higher Overlay Portrait"] = "Наложение портрета над рамкой"
L["Makes frame portrait visible regardles of health level when overlay portrait is set."] = "Делает портрет на этой рамке видимым не зависимо от кол-ва оставшегося здоровья при наложении."
L["Classbar Texture"] = "Текстура классовой полосы"
L["Resize Health Prediction"] = "Подогнать входящее исцеление"
L["Slightly chages size of health prediction bars."] = "Немного изменяет размер полос входящего исцеления."


--Viewport
L["Viewport"] = true
L["Left Offset"] = "Отступ слева"
L["Set the offset from the left border of the screen."] = "Устаназвивает отступ от левого края экрана."
L["Right Offset"] = "Отступ справа"
L["Set the offset from the right border of the screen."] = "Устаназвивает отступ от правого края экрана."
L["Top Offset"] = "Отступ сверху"
L["Set the offset from the top border of the screen."] = "Устаназвивает отступ от верхнего края экрана."
L["Bottom Offset"] = "Отступ снизу"
L["Set the offset from the bottom border of the screen."] = "Устаназвивает отступ от нижнего края экрана."

--Help
L["SLE_DESC"] = [=[|cff9482c9Shadow & Light|r это расширение для ElvUI. Оно добавляет:
- много новых функций
- больше вариантов настройки для существующих опций

|cff3cbf27Внимание:|r Оно совместимо с большинством существующих плагинов для ElvUI. Однако некоторые функции могут оказаться недоступными для избежания конфликтов.]=]
L["Links"] = "ССылки"
L["LINK_DESC"] = [[Ниже представлены ссылки на страницы Shadow & Light на нескольких сайтах.]]

--FAQ--
L["FAQ_DESC"] = "Эта секция содержит некоторые вопросы о ElvUI и Shadow & Light."
L["FAQ_Elv_1"] = [[|cff30ee30В: Где я могу получить поддержку по ElvUI?|r
|cff9482c9О:|r Лучше всего на официальном форуме - tukui.org/forums/
Для сообщения об ошибках лучше использовать тикет треккер - git.tukui.org/Elv/elvui/issues]]
L["FAQ_Elv_2"] = [[|cff30ee30В: Нужно ли мне для этого знать английский?|r
|cff9482c9О:|r Английский является официальным языком на форумах tukui.org, так что большинство сообщений написано на нем.
Но это не значит, что это единственный дозволенный язык. Вы можете найти сообщения на испанском, французском, немецком, русском, итальянском и других языках.
Пока вы придерживаетесь простых правил приличия, никто не будет против сообщений на вашем родном языке. Например, вы можете указать язык сообщения в названии темы.
Имейте ввиду, что вы все равно можете получить ответ на английском, т.к. отвечающи может не знать вашего языка.]]
L["FAQ_Elv_3"] = [[|cff30ee30В: Что нужно указать при сообщении об ошибке?|r
|cff9482c9О:|r Прежде всего убедитесь, что ошибка вызвана самим ElvUI.
Для этого отключите все аддоны, кроме ElvUI и ElvUI_Config.
Если ошибка остается, то она родная и можно о ней сообщать.
Необходимо будет указать версию ElvUI ("последняя" это не номер), текст ошибки и, при необходимости, скриншот.
Чем подробнее вы распишите саму ошибку и обстоятельства ее возникновения, тем быстрее и направленнее будет ее решение.]]
L["FAQ_Elv_4"] = [[|cff30ee30В: Почему некоторые опции не применяются на других персонажах, использующих тот же профиль?|r
|cff9482c9О:|r В ElvUI есть несколько типов опций. Первые (profile) храняться в профиле, вторые (private) применимы только для текущего персонажа, третьи (global) применяются для всех персонажей не зависимо от профиля.
Скорее всего в данном случае речь идет об опции второго типа.]]
L["FAQ_Elv_5"] = [[|cff30ee30В: Какие команды чата есть в ElvUI?|r
|cff9482c9О:|r У ElvUI есть множество команд с разным назначением. Напрмиер:
/ec или /elvui - открывает окно настроек
/bgstats - отображает специальные инфо-тексты полей боя, если вы на нем и уже успели скрыть их
/hellokitty - Хотите няшный розовый интерфейс? Получите, распишитесь!
/harlemshake - Нужна встряска? Да не вопрос!
/luaerror - перегружает интерфейс в тестовый режим, предназначенный для адекватного сообщения об ошибках (см. вопрос 3)
/egrid - Устанавливает размер сетки в режиме показа фиксаторов
/moveui - Дает вам двигать элементы
/resetui - Сбрасывает интерфейс на умолчания]]
L["FAQ_sle_1"] = [[|cff30ee30В: Что делать, если я получаю сообщения об ошибках в Shadow & Light?|r
|cff9482c9О:|r Примерно то же самое, что и для ElvUI (см. другой раздел справки).
Только теперь понадобится еще и указать версию S&L.]]
L["FAQ_sle_2"] = [[|cff30ee30В: Применима ли языковая политика форумов ElvUI к Shadow & Light?|r
|cff9482c9О:|r Да. За исключением того, что для S&L официальных языков поддержки два - английский и русский.]]
L["FAQ_sle_3"] = [[|cff30ee30В: Почему шаблоны интерфейса в игре не похожи на то, что я видел на скриншотах на странице аддона?|r
|cff9482c9О:|r Потому что мы просто забыли их обновить.]]
L["FAQ_sle_4"] = [[|cff30ee30В: Почему я вижу странные иконки около имен некоторых людей в чате?|r
|cff9482c9О:|r Эти ионки обозначают людей, которых мы хотели выделить по той или иной причине.
Например: |TInterface\AddOns\ElvUI_SLE\media\textures\SLE_Chat_LogoD:0:2|t иконка для персонажей Дарта, |TInterface\AddOns\ElvUI_SLE\media\textures\SLE_Chat_Logo:0:2|t для персонажей Repooc'а, а |TInterface\AddOns\ElvUI_SLE\media\textures\Chat_Test:16:16|t для людей, котрые в свое время помогли вычислить хитрый баг.]]
L["FAQ_sle_5"] = [[|cff30ee30В: Как я могу связаться с авторами?|r
|cff9482c9О:|r По очевидным причинам мы не раздаем свои контакты всем желающим. Так что лучшим методом являются форумы tukui.org.]]

--Credits--
L["ELVUI_SLE_CREDITS"] = "Мы хотели бы отметить и поблагодарить следующих людей за помощь в создании этого аддона."
L["ELVUI_SLE_MISC"] = [=[BuG - за постоянные и ржачные методы сломать все и вся
TheSamaKutra
Сообщество Tukui
]=]
