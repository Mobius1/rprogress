# rprogress
Customisable radial progress bars for FiveM. 

## Table of contents
* [Demo Videos](#demo-videos)
* [Requirements](#requirements)
* [Download & Installation](#download--installation)
* [Configuration](#configuration)
* [Client Functions](#client-functions)
* [Sync vs Async](#sync-vs-async)
* [Demo Commands](#demo-commands)
* [Contributing](#contributing)
* [To Do](#to-do)

## Demo Videos
* [Default](https://streamable.com/85j3gt)
* [Custom MaxAngle and Rotation](https://streamable.com/i6lhxx)
* [Without Timer](https://streamable.com/d7qil2)
* [Demo with esx_doorlock](https://streamable.com/94b0ph)
* [Custom Label Position](https://streamable.com/4mqwgx)

## Requirements

* None!

## Download & Installation

* Download and extract the package: https://github.com/Mobius1/RadialProgress/archive/master.zip
* Drop the `rprogress` directory into you `resources` directory
* Add `ensure rprogress` in your `server.cfg`
* Edit `config.lua` to your liking
* Start your server and rejoice!

## Configuration

```lua
Config.Async        = true  -- Whether to run the progress bar asyncronously

Config.From         = 0     -- Starting progress percentage
Config.To           = 100   -- Ending progress percentage

Config.Duration         = 5000          -- Duration of the progress
Config.Label            = "Loading..."  -- Text shown with the dial
Config.LabelPosition    = "bottom"

Config.Color        = "rgba(255, 255, 255, 1.0)"    -- Progress bar colour
Config.BGColor      = "rgba(0, 0, 0, 0.4)"          -- Progress background colour

Config.x            = 0.5 -- Horizontal position
Config.y            = 0.5 -- Vertical position


Config.Rotation     = 0     -- Rotation angle of dial in degrees
Config.MaxAngle     = 360   -- Max arc in degrees - 360 = full circle, 90 = quarter of a circle, etc
Config.Radius       = 60    -- Radius of the dial in pixels
Config.Stroke       = 10    -- stroke width of the dial in pixels

Config.ShowTimer    = true  -- Shows the timer countdown within the dial
Config.ShowProgress = false -- Shows the progress within the dial
```
NOTE: `Config.Position` is based on screen size so setting `Config.Position.x = 0.5` will be the center of the screen, `Config.Position.x = 1.0` with be right-side of the screen, `Config.Position.x = 0.0` will be the left-side of the screen, etc.

## Client Functions

NOTE: DO NOT run these in a loop

Available exports:

```lua
-- starts the progress bar for the defined duration and fires an optional callback when finished
exports.rprogress:Start(duration, cb)

-- stops the progress bar early
exports.rprogress:Stop()

-- Display a custom progress bar by overriding config.lua values
exports.rprogress:Custom(options)
```

##### Start the progress bar

```lua
-- async
exports.rprogress:Start(2000, function()
    -- do something when progress is complete
end)

-- sync
exports.rprogress:Start(2000)
```

##### Stop the progress bar early
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
    Label = "My Custom Label",
    LabelPosition = "right",
    Color = "rgba(255, 255, 255, 1.0)",
    BGColor = "rgba(0, 0, 0, 0.4)",
    onStart = function()
        -- do something when progress starts
    end	
    onComplete = function()
        -- do something when progress is complete
    end
})
```

## Sync vs Async

By default, `rprogress` runs asyncronously with callbacks available to call when the progress bar is complete.

By setting `Async` to `false`, the resource will run syncronously and any code after the progress bar function will not run until the progress bar is complete.

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

## Demo Commands

```lua
/rprogressStart [duration]
/rprogressCustom [from] [to] [duration] [radius] [stroke] [MaxAngle] [rotation]
/rprogressSync [duration]
/rprogressAsync [duration]
```

You can delete the `demo.lua` file and remove it's entry from `fxmanifest.lua` if these are not required.

## Contributing
Pull requests welcome.

## To Do
- [x] Allow sync and async
- [x] Allow bar colour customisation in `config.lua`

## Legal

### License

rprogress - Customisable radial progress bars for FiveM.

Copyright (C) 2020 Karl Saunders

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.