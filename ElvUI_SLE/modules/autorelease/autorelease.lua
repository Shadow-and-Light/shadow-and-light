--Credit to Repooc.
--Remade his auto release featule to module which allows profile setting of the function not the global one.
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AR = E:NewModule('AutoRelease', 'AceHook-3.0', 'AceEvent-3.0');
local myclass = E.myclass
local IsInInstance = IsInInstance
local soulstone = GetSpellInfo(20707)
local UnitLevel = UnitLevel
local option = false
local level = 0

local function Check(level)
	if ((myclass ~= "SHAMAN") and not (soulstone and UnitBuff("player", soulstone))) then
		RepopMe()
	elseif myclass == "SHAMAN" and level < 32 then
		RepopMe()
	end
end

function AR:Releasing()
	local inInstance, instanceType = IsInInstance()
	if myclass == "SHAMAN" then level = UnitLevel("player") end
	if (inInstance and (instanceType == "pvp")) then
		if E.db.sle.pvpautorelease then Check(level) end
	end
	
	-- auto resurrection for world PvP area...when active
	if E.db.sle.pvpautorelease then 
		for index = 1, GetNumWorldPVPAreas() do
			local _, localizedName, isActive = GetWorldPVPAreaInfo(index)
			if (GetRealZoneText() == localizedName and isActive) then Check(level) end
		end
	end
end

function AR:Initialize()
	self:RegisterEvent("PLAYER_DEAD", "Releasing");
end

E:RegisterModule(AR:GetName())