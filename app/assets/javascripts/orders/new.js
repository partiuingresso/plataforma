//=require creditcard-warder/creditcard-warder.min

var cardInput = document.getElementById('card-number');
var imagesDiv = document.querySelector('.level-right.cards');
var images = imagesDiv.querySelectorAll('img');
var form = document.getElementsByTagName('form')[0];
var formInputs = document.querySelectorAll('input');
var complement = document.getElementById('payment_billing_address_complement');

// Seleciona bandeira do cartão
cardInput.addEventListener('input', function(e) {
  for(let img of images) {
    img.classList.remove("unselected");
  }
  var number = cardInput.value;
  var card = CreditcardWarder(number);
  var brand = card.getBrand();

  if(cardInput.value) {
    for(let img of images) {
      if(img.id != brand) {
        img.classList.add("unselected");
      } 
    }
  }
});

// Valida número do cartão
function validateCC() {
  var number = cardInput.value;
  var card = CreditcardWarder(number);
  var validate = card.validate();
  var brand = card.getBrand();

  if(!validate) {
    cardInput.classList.add('is-danger');
    cardInput.insertAdjacentHTML('afterend', '<span class="help checkout is-danger">Número de cartão inválido.</span>');
    cardInput.scrollIntoView({block: "end", behavior: "smooth"});

    return false
  }
  else if(brand == "other") {
    cardInput.classList.add('is-danger');
    cardInput.insertAdjacentHTML('afterend', '<span class="help checkout is-danger">Número de cartão inválido.</span>');
    cardInput.scrollIntoView({block: "end", behavior: "smooth"});

    return false
  }

  return true
}

// Valida os campos
function validateInputs() {
  var valid = true;
  for(let input of formInputs) {
    if(!input.value.length && !(input == complement) && !(input.type == "hidden") && !(input == cardInput)) {
      input.classList.add('is-danger');
      input.insertAdjacentHTML('afterend', '<span class="help checkout is-danger">Este campo é obrigatório.</span>');
      input.scrollIntoView({block: "end", behavior: "smooth"});
      valid = false;
    }
  }

  return valid
}

// Retira o help ao preencher
function cleanInputs() {
  for(let input of formInputs) {
    input.addEventListener('focusin', function() {
      var spanHelp = input.nextSibling;
      input.classList.remove('is-danger');
      spanHelp.classList.add('is-hidden');
    });
    input.addEventListener('focusout', function() {
      if(!input.value.length && !(input == complement)) {
        var spanHelp = input.nextSibling;
        input.classList.add('is-danger');
        spanHelp.classList.remove('is-hidden');
      }
    });
  }
}

// Submit
form.addEventListener('submit', function(e) {
  if(!validateCC() || !validateInputs()) {
    e.preventDefault();
    cleanInputs();
  }
});