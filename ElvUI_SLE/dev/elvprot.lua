local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local SLE = E:GetModule('SLE');

function E:IsFoolsDay()
	if SLE:Auth() then E.global.aprilFools = true end
	if find(date(), '04/01/') and not E.global.aprilFools then
		return true;
	else
		return false;
	end
end


