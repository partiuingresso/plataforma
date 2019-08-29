import './colors'
import modal from './modal'
import '../carousel.js.erb'
import cart from './cart'

export default {
	init()	{
		modal.init()
		cart.init()
	}
}
