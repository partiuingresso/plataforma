import './colors'
import video from './video'
import '../carousel.js.erb'
import cart from './cart'
import cartModal from './cart-modal'
import cartInfo from './cart-info'
import faq from './faq'
import read from './read-more'
import * as sharer from 'sharer.js'

export default {
	init()	{
    faq.init()
    read.init()
    cartInfo.init()
		video.init()
		cart.init()
    cartModal.init()
    Sharer.init()
	}
}
