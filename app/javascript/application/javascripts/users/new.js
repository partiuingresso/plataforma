import * as Validation from "../utils/validation";

/*
 * Validations
 */


Validation.setValidateStyles('is-danger', 'active');

var form = document.getElementsByTagName('form')[0];
form.addEventListener('submit', function(event) {
	Validation.clearErrorStyles();

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

function validateNameField() {
	var valid = true;
	var nameInput = document.getElementById('user_name');

	if(Validation.inputFilled(nameInput)) {
		if(!Validation.validCompleteName(nameInput.value)) {
			var invalidNameError = document.getElementById('invalid_name_error');
			Validation.invalidInput(nameInput, invalidNameError);
			valid = false;
		}
	} else {
		var blankNameError = document.getElementById('blank_name_error');
		Validation.invalidInput(nameInput, blankNameError);
		valid = false;
	}

	return valid;
}

function validateEmailField() {
	var valid = true;
	var emailInput = document.getElementById('user_email');

	if(Validation.inputFilled(emailInput)) {
		if(!Validation.validEmail(emailInput.value)) {
			var invalidEmailError = document.getElementById('invalid_email_error');
			Validation.invalidInput(emailInput, invalidEmailError);
			valid = false;
		}
	} else {
		var blankEmailError = document.getElementById('blank_email_error');
		Validation.invalidInput(emailInput, blankEmailError);
		valid = false;
	}

	return valid;
}

function validatePasswordField() {
	var valid = true;
	var passwordInput = document.getElementById('user_password');

	if(Validation.inputFilled(passwordInput)) {
		if(!Validation.validPassword(passwordInput.value)) {
			var invalidPasswordError = document.getElementById('invalid_password_error');
			Validation.invalidInput(passwordInput, invalidPasswordError);
			valid = false;
		}
	} else {
		var blankPasswordError = document.getElementById('blank_password_error');
		Validation.invalidInput(passwordInput, blankPasswordError);
		valid = false;
	}

	return valid;
}
