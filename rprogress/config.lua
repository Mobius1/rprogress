Config = {}

Config.From         = 0     -- Starting progress percentage
Config.To           = 100   -- Ending progress percentage

Async               = true  -- Whether to run the progress bar asyncronously

Config.Duration     = 5000
Config.Label        = "Loading..."

Config.Color        = "rgba(255, 255, 255, 1.0)"    -- Progress bar colour
Config.BGColor      = "rgba(0, 0, 0, 0.4)"          -- Progress background colour

Config.Position = { 
    x   = 0.5,              -- Horizontal position
    y   = 0.5               -- Vertical position
}

Config.Rotation     = 0     -- Rotation angle of dial
Config.MaxAngle     = 360   -- Max arc in degrees - 360 will be a full circle, 90 will be a quarter of a circle, etc
Config.Radius       = 60    -- Radius of the dial
Config.Stroke       = 10    -- stroke width of the dial

Config.ShowTimer    = true  -- Shows the timer countdown withing the dial
Config.ShowProgress = false -- Shows the progress within the dial

Config.onStart      = function()end
Config.onComplete   = function()end  