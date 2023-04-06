local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local EC = SLE.ElvConfig

function EC:UpdateUnitframes()
	E.Options.args.unitframe.args.groupUnits.args.boss.args.generalGroup.args.positionsGroup.args.spacing.min = -4

	E.Options.args.unitframe.args.groupUnits.args.arena.args.generalGroup.args.positionsGroup.args.spacing.min = -4

	E.Options.args.unitframe.args.groupUnits.args.party.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.party.args.generalGroup.args.positionsGroup.args.horizontalSpacing.max = 100 --Roxanne
	E.Options.args.unitframe.args.groupUnits.args.party.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.groupUnits.args.raid1.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.raid1.args.generalGroup.args.positionsGroup.args.horizontalSpacing.max = 100 --Roxanne
	E.Options.args.unitframe.args.groupUnits.args.raid1.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.groupUnits.args.raid2.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.raid2.args.generalGroup.args.positionsGroup.args.horizontalSpacing.max = 100 --Roxanne
	E.Options.args.unitframe.args.groupUnits.args.raid2.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.groupUnits.args.raid3.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.raid3.args.generalGroup.args.positionsGroup.args.horizontalSpacing.max = 100 --Roxanne
	E.Options.args.unitframe.args.groupUnits.args.raid3.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.groupUnits.args.raidpet.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.raidpet.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.groupUnits.args.tank.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.groupUnits.args.assist.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4

	-- Change Portrait max camDistanceScale
	for unit in pairs(E.Options.args.unitframe.args.individualUnits.args) do
		if E.Options.args.unitframe.args.individualUnits.args[unit].args and E.Options.args.unitframe.args.individualUnits.args[unit].args.portrait then
			E.Options.args.unitframe.args.individualUnits.args[unit].args.portrait.args.camDistanceScale.max = 7
		end
	end
	for unit in pairs(E.Options.args.unitframe.args.groupUnits.args) do
		if E.Options.args.unitframe.args.groupUnits.args[unit].args and E.Options.args.unitframe.args.groupUnits.args[unit].args.portrait then
			E.Options.args.unitframe.args.groupUnits.args[unit].args.portrait.args.camDistanceScale.max = 7
		end
	end
end

function EC:ADDON_LOADED(event, addon)
	if addon ~= 'ElvUI_OptionsUI' then return end
	EC:UnregisterEvent(event)
	EC:UpdateUnitframes()
end

function EC:Initialize()
	if not SLE.initialized or not E.global.sle.advanced.optionsLimits then return end
	EC:RegisterEvent('ADDON_LOADED')
end

SLE:RegisterModule(EC:GetName())
