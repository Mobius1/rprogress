OnStart = nil
OnComplete = nil
Run = false

------------------------------------------------------------
--                     MAIN FUNCTIONS                     --
------------------------------------------------------------

function Start(text, duration, cb)
    if type(text) ~= "string" then
        local msg = "======== rprogress ERROR: param 'text' must be type:string ========"
        local s = string.rep("=", string.len(msg))
        print(s)
        print(msg)
        print(s)
    end

    if tonumber(duration) == nil then
        local msg = "======== rprogress ERROR: param 'duration' must be type:number ========"
        local s = string.rep("=", string.len(msg))
        print(s)
        print(msg)
        print(s)
    end
    

    local options = MergeConfig(Config, {
        display = true,
        Duration = duration,
        Label = text
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

function Custom(options, static) 
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

    -- Static Progress
    if static == true then
        return options
    end

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

function NewStaticProgress(config)
    local options = Custom(config, true)

    options.display = false
    options.static = true

    SendNUIMessage(options)

    return {
        Show = function()
            options.hide = false
            options.show = true
            SendNUIMessage(options)            
        end,
        SetProgress = function(progress)
            options.hide = false
            options.show = true
            options.progress = tonumber(progress)

            if options.progress > 100 then
                options.progress = 100
            end

            SendNUIMessage(options)
        end,
        Hide = function()
            options.show = false
            options.hide = true
            SendNUIMessage(options)
        end,
        Destroy = function()
            options.show = false
            options.hide = false
            options.destroy = true
            SendNUIMessage(options)            
        end
    }
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

RegisterNUICallback('progress_stop', function()
    Run = false
end)

------------------------------------------------------------
--                         EVENTS                         --
------------------------------------------------------------

RegisterNetEvent("rprogress:start")
RegisterNetEvent("rprogress:stop")
RegisterNetEvent("rprogress:custom")

AddEventHandler("rprogress:start", Start)
AddEventHandler("rprogress:stop", Stop)
AddEventHandler("rprogress:custom", function(options)
    options.Async = false
    options.onStart = nil
    options.onComplete = nil

    Custom(options)
end)


------------------------------------------------------------
--                        EXPORTS                         --
------------------------------------------------------------

exports('Start', Start)
exports('Custom', Custom)
exports('Stop', Stop)
exports('NewStaticProgress', NewStaticProgress)