fx_version 'adamant'

game 'gta5'

description 'Radial Progress'

author 'Karl Saunders'

version '0.7.6'

client_scripts {
    'config.lua',
    'utils.lua',
    'client.lua',
}

ui_page 'ui/ui.html'

files {
    'ui/ui.html',
    'ui/fonts/*.ttf',
    'ui/css/*.css',
    'ui/js/easings.js',
    'ui/js/class.RadialProgress.js',
    'ui/js/app.js',
}

exports {
    "Start",
    "Custom",
    "Stop",
    "Static",
    "Linear",
    "MiniGame"
}
