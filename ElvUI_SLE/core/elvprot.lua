local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE');
--[[local find = string.find
local tinsert = tinsert

function E:IsFoolsDay()
	if not SLE:Auth() then E.global.aprilFools = true end
	if find(date(), '04/01/') and not E.global.aprilFools then
		return true;
	else
		return false;
	end
end

local function Fools2013()
	tinsert(E.massiveShakeObjects, M1)
	tinsert(E.massiveShakeObjects, M2)
	tinsert(E.massiveShakeObjects, M3)
	tinsert(E.massiveShakeObjects, M4)
	tinsert(E.massiveShakeObjects, M5)
	tinsert(E.massiveShakeObjects, M6)
	tinsert(E.massiveShakeObjects, M7)
	tinsert(E.massiveShakeObjects, M8)
	for i=1, 5 do
		if FseedButtons[i] then
			for j = 1, #FseedButtons[i] do
				tinsert(E.massiveShakeObjects, FseedButtons[i][j])
			end
		end
	end
	for i = 1, #FtoolButtons do
		tinsert(E.massiveShakeObjects, FtoolButtons[i])
	end
	for i = 1, #FportalButtons do
		tinsert(E.massiveShakeObjects, FportalButtons[i])
	end
	tinsert(E.massiveShakeObjects, ConfigUIButton)
	tinsert(E.massiveShakeObjects, ReloadUIButton)
	tinsert(E.massiveShakeObjects, MoveUIButton)
	tinsert(E.massiveShakeObjects, Bbutton)
	tinsert(E.massiveShakeObjects, Abutton)

	if Fbutton then tinsert(E.massiveShakeObjects, Fbutton) end

	tinsert(E.massiveShakeObjects, DP_1)
	tinsert(E.massiveShakeObjects, DP_2)
	tinsert(E.massiveShakeObjects, DP_3)
	tinsert(E.massiveShakeObjects, DP_4)
	tinsert(E.massiveShakeObjects, DP_5)
	tinsert(E.massiveShakeObjects, DP_6)
	tinsert(E.massiveShakeObjects, Top_Center)
	tinsert(E.massiveShakeObjects, Bottom_Panel)
	tinsert(E.massiveShakeObjects, BottomBG)
	tinsert(E.massiveShakeObjects, LeftBG)
	tinsert(E.massiveShakeObjects, RightBG)
	tinsert(E.massiveShakeObjects, ActionBG)
	tinsert(E.massiveShakeObjects, RaidUtility_ShowButton)
	tinsert(E.massiveShakeObjects, RaidUtilityPanel)
end

hooksecurefunc(E, "BeginFoolsDayEvent", Fools2013)]]