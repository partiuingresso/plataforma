//=require creditcard-warder/creditcard-warder.min


var input = document.getElementById('card-number');
var imagesDiv = document.querySelector('.level-right.cards');
var images = imagesDiv.querySelectorAll('img');

input.addEventListener('input', function(e) { 
  for(let img of images) {
    img.classList.remove("unselected");
  }
  var number = input.value;
  var card = CreditcardWarder(number);
  var brand = card.getBrand();

  if(input.value) {
    for(let img of images) {
      if(img.id != brand) {
        img.classList.add("unselected");
      } 
    }
  }
});

var form = document.getElementsByTagName('form')[0];
form.addEventListener('submit', function(event) {
  var number = input.value;
  var card = CreditcardWarder(number);
  var validate = card.validate();
  var brand = card.getBrand();

  if(!validate) {
    event.preventDefault();
    var help = document.getElementById('cardHelp');
    help.classList.remove('is-hidden');
    input.classList.add('is-danger');
    input.scrollIntoView({block: "end", behavior: "smooth"});
  }
  else if(brand == "other") {
    event.preventDefault();
    var help = document.getElementById('cardHelp');
    help.classList.remove('is-hidden');
    input.classList.add('is-danger');
    input.scrollIntoView({block: "end", behavior: "smooth"});

  }
});


