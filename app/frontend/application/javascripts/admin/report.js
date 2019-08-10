import adminOrders from '../my_orders'

export default {
	init() {
	    var tablinks = document.getElementsByClassName("tablinks")
	    tablinks[0].click()
	    adminOrders.init()
	}
}
