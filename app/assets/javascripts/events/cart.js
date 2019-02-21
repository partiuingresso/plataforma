var orderForm = document.getElementById('new_order');
var totalPrice = document.getElementById('total_price');

init();

function init() {
	total = 0;
	setEventHandlers();
}

function setEventHandlers() {
	var orderInputs = orderForm.querySelectorAll('input.quantity-input');
	var calculateTotal = function() {
		let total = 0;
		for(let input of orderInputs) {
			total += input.value * Number(input.dataset.price);
		}

		return total;
	};

	for(let input of orderInputs) {
		input.addEventListener('input', function(e) {
			if(Number(input.value) < 0) {
				return;
			}
			let total = calculateTotal().toFixed(2);
			totalPrice.innerText = total.toString(10).replace(".", ",");
		});
	}
}
