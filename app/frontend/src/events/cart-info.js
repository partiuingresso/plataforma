export default {
  init() {
    var moreInfo = document.querySelectorAll('.moreInfo')
    if(moreInfo) {
      for(let i of moreInfo) {
        i.querySelector('.buttonInfo').addEventListener('click', function(e) {
          if(i.classList.contains('active')) {
            i.classList.remove('active')
            i.parentElement.style.cssText = 'padding-bottom: unset'
          } else {
            i.classList.add('active')
            var width = i.parentElement.offsetWidth
            i.querySelector('.description').style.cssText = 'width: '+ width +'px'
            var height = i.querySelector('.description').offsetHeight + 16
            i.parentElement.style.cssText = 'padding-bottom: ' + height + 'px'
          }
        })
      }
    }
    var sellingInfo = document.querySelector('.sellingInfo')
    var details = document.querySelector('.details')
    var detailsPosition = details.getBoundingClientRect().y
    document.addEventListener('scroll', function(e) {
      var scrollOffset = window.pageYOffset
      if(scrollOffset >= detailsPosition) {
        sellingInfo.classList.remove('closed')
      } else {
        sellingInfo.classList.add('closed')
      }
    })
  }
}