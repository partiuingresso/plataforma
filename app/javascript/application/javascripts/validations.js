import Rails from 'rails-ujs';

import QrScanner from 'qr-scanner';
import QrScannerWorkerPath from '!!file-loader!../../../../node_modules/qr-scanner/qr-scanner-worker.min.js';
QrScanner.WORKER_PATH = QrScannerWorkerPath;

var form = document.getElementById('new_validation');
var ticketCodeInput = document.getElementById('ticket_token_code');

var qrScanner;
initScanner();

var validated = false;
var hold = false;

var button = document.getElementById("open-camera");
button.addEventListener('click', function() {
	startScanner();
});

form.addEventListener('ajax:success', function(e) {
	var resultElem = document.getElementById('validation-result');
	resultElem.innerText = "Validação feita com sucesso!!!!!";
	var [data, status, xhr] = e.detail
	console.log('data: ', data);
	console.log('status: ', status);
	console.log('xhr: ', xhr);
	validated = true;
	hold = false;
});

function initScanner() {
	var videoElem = document.getElementById('qr-video');
	qrScanner = new QrScanner(videoElem, result => qrCodeScanned(result));
	qrScanner.setInversionMode("both");
}

function resetScanner() {
	qrScanner.stop();
	qrScanner._qrWorker.terminate();
	initScanner();
}

function startScanner() {
	qrScanner.start();
}

function qrCodeScanned(result) {
	if(!(validated || hold)) {
		hold = true;
		var resultElem = document.getElementById('validation-result');
		resultElem.innerText = "Validação feita com sucesso: " + result + " -> " + Date().toString();
		ticketCodeInput.value = result;
		resetScanner();
		// Rails.fire(form, 'submit');
		hold = false;
	}
}

