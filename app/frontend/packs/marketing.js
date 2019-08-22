import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import MarketingIntegrations from 'components/marketing_integrations.vue'

Vue.use(Vuelidate)

document.addEventListener('DOMContentLoaded', () => {
	new Vue({
		el: '[data-behavior="vue"]',
		components: {
			'marketing-integrations': MarketingIntegrations
		}
	})
})
