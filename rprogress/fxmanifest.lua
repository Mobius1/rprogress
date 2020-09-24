fx_version 'adamant'

game 'gta5'

description 'Radial Progress'

author 'Karl Saunders'

version '0.4.0'

client_scripts {
    'config.lua',
    'utils.lua',
    'client.lua',
    'demo.lua' -- remove if not needed
}

ui_page 'ui/ui.html'

files {
    'ui/ui.html',
    'ui/fonts/ChaletComprimeCologneSixty.ttf',
    'ui/fonts/ChaletLondonNineteenSixty.ttf',
    'ui/css/app.css',
    'ui/js/easings.js',
    'ui/js/class.RadialProgress.js',
    'ui/js/app.js',
}

exports "Start"
exports "Custom"
exports "Stop"
exports "NewStaticProgress"