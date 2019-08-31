import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import ProducerRegistrationWizard from 'components/producer_registration_wizard.vue'

Vue.use(Vuelidate)

document.addEventListener('DOMContentLoaded', () => {
	new Vue({
		el: '[data-behavior="vue"]',
		components: {
			'producer-registration-wizard': ProducerRegistrationWizard
		}
	})
})
