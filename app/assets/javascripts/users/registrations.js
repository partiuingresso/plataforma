var form = document.getElementsByTagName('form')[0];
form.addEventListener('submit', function(event) {
	cleanErrorStyles();

	var validate = validateNameField();
	validate = validateEmailField() && validate;
	validate = validatePasswordField() && validate;
	if(!validate) {
		event.preventDefault();
	} else {
		var button = document.querySelector('form button');
		button.innerHTML = "<i class='fa fa-spinner fa-spin'></i> Aguarde...";
		button.disabled = true;
	}
});

function inputInvalid(inputElement, spanElement) {
		inputElement.classList.add('is-danger');
		spanElement.classList.add('active');
}

function validateInputNotBlank(inputElement) {
	// Validates not blank.
	return Boolean(inputElement.value.trim());
}

function validateNameField() {
	var valid = true;
	var nameInput = document.getElementById('user_name');
	if(validateInputNotBlank(nameInput)) {
		// Validates name format.
		let expression = /^[a-z]{2,}(?:\s+[a-z]+\.?)*\s+[a-z]{2,}\.?(?:\s+[a-z]+\.?)*$/i;
		if(!expression.test(nameInput.value)) {
			var invalidNameError = document.getElementById('invalid_name_error');
			inputInvalid(nameInput, invalidNameError);

			valid = false;
		}
	} else {
		var blankNameError = document.getElementById('blank_name_error');
		inputInvalid(nameInput, blankNameError);

		valid = false;
	}

	return valid;
}

function validateEmailField() {
	var valid = true;
	var emailInput = document.getElementById('user_email');
	if(validateInputNotBlank(emailInput)) {
		// Validates email format.
		const expression = /(?!.*\.{2})^([a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+(\.[a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+)*|"((([ \t]*\r\n)?[ \t]+)?([\x01-\x08\x0b\x0c\x0e-\x1f\x7f\x21\x23-\x5b\x5d-\x7e\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|\\[\x01-\x09\x0b\x0c\x0d-\x7f\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))*(([ \t]*\r\n)?[ \t]+)?")@(([a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.)+([a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.?$/i;
		if(!expression.test(emailInput.value)) {
			var invalidEmailError = document.getElementById('invalid_email_error');
			inputInvalid(emailInput, invalidEmailError);

			valid = false;
		}
	} else {
		var blankEmailError = document.getElementById('blank_email_error');
		inputInvalid(emailInput, blankEmailError);

		valid = false;
	}

	return valid;
}

function validatePasswordField() {
	var valid = true;
	var passwordInput = document.getElementById('user_password');
	if(validateInputNotBlank(passwordInput)) {
		if(passwordInput.value.length < 8) {
			var invalidPasswordError = document.getElementById('invalid_password_error');
			inputInvalid(passwordInput, invalidPasswordError);

			valid = false;
		}
	} else {
		var blankPasswordError = document.getElementById('blank_password_error');
		inputInvalid(passwordInput, blankPasswordError);

		valid = false;
	}

	return valid;
}

function cleanErrorStyles() {
	var isDangerElements = Array.from(document.getElementsByClassName('is-danger'));
	var errorActiveElemeents = Array.from(document.querySelectorAll('.error.active'));

	for(let element of isDangerElements) {
		element.classList.remove('is-danger');
	}

	for(let element of errorActiveElemeents) {
		element.classList.remove('active');
	}
}
