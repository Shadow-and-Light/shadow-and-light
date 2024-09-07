local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local M = SLE.Media

function M:Initialize()
	if not SLE.initialized then return end
end

SLE:RegisterModule(M:GetName())
