//= require moip/moip-sdk-js

const pubKey = `-----BEGIN PUBLIC KEY-----
				MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnofhltO5CDIwLXmAtvaP
			    mIX++JeopYEWdYaAy5SfOKqniWykWUS70Y9dJq9PuD8PwtXcAMP5hIzVWGx3brel
			    02HNDQ/ayhkkWtmPrjpWn+zpjC6SSK0taXEfHwTuVtABYfR1ALR3u4nXHjtFG2mj
			    srsNWDdCm3LiXH//AL0SYh5kv7C18ccTZdKQVv7NALaQor9Uh6HeMyNCsjZGStqS
			    Dzl56k3rdMa/gzV+B6YeGkFx6P6k7dEHzHvc6mhY2oFrPBRb0Dg30BwQy12pRKuc
			    JaCHbICrdX5ks5PQSU6i3HRjfY3sjj035xrNe6BEn0U7yb552X8NMWEAEpeclw2c
			    cwIDAQAB
			    -----END PUBLIC KEY-----`;

var form = document.getElementById('new_order');
var expirationDate = document.getElementById('expiration-date').value;

form.addEventListener('submit', function(e) {
	var cardNumberValue = document.getElementById('card-number').value;
	var cvcValue = document.getElementById('cvc').value;
	var expirationDate = document.getElementById('expiration-date').value;
	var expMonthValue = new Date(expirationDate).getMonth();
	var expYearValue = new Date(expirationDate).getYear();

	MoipSdkJs.MoipCreditCard
		.setPubKey(pubKey)
		.setCreditCard({
			number: cardNumberValue,
			cvc: cvcValue,
			expirationMonth: expMonthValue,
			expirationYear: expYearValue
		})
		.hash()
		.then(hash => {
			var hashInput = document.getElementById('payment_hash');
			hashInput.value = hash;
		});
});
