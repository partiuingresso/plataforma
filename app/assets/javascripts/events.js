var html = document.querySelector('html');
var modal = document.getElementById('new-offer-modal');
var table = document.getElementById('offers-table');
var prototypeRow = table.querySelector('.prototype-row');
var hiddenFields = document.querySelector('.hidden-fields');
var offerFieldsPrototype;

var newOffer;
var offerCount;

init();

function init() {
	offerCount = table.tBodies[0].rows.length - 1;
	if(offerCount == 0) {
		table.style.display = 'none';
	}
	offerFieldsPrototype = hiddenFields.querySelector('.empty-fields');
	hiddenFields.querySelector('.empty-fields').remove();

	newOffer = newOfferFields();

	setEventsHandlers();
}

function setEventsHandlers() {
	var file = document.getElementById("event_image");
	// 1. Image file input handler
	file.onchange = function(){
	    if(file.files.length > 0)
	    {
			document.getElementById('filename').innerHTML = file.files[0].name;
	    }
	};


	var addOfferButton = document.getElementById('offer-button');
	var modalForm = modal.querySelector('.modal-form');
	// 2. Add offer button handler
	addOfferButton.addEventListener('click', function(e) {
		modalForm.appendChild(newOffer);
		showModal();
	});

	var modalBackground = modal.querySelector('.modal-background');
	// 3. Modal background click handler
	modalBackground.addEventListener('click', function(e) {
		newOffer.remove();
		newOffer = newOfferFields();
		closeModal();
	});

	var closeButton = modal.querySelector('.delete');
	// 4. Close modal button handler
	closeButton.addEventListener('click', function(e) {
		newOffer.remove();
		newOffer = newOfferFields();
		closeModal();
	});

	var cancelButton = document.getElementById('cancel-button');
	// 5. Cancel offer creation button click handler
	cancelButton.addEventListener('click', function(e) {
		newOffer.remove();
		newOffer = newOfferFields();
		closeModal();
	});

	var newOfferButton = document.getElementById('create-offer-button');
	// 6. New offer button handler
	newOfferButton.addEventListener('click', function(e) {
		var nameInput = modal.querySelector('.name-input');
		var priceInput = modal.querySelector('.price-input');
		var quantityInput = modal.querySelector('.quantity-input');
		addOfferRow(nameInput.value, priceInput.value, quantityInput.value);

		var offer = modal.querySelector('.empty-fields');
		offer.remove();
		hiddenFields.appendChild(offer);

		closeModal();
		offerCount += 1;
		newOffer = newOfferFields();
	});
}

function showModal() {
	modal.classList.add('is-active');
	html.classList.add('is-clipped');
}

function closeModal() {
	modal.classList.remove('is-active');
	html.classList.remove('is-clipped');
}

function newOfferFields() {
	var offerFields = offerFieldsPrototype.cloneNode(true);

	var fields = offerFields.querySelectorAll('input, textarea');
	for(let field of fields) {
		field.name = field.name.replace(/\[\d\]/, '[' + offerCount + ']');
	}

	return offerFields;
}

function addOfferRow(name, price, quantity) {
	var newRow = prototypeRow.cloneNode(true);
	var nameCell = newRow.querySelector('.name-cell');
	var priceCell = newRow.querySelector('.price-cell');
	var quantityCell = newRow.querySelector('.quantity-cell');
	newRow.classList.remove('prototype-row');
	nameCell.innerText = name;
	priceCell.innerText = price;
	quantityCell.innerText = quantity;
	table.tBodies[0].appendChild(newRow);
	table.style.display = '';
}
