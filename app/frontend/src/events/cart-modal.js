export default {
  init() {
    const cartModalButton = document.querySelector('.showCart > button')
    if(cartModalButton) {
      const cart = document.querySelector('.cart')
      const goBack = document.querySelector('.cart > .goBack')
      let scrollPos
      cartModalButton.addEventListener('click', function(e) {
        scrollPos = window.pageYOffset
        cart.className = 'cart active animated slideInUp faster'
        cart.scrollTo(0, 0)
        setTimeout(function(){ document.documentElement.classList.add('is-clipped') }, 500)
      })

      goBack.addEventListener('click', function(e) {
        if(cart.classList.contains('active')) {
          document.documentElement.classList.remove('is-clipped')
          window.scrollTo(0, scrollPos)
          cart.className = 'cart active animated slideOutDown faster'
          setTimeout(function(){ cart.className = 'cart' }, 500)
        }
      })
    }
  }
}