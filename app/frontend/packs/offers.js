import Vue from 'vue/dist/vue.esm'
import TicketManager from 'components/ticket_manager/ticket_manager.js.erb'
import ConfirmDialog from 'components/confirm_dialog.vue'
import TicketForm from 'components/ticket_form.vue'

document.addEventListener('DOMContentLoaded', () => {
	new Vue({
		el: '[data-behavior="vue"]',
		components: {
			'ticket-manager': TicketManager
		}
	})
})
