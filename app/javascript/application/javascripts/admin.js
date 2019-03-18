import { openTab } from "./tabs";
window.openTab = openTab;

// Show balance
window.onload = function() {
  showBalance();
  var mybtn = document.getElementsByClassName("tablinks")[0];
  mybtn.click();
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