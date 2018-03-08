local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.db.sle.skins.talkinghead.hide then
		if (not IsAddOnLoaded("Blizzard_TalkingHeadUI")) then
			local f = CreateFrame("Frame")
			f:RegisterEvent("ADDON_LOADED")
			f:SetScript("OnEvent", function(self, event, addon)
				if event == "ADDON_LOADED" and addon == "Blizzard_TalkingHeadUI" then
					hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
						TalkingHeadFrame:Hide()
					end)
					self:UnregisterEvent(event)
				end
			end)
		else
			hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
				TalkingHeadFrame:Hide()
			end)
		end
	end
end

hooksecurefunc(S, "Initialize", LoadSkin)