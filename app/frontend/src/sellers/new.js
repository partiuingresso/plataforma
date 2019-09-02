export default {
	init()	{
		var brazilValues = require('brazilian-values')
		setEventHandlers()

		function setEventHandlers() {
			var phoneInputs = document.querySelectorAll('.phone-input')
			for(let input of phoneInputs) {
				input.addEventListener('input', function() {
					input.value = brazilValues.formatToPhone(input.value)
				})
			}

			var cpfInputs = document.querySelectorAll('.cpf-input')
			for(let input of cpfInputs) {
				input.addEventListener('input', function() {
					input.value = brazilValues.formatToCPF(input.value)
				})
			}

			var cnpjInputs = document.querySelectorAll('.cnpj-input')
			for(let input of cnpjInputs) {
				input.addEventListener('input', function() {
					input.value = brazilValues.formatToCNPJ(input.value)
				})
			}

			var cepInputs = document.querySelectorAll('.cep-input')
			for(let input of cepInputs) {
				input.addEventListener('input', function() {
					input.value = brazilValues.formatToCEP(input.value)
				})
			}
		}
	}
}

