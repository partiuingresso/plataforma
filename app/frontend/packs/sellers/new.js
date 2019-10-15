import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import autofocus from 'vue-autofocus-directive'
import ProducerRegistrationWizard from 'components/producer_registration_wizard.vue'

Vue.use(Vuelidate)
Vue.directive('autofocus', autofocus)

document.addEventListener('DOMContentLoaded', () => {
	new Vue({
		el: '[data-behavior="vue"]',
		components: {
			'producer-registration-wizard': ProducerRegistrationWizard
		}
	})
})
