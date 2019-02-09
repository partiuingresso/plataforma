
function cpfMask(inputElement) {

	inputElement.addEventListener('input', function(event) {
		const cpfLength = 14;
		const dotSeparator = '.';
		const digitSeparator = '-';
		var inputString = inputElement.value;
		var finalString = inputString.slice(0, -1);
		var lastChar = inputString[inputString.length - 1];
		if(inputString.length <= cpfLength) {
			if(inputString.length > 0 && inputString.length % 4 == 0) {
				var separator = inputString.length <= 8 ? dotSeparator : digitSeparator;
				finalString += separator;
			}
			if(!isNaN(lastChar)) {
				finalString += lastChar;
			}
		}

		inputElement.value = finalString;
	});

	inputElement.addEventListener('paste', function(event) {
		let inputString = (event.clipboardData || window.clipboardData).getData('text');	
		const expression = /^[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}$/i;
		if(!expression.test(inputString)) {
			event.preventDefault();
		}
	});
}