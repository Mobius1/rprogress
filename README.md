# rprogress
Customisable radial progress bars for FiveM. 

## Table of contents
* [Demo Videos](#demo-videos)
* [Requirements](#requirements)
* [Download & Installation](#download--installation)
* [Configuration](#configuration)
* [Upgrading](#upgrading)
* [Client Functions](#client-functions)
* [Server Triggers](#server-triggers)
* [Scenarios and Animations](#scenarios-and-animations)
* [Sync vs Async](#sync-vs-async)
* [Static Progress Dials](#static-progress-dials)
* [Partial Progress Dials](#partial-progress-dials)
* [Pie Progress](#pie-progress)
* [Demo Commands](#demo-commands)
* [Contributing](#contributing)
* [To Do](#to-do)

## Demo Videos
* [Default](https://streamable.com/85j3gt)
* [Custom MaxAngle and Rotation](https://streamable.com/i6lhxx)
* [Animations](https://streamable.com/23r6jg)
* [Without Timer](https://streamable.com/d7qil2)
* [Demo with esx_doorlock](https://streamable.com/94b0ph)
* [Custom Label Position](https://streamable.com/4mqwgx)
* [Static Progress Dial](https://streamable.com/uzbfsd)

## Requirements

* None!

## Download & Installation

* Download and extract the package: https://github.com/Mobius1/rprogress/archive/master.zip
* Drop the `rprogress` directory into you `resources` directory
* Add `ensure rprogress` in your `server.cfg`
* Edit `config.lua` to your liking
* Start your server and rejoice!

## Configuration

```lua
Config.Async        = true  -- Whether to run the progress dial asyncronously

Config.From         = 0     -- Starting progress percentage
Config.To           = 100   -- Ending progress percentage

Config.Duration         = 5000          -- Duration of the progress
Config.Label            = "Loading..."  -- Text shown with the dial
Config.LabelPosition    = "bottom"

Config.Color        = "rgba(255, 255, 255, 1.0)"    -- Progress dial colour
Config.BGColor      = "rgba(0, 0, 0, 0.4)"          -- Progress background colour

Config.x            = 0.5 -- Horizontal position
Config.y            = 0.5 -- Vertical position

Config.Rotation     = 0     -- Rotation angle of dial in degrees
Config.MaxAngle     = 360   -- Max arc in degrees - 360 = full circle, 90 = quarter of a circle, etc
Config.Radius       = 60    -- Radius of the dial in pixels
Config.Stroke       = 10    -- stroke width of the dial in pixels

Config.ShowTimer    = true  -- Shows the timer countdown within the dial
Config.ShowProgress = false -- Shows the progress within the dial

Config.Easing       = "easeLinear" -- The easing used for the dial animation - see "rprogress/ui/js/easings.js"

Config.DisableControls = {
    Mouse           = false,    -- Disable mouse controls until progress is complete
    Player          = false,    -- Disable player movement until progress is complete
    Vehicle         = false     -- Disable vehicle control until progress is complete    
}
```
NOTE: `Config.Position` is based on screen size so setting `Config.Position.x = 0.5` will be the center of the screen, `Config.Position.x = 1.0` with be right-side of the screen, `Config.Position.x = 0.0` will be the left-side of the screen, etc.

## Upgrading

#### Upgrading to v0.6.0
Replace all instances of `exports.rprogress:NewStaticProgress` with `exports.rprogress:Static`

## Client Functions

NOTE: DO NOT run these in a loop

Available exports:

```lua
-- starts the progress dial for the defined duration
-- This runs in sync so any code after this call won't be run until the progress is complete
exports.rprogress:Start(text, duration)

-- stops the progress dial early
exports.rprogress:Stop()

-- Display a custom progress dial by overriding config.lua values
exports.rprogress:Custom(options)

-- Create a static progress dial
exports.rprogress:Static(options)
```

##### Display a progress dial with text for set duration

```lua
exports.rprogress:Start(text, duration)
```

##### Stop the progress dial early
```lua
exports.rprogress:Stop()
```

##### Override `config.lua` values
```lua
exports.rprogress:Custom({
    Async = true,
    x = 0.5,
    y = 0.5,
    From = 0,
    To = 100,
    Duration = 1000,
    Radius = 60,
    Stroke = 10,
    MaxAngle = 360,
    Rotation = 0,
    Easing = "easeLinear",
    Label = "My Custom Label",
    LabelPosition = "right",
    Color = "rgba(255, 255, 255, 1.0)",
    BGColor = "rgba(0, 0, 0, 0.4)",
    Animation = {
        scenario = "WORLD_HUMAN_AA_SMOKE", -- https://pastebin.com/6mrYTdQv
        animationDictionary = "missheistfbisetup1", -- https://alexguirre.github.io/animations-list/
        animationName = "unlock_loop_janitor",
    },
    DisableControls = {
        Mouse = true,
        Player = true,
        Vehicle = true
    },    
    onStart = function()
        -- do something when progress starts
    end	
    onComplete = function()
        -- do something when progress is complete
    end
})
```

## Server Triggers
These won't run in async due to not being able to pass callbacks from server to client.
```lua
TriggerClientEvent('rprogress:start', source, text, duration)
TriggerClientEvent('rprogress:stop', source)
TriggerClientEvent('rprogress:custom', source, options)
```

## Scenarios and Animations
`rprogress` allows you to run a scenario or play an animation while the progress dial is running.

If you want to run a scenario, then provide the `Animation` table with the `scenario` key.

```lua
exports.rprogress:Custom({
    Animation = {
        scenario = "WORLD_HUMAN_AA_SMOKE"
    }
}) 
```

You can find a list of scenarios [here](https://pastebin.com/6mrYTdQv)

If you want to play an animation, then provide the `Animation` table with the required `animationDictionary` and `animationName` keys. You can also provide the optional `flag` key (see [`TaskPlayAnim`](https://wiki.rage.mp/index.php?title=Player::taskPlayAnim)).
```lua
exports.rprogress:Custom({
    Animation = {
        animationDictionary = "missheistfbisetup1",
        animationName = "unlock_loop_janitor",
        flag = 1, -- optional
    }
}) 
```

You can find a list of animation dictionaries / names [here](https://alexguirre.github.io/animations-list/).

If `scenario` is set as well as `animationDictionary` and `animationName`, then the `scenario` will take priority.

## Sync vs Async

The `Start()` method runs in sync so any code after the call to the method won't be run until the progress is complete. If you want a progress dial to run asyncronously, you can use the `Custom()` method with `Async` set to `true` and utilise the `onStart` and `onComplete` callbacks.

##### Async
```lua
print("before")

exports.rprogress:Custom({
    Async = true,
    Duration = 3000,
    onStart = function()
        print("start")
    end      
    onComplete = function()
        print("complete")
    end    
})

print("after")
```

##### Output
```lua
before
after
start
complete
```

##### Sync
```lua
print("before")

exports.rprogress:Custom({
    Async = false,
    Duration = 3000,
    onStart = function()
        print("start")
    end      
    onComplete = function()
        print("complete")
    end     
})

print("after")
```

###### Output
```lua
before
start
complete
after
```

## Static Progress Dials

If you don't just want a progress dial that fills automatically, you can create a static one and update it as required.

[Demo Video](https://streamable.com/uzbfsd)

```lua
-- Create new static progress dial
local staticDial = exports.rprogress:Static(options)

-- Show the progress dial
staticDial.Show()

-- Update the progress of the dial (0-100)
staticDial.SetProgress(progress)

-- Hide the progress dial
staticDial.Hide()

-- Destroy the dial (set as no longer needed)
staticDial.Destroy()
```

## Partial Progress Dials

To create a partial progress dial set the `maxAngle` property to the desired value:
```lua
exports.rprogress:Custom({
    maxAngle: 240
})
```
#### Result
![](https://i.imgur.com/CS7kLpw.png)

You can also set `rotation` property to the desired value:
```lua
exports.rprogress:Custom({
    maxAngle: 240,
    rotation: -120
})
```

#### Result
![](https://i.imgur.com/Jlouv2P.png)

## Pie Progress
Setting the `radius` and `stroke` properties to equal values will produce a pie chart type progress:
```lua
exports.rprogress:Custom({
    Radius: 60,
    Stroke: 60
})
```

#### Result
![](https://i.imgur.com/ZhnkvXs.gif)

## Demo Commands

```lua
/rprogressStart [text] [duration]
/rprogressCustom [from] [to] [duration] [radius] [stroke] [MaxAngle] [rotation]
/rprogressSync [duration]
/rprogressAsync [duration]
/rprogressStatic
/rprogressEasing [functionName] [duration]
/rprogressAnimation [animDictionary] [animName] [duration]
/rprogressScenario [scenarioName] [duration]
```

You can delete the `demo.lua` file and remove it's entry from `fxmanifest.lua` if these are not required.

## Contributing
Pull requests welcome.

## To Do
- [x] Allow sync and async
- [x] Allow dial colour customisation in `config.lua`
- [x] Allow control disable ([Suggested by Korek](https://forum.cfx.re/t/release-standalone-rprogress-customisable-radial-progress-bars/1630655/24))

## Legal

### License

rprogress - Customisable radial progress dials for FiveM.

Copyright (C) 2020 Karl Saunders

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.