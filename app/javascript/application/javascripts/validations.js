import Rails from 'rails-ujs';

/*
 *
 * This module depends on Instascan library, which is included in new_validation.html 
 * template using asset pipeline.
 *
 */

var scanner = new Instascan.Scanner({
	video: document.getElementById('qr-video'),
	mirror: false,
	backgroundScan: false
});

scanner.addListener('scan', function(content) {
	var resultElem = document.getElementById('validation-result');
	resultElem.innerText = "Validação feita com sucesso: " + content + " -> " + Date().toString();
	var input = document.getElementById('ticket_token_code');
	input.value = content;
});

Instascan.Camera.getCameras().then(function(cameras) {
	if(cameras.length > 0) {
		scanner.start(cameras[0]);
	} else {
		console.error('No cameras found');
	}
}).catch(function(e){
	console.error(e);
});
