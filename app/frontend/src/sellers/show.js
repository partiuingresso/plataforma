import SimpleMaskMoney from 'simple-mask-money';

export default {
	init() {
		setEventHandlers();

		SimpleMaskMoney.args = {
		    allowNegative: false,
		    negativeSignAfter: false,
		    prefix: 'R$',
		    suffix: '',
		    fixed: true,
		    fractionDigits: 2,
		    decimalSeparator: ',',
		    thousandsSeparator: '.',
		    cursor: 'move'
		};


		var priceInputList = document.querySelectorAll('.price-input');
		for(let input of priceInputList) {
			input.value = SimpleMaskMoney.format(input.value);
			SimpleMaskMoney.setMask(input);
		}

		function setEventHandlers() {
			var newTransferButton = document.getElementById('new-transfer-button');
			var closeModalControls = document.querySelectorAll('.close-modal');
			newTransferButton.addEventListener('click', function() {
				showModal();
			});

			for(let control of closeModalControls) {
				control.addEventListener('click', function() {
					closeModal();
				});
			}
		}

		function showModal() {
			var modal = document.querySelector('.modal');
			var html = document.querySelector('html');
			modal.classList.add('is-active');
			html.classList.add('is-clipped');
		}

		function closeModal() {
			var modal = document.querySelector('.modal');
			var html = document.querySelector('html');
			modal.classList.remove('is-active');
			html.classList.remove('is-clipped');
		}
	}
}
