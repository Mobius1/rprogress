--------------------------------------
-- DELETE THIS FILE IF NOT REQUIRED --
--------------------------------------

TriggerEvent('chat:addSuggestion', '/rprogressStart', 'rprogress Start Demo', {
    { name="Label", help="The label to show" },
    { name="Duration", help="Duration in ms" }
})

TriggerEvent('chat:addSuggestion', '/rprogressMiniGame', 'rprogress MiniGame Demo', {
    { name="Difficulty", help="Easy, Medium, Hard or Custom" }
})

TriggerEvent('chat:addSuggestion', '/rprogressEasing', 'rprogress easing animations', {
    { name="Easing", help="Easing function" },
    { name="Duration", help="Duration in ms" },
})

TriggerEvent('chat:addSuggestion', '/rprogressAnimation', 'rprogress play animation', {
    { name="animDictionary", help="animDictionary" },
    { name="animationName", help="animationName" },
    { name="Duration", help="Duration in ms" },
})

TriggerEvent('chat:addSuggestion', '/rprogressScenario', 'rprogress play task', {
    { name="scenarioName", help="Scenario Name" },
    { name="Duration", help="Duration in ms" },
})

TriggerEvent('chat:addSuggestion', '/rprogressAsync', 'Run rprogress async', {
    { name="Duration", help="Duration in ms" }
})

TriggerEvent('chat:addSuggestion', '/rprogressSync', 'Run rprogress sync', {
    { name="Duration", help="Duration in ms" }
})

TriggerEvent('chat:addSuggestion', '/rprogressStatic', 'rprogress static demo')
TriggerEvent('chat:addSuggestion', '/rprogressDisableControls', 'rprogress with disabled controls')

TriggerEvent('chat:addSuggestion', '/rprogressCustom', 'rprogress Custom Demo', {
    { name="From (0-100)", help="Percentage to start from" },
    { name="To (0-100)", help="Percentage to stop at" },
    { name="Duration", help="Duration in ms" },
    { name="Radius (px)", help="Radius of the dial" },
    { name="Stroke (px)", help="Stroke width of bar" },
    { name="MaxAngle (deg)", help="Maximum arc of dial" },
    { name="Rotation (deg)", help="Rotation angle of dial" },
})

RegisterCommand("rprogressStart", function(source, args, raw)
    Start(args[1], tonumber(args[2])) 
end)

RegisterCommand("rprogressMiniGame", function(source, args, raw)
    MiniGame({
        Difficulty = args[1] or "Easy",
        onComplete = function(success)           
            if success then
                ShowNotification("~g~SUCCESS!")
            else
                ShowNotification("~r~FAILED!")
            end
        end
    })
end)

RegisterCommand("rprogressEasing", function(source, args, raw)
    local easing = args[1]
    local duration = args[2]
    if duration == nil then
        duration = 3000
    end      

    if easing == nil then
        easing = "easeLinear"
    end

    Custom({
        Label = easing,
        Easing = easing,
        Duration = tonumber(duration),
        ShowTimer = false
    }) 
end)

RegisterCommand("rprogressAnimation", function(source, args, raw)
    local animationDictionary = args[1]
    local animationName = args[2]

    if animationDictionary == nil then
        return PrintError("Please provide an animationDictionary")
    end

    if animationName == nil then
        return PrintError("Please provide an animationName")
    end

    local duration = args[3]
    if duration == nil then
        duration = 3000
    end    

    Custom({
        Animation = {
            animationDictionary = animationDictionary,
            animationName = animationName,
        },
        Duration = tonumber(duration),              
    }) 
end)

RegisterCommand("rprogressScenario", function(source, args, raw)

    if args[1] == nil then
        return PrintError("Please provide a scenerio name")
    end

    local duration = args[2]
    if duration == nil then
        duration = 3000
    end    


    Custom({
        Duration = tonumber(duration),
        Animation = {
            scenario = args[1]
        },    
    }) 
end)

RegisterCommand("rprogressSync", function(source, args, raw)
    ShowNotification("~b~Event: before")
    Custom({
        Async = false,
        Duration = tonumber(args[1]),
        onStart = function(data, cb)
            ShowNotification("~b~Event: onStart")
        end,
        onComplete = function(data, cb)
            ShowNotification("~g~Event: onComplete")
        end
    }) 
    ShowNotification("~g~Event: after")
end)

RegisterCommand("rprogressAsync", function(source, args, raw)
    ShowNotification("~b~Event: before")
    Custom({
        Duration = tonumber(args[1]),
        onStart = function(data, cb)
            ShowNotification("~b~Event: onStart")
        end,
        onComplete = function(data, cb)
            ShowNotification("~g~Event: onComplete")
        end
    }) 
    ShowNotification("~g~Event: after")
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

RegisterCommand("rprogressStatic", function(source, args, raw)
    local ProgressBar = exports.rprogress:Static({
        Label = "My Custom Label",
        ShowProgress = true
    })

    print("local ProgressBar = exports.rprogress:Static({ Label = 'My Custom Label', ShowProgress = true })")

    Citizen.Wait(1000)

    math.randomseed(GetGameTimer())

    ProgressBar.Show()
    print("ProgressBar.Show()")

    local last = 0
    for i = 1, 6 do
        Citizen.Wait(1000)

        local max = last + 20

        local progress = math.random (last, max)

        if progress > 100 then
            progress = 100
        end

        if progress < 100 and i == 6 then
            progress = 100
        end        

        ProgressBar.SetProgress(progress)

        print("ProgressBar.SetProgress("..progress..")")
    
        last = last + 20

        if progress >= 100 then
            Citizen.Wait(1000) 
            
            ProgressBar.Hide()
            print("ProgressBar.Hide()")

            Citizen.Wait(1000)          

            ProgressBar.Destroy()
            print("ProgressBar.Destroy()")

            break
        end
    end  
end)

RegisterCommand("rprogressDisableControls", function(source, args, raw)
    Custom({
        DisableControls = {
            Mouse = true,
            Player = true,
            Vehicle = true
        },
        Duration = tonumber(args[1]),
        onStart = function(data, cb)
            ShowNotification("~w~Controls: ~r~DISABLED")
        end,
        onComplete = function(data, cb)
            ShowNotification("~w~Controls: ~g~ENABLED")
        end
    }) 
end)