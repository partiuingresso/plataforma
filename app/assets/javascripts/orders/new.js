//=require creditcard-warder/creditcard-warder.min
//=require brazilian-values/dist/brazilian-values.min
//=require payment-formatter/umd/index.min


var cardInput = document.getElementById('card-number');
var cvcInput = document.getElementById('cvc');
var expInput = document.getElementById('expiration-date');
var imagesDiv = document.querySelector('.level-right.cards');
var images = imagesDiv.querySelectorAll('img');
var form = document.getElementsByTagName('form')[0];
var formInputs = form.querySelectorAll('input, select');
var complement = document.getElementById('payment_billing_address_complement');


// Max length do input do cartão e cvv
cardInput.addEventListener('keypress', function() {
  if(cardInput.value.length == 16) {
    event.preventDefault();
  }
});
cvcInput.addEventListener('keypress', function() {
  if(cvcInput.value.length == 4) {
    event.preventDefault();
  }
});

// Masks
paymentFormatter({
  inputType: 'expiry',
  selector: 'input#expiration-date'
});


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
  var spanHelp = cardInput.nextElementSibling;

  if(!validate) {
    cardInput.classList.add('is-danger');
    spanHelp.classList.remove('is-hidden');
    cardInput.scrollIntoView({block: "end", behavior: "smooth"});

    return false
  }
  else if(brand == "other") {
    cardInput.classList.add('is-danger');
    spanHelp.classList.remove('is-hidden');
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
      if(input.matches('select')) {
        input.parentElement.classList.add('is-danger');
      } else {
        input.classList.add('is-danger');
      }
      var spanHelp = input.nextElementSibling;
      if(!spanHelp) {
        input.insertAdjacentHTML('afterend', '<span class="help checkout is-danger">Este campo é obrigatório.</span>');
      }
      input.scrollIntoView({block: "end", behavior: "smooth"});
      valid = false;
    }
  }

  return valid
}

// Retira o help ao preencher
function cleanInputs() {
  for(let input of formInputs) {
    if(input != complement) {
      input.addEventListener('focusin', function() {
        var spanHelp = input.nextElementSibling;
        spanHelp.classList.add('is-hidden');
        if(input.matches('select')) {
          input.parentElement.classList.remove('is-danger');
        } else {
          input.classList.remove('is-danger');
        }
      });
      input.addEventListener('focusout', function() {
        if(!input.value.length && !(input == complement)) {
          var spanHelp = input.nextElementSibling;
          spanHelp.classList.remove('is-hidden');
          if(input.matches('select')) {
            input.parentElement.classList.add('is-danger');
          } else {
            input.classList.add('is-danger');
          }
        }
      });
    }
  }
}

// Submit
form.addEventListener('submit', function(e) {
  if(!validateCC() || !validateInputs()) {
    e.preventDefault();
    cleanInputs();
  }
});