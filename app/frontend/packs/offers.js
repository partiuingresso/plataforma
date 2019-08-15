import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import TicketManager from 'components/ticket_manager.vue'

Vue.use(Vuelidate)

document.addEventListener('DOMContentLoaded', () => {
	new Vue({
		el: '[data-behavior="vue"]',
		components: {
			'ticket-manager': TicketManager
		}
	})
})
