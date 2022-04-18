# rprogress
Customisable radial progress bars for FiveM. 

## Table of contents
* [Demo Videos](#demo-videos)
* [Requirements](#requirements)
* [Download & Installation](#download--installation)
* [Configuration](#configuration)
* [Upgrading](#upgrading)
* [Client Functions](#client-functions)
* [Scenarios and Animations](#scenarios-and-animations)
* [MiniGame](#minigame)
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
* [Mini Game](https://streamable.com/azhzhz)

## Requirements

* None!

## Download & Installation

* Download and extract the package: https://github.com/Mobius1/rprogress/archive/master.zip
* Drop the `rprogress-master` directory into you `resources` directory
* Rename the directory from `rprogress-master` to `rprogress`
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
Config.ZoneColor    = "rgba(51, 105, 30, 1)"        -- Minigame Zone colour

Config.x            = 0.5 -- Horizontal position
Config.y            = 0.5 -- Vertical position

Config.Rotation     = 0         -- Rotation angle of dial
Config.MaxAngle     = 360       -- Max arc in degrees - 360 will be a full circle, 90 will be a quarter of a circle, etc
Config.Radius       = 60        -- Radius of the radial dial
Config.Stroke       = 10        -- stroke width of the radial dial
Config.Width        = 300       -- Width of the linear bar
Config.Height       = 40        -- Height of the linear bar
Config.Cap          = 'butt'    -- or 'round'
Config.Padding      = 0         -- Background bar padding
Config.CancelKey    = 178       -- Key used for cancelling progress

Config.ShowTimer    = true  -- Shows the timer countdown within the radial dial
Config.ShowProgress = false -- Shows the progress within the radial dial

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

-- Create a linear progress bar
exports.rprogress:Linear(text, duration)

-- or

exports.rprogress:Custom({
    Type = 'linear'
    Duration = 3000,
    Width = 400,
    Height = 50,
    y = 0.75
})
```

##### Display a progress dial with text for set duration

```lua
exports.rprogress:Start(text, duration)
```

##### Stop the progress dial early
```lua
exports.rprogress:Stop()
```

##### Create a custom progress instance
```lua
exports.rprogress:Custom({
    Async = true,
    canCancel = true,       -- Allow cancelling
    cancelKey = 178,        -- Custom cancel key
    x = 0.5,                -- Position on x-axis
    y = 0.5,                -- Position on y-axis
    From = 0,               -- Percentage to start from
    To = 100,               -- Percentage to end
    Duration = 1000,        -- Duration of the progress
    Radius = 60,            -- Radius of the dial
    Stroke = 10,            -- Thickness of the progress dial
    Cap = 'butt',           -- or 'round'
    Padding = 0,            -- Padding between the progress dial and the background dial
    MaxAngle = 360,         -- Maximum sweep angle of the dial in degrees
    Rotation = 0,           -- 2D rotation of the dial in degrees
    Width = 300,            -- Width of bar in px if Type = 'linear'
    Height = 40,            -- Height of bar in px if Type = 'linear'
    ShowTimer = true,       -- Shows the timer countdown within the radial dial
    ShowProgress = false,   -- Shows the progress % within the radial dial    
    Easing = "easeLinear",
    Label = "My Custom Label",
    LabelPosition = "right",
    Color = "rgba(255, 255, 255, 1.0)",
    BGColor = "rgba(0, 0, 0, 0.4)",
    ZoneColor = "rgba(51, 105, 30, 1)",
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
    end,
    onComplete = function(cancelled)
        -- cancelled: boolean - whether player cancelled the progress

        -- do something when progress is complete
    end
})
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

## MiniGame
`rProgress` can be set up to allow a minigame to test player reflexes by utilising the `MiniGame()` method.

The progress bar will flip back and forth and display a trigger zone for the player to hit the `SpaceBar` when the progress bar is within it.

As with the `Custom()` method, you can pass a variety of options. The `onComplete` callback will return the `success` parameter to indicate whether the player was successful or not.

```lua
exports.rprogress:MiniGame({
    Difficulty = "Easy",
    Timeout = 5000, -- Duration before minigame is cancelled
    onComplete = function(success)
            if success then
                -- Player was successful
            else
                -- Player was unsuccessful
            end    
    end,
    onTimeout = function()
        -- Player took too long to respond
    end
})
```

You can define the defficulties in the `config.lua` file:
```lua
Config.MiniGameOptions = {
    MaxAngle = 240,
    Rotation = -120,    
    Difficulty = {
        Easy = {
            Zone = 40,
            Duration = 500
        },
        Medium = {
            Zone = 25,
            Duration = 450
        },
        Hard = {
            Zone = 20,
            Duration = 400
        }      
    }      
}
```

To add you own difficulty you can define it in the `Config.MiniGameOptions.Difficulty` table and add the `Zone` and `Duration` values:

```lua
Config.MiniGameOptions = {
    MaxAngle = 240,
    Rotation = -120,    
    Difficulty = {
        Custom = {
            Zone = 40,         -- The percentage of the dial that is the trigger zone (lower = harder)
            Duration = 1000    -- Time in milliseconds for the dial to fill in one direction (lower = harder)
        }
    }
}
```

Then use it in the `MiniGame()` method:

```lua
exports.rprogress:MiniGame({
    Difficulty = "Custom",
    onComplete = function(success)

    end
})
```

You can also pass the `Zone` and `Duration` values instead of `Difficulty` for on-the-fly difficulty settings:

```lua
exports.rprogress:MiniGame({
    Zone = 40,
    Duration = 750,
    onComplete = function(success)
    
    end
})
```

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
/rprogressCustom [from] [to] [duration] [radius] [stroke] [MaxAngle] [rotation] [padding] [cap]
/rprogressMiniGame [difficulty]
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


## Legal

### License

```
rprogress - Customisable radial progress dials for FiveM.

Copyright (C) 2020 Karl Saunders

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>
```