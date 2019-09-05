export default {
  init() {
    var helpLink = document.querySelector('.helpLink')
    var form = document.querySelector('.form')
    var needHelp = document.querySelector('.needHelp')
    var goBack = document.querySelector('.goBack')

    helpLink.addEventListener('click', function(e) {
      form.className = 'form animated fadeOutLeftBig slower hide'
      needHelp.className = 'needHelp animated fadeInRightBig fast show'
    })

    goBack.addEventListener('click', function(e) {
      needHelp.className = 'needHelp animated fadeOutRight'
      form.className = 'form animated fadeInLeft'
    })
  }
}