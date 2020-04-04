local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local EC = SLE:NewModule("ElvConfig", "AceEvent-3.0")

--Module to allow changing default ElvUI settings limits

--When config is loaded
function EC:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_OptionsUI" then return end
	EC:UnregisterEvent(event)
	EC:UpdateActionbars()
	EC:UpdateUitframes()
end

--Changing actionbars options. Allowing negative minimum button spacing
function EC:UpdateActionbars()
	--Change stuff for regular bars
	for i=1, 10 do
		E.Options.args.actionbar.args.playerBars.args["bar"..i].args.buttonspacing.min = -4
	end
	E.Options.args.actionbar.args.barPet.args.buttonspacing.min = -4
	E.Options.args.actionbar.args.stanceBar.args.buttonspacing.min = -4
end

--Allowing group frames to have negative minimum on horizontal and vertical spacing. Also max camera distance
function EC:UpdateUitframes()
	--Boss/Arena
	E.Options.args.unitframe.args.groupUnits.args.boss.args.generalGroup.args.spacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.arena.args.generalGroup.args.spacing.min = -4
	--Party
	E.Options.args.unitframe.args.groupUnits.args.party.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.party.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4
	--Raid
	E.Options.args.unitframe.args.groupUnits.args.raid.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.raid.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4
	--Raid 40
	E.Options.args.unitframe.args.groupUnits.args.raid40.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.raid40.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4
	--Raid Pets
	E.Options.args.unitframe.args.groupUnits.args.raidpet.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.groupUnits.args.raidpet.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4
	--Tanks/ASssists
	-- E.Options.args.unitframe.args.groupUnits.args.tank.args.generalGroup.args.verticalSpacing.min = -4
	-- E.Options.args.unitframe.args.groupUnits.args.assist.args.generalGroup.args.verticalSpacing.min = -4
	--Camera for frames with portraits
	for unit, settings in T.pairs(E.Options.args.unitframe.args.individualUnits.args) do
		if E.Options.args.unitframe.args.individualUnits.args[unit].args and E.Options.args.unitframe.args.individualUnits.args[unit].args.portrait then
			E.Options.args.unitframe.args.individualUnits.args[unit].args.portrait.args.camDistanceScale.max = 7
		end
	end
	for unit, settings in T.pairs(E.Options.args.unitframe.args.groupUnits.args) do
		if E.Options.args.unitframe.args.groupUnits.args[unit].args and E.Options.args.unitframe.args.groupUnits.args[unit].args.portrait then
			E.Options.args.unitframe.args.groupUnits.args[unit].args.portrait.args.camDistanceScale.max = 7
		end
	end
end

function EC:Initialize()
	if not SLE.initialized then return end
	if not E.global.sle.advanced.optionsLimits then return end
	self:RegisterEvent("ADDON_LOADED")
end

SLE:RegisterModule(EC:GetName())