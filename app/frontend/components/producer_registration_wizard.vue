<template>
	<div>
		<router-view :data="account" @finish="submit"></router-view>
	</div>
</template>

<script>
import Rails from 'rails-ujs'
import toFormData from 'src/utils/form_data'
import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import Welcome from 'components/producer_registration/welcome.vue'
import IdentifiationType from 'components/producer_registration/identification_type.vue'
import PersonalInformation from 'components/producer_registration/personal_information.vue'
import CompanyFantasyName from 'components/producer_registration/company_fantasy_name.vue'
import CompanyLegalInformation from 'components/producer_registration/company_legal_information.vue'
import CompanyAddress from 'components/producer_registration/company_address.vue'
import Contacts from 'components/producer_registration/contacts.vue'

Vue.use(VueRouter)

const routes = [
	{
		path: '/',
		name: 'welcome',
		component: Welcome
	},
	{
		path: '/identification_type',
		name: 'identification_type',
		component: IdentifiationType
	},
	{
		path: '/personal_information/:type',
		name: 'personal_information',
		component: PersonalInformation,
		props: true
	},
	{
		path: '/company/fantasy_name',
		name: 'company_fantasy_name',
		component: CompanyFantasyName
	},
	{
		path: '/company/legal_information',
		name: 'company_legal_information',
		component: CompanyLegalInformation
	},
	{
		path: '/company/address',
		name: 'company_address',
		component: CompanyAddress
	},
	{
		path: '/contacts/:type',
		name: 'contacts',
		component: Contacts,
		props: true
	}
]

const router = new VueRouter({
	routes,
	mode: 'abstract'
})

export default {
	router,
	data() {
		return {
			account: {
				name: '',
				email: '',
				document_number: '',
				birthdate: '',
				phone: '',
				address: {
					zipcode: '',
					address: '',
					number: '',
					complement: '',
					district: '',
					city: '',
					state: ''
				},
				company: {
					name: '',
					business_name: '',
					document_number: '',
					phone: '',
					show_phone: '',
					help_email: '',
					address: {
						zipcode: '',
						address: '',
						number: '',
						complement: '',
						district: '',
						city: '',
						state: ''
					}
				}
			}
		}
	},
	created() {
		this.$router.replace('/')
	},
	methods: {
		submit() {
			const formData = toFormData({ obj: this.account, namespace: 'account' })
			Rails.ajax({
				url: '/companies',
				type: 'post',
				data: formData
			})
		}
	}
}
</script>
