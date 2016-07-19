local parent, ns = ...
local oUF = ElvUF or oUF
local _G = _G

local Update = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end
	local offline = self.Offline
	local dc = self.Health.disconnected

	if dc or _G[offline.Group].isForced then
		offline:Show()
	else
		offline:Hide()
	end
end

local Path = function(self, ...)
	return (self.Health.Override or Update) (self, ...)
end

local Enable = function(self, unit)
	local offline = self.Offline
	if(offline) then
		offline.__owner = self

		self:RegisterEvent('UNIT_CONNECTION', Path)
		Update(self, nil, unit)
		return true
	end
end

local Disable = function(self)
	local offline = self.Health
	if(offline) then
		self:UnregisterEvent('UNIT_CONNECTION', Path)
		self.Offline:Hide()
	end
end

oUF:AddElement('SLE_Offline', Path, Enable, Disable)