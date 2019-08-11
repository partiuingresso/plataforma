import Vue from 'vue/dist/vue.esm'
import TicketManager from 'components/ticket_manager.vue'

document.addEventListener('DOMContentLoaded', () => {
	new Vue({
		el: '[data-behavior="vue"]',
		components: {
			'ticket-manager': TicketManager
		}
	})
})
