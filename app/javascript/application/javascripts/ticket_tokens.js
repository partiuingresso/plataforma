show_tickets();

function show_tickets() {
  let ticketBtn = document.querySelectorAll('.ticket');
  for(let t of ticketBtn) {
    t.addEventListener('click', function() {
      let modal = t.nextElementSibling;
      modal.classList.add('is-active');
      document.documentElement.classList.add('is-clipped');
    });
  }
}