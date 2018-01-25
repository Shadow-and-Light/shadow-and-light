local parent, ns = ...
local oUF = ElvUF or oUF
local _G = _G
local UnitIsDead = UnitIsDead

local Update = function(self, event, unit)
	local dead = self.Dead
	if unit and unit ~= self.unit then return end
	if not unit then unit = self.unit end
	local corpse = UnitIsDead(unit) or UnitIsGhost(unit)
	if corpse or _G[dead.Group].isForced then
		dead:Show()
	else
		dead:Hide()
	end
end

local Path = function(self, ...)
	return (self.Dead.Override or Update) (self, ...)
end

local Enable = function(self, unit)
	local dead = self.Dead
	if(dead) then
		dead.__owner = self

		-- self:RegisterEvent('PLAYER_ALIVE', Path)
		-- self:RegisterEvent('PLAYER_UNGHOST', Path)
		-- self:RegisterEvent('PLAYER_DEAD', Path)
		self:RegisterEvent('UNIT_HEALTH', Path)
		Update(self, nil, unit)
		return true
	end
end

local Disable = function(self)
	local dead = self.Dead
	if(dead) then
		-- self:UnregisterEvent('PLAYER_ALIVE', Path)
		-- self:UnregisterEvent('PLAYER_UNGHOST', Path)
		-- self:UnregisterEvent('PLAYER_DEAD', Path)
		self:UnregisterEvent('UNIT_HEALTH', Path)
		self.Dead:Hide()
	end
end

oUF:AddElement('SLE_Dead', Path, Enable, Disable)