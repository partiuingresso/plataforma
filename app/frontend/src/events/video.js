export default {
  init() {
    var videoButton = document.querySelector('.videoButton')
    var videoModal = document.querySelector('.videoModal')
    var backButton = document.querySelector('.videoModal > .video > .back')
    if(videoButton) {
      var video = document.getElementById('video')
      var videoSrc = videoButton.dataset.src
      if(videoSrc.includes('watch?v=')) {
        videoSrc = videoSrc.replace('watch?v=', 'embed/')
      } else if(videoSrc.includes('//vimeo')) {
        videoSrc = videoSrc.replace('//vimeo', '//player.vimeo')
        videoSrc = videoSrc.replace('.com/', '.com/video/')
      }
      videoButton.addEventListener('click', function(e) {
      	setTimeout(function(){ document.documentElement.classList.add('is-clipped') }, 600)
      	video.setAttribute('src',videoSrc + '?rel=0&amp;showinfo=0&amp;modestbranding=1&amp;autoplay=1')
        videoModal.className = 'videoModal active animated fadeIn faster'
        
      })
      backButton.addEventListener('click', function(e) {
        closeVideoModal()
      })
      document.addEventListener('keydown', function (event) {
        var e = event || window.event
        if (e.keyCode === 27) {
          closeVideoModal()
        }
      })
    }
    function closeVideoModal() {
      videoModal.className = 'videoModal'
      document.documentElement.classList.remove('is-clipped')
      video.setAttribute('src','')
    }
  }
}