local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local B = SLE.Blizzard

--GLOBALS: unpack, tinsert
local tinsert = tinsert

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.blizz = {
		order = 1,
		type = 'group',
		name = 'Blizzard',
		args = {
			header = ACH:Header('Blizzard', 1),
		},
	}
end

tinsert(SLE.Configs, configTable)
