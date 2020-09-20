OnStart = nil
OnComplete = nil
Run = false

------------------------------------------------------------
--                     MAIN FUNCTIONS                     --
------------------------------------------------------------

function Start(duration, cb)
    if tonumber(duration) == nil then
        local msg = "======== rprogress ERROR: param 'duration' must be type:number ========"
        local s = string.rep("=", string.len(msg))
        print(s)
        print(msg)
        print(s)
    end

    local options = MergeConfig(Config, {
        display = true,
        Duration = duration
    })

    if cb ~= nil then
        if type(cb) == "function" then
            OnComplete = cb
        end
    else
        options.Async = false
    end

    -- CAN'T SEND FUNCTIONS TO NUI
    options.onStart = nil
    options.onComplete = nil    

    SendNUIMessage(options)

    if options.Async == false then
        Run = true
        while Run do
            Citizen.Wait(1)
        end
    end    
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

    if options.Async == false then
        Run = true
        while Run do
            Citizen.Wait(1)
        end
    end
end

function Stop()
    SendNUIMessage({
        stop = true
    })
end


------------------------------------------------------------
--                     NUI CALLBACKS                      --
------------------------------------------------------------

RegisterNUICallback('progress_start', function()
    if OnStart ~= nil then
        OnStart()
    end
end)
RegisterNUICallback('progress_complete', function()
    Run = false
    if OnComplete ~= nil then
        OnComplete()
    end
end)


------------------------------------------------------------
--                        EXPORTS                         --
------------------------------------------------------------

exports('Start', Start)
exports('Custom', Custom)
exports('Stop', Stop)


------------------------------------------------------------
--                          DEMO                          --
------------------------------------------------------------

TriggerEvent('chat:addSuggestion', '/rprogressStart', 'rprogress Async Demo', {
    { name="Duration (ms)", help="Duration of progress" }
})

TriggerEvent('chat:addSuggestion', '/rprogressSync', 'rprogress Sync Demo', {
    { name="Duration (ms)", help="Duration of progress" }
})

TriggerEvent('chat:addSuggestion', '/rprogressCustom', 'rprogress Custom Demo', {
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
        ShowNotification("~g~Event: onComplete")
    end) 
end)

RegisterCommand("rprogressSync", function(source, args, raw)
    ShowNotification("~b~Event: onStart")
    Start(tonumber(args[1]))
    ShowNotification("~g~Event: onComplete")
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
            ShowNotification("~b~Event: onStart")
        end,
        onComplete = function(data, cb)
            ShowNotification("~g~Event: onComplete")
        end
    }) 
end)

function ShowNotification(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end

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