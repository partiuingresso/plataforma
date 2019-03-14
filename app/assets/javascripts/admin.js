//= require Chart.bundle
//= require chartkick

// Show balance
window.onload = function() {
  showBalance();
}

function showBalance() {
  var showBtn = document.querySelector(".button.show");
  var hideBtn = document.querySelector(".button.hide");
  var balance = document.getElementById("balance");
  showBtn.addEventListener('click', function() {
    balance.classList.remove('blur');
    showBtn.classList.add('is-hidden');
    hideBtn.classList.remove('is-hidden');
  });
  hideBtn.addEventListener('click', function() {
    balance.classList.add('blur');
    showBtn.classList.remove('is-hidden');
    hideBtn.classList.add('is-hidden');
  });
}