import * as Vibrant from 'node-vibrant'

let v = new Vibrant(imgurl)
v.getPalette((err, palette) => {
	let vibrant = palette.Vibrant.getRgb()
	let lightvibrant = palette.LightVibrant.getRgb()
	let darkvibrant = palette.DarkVibrant.getRgb()
	let muted = palette.Muted.getRgb()
	let lightmuted = palette.LightMuted.getRgb()
	let darkmuted = palette.DarkMuted.getRgb()

	function decToInt(rgb) {
		rgb[0] = parseInt(rgb[0])
		rgb[1] = parseInt(rgb[1])
		rgb[2] = parseInt(rgb[2])
	}

	decToInt(vibrant)
	decToInt(lightvibrant)
	decToInt(darkvibrant)
	decToInt(muted)
	decToInt(lightmuted)
	decToInt(darkmuted)


  let style = document.createElement('style')
  style.type = 'text/css'
  style.innerHTML = ':root { --darkvibrant: '+darkvibrant+'; --vibrant: '+vibrant+'; --muted: '+muted+'; --darkmuted: '+darkmuted+'; --lightvibrant: '+lightvibrant+'; --lightmuted: '+lightmuted+'; }'
  document.getElementsByTagName('head')[0].appendChild(style)
})