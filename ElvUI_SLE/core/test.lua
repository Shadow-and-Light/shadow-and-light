local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local T = E:GetModule('SLE_Test');
local LSM = LibStub("LibSharedMedia-3.0")

-- local f1, f2, b1, b2

-- function T:Load(event, addon)
	-- if addon ~= "ElvUI_Config" then return end
	-- T:UnregisterEvent("ADDON_LOADED")
	
	-- E.Options.args.actionbar.args.enable.name = '|cff30ee30'..L["Enable"]..'|r'
	
-- end

-- function T:Initialize()
	-- self:RegisterEvent("ADDON_LOADED", "Load")
	--[[f1 = CreateFrame("PlayerModel")
	f1:SetPoint("TOPLEFT", LeftChatPanel,"TOPLEFT",0,0)
	f1:SetHeight(E.db.chat.panelHeight)
	f1:SetWidth(E.db.chat.panelWidth)
	
	f1:SetFrameStrata(LeftChatPanel:GetFrameStrata())
	f1:SetFrameLevel(LeftChatPanel:GetFrameLevel() - 2)
	f1:SetScale(0.71)
	f1:SetUnit("player")
	
	f1:SetPosition(2.5,0,-0.9)
	f1:SetFacing(0.5)]]
-- end

-- local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
    -- obj:SetFont(font, size, style)
    -- if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
    -- if sox and soy then obj:SetShadowOffset(sox, soy) end
    -- if r and g and b then obj:SetTextColor(r, g, b)
    -- elseif r then obj:SetAlpha(r) end
-- end

-- function T:Set()
	-- local NORMAL        = E["media"].normFont
    -- local NUMBER        = E["media"].normFont
	-- SetFont(ZoneTextString, LSM:Fetch('font', 'ElvUI Pixel'), 36, 'MONOCHROMEOUTLINE')
	-- SetFont(SubZoneTextString,  NORMAL, 13, "OUTLINE")
-- end

-- E:RegisterModule(T:GetName())

-- hooksecurefunc(E, "UpdateBlizzardFonts", T.Set)