
var file = document.getElementById("event_image");
file.onchange = function(){
    if(file.files.length > 0)
    {
		document.getElementById('filename').innerHTML = file.files[0].name;
    }
};

var offerButton = document.getElementById('offer-button');
var cancelButton = document.getElementById('cancel-button');
var modal = document.getElementById('new-offer-modal');
var background = modal.querySelector('.modal-background');
var html = document.querySelector('html');
offerButton.addEventListener('click', function(e) {
	if(offerFields) {
		offers.appendChild(offerFields);
	}
	modal.classList.add('is-active');
	html.classList.add('is-clipped');
});

cancelButton.addEventListener('click', function(e) {
	if(offerFields) {
		offerFields.remove();
	}
	closeModal();
});

var closeButton = modal.querySelector('.delete');
closeButton.addEventListener('click', function(e) {
	if(offerFields) {
		offerFields.remove();
	}
	closeModal();
});

background.addEventListener('click', function(e) {
	closeModal();
});

var table = document.getElementById('offers-table');
var tableBody = table.querySelector('tbody');
var prototypeRow = tableBody.querySelector('.prototype-row');

table.style.display = 'none';

var index = 0;
var offerFieldsPrototype = modal.querySelector('.offer-fields').cloneNode(true);

var createOfferButton = document.getElementById('create-offer-button');
createOfferButton.addEventListener('click', function(e) {
	var nameInput = modal.querySelector('.name-input');
	var priceInput = modal.querySelector('.price-input');
	var quantityInput = modal.querySelector('.quantity-input');
	addOfferRow(nameInput.value, priceInput.value, quantityInput.value);

	var offerFields = modal.querySelector('.offer-fields');
	offerFields.remove();
	var hiddenFields = document.querySelector('.hidden-fields');
	hiddenFields.appendChild(offerFields);

	newOfferFields();

	closeModal();
});

var offers = modal.querySelector('.offers');
var offerFields;

function closeModal() {
	modal.classList.remove('is-active');
	html.classList.remove('is-clipped');
}

function newOfferFields() {
	index += 1;
	offerFields = offerFieldsPrototype.cloneNode(true);

	var fields = offerFields.querySelectorAll('input, textarea');
	for(let field of fields) {
		field.name = field.name.replace(/\[\d\]/, '[' + index + ']');
	}
}

function addOfferRow(name, price, quantity) {
	var newRow = prototypeRow.cloneNode(true);
	newRow.classList.remove('prototype-row');
	var nameCell = newRow.querySelector('.name-cell');
	var priceCell = newRow.querySelector('.price-cell');
	var quantityCell = newRow.querySelector('.quantity-cell');
	nameCell.innerText = name;
	priceCell.innerText = price;
	quantityCell.innerText = quantity;
	tableBody.appendChild(newRow);
	table.style.display = '';
}

