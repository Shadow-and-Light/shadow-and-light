local SLE, T, E, L, V, P, G = unpack(select(2, ...))

--GLOBALS: ElvDB

--Convers all the things!
function SLE:DatabaseConversions()
	for profile, data in T.pairs(ElvDB.profiles) do
		-- if profile ~= "Minimalistic" then
			-- print(profile)
		-- end
		if data then
			if data.sle then
				if data.sle.Armory then
					if data.sle.Armory.Character then
						if data.sle.Armory.Character.Level then
							if data.sle.Armory.Character.Level.ItemColor then
								if T.type(data.sle.Armory.Character.Level.ItemColor) == "boolean" then
									data.sle.Armory.Character.Level.ItemColor = P.sle.Armory.Character.Level.ItemColor
								end
							end
						end
					end
				end
				if data.sle.minimap then 
					if data.sle.minimap.portals then
						if T.type(data.sle.minimap.locPanel.portals.hsPrio) == "table" then
							data.sle.minimap.locPanel.portals.hsPrio = P.sle.minimap.locPanel.portals.hsPrio
						end
					elseif data.sle.minimap.locPanel.portals and data.sle.minimap.locPanel.portals.hsPrio then
						local tbl = {T.split(",", data.sle.minimap.locPanel.portals.hsPrio)}
						local tblP = {T.split(",", P.sle.minimap.locPanel.portals.hsPrio)}
						if #tbl < #tblP then
							for i = #tbl+1, #tblP do
								data.sle.minimap.locPanel.portals.hsPrio = data.sle.minimap.locPanel.portals.hsPrio .. "," .. tblP[i]
							end
						end
					end
				end
			end
		end
	end
end
