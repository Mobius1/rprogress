OnStart = nil
OnComplete = nil

function Start(duration, cb)
    if tonumber(duration) == nil then
        local msg = "======== rprogress ERROR: param 'duration' must be type:number ========"
        local s = string.rep("=", string.len(msg))
        print(s)
        print(msg)
        print(s)
    end

    if cb ~= nil then
        OnComplete = cb
    end

    local options = MergeConfig(Config, {
        display = true,
        Duration = duration
    })

    -- CAN'T SEND FUNCTIONS TO NUI
    options.onStart = nil
    options.onComplete = nil    

    SendNUIMessage(options)
end

function Custom(options) 
    -- ERROR HANDLING --
    if ErrorCheck(options) then
        return
    end

    -- MERGE USER OPTIONS
    options = MergeConfig(Config, options)

    options.display = true

    if options.ShowProgress == true then
        options.ShowTimer = false
    end

    OnStart = options.onStart
    OnComplete = options.onComplete

    -- CAN'T SEND FUNCTIONS TO NUI
    options.onStart = nil
    options.onComplete = nil

    SendNUIMessage(options) 
end

RegisterNUICallback('progress_start', function()
    if OnStart ~= nil then
        OnStart()
    end
end)
RegisterNUICallback('progress_complete', function()
    if OnComplete ~= nil then
        OnComplete()
    end
end)

function Stop()
    SendNUIMessage({
        stop = true
    })
end

exports('Start', Start)
exports('Custom', Custom)
exports('Stop', Stop)

-- DEMO --
TriggerEvent('chat:addSuggestion', '/rprogressStart', 'rprogress Demo', {
    { name="Duration (ms)", help="Duration of progress" }
})

TriggerEvent('chat:addSuggestion', '/rprogressCustom', 'rprogress Demo', {
    { name="From (0-100)", help="Percentage to start from" },
    { name="To (0-100)", help="Percentage to stop at" },
    { name="Duration (ms)", help="Duration of progress" },
    { name="Radius (px)", help="Radius of the dial" },
    { name="Stroke (px)", help="Stroke width of bar" },
    { name="MaxAngle (deg)", help="Maximum arc of dial" },
    { name="Rotation (deg)", help="Rotation angle of dial" },
})

RegisterCommand("rprogressStart", function(source, args, raw)
    Start(tonumber(args[1]), function(data, cb)
        exports.FeedM:ShowNotification("~g~Event: onComplete")
    end) 
end)

RegisterCommand("rprogressCustom", function(source, args, raw)
    Custom({
        From = tonumber(args[1]),
        To = tonumber(args[2]),
        Duration = tonumber(args[3]),
        Radius = tonumber(args[4]) or Config.Radius,
        Stroke = tonumber(args[5]) or Config.Stroke,
        MaxAngle = tonumber(args[6]) or Config.MaxAngle,
        Rotation = tonumber(args[7]) or Config.Rotation,
        onStart = function(data, cb)
            exports.FeedM:ShowNotification("~b~Event: onStart")
        end,
        onComplete = function(data, cb)
            exports.FeedM:ShowNotification("~g~Event: onComplete")
        end
    }) 
end)

function MergeConfig(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                MergeConfig(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
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
            if k == "ShowTimer" or k == "ShowProgress" then
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