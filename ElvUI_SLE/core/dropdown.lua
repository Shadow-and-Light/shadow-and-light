local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DD = SLE:NewModule("Dropdowns", "AceEvent-3.0")

DD.RegisteredMenus = {}

--Cache global variables
local tinsert = tinsert
--WoW API / Variables
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local GetCursorPosition = GetCursorPosition

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, UISpecialFrames,

local PADDING = 10
local BUTTON_HEIGHT = 16
local BUTTON_WIDTH = 135
local TITLE_OFFSET = 10

local function OnClick(btn)
	if btn.func then btn.func() end

	btn:GetParent():Hide()
end

local function OnEnter(btn)
	btn.hoverTex:Show()
end

local function OnLeave(btn)
	btn.hoverTex:Hide()
end

function SLE:DropDown(list, frame, MenuAnchor, FramePoint, xOffset, yOffset, parent, customWidth, justify)
	if T.InCombatLockdown() then return end
	if not frame:IsShown() then
		if not frame.buttons then
			frame.buttons = {}
			frame:SetFrameStrata("DIALOG")
			frame:SetClampedToScreen(true)
			T.tinsert(UISpecialFrames, frame:GetName())
			frame:Hide()
		end

		xOffset = xOffset or 0
		yOffset = yOffset or 0
		local TitleCount = 0
		local AddOffset = 0

		for i=1, #frame.buttons do
			frame.buttons[i]:Hide()
		end
		if not parent then FramePoint = "CURSOR" end

		for i=1, #list do
			if not frame.buttons[i] then
				if list[i].secure then
					frame.buttons[i] = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")
				else
					frame.buttons[i] = CreateFrame("Button", nil, frame)
				end

				frame.buttons[i].hoverTex = frame.buttons[i]:CreateTexture(nil, 'OVERLAY')
				frame.buttons[i].hoverTex:SetAllPoints()
				frame.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
				frame.buttons[i].hoverTex:SetBlendMode("ADD")
				frame.buttons[i].hoverTex:Hide()

				frame.buttons[i].text = frame.buttons[i]:CreateFontString(nil, 'BORDER')
				frame.buttons[i].text:SetAllPoints()
				frame.buttons[i].text:FontTemplate()

				if not list[i].nohighlight then
					frame.buttons[i]:SetScript("OnEnter", OnEnter)
					frame.buttons[i]:SetScript("OnLeave", OnLeave)
				end

				if list[i].func then
					frame.buttons[i].func = list[i].func
				end
			end
			frame.buttons[i].text:SetJustifyH(justify or "LEFT")
			frame.buttons[i]:Show()
			frame.buttons[i]:Height(BUTTON_HEIGHT)
			frame.buttons[i]:Width(customWidth or BUTTON_WIDTH)
			local icon = ""
			if list[i].icon then
				icon = "|T"..list[i].icon..":14:14|t "
			end
			frame.buttons[i].text:SetText(icon..list[i].text)
			if list[i].title then
				TitleCount = TitleCount + 1
				frame.buttons[i].text:SetTextColor(0.98, 0.95, 0.05)
				if list[i].ending or i == 1 or list[i-1].title then
					AddOffset = AddOffset + 1
				end
			else
				frame.buttons[i].text:SetTextColor(1, 1, 1)
			end
			if list[i].secure then
				frame.buttons[i].secure = list[i].secure
				frame.buttons[i]:SetAttribute("type", frame.buttons[i].secure.buttonType)
				if frame.buttons[i].secure.buttonType == "item" then
					local name = T.GetItemInfo(frame.buttons[i].secure.ID)
					frame.buttons[i]:SetAttribute("item", name)
				elseif frame.buttons[i].secure.buttonType == "spell" then
					local name = T.GetSpellInfo(frame.buttons[i].secure.ID)
					frame.buttons[i]:SetAttribute("spell", name)
				elseif frame.buttons[i].secure.buttonType == "macro" then
					frame.buttons[i]:SetAttribute("macrotext", frame.buttons[i].secure.ID)
				else
					SLE:Print("Wrong argument for button type: "..frame.buttons[i].secure.buttonType)
				end
				frame.buttons[i]:HookScript("OnClick", OnClick)
			else
				frame.buttons[i]:SetScript("OnClick", OnClick)
			end
			
			local MARGIN = 10
			if justify then
				if justify == "RIGHT" then MARGIN = -10 end
				if justify == "CENTER" then MARGIN = 0 end
			end

			if i == 1 then
				frame.buttons[i]:Point("TOPLEFT", frame, "TOPLEFT", MARGIN, -PADDING)
			else
				frame.buttons[i]:Point("TOPLEFT", frame.buttons[i-1], "BOTTOMLEFT", 0, -((list[i-1].title or list[i].title) and TITLE_OFFSET or 0))
			end
		end

		frame:Height((#list * BUTTON_HEIGHT) + PADDING * 2 + TitleCount * (2 * TITLE_OFFSET) - AddOffset * TITLE_OFFSET)
		frame:Width(customWidth or (BUTTON_WIDTH + PADDING * 2))

		frame:ClearAllPoints()
		if FramePoint == "CURSOR" then
			local UIScale = UIParent:GetScale();
			local x, y = GetCursorPosition();
			x = x/UIScale
			y = y/UIScale
			frame:Point(MenuAnchor, UIParent, "BOTTOMLEFT", x + xOffset, y + yOffset)
		else
			frame:Point(MenuAnchor, parent, FramePoint, xOffset, yOffset)
		end
	end
	ToggleFrame(frame)
end

function DD:GetCooldown(CDtype, id)
	local cd, formatID
	local start, duration = T["Get"..CDtype.."Cooldown"](id)
	if start > 0 then
		cd = duration - (T.GetTime() - start)
		cd, formatID = E:GetTimeInfo(cd, 0)
		cd = T.format(E.TimeFormats[formatID][2], cd)
		return cd
	end
	return nil
end

function DD:HideMenus()
	for name, menu in T.pairs(DD.RegisteredMenus) do
		menu:Hide()
	end
end

function DD:RegisterMenu(menu)
	local name = menu:GetName()
	if name then
		DD.RegisteredMenus[name] = menu
	else
		SLE:Print("Dropdown not registered. Please chack if it has a name.")
	end
end

function DD:Initialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "HideMenus")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "HideMenus")
end

SLE:RegisterModule(DD:GetName())