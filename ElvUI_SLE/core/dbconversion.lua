local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

--GLOBALS: ElvDB, ElvPrivateDB
local SLE_Test = false

local ProfileNames = NONE
local CharacterNames = NONE

local mediaFonts = {
	'mail',
	'objective',
	'objectiveHeader',
	'questFontSuperHuge',
}

--* BlizzMove Module Removed
E.PopupDialogs['SL_BLIZZMOVE_SUGGESTIONS'] = {
	text = L["SL_BLIZZMOVE_SUGGESTIONS_TEXT"],
	button1 = OKAY,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

--Convers all the things!
function SLE:DatabaseConversions()
	if ElvDB.SLE_DB_Ver == SLE.DBversion and not SLE_Test then return end --Only execute all this shit when current database is actually outdated.
	--Profile options conversion
	for profile, data in pairs(ElvDB.profiles) do
		-- if profile ~= "Minimalistic" then
		-- print(profile)
		-- end
		local profileChanged = false
		if data and data.sle then
			if data.sle.databars and data.sle.databars.exp then
				E:CopyTable(E.db.sle.databars.experience, data.sle.databars.exp)
				data.sle.databars.exp = nil
				profileChanged = true
			end
			if data.sle.databars and data.sle.databars.rep then
				E:CopyTable(E.db.sle.databars.reputation, data.sle.databars.rep)
				data.sle.databars.rep = nil
				profileChanged = true
			end
			if data.sle.databars and data.sle.databars.reputation and data.sle.databars.reputation.chatfilter and (data.sle.databars.reputation.chatfilter.style and type(data.sle.databars.reputation.chatfilter.style) ~= 'table') then
				local oldValue = E.db.sle.databars.reputation.chatfilter.style
				E.db.sle.databars.reputation.chatfilter.style = {}
				E:CopyTable(E.db.sle.databars.reputation.chatfilter.style, P.sle.databars.reputation.chatfilter.style)
				E.db.sle.databars.reputation.chatfilter.style.increase = oldValue
				profileChanged = true
			end
			if data.sle.Armory then data.sle.Armory = nil
				profileChanged = true
			end
			if data.sle.armory then
				if data.sle.armory.character then
					if data.sle.armory.character.ilvl then
						if data.sle.armory.character.ilvl.fontStyle == 'NONE' then
							data.sle.armory.character.ilvl.fontStyle = ''
							profileChanged = true
						end
					end
					if data.sle.armory.character.enchant then
						if data.sle.armory.character.enchant.fontStyle == 'NONE' then
							data.sle.armory.character.enchant.fontStyle = ''
							profileChanged = true
						end
					end
				end
				if data.sle.armory.inspect then
					if data.sle.armory.inspect.ilvl then
						if data.sle.armory.inspect.ilvl.fontStyle == 'NONE' then
							data.sle.armory.inspect.ilvl.fontStyle = ''
							profileChanged = true
						end
					end
					if data.sle.armory.inspect.enchant then
						if data.sle.armory.inspect.enchant.fontStyle == 'NONE' then
							data.sle.armory.inspect.enchant.fontStyle = ''
							profileChanged = true
						end
					end
				end
				if data.sle.armory.stats then
					if data.sle.armory.stats.itemLevel then
						if data.sle.armory.stats.itemLevel.size then
							E.db.sle.armory.stats.itemLevel.fontSize = data.sle.armory.stats.itemLevel.size
							data.sle.armory.stats.itemLevel.size = nil
							profileChanged = true
						end
						if data.sle.armory.stats.itemLevel.outline then
							E.db.sle.armory.stats.itemLevel.fontOutline = data.sle.armory.stats.itemLevel.outline
							data.sle.armory.stats.itemLevel.outline = nil
							profileChanged = true
						end
					end
					if data.sle.armory.stats.catFonts then
						if data.sle.armory.stats.catFonts.font then
							E.db.sle.armory.stats.statHeaders.font = data.sle.armory.stats.catFonts.font
							data.sle.armory.stats.catFonts.font = nil
							profileChanged = true
						end
						if data.sle.armory.stats.catFonts.size then
							E.db.sle.armory.stats.statHeaders.fontSize = data.sle.armory.stats.catFonts.size
							data.sle.armory.stats.catFonts.size = nil
							profileChanged = true
						end
						if data.sle.armory.stats.catFonts.outline then
							E.db.sle.armory.stats.statHeaders.fontOutline = data.sle.armory.stats.catFonts.outline
							data.sle.armory.stats.catFonts.outline = nil
							profileChanged = true
						end
					end
					if data.sle.armory.stats.statFonts then
						if data.sle.armory.stats.statFonts.font then
							E.db.sle.armory.stats.statLabels.font = data.sle.armory.stats.statFonts.font
							data.sle.armory.stats.statFonts.font = nil
							profileChanged = true
						end
						if data.sle.armory.stats.statFonts.size then
							E.db.sle.armory.stats.statLabels.fontSize = data.sle.armory.stats.statFonts.size
							data.sle.armory.stats.statFonts.size = nil
							profileChanged = true
						end
						if data.sle.armory.stats.statFonts.outline then
							E.db.sle.armory.stats.statLabels.fontOutline = data.sle.armory.stats.statFonts.outline
							data.sle.armory.stats.statFonts.outline = nil
							profileChanged = true
						end
					end
					if data.sle.armory.stats.AverageColor and (data.sle.armory.stats.AverageColor.r or data.sle.armory.stats.AverageColor.g or data.sle.armory.stats.AverageColor.b) then
						E:CopyTable(E.db.sle.armory.stats.itemLevel.AverageColor, data.sle.armory.stats.AverageColor)
						data.sle.armory.stats.AverageColor = nil
						profileChanged = true
					end
					if data.sle.armory.stats.IlvlColor then
						data.sle.armory.stats.IlvlColor = nil
						profileChanged = true
					end
					if data.sle.armory.stats.IlvlFull then
						E.db.sle.armory.stats.itemLevel.IlvlFull = data.sle.armory.stats.IlvlFull
						data.sle.armory.stats.IlvlFull = nil
						profileChanged = true
					end
					if data.sle.armory.stats.gradient then
						E.db.sle.armory.stats.itemLevel.gradient = data.sle.armory.stats.gradient
						data.sle.armory.stats.gradient = nil
						profileChanged = true
					end
				end
			end
			if data.sle.minimap then
				if data.sle.minimap.locPanel then
					if data.sle.minimap.locPanel.fontOutline == 'NONE' then
						data.sle.minimap.locPanel.fontOutline = ''
						profileChanged = true
					end
					if data.sle.minimap.locPanel.colorType_Coords then
						E:CopyTable(E.db.sle.minimap.locPanel.coords.colorType, data.sle.minimap.locPanel.colorType_Coords)
						data.sle.minimap.locPanel.colorType_Coords = nil
						profileChanged = true
					end
					if data.sle.minimap.locPanel.customColor_Coords then
						E:CopyTable(E.db.sle.minimap.locPanel.coords.customColor, data.sle.minimap.locPanel.customColor_Coords)
						data.sle.minimap.locPanel.customColor_Coords = nil
						profileChanged = true
					end
					if data.sle.minimap.portals then
						if type(data.sle.minimap.locPanel.portals.hsPrio) == 'table' then
							data.sle.minimap.locPanel.portals.hsPrio = P.sle.minimap.locPanel.portals.hsPrio
							profileChanged = true
						end
					elseif data.sle.minimap.locPanel.portals and data.sle.minimap.locPanel.portals.hsPrio then
						local CurrentDefault = P.sle.minimap.locPanel.portals.hsPrio
						local CurrentSettings = data.sle.minimap.locPanel.portals.hsPrio
						for hs in CurrentDefault:gmatch('%d+') do
							if not CurrentSettings:match(hs) then
								CurrentSettings = CurrentSettings .. ',' .. hs
								profileChanged = true
							end
						end
						if profileChanged then
							data.sle.minimap.locPanel.portals.hsPrio = CurrentSettings
						end
					end
				end
				if data.sle.minimap.coords then
					if data.sle.minimap.coords.fontOutline and data.sle.minimap.coords.fontOutline == 'NONE' then
						data.sle.minimap.coords.fontOutline = ''
						profileChanged = true
					end
				end
				if data.sle.minimap.instance then
					if data.sle.minimap.instance.fontOutline and data.sle.minimap.instance.fontOutline == 'NONE' then
						data.sle.minimap.instance.fontOutline = ''
						profileChanged = true
					end
				end

			end
			if data.sle.nameplates then
				if data.sle.nameplates.threat then
					if type(data.sle.nameplates.threat) == "table" then
						if data.sle.nameplates.threat.fontOutline and data.sle.nameplates.threat.fontOutline == 'NONE' then
							data.sle.nameplates.threat.fontOutline = ''
							profileChanged = true
						end
					else
						data.sle.nameplates.threat = nil
						profileChanged = true
					end
				end
				if data.sle.nameplates.targetcount then
					if type(data.sle.nameplates.targetcount) == "table" then
						if data.sle.nameplates.targetcount.fontOutline and data.sle.nameplates.targetcount.fontOutline == 'NONE' then
							data.sle.nameplates.targetcount.fontOutline = ''
							profileChanged = true
						end
					else
						data.sle.nameplates.targetcount = nil
						profileChanged = true
					end
				end

			end
			if data.sle.screensaver then
				data.sle.screensaver = nil
				profileChanged = true
			end
			if data.sle.skins then
				if data.sle.skins.merchant then
					if data.sle.skins.merchant.list then
						if data.sle.skins.merchant.list.nameOutline and data.sle.skins.merchant.list.nameOutline == 'NONE' then
							data.sle.skins.merchant.list.nameOutline = ''
							profileChanged = true
						end
						if data.sle.skins.merchant.list.subOutline and data.sle.skins.merchant.list.subOutline == 'NONE' then
							data.sle.skins.merchant.list.subOutline = ''
							profileChanged = true
						end
					end
				end
			end
			if profileChanged then
				if ProfileNames == NONE then
					ProfileNames = profile
				else
					ProfileNames = ProfileNames..', '..profile
				end
			end
		end
	end
	--Private options convert
	for private, data in pairs(ElvPrivateDB.profiles) do
		local privateChanged = false
		if data then
			if data.sle then
				if data.sle.module then
					if data.sle.module.blizzmove then
						E:StaticPopup_Show('SL_BLIZZMOVE_SUGGESTIONS')
						data.sle.module.blizzmove = nil
						privateChanged = true
					end
					if data.sle.module.screensaver and type(data.sle.module.screensaver) == 'boolean' then
						data.sle.module.screensaver = nil
						privateChanged = true
					end
				end
				if data.sle.equip then
					if data.sle.equip.onlyTalent then data.sle.equip.onlyTalent = nil end
				end
				if data.sle.professions then
					if data.sle.professions.fishing then
						if data.sle.professions.fishing.CastButton and data.sle.professions.fishing.CastButton == "None" then
							data.sle.professions.fishing.CastButton = "Shift"
							privateChanged = true
						end
					end
					if data.sle.professions.enchant then
						if data.sle.professions.enchant.enchScroll then
							data.sle.professions.enchant = nil
							privateChanged = true
						end
					end
				end
				if privateChanged then
					if CharacterNames == NONE then
						CharacterNames = private
					else
						CharacterNames = CharacterNames..', '..private
					end
				end
			end
		end
	end
	--Global settions converted
	local globals = ElvDB.global
	if globals then
		if globals.sle then
			if globals.sle.pvpreadydialogreset then globals.sle.pvpreadydialogreset = nil end
		end
	end

	if not SLE_Test then ElvDB.SLE_DB_Ver = SLE.DBversion end
	E:StaticPopup_Show('SLE_CONVERSION_COMPLETE', ProfileNames, CharacterNames)
end
