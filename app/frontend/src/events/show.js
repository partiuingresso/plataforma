import './colors'
import modal from './modal'
import '../carousel.js.erb'
import cart from './cart'
import cartInfo from './cart-info'
import faq from './faq'
import read from './read-more'

export default {
	init()	{
    faq.init()
    read.init()
    cartInfo.init()
		// modal.init()
		cart.init()
	}
}
