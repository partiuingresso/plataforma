
var file = document.getElementById("event_image");
file.onchange = function(){
    if(file.files.length > 0)
    {
		document.getElementById('filename').innerHTML = file.files[0].name;
    }
};