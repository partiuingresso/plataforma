var order = document.querySelectorAll('.order.row');

for(let i of order) {
  i.addEventListener('click', function() {
    var details = i.nextElementSibling;
    var close = details.querySelector('.close');
    details.classList.remove('is-hidden');
    close.addEventListener('click', function() {
      details.classList.add('is-hidden');
    });
  });
}