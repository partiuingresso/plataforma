
var form = document.getElementsByTagName('form')[0];
var nameInput = document.getElementById('user_name');
var nameErrorSpan = document.getElementById('user_name_error');
var emailInput = document.getElementById('user_email');
var emailErrorSpan = document.getElementById('user_email_error');
var passwordInput = document.getElementById('user_password');
var passwordErrorSpan = document.getElementById('user_password_error');

var button = document.querySelector('form button');

form.addEventListener('submit', function(event) {
	cleanErrorStyles();

	validate = validateInput(nameInput, nameErrorSpan);
	validate = validateInput(emailInput, emailErrorSpan) && validate;
	validate = validateInput(passwordInput, passwordErrorSpan) && validate;

	if(!validate) {
		event.preventDefault();
	} else {
		button.innerHTML = "<i class='fa fa-spinner fa-spin'></i> Aguarde...";
		button.disabled = true;
	}
});

function validateInput(inputElement, spanElement) {
	// Validates not blank.
	if(!inputElement.value.trim()) {
		// Not valid.
		inputElement.classList.add('is-danger');
		spanElement.classList.add('active');

		return false;
	}

	return true;
}

function cleanErrorStyles() {
	nameInput.classList.remove('is-danger');
	nameErrorSpan.classList.remove('active');
	emailInput.classList.remove('is-danger');
	emailErrorSpan.classList.remove('active');
	passwordInput.classList.remove('is-danger');
	passwordErrorSpan.classList.remove('active');
}
