var cart = document.querySelector('.offers.card');
var modal = document.querySelector('.modal');

if(cart) {
  cartInit();
}

if(modal) {
  modalInit();
}

function cartInit() {
  var cartbtn = document.querySelector('.cart-btn');
  var hidecart = document.querySelector('.hide-cart');
  cartbtn.addEventListener('click', function() {
    cart.classList.add("is-block");
  });
  hidecart.addEventListener('click', function() {
    cart.classList.remove("is-block");
  });
}

function modalInit() {
  var videobtn = document.querySelector('.video-btn');
  var modalclose = document.querySelector('.modal-close');
  var video = document.getElementById('video');
  videobtn.addEventListener('click', function() {
    modal.classList.add("is-active");
    modal.classList.add("is-clipped");
    var videoSrc = videobtn.dataset.src;
    video.setAttribute('src',videoSrc + "?rel=0&amp;showinfo=0&amp;modestbranding=1&amp;autoplay=1" ); 
  });
  modal.addEventListener('click', function() {
    closeModal();
  });
  document.addEventListener('keydown', function (event) {
      var e = event || window.event;
      if (e.keyCode === 27) {
        closeModal();
      }
  });
}

function closeModal() {
    modal.classList.remove("is-active");
    modal.classList.remove("is-clipped");
    video.setAttribute('src','');
}

function closeCart() {
    cart.classList.remove("is-active");
    cart.classList.remove("is-clipped");
    video.setAttribute('src','');
}