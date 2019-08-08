window.onload = function() {
    var tablinks = document.getElementsByClassName("tablinks");
    tablinks[0].click();

    var table = { rows: document.getElementsByClassName('clickable-row') };
    for(let row of table.rows) {
		row.addEventListener('click', function(event) {
			window.location = this.dataset.href;
		})
    }
}
