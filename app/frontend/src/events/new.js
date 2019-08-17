import 'trix'
export default {
	init() {
		var fileInputs = document.querySelectorAll(".file-input")
		for(let input of fileInputs) {
			input.onchange = function(){
			    if(input.files.length > 0)
			    {
					let filenameSpan = document.getElementById(this.dataset.target)
					filenameSpan.innerHTML = input.files[0].name
			    }
			}
		}
	}
}
