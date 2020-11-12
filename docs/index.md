## Welcome to rprogress Documentation

Customisable radial progress bars for FiveM.

## API
---
### Start()

##### Usage
```lua
exports.rprogress:Start(text --[[string]], duration --[[number]])
```
---
### Stop()

##### Usage
```lua
exports.rprogress:Stop()
```
---
### Custom()

##### Usage
```lua
exports.rprogress:Custom(options --[[table]])
```
---
### NewStaticProgress()

Creates a static progress dial

##### Usage
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