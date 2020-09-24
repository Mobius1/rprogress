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
                    error = { prop = k, type = "boolean" }
                end
            elseif k == "Label" or k == "Color" or k == "BGColor" or k == "LabelPosition" then
                if type(v) ~= "string" then
                    error = { prop = k, type = "string" }
                end
            elseif k == "DisableControls" then
                for m, n in pairs(v) do
                    if type(n) ~= "boolean" then
                        error = { prop = k .. "." .. m, type = "boolean" }
                    end
                end
            else
                if tonumber(v) == nil then
                    error = { prop = k, type = "number" }
                end
            end
    
            if error ~= false then
                local msg = "======== rprogress ERROR: param '" .. error.prop .. "' must be type:" .. error.type .. " ========"
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