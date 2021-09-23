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

function ErrorCheck(options)

    if type(options) ~= "table" then
        PrintError("options must be type:table")
        return true
    end

    for k, v in pairs(options) do
        local error = false
        if k ~= "onStart" and k ~= "onComplete" and k ~= "onTimeout" then
            if k == "ShowTimer" or k == "ShowProgress" or k == "Async" or k == "MiniGame" or k == "Loop" or k == "canCancel" then
                if type(v) ~= "boolean" then
                    error = { prop = k, type = "boolean" }
                end
            elseif k == "Label" or k == "Color" or k == "BGColor" or k == "LabelPosition" or k == "Easing" or k == "Cap" or k == "Type" then
                if type(v) ~= "string" then
                    error = { prop = k, type = "string" }
                end
            elseif k == "DisableControls" then
                for m, n in pairs(v) do
                    if type(n) ~= "boolean" then
                        error = { prop = k .. "." .. m, type = "boolean" }
                    end
                end
            elseif k == "Animation" then
                for m, n in pairs(v) do
                    if m == "flag" then
                        if tonumber(n) == nil then
                            error = { prop = k, type = "number" }
                        end
                    else
                        if type(n) ~= "string" then
                            error = { prop = k .. "." .. m, type = "string" }
                        end
                    end
                end                
            else
                if tonumber(v) == nil then
                    error = { prop = k, type = "number" }
                end
            end
    
            if error ~= false then
                PrintError("param '" .. error.prop .. "' must be type:" .. error.type)
                            
                return true
            end            
        end
    end
    
    return false
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