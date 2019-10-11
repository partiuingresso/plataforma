<template>
	<div>
		<h1>Certo, {{ first_name }}!</h1>
		<p>
			Qual é o <b>Nome Fantasia</b> de sua empresa? <br />
			Esta informação aparecerá nas comunicações oficiais do seu evento.
		</p>
		<input
			v-model.lazy="$v.name.$model"
			:placeholder="`Ex: ${first_name} Produções`"
		/>
		<div v-if="$v.name.$error" class="error active">Campo obrigatório</div>
		<a @click="next" class="nextButton">Avançar -></a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
import { required } from 'vuelidate/lib/validators'
export default {
	extends: WizardView,
	props: ['first_name'],
	data() {
		return {
			name: ''
		}
	},
	validations: {
		name: {
			required
		}
	},
	created() {
		this.data.company = {
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
	},
	methods: {
		next() {
			this.$v.$touch()
			if(!this.$v.$invalid) {
				this.data.company.name = this.name
				this.$router.push({ name: 'company_legal_information' })
			}
		}
	}
}
</script>

<style lang="scss" scoped>
div {
	.error {
		margin-top: -40px;
    margin-bottom: 20px;
    padding-top: 10px;
	}
	input {
		margin-top: 50px;
		margin-bottom: 40px;
		padding: 10px 0;
		border-bottom: 3px solid #C72328;
		border-style: none none solid none;
		width: 100%;
		font-weight: normal;
		font-size: 20px;
		line-height: 20px;
		color: #ffffff;
		background-color: transparent;
		&::placeholder {
			font-weight: normal;
			color: rgba(255, 255, 255, 0.4);
		}
	}
}
</style>