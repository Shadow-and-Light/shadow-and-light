local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local RC = LibStub("LibRangeCheck-2.0")
local ElvUF = ElvUI.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

local strsplit, format, gsub = strsplit, format, gsub
local UnitGetTotalAbsorbs, UnitName = UnitGetTotalAbsorbs, UnitName
local UnitIsPVP, UnitHonorLevel = UnitIsPVP, UnitHonorLevel
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitPower = UnitPower
local SPELL_POWER_MANA = Enum.PowerType.Mana

do
    local function rangecolor(hex)
        if hex and strmatch(hex, '^%x%x%x%x%x%x$') then
            return '|cFF'..hex
        end

        return "|cFFffff00" --fall back to yellow
    end

    ElvUF.Tags.OnUpdateThrottle['range:sl'] = 0.25
    ElvUF.Tags.Methods['range:sl'] = function(unit, _, args)
        local name, server = UnitName(unit)
        local min, max = RC:GetRange(unit)
        local closerange, shortrange, midrange, longrange, outofrange = strsplit(':', args or '')
        if closerange == "" then closerange = nil end
        local rangeText
        local rcolor

        if(server and server ~= "") then
            name = format("%s-%s", name, server)
        end

        if min then
            if min >= 100 then max = nil end
            if max then
                if max <= 5 then
                    rcolor = closerange and rangecolor(closerange) or "|cFFffffff" --white
                elseif max <= 20 then
                    rcolor = shortrange and rangecolor(shortrange) or "|cFF00ff00" --green
                elseif max <= 30 then
                    rcolor = midrange and rangecolor(midrange) or "|cFFffff00" --yellow
                elseif max <= 35 then
                    rcolor = longrange and rangecolor(longrange) or "|cFFff9900" --orange
                elseif min >= 40 then
                    rcolor = outofrange and rangecolor(outofrange) or "|cFFff0000" --red
                else
                    rcolor = "|cFFffff00" --yellow
                end
            end
        end

        if min and max and (name ~= UnitName('player')) then
            rangeText = strjoin("", min, "-", max)
        end

        if rcolor and rangeText then
            rangeText = rcolor..rangeText
        end

        return rangeText or nil
    end
end

ElvUF.Tags.Events['absorbs:sl-short'] = 'UNIT_ABSORB_AMOUNT_CHANGED'
ElvUF.Tags.Methods['absorbs:sl-short'] = function(unit)
    local absorb = UnitGetTotalAbsorbs(unit) or 0
    if absorb == 0 then
        return 0
    else
        return E:ShortValue(absorb)
    end
end

ElvUF.Tags.Events['absorbs:sl-full'] = 'UNIT_ABSORB_AMOUNT_CHANGED'
ElvUF.Tags.Methods['absorbs:sl-full'] = function(unit)
    local absorb = UnitGetTotalAbsorbs(unit) or 0
    if absorb == 0 then
        return 0
    else
        return absorb
    end
end

ElvUF.Tags.OnUpdateThrottle['sl:pvptimer'] = 1
ElvUF.Tags.Methods['sl:pvptimer'] = function(unit)
    if (UnitIsPVPFreeForAll(unit) or UnitIsPVP(unit)) then
        local timer = GetPVPTimer()

        if timer ~= 301000 and timer ~= -1 then
            local mins = floor((timer / 1000) / 60)
            local secs = floor((timer / 1000) - (mins * 60))
            return ("%01.f:%02.f"):format(mins, secs)
        else
            return "PvP"
        end
    else
        return nil
    end
end

ElvUF.Tags.Events['sl:pvplevel'] = 'HONOR_LEVEL_UPDATE UNIT_FACTION'
ElvUF.Tags.Methods['sl:pvplevel'] = function(unit)
    -- if unit ~= "target" and unit ~= "player" then return "" end
    return (UnitIsPVP(unit) and UnitHonorLevel(unit) > 0) and UnitHonorLevel(unit) or ""
end

for textFormat in pairs(E.GetFormattedTextStyles) do
    local tagTextFormat = strlower(gsub(textFormat, '_', '-'))
    ElvUF.Tags.Events[format('mana:%s:healeronly', tagTextFormat)] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER GROUP_ROSTER_UPDATE'
    ElvUF.Tags.Methods[format('mana:%s:healeronly', tagTextFormat)] = function(unit)
        local role = UnitGroupRolesAssigned(unit)
        if role ~= "HEALER" then return end

        local min = UnitPower(unit, SPELL_POWER_MANA)
        if min ~= 0 and tagTextFormat ~= 'deficit' then
            return E:GetFormattedText(textFormat, min, UnitPowerMax(unit, SPELL_POWER_MANA))
        end
    end
end

--*Add the tags to the ElvUI Options
E:AddTagInfo('sl:pvptimer', 'S&L', L["SLE_Tag_sl-pvptimer"])
E:AddTagInfo('sl:pvplevel', 'S&L', L["SLE_Tag_sl-pvplevel"])
E:AddTagInfo('absorbs:sl-short', 'S&L', L["SLE_Tag_absorb-sl-short"])
E:AddTagInfo('absorbs:sl-full', 'S&L', L["SLE_Tag_absorb-sl-full"])
E:AddTagInfo('range:sl', 'S&L', L["SLE_Tag_range-sl"])