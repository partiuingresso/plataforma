var sendEmailInputs = document.getElementsByClassName('send-email-button');

for(let input of sendEmailInputs) {
	let form = input.parentElement;
	form.addEventListener('ajax:success', function(e) {
		input.classList.add('is-success');
		input.value = "Enviado";
		input.disabled = true;
	});
}
