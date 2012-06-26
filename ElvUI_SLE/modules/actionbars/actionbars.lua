local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local AB = E:GetModule('ActionBars');

function AB:UpdatePet()
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton"..i;
		local button = _G[buttonName];
		local icon = _G[buttonName.."Icon"];
		local autoCast = _G[buttonName.."AutoCastable"];
		local shine = _G[buttonName.."Shine"];	
		local checked = button:GetCheckedTexture();
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);

		if not isToken then
			icon:SetTexture(texture);
			button.tooltipName = name;
		else
			icon:SetTexture(_G[texture]);
			button.tooltipName = _G[name];
		end		
		
		button.isToken = isToken;
		button.tooltipSubtext = subtext;	
		
		if isActive and name ~= "PET_ACTION_FOLLOW" then
			button:SetChecked(1);
			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(button);
			end
		else
			button:SetChecked(0);
			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(button);
			end			
		end		
		
		--DPE. Enable/disable autocast square around buttons
		if E.db.dpe.petbar.autocast then
			if autoCastAllowed then
				autoCast:Show();
			else
				autoCast:Hide();
			end	
		else
			autoCast:Hide();
		end
		
		if autoCastEnabled then
			AutoCastShine_AutoCastStart(shine);
		else
			AutoCastShine_AutoCastStop(shine);
		end		
		
		button:SetAlpha(1);
		
		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(icon, nil);
			else
				SetDesaturation(icon, 1);
			end
			icon:Show();
		else
			icon:Hide();
		end		
		
		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			PetActionButton_StopFlash(button);
			SetDesaturation(icon, 1);
			button:SetChecked(0);
		end		
		
		checked:SetAlpha(0.3);
	end
end
