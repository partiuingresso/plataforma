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