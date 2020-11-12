## Welcome to rprogress Documentation

Customisable radial progress bars for FiveM.

## API

### Start()
---
```lua
exports.rprogress:Start(text --[[string]], duration --[[number]])
```

### Stop()
---
```lua
exports.rprogress:Stop()
```

### Custom()
---
```lua
exports.rprogress:Custom(options --[[table]])
```

### NewStaticProgress()
---
Creates a static progress dial

```lua
local staticProgress = exports.rprogress:NewStaticProgress(options --[[table]])

-- Show the progress bar
staticProgress.Show()

-- Update the progress of the bar (0-100)
staticProgress.SetProgress(progress)

-- Hide the progress bar
staticProgress.Hide()

-- Destroy the bar (set as no longer needed)
staticProgress.Destroy()
```

## Options

This are the options that can be passed to the `Custom()` and `NewStaticProgress()` methods.

### Async
---
Type: `bool`
Default: `true`

Enable / disable async
### x
---
Type: `float`
Default: `0.5`

Sets the horizontal position of the dial
### y
---
Type: `float`
Default: `0.5`

Sets the vertical position of the dial
### From
---
Type: `number`
Default: `0`

Sets the percentage progress to start from

Sets the vertical position of the dial
### To
---
Type: `number`
Default: `100`

Sets the completion percentage of rthe dial

### Duration
---
Type: `number`
Default: `5000`

Sets length of time taken to complete the progress in `ms`

### Radius
---
Type: `number`
Default: `60`

Sets the radius of the dial in `px`
### Stroke
---
Type: `number`
Default: `10`

Sets the stroke width of the dial in `px`
### MaxAngle
---
Type: `number`
Default: `360`

Sets maximum arc of the dial in `degrees`
### Rotation
---
Type: `number`
Default: `0`

Sets rotation of the dial in `degrees`
### Easing
---
Type: `string`
Default: `"easeLinear"`

Sets the easing function used for the dial animation -- See the [easings.js](https://github.com/Mobius1/rprogress/blob/master/rprogress/ui/js/easings.js) file
### Label
---
Type: `string`
Default: `"Loading..."`

Sets the text to show during the progress

### LabelPosition
---
Type: `string`
Default: `"bottom"`

Sets the position of the label relative to the dial
### Color
---
Type: `string`
Default: `"rgba(255, 255, 255, 1.0)"`

Sets the color of the dial's progress bar
### BGColor
---
Type: `string`
Default: `"rgba(0, 0, 0, 0.4)"`

Sets the color of the dial background
### Animation
---
Type: `table`
Default: `nil`

Sets the `animationDictionary` and `animationName` or `scenario` to be used during progress.

```lua
Animation = {
    scenario = "WORLD_HUMAN_AA_SMOKE"
}
```
or
```lua
Animation = {
    animationDictionary = "missheistfbisetup1",
    animationName = "unlock_loop_janitor",
    flag = 1, -- optional
}
```

If `scenario` is set as well as `animationDictionary` and `animationName`, then the `scenario` will take priority.

See [TaskStartScenarioInPlace](https://runtime.fivem.net/doc/natives/?_0x142A02425FF02BD9) and [TaskPlayAnim](https://runtime.fivem.net/doc/natives/?_0xEA47FE3719165B94)

### DisableControls   
---
Type: `table`
Default:
```lua
    DisableControls = {
        Mouse   = true, -- enable / disable camera movement
        Player  = true, -- enable / disable player movement
        Vehicle = true  -- enable / disable vehicle movement / usage
    }, 
```

Allows for disabled controls during progress

### onStart
---
Type: `function`
Default: `nil`

Callback fired when progress begins

### onComplete
---
Type: `function`
Default: `nil`

Callback fired when progress completes