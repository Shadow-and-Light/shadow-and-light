local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local EC = SLE:NewModule("ElvConfig", "AceEvent-3.0")

function EC:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end
	EC:UnregisterEvent(event)
	EC:UpdateActionbars()
	EC:UpdateUitframes()
end

function EC:UpdateActionbars()
	local extra = T.IsAddOnLoaded('ElvUI_ExtraActionBars')
	if extra then
		if not E.Options.args.blazeplugins then
			E:Delay(0.1, EC.UpdateActionbars)
			return
		end
		for i = 7, 10 do
			E.Options.args.blazeplugins.args.EAB.args['bar'..i].args.buttonspacing.min = -4
		end
	end
	for i=1, 6 do
		E.Options.args.actionbar.args['bar'..i].args.buttonspacing.min = -4
	end
	E.Options.args.actionbar.args.barPet.args.buttonspacing.min = -4
	E.Options.args.actionbar.args.stanceBar.args.buttonspacing.min = -4
end

function EC:UpdateUitframes()
	E.Options.args.unitframe.args.boss.args.spacing.min = -4
	E.Options.args.unitframe.args.arena.args.spacing.min = -4

	E.Options.args.unitframe.args.party.args.general.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.party.args.general.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.raid.args.general.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.raid.args.general.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.raid40.args.general.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.raid40.args.general.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.raidpet.args.general.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.raidpet.args.general.args.positionsGroup.args.verticalSpacing.min = -4

	E.Options.args.unitframe.args.tank.args.general.args.verticalSpacing.min = -4
	E.Options.args.unitframe.args.assist.args.general.args.verticalSpacing.min = -4
	
	for unit, settings in T.pairs(E.Options.args.unitframe.args) do
		if E.Options.args.unitframe.args[unit].args and E.Options.args.unitframe.args[unit].args.portrait then
			E.Options.args.unitframe.args[unit].args.portrait.args.camDistanceScale.max = 7
		end
	end
end

function EC:Initialize()
	if not SLE.initialized then return end
	if not E.global.sle.advanced.optionsLimits then return end
	self:RegisterEvent("ADDON_LOADED")
end

SLE:RegisterModule(EC:GetName())