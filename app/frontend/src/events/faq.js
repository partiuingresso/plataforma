export default {
  init() {
    var faqItem = document.querySelectorAll('.faqItem')
    if(faqItem) {
      for(let i of faqItem) {
        i.querySelector('.question').addEventListener('click', function(e) {
          if(i.classList.contains('active')) {
            i.classList.remove('active')
            var answear = i.querySelector('.answear')
            answear.className = 'answear'
          }
          else {
            i.classList.add('active')
            var answear = i.querySelector('.answear')
            answear.className = 'answear'
          }
        })
      }
    }
  }
}