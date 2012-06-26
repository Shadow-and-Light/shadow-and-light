local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");

--The solution for the "default seting launch" problem when no value can be read from profile table.
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
local CAN_HAVE_CLASSBAR = (E.myclass == "PALADIN" or E.myclass == "SHAMAN" or E.myclass == "DRUID" or E.myclass == "DEATHKNIGHT" or E.myclass == "WARLOCK")

--Function to move damn combat indicator to topright part of the frame. Maybe i should create an option to make it placeble everywhere.
function UF:Update_CombatIndicator()
	local CombatText = ElvUF_Player.Combat
	
	local x, y = self:GetPositionOffset(E.db.dpe.combatico.pos)
	CombatText:ClearAllPoints()
	CombatText:Point(E.db.dpe.combatico.pos, ElvUF_Player.Health, E.db.dpe.combatico.pos, x, x)
end

UF.Update_PlayerFrameDPE = UF.Update_PlayerFrame
function UF:Update_PlayerFrame(frame, db)
	UF:Update_PlayerFrameDPE(frame, db)
	
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
	if db.power.text then
		power.value:Show()
		
		local x, y = self:GetPositionOffset(db.power.position)
		power.value:ClearAllPoints()
		power.value:Point(db.power.position, frame.Power, db.power.position, x, y)			
	else
		power.value:Hide()
	end
	
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
			
			if USE_POWERBAR_OFFSET then
				CLASSBAR_WIDTH = CLASSBAR_WIDTH - POWERBAR_OFFSET
			end
		end
		
		if USE_POWERBAR_OFFSET then
			CLASSBAR_WIDTH = CLASSBAR_WIDTH - POWERBAR_OFFSET
		end

		if USE_MINI_CLASSBAR then
			CLASSBAR_WIDTH = CLASSBAR_WIDTH*2/3
		end	
		
		if USE_MINI_POWERBAR then
			POWERBAR_WIDTH = POWERBAR_WIDTH / 2
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
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -BORDER, 0)
		end
		
		health:Point("TOPLEFT", frame, "TOPLEFT", PORTRAIT_WIDTH+BORDER, DEPTH)
	end
	
	--Classbars	
	if E.myclass == "PALADIN" then
			local bars = frame.HolyPower
			bars:ClearAllPoints()
			if USE_MINI_CLASSBAR then
				bars:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*3 + 6), db.classbar.yOffset -SPACING)
				bars:SetFrameStrata("MEDIUM")
			else
				bars:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER +SPACING)
				bars:SetFrameStrata("LOW")
			end
			bars:Width(CLASSBAR_WIDTH)
			bars:Height(CLASSBAR_HEIGHT - (BORDER*2))
		elseif E.myclass == "WARLOCK" then
			local bars = frame.SoulShards
			bars:ClearAllPoints()
			if USE_MINI_CLASSBAR then
				bars:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*3 + 6), db.classbar.yOffset -SPACING)
				bars:SetFrameStrata("MEDIUM")
			else
				bars:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER +SPACING)
				bars:SetFrameStrata("LOW")
			end
			bars:Width(CLASSBAR_WIDTH)
			bars:Height(CLASSBAR_HEIGHT - (BORDER*2))			
		elseif E.myclass == "DEATHKNIGHT" then
			local runes = frame.Runes
			runes:ClearAllPoints()
			if USE_MINI_CLASSBAR then
				CLASSBAR_WIDTH = CLASSBAR_WIDTH * 3/2 --Multiply by reciprocal to reset previous setting
				CLASSBAR_WIDTH = CLASSBAR_WIDTH * 4/5
				runes:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*3 + 8), db.classbar.yOffset -SPACING)
				runes:SetFrameStrata("MEDIUM")
			else
				runes:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER +SPACING)
				runes:SetFrameStrata("LOW")
			end
			runes:Width(CLASSBAR_WIDTH)
			runes:Height(CLASSBAR_HEIGHT - (BORDER*2))							
		elseif E.myclass == "SHAMAN" then
			local totems = frame.TotemBar
			
			totems:ClearAllPoints()
			if not USE_MINI_CLASSBAR then
				totems:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", db.classbar.xOffset +BORDER, db.classbar.yOffset +BORDER +SPACING)
				totems:SetFrameStrata("LOW")
			else
				CLASSBAR_WIDTH = CLASSBAR_WIDTH * 3/2 --Multiply by reciprocal to reset previous setting
				CLASSBAR_WIDTH = CLASSBAR_WIDTH * 4/5
				totems:Point("CENTER", frame.Health.backdrop, "TOP", db.classbar.xOffset -(BORDER*3 + 6), db.classbar.yOffset -SPACING)
				totems:SetFrameStrata("MEDIUM")			
			end
			
			totems:Width(CLASSBAR_WIDTH)
			totems:Height(CLASSBAR_HEIGHT - (BORDER*2))				
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


UF:DefOffsetSetting()