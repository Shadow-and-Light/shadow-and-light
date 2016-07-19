local SLE, T, E, L, V, P, G = unpack(select(2, ...))

function SLE:CyrCommands()
	SLASH_RELOADUI3 = "/кд"

	E:RegisterChatCommand("шт", "DelayScriptCall") --in
	E:RegisterChatCommand("ус", "ToggleConfig") --ec
	E:RegisterChatCommand("удмгш", "ToggleConfig") --elvui
	E:RegisterChatCommand('ипыефеы', 'BGStats') --bgstats
	E:RegisterChatCommand('руддщлшеен', 'HelloKittyToggle') --hellokitty
	E:RegisterChatCommand('руддщлшеенашч', 'HelloKittyFix') --hellokittyfix
	E:RegisterChatCommand('рфкдуьырфлу', 'HarlemShakeToggle') --harlemshake
	E:RegisterChatCommand('упкшв', 'Grid') --egrid
	E:RegisterChatCommand("ьщмугш", "ToggleConfigMode") --moveui
	E:RegisterChatCommand("куыуегш", "ResetUI") --resetui
	-- E:RegisterChatCommand('сдуфтпгшдв', 'MassGuildKick') --cleanguild
	-- E:RegisterChatCommand('фзкшдащщды', 'DisableTukuiMode') --aprilfools

	if E.ActionBars then
		self:RegisterChatCommand('ли', E.ActionBars.ActivateBindMode) --kb
	end
end

function SLE:CyrDevCommands()
	SLASH_FRAME2 = "/акфьу"
	SLASH_FRAMELIST2 = "/акфьудшые"
	SLASH_TEXLIST2 = "/еучдшые"

	E:RegisterChatCommand('дгфуккщк', 'LuaError') --luaerror
	E:RegisterChatCommand('сзгшьзфсе', 'GetCPUImpact') --cpuimpact
	E:RegisterChatCommand('сзггыфпу', 'GetTopCPUFunc') --cpuusage
	E:RegisterChatCommand('утфидуидшяяфкв', 'EnableBlizzardAddOns') --enableblizzard
end

function SLE:CyrillicsInit()
	if GetLocale() == "ruRU" then
		SLE.Russian = true

		SLE.RuMonths = {"Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"}
		SLE.RuWeek = {"Воскресенье","Понедельник","Вторник","Среда","Четверг","Пятница","Суббота"}
	end

	if E.global.sle.advanced.cyrillics.commands or GetLocale() == "ruRU" then SLE:CyrCommands() end
	if E.global.sle.advanced.cyrillics.devCommands or GetLocale() == "ruRU" then SLE:CyrDevCommands() end
end
-- if GetLocale() ~= "ruRU" then return end


