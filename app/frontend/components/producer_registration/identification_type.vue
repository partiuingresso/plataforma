<template>
	<div>
		<h1>Identificação</h1>
		<p>Você gostaria de utilizar a <strong>PartiuIngresso.com</strong> para publicar seus eventos e receber pagamentos como...</p>
		<a @click="personal" class="selectButton">Pessoa Física</a>
		<a @click="company" class="selectButton">Pessoa Jurídica</a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
export default {
	extends: WizardView,
	methods: {
		personal() {
			delete this.data.company
			this.$router.push({ name: 'personal_information', params: { type: 'personal' } })
		},
		company() {
			this.data.company = this.buildCompany()
			this.$router.push({ name: 'company_fantasy_name' })
		},
		buildCompany() {
			return {
				name: '',
				business_name: '',
				document_number: '',
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
}
</script>

<style lang="scss" scoped>
	div {
		.selectButton {
			margin-top: 60px;
			display: inline-block;
			width: 240px;
			border: 3px solid #C72328;
			border-radius: 10px;
			padding: 20px 0;
			text-align: center;
			font-weight: 600;
			font-size: 20px;
			line-height: 20px;
			color: #ffffff;
	    transition: background-color 250ms ease;
	    outline: none;
			&:hover, &:focus { background-color: #C72328; }
			&:first-of-type { margin-right: 40px; }
		}
	}
</style>