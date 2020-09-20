function ShowNotification(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end

function DeepCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            v = DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

function MergeConfig(t1, t2)
    local copy = DeepCopy(t1)
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
        print("==================================================================")
        print("======== rprogress ERROR: options must be type:table ========")
        print("==================================================================")
        return true
    end

    for k, v in pairs(options) do
        local error = false
        if k ~= "onStart" and k ~= "onComplete" then
            if k == "ShowTimer" or k == "ShowProgress" or k == "Async" then
                if type(v) ~= "boolean" then
                    error = "boolean"
                end
            elseif k == "Position" then
                if type(v) ~= "table" then
                    error = "table"
                end
            elseif k == "Label" or k == "Color" or k == "BGColor" then
                if type(v) ~= "string" then
                    error = "string"
                end
            else
                if tonumber(v) == nil then
                    error = "number"
                end
            end
    
            if error then
                local msg = "======== rprogress ERROR: param '" .. k .. "' must be type:" .. error .. " ========"
                local s = string.rep("=", string.len(msg))
                print(s)
                print(msg)
                print(s)
                            
                return true
            end            
        end
    end
    
    return false
end