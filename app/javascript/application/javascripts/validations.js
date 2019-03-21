import Rails from 'rails-ujs';

import QrScanner from 'qr-scanner';
import QrScannerWorkerPath from '!!file-loader!../../../../node_modules/qr-scanner/qr-scanner-worker.min.js';
QrScanner.WORKER_PATH = QrScannerWorkerPath;

var form = document.getElementById('new_validation');
var ticketCodeInput = document.getElementById('ticket_token_code');

var videoElem = document.getElementById('qr-video');
const qrScanner = new QrScanner(videoElem, result => qrCodeScanned(result));
qrScanner.setInversionMode("both");
qrScanner.start();

var validated = false;
var hold = false;

function qrCodeScanned(result) {
	if(!(validated || hold)) {
		hold = true;
		var resultElem = document.getElementById('validation-result');
		resultElem.innerText = "Validação feita com sucesso: " + result;
		ticketCodeInput.value = result;
		// Rails.fire(form, 'submit');
	}
}

form.addEventListener('ajax:success', function(e) {
	var resultElem = document.getElementById('validation-result');
	resultElem.innerText = "Validação feita com sucesso!!!!!";
	var [data, status, xhr] = e.detail
	console.log('data: ', data);
	console.log('status: ', status);
	console.log('xhr: ', xhr);
	// console.log(e.detail);
	validated = true;
	hold = false;
});

var button = document.getElementById("clean-validation");
button.addEventListener('click', function() {
	var resultElem = document.getElementById('validation-result');
	resultElem.innerText = "";
	hold = false;
});
