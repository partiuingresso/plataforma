//= require Chart.bundle
//= require chartkick


// Tabs
function openTab(evt, tabName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" is-active", "");
    }
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " is-active";
}

window.onload = function() {
  var mybtn = document.getElementsByClassName("tablinks")[0];
  mybtn.click();
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