export default {
	init() {
		var total = 0
		setEventHandlers()

		function setEventHandlers() {
			var orderForm = document.getElementById('new_order')
			var orderInputs = orderForm.querySelectorAll('input.quantity-input')
			var calculateTotal = function() {
				let total = 0
				for(let input of orderInputs) {
					total += input.value * Number(input.dataset.price)
				}

				return total
			}

			var plus = document.querySelectorAll('.plus')
			var minus = document.querySelectorAll('.minus')
			var totalPrice = document.getElementById('total_price')

			for(let button of plus) {
				button.addEventListener('click', function(e) {
				var quantityView = button.parentElement.querySelector('.quantity')
				var number = Number(quantityView.innerHTML)
				var hiddenInput = quantityView.previousElementSibling
				var max = Number(hiddenInput.dataset.max)
				if(number < max) {
					number++
					quantityView.innerHTML = number
					hiddenInput.value = number
					let total = calculateTotal().toFixed(2)
					totalPrice.innerText = total.toString(10).replace(".", ",")
				}
				})
			}

			for(let button of minus) {
				button.addEventListener('click', function(e) {
				var quantityView = button.parentElement.querySelector('.quantity')
				var number = Number(quantityView.innerHTML)
					if(number > 0) {
						number--
						quantityView.innerHTML = number
						var hiddenInput = quantityView.previousElementSibling
						hiddenInput.value = number
						let total = calculateTotal().toFixed(2)
						totalPrice.innerText = total.toString(10).replace(".", ",")
					}
				})
			}
		}
	}
}
