import * as Vibrant from 'node-vibrant'

let v = new Vibrant(imgurl)
v.getPalette((err, palette) => {
    let darkvibrant = palette.DarkVibrant.getRgb()
    let vibrant = palette.Vibrant.getRgb()
    let muted = palette.Muted.getRgb()
    let darkmuted = palette.DarkMuted.getRgb()
    let lightvibrant = palette.LightVibrant.getRgb()
    let lightmuted = palette.LightMuted.getRgb()

    var style = document.createElement('style')
    style.type = 'text/css'
    style.innerHTML = ':root { --darkvibrant: '+darkvibrant+'; --vibrant: '+vibrant+'; --muted: '+muted+'; --darkmuted: '+darkmuted+'; --lightvibrant: '+lightvibrant+'; --lightmuted: '+lightmuted+'; }'
    document.getElementsByTagName('head')[0].appendChild(style)
})
