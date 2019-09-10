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

var searchMobile = document.querySelector('header.mobile > .search')

if(searchMobile) {
  var closeBtn = searchMobile.querySelector('span:last-of-type')
  searchMobile.addEventListener('click', function(e) {
    if(e.target != closeBtn) {
      searchMobile.classList.add('active')
      searchMobile.querySelector('.input').focus()
    }
  })
  closeBtn.addEventListener('click', function() {
    searchMobile.classList.remove('active')
  })
}