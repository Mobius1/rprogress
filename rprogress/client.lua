OnStart = nil
OnComplete = nil
Run = false

------------------------------------------------------------
--                     MAIN FUNCTIONS                     --
------------------------------------------------------------

function Start(text, duration)
    if type(text) ~= "string" then
        local msg = "======== rprogress ERROR: param 'text' must be type:string ========"
        local s = string.rep("=", string.len(msg))
        print(s)
        print(msg)
        print(s)

        return
    end

    if tonumber(duration) == nil then
        local msg = "======== rprogress ERROR: param 'duration' must be type:number ========"
        local s = string.rep("=", string.len(msg))
        print(s)
        print(msg)
        print(s)

        return
    end
    
    local options = MergeConfig(Config, {
        display = true,
        Duration = duration,
        Label = text
    })

    options.Async = false

    -- CAN'T SEND FUNCTIONS TO NUI
    options.onStart = nil
    options.onComplete = nil 
    
    OnStart = nil
    OnComplete = nil

    SendNUIMessage(options)

    Run = true

    while Run do
        DisableControls(options)
        Citizen.Wait(1)
    end
end

function Custom(options, static) 
    -- ERROR HANDLING --
    if ErrorCheck(options) then
        return
    end
    
    local Controls = {
        Mouse = Config.DisableControls.Mouse,
        Player = Config.DisableControls.Player,
        Vehicle = Config.DisableControls.Vehicle,
    }

    if options.DisableControls ~= nil then
        Controls = options.DisableControls
    end

    -- MERGE USER OPTIONS
    options = MergeConfig(Config, options)

    options.DisableControls = MergeConfig(Config.DisableControls, Controls)

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

    Run = true

    if options.Async == false then
        while Run do
            DisableControls(options)
            Citizen.Wait(1)
        end
    else
        Citizen.CreateThread(function()
            while Run do
                DisableControls(options)
                Citizen.Wait(0)
            end
        end)
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
            options.progress = false
            SendNUIMessage(options)            
        end,
        SetProgress = function(progress)
            options.hide = false
            options.show = true
            options.progress = tonumber(progress)

            if options.progress < 0 then
                options.progress = 0
            elseif options.progress > 100 then
                options.progress = 100
            end

            SendNUIMessage(options)
        end,
        Hide = function()
            options.show = false
            options.hide = true
            options.progress = false
            SendNUIMessage(options)
        end,
        Destroy = function()
            options.show = false
            options.hide = false
            options.progress = false
            options.destroy = true
            SendNUIMessage(options)            
        end
    }
end

function DisableControls(options)
    if options.DisableControls.Mouse then
        DisableControlAction(1, 1, true)
        DisableControlAction(1, 2, true)
        DisableControlAction(1, 106, true)
    end
    
    if options.DisableControls.Player then
        DisableControlAction(0, 21, true)
        DisableControlAction(0, 30, true)
        DisableControlAction(0, 31, true)
        DisableControlAction(0, 36, true)
    end

    if options.DisableControls.Vehicle then
        DisableControlAction(0, 71, true)
        DisableControlAction(0, 72, true)
        DisableControlAction(0, 75, true)
    end    
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