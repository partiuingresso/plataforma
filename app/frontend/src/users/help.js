export default {
  init() {
    var helpLink = document.querySelector('.helpLink')
    var form = document.querySelector('.form')
    var needHelp = document.querySelector('.needHelp')
    var goBack = document.querySelector('.goBack')
    var viewPass = document.querySelector('.viewPass')

    console.log(viewPass)

    if(viewPass) {
      viewPass.addEventListener('click', function(e) {
        let pass = viewPass.previousElementSibling
        let passAtt = pass.getAttribute('type')
        if(passAtt == 'password') {
          pass.setAttribute('type', 'text')
        } else {
          pass.setAttribute('type', 'password')
        }
      })
    }

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