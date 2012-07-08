local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

function S:EmbedSkada()
	local barSpacing = E:Scale(1)
	local borderWidth = E:Scale(2)
	local widthOffset = 4
	local numBars = 8
	
	for _, window in pairs(skadaWindows) do
		window.bargroup:SetParent(RightChatPanel)
	end
	if E.db.general.panelBackdrop == 'SHOWBOTH' or E.db.general.panelBackdrop == 'RIGHT' then
		if #skadaWindows == 1 then
			self:EmbedSkadaWindow(skadaWindows[1], E.db.general.panelWidth - widthOffset, E.db.general.panelHeight - 25, "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 3)
		elseif #skadaWindows == 2 then
			self:EmbedSkadaWindow(skadaWindows[1], ((E.db.general.panelWidth - widthOffset) / 2) - (borderWidth + E.mult) + 1, E.db.general.panelHeight - 25,  "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 3)
			self:EmbedSkadaWindow(skadaWindows[2], ((E.db.general.panelWidth - widthOffset) / 2) - (borderWidth + E.mult), E.db.general.panelHeight - 25,  "BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 2, 2)
		elseif #skadaWindows > 2 then
			self:EmbedSkadaWindow(skadaWindows[1], ((E.db.general.panelWidth - widthOffset) / 2) - (borderWidth + E.mult) + 1, E.db.general.panelHeight - 25,  "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 3)
			self:EmbedSkadaWindow(skadaWindows[2], ((E.db.general.panelWidth - widthOffset) / 2) - (borderWidth + E.mult), (E.db.general.panelHeight - 25) / 2 - 3,  "BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 2, 2)
			self:EmbedSkadaWindow(skadaWindows[3], skadaWindows[2].db.barwidth, (E.db.general.panelHeight - 25) / 2,  "BOTTOMLEFT", skadaWindows[2].bargroup.backdrop, "TOPLEFT", 2, 3)
		end	
	else
		if #skadaWindows == 1 then
			self:EmbedSkadaWindow(skadaWindows[1], E.db.general.panelWidth - widthOffset, E.db.general.panelHeight - 2, "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 3)
		elseif #skadaWindows == 2 then
			self:EmbedSkadaWindow(skadaWindows[1], ((E.db.general.panelWidth - widthOffset) / 2) - (borderWidth + E.mult) + 1, E.db.general.panelHeight - 2,  "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 3)
			self:EmbedSkadaWindow(skadaWindows[2], ((E.db.general.panelWidth - widthOffset) / 2) - (borderWidth + E.mult) + 1, E.db.general.panelHeight - 2,  "BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 2, 2)
		elseif #skadaWindows > 2 then
			self:EmbedSkadaWindow(skadaWindows[1], ((E.db.general.panelWidth - widthOffset) / 2) - (borderWidth + E.mult) + 1, E.db.general.panelHeight - 2,  "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 3)
			self:EmbedSkadaWindow(skadaWindows[2], ((E.db.general.panelWidth - widthOffset) / 2) - (borderWidth + E.mult), (E.db.general.panelHeight - 2) / 2 - 3,  "BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 2, 2)
			self:EmbedSkadaWindow(skadaWindows[3], skadaWindows[2].db.barwidth, (E.db.general.panelHeight - 2) / 2,  "BOTTOMLEFT", skadaWindows[2].bargroup.backdrop, "TOPLEFT", 2, 3)
		end	
	end
end

function S:SetEmbedRight(addon)
	self:RemovePrevious(addon)
	if not IsAddOnLoaded(addon) then return; end
	if self.lastAddon == nil then self.lastAddon = addon; end

	if addon == 'Recount' then
		Recount:LockWindows(true)
		
		Recount_MainWindow:ClearAllPoints()
		Recount_MainWindow:SetPoint("BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 0, 0)

		if E.db.general.panelBackdrop == 'SHOWBOTH' or E.db.general.panelBackdrop == 'RIGHT' then
			Recount_MainWindow:SetWidth(E.db.general.panelWidth)
			Recount_MainWindow:SetHeight(E.db.general.panelHeight - 14)
		else
			Recount_MainWindow:SetWidth(E.db.general.panelWidth)
			Recount_MainWindow:SetHeight(E.db.general.panelHeight + 9)		
		end		
		Recount_MainWindow:SetParent(RightChatPanel)	
		self.lastAddon = addon
	elseif addon == 'Omen' then
		Omen.db.profile.Locked = true
		Omen:UpdateGrips()
		if not Omen.oldUpdateGrips then
			Omen.oldUpdateGrips = Omen.UpdateGrips
		end
		Omen.UpdateGrips = function(...)
			local db = Omen.db.profile
			if S.db.embedRight == 'Omen' then
				Omen.VGrip1:ClearAllPoints()
				Omen.VGrip1:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", db.VGrip1, 0)
				Omen.VGrip1:SetPoint("BOTTOMLEFT", Omen.BarList, "BOTTOMLEFT", db.VGrip1, 0)
				Omen.VGrip2:ClearAllPoints()
				Omen.VGrip2:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", db.VGrip2, 0)
				Omen.VGrip2:SetPoint("BOTTOMLEFT", Omen.BarList, "BOTTOMLEFT", db.VGrip2, 0)
				Omen.Grip:Hide()
				if db.Locked then
					Omen.VGrip1:Hide()
					Omen.VGrip2:Hide()
				else
					Omen.VGrip1:Show()
					if db.Bar.ShowTPS then
						Omen.VGrip2:Show()
					else
						Omen.VGrip2:Hide()
					end
				end			
			else
				Omen.oldUpdateGrips(...)
			end
		end
		
		if not Omen.oldSetAnchors then
			Omen.oldSetAnchors = Omen.SetAnchors
		end
		Omen.SetAnchors = function(...)
			if S.db.embedRight == 'Omen' then return; end
			Omen.oldSetAnchors(...)
		end
		
		OmenAnchor:ClearAllPoints()
		OmenAnchor:SetPoint("BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 0, 0)
		
		if E.db.general.panelBackdrop == 'SHOWBOTH' or E.db.general.panelBackdrop == 'RIGHT' then
			OmenAnchor:SetWidth(E.db.general.panelWidth)
			OmenAnchor:SetHeight(E.db.general.panelHeight - 23)
		else
			OmenAnchor:SetWidth(E.db.general.panelWidth)
			OmenAnchor:SetHeight(E.db.general.panelHeight)		
		end
		
		OmenAnchor:SetParent(RightChatPanel)
		OmenAnchor:SetFrameStrata('LOW')
		if not OmenAnchor.SetFrameStrataOld then
			OmenAnchor.SetFrameStrataOld = OmenAnchor.SetFrameStrata
		end
		OmenAnchor.SetFrameStrata = E.noop
		
		local StartMoving = Omen.Title:GetScript('OnMouseDown')
		local StopMoving = Omen.Title:GetScript('OnMouseUp')
		Omen.Title:SetScript("OnMouseDown", function()
			if S.db.embedRight == 'Omen' then return end
			StartMoving()
		end)
		
		Omen.Title:SetScript("OnMouseUp", function()
			if S.db.embedRight == 'Omen' then return end
			StopMoving()
		end)	

		Omen.BarList:SetScript("OnMouseDown", function()
			if S.db.embedRight == 'Omen' then return end
			StartMoving()
		end)
		
		Omen.BarList:SetScript("OnMouseUp", function()
			if S.db.embedRight == 'Omen' then return end
			StopMoving()
		end)				
		
		self.lastAddon = addon
	elseif addon == 'Skada' then
		-- Update pre-existing displays
		table.wipe(skadaWindows)
		for _, window in ipairs(Skada:GetWindows()) do
			window:UpdateDisplay()
			tinsert(skadaWindows, window)
		end
	
		self:RemovePrevious(addon)

		function Skada:CreateWindow(name, db)
			Skada:CreateWindow_(name, db)
			
			table.wipe(skadaWindows)
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(skadaWindows, window)
			end	
			
			if S.db.embedRight == 'Skada' then
				S:EmbedSkada()
			end
		end
		
		function Skada:DeleteWindow(name)
			Skada:DeleteWindow_(name)
			
			table.wipe(skadaWindows)
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(skadaWindows, window)
			end	
			
			if S.db.embedRight == 'Skada' then
				S:EmbedSkada()
			end
		end
		
		self:EmbedSkada()
		self.lastAddon = addon
	end
end