local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local SLE = E:GetModule('SLE');
local find = string.find

function E:IsFoolsDay()
	if not SLE:CheckFlag(nil, 'SLEAUTHOR') then E.global.aprilFools = true end
	if find(date(), '04/01/') and not E.global.aprilFools then
		return true;
	else
		return false;
	end
end

E.BeginFoolsDayEventSLE = E.BeginFoolsDayEvent
function E:BeginFoolsDayEvent()
	E.BeginFoolsDayEventSLE(self)
	tinsert(self.massiveShakeObjects, M1)
	tinsert(self.massiveShakeObjects, M2)
	tinsert(self.massiveShakeObjects, M3)
	tinsert(self.massiveShakeObjects, M4)
	tinsert(self.massiveShakeObjects, M5)
	tinsert(self.massiveShakeObjects, M6)
	tinsert(self.massiveShakeObjects, M7)
	tinsert(self.massiveShakeObjects, M8)
	for i=1, 5 do
		if FseedButtons[i] then
			for j = 1, #FseedButtons[i] do
					tinsert(self.massiveShakeObjects, FseedButtons[i][j])
			end
		end
	end
	for i = 1, #FtoolButtons do
		tinsert(self.massiveShakeObjects, FtoolButtons[i])
	end
	for i = 1, #FportalButtons do
		tinsert(self.massiveShakeObjects, FportalButtons[i])
	end
	tinsert(self.massiveShakeObjects, ConfigUIButton)
	tinsert(self.massiveShakeObjects, ReloadUIButton)
	tinsert(self.massiveShakeObjects, MoveUIButton)
	tinsert(self.massiveShakeObjects, Bbutton)
	tinsert(self.massiveShakeObjects, Abutton)
	if Fbutton then tinsert(self.massiveShakeObjects, Fbutton) end
	tinsert(self.massiveShakeObjects, DP_1)
	tinsert(self.massiveShakeObjects, DP_2)
	tinsert(self.massiveShakeObjects, DP_3)
	tinsert(self.massiveShakeObjects, DP_4)
	tinsert(self.massiveShakeObjects, DP_5)
	tinsert(self.massiveShakeObjects, DP_6)
	tinsert(self.massiveShakeObjects, Top_Center)
	tinsert(self.massiveShakeObjects, Bottom_Panel)
	tinsert(self.massiveShakeObjects, BottomBG)
	tinsert(self.massiveShakeObjects, LeftBG)
	tinsert(self.massiveShakeObjects, RightBG)
	tinsert(self.massiveShakeObjects, ActionBG)
	tinsert(self.massiveShakeObjects, RaidUtility_ShowButton)
	tinsert(self.massiveShakeObjects, RaidUtilityPanel)
end


