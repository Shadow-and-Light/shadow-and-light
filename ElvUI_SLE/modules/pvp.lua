local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local PvP = SLE:NewModule('PVP','AceHook-3.0', 'AceEvent-3.0')
--GLOBALS: hooksecurefunc, CreateFrame
local RepopMe, HasSoulstone = RepopMe, HasSoulstone
local COMBATLOG_HONORGAIN, COMBATLOG_HONORGAIN_NO_RANK, COMBATLOG_HONORAWARD = COMBATLOG_HONORGAIN, COMBATLOG_HONORGAIN_NO_RANK, COMBATLOG_HONORAWARD
local PVP_RANK_0_0 =PVP_RANK_0_0
local GetCurrencyInfo = GetCurrencyInfo
PvP.HonorStrings = {}
local FactionToken = UnitFactionGroup("player")
local bit_band = bit.band
local BG_Opponents = {
}
local _G = _G
local CancelDuel = CancelDuel
local StaticPopup_Hide = StaticPopup_Hide
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local TopBannerManager_Show = TopBannerManager_Show
local BossBanner_BeginAnims = BossBanner_BeginAnims
local PlaySound = PlaySound




function PvP:Release()
	if (PvP.db.rebirth and not HasSoulstone()) or not PvP.db.rebirth then RepopMe() end
end

function PvP:Dead()
	local inInstance, instanceType = T.IsInInstance()
	if not PvP.db.autorelease then return end --Option disabled = do jack shit
	if (inInstance and instanceType == "pvp") then
		PvP:Release()
		return --To prevent the rest of the function from execution when not needed
	end
	-- auto resurrection for world PvP area...when active
	for index = 1, T.GetNumWorldPVPAreas() do
		local _, localizedName, isActive, canQueue = T.GetWorldPVPAreaInfo(index)
		if (T.GetRealZoneText() == localizedName and isActive) or (T.GetRealZoneText() == localizedName and canQueue) then PvP:Release() end
	end
end

function PvP:UpdatePvPHolder()
	if PvP.CaptureBar1 then
		PvP.CaptureBar1:HookScript("OnShow", function(self) self:SetPoint("TOP", PvP.AlwaysUpFrame, "BOTTOM", 0, -10) end)
		PvP.CaptureBar1:Hide()
		PvP.CaptureBar1:Show()
		PvP:UnregisterEvent("UPDATE_WORLD_STATES")
	end
end

function PvP:Duels(event, name)
	local cancelled = false
	if event == "DUEL_REQUESTED" and PvP.db.duels.regular then
		CancelDuel()
		StaticPopup_Hide("DUEL_REQUESTED")
		cancelled = "REGULAR"
	elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" and PvP.db.duels.pet then
		C_PetBattles.CancelPVPDuel()
		StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
		cancelled = "PET"
	end
	if cancelled then
		SLE:Print(T.format(L["SLE_DuelCancel_"..cancelled], name))
	end
end

function PvP:OpponentsTable()
	T.twipe(BG_Opponents)
	for index = 1, T.GetNumBattlefieldScores() do
		local name, _, _, _, _, faction, _, _, classToken = T.GetBattlefieldScore(index)
		if (FactionToken == "Horde" and faction == 1) or (FactionToken == "Alliance" and faction == 0) then
			BG_Opponents[name] = classToken
		end
	end
end

function PvP:LogParse(event, ...)
	local _, subevent, _, _, Caster, _, _, _, TargetName, TargetFlags = ...
	if subevent == "PARTY_KILL" then
		local mask = bit_band(TargetFlags, COMBATLOG_OBJECT_TYPE_PLAYER)
		if Caster == E.myname and (BG_Opponents[TargetName] or mask > 0) then
			if mask > 0 and BG_Opponents[TargetName] then TargetName = "|c"..RAID_CLASS_COLORS[BG_Opponents[TargetName]].colorStr..TargetName.."|r" end
			TopBannerManager_Show(_G["BossBanner"], { name = TargetName, mode = "PVPKILL" });
		end
	end
end

function PvP:Initialize()
	if not SLE.initialized then return end
	PvP.db = E.db.sle.pvp
	PvP.AlwaysUpFrame = WorldStateAlwaysUpFrame
	PvP.CaptureBar1 = WorldStateCaptureBar1
	--AutoRes event
	self:RegisterEvent("PLAYER_DEAD", "Dead");
	--Mover for pvp info
	PvP.holder = CreateFrame("Frame", "SLE_PvPHolder", E.UIParent)
	PvP.holder:SetSize(10, 58)
	PvP.holder:SetPoint("TOP", E.UIParent, "TOP", -5, -15)
	PvP.AlwaysUpFrame:ClearAllPoints()
	PvP.AlwaysUpFrame:SetPoint("CENTER", PvP.holder)
	self:RegisterEvent("UPDATE_WORLD_STATES", "UpdatePvPHolder")
	E:CreateMover(PvP.holder, "PvPMover", "PvP", nil, nil, nil, "ALL,S&L,S&L MISC")

	self:RegisterEvent("DUEL_REQUESTED", "Duels")
	self:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED", "Duels")

	function PvP:ForUpdateAll()
		PvP.db = E.db.sle.pvp
	end
	
	if E.private.sle.pvp.KBbanner.enable then
		hooksecurefunc(_G["BossBanner"], "PlayBanner", function(self, data)
			if ( data ) then
				if ( data.mode == "PVPKILL" ) then
					self.Title:SetText(data.name);
					self.Title:Show();
					self.SubTitle:Hide();
					self:Show();
					BossBanner_BeginAnims(self);
					if E.private.sle.pvp.KBbanner.sound then PlaySound("UI_Raid_Boss_Defeated") end
				end
			end
		end)
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "LogParse")
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE", "OpponentsTable")
	end
end

SLE:RegisterModule(PvP:GetName())