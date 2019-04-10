import Rails from 'rails-ujs';
let editlinks = document.querySelectorAll(".icon.admin-orders.edit");

for(let edit of editlinks) {
  edit.addEventListener('click', function(e) {
    let input = edit.parentElement.previousElementSibling.querySelector('.input.admin-orders');
    let value = input.value;
    let save = edit.nextElementSibling;
    let form = input.form;
    let done = false;
    input.classList.remove('is-static');
    input.removeAttribute('readonly');
    input.focus();
    edit.classList.add('is-hidden');
    save.classList.remove('is-hidden');
    save.addEventListener('click', function(e) {
      console.log("olar");
      if(done) {
        preventDefault(e);
      } else {
        Rails.fire(form, 'submit', input);
      }
    });
    form.addEventListener('ajax:success', function(e) {
      save.classList.add('has-text-success');
      input.classList.add('has-background-success');
      input.classList.add('is-static');
      input.setAttribute('readonly','');
      const done = true;
      console.log(done);
    });
    input.addEventListener('focusout', function clear(e) {
      if(!done) {
        console.log("focusout");
        console.log(done);
        input.value = value;
        input.classList.add('is-static');
        input.setAttribute('readonly','');
        edit.classList.remove('is-hidden');
        save.classList.add('is-hidden');
      }
    });
  });
}