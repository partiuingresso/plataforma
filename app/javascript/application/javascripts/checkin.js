import './qrscanner.js.erb';

var modal = document.getElementById('modal');
var newValidationBody = document.getElementById('new-validation');
var successValidationBody = document.getElementById('success-validation');
var errorValidationBody = document.getElementById('error-validation');

var links = document.querySelectorAll('.validate-link');
for(let link of links) {
	link.addEventListener('ajax:success', function(e) {
		initNewValidationModal();
	});
}

function initNewValidationModal() {
	var form = document.getElementById('new_validation');
	form.addEventListener('ajax:success', function(e) {
		closeModal();
	});

	var cancelButton = newValidationBody.querySelector('.button.cancel');
	cancelButton.addEventListener('click', function(e) {
		closeModal();
	});
}

function closeModal() {
	newValidationBody.classList.add('is-hidden');
	successValidationBody.classList.add('is-hidden');
	errorValidationBody.classList.add('is-hidden');
	modal.classList.add('is-hidden');
}
