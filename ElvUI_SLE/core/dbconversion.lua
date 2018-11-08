local SLE, T, E, L, V, P, G = unpack(select(2, ...))

--GLOBALS: ElvDB

--Convers all the things!
function SLE:DatabaseConversions()
	for profile, data in T.pairs(ElvDB.profiles) do
		-- if profile ~= "Minimalistic" then
			-- print(profile)
		-- end
		if T.type(data.sle.minimap.locPanel.portals.hsPrio) == "table" then
			data.sle.minimap.locPanel.portals.hsPrio = P.sle.minimap.locPanel.portals.hsPrio
		end
	end
end
