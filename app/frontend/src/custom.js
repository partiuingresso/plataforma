var dropdownLink = document.querySelector('.navDroplink')
var dropdown = document.querySelector('.navDropdown')

var toggleDropdown = function(e) {
  if(dropdown.classList.contains('show')) {
    dropdown.classList.remove('show')
  } else {
    dropdown.classList.add('show')
  }
}

var hideDropdown = function(e) {
  if (e.target != dropdownLink && !dropdownLink.contains(e.target) && !dropdown.contains(e.target)) {
    if (dropdown.classList.contains('show')) {
      dropdown.classList.remove('show')
    }
    else {
      return
    }
  }
}

if(dropdownLink) {
  dropdownLink.addEventListener('click', toggleDropdown)
  document.addEventListener('click', hideDropdown)
}