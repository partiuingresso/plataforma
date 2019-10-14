<template>
	<div>
		<h1>Contatos</h1>
		<p>Informe as melhores formas de entrar em contato com {{ this.type == 'company' ? 'seu negócio' : 'você' }}.</p>
		<input
			v-model.lazy="$v.phone.$model"
			placeholder="DDD + Telefone"
			v-mask="['(##) ####-####', '(##) #####-####']"
		/>
		<div v-show="$v.phone.$error">
			<div v-if="!$v.phone.required" class="error active">Campo obrigatório</div>
			<div v-if="!$v.phone.isPhone" class="error active">Campo inválido</div>
		</div>
		<label class="checkbox">
			<input v-model="show_phone" type="checkbox" />
			Deseja utilizar este número para realizar atendimento aos clientes?
		</label>
		<input
			placeholder="Endereço de e-mail"
			v-model.lazy="$v.help_email.$model"
		/>
		<div v-show="$v.help_email.$error">
			<div v-if="!$v.help_email.required" class="error active">Campo obrigatório</div>
			<div v-if="!$v.help_email.email" class="error active">Campo inválido</div>
		</div>
		<div class="warning">
			<b>Importante!</b>	Este endereço de e-mail será utilizado para o atendimento aos clientes. <br />
			Fique tranquilo! Você poderá alterar este contato quando quiser.
		</div>
		<a
			class="nextButton"
			v-if="type == 'company'"
			@click="next"
		>
			Avançar ->
		</a>
		<a v-else class="nextButton" @click="finish">Finanlizar -></a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
import { mask } from 'vue-the-mask'
import { helpers, required, email } from 'vuelidate/lib/validators'
const isPhone = helpers.regex('phone', /^\(\d{2}\)\s\d{4,5}-\d{4}$/)
export default {
	extends: WizardView,
	directives: {
		mask
	},
	data() {
		return {
			phone: '',
			show_phone: false,
			help_email: ''
		}
	},
	validations: {
		phone: {
			required,
			isPhone
		},
		help_email: {
			required,
			email
		}
	},
	methods: {
		finish() {
			this.$v.$touch()
			if(!this.$v.$invalid) {
				this.commit()
				this.finishButton()
			}
		},
		next() {
			this.$v.$touch()
			if(!this.$v.$invalid) {
				this.commit()
				this.$router.push({ name: 'personal_information' })	
			}
		},
		commit() {
			if(this.type === 'company') {
				this.data.company.phone = this.phone
			} else {
				this.data.phone = this.phone
			}
			Object.assign(this.data, {
				show_phone: this.show_phone,
				help_email: this.help_email
			})
		}
	}
}
</script>

<style lang="scss" scoped>
	div {
		p:first-of-type { margin-bottom: 50px; }
		.warning { margin-top: 12px; font-size: 14px; line-height: 18px; color: rgba(255, 255, 255, 0.75); }
		a.nextButton { margin-top: 50px; }
		label {
			margin-top: 12px;
			margin-bottom: 40px;
			color: rgba(255, 255, 255, 0.75);
			font-size: 14px;
			line-height: 24px;
			display: block;
			&:hover { color: rgba(255, 255, 255, 1); }
			> input { vertical-align: text-top; }
		}
	  input {
	    padding: 10px 0;
	    border-bottom: 3px solid #C72328;
	    border-style: none none solid none;
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
	  .error {
  		vertical-align: middle;
  		width: auto;
  		position: absolute;
  		margin-top: 5px;
  		&.active { display: inline-block; }
	  }
	  label.checkbox, .warning {
	  	margin-top: 25px;
	  }
	}
</style>