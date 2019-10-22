export default {
  init() {
    var text = document.querySelector('.text')
    var readMore = text.querySelector('.readMore')
    window.addEventListener("load", function(event) {
      if(text.offsetHeight >= 720) {
        text.addEventListener('click', function(e) {
          readMore.classList.add('is-hidden')
          text.classList.add('more')
        })
      } else {
        readMore.classList.add('is-hidden')
      }
    })
  }
}