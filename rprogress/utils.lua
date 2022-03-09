function clone(object)
    local lookup_table = {}
    local function copy(object) 
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[copy(key)] = copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return copy(object)
end

function MergeConfig(t1, t2)
    local copy = clone(t1)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(copy[k] or false) == "table" then
                MergeConfig(copy[k] or {}, t2[k] or {})
            else
                copy[k] = v
            end
        else
            copy[k] = v
        end
    end
    return copy
end

function PrintError(msg)
    -- ShowNotification("~r~RPROGRESS ERROR: ~w~" .. msg)

    msg = "======== RPROGRESS ERROR: " .. msg .. " ========"
    local s = string.rep("=", string.len(msg))
    print(s)
    print(msg)
    print(s)
end

function LoadAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)

        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(1)
        end
    end
end

function ShowNotification(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end