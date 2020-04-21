-- English localization file for ruRU.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "ruRU")

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
L["SLE_DB_CONVERT_COMPLETE_TEXT"] = "S&L сконвертировал устаревшие поля базы данных.\n\n|cff14adcdОбновлены профили:|r\n%s\n\n|cff14adcdОбновлены личные настройки для персонажей:|r\n%s\n\nМожете спокойно продолжать играть :)"

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
L["AFK Mode in |cff9482c9Shadow & Light|r is additional settings/elements for standard |cff1784d1ElvUI|r AFK screen."] = "Режим АФК в |cff9482c9Shadow & Light|r это дополнительные настройки/элементы стандартного экрана отсутствия |cff1784d1ElvUI|r."
L["This option is bound to character and requires a UI reload to take effect."] = "Эта опция привязана к персонажу и требует перезагрузки для активации."
L["Shadow & Light Imports"] = "Импорт Shadow & Light"
L["You can now choose if you want to use one of the authors' set of options. This will change the positioning of some elements as well of other various options."] = "Вы можете использовать набор настроек, используемый одним из представленных людей. Будут изменены положения элементов и другие настройки."
L["SLE_Install_Text_AUTHOR"] = [=[Этот шаг опционален и должен использоваться только в  случае, если вы собираетесь использовать одну из наших конфигурацй. В зависимости от выбранного расположения в установке ElvUI результат может отличться.
Если вы не выберете ни один из вариантов, то следующий шаг установки будет автоматически пропущен.

Была выбрана роль |cff1784d1"%s"|r.

|cffFF0000Внимание:|r Пожалуйста помните, что авторы могут не использовать тему/роль, которую вы выбрали, и потому результат не всегда будет хорошим. Также переключение между шаблонами здесь может привести к неоднозначным результатам.]=]
L["Darth's Config"] = "Опции Дарта"
L["Repooc's Config"] = "Опции Repooc'а"
L["Affinitii's Config"] = "Опции Affinitii"
L["Darth's Default Set"] = "Установлены настройки Дарта"
L["Repooc's Default Set"] = "Установлены настройки Repooc'а"
L["Affinitii's Default Set"] = "Установлены настройки Affinitii"
L["Layout & Settings Import"] = "Импорт расположений и настроек"
L["Layout Old"] = "Старое расположение"
L["You have selected to use %s and role %s."] = "Вы выбрали %s для роли %s."
L["SLE_INSTALL_LAYOUT_TEXT2"] = [[Данные опции импортируют расположения/настройки аддонов для выбранных опций и роли.
Учтите, что эти пресеты могут включать незнакомые вам настройки.

Также это пожет сбросить/изменить некоторые из опций, выбранных вами на предыдущих шагах.]]
L["|cff1784d1%s|r role was chosen"] = 'Была выбрана роль |cff1784d1"%s"|r.'
L["Import Profile"] = "Импорт профиля"
L["SLE_INSTALL_SETTINGS_LAYOUT_TEXT"] = [[Это действие может привести к потере некоторых ваших настроек.
Продолжить?]]
L["SLE_INSTALL_SETTINGS_ADDONS_TEXT"] = [[Это действие создаст профили для следующих аддонов (если они включены) и переключится на них:
%s

Продолжить?]]

--Config replacements
L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."] = "Shadow & Light отключил эту опцию. Для ее возвращения нужно отключить соответственную опцию в S&L. Нажмите для перехода к ней."

--Core
L["SLE_LOGIN_MSG"] = "|cff9482c9Shadow & Light|r версии |cff1784d1%s%s|r для ElvUI загружен. Спасибо за использование."
L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."] = "Плагин для |cff1784d1ElvUI|r  от\nDarth Predator'а и Repooc'а"
L["Reset All"] = "Сбросить все"
L["Resets all movers & options for S&L."] = "Сбросить все фиксаторы и опции S&L"
L["WARNING: This will reset all movers & options for S&L and reload the screen."] = true
L["Reset these options to defaults"] = "Восстановить умолчания для этих опций"
L["Modules designed for older expantions"] = "Модули для предыдущих дополнений"
L["Game Menu Buttons"] = "Кнопки главного меню"
L["Adds |cff9482c9Shadow & Light|r buttons to main game menu."] = "Добавляет кнопки |cff9482c9Shadow & Light|r в главное меню."
L["Advanced Options"] = "Продвинутые опции"
L["SLE_Advanced_Desc"] = [[Следующие опции дают доступ к дополнительным настройкам.
Не рекомендуется для использванием новичкам или людям без опыта настройки аддонов.]]
L["Allow Advanced Options"] = "Разрешить продвинутые настройки"
L["Change Elv's options limits"] = "Измениь пределы опций ElvUI"
L["Allow |cff9482c9Shadow & Light|r to change some of ElvUI's options limits."] = "Позволяет |cff9482c9Shadow & Light|r изменить пределы некоторых опций ElvUI."
L["Cyrillics Support"] = "Поддержка кириллицы"
L["SLE_CYR_DESC"] = [[Если вы иногда (или на постоянной основе) используете кириллицу при написании сообщений
и постоянно забываете переключить язык для ввода слэш команд, тогда эти опции для вас.
Они позволяют использовать команды ElvUI на неверной раскладке. Всегда работает на русском клиенте.
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
L["Modules"] = "Модули"
L["Options for different S&L modules."] = "Опции различных модулей S&L."

--Config groups
L["S&L: All"] = "S&L: Все"
L["S&L: Datatexts"] = "S&L: Инфо-тексты"
L["S&L: Backgrounds"] = "S&L: Фоновые фреймы"
L["S&L: Misc"] = "S&L: Прочее"

--Actionbars
L["OOR as Bind Text"] = "Вне радиуса на назначнии"
L["Out Of Range indication will use keybind text instead of the whole icon."] = "Индикация о слишком далекой цели будет окрашивать текст назначенной клавиши вместо всей иконки."
L["Checked Texture"] = "Текстура выделения"
L["Highlight the button of the spell with areal effect until the area is selected."] = "Пдсвечивает кнопку с эффектом по области пока не будет выбрана точка применения."
L["Checked Texture Color"] = "Цвет выделения"

--Armory
L["SLE_Armory_Info"] = "Оружейная представляет стандартную информацию о предметах из ElvUI в другом виде. Имейте ввиду, что отображение чар, камней и уровней предметов не будет функционировать без активации соответствующей опции ElvUI. Для перехода в соответствующую секцию настроек, нажмите на кнопку ниже."
L["SLE_Armory_SkinDisabled"] = "Ты вырубил все скины, так что мы вырубили все функции во избежание адовых графических глюков. А чего еще ты ждал?"
L["Average"] = "Средний"
L["Not Enchanted"] = "Не зачаровано"
L["Empty Socket"] = "Пустой слот"
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
L["Full Item Level"] = "Полный уровень предметов"
L["Show both equipped and average item levels."] = "Отображать и уровень одетых предметов, и общий средний уровень."
L["Item Level Coloring"] = "Окраска уровней предметов"
L["Color code item levels values. Equipped will be gradient, average - selected color."] = "Окрашивает значения уровней предметов. Цвет уровня одетых вещей будет градиентом, цвет среднего урвоня по выбору."
L["Color of Average"] = "Цвет стреднего"
L["Sets the color of average item level."] = "Устанавливает цвет среднего уровня предметов."
L["Only Relevant Stats"] = "Только подходящие"
L["Show only those primary stats relevant to your spec."] = "Отображает только те основные характеристики, что подходят вашей текущей специализации."
L["SLE_ARMORY_POINTS_AVAILABLE"] = "Очков доступно: %s"
L["Show ElvUI skin's backdrop overlay"] = "Отображать фон скина ElvUI"
L["Try inspecting %s. Sometimes this work will take few second for waiting server's response."] = "Осматриваю %s. Можеть занять несколько секунд ожидания ответа сервера."
L['Inspect is canceled because target was changed or lost.'] = "Осмотр отменет, т.к. цель была изменена или потеряна."
L["You can't inspect while dead."] = "Мертвые не осматривают."
L["Show Inspection message in chat"] = "Отображать сообщение об осмотре в чате."
L["Font Size"] = "Размер шрифта"
L["General Fonts"] = "Общие шрифты"
L["Title"] = "Звание"
L["Level and race"] = "Уровень и раса"
L["Info Fonts"] = "Шрифты информации"
L["Block names"] = "Названия блоков"
L["PvP Type"] = "Режим PvP"
L["Spec Fonts"] = "Шрифты спека"
L["Azerite Level Position"] = "Позиция уровня азерита"
L["Transmog"] = "Трансмог"
L["Enable Glow"] = "Включить свечение"
L["Enable Arrow"] = "Включить стрелку"
L["Enables a small arrow-like indicator on the item slot. Howering over this arrow will show the item this slot is transmogged into."] = "отображать индикатор в виде стрелки на слоте. При наведении курсора на стрелку будет показываться название предмета трансмогрификации."
L["Glow Number"] = "Элементов свечения"
L["Glow Offset"] = "Отступ свечения"
L["Categories"] = "Категории"
L["Decimals"] = "Десятичные доли"
L["Show stats with decimals."] = "От ображать характеристики с десятичными долями."
L["Corruption / Resist"] = "Порча / Резист"

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
L["Crest"] = "Герб"
L["Faction Crest X-Offset"] = "Отступ по X герба фракции"
L["Faction Crest Y-Offset"] = "Отступ по Y герба фракции"
L["Race Crest X-Offset"] = "Отступ по X герба класса"
L["Race Crest Y-Offset"] = "Отступ по Y герба класса"
L["Texts Positions"] = "Позиции текстов"
L["Date X-Offset"] = "Отступ даты по X"
L["Date Y-Offset"] = "Отступ даты по Y"
L["Player Info X-Offset"] = "Отступ инфо игрока по X"
L["Player Info Y-Offset"] = "Отступ инфо игрока по Y"
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
L["Title font"] = "Зона"
L["Subtitle font"] = "Субзона"
L["Date font"] = "Дата"
L["Player info font"] = "Информация"
L["Tips font"] = "Подсказки"
L["Graphics"] = "Графика"

--Auras
L["Hide Buff Timer"] = "Скрыть время баффов"
L["This hides the time remaining for your buffs."] = "Скрывает оставшееся время действия баффов на вас."
L["Hide Debuff Timer"] = "Скрыть время дебаффов"
L["This hides the time remaining for your debuffs."] = "Скрывает оставшееся время действия дебаффов на вас."

--Backgrounds
L["Backgrounds"] = "Фоновые панели"
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
L["Hide in Pet Battle"] = "Прятать в битвах питомцев"
L["Show/Hide this frame during Pet Battles."] = "Показать/скрыть этот фрейм в битвах питомцев"

--Bags

--Blizzard
L["Move Blizzard frames"] = "Перемещение фреймов Blizzard"
L["Allow some Blizzard frames to be moved around."] = "Разрешить перемещение некоторых фреймов Blizzard."
L["Remember"] = "Запомнить"
L["Remember positions of frames after moving them."] = "Запомнить позицию фрейма после перемещения."
L["Pet Battles skinning"] = "Скин битв питомцев"
L["Make some elements of pet battles movable via toggle anchors."] = "Дает возможность перемещать некоторые элементы боев питомцев при пмощи фиксаторов."

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
L["Replaces long reports from damage meters with a clickable hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter the report of other things."] = "Заменяет длиные отчеты от аддонов для измерения УВС на гиперссылку, сокращая уровень спама в чате.\nКорректно работает с отчетами урона и исцеления. Может не отфильтровать другие специфические отчеты."
L["Texture Alpha"] = "Прозрачность текстур"
L["Allows separate alpha setting for textures in chat"] = "Включает отдельную настройку прозрачности для текстур в чате"
L["Chat Frame Justify"] = "Выравнивание текста"
L["Identify"] = "Определить"
L["Shows the message in each chat frame containing frame's number."] = "Оображает на каждой вкладке сообщеине с ее идентификатором."
L["This is %sFrame %s|r"] = "Это %sВкладка %s|r"
L["Loot Icons"] = "Иконки добычи"
L["Shows icons of items looted/created near respective messages in chat. Does not affect usual messages."] = "Отображает иконки созданных/полученных предметов в соответствующих сообщениях чата. Не влияет на обычные сообщения."
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
L["Following options determine which channels to save in chat history.\nNote: disabling a channel will immediately delete saved info for that channel."] = "Следующие опции задают каналы, которые будут сохраняться в истории чата.\nОбратите внимание: отключение канала тутже отчистит историю чата от сообщений из этого канала."
L["Alt-Click Invite"] = "Альт-клик для приглашения"
L["Allows you to invite people by alt-clicking their names in chat."] = "Позволяет приглашать людей в группу кликом по их именам с зажатым Alt."
L["Invite links"] = "Ссылки для приглашения"
L["Converts specified keywords to links that automatically invite message's author to group."] = "Превращает указаные слова в ссылки, клик по которым пригласит автора сообщения в группу."
L["Link Color"] = "Цвет ссылки"
L["Invite Keywords"] = "Ключевые слова для приглашения"
L["Chat Setup Delay"] = "Задержка подключения ата"
L["Manages the delay before S&L will execute hooks to ElvUI's chat positioning. Prevents some weird positioning issues."] = "задает задержку до выполнения хуков к функция позиционирования ElvUI. Предотвращает некоторые проблемы расположения окон чата."
L["Title Width"] = "Ширина названия"

--Databars
L["Full value on Exp Bar"] = "Полное значение опыта"
L["Changes the way text is shown on exp bar."] = "Изменяет отображение значений опыта на полосе."
L["Full value on Rep Bar"] = "Полное значение репутации"
L["Changes the way text is shown on rep bar."] = "Изменяет отображение значений репутации на полосе."
L["Auto Track Reputation"] = "Автоматически отслеживать репутацию"
L["Automatically sets reputation tracking to the most recent reputation change."] = "Автоматически изменять отслеживаемую репутацию на последнюю фракцию, чье отношение к Вам изменилось."
L["Ignore Guild Reputation"] = "Игнорировать гильдию"
L["Ignore guild reputation gains when autotracking."] = "Игнорировать репутацию гильдии при автоматическом отслеживании."
L["Change the style of reputation messages."] = "Изменяет стиль сообщений о получении репутации"
L["Reputation increase Style"] = "Стиль прибавки"
L["Reputation decrease Style"] = "Стиль уменьшения"
L["Output"] = "Вывод"
L["Determines in which frame reputation messages will be shown. Auto is for whatever frame has reputation messages enabled via Blizzard options."] = "Определяет вкладку, на которой будут выводиться сообщения. Авто будет выводить в соответствии с настроками Blizzard."
L["Change the style of experience gain messages."] = "Изменяет стиль сообщений о получении опыта."
L["Experience Style"] = "Стиль опыта"
L["Full List"] = "Полный список"
L["Show all factions affected by the latest reputation change. When disabled only first (in alphabetical order) affected faction will be shown."] = "Показывать все фракции, затронутые последним изменеием репутации. При отключении будет показываться только первая (в алфавитном порядке) фракция."
L["Full value on Azerite Bar"] = "Полное значение азерита"
L["Changes the way text is shown on azerite bar."] = "Изменяет отображение значения силы артефакта (азерита) на полосе."
L["Full value on Honor Bar"] = "Полное значение чести"
L["Changes the way text is shown on honor bar."] = "Изменяет отображение количества чести на полосе."
L["Chat Filters"] = "Фильтры чата"
L["Replace massages about honorable kills in chat."] = "Заменять сообщения о почетных победах в чате."
L["Award"] = "Награда"
L["Replace massages about honor points being awarded."] = "Заменять сообщения о наградной чести."
L["Defines the style of changed string. Colored parts will be shown with your selected value color in chat."] = "Определяет стил сообщения. Окрашенные элементы будут отображаться выбранным вами цветом значений."
L["Award Style"] = "Стиль наград"
L["HK Style"] = "Стиль почетной победы"
L["Honor Style"] = "Стиль чести"

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
-- L["|cffeda55fShift+Left Click|r a line to lookup a player."] = true
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
https://git.tukui.org/Darth_Predator/elvui-shadowandlight]=]
L["Additional Datatext Panels"] = "Дополнительные панели инфо-текстов"
L["DP_DESC"] = [=[Дополнительные панели под информационные тексты.
Всего здесь 8 дополнительных панелей и 20 дополнительных слотов под инфо-тексты.]=]
L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information."] = "Некоторые инфо-тексты, предоставляемые Shadow & LIght, имеют настройки, изменяющие отображаемую информацию."
L["Sets size of this panel"] = "Установить ширину панели"
L["Don't show this panel, only datatexts assigned to it."] = "Не показывать саму панель, а только назначенные на нее инфо-тексты"
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
L['Show Unused Currencies'] = "Показывать неиспользуемую валюту"
L["These options are for modifying the Shadow & Light Friends datatext."] = "Опции для настройки инфо-текста S&L Friends."
L["Hide In Combat"] = "Скрывать в бою"
L["Will not show the tooltip while in combat."] = "Не отображать подсказки инфо-текста в бою."
L["Hide Friends"] = "Скрыть друзей"
L["Hide Title"] = "Скрыть заголовок"
L["Minimize the Friend Datatext."] = "Минимизировать список друзей"
L["Show Totals"] = "Показывать общее"
L["Show total friends in the datatext."] = "Показывать общее кол-во друзей на инфо-тексте."
L["Hide Hints"] = "Скрыть управление"
L["Hide the hints in the tooltip."] = "Скрывать инструкцию по управлению в подсказке инфо-текста."
L["Expand RealID"] = "Развернуть RealID"
L["Display RealID with two lines to view broadcasts."] = "Отображать информацию друзей по RealID в две строки для отображения рассылки."
L["Autohide Delay:"] = "Задержка скрывания"
L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."] = "Устанавливает время исчезновения подсказки, после ухода курсора с инфо-текста."
L["S&L Guild"] = true
L["These options are for modifying the Shadow & Light Guild datatext."] = "Опции для настройки инфо-текста S&L Guild."
L["Show total guild members in the datatext."] = "Показывать общее кол-во членов гильдии на инфо-тексте."
L["Hide MOTD"] = "Скрыть сообщение дня"
L["Hide the guild's Message of the Day in the tooltip."] = "Скрывает сообщение дня гильдии на подсказке."
L["Hide Guild"] = "Скрыть гильдию"
L["Minimize the Guild Datatext."] = "Минимизировать состав гильдии."
L["Hide the Shadow & Light title in the tooltip."] = true
L["Hide the guild's name in the tooltip."] = "Скрывает название гильдии на подсказке."
L["S&L Mail"] = true
L["These options are for modifying the Shadow & Light Mail datatext."] = "Опции для настройки инфо-текста S&L Mail"
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
L["Hide panel background"] = "Скрыть фон"
L["SLE_DT_CURRENCY_WARNING_GOLD"] = [[На вашей панели %s включен инфо-текст |cff3cbf27"Золото"|r при активном инфо-тексте |cff3cbf27"S&L Currency"|r. Для корректной работы |cff3cbf27"S&L Currency"|r мы отключаем некоторые функции инфо-текста |cff3cbf27"Золото"|r. Для избежания данного конфликта вам необходимо заменить один из конфликтующих инфо-текстов.]]
L["Gold Sorting"] = "Сортировка золота"
L["Normal"] = "Нормальная"
L["Reversed"] = "Обратная"
L["Amount"] = "Количество"
L["Order of each toon. Smaller numbers will go first"] = "Порядок персонажей. Показ в порядке возрастания номера."
L["Tracked"] = "Отслеживание"
L["Gold Throttle"] = "Фильтрация золота"
L["Mode"] = "Режим"
L["Amount of gold needed on a character to show it in the list"] = "Кол-во золота, которое должно быть на персонаже, чтобы он отображался в списке."
L["Public Note Text Color"] = "Цвет заметки"
L["Officer Note Text Color"] = "Цвет офицерской заметки"

--Enhanced Shadows
L["Enhanced Shadows"] = "Улучшенные тени"
L["Use shadows on..."] = "Использовать тени на..."
L["SLE_EnhShadows_BarButtons_Option"] = "Кнопки панели %s"
L["SLE_EnhShadows_MicroButtons_Option"] = "Кнопки микроменю"
L["SLE_EnhShadows_StanceButtons_Option"] = "Кнопки стоек"
L["SLE_EnhShadows_PetButtons_Option"] = "Кнопки питомца"

--Equip Manager
L["Equipment Manager"] = "Менеджер экипировки"
L["EM_DESC"] = "Этот модуль предоставляет различные опции для автоматической смены комплектов экипировки при переключении набора талантов или попадании в определенную локацию."
L['Equipment Set Overlay'] = "Название комплекта"
L['Show the associated equipment sets for the items in your bags (or bank).'] = "Отображает название комплекта экипировки, к которому привязан предмет, на его иконке в сумках или банке."
L["Impossible to switch to appropriate equipment set in combat. Will switch after combat ends."] = "Невозможно переключиться на подходящий комплект в бою. Переключение произойдет после окончания боя."
L["SLE_EM_LOCK_TITLE"] = "|cff9482c9S&L|r"
L["SLE_EM_LOCK_TOOLTIP"] = [[Эта кнопка позволит временно отключить автоматическую
смену экипировки при помощи менеджера экипировки.
В заблокированном состоянии (красный цвет) автоматическая смена отключена.]]
L["Block button"] = "Кнопка блокировки"
L["Create a button in character frame to allow temp blocking of auto set swap."] = "Создать в окне персонажа кнопку, позволяющую временно отключить автоматическую смену комплектов."
L["Ignore zone change"] = "Игнорировать смену зоны"
L["Swap sets only on specialization change ignoring location change when. Does not influence entering/leaving instances and bg/arena."] = "Изменять комплект только при смене специализации, игнорируя изменение локации. Не влиет на вход/выход из подземелий и полей боя/арен."
L["Equipment conditions"] = "Условия экипировки"
L["SLE_EM_SET_NOT_EXIST"] = "Комплекта |cff9482c9%s|r не существует!"
L["SLE_EM_TAG_INVALID"] = "Неверный тэг: %s"
L["SLE_EM_TAG_INVALID_TALENT_TIER"] = "Неверный параметр для тэга talent. Указан ряд |cff9482c9%s|r, должен быть от 1 до 7."
L["SLE_EM_TAG_INVALID_TALENT_COLUMN"] = "Неверный параметр для тэга talent. Указан столбец |cff9482c9%s|r, должен быть от 1 до 3."
L["SLE_EM_TAG_DOT_WARNING"] = "Обнаружен неверный разделитель. Необходимо использовать запятые, а не точки."
L["SLE_EM_CONDITIONS_DESC"] = [[Определяет условия, при которых будут надеваться указанные сеты.
Работает по принципу макросов и контроллируется набором тэгов, представленным ниже.]]
L["SLE_EM_TAGS_HELP"] = [[Следующие тэги и параметры могут использоваться для условий экипировки:
|cff3cbf27solo|r - когда вы не в группе;
|cff3cbf27party|r - если вы в любом типе группы. Может быть с заданным размером, например [party:4] - в группе из 4 человек;
|cff3cbf27raid|r - если вы состояите в рейде. Может быть с заданным размером, аналогино предыдущему;
|cff3cbf27spec|r - указаная специализация. Использование [spec:<номер>], где номер это прядок специализации на соответствующей вкладке;
|cff3cbf27talent|r - указаный талант. Использование [talent:<ряд>/<столбец>] ряд идет от 1 на 15 уровне до 7 на 100 уровне, столбец указывается для этого ряда от 1 до 3;
|cff3cbf27instance|r - в подземелье. Может быть определенного типа - [instance:<тип>]. Типы подземелий: party, raid и scenario. Если тип не задан, то быдет использоваться во всех подземельях;
|cff3cbf27pvp|r - для полей боя, арен и открытых пвп зон. Параметры: pvp, arena;
|cff3cbf27difficulty|r - Определяет сложность подземелья. Параметры: normal, heroic, lfr, challenge, mythic;
|cff3cbf27effectivelevel|r - effective level refers to your level when you are scaled, e.g. timewalking

Пример: [solo] Set1; [party:4, spec:3] Set2; [instance:raid, difficulty:heroic] Set3
]]

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
L["This will auto-roll if you are above the given level if: You cannot equip the item being rolled on, or the iLevel of your equipped item is higher than the item being rolled on or you have an heirloom equipped in that slot"] = "Автоматически разыгрывать добычу после установленного уровня, если: вы не можете надеть предмет, или надетый на вас предмет выше уровнем, или в этом слоте у вас фамильный предмет"
L["Level to start auto-rolling from"] = "Минимальный уровень розыгрыша"
L["Loot Announcer"] = "Оповещение о добыче"
-- L["AUTOANNOUNCE_DESC"] = "Когда включен, будет автоматически анонсить выпавший лут.\n\n|cffFF0000Note:|r Только для РЛа, Помощника и мастер лута."
L["Auto Announce"] = "Авто оповещение"
L["Manual Override"] = "Принудительно"
L["Sets the button for manual override."] = "Задает кнопку, при зажатии которой добыча будет анонсироватья."
L["No Override"] = "Нет принудительного"
L["Automatic Override"] = "Автоматически"
L["Sets the alpha of Loot Roll History frame."] = "Устанавливает прозрачность окна истории добычи"
L["Sets the minimum loot threshold to announce."] = "Минимальное качество предмета, для вывода в чате."
L["Select chat channel to announce loot to."] = "Канал чата, для вывода сообщений."
L["Loot Roll History"] = "История добычи"
L["LOOTH_DESC"] = "Опции, задающие поведение окна истории добычи."
L["Auto hide"] = "Автоматически скрывать"
L["Automatically hides Loot Roll History frame when leaving the instance."] = "Автоматически скрывать окно истории добычи Blizzard при выходе из подземелья."
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
	"Народные Гуляния",
	"Аляска",
	"Акихабара",
	"Звезда Смерти",
	"Храм НОД",
}
L["SLE_MEDIA_PVP"] = {
	"(Территория Орды)",
	"(Территория Альянса)",
	"(Спорная территори)",
	"(Территория пришельцев)",
	"(Курилка)",
	"(Зона отдыха)",
	"(Стоянка мамонтов)",
}
L["SLE_MEDIA_SUBZONES"] = {
	"Администрация",
	"Склад водки",
	"Пожарный выход",
	"Кабинет директора",
	"Пельменная",
	"Интернет кафе",
	"Балкон",
	"Регистратура",
}
L["SLE_MEDIA_PVPARENA"] = {
	"(PvP)",
	"Не курить!",
	"Самый низки наалог на доходы",
	"Свободная зона",
	"Идет самоуничтожение",
	"Все по 40 рублей!",
	"Ня!",
}
L["SLE_MEDIA"] = "Опции для изменения внешнего вида некоторых элементов интерфейса."
L["Zone Text"] = "Текст локации"
L["Subzone Text"] = "Название сублокации"
L["PvP Status Text"] = "PvP статус"
L["Misc Texts"] = "Прочие тексты"
L["Mail Text"] = "Текст письма"
L["Chat Editbox Text"] = "Текст поля ввода"
L["Gossip and Quest Frames Text"] = "Текст окон заданий и диалогов"
L["Banner Big Text"] = "Большой текст баннеров"
L["Objective Tracker Header Text"] = "Заголовки списка заданий"
L["Objective Tracker Text"] = "Текст списка заданий"

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
L["Skin dungeon icon."] = "Скинить иконку поиска группы."
L["Skin Mail"] = "Иконка почты"
L["Skin mail icon."] = "Скинить иконку письма."
L["Skin garrison"] = "Иконка гарнизона"
L["Skin garrison landing page button."] = "Скинить кнопку гарнизона"
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
L["Automatic Width"] = "Автоматическая ширина"
L["Change width based on the zone name length."] = "Изменять ширину в зависимости от длины текста."
L["Update Throttle"] = "Частота обновления"
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = "Частота обновления координат и текста локации. Проверка проводится чаще с более низким значением."
L["Hide In Class Hall"] = "Скрывать в оплоте"
L["Full Location"] = "Полный текст"
L["Color Type"] = "Тип окрашивания"
L["Custom Color"] = "Свой цвет"
L["Reaction"] = "Отношение"
L["Location"] = "Локация"
L["Coordinates"] = "Координаты"
L["Teleports"] = "Телепорты"
L["Portals"] = "Порталы"
L["Link Position"] = "Сообщать координаты"
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = "Разрешить отправку ваших координат в поле ввода чата при нажатии shift+ПКМ на названии зоны."
L["Relocation Menu"] = "Меню перемещений"
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = "ПКМ на панели локалии откроет меню с доступными вариантами перемещени (камни, порталы и т.д.)"
L["Custom Width"] = "Своя ширина"
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = "По умолчанию ширина меню будет равна ширине панели. Включение данной опции позволит установить свою ширину."
L["Justify Text"] = "Выравнивание тектса"
L["Hearthstone Location"] = "Привязка камня"
L["Show the name on location your Heathstone is bound to."] = "Показывать имя локации, к которой привязан камень возвращения."
L["Only Number"] = "Только цифры"
L["Horizontal Growth"] = "Горизонтаьный рост"
L["Vertical Growth"] = "Вертикальный рост"
L["Info for some items is not available yet. Please try again later"] = "Информация о некоторых предметах пока недоступна. Зайдите попозже."
L["Update canceled."] = "Обновление отменено."
L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."] = "Информация о предмете недоступна. Ждем-с. Меню откроется автоматически, когда вся информация будет доступна. Вызовите меню повторно во время обновления для отмены."
L["Update complete. Opening menu."] = "Обновление завершено. Открываю меню."
L["Show hearthstones"] = "Камни возвращения"
L["Show hearthstone type items in the list."] = [[Показывать предметы типа "Камень возвращения" в списке.]]
L["Show Toys"] = "Игрушки"
L["Show toys in the list. This option will affect all other display options as well."] = "Показывать игрушки в списке. Эта опция повлияет на другие опции отображения."
L["Show spells"] = "Заклинания"
L["Show relocation spells in the list."] = "Показывать перемещающие заклинания в списке."
L["Show engineer gadgets"] = "Инженерные гаджеты"
L["Show items used only by engineers when the profession is learned."] = "Отображать в списке инженерные гаджеты при наличии изученой профессии."
L["Ignore missing info"] = "Игнорировать отсутсвие информации"
L["SLE_LOCPANEL_IGNOREMISSINGINFO"] = [[Из-за особенностей работы клиента информация о некоторых предметах может оказаться недоступной на какой-то период времени.В большинстве своем это касается игрушек.
При вызове меню будет ожидать появления информации о всех предметах перед отображением. Это может занять ощутимое время, зависит от скорости ответа сервера.
Включив эту опцию, вы заставите меню игнорировать предметы с отсутствующей информацией, что может привести к их отсутствию в списке.]]
L["HS Toys Order"] = "Порядок игрушек-камней"

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
L["Display the number of party / raid members targeting the nameplate unit."] = "Показывать количество членов группы/рейда, выбравших в цель этот юнит."
L["Threat Text"] = "Текст угрозы"
L["Display threat level as text on targeted, boss or mouseover nameplate."] = "Отображает текст угрозы на индикаторе цели, босса или юнита под курсором."

--Professions
L["Deconstruct Mode"] = "Режим распыления"
L["Create a button in your bag frame to switch to deconstruction mode allowing you to easily disenchant/mill/prospect and pick locks."] = "Создает в сумках кнопку для переключения в режим распыления, позворяющий распылять/просеивать/перетирать, а также вскрывать замки."
L["Actionbar Proc"] = "Прок панелей команд"
L["Actionbar Autocast"] = "Эффект автопременения"
L["Show glow on bag button"] = "Отображать свечение на кнопке"
L["Show glow on the deconstruction button in bag when deconstruction mode is enabled.\nApplies on next mode toggle."] = "Подсвечивать кнопку режима распыления, когда режим активен\nПрименяется после следующего переключения режима."
L["Scroll"] = "Свиток"
L["Missing scroll item for spellID %d. Please report this at the Shadow&Light Ticket Tracker."] = true
L["Sets style of glow around item available for deconstruction while in deconstruct mode. Autocast is less intense but also less noticeable."] = "Устанавливает стил свечения вокруг предмета, пригодного для распыления, когда режим активен. Атопременение менее яркое, но также менее заметное."
L["Enchant Scroll Button"] = "Кнопка зачарования свитка"
L["Create a button for applying selected enchant on the scroll."] = "Создать кнопку для применнеия чар к свитку."
L["Following options are global and will be applied to all characters on account."] = "Следующие опции глобальны и применяются ко всем персонажам учетной записи."
L["Deconstruction ignore"] = "Игнорировать при распылении"
L["Items listed here will be ignored in deconstruction mode. Add names or item links, entries must be separated by comma."] = "Указаные здесь предметы будут игнорироваться в режиме распыления. Добавляйте названия предметов или ссылки, разделяя их запятыми."
L["Ignore tabards"] = "Игнорировать накидки"
L["Deconstruction mode will ignore tabards."] = "Режим распыления будет игнорировать накидки."
L["Ignore Pandaria BoA"] = "Игнорировать БоА предметы Пандарии"
L["Deconstruction mode will ignore BoA weapons from Pandaria."] = "Режим распыления будет игнорировать привязанные к учетной записи оружия из Пандарии."
L["Ignore Cooking"] = "Игнорирвоать готовку"
L["Deconstruction mode will ignore cooking specific items."] = "Режим распыления будет игнорировать предметы для кулинарии."
L["Ignore Fishing"] = "Игнорировать рыболовство"
L["Deconstruction mode will ignore fishing specific items."] = "Режим распыления будет игнорировать предметы для рыбалки."
L["Unlock in trade"] = "Открывать в обмене"
L["Apply unlocking skills in trade window the same way as in deconstruction mode for bags."] = "Применять взлом замков в окне обмена таким же образом, как и в сумках."
L["Easy Cast"] = "Быстрая рыбалка"
L["Allow to fish with double right-click."] = "Позволяет начать ловить рыбу двойным ПКМ."
L["From Mount"] = "С маунта"
L["Start fishing even if you are mounted."] = "Забрасывать удочку даже, если вы на средстве передвижения."
L["Apply Lures"] = "Наживка"
L["Automatically apply lures."] = "Автоматически насаживать наживку."
L["Ignore Poles"] = "Без удочки"
L["If enabled will start fishing even if you don't have fishing pole equipped. Will not work if you have fish key set to \"None\"."] = "При включении будет начинать рыбачить даже без надетой удочки. Не будет работать, если модификатор рыбалки выставлен на \"Нет\"."
L["Fish Key"] = "Модификатор рыбалки"
L["Hold this button while clicking to allow fishing action."] = "Удерживайте эту кнопку для быстрой рыбалки."
L["SLE_Prof_Relure_Error"] = "Не могу использовать приманку из-за заданного интервала задержки. Осталось времени: %.1f секунд."
L["Re-lure Threshold"] = "Задержка наживки"
L["Time after the previous attemp to apply a lure before the next attempt will occure."] = "Время после последней попытки использования наживки, через котороне наживка вновь будет автоматически применяться."

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
L["Play sound when killing blows popup is shown."] = "Проигрывать звук при нанесении смертельного удара."

--Quests
L["Rested"] = "Отдых"
L["Auto Reward"] = "Автоматическая награда"
L["Automatically selects a reward with highest selling price when quest is completed. Does not really finish the quest."] = "Автоматическивыбирать награду с наивысшей стоимостью при сдаче квеста."
L["Quest Log Toggle"] = "Переключение списка заданий"

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
L["No tooltips"] = "Без подсказок"

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
L["ElvUI Objective Tracker"] = "Список задач ElvUI"
L["ElvUI Skins"] = "Скины ElvUI"
L["As List"] = "Списком"
L["List Style Fonts"] = "Шрифты стиля списка"
L["Item Name Font"] = "Шрифт названия"
L["Item Name Size"] = "Размер названия"
L["Item Name Outline"] = "Граница названия"
L["Item Info Font"] = "Шрифт информации"
L["Item Info Size"] = "Размер информации"
L["Item Info Outline"] = "Граница информации"
L["Remove Parchment"] = "Удалить пергамент"
L["Stage Background"] = "Фон стадии"
L["Hide the talking head frame at the top center of the screen."] = "Скрыть говорящую голову"

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
L["S&L: Farm Seed Bars"] = "S&L: Семена"
L["S&L: Farm Tool Bar"] = "S&L: Инструменты фермы"
L["S&L: Farm Portal Bar"] = "S&L: Порталы фермы "
--Garrison
L["Garrison Tools Bar"] = "Панель гарнизона"
L["Auto Work Orders"] = "Автоматические заказы"
L["Automatically queue maximum number of work orders available when visiting respected NPC."] = "Автоматически делать максимально возможное количество заказов при открытии соответствующего диалога."
L["Auto Work Orders for Warmill"] = "Авто. заказы на фабрике"
L["Automatically queue maximum number of work orders available for Warmill/Dwarven Bunker."] = "Автоматически делать максимальное количество заказов для военной фабрики/дворфийского бункера."
L["Auto Work Orders for Trading Post"] = "Авто. заказы в торговой лавке"
L["Automatically queue maximum number of work orders available for Trading Post."] = "Автоматически делать максимальное количество заказов для торговой лавки."
L["Auto Work Orders for Shipyard"] = "Авто. заказы на верфи"
L["Automatically queue maximum number of work orders available for Shipyard."] = "Автоматически делать максимальное количество заказов для верфи."
L["Toolbar"] = "Инструменты"
L["S&L: Garrison Tools Bar"] = "S&L: Инструменты гарнизона"
--Class Hall
L["Class Hall"] = "Оплот класса"
L["Auto Work Orders for equipment"] = "Авто. заказы на экипировку"

--Tooltip
L["Always Compare Items"] = "Всегда сравнивать предметы"
L["Faction Icon"] = "Иконка фракции"
L["Show faction icon to the left of player's name on tooltip."] = "Отображать иконку фракции около имени игроков в подсказках"
L["RAID_TOS"] = "ГС"
L["RAID_NH"] = "ЦН"
L["RAID_TOV"] = "ИД"
L["RAID_EN"] = "ИК"
L["RAID_ANTO"] = "АПТ"
L["RAID_DAZALOR"] = "БзДА"
L["RAID_STORMCRUS"] = "ГШ"
L["RAID_ETERNALPALACE"] = "ВД"
L["Raid Progression"] = "Рейдовый прогресс"
L["Show raid experience of character in tooltip (requires holding shift)."] = "Отображает рейдовый опыт данного персонажа (требуется зажатый shift)"
L["Name Style"] = "Стиль названия"
L["Difficulty Style"] = "Стиль сложности"
L["Short"] = "Короткий"

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
L["Minimum Roll Value"] = "Минимальное значение броска"
L["The lower limit for custom roll button."] = "Нижняя граница броска при использовании собственных установок."
L["Maximum Roll Value"] = "Масимальное значение броска"
L["The higher limit for custom roll button."] = "Верхняя граница броска при использовании собственных установок."
L["Quick Action"] = "Быстрое действие"
L["Use quick access (on right click) for this button."] = "Функция для быстрого действия. Вызывается нажатием ПКМ на кнопке открытия списка."
L["Function"] = "Функция"
L["Function called by quick access."] = "Функция для вызова быстрым действием"
L["UI Buttons Strata"] = "Слой меню"

--Unitframes
L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."] = "Опции для дополнительной настройки рамок юнитов. Пожалуйста, не изменяйте эти настройки в то же время, кода включен тестовый режим рамок боссов и арены в ElvUI. Это сделает их невидимыми до повторного включения."
L["Player Frame Indicators"] = "Индикаторы игрока"
L["Combat Icon"] = "Иконка боя"
L["LFG Icons"] = "Иконки ЛФГ"
L["Choose what icon set will unitframes and chat use."] = "Набор иконок для использования на рамках юнитов и в чате."
L["Offline Indicator"] = "Не в сети"
L["Dead Indicator"] = "Мертв"
L["Shows an icon on party or raid unitframes for people that are offline."] = "Показывает иконку на рамках членов группы или рейда, которые находятся не в сети"
L["Statusbars"] = "Полосы состояния"
L["Power Texture"] = "Текстура ресурса"
L["Castbar Texture"] = "Текстура полосы заклинаний"
L["Red Icon"] = "Красная иконка"
L["Aura Bars Texture"] = "Текстура полос аур"
L["Makes frame portrait visible regardless of health level when overlay portrait is set."] = "Делает портрет на этой рамке видимым не зависимо от кол-ва оставшегося здоровья при наложении."
L["Classbar Texture"] = "Текстура классовой полосы"
L["Resize Health Prediction"] = "Подогнать входящее исцеление"
L["Slightly changes size of health prediction bars."] = "Немного изменяет размер полос входящего исцеления."

--Unitframes, tags
L["SLE_Tag_sl-pvptimer"] = "Альтернативная версия \"pvptimer\". Не отображает надпись \"PvP\"."
L["SLE_Tag_sl-pvplevel"] = "Показывает уровень чести юнита."
L["SLE_Tag_absorb-sl-short"] = "Альтернативная версия \"absorbs\". Показывает 0, когда нет эффектов поглощения. Короткое значение"
L["SLE_Tag_absorb-sl-full"] = "Альтернативная версия \"absorbs\". Показывает 0, когда нет эффектов поглощения. Полное значение"
-- L["SLE_Tag_health-current-rehok"] = true
L["SLE_Tag_range-sl"] = "Показывает примерное расстояние до юнита.."

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
L["About/Help"] = "Информация"
L["About"] = "Об аддоне"
L["SLE_DESC"] = [=[|cff9482c9Shadow & Light|r это расширение для ElvUI. Оно добавляет:
- много новых функций
- больше вариантов настройки для существующих опций

|cff3cbf27Внимание:|r Оно совместимо с большинством существующих плагинов для ElvUI. Однако некоторые функции могут оказаться недоступными для избежания конфликтов.]=]
L["Links"] = "Ссылки"
L["LINK_DESC"] = [[Ниже представлены ссылки на страницы Shadow & Light на нескольких сайтах.]]
L["Donate"] = "Пожертвовать"

--FAQ--
L["FAQ_DESC"] = "Эта секция содержит некоторые вопросы о ElvUI и Shadow & Light."
L["FAQ_Elv_1"] = [[|cff30ee30В: Где я могу получить поддержку по ElvUI?|r
|cff9482c9О:|r Лучше всего на официальном форуме - https://www.tukui.org/forum/
Для сообщения об ошибках лучше использовать тикет треккер - https://git.tukui.org/elvui/elvui/issues]]
L["FAQ_Elv_2"] = [[|cff30ee30В: Нужно ли мне для этого знать английский?|r
|cff9482c9О:|r Английский является официальным языком на форумах tukui.org, так что большинство сообщений написано на нем.
Но это не значит, что это единственный дозволенный язык. Вы можете найти сообщения на испанском, французском, немецком, русском, итальянском и других языках.
Пока вы придерживаетесь простых правил приличия, никто не будет против сообщений на вашем родном языке. Например, вы можете указать язык сообщения в названии темы.
Имейте ввиду, что вы все равно можете получить ответ на английском, т.к. отвечающи может не знать вашего языка.]]
L["FAQ_Elv_3"] = [[|cff30ee30В: Что нужно указать при сообщении об ошибке?|r
|cff9482c9О:|r Прежде всего убедитесь, что ошибка вызвана самим ElvUI.
Для этого отключите все аддоны, кроме ElvUI и ElvUI_OptionsUI.
You can do this by typing "/luaerror on" (without quotes).
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
Например: |TInterface\AddOns\ElvUI_SLE\media\textures\SLE_Chat_Logo:12:28|t это иконка для разработчиков, а |TInterface\AddOns\ElvUI_SLE\media\textures\SLE_Chat_Logo_Alt:16:16|t это иконка, которую иногда использует Repooc. |TInterface\AddOns\ElvUI_SLE\media\textures\Chat_Test:16:16|t для людей, котрые в свое время помогли вычислить хитрый баг.]]
L["FAQ_sle_5"] = [[|cff30ee30В: Как я могу связаться с авторами?|r
|cff9482c9О:|r По очевидным причинам мы не раздаем свои контакты всем желающим. Так что лучшим методом являются форумы tukui.org.]]

--Credits--
L["ELVUI_SLE_CREDITS"] = "Мы хотели бы отметить и поблагодарить следующих людей за помощь в создании этого аддона."
L["Submodules and Coding:"] = "Модули и код:"
L["Other Support:"] = "Прочее:"
L["ELVUI_SLE_DONORS_TITLE"] = "Спасибо этим офигенным людям за пожертвования в пользу нашей работы:"
L["ELVUI_SLE_MISC"] = [=[BuG - за постоянные и ржачные методы сломать все и вся
TheSamaKutra
RZ_Digital - за наше новое офигенное лого
Сообщество Tukui
]=]
L["ELVUI_SLE_PATREON_TITLE"] = "Огромное спасибо нашим спонсорам, которые поддерживают создание этого аддона:"
L["Patrons"] = "Спонсоры"
L["Donors"] = "Пожертвования"

L["SLE_BENIK_AF"] = [[В связи с большим количеством дел ИРЛ, команда |cff9482c9Shadow & Light|r ушла в отпуск.

Но пока нас нет, |cfffe7b2cBenik|r был настолько добр, что согласился заняться поддержкой |cff9482c9S&L|r!
Если вы столкнетесь с какими-либо ошибками или проблемами в |cff9482c9S&L|r, оставьте сообщение на форуме tukui.org в секции BenikUI.
И помните: если что-то сломалось, то виноват в этом Benik! Используйте хэштэг |cfffe7b2c#IBlameBenik|r, когда постите об ошибках!]]
L["SLE_ERRORS_AF"] = {
	"Очевидно Merathilis перепил и ухитрпился заспамить мунфаером нашу силовую линию! Вы должны немедленно ее починить!",
	"Мы рады сообщить, что наша кампания #IBlameBenik продвигается успешно! И не забудьте тоже обвинить Benik'а во всем!",
	"АХТУНГ! Дарт спер ядерную нопку и требует выкуп в размере 500 миллионов золотых и нескольких гоничных-дренеек. Спрячьтесь в ближайшем бомбоубежище и приготовьтесь играть в Fallout в реале!",
	"С вашим интерфейсом что-то не так. Ожидайте, мы пытаемся все починить! Мы не несем ответственности, если все станет еще хуже.",
	"Священный Орден Имперской Инквизиции обнаружил еретические материалы на вашем ПК! Ваш дом и вся планета будет подвергнута Экстерминатусу во имя Императора!",
	"МЕДВЕДИ! Какого черта в твоем интерфейсе делают медведи?!",
	"Benik немного поправил локализацию. Надеемся, что вы умеете говорить по турецки!",
	"Камень льда растаял! Наши сервера затопило. Приносим извинения за неудобства.",
	"ВЫ НЕ ГОТОВЫ!!!",
	"ElvUI обнаружил обычное количество фиговых ответов от сервера Blizzard и будет закрыт. Свяжитесь с ближайшим гоблином инженером для получения дополнительной информации.",
	"Не трогай свечу! Или мы пожалуемся Benik'у!",
}
