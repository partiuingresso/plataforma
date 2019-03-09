init();

function init() {
	total = 0;
	setEventHandlers();
}

function setEventHandlers() {
	var orderForm = document.getElementById('new_order');
	var orderInputs = orderForm.querySelectorAll('input.quantity-input');
	var calculateTotal = function() {
		let total = 0;
		for(let input of orderInputs) {
			total += input.value * Number(input.dataset.price);
		}

		return total;
	};

	var plus = document.querySelectorAll('.button.plus');
	var minus = document.querySelectorAll('.button.minus');
	var totalPrice = document.getElementById('total_price');

	for(let button of plus) {
		button.addEventListener('click', function(e) {
		var buttonParent = button.parentElement;
		var divSibling = buttonParent.previousElementSibling;
		var quantityView = divSibling.querySelector('.quantity-view');
		var number = quantityView.innerHTML;
		var hiddenInput = divSibling.querySelector('.quantity-input');
		var max = hiddenInput.dataset.max;
		if(number < max) {
			number++;
			quantityView.innerHTML = number;
			hiddenInput.value = number;
			let total = calculateTotal().toFixed(2);
			totalPrice.innerText = total.toString(10).replace(".", ",");
		}
		});
	}

	for(let button of minus) {
		button.addEventListener('click', function(e) {
		var buttonParent = button.parentElement;
		var divSibling = buttonParent.nextElementSibling;
		var quantityView = divSibling.querySelector('.quantity-view');
		var number = quantityView.innerHTML;
			if(number > 0) {
				number--;
				quantityView.innerHTML = number;
				var hiddenInput = divSibling.querySelector('.quantity-input');
				hiddenInput.value = number;
				let total = calculateTotal().toFixed(2);
				totalPrice.innerText = total.toString(10).replace(".", ",");
			}
		});
	}
}

