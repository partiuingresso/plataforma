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

var menuMobileLink = document.querySelector('header.mobile > .myAccount > a')
var menuMobile = document.querySelector('header.mobile > .menu')
var html = document.querySelector('html')

var toggleMenuMobile = function(e) {
  if(menuMobileLink.classList.contains('active')) {
    menuMobileLink.classList.remove('active')
    menuMobile.className = 'menu'
    html.classList.remove('is-clipped')
  } else {
    menuMobileLink.classList.add('active')
    menuMobile.className = 'menu active'
    html.classList.add('is-clipped')
  }
}

if(menuMobileLink) {
  menuMobileLink.addEventListener('click', toggleMenuMobile)
}

console.log(menuMobile)