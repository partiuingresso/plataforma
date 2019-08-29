import './colors-ads'
import '../carousel.js.erb'
import cart from './cart'
import modal from './modal-ads'

export default {
	init() {
		cart.init()
		modal.init()
	}
}