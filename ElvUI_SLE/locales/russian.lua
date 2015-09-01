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
L["Pet Battle Status"] = "Статус битвы питомцев"
L["Pet Battle AB"] = "Панель битв питомцев"
L["Ghost Frame"] = "Фрейм призрака"
L['Raid Marker Bar'] = "Полоса меток"

--Import--
L["Import Options"] = "Импорт Настроек"
L["Author Specific Imports"] = "Импорт специфических настроек авторов"
L['Select Author'] = "Выберите автора"
L["Please be aware that importing any of the filters will require a reload of the UI for the settings to take effect.\nOnce you click a filter button, your screen will reload automatically."] = "Пожалуйста, учтите, что импортирование любого фильтра потребует перезагрузки интерфейса для вступления в силу.\nКак только вы нажмете на кнопку, Ваш интерфейс перезагрузится автоматически."
L["Import"] = "Импорт"
L["This will import non class specific filters from this author."] = "Это импортирует не привязанные к классу фильтры этого автора."
L["This will import All Class specific filters from this author."] = "Это импортирует все классовые фильтры этого автора."
L['Import All'] = "Импорт всего"

--General--
L["SLE_LOGIN_MSG"] = [=[Вы используете редакцию ElvUI под названием |cff1784d1"Shadow & Light"|r версия |cff1784d1%s%s|r.
Если вы хотите использовать оригинальный ElvUI, просто отключите плагин этой редакции в вашем менеджере аддонов.
Приятной игры.]=]
L["SLE_DESC"] = [=[Это редакция ElvUI добавляет некоторые новые функции к оригинальному аддону и изменяет функционал некоторых старых опций.
Эта редакция ни в коем виде не изменяет оригинальные файлы, так что вы можете спокойно отключить ее в вашем менеджере аддонов по желанию.]=]
L["Plugin for |cff1784d1ElvUI|r by\nDarth Predator and Repooc."] = "Плагин для |cff1784d1ElvUI|r  от\nDarth Predator'а и Repooc'а"
L['MSG_OUTDATED'] = "Ваша версия ElvUI старее, чем рекомендованная для использования с Shadow & Light. У Вас версия |cff1784d1%.2f|r (рекомендованная |cff1784d1%.2f|r). Пожалуйста, обновите ElvUI."
L["Reset these options to defaults"] = "Восстановить умолчания для этих опций"
L["Reset All"] = "Сбросить все"
L["Resets all movers & options for S&L."] = "Сбросить все фиксаторы и опции S&L"
L['Oh lord, you have got ElvUI Enhanced and Shadow & Light both enabled at the same time. Select an addon to disable.'] = "Ешкин конь, одновременно включены ElvUI Enhanced и Shadow & Light. Выберите что отключить."
L['You have got Loot Confirm and Shadow & Light both enabled at the same time. Select an addon to disable.'] = "Одновременно активны Loot Confirm и Shadow & Light. Выберите что из них отключить."
L["Enabling mouse over will make ElvUI's raid utility show on mouse over instead of always showing."] = "Отображать кнопку управления рейдом только при наведении мыши."
L['Adjust the position of the threat bar to any of the datatext panels in ElvUI & S&L.'] = "Позволяет поместить полосу угрозы на любой панели инфо-текстов."
L["This option have been moved by Shadow & Light. Click to access it's new place."] = "Shadow & Light переместил эту опцию. Кликните для перехода к ее новому расположению."
L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."] = "Shadow & Light отключил эту опцию. Для доступа к ней нужно отключить соответствующую опцию S&L. Кликните для перехода к ее расположению."
L["This will clear your chat history and reload your UI.\nContinue?"] = "История чата будет очищена, а интерфейс перезагружен.\nПродолжить?"
L["This will clear your editbox history and reload your UI.\nContinue?"] = "История введенных сообщений будет очищена, а интерфейс перезагружен.\nПродолжить?"

--Chat--
L["Reset Chat History"] = "Сбросить историю чата"
L["Clears your chat history and will reload your UI."] = "Очищает историю сохраненных сообщений в чате и перезагружет интерфейс."
L["Reset Editbox History"] = "Сбросить введенное"
L["Clears the editbox history and will reload your UI."] = "Очищает историю введенных сообщений и перезагружает интерфейс."
L["Chat Editbox History"] = "История ввода"
L["The amount of messages to save in the editbox history.\n\n|cffFF0000Note:|r To disable, set to 0."] = "Количество сообщений, введенных вами, которое будет сохранено между сеансами.\n\n|cffFF0000Напоминание:|r Для отключения, установите на 0."
L["Guild Master Icon"] = "Иконка Главы гильдии"
L["Displays an icon near your Guild Master in chat.\n\n|cffFF0000Note:|r Some messages in chat history may disappear on login."] = "Отображает иконку рядом с сообщениями главы вашей гильдии в чате.\n\n|cffFF0000Предупреждение:|r Некоторые сообщения в истории чата в истории чата могут исчезать при входе в игру."
L["Filter DPS meters' Spam"] = "Фильтровать отчеты о УВС"
L["Replaces long reports from damage meters with a clickeble hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter te report of other things"] = "Заменяет длиные отчеты от аддонов для измерения УВС на гиперссылку, сокращая уровень спама в чате.\nКорректно работает с отчетами урона и исцеления. Может не отфильтровать другие специфические отчеты."
L["Reported by %s"] = "Отчет от %s"
L["Texture Alpha"] = "Прозрачность текстур"
L["Allows separate alpha setting for textures in chat"] = "Включает отдельную настройку прозрачности для текстур в чате"

--Raid utility--
L['Raid Utility'] = "Управление рейдом"

--Media--
L["SLE_MEDIA"] = "Опции для изменения внешнего вида некоторых элементов интерфейса."
L["Zone Text"] = "Текст локации"
L["Test"] = "Тест"
L["Subzone Text"] = "Название сублокации"
L["PvP Status Text"] = "PvP статус"
L["Misc Texts"] = "Прочие тексты"
L["Mail Text"] = "Текст письма"
L["Chat Editbox Text"] = "Текст поля ввода"
L["Gossip and Quest Frames Text"] = "Текст окон заданий и диалогов"
L["Screensaver"] = "Заставка"
L["Title font"] = "Заголовок"
L["Subitle font"] = "Подзаголовок"
L["Date font"] = "Дата"
L["Player info font"] = "Информация игрока"
L["Tips font"] = "Советы"
L["Graphics"] = "Графика"
L["Crest Size"] = "Размер гербов"
L["X-Pack Logo Size"] = "Логотип дополнения"
L["Model Animation"] = "Анимация модели"
L["Model Position"] = "Позиция модели"
L["SLE_TIPS"] = {
	"Не стой в огне!",
	"Спать вредно! Пока ты спишь, враг качается!",
	"Сделал дейлик - спас китайца!",
	"Elv: I just utilized my degree in afro engineering and fixed it",
	"Варлоки пришли к нам из сказочного мира, где их любят и уважают. Поэтому они ненавидят наш мир лютой ненавистью.",
	[[|TInterface\AddOns\ElvUI_SLE\media\textures\WH:24:24|t Сожги еретика. Убей мутанта. Преследуй нечисть.]],
	"Кровь для Бога Крови!",
	"Кофе для Бога Кофе!",
	"Друид живет в единении с природой... Поэтому он не курит всякий фуфел, как другие таурены!",
	"На форумах tukui.org поддержка по ElvUI оказывается в том числе и на русском языке.",
	"Любимый комментарий Дарта к изменениям в коде - \"Ууууупс\"",
	"Нужно... Больше... Некодевочек... Стоп. Что?!",
}
L['You Are Away From Keyboard'] = "Вы отошли от компьютера"
L["Take care of yourself, Master!"] = "Не задерживайтесь, Хозяин!"

--Install--
L["|cff1784d1Shadow & Light|r Installation"] = "Установка |cff1784d1Shadow & Light|r"
L["Welcome to |cff1784d1Shadow & Light|r version %s!"] = "Добро пожаловать в |cff1784d1Shadow & Light|r версии %s!"
L["This will take you through a quick install process to setup some Shadow & Light features.\nIf you choose to not setup any options through this config, click Skip Process button to finish the installation."] = "Этот установщик позволит ван выбрать поведение некоторых функций Shadow & Light.\nЕсли вы не хотите настраивать эти опции, то нажмите кнопку \"Пропустить установку\" для ее завершения немедленно."
L["This will determine if you want to use ElvUI's default layout for chat datatext panels or let Shadow & Light handle them."] = "Здесь вы можете указать использовать ли стандартное положение информационных панелей чата ElvUI или позволить Shadow & Light его изменить."
L["If you select S&L Panels, the datatext panels will be attached below the left and right chat frames instead of being inside the chat frame."] = "Если вы выберете стиль S&L, то информационные панели будут прикреплены к нижней границе панелей чата вместо нахождения внутри них."
L["SLE_ARMORY_INSTALL"] = "Включить режим оружейной S&L\n(Детализированные окна персонажа и осмотра)\n|cffFF0000Предепреждаем:|r Эта опция на данный момент находится в состоянии беты."
L["This will enable S&L Armory mode components that will show more detailed information at a quick glance on the toons you inspect or your own character."] = "Активирует компоненты оружейной Shadow & Light, которые покажут вам более детальную информацию о вашем персонаже или игроке, которого вы осматриваете."
L["Shadow & Light Layouts"] = "Шаблоны Shadow & Light"
L["You can now choose if you want to use one of the authors' set of options. This will change the positioning of some elements as well of other various options."] = "Вы можете использовать набор настроек, используемый одним из представленных людей. Будут изменены положения элементов и другие настройки."
L["SLE_Install_Text2"] = [=[Этот шаг опционален и должен использоваться только в случае, если Вы хотите использовать одну из наших конфигураций. В зависимости от роли, выбранной в ElvUI (шаг "Расположение"), результат может отличаться.

Была выбрана роль |cff1784d1"%s"|r.

|cffFF0000Внимание:|r Пожалуйста помните, что авторы могут не использовать тему/роль, которую вы выбрали, и потому результат не всегда будет хорошим. Также переключение между шаблонами здесь может привести к неоднозначным результатам.
]=]
L["Darth's Config"] = "Опции Дарта"
L["Darth's Default Set"] = "Установлены настройки Дарта"	 
L["Repooc's Config"] = "Опции Repooc'а"	 
L["Repooc's Default Set"] = "Установлены настройки Repooc'а"	 
L["Affinitii's Config"] = "Опции  Affinitii"
L["Affinitii's Default Set"] = "Установлены настройки Affinitii"

--Auras--
L["Hide Buff Timer"] = "Спрятать таймеры баффов"
L["This hides the time remaining for your buffs."] = "Скрывает текст оставшегося времени действия около баффов"
L["Hide Debuff Timer"] = "Спрятать таймеры дебаффов"
L["This hides the time remaining for your debuffs."] = "Скрывает текст оставшегося времени действия около дебаффов"
L["Mark Your Consolidated Buffs"] = "Отмечать ваши объединенные эффекты"
L["Create a mark bar on a consolidated buffs bar's icons for buffs your class can provide."] = "Создавать метку в полосе объединенных эффектов на иконках, бафф которых может предоставить ваш класс."
L["You are in combat, Consolidated Buffs Bars will be updated upon leaving it"] = "Вы в бою. Полоса объединенных эффектов будет обновлена по его окончанию."

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
L["Armory Mode"] = "Оружейная"
L['Enchant String'] = "Текст чар"
L['String Replacement'] = "Замена текста"
L['Original String'] = "Оригинальный текст"
L['New String'] = "Новый текст"
L['List of Strings'] = "Список замен"
L['Create Replacement'] = "Создать замену"
L['Character Armory'] = "Персонаж"
L['Inspect Armory'] = "Осмотр"
L['Show Missing Enchants or Gems'] = "Показывать отсутствие чар и камней"
L['Show Warning Icon'] = "Показывать иконку предупреждения"
L['Select Image'] = "Выберите картинку"
L["Custom"] = "Своя"
L['Custom Image Path'] = "Путь к своей картинке"
L['Gradient Texture Color'] = "Цвет градиентной текстуры"
L['Upgrade Level'] = "Уровень улучшения"
L["Only Damaged"] = "На поврежденных"
L["Warning Size"] = "Размер предупреждений"
L['Warning Only As Icons'] = "Только иконки предупреждений"
L["Gem Sockets"] = "Слоты для камней"
L["Socket Size"] = "Размер слотов"

--Character Frame--
L["Not Enchanted"] = "Нет чар"
L['This is not profession only.'] = "Не усиление от профессии"
L['Empty Socket'] = "Пустое гнездо"
L['Average'] = "Средний ур. предметов" --Not sure if still used. Saw it in code, never saw in game

--Marks--
L['Options for panels providing fast access to raid markers and flares.'] = "Опции панелей, предоставляющих быстрый доступ к рейдовым меткам и маркерам на земле."
L["Raid Markers"] = "Рейдовые Метки"
L["Show/Hide raid marks."] = "Показать/скрыть фрейм рейдовых меток."
L["Change the direction of buttons growth from the skull marker"] = "Изменяет направление роста кнопок от метки \"череп\"."
L["Reverse"] = "Обратный порядок"
L['Modifier Key'] = "Модификатор"
L['Set the modifier key for placing world markers.'] = "Модификатор для установки меток на земле."

--Bags--
L["New Item Flash"] = "Мерцание новых предметов"
L["Use the Shadow & Light New Item Flash instead of the default ElvUI flash"] = "Использовать полное мерцание Shadow & Light вместо обычного из ElvUI."


--Datatexts--
L["Panels & Dashboard"] = "Панели и Информация"
L["LFR Lockout"] = "Состояние ЛФР"
L["Loot History"] = "История добычи"
L["Raid Saves"] = "Сохранения рейдов"
L["Show/Hide LFR lockout info in time datatext's tooltip."] = "Отображать/скрывать информацию о сохранении ЛФР"
L["Bosses killed: "] = "Боссов убито: "
L["You didn't select any instance to track."] = "Вы не выбрали подземелья для отслеживания"
L["This LFR isn't available for your level/gear."] = "Это подземелье не доступно для Вашего уровня или экипировки."
L["This raid isn't available for your level/gear."] = "Этот рейд не доступен для Вашего уровня или экипировки."
L["SLE_AUTHOR_INFO"] = "\"Shadow & Light\" от Darth Predator'а и Repooc'а"
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
-- L["Left Chat"] = "Левый чат"
-- L["Right Chat"] = "Правый чат"
L["Additional Datatext Panels"] = "Дополнительные панели инфо-текстов"
L["DP_DESC"] = [=[Дополнительные панели под информационные тексты.
Всего здесь 8 дополнительных панелей и 20 дополнительных слотов под инфо-тексты, а также панель состояния с 4мя индикаторами.
Панели на чатах отключить нельзя.]=]
L["Dashboard"] = "Панель состояния"
L["Show/Hide dashboard."] = "Показать/скрыть панель состояния."
L["Dashboard Panels Width"] = "Ширина панелей"
L["Sets size of dashboard panels."] = "Устанавливает размер полос панели состояния."
L["Override Chat DT Panels"] = "Изменить инфо-панели чата"
L["This will have S&L handle chat datatext panels and place them below the left & right chat panels.\n\n|cffFF0000Note:|r When you first enabled, you may need to move the chat panels up to see your datatext panels."] = "S&L перенесет панели информации чатов. Информационные панели будут перемещены под панели чата. \n\n|cffFF0000Внимание:|r При первой активации может потребоваться вручную переместить панели чата, чтобы увидеть инфо-панели."
L["Show/Hide this panel."] = "Показать/скрыть эту панель."
L["Sets size of this panel"] = "Установить ширину панели"
L['Hide panel background'] = "Скрыть фон панели"
L["Don't show this panel, only datatexts assinged to it"] = "Не показывать саму панель, а только назначенные на нее инфо-тексты"
L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information."] = "Некоторые инфо-тексты Shadow & Light имеют настройки, которые могут изменить отображаемую информацию."
L["S&L Friends"] = true
L["Show total friends in the datatext."] = "Показывать общее кол-во друзей на инфо-тексте."
L["Show total guild members in the datatext."] = "Показывать общее кол-во членов гильдии на инфо-тексте."
L["These options are for modifing the Shadow & Light Friends datatext."] = "Опции для настройки инфо-текста S&L Friends."
L["S&L Guild"] = true
L["Show Totals"] = "Показывать общее"
L["Expand RealID"] = "Развернуть RealID"
L["Display realid with two lines to view broadcasts."] = "Отображать информацию друзей по RealID в две строки для отображения рассылки."
L["Hide Hints"] = "Скрыть управление"
L["Hide the hints in the tooltip."] = "Скрывать инструкцию по управлению в подсказке инфо-текста"
L["Autohide Delay:"] = "Задержка скрывания"
L["Adjust the tooltip autohide delay when mouse is no longer hovering of the datatext."] = "Устанавливает время исчезновения подсказки, после ухода курсора с инфо-текста."
L["S&L Mail"] = true
L["These options are for modifing the Shadow & Light Mail datatext."] = "Опции для настройки инфо-текста S&L Mail"
L["Minimap icon"] = "Иконка на миникарте"
L["If enabled will show new mail icon on minimap."] = "Если включено, то иконка почты на миникарте будет отображаться."
L["S&L Datatexts"] = "Инфо-тексты S&L"
L["Datatext Options"] = "Опции инфо-текстов"
L["These options are for modifing the Shadow & Light Guild datatext."] = "Опции для настройки инфо-текста S&L Guild."
L["Hide MOTD"] = "Скрыть сообщение дня"
L["Hide the guild's Message of the Day in the tooltip."] = "Скрывает сообщение дня гильдии на подсказке."
L["Hide Guild Name"] = "Скрыть название гильдии"
L["Hide the guild's name in the tooltip."] = "Скрывает название гильдии на подсказке."
L["Hide In Combat"] = "Скрывать в бою"
L["Will not show the tooltip while in combat."] = "Не отображать подсказки инфо-текста в бою."
L["World Loot"] = "Мировая добыча"
L["Show/Hide the status of Key to the Palace of Lei Shen and Trove of the Thunder King."] = "Показать/скрыть статус Ключа от дворца Лэй Шэня и Сокровищ Властелина Грома."
L["Time Played"] = "Времени в игре"
L["Account Time Played"] = "Время в игре на аккаунте"
L["D"] = "Дн"
L["Previous Level:"] = "Предыдущий уровень:"
L['Current:'] = "Текущее:"
L['Weekly:'] = "За неделю:"
L['ElvUI Improved Currency Options'] = "Опции расширенного инфо-текста валюты"
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
L["Gradient"] = "Градиент"
L["If enabled will color durability text based on it's value."] = "Если включено, будет окрашивать текст прочности в зависимости от значения."
L["Durability Threshold"] = "Порог прочности"
L["Datatext will flash if durability shown will be equal or lower that this value. Set to -1 to disable"] = "Инфотекст начнет мигать, если показанная прочность будет меньшей либо равной заданному числу. Поставьте на -1 для отключения."
L["Any changes made will take effect only after:\n - Opening vendor\n - Item durability changes\n - Experiencing loading screen."] = "Изменения данных параметров вступят в силу только после одного из следующих действий:\n - Взаимодействия с торговцем\n - Изменения прочности предметов\n - Окончания экрана загрузки."

--Equip Manager--
L['Equipment Manager'] = "Менеджер экипировки"
L["EM_DESC"] = "Этот модуль предоставляет различные опции для автоматической смены комплектов экипировки при переключении набора талантов или попадании в определенную локацию."	 
L['Spam Throttling'] = "Подавление спама"
L["Removes the spam from chat stating what talents were learned or unlearned during spec change."] = "Удаляет спам об изученных/забытых заклинаниях при смене талантов."
L['Equipment Set Overlay'] = "Название комплекта"
L['Show the associated equipment sets for the items in your bags (or bank).'] = "Отображает название комплекта экипировки, к которому привязан предмет, на его иконке в сумках или банке."
L["Here you can choose what equipment sets to use in different situations."] = "Здесь Вы можете выбрать какие комплекты экипировки использовать в различных случаях."
L["Equip this set when switching to primary talents."] = "Надеть этот набор при переключении на основной набор талантов."
L["Equip this set when switching to secondary talents."] = "Надеть этот набор при переключении на дополнительный набор талантов."
L["Equip this set after entering dungeons or raids."] = "Надеть этот набор при попадании в подземелье или рейд."
L["Equip this set after entering battlegrounds or arens."] = "Надеть этот набор при попадании на поля боя или арены."

--XP-Rep Bar--
L["Xp-Rep Text"] = "Текст Опыта/Репутации"
L["Full value on Exp Bar"] = "Полное значение опыта"
L["Changes the way text is shown on exp bar."] = "Изменяет отображение значений опыта на полосе."
L["Full value on Rep Bar"] = "Полное значение репутации"
L["Changes the way text is shown on rep bar."] = "Изменяет отображение значений репутации на полосе."
L["Auto Track Reputation"] = "Автоматически отслеживать репутацию"
L["Automatically sets reputation tracking to the most recent reputation change."] = "Автоматически изменять отслеживаемую репутацию на последнюю фракцию, чье отношение к Вам изменилось."

--Farm--
L['Farm'] = "Ферма"
L["Farm Options"] = "Опции фермы"
L["FARM_DESC"] = [[Дополнительные панели с семенами, инструментами и порталами для Фермы Солнечной Песни.
Они будут отображаться только если Вы находитесь на ферме или рынке Полугорья.]]
L['Only active buttons'] = "Только активные"
L['Only show the buttons for the seeds, portals, tools you have in your bags.'] = "Отображать только кнопки для тех семян/инструментов/порталов, которые есть у Вас в сумках."
L["Seed Bars"] = "Панели семян"
L["Auto Planting"] = "Автоматическая посадка"
L["Automatically plant seeds to the nearest tilled soil if one is not already selected."] = "Автоматически высаживать указанное растение на ближайшую возделанную землю, если не выбрана другая."
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
L["Garrison Tools Bar"] = "Панель гарнизона"
L["Tilled Soil"] = "Возделанная земля"
L['Right-click to drop the item.'] = "ПКМ для уничтожения предмета."
L["We are sorry, but you can't do this now. Try again after the end of this combat."] = "Извините, но Вы не можете этого сделать сейчас. Попробуйте снова после окончания текущего боя."

--Help--
L["LINK_DESC"] = [[Сылки ниже ведуть на страницы Shadow & Light на различных сайтах.]]
L['About/Help'] = "Помощь/Информация"
L['About'] = "Информация"
L['Links'] = "Ссылки"
L['GitLab Link / Report Errors'] = "Ссылка на GitLab / Сообщить об ошибке"

--Import Section
L["SLE_IMPORTS"] = "|cffFF0000Важно:|r Используйте импортирование фильтров осторожно, так как они удалят ваши собственные фильтры!\nИмпортирование классового фильтра перезапишет любые изменения, которые Вы в него вносили."

--Loot--
L["AUTOANNOUNCE_DESC"] = [[Этот модуль будет выводить список выпавшей добычи при открытии окна добычи.
Вывод осуществляется только если Вы лидер, помощник или ответственный за добычу или при зажатии клавиши принудительного вывода.]]
L["LOOTH_DESC"] = "Опции, задающие поведение окна истории добычи."
L["Loot Dropped:"] = "Список добычи:"
L["Loot Roll History"] = "История добычи"
L["Loot Quality"] = "Качество добычи"
L["Automatically announce in selected chat channel."] = "Автоматически выводить список добычи в выбранный канал чата"
L["Select chat channel to announce loot to."] = "Канал чата, для вывода сообщений."
L["Sets the alpha of Loot Roll Histroy frame."] = "Устанавливает прозрачность окна истории добычи"
L["Sets the minimum loot threshold to announce."] = "Минимальное качество предмета, для вывода в чате."
L["Auto Announce"] = "Авто оповещение"
L["Automaticaly hides Loot Roll Histroy frame when leaving the instance."] = "Автоматически скрывать окно истории добычи Blizzard при выходе из подземелья."
L['Loot Announcer'] = "Оповещение о добыче"
L["Loot Auto Roll"] = "Автоматические броски"
L["LOOT_AUTO_DESC"] = "Автоматически выбирает вариант при розыгрыше добычи, основываясь на заданных настройках."
L["Auto hide"] = "Автоматически скрывать"
L["Manual Override"] = "Принудительно"
L["Sets the button for manual override."] = "Задает кнопку, при зажатии которой добыча будет анонсироватья."
L["Auto Confirm"] = "Автоматически подтвердить"
L["Automatically click OK on BOP items"] = "Автоматически подтверждать поднятие/разрушение ПпП вещей"
L["Auto Greed"] = "Авто. не откажусь"
L["Automatically greed uncommon (green) quality items at max level"] = "Автоматически нажимать \"не откажусь\" на предметы зеленого качества на максимальном уровне."
L["Auto Disenchant"] = "Авто. распыление"
L["Automatically disenchant uncommon (green) quality items at max level"] = "Автоматически нажимать \"распылить\" на вещи зеленого качества на максимальном уровне."
L["Sets the auto greed/disenchant quality\n\nUncommon: Rolls on Uncommon only\nRare: Rolls on Rares & Uncommon"] = "Устанавливает качество предмета для автоматических бросков.\n\nНеобычное: разыгрывает только зеленые\nРедкие: разыгрывает синие и зеленые."
L["Roll based on level."] = "Уровень розыгрыша"
L["This will auto-roll if you are above the given level if: You cannot equip the item being rolled on, or the ilevel of your equipped item is higher than the item being rolled on or you have an heirloom equipped in that slot"] = "Автоматически разыгрывать добычу после установленного уровня, если: вы не можете надеть предмет, или надетый на вас предмет выше уровнем, или в этом слоте у вас фамильный предмет"
L["Level to start auto-rolling from"] = "Минимальный уровень розыгрыша"

--Nameplates--
L["Target Count"] = "Число выделений"
L["Display the number of party / raid members targetting the nameplate unit."] = "Показывать количество членов группы/рейда, выбравших в цель этот юнит."
L["Threat Text"] = "Текст угрозы"
L["Display threat level as text on targeted, boss or mouseover nameplate."] = "Отображает текст угрозы на индикаторе цели, босса или юнита под курсором."

--Minimap--
L["Minimap Options"] = "Опции миникарты"
L['Hide minimap in combat.'] = "Скрыть миникарту в бою"
L['MINIMAP_DESC'] = "Эти опции влияют на различные функции миникарты.  Некоторые опции погут не работать, если вы отключите миникарты в основных настройках ElvUI."
L["Minimap Coordinates"] = "Координаты на миникарте"
L['Enable/Disable Square Minimap Coords.'] = "Включить/выключить координаты на миникарте."
L['Coords Display'] = "Отображение координат"
L['Change settings for the display of the coordinates that are on the minimap.'] = "Укажите условие отображения координат на миникарте."
L["Coords Location"] = "Позиция координат"
L['This will determine where the coords are shown on the minimap.'] = "Определяет место, в котором будут отображаться координаты на миникарте"
L['Bottom Corners'] = "Нижние углы"
L['Bottom Center'] = "Внизу по центру"
L['Enable/Disable Square Minimap Buttons.'] = "Включить/выключить квадратные иконки у миникарты."
L["Bar Enable"] = "Включить полосу"
L['Enable/Disable Square Minimap Bar.'] = "Включить/выключить панель для иконок миникарты."
L['Skin Dungeon'] = "Иконка поиска"
L['Skin dungeon icon.'] = "Забирать иконку поиска группы."
L['Skin Mail'] = "Иконка почты"
L['Skin mail icon.'] = "Забирать иконку письма."
L['Icons Per Row'] = "Иконок в ряду"
L['The number of icons per row for Square Minimap Bar.'] = "Кол-во иконок в ряду на полосе иконок."
L['Anchor Setting'] = "Настрокий расположения"
L['Anchor mode for displaying the minimap buttons are skinned.'] = "Место расположения иконок аддонов, когда они стилизованы."
L['Horizontal Bar'] = "Горизонтальная панель"
L['Vertical Bar'] = "Вертикальная панель"
L['The size of the minimap buttons when not anchored to the minimap.'] = "Размер иконок миникарты, когда они находятся на полосе."
L['Show minimap buttons on mouseover.'] = "Отображать иконки при наведении мыши."
L["Instance indication"] = "Индикатор подземелья"
L['Show instance difficulty info as text.'] = "Показывать информацию о сложности подземелья в виде текста"
L['Sets the colors for difficulty abbreviation'] = "Устанавливает цвета для аббревиатур уровней сложности."
L['Show texture'] = "Показывать текстуру"
L['Show instance difficulty info as default texture.'] = "Показывать информацию о сложности подземелья в виде стандартной текстуры"
L['Minimap Alpha'] = "Прозрачность миникарты"
L['Decimals'] = "Десятые доли"

--Tooltip--
L["TTOFFSET_DESC"] = "Добавляет возможность сделать отступ подсказки от курсора. Работает только при включенной опции \"Около курсора\" в ElvUI."
L["Tooltip enhancements"] = "Дополнительные опции подсказки"
L["Faction Icon"] = "Иконка фракции"
L["Tooltip Cursor Offset"] = "Смещение подсказки"
L["Show faction icon to the left of player's name on tooltip."] = "Отображать иконку фракции около имени игроков в подсказках"
L["Tooltip X-offset"] = "Смещение подсказки по X"
L["Offset the tooltip on the X-axis."] = "Смещает подсказку по оси X относительно выбранной точки крепления."
L["Tooltip Y-offset"] = "Смещение подсказки по Y"
L["Offset the tooltip on the Y-axis."] = "Смещает подсказку по оси Y относительно выбранной точки крепления."

--UI buttons--
L["S&L UI Buttons"] = "Меню S&L"
L["UB_DESC"] = "Добавляет небольшую полосу с кнопками, дающими доступ к набору полезных функций."
L["Click to reload your interface"] = "Нажмите для перезагрузки интерфейса"
L["Click to toggle config window"] = "Нажмите для отображения окна настроек"
L["Click to toggle the AddOn Manager frame."] = "Нажмите для отображения окна менеджера аддонов."
L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."] = "Нажмите для отображения окна настроек включенного босс мода."
L["Click to unlock moving ElvUI elements"] = "Нажмите для входа в режим перемещения элементов"
L["ElvUI Config"] = "Настройка ElvUI"
L["Move UI"] = "Разблокировать элементы"
L["Reload UI"] = "Перезагрузить интерфейс"
L["AddOns Manager"] = "Менеджер аддонов"
L["Boss Mod"] = "Босс мод"
L["AddOns"] = "Аддоны"
L["S&L Config"] = "Настройки Shadow & Light"
L["Click to toggle Shadow & Light config group"] = "Нажмите, чтобы открыть группу настроек Shadow & Light"
L["Do a roll with custom limits. Those limits can be set in S&L config."] = "Сделать бросок с собственными пределами. Они могут быть выставлены в настройках S&L."
L["Minimum Roll Value"] = "Минимальное значение броска"
L["The lower limit for custom roll button."] = "Нижняя граница броска при использовании собственных установок."
L["Maximum Roll Value"] = "Масимальное значение броска"
L["The higher limit for custom roll button."] = "Верхняя граница броска при использовании собственных установок."
L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."] = "Пределы для броска указаны некорректно! Минимальное значение должно быть меньше максимального."
L["Quick Action"] = "Быстрое действие"
L["Use quick access (on right click) for this button."] = "Функция для быстрого действия. Вызывается нажатием ПКМ на кнопке открытия списка."
L["UI Buttons Style"] = "Стиль меню"
L['Dropdown'] = "Выпадающий список"
L["Function"] = "Функция"
L["Function called by quick access."] = "Функция, вызываемая быстрым доступом"

--Unitframes--
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
L["Choose what icon set will unitframes and chat use."] = "Набор иконок для использования на рамках юнитов и в чате."

--Raid Manager--
L["Options for customizing Blizzard Raid Manager \"O - > Raid\""] = "Опции настройки менеджера рейда \"О -> Рейд\""
L["Show role icons"] = "Показывать иконки роли"
L["Show level"] = "Показывать уровень"

L["Enhanced Vehicle Bar"] = "Улучшенный контроль машин"
L["A different look/feel vehicle bar based on work by Azilroka"] = "Использовать улучшенную панель управления средствами передвижения, основанную на коде Azilroka"

--Garrison--
L["Auto Work Orders"] = "Автоматические заказы"
L["Automatically queue maximum number of work orders available when visitin respected NPC."] = "Автоматически делать максимально возможное количество заказов при открытии соответствующего диалога."
L["Auto Work Orders for Warmill"] = "Авто. заказы на фабрике"
L["Automatically queue maximum number of work orders available for Warmill/Dwarven Bunker."] = "Автоматически делать максимальное количество заказов для военной фабрики/дворфийского бункера."
L["Auto Work Orders for Trading Post"] = "Авто. заказы в торговой лавке"
L["Automatically queue maximum number of work orders available for Trading Post."] = "Автоматически делать максимальное количество заказов для торговой лавки."
L["Auto Work Orders for Shipyard"] = "Авто. заказы на верфи"
L["Automatically queue maximum number of work orders available for Shipyard."] = "Автоматически делать максимальное количество заказов для верфи."

--Error Frame--
L["Error Frame"] = "Фрейм ошибок"
L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"] = "Устанавливает ширину фрейма ошибок. Если фрейм окажется слишком узким, текст будет разделен на несколько строк."
L["Set the height of Error Frame. Higher frame can show more lines at once."] = "Устанавливает высоту фрейма ошибок. Чем выше фрейм, тем больше строк может быть показано одновременно."

--Quests--
L["Rested"] = "Отдых"

--FAQ--
L["FAQ_DESC"] = "В этой секции представлены некоторые вопросы вопросы о ElvUI и Shadow & Light."
L["FAQ_Elv_1"] = [[|cff30ee30В: Где я могу получить поддержку по ElvUI?|r
|cff9482c9О:|r Лучшим местом, чтобы задать вопрос или попросить о помощи, будет официальный форум - tukui.org/forums/
Для сообщения об ошибке можно также воспользоваться тикет системой - git.tukui.org/Elv/elvui/issues]]
L["FAQ_Elv_2"] = [[|cff30ee30В: Обязательно ли для этого знать английский?|r
|cff9482c9О:|r Большая часть сообщений (включая гайды и ответы на вопросы) на форумах написаны на английском. Это официальный язык данного форума.
Однако это не значит, что англйский - единственный используемый там язык: при желании можно найти сообщения на испанском, французском, немецком, русском, итальянском и т.д.
При соблюдении простых правил приличия, никто не скажет слова против написания сообщений на вашем родном языке. Например, в заголовке темы тем или иным способом нужно указать язык самого сообщения.
Тем не менее, ответ вам может все же поступить на английском, если текущий отвечающий не знаком в вашим собственным.]]
L["FAQ_Elv_3"] = [[|cff30ee30В: Что нужно указать при сообщении об ошибке?|r
|cff9482c9О:|r Прежде всего убедитесь, что ошибка вызвана самим ElvUI.
Для этого отключите все аддоны, кроме ElvUI и ElvUI_Config.
Если ошибка остается, то она родная и можно о ней сообщать.
Необходимо будет указать версию ElvUI ("последняя" это не номер), текст ошибки и, при необходимости, скриншот.
Чем подробнее вы распишите саму ошибку и обстоятельства ее возникновения, тем быстрее и направленнее будет ее решение.]]
L["FAQ_Elv_4"] = [[|cff30ee30В: Почему некоторые опции не применяются на других персонажах, использующих тот же профиль?|r
|cff9482c9О:|r В ElvUI есть несколько типов опций. Первые (profile) храняться в профиле, вторые (private) применимы только для текущего персонажа, третьи (global) применяются для всех персонажей не зависимо от профиля.
Скорее всего в данном случае речь идет об опции второго типа.]]
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
L["Submodules and Coding:"] = "Субмодули и помощь с кодом:"
L["Other Support:"] = "Прочая поддержка:"
L["ELVUI_SLE_CREDITS"] = "Мы бы хотели отметить следующих людей, которые помогли нас сделать этот аддон посредством тестирования, кода и прочего."
L["ELVUI_SLE_MISC"] = [=[BuG - за то, что он француз :D
TheSamaKutra
Сообщество TukUI
]=]
