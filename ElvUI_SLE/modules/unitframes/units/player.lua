local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");

function UF:DefOffsetSetting()
	if E.db.unitframe.units.player.classbar.xOffset == nil then
		E.db.unitframe.units.player.classbar.xOffset = 0
	end
	if E.db.unitframe.units.player.classbar.yOffset == nil then
		E.db.unitframe.units.player.classbar.yOffset = 0
	end
	--This is for enable/disable option.
	if E.db.unitframe.units.player.classbar.offset == nil then
		E.db.unitframe.units.player.classbar.offset = false
	end
end

--Setting the variable for using classbar. Elv's function.
local CAN_HAVE_CLASSBAR = (E.myclass == "PALADIN" or E.myclass == "DRUID" or E.myclass == "DEATHKNIGHT" or E.myclass == "WARLOCK" or E.myclass == "PRIEST" or E.myclass == "MONK" or E.myclass == 'MAGE')

ElvUF_Player:SetScript("OnUpdate", function()
	if not E.db.sle.combatico.enable then
		ElvUF_Player.Combat:Hide()
	end
end)
--Function to move damn combat indicator to topright part of the frame. Maybe i should create an option to make it placeble everywhere.
function UF:Update_CombatIndicator()
	local CombatText = ElvUF_Player.Combat
	
	local x, y = self:GetPositionOffset(E.db.sle.combatico.pos)
	CombatText:ClearAllPoints()
	CombatText:Point(E.db.sle.combatico.pos, ElvUF_Player.Health, E.db.sle.combatico.pos, x, x)
end

UF.Update_PlayerFrameSLE = UF.Update_PlayerFrame
function UF:Update_PlayerFrame(frame, db)
	UF:Update_PlayerFrameSLE(frame, db)
	
	local health = frame.Health
	local power = frame.Power
	
	local BORDER = E:Scale(2)
	local SPACING = E:Scale(1)
	local UNIT_WIDTH = db.width
	local UNIT_HEIGHT = db.height
	
	local USE_POWERBAR = db.power.enable
	local USE_MINI_POWERBAR = db.power.width ~= 'fill' and USE_POWERBAR
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR
	local POWERBAR_OFFSET = db.power.offset
	local POWERBAR_HEIGHT = db.power.height
	local POWERBAR_WIDTH = db.width - (BORDER*2)
	
	local USE_CLASSBAR = db.classbar.enable and CAN_HAVE_CLASSBAR
	local USE_MINI_CLASSBAR = db.classbar.fill == "spaced" and USE_CLASSBAR
	local CLASSBAR_HEIGHT = db.classbar.height
	local CLASSBAR_WIDTH = db.width - (BORDER*2)
	
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT
	local PORTRAIT_WIDTH = db.portrait.width
	
	local unit = self.unit
	
	--Power Text
		local x, y = self:GetPositionOffset(db.power.position)
		power.value:ClearAllPoints()
		power.value:Point(db.power.position, frame.Power, db.power.position, x, y)		
		frame:Tag(power.value, db.power.text_format)
	
	if not E.db.unitframe.units.player.classbar.offset then return end --Checking for offset option enabled
	--All this crap is needed to be copied from Elv's player.lua to avoid graphical bugs
	--Adjust some variables
	do
		if not USE_POWERBAR then
			POWERBAR_HEIGHT = 0
		end
		
		if USE_PORTRAIT_OVERLAY or not USE_PORTRAIT then
			PORTRAIT_WIDTH = 0
			if USE_POWERBAR_OFFSET then
				CLASSBAR_WIDTH = CLASSBAR_WIDTH - POWERBAR_OFFSET
			end			
		end
		
		if USE_PORTRAIT then
			CLASSBAR_WIDTH = math.ceil((UNIT_WIDTH - (BORDER*2)) - PORTRAIT_WIDTH)
		end
		
		if USE_POWERBAR_OFFSET then
			CLASSBAR_WIDTH = CLASSBAR_WIDTH - POWERBAR_OFFSET
		end
	end
	
	health:ClearAllPoints()
	health:Point("TOPRIGHT", frame, "TOPRIGHT", -BORDER, -BORDER)
		if USE_POWERBAR_OFFSET then
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -(BORDER+POWERBAR_OFFSET), -BORDER)
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", BORDER, BORDER+POWERBAR_OFFSET)
		elseif USE_MINI_POWERBAR then
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", BORDER, BORDER + (POWERBAR_HEIGHT/2))
		else
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", BORDER, BORDER + POWERBAR_HEIGHT)
		end
	
	health.bg:ClearAllPoints()
		if not USE_PORTRAIT_OVERLAY then
			health:Point("TOPLEFT", PORTRAIT_WIDTH+BORDER, -BORDER)		
			health.bg:SetParent(health)
			health.bg:SetAllPoints()
		else
			health.bg:Point('BOTTOMLEFT', health:GetStatusBarTexture(), 'BOTTOMRIGHT')
			health.bg:Point('TOPRIGHT', health)		
			health.bg:SetParent(frame.Portrait.overlay)			
		end
	--End of needed copy.
	
	--Classbar positioning
	if USE_CLASSBAR then
		local DEPTH
		if USE_MINI_CLASSBAR then
			DEPTH = -(BORDER+(CLASSBAR_HEIGHT/2))
		else
			DEPTH = -(BORDER)
		end
		
		if USE_POWERBAR_OFFSET then
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -(BORDER+POWERBAR_OFFSET), DEPTH)
		else
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -BORDER, DEPTH)
		end
		
		health:Point("TOPLEFT", frame, "TOPLEFT", PORTRAIT_WIDTH+BORDER, DEPTH)
	end
	
	if USE_POWERBAR_OFFSET then
		CLASSBAR_WIDTH = CLASSBAR_WIDTH - POWERBAR_OFFSET
	end
	
	--Classbars	
	if E.myclass == "PALADIN" then
		local bars = frame.HolyPower
		bars:ClearAllPoints()
		
		local MAX_HOLY_POWER = 5
		
		if USE_MINI_CLASSBAR then
			CLASSBAR_WIDTH = CLASSBAR_WIDTH * (MAX_HOLY_POWER - 1) / MAX_HOLY_POWER
			bars:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*3 + 6), db.classbar.yOffset)
			bars:SetFrameStrata("MEDIUM")
		else
			bars:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER +SPACING)
			bars:SetFrameStrata("LOW")
		end
		bars:Width(CLASSBAR_WIDTH)
		bars:Height(CLASSBAR_HEIGHT - (BORDER*2))
	elseif E.myclass == 'PRIEST' then
		local bars = frame.ShadowOrbs
		bars:ClearAllPoints()
		if USE_MINI_CLASSBAR then
			CLASSBAR_WIDTH = CLASSBAR_WIDTH * (PRIEST_BAR_NUM_ORBS - 1) / PRIEST_BAR_NUM_ORBS
			bars:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*3 + 6), db.classbar.yOffset)
			bars:SetFrameStrata("MEDIUM")
		else
			bars:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER+SPACING)
			bars:SetFrameStrata("LOW")
		end
			
		bars:Width(CLASSBAR_WIDTH)
		bars:Height(CLASSBAR_HEIGHT - (BORDER*2))
			for i = 1, PRIEST_BAR_NUM_ORBS do
			bars[i]:SetHeight(bars:GetHeight())	
			bars[i]:SetWidth(E:Scale(bars:GetWidth() - 2)/PRIEST_BAR_NUM_ORBS)	
			bars[i]:GetStatusBarTexture():SetHorizTile(false)
			bars[i]:ClearAllPoints()
			if i == 1 then
				bars[i]:SetPoint("LEFT", bars)
			else
				if USE_MINI_CLASSBAR then
					bars[i]:Point("LEFT", bars[i-1], "RIGHT", SPACING+(BORDER*2)+8, 0)
				else
					bars[i]:Point("LEFT", bars[i-1], "RIGHT", SPACING, 0)
				end
			end
			
			if not USE_MINI_CLASSBAR then
				bars[i].backdrop:Hide()
			else
				bars[i].backdrop:Show()
			end
		end
		
		if not USE_MINI_CLASSBAR then
			bars.backdrop:Show()
		else
			bars.backdrop:Hide()			
		end		
		
		if USE_CLASSBAR and not frame:IsElementEnabled('ShadowOrbs') then
			frame:EnableElement('ShadowOrbs')
		elseif not USE_CLASSBAR and frame:IsElementEnabled('ShadowOrbs') then
			frame:DisableElement('ShadowOrbs')	
			bars:Hide()
		end	
	elseif E.myclass == 'MAGE' then
		local bars = frame.ArcaneChargeBar
		bars:ClearAllPoints()
		if USE_MINI_CLASSBAR then
			CLASSBAR_WIDTH = CLASSBAR_WIDTH * (UF['classMaxResourceBar'][E.myclass] - 1) / UF['classMaxResourceBar'][E.myclass]
			bars:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*4 + 10), db.classbar.yOffset)
			bars:SetFrameStrata("MEDIUM")
		else
			bars:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER+SPACING)
			bars:SetFrameStrata("LOW")
		end
			
		bars:Width(CLASSBAR_WIDTH)
		bars:Height(CLASSBAR_HEIGHT - (BORDER*2))
			for i = 1, UF['classMaxResourceBar'][E.myclass] do
			bars[i]:SetHeight(bars:GetHeight())	
			bars[i]:SetWidth(E:Scale(bars:GetWidth() - 2)/UF['classMaxResourceBar'][E.myclass])	
			bars[i]:GetStatusBarTexture():SetHorizTile(false)
			bars[i]:ClearAllPoints()
			if i == 1 then
				bars[i]:SetPoint("LEFT", bars)
			else
				if USE_MINI_CLASSBAR then
					bars[i]:Point("LEFT", bars[i-1], "RIGHT", SPACING+(BORDER*2)+2, 0)
				else
					bars[i]:Point("LEFT", bars[i-1], "RIGHT", SPACING, 0)
				end
			end
			
			if not USE_MINI_CLASSBAR then
				bars[i].backdrop:Hide()
			else
				bars[i].backdrop:Show()
			end
		end
		
		if not USE_MINI_CLASSBAR then
			bars.backdrop:Show()
		else
			bars.backdrop:Hide()			
		end		
			if USE_CLASSBAR and not frame:IsElementEnabled('ArcaneChargeBar') then
			frame:EnableElement('ArcaneChargeBar')
		elseif not USE_CLASSBAR and frame:IsElementEnabled('ArcaneChargeBar') then
			frame:DisableElement('ArcaneChargeBar')	
		end
	elseif E.myclass == "WARLOCK" then
		local bars = frame.ShardBar
		bars:ClearAllPoints()
		if USE_MINI_CLASSBAR then
			CLASSBAR_WIDTH = CLASSBAR_WIDTH * 2 / 3
			bars:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*3 + 6), db.classbar.yOffset -SPACING)
			bars:SetFrameStrata("MEDIUM")
		else
			bars:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER +SPACING)
			bars:SetFrameStrata("LOW")
		end
		bars:Width(CLASSBAR_WIDTH)
		bars:Height(CLASSBAR_HEIGHT - (BORDER*2))	
			if not USE_MINI_CLASSBAR then
			bars.backdrop:Show()
		else
			bars.backdrop:Hide()			
		end	
	elseif E.myclass == 'MONK' then
		local bars = frame.Harmony
		bars:ClearAllPoints()
		if USE_MINI_CLASSBAR then
			bars:Point("CENTER", frame.Health.backdrop, "TOP",db.classbar.xOffset -(BORDER*3 + 6), db.classbar.yOffset)
			bars:SetFrameStrata("MEDIUM")	
		else
			bars:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER+SPACING)
			bars:SetFrameStrata("LOW")
		end
		bars:Width(CLASSBAR_WIDTH)
		bars:Height(CLASSBAR_HEIGHT - (BORDER*2))
		
		if not USE_MINI_CLASSBAR then
			bars.backdrop:Show()
		else
			bars.backdrop:Hide()			
		end
		
		if USE_CLASSBAR and not frame:IsElementEnabled('Harmony') then
			frame:EnableElement('Harmony')
			bars:Show()
		elseif not USE_CLASSBAR and frame:IsElementEnabled('Harmony') then
			frame:DisableElement('Harmony')
			bars:Hide()
		end
	elseif E.myclass == "DEATHKNIGHT" then
		local runes = frame.Runes
		runes:ClearAllPoints()
		if USE_MINI_CLASSBAR then
			CLASSBAR_WIDTH = CLASSBAR_WIDTH * 4/5
			runes:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*3 + 8), db.classbar.yOffset -SPACING)
			runes:SetFrameStrata("MEDIUM")
		else
			runes:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER +SPACING)
			runes:SetFrameStrata("LOW")
		end
		runes:Width(CLASSBAR_WIDTH)
		runes:Height(CLASSBAR_HEIGHT - (BORDER*2))							
	elseif E.myclass == "DRUID" then
		local eclipseBar = frame.EclipseBar
			eclipseBar:ClearAllPoints()
		if not USE_MINI_CLASSBAR then
			eclipseBar:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER +SPACING)
			eclipseBar:SetFrameStrata("LOW")
		else		
			CLASSBAR_WIDTH = CLASSBAR_WIDTH * 3/2 --Multiply by reciprocal to reset previous setting
			CLASSBAR_WIDTH = CLASSBAR_WIDTH * 2/3
			eclipseBar:Point("LEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +(BORDER*2 + 4), db.classbar.yOffset)
			eclipseBar:SetFrameStrata("MEDIUM")						
		end
			eclipseBar:Width(CLASSBAR_WIDTH)
		eclipseBar:Height(CLASSBAR_HEIGHT - (BORDER*2))	
		--?? Apparent bug fix for the width after in-game settings change
		eclipseBar.LunarBar:SetMinMaxValues(0, 0)
		eclipseBar.SolarBar:SetMinMaxValues(0, 0)
		eclipseBar.LunarBar:Size(CLASSBAR_WIDTH, CLASSBAR_HEIGHT - (BORDER*2))			
		eclipseBar.SolarBar:Size(CLASSBAR_WIDTH, CLASSBAR_HEIGHT - (BORDER*2))					
	end

	frame:UpdateAllElements()
end

UF.UpdatePlayerFrameAnchorsSLE = UF.UpdatePlayerFrameAnchors
function UF:UpdatePlayerFrameAnchors(frame, isShown)
	UF:UpdatePlayerFrameAnchorsSLE(frame, isShown)
	
	if E.db.sle == nil then E.db.sle = {} end
	
	local db = E.db['unitframe']['units'].player
	local health = frame.Health
	local PORTRAIT_WIDTH = db.portrait.width
	local CLASSBAR_HEIGHT = db.classbar.height
	local USE_CLASSBAR = db.classbar.enable
	local USE_MINI_CLASSBAR = db.classbar.fill == "spaced" and USE_CLASSBAR
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT

	if E.db.unitframe.units.player.classbar.offset then
		local DEPTH
		if USE_MINI_CLASSBAR then
			DEPTH = -(E:Scale(2)+(CLASSBAR_HEIGHT/2))
		else
			DEPTH = -(E:Scale(2))
		end
		
		if not USE_MINI_CLASSBAR and (USE_PORTRAIT and not USE_PORTRAIT_OVERLAY) then
			health:Point("TOPLEFT", frame, "TOPLEFT", PORTRAIT_WIDTH + 2, DEPTH)
		end
	end

	if E.myclass == "DRUID" then
		UF:EclipseTextSLE()
	end
	
	if E.myclass == "WARLOCK" then
		UF:DFTextSLE()
	end
end

function UF:ClassbarTextSLE()
	if E.myclass == "DRUID" then
		UF:EclipseTextSLE()
	elseif E.myclass == "WARLOCK" then
		UF:DFTextSLE()
	end
end

function UF:EclipseTextSLE()
	local eclipseBar = ElvUF_Player.EclipseBar
	local spower = UnitPower( PlayerFrame.unit, SPELL_POWER_ECLIPSE );
	if E.db.sle.powtext then
		eclipseBar.powtext:SetText(spower)
	else
		eclipseBar.powtext:SetText('')
	end
end

function UF:DFTextSLE()
	local ShardBar = ElvUF_Player.ShardBar
	local dfpower = UnitPower( PlayerFrame.unit, SPELL_POWER_DEMONIC_FURY );
	local hasspec = GetSpecialization(false, false)
	if hasspec == nil then return end
	local index = select(1, GetSpecializationInfo(GetSpecialization(false, false, active)), false, false)
	if index == 266 then --This crap is checking the spec.
		if E.db.sle.powtext then
			ShardBar.powtext:SetText(dfpower)
			if E.db.unitframe.units.player.classbar.fill == "spaced" then
				ShardBar.powtext:ClearAllPoints()
				ShardBar.powtext:SetPoint("LEFT", ShardBar, "RIGHT")
			else
				ShardBar.powtext:ClearAllPoints()
				ShardBar.powtext:SetPoint("CENTER", ShardBar, "CENTER")
			end
		else
			ShardBar.powtext:SetText('')
		end
	else
		ShardBar.powtext:SetText('')
	end
end

--Text for druid eclipse bar
if E.myclass == "DRUID" then
	local eclipseBar = ElvUF_Player.EclipseBar
	local lunarBar = eclipseBar.LunarBar

	eclipseBar.powtext = lunarBar:CreateFontString(nil, 'OVERLAY')
	eclipseBar.powtext:SetPoint("CENTER", eclipseBar, "CENTER")
	eclipseBar.powtext:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
end

if E.myclass == "WARLOCK" then
	local ShardBar = ElvUF_Player.ShardBar
	local dfbar = select(2, ShardBar:GetChildren())
	
	ShardBar.powtext = dfbar:CreateFontString(nil, 'OVERLAY')
	ShardBar.powtext:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
end
UF:DefOffsetSetting()