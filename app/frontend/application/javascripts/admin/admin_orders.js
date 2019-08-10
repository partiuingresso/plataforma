import ordersIndex from '../my_orders'
import email from './email'
import ordersEdit from './admin_orders_edit'

export default {
	init() {
		ordersIndex.init()
		email.init()
		ordersEdit.init()
	}
}