show_tickets();

function show_tickets() {
  let ticketBtn = document.querySelectorAll('.ticket');
  let closeBtn = document.querySelectorAll('.closeBtn');
  for(let t of ticketBtn) {
    t.addEventListener('click', function() {
      let show = t.nextElementSibling;
      show.classList.add('op-1');
      document.documentElement.classList.add('is-clipped');
    });
  }
  for(let c of closeBtn) {
    c.addEventListener('click', function() {
      let close = c.parentElement.parentElement.parentElement.parentElement;
      close.classList.remove('op-1');
      document.documentElement.classList.remove('is-clipped');
    });
  }
}