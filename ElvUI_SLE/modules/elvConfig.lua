local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local EC = SLE:NewModule("ElvConfig", "AceEvent-3.0")

--Module to allow changing default ElvUI settings limits

--When config is loaded
function EC:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end
	EC:UnregisterEvent(event)
	EC:UpdateActionbars()
	EC:UpdateUitframes()
end

--Changing actionbars options. Allowing negative minimum button spacing
function EC:UpdateActionbars()
	local extra = SLE._Compatibility["ElvUI_ExtraActionBars"]
	if extra then --If ExtraActionBars loaded
		if not E.Options.args.blazeplugins then --Blaze's options sectiot, setup a delay and exit
			E:Delay(0.1, EC.UpdateActionbars)
			return
		end
		--Change stuff for additional bars
		for i = 7, 10 do
			E.Options.args.blazeplugins.args.EAB.args['bar'..i].args.buttonspacing.min = -4
		end
	end
	--Change stuff for regular bars
	for i=1, 6 do
		E.Options.args.actionbar.args['bar'..i].args.buttonspacing.min = -4
	end
	E.Options.args.actionbar.args.barPet.args.buttonspacing.min = -4
	E.Options.args.actionbar.args.stanceBar.args.buttonspacing.min = -4
end

--Allowing group frames to have negative minimum on horizontal and vertical spacing. Also max camera distance
function EC:UpdateUitframes()
	--Boss/Arena
	E.Options.args.unitframe.args.boss.args.generalGroup.args.spacing.min = -4
	E.Options.args.unitframe.args.arena.args.generalGroup.args.spacing.min = -4
	--Party
	E.Options.args.unitframe.args.party.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.party.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4
	--Raid
	E.Options.args.unitframe.args.raid.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.raid.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4
	--Raid 40
	E.Options.args.unitframe.args.raid40.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.raid40.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4
	--Raid Pets
	E.Options.args.unitframe.args.raidpet.args.generalGroup.args.positionsGroup.args.horizontalSpacing.min = -4
	E.Options.args.unitframe.args.raidpet.args.generalGroup.args.positionsGroup.args.verticalSpacing.min = -4
	--Tanks/ASssists
	E.Options.args.unitframe.args.tank.args.generalGroup.args.verticalSpacing.min = -4
	E.Options.args.unitframe.args.assist.args.generalGroup.args.verticalSpacing.min = -4
	--Camera for frames with portraits
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