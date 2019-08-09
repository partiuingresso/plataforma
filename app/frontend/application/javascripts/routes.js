export default [
	{ page: 'login', module: './users/new' },
	{ page: 'users-edit', module: './users/edit' },
	{ page: ['events-new', 'events-edit'], module: './events/new' },
	{ page: 'events-ads', module: './events/ads' },
	{ page: 'events-show', module: './events/show' },
	{ page: 'events-index', module: './events/index' },
	{ page: 'checkout', module: './orders.js.erb' },
	{ page: 'backstage', module: './admin/producer' },
	{ page: 'companies-new', module: './companies/new' },
	{ page: 'companies-show', module: './companies/show' },
	{ page: 'orders-index', module: './my_orders' },
	{ page: 'admin-dashboard', module: './admin/admin' },
	{ page: 'admin-orders', module: './admin/admin_orders' },
	{ page: 'admin-users', module: './admin/admin_users' },
	{ page: 'report', module: './admin/report' },
	{ page: 'checkin', module: './checkin.js.erb' },
	{ page: 'tickets', module: './ticket_tokens' }
]
