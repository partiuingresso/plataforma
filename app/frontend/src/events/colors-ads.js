import * as Vibrant from 'node-vibrant'

let v = new Vibrant(imgurl)
v.getPalette((err, palette) => {
    let darkvibrant = palette.DarkVibrant.getRgb()
    let vibrant = palette.Vibrant.getRgb()
    let muted = palette.Muted.getRgb()
    let darkmuted = palette.DarkMuted.getRgb()
    let lightvibrant = palette.LightVibrant.getRgb()
    let lightvibrant_hex = palette.LightVibrant.getHex()
    let lightmuted = palette.LightMuted.getRgb()

    var elem = document.getElementById('infobar')
    elem.setAttribute('style', 'background-image: linear-gradient(to right, rgba('+muted+',0.95), rgba('+darkmuted+',0.95));')

    var style = document.createElement('style')
    style.type = 'text/css'
    style.innerHTML = '.vibrantbg { background-color: rgb('+vibrant+'); } .mutedbg { background-color: rgb('+muted+'); } .darkvibrantbg { background-color: rgb('+darkvibrant+'); } .darkmutedbg { background-color: rgb('+darkmuted+'); } .lightvibrantbg { background-color: rgb('+lightvibrant+'); } .lightmutedbg { background-color: rgba('+lightmuted+', 0.1); } .vibrant { color: rgb('+vibrant+'); } .muted { color: rgb('+muted+'); } .darkvibrant { color: rgb('+darkvibrant+'); } .darkmuted { color: rgb('+darkmuted+'); } .lightvibrant { color: '+lightvibrant_hex+'; } .lightmuted { color: rgb('+lightmuted+'); } .ads-btn { background-image: linear-gradient(to right, rgb('+lightvibrant+') 0%, rgb('+vibrant+') 100%); } .ads-btn:hover { background-image: linear-gradient(to right, rgb('+vibrant+') 0%, rgb('+lightvibrant+') 100%); }'
    document.getElementsByTagName('footer')[0].appendChild(style)
})
