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

    Custom(options)
end)


------------------------------------------------------------
--                        EXPORTS                         --
------------------------------------------------------------

exports('Start', Start)
exports('Custom', Custom)
exports('Stop', Stop)