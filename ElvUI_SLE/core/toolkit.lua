local E, L, V, P, G, _ = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local BG = E:GetModule('SLE_BackGrounds')
local DTP = E:GetModule('SLE_DTPanels')
local CH = E:GetModule("Chat")
local UB = E:GetModule('SLE_UIButtons')
local RM = E:GetModule('SLE_RaidMarks')
local RF = E:GetModule('SLE_RaidFlares')
local F = E:GetModule('SLE_Farm')
local LT = E:GetModule('SLE_Loot')
local UF = E:GetModule('UnitFrames')

local GetContainerNumSlots, GetContainerItemID = GetContainerNumSlots, GetContainerItemID

--The list of authorized toons
local Authors = {
	["Illidan"] = {
		--Darth's toon
		["Darthpred"] = "SLEAUTHOR",
		--Repooc's Toon
		["Repooc"] = "SLEAUTHOR",
		["Repooc"] = "SLEAUTHOR"
	},
	["ВечнаяПесня"] = {
		--Darth's toons
		["Дартпредатор"] = "SLEAUTHOR",
		["Алея"] = "SLEAUTHOR",
		["Ваззули"] = "SLEAUTHOR",
		["Сиаранна"] = "SLEAUTHOR",
		["Джатон"] = "SLEAUTHOR",
		["Фикстер"] = "SLEAUTHOR",
		["Киландра"] = "SLEAUTHOR",
		["Нарджо"] = "SLEAUTHOR",
		["Келинира"] = "SLEAUTHOR",
		["Крениг"] = "SLEAUTHOR",
		["Мейжи"] = "SLEAUTHOR"
	},
	["Korialstrasz"] = {
		["Cursewordz"] = "SLEAUTHOR"
	},
	["Spirestone"] = {
		["Sifupooc"] = "SLEAUTHOR",
		["Dapooc"] = "SLEAUTHOR",
		["Lapooc"] = "SLEAUTHOR",
		["Warpooc"] = "SLEAUTHOR",
		["Repooc"] = "SLEAUTHOR"
	},
	["Andorhal"] = {
		["Dapooc"] = "SLEAUTHOR",
		["Rovert"] = "SLEAUTHOR",
		["Sliceoflife"] = "SLEAUTHOR"
	},
	["WyrmrestAccord"] = {
		["Kitalie"] = "SLEAUTHOR",
		["Sagome"] = "SLEAUTHOR",
		["Ainy"] = "SLEAUTHOR",
		["Norinael"] = "SLEAUTHOR",
		["Tritalie"] = "SLEAUTHOR",
		["Myun"] = "SLEAUTHOR",
		["Nevaleigh"] = "SLEAUTHOR",
		["Celenii"] = "SLEAUTHOR",
		["Varysa"] = "SLEAUTHOR",
		["Caylasena"] = "SLEAUTHOR",
		["Arillora"] = "SLEAUTHOR",
		["Dapooc"] = "SLEAUTHOR",
	},
	["Anasterian(US)"] = {
		["Dapooc"] = "SLEAUTHOR",
	},
	["Brill(EU)"] = {
		["Дартпредатор"] = "SLEAUTHOR",
	},
}

function SLE:Auth(sender)
	local senderName, senderRealm

	if sender then
		senderName, senderRealm = string.split('-', sender)
	else
		senderName = E.myname
	end

	senderRealm = senderRealm or E.myrealm
	senderRealm = senderRealm:gsub(' ', '')

	if Authors[senderRealm] and Authors[senderRealm][senderName] then
		return Authors[senderRealm][senderName]
	end
	
	return false
end

function SLE:BagSearch(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

function SLE:ValueTable(table, item)
	for i, _ in pairs(table) do
		if i == item then return true end
	end
	return false
end

function SLE:SimpleTable(table, item)
	for i = 1, #table do
		if table[i] == item then  
			return true 
		end
	end
	return false
end

function SLE:Print(msg)
	print(E["media"].hexvaluecolor..'S&L:|r', msg)
end

E.UpdateAllSLE = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllSLE(self)
	BG:UpdateFrames()
	BG:RegisterHide()
	DTP:Update()
	DTP:DashboardShow()
	DTP:DashWidth()
	if E.private.unitframe.enable then
		UF:Update_CombatIndicator()
	end
	LT:LootShow()
	UB:UpdateAll()
	RM:Update()
	RF:Update()
	F:UpdateLayout()
	CH:GMIconUpdate()
end