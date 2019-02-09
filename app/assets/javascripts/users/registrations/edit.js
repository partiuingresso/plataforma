//= require utils/validation
//= require utils/input_mask

/*
 * Input masks
 */

cpfMask(document.getElementById('user_cpf'));

/*
 * Validations
 */

var cpfInput = document.getElementById('user_cpf');
cpfExists = inputFilled(cpfInput);

setValidateStyles('is-danger', 'active');

var form = document.getElementsByTagName('form')[0];
form.addEventListener('submit', function(event) {
	clearErrorStyles();


	var validate = validateNameField();
	validate = validateEmailField() && validate;
	validate = validateCpfField() && validate;
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

	if(inputFilled(nameInput)) {
		if(!validCompleteName(nameInput.value)) {
			var invalidNameError = document.getElementById('invalid_name_error');
			invalidInput(nameInput, invalidNameError);
			valid = false;
		}
	} else {
		var blankNameError = document.getElementById('blank_name_error');
		invalidInput(nameInput, blankNameError);
		valid = false;
	}

	return valid;
}

function validateEmailField() {
	var valid = true;
	var emailInput = document.getElementById('user_email');

	if(inputFilled(emailInput)) {
		if(!validEmail(emailInput.value)) {
			var invalidEmailError = document.getElementById('invalid_email_error');
			invalidInput(emailInput, invalidEmailError);
			valid = false;
		}
	} else {
		var blankEmailError = document.getElementById('blank_email_error');
		invalidInput(emailInput, blankEmailError);
		valid = false;
	}

	return valid;
}

function validateCpfField() {
	var valid = true;
	if(inputFilled(cpfInput)) {
		const expression = /^[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}$/i;
		if(!expression.test(cpfInput.value)) {
			var invalidCpfError = document.getElementById('invalid_cpf_error');
			invalidInput(cpfInput, invalidCpfError);
			valid = false;
		}
	} else if(cpfExists) {
		var blankCpfError = document.getElementById('blank_cpf_error');
		invalidInput(cpfInput, blankCpfError);
		valid = false;
	}

	return valid;
}

function validatePasswordField() {
	var passwordInput = document.getElementById('user_current_password');
	var blankPasswordError = document.getElementById('blank_current_password_error');

	if(!inputFilled(passwordInput)) {
		invalidInput(passwordInput, blankPasswordError);

		return false;
	}

	return true;
}
