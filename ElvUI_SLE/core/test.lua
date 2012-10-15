local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local AL = E:NewModule('Autoloot', 'AceHook-3.0', 'AceEvent-3.0');
local M = E:GetModule('Misc')

function M:ErrorFrameToggle(event)
	if event == 'PLAYER_REGEN_DISABLED' and E.private.sle.errors ~= true then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
	end
end

E.Options.args.sle.args.general.args.errors = {
	order = 3,
	type = "toggle",
	name = L["Errors in combat"],
	desc = L["Show/hide error messages in combat."],
	get = function(info) return E.private.sle.errors end,
	set = function(info, value) E.private.sle.errors = value; E:StaticPopup_Show("PRIVATE_RL") end
}

E.Options.args.sle.args.general.args.autoloot = {
	order = 2,
	type = "toggle",
	name = "Autoloot",
	desc = "Enable/Disable Autoloot window",
	get = function(info) return E.db.sle.autoloot end,
	set = function(info, value) E.db.sle.autoloot = value; end
}
function AL:LootShow() --Needs to be run on PLAYER_ENTERING_WORLD event = loading screen ends. Also need a module assinged.
	local inInstance, instanceType = IsInInstance()
	--local isDungeon = (instanceType == "party")
	if (inInstance and (instanceType == "party" or "raid") and E.db.sle.autoloot) then --in instance with option enabled
		LootHistoryFrame:Show()
	elseif (inInstance and (instanceType == "party" or "raid") and not E.db.sle.autoloot) then --in instance with option disabled
	elseif (not inInstance and E.db.sle.autoloot) then--out of instance with option enabled
		LootHistoryFrame:Hide()
	else --out of instance with option disabled
	end
end

function AL:Initialize()
	self:LootShow()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'LootShow')
	self:RegisterEvent('PLAYER_LOGIN', 'LootShow')
end

E:RegisterModule(AL:GetName())