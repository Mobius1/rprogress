OnStart = nil
OnComplete = nil
Run = false
Animation = nil

------------------------------------------------------------
--                     MAIN FUNCTIONS                     --
------------------------------------------------------------

function Start(text, duration)
    if type(text) ~= "string" then
        PrintError("param 'text' must be type:string")
        return
    end

    if tonumber(duration) == nil then
        PrintError("param 'duration' must be type:number")
        return
    end
    
    local options = MergeConfig(Config, {
        display = true,
        Duration = duration,
        Label = text
    })

    options.Async = false
    options.MiniGame = false

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

    Animation = nil
    if options.Animation ~= nil then
        Animation = options.Animation
    end

    -- CAN'T SEND FUNCTIONS TO NUI
    options.onStart = nil
    options.onComplete = nil

    -- Static Progress
    if static == true then
        return options
    end

    if options.MiniGame then
        SetNuiFocus(true, true)
    end

    SendNUIMessage(options) 

    Run = true

    PlayAnimation(options)

    if options.Async == false then
        while Run do
            DisableControls(options)
            Citizen.Wait(1)
        end

        StopAnimation()
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

function Static(config)
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

function MiniGame(options)

    if Run then
        return
    end

    -- MERGE USER OPTIONS
    options = MergeConfig(Config.MiniGameOptions, options)
    
    if options.Zone == nil and options.Duration == nil then
        local difficulty = "Easy"

        if options.Difficulty ~= nil then
            difficulty = options.Difficulty
        end
    
        options.Zone = Config.MiniGameOptions.Difficulty[difficulty].Zone
        options.Duration = Config.MiniGameOptions.Difficulty[difficulty].Duration
    end
    
    options.Difficulty = nil
    options.MiniGame = true

    Custom(options)
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

-- Start the scenario / animation
function PlayAnimation()
    if Animation ~= nil then
        local player = PlayerPedId()
        if DoesEntityExist( player ) and not IsEntityDead( player ) then  
            Citizen.CreateThread(function()
                if Animation.scenario ~= nil then
                    TaskStartScenarioInPlace(player, Animation.scenario, 0, true)
                else
                    if Animation.animationDictionary ~= nil and Animation.animationName ~= nil then
                        
                        if Animation.flag == nil then
                            Animation.flag = 1
                        end

                        RequestAnimDict( Animation.animationDictionary )
                        TaskPlayAnim( player, Animation.animationDictionary, Animation.animationName, 3.0, 1.0, -1, Animation.flag, 0, 0, 0, 0 )
                    end
                end
            end)
        end
    end 
end

-- Stop the scenario / animation
function StopAnimation()
    if Animation ~= nil then
        local player = PlayerPedId()
        if DoesEntityExist( player ) and not IsEntityDead( player ) then
            if Animation.scenario ~= nil then
                ClearPedTasks(player)
            else
                if Animation.animationDictionary ~= nil and Animation.animationName ~= nil then
                    StopAnimTask(player, Animation.animationDictionary, Animation.animationName, 1.0)
                end
            end
        end
    end
end

function Reset()
    Run = false

    SetNuiFocus(false, false)    
end

Reset()

------------------------------------------------------------
--                     NUI CALLBACKS                      --
------------------------------------------------------------

RegisterNUICallback('progress_start', function(data)
    if OnStart ~= nil then
        OnStart()
    end
end)

RegisterNUICallback('progress_complete', function(data)
    Reset()

    if OnComplete ~= nil then
        OnComplete()
        StopAnimation()
    end
end)

RegisterNUICallback('progress_stop', function(data)
    Reset()

    StopAnimation()
end)

RegisterNUICallback('progress_minigame_input', function(data)
    if OnComplete ~= nil then
        OnComplete(data.success == true)
    end
end)

RegisterNUICallback('progress_minigame_complete', function(data)
    Reset()
end)


------------------------------------------------------------
--                         EVENTS                         --
------------------------------------------------------------

RegisterNetEvent("rprogress:start")
RegisterNetEvent("rprogress:stop")
RegisterNetEvent("rprogress:custom")
RegisterNetEvent("rprogress:minigame")

AddEventHandler("rprogress:start", Start)
AddEventHandler("rprogress:stop", Stop)
AddEventHandler("rprogress:custom", function(options)
    options.Async = false
    options.onStart = nil
    options.onComplete = nil

    Custom(options)
end)
AddEventHandler("rprogress:minigame", MiniGame)


------------------------------------------------------------
--                        EXPORTS                         --
------------------------------------------------------------

exports('Start', Start)
exports('Custom', Custom)
exports('Stop', Stop)
exports('Static', Static)
exports('MiniGame', MiniGame)