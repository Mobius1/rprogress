--------------------------------------
-- DELETE THIS FILE IF NOT REQUIRED --
--------------------------------------

TriggerEvent('chat:addSuggestion', '/rprogressStart', 'rprogress Start Demo', {
    { name="Label", help="The label to show" },
    { name="Duration (ms)", help="Duration of progress" }
})

TriggerEvent('chat:addSuggestion', '/rprogressAsync', 'Run rprogress async', {
    { name="Duration (ms)", help="Duration of progress" }
})

TriggerEvent('chat:addSuggestion', '/rprogressSync', 'Run rprogress sync', {
    { name="Duration (ms)", help="Duration of progress" }
})

TriggerEvent('chat:addSuggestion', '/rprogressStatic', 'rprogress static demo')
TriggerEvent('chat:addSuggestion', '/rprogressDisableControls', 'rprogress with disabled controls')

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
    Start(args[1], tonumber(args[2])) 
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
    local ProgressBar = NewStaticProgress({
        Label = "My Custom Label",
        ShowProgress = true
    })

    print("local ProgressBar = NewStaticProgress({ Label = 'My Custom Label', ShowProgress = true })")
    ShowNotification("NewStaticProgress()")

    Citizen.Wait(1000)

    math.randomseed(GetGameTimer())

    ProgressBar.Show()
    print("ProgressBar.Show()")
    ShowNotification("ProgressBar.Show()")

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
        ShowNotification("ProgressBar.SetProgress("..progress..")")
    
        last = last + 20

        if progress >= 100 then
            Citizen.Wait(1000) 
            
            ProgressBar.Hide()
            print("ProgressBar.Hide()")
            ShowNotification("ProgressBar.Hide()")

            Citizen.Wait(1000)          

            ProgressBar.Destroy()
            print("ProgressBar.Destroy()")
            ShowNotification("ProgressBar.Destroy()")

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

function ShowNotification(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end