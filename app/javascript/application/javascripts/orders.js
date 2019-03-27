import JSEncrypt from 'jsencrypt';
import { MoipCreditCard } from 'moip-sdk-js';
import cep from 'cep-promise';
import * as brazilValues from 'brazilian-values';
import paymentFormatter from 'payment-formatter';
import CreditcardWarder from '../../../../vendor/assets/javascript/creditcard-warder/creditcard-warder.min';

var installmentSelect = document.getElementById('order_form_payment_attributes_installment_count');
installmentSelect.addEventListener('change', function() {
	var selectedOption = installmentSelect.selectedOptions[0];
	var totalElement = document.getElementById('total');
	totalElement.innerText = selectedOption.dataset.price.toString(10);
});

const pubKey = `-----BEGIN PUBLIC KEY-----
				MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnofhltO5CDIwLXmAtvaP
			    mIX++JeopYEWdYaAy5SfOKqniWykWUS70Y9dJq9PuD8PwtXcAMP5hIzVWGx3brel
			    02HNDQ/ayhkkWtmPrjpWn+zpjC6SSK0taXEfHwTuVtABYfR1ALR3u4nXHjtFG2mj
			    srsNWDdCm3LiXH//AL0SYh5kv7C18ccTZdKQVv7NALaQor9Uh6HeMyNCsjZGStqS
			    Dzl56k3rdMa/gzV+B6YeGkFx6P6k7dEHzHvc6mhY2oFrPBRb0Dg30BwQy12pRKuc
			    JaCHbICrdX5ks5PQSU6i3HRjfY3sjj035xrNe6BEn0U7yb552X8NMWEAEpeclw2c
			    cwIDAQAB
			    -----END PUBLIC KEY-----`;

var form = document.getElementById('new_order_form');
var expirationDate = document.getElementById('expiration-date').value;

form.addEventListener('submit', function(e) {
	var cardNumberValue = document.getElementById('card-number').value;
	var cvcValue = document.getElementById('cvc').value;
	var expirationDate = document.getElementById('expiration-date').value.split('/');
	var expMonthValue = expirationDate[0];
	var expYearValue = expirationDate[1];

	MoipCreditCard
    .setEncrypter(JSEncrypt, 'node')
		.setPubKey(pubKey)
		.setCreditCard({
			number: cardNumberValue,
			cvc: cvcValue,
			expirationMonth: expMonthValue,
			expirationYear: expYearValue
		})
		.hash()
		.then(hash => {
			var hashInput = document.getElementById('order_form_payment_attributes_hash');
			hashInput.value = hash;
		});
});

var cardInput = document.getElementById('card-number');
var cvcInput = document.getElementById('cvc');
var expInput = document.getElementById('expiration-date');
var cpfInput = document.getElementById('order_form_payment_attributes_holder_document');
var celInput = document.getElementById('phone');
var zipInput = document.getElementById('order_form_payment_attributes_billing_address_attributes_zipcode');
var imagesDiv = document.querySelector('.level-right.cards');
var images = imagesDiv.querySelectorAll('img');
var form = document.getElementsByTagName('form')[0];
var formInputs = form.querySelectorAll('input, select');
var complement = document.getElementById('payment_billing_address_attributes_complement');
var streetInput = document.getElementById('order_form_payment_attributes_billing_address_attributes_address');
var districtInput = document.getElementById('order_form_payment_attributes_billing_address_attributes_district');
var cityInput = document.getElementById('order_form_payment_attributes_billing_address_attributes_city');
var stateInput = document.getElementById('order_form_payment_attributes_billing_address_attributes_state');
var numberInput = document.getElementById('order_form_payment_attributes_billing_address_attributes_number');
var addressInput = document.getElementById('address');

// Max length do input do cartão e cvv
cardInput.addEventListener('keypress', function(e) {
  if(cardInput.value.length == 16) {
    e.preventDefault();
  }
});
cvcInput.addEventListener('keypress', function(e) {
  if(cvcInput.value.length == 4) {
    e.preventDefault();
  }
});

// Masks e dica Validade do CC
expInput.addEventListener('focusin', function() {
  expInput.placeholder = "MM/AA";
});
expInput.addEventListener('focusout', function() {
  expInput.placeholder = "Validade";
});
paymentFormatter({
  inputType: 'expiry',
  selector: 'input#expiration-date'
});

// Mask do CPF
cpfInput.addEventListener('input', function() {
  cpfInput.value = brazilValues.formatToCPF(cpfInput.value);
});

// Mask do Telefone Cel
celInput.addEventListener('input', function() {
  celInput.value = brazilValues.formatToPhone(celInput.value);
});

// Mask do CEP
zipInput.addEventListener('input', function() {
  zipInput.value = brazilValues.formatToCEP(zipInput.value);
  if(zipInput.value.length == 9) {
    zipInput.parentElement.classList.add('is-loading');
    cepToAddress();
  }
});

// Pega o cep e popula
function cepToAddress() {
  cep(zipInput.value).then(function(result) {
    zipInput.parentElement.classList.remove('is-loading');
    addressInput.classList.remove('is-hidden');
    streetInput.value = result.street;
    districtInput.value = result.neighborhood;
    cityInput.value = result.city;
    stateInput.value = result.state;
    numberInput.focus();
  }, function() {
    zipInput.parentElement.classList.remove('is-loading');
    addressInput.classList.remove('is-hidden');
    streetInput.focus();
  });
}

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

  if(!validate || brand == "other") {
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
  var cpfValid = brazilValues.isCPF(cpfInput.value);
  for(let input of formInputs) {
    if(input.value.length === 0 && input !== complement && input.type !== "hidden" && input !== cardInput) {
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
    } else if((input === cpfInput) && (cpfInput.value.length >= 1) && !cpfValid) {
      var spanHelp = input.nextElementSibling;
      if(!spanHelp || !spanHelp.matches('.cpf')) {
        input.classList.add('is-danger');
        input.insertAdjacentHTML('afterend', '<span class="help checkout is-danger cpf">CPF inválido.</span>');
        input.scrollIntoView({block: "end", behavior: "smooth"});
      } else if(spanHelp.matches('.cpf')) {
        spanHelp.classList.remove('is-hidden');
      }
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
        if(input.value.length === 0 && input !== complement) {
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