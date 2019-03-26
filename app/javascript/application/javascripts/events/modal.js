var cartbtn = document.querySelector('.cart-btn');
var videobtn = document.querySelector('.video-btn');

var html = document.documentElement;

if(cartbtn) {
  cartInit();
}

if(videobtn) {
  modalInit();
}

function cartInit() {
  let cart = document.querySelector('.offers.card');
  let hidecart = document.querySelector('.hide-cart');
  let body = document.body;
  let footer = document.querySelector('.footer');
  body.classList.add("mb-footer");
  footer.classList.add("height-footer");
  cartbtn.addEventListener('click', function() {
    cart.classList.add("op-1");
    html.classList.add("is-clipped");
  });
  hidecart.addEventListener('click', function() {
    cart.classList.remove("op-1");
    html.classList.remove("is-clipped");
  });
}

function modalInit() {
  let modal = document.querySelector('.modal');
  let modalclose = document.querySelector('.modal-close');
  let video = document.getElementById('video');
  videobtn.addEventListener('click', function() {
    html.classList.add("is-clipped");
    modal.classList.add("is-active");
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
  let modal = document.querySelector('.modal');
  modal.classList.remove("is-active");
  html.classList.remove("is-clipped");
  video.setAttribute('src','');
}