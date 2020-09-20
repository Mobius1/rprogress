# rprogress
Customisable radial progress bars for FiveM . 

## Demo Videos
* [Default](https://streamable.com/85j3gt)
* [Custom MaxAngle and Rotation](https://streamable.com/i6lhxx)
* [Without Timer](https://streamable.com/d7qil2)
* [Demo with esx_doorlock](https://streamable.com/94b0ph)

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
Config.From         = 0     -- Starting progress percentage
Config.To           = 100   -- Ending progress percentage

Config.Duration     = 5000          -- Duration of the progress
Config.Label        = "Loading..."  -- Text shown with the dial

Config.Color        = "rgba(255, 255, 255, 1.0)"    -- Progress bar colour
Config.BGColor      = "rgba(0, 0, 0, 0.4)"          -- Progress background colour

Config.Position = { 
    x   = 0.5,              -- Horizontal position
    y   = 0.5               -- Vertical position
}

Config.Rotation     = 0     -- Rotation angle of dial in degrees
Config.MaxAngle     = 360   -- Max arc in degrees - 360 = full circle, 90 = quarter of a circle, etc
Config.Radius       = 60    -- Radius of the dial in pixels
Config.Stroke       = 10    -- stroke width of the dial in pixels

Config.ShowTimer    = true  -- Shows the timer countdown withing the dial
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
exports.rprogress:Start(2000, function()
    -- do something when progress is complete
end)
```

##### Stop the progress bar early
```lua
exports.rprogress:Stop()
```

##### Override `config.lua` values
```lua
exports.rprogress:Custom({
    From = 0,
    To = 100,
    Duration = 1000,
    Radius = 60,
    Stroke = 10,
    MaxAngle = 360,
    Rotation = 0,
    Color = "rgba(255, 255, 255, 1.0)",
    BGColor = "rgba(0, 0, 0, 0.4)",
    onStart = function(data, callback)
        -- do something when progress starts
    end	
    onComplete = function(data, callback)
        -- do something when progress is complete
    end
})
```

## Contributing
Pull requests welcome.

## To Do
- [ ] Allow bar colour customisation in `config.lua`

## Legal

### License

esx_collectables - Enable collectable items on an ESX-enabled FiveM server

Copyright (C) 2020 Karl Saunders

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.