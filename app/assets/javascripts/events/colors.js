//= require node-vibrant/dist/vibrant
window.onload = function() {
  let v = new Vibrant(imgurl);   
  v.getPalette((err, palette) => {
    let dark = palette.DarkVibrant.getRgb();
    let vibrant = palette.Vibrant.getRgb();
    var elem = document.getElementById('infobar');
    elem.setAttribute('style', 'background-image: linear-gradient(to right, rgba('+dark+',0.3), rgba('+vibrant+',0.3));');
  });
}