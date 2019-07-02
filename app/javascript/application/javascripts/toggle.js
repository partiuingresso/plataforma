export function toggle() {
  let toggles = document.querySelectorAll('.toggle');
  let dismiss = document.querySelectorAll('.dismiss');
  for(let t of toggles) {
    t.addEventListener("click", function() {
      var content = t.nextElementSibling;
      content.classList.remove('is-hidden');
      t.classList.add('is-hidden');
    });
  }
  for(let d of dismiss) {
    d.addEventListener("click", function() {
      var toggle = d.previousElementSibling;
      toggle.classList.remove('is-hidden');
      d.classList.add('is-hidden');
    });
  }
}

export function toggleCart() {
  let toggles = document.querySelectorAll('.toggleCart');
  let dismiss = document.querySelectorAll('.dismissCart');
  for(let t of toggles) {
    t.addEventListener("click", function() {
      var content = t.parentNode.parentNode.parentNode.childNodes[3];
      var dismiss = t.nextElementSibling;
      content.classList.remove('is-hidden');
      t.classList.add('is-hidden');
      dismiss.classList.remove('is-hidden');
    });
  }
  for(let d of dismiss) {
    d.addEventListener("click", function() {
      var toggle = d.previousElementSibling;
      var content = d.parentNode.parentNode.parentNode.childNodes[3];
      toggle.classList.remove('is-hidden');
      content.classList.add('is-hidden');
      d.classList.add('is-hidden');
    });
  }
}