<template>
	<div>
		<h1 v-if="type == 'company'">Falta pouco, {{ first_name }}!</h1>
		<h1 v-else>Certo, {{ first_name }}!</h1>
		<p>
			Precisamos apenas completar alguns dados <b v-if="type == 'company'">pessoais</b> que ainda não sabemos sobre você.
			Vamos lá? É bem rápido!
		</p>

		<div class="grouped">
			<p class="info">{{ full_name }}</p>
			<p class="info">{{ email }}</p>
		</div>

		<div class="grouped">
			<div>
				<input
					v-autofocus
					v-model.lazy="$v.formData.document_number.$model"
					v-mask="'###.###.###-##'"
					placeholder="CPF"
					v-on:keyup.enter="resolve"
				/>
				<div v-show="$v.formData.document_number.$error">
					<div v-if="!$v.formData.document_number.required" class="error active">Campo obrigatório</div>
					<div v-if="!$v.formData.document_number.isCpf" class="error active">Campo inválido</div>
				</div>
			</div>
			<div>
				<input
					placeholder="Data de nascimento"
					v-model.lazy="$v.formData.birthdate.$model"
					v-mask="'##/##/####'"
					@focus="birthPlaceholder($event)"
					@blur="birthPlaceholder($event)"
					v-on:keyup.enter="resolve"
				/>
				<div v-show="$v.formData.birthdate.$error">
					<div v-if="!$v.formData.birthdate.required" class="error active">Campo obrigatório</div>
					<div v-if="!$v.formData.birthdate.isBirthdate" class="error active">Campo inválido</div>
				</div>
			</div>
		</div>
		
		<div class="grouped">
			<div v-if="type == 'company'">
				<input
					placeholder="DDD + Telefone"
					v-model.lazy="$v.formData.phone.$model"
					v-mask="['(##) ####-####', '(##) #####-####']"
					v-on:keyup.enter="resolve"
				/>
				<div v-show="$v.formData.phone.$error">
					<div v-if="!$v.formData.phone.required"	class="error active">Campo obrigatório</div>
					<div v-if="!$v.formData.phone.isPhone"	class="error active">Campo inválido</div>
				</div>
			</div>
			<div class="cep" ref="cep">
				<input
					placeholder="CEP"
					v-mask="'#####-###'"
					v-model.lazy="$v.formData.address.zipcode.$model"
					@input="zipcodeInput($event)"
					v-on:keyup.enter="resolve"
				/>
				<div v-show="$v.formData.address.zipcode.$error">
					<div v-if="!$v.formData.address.zipcode.required" class="error active">Campo obrigatório</div>
					<div v-if="!$v.formData.address.zipcode.isCep" class="error active">Campo inválido</div>
				</div>
			</div>
		</div>

		<div v-show="showAddress" class="address">
			<div class="grouped">
				<div>
					<input
						placeholder="Endereço"
						class="street ok"
						v-model.lazy="$v.formData.address.address.$model"
						:style="{ width: formData.address.address.length * 9.95 + 'px'}"
						v-on:keyup.enter="resolve"
					/>,
					<div v-if="$v.formData.address.address.$error" class="error active">Campo obrigatório</div>
				</div>
				<div>
					<input v-model.lazy="$v.formData.address.number.$model" class="numberInput" v-on:keyup.enter="resolve" placeholder="Número" />
					<div v-if="$v.formData.address.number.$error" class="error active">Campo obrigatório</div>
				</div>
			</div>
			
			<div class="grouped">
				<div>
					<input v-model="formData.address.complement" class="complement" v-on:keyup.enter="resolve" placeholder="Complemento" />
				</div>
				<div>
					<input v-model.lazy="$v.formData.address.district.$model" class="ok" v-on:keyup.enter="resolve" placeholder="Bairro" />
					<div v-if="$v.formData.address.district.$error" class="error active">Campo obrigatório</div>
				</div>
			</div>
			
			<div class="grouped city">
				<div>
					<input
						placeholder="Cidade"
						class="city ok"
						v-model.lazy="$v.formData.address.city.$model"
						:style="{ width: formData.address.city.length * 9.95 + 'px'}"
						v-on:keyup.enter="resolve"
					/>,
					<div v-if="$v.formData.address.city.$error" class="error active">Campo obrigatório</div>
				</div>
				<div>
					<input
						placeholder="Estado"
						class="ok"
						maxLength="2"
						v-model.lazy="$v.formData.address.state.$model"
						v-on:keyup.enter="resolve"
					/>
					<div v-if="$v.formData.address.state.$error" class="error active">Campo obrigatório</div>
				</div>
			</div>
		</div>
		
		<a v-if="type == 'personal'" @click="next" class="nextButton" tabindex="0">Avançar -></a>
		<a v-else class="nextButton" @click="finish" tabindex="0">
			Finanlizar
			<span v-if="loading">
				<i class='fa fa-spinner fa-spin'></i>
			</span>
			<span v-else>
			 ->
			</span>
		</a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
import { mask } from 'vue-the-mask'
import cep from 'cep-promise'
import moment from 'moment'
import { helpers, required, requiredIf } from 'vuelidate/lib/validators'
const isCpf = helpers.regex('cpf', /^\d{3}\.\d{3}\.\d{3}-\d{2}$/)
const isBirthdate = (value) => {
	let date = moment(value, 'DD/MM/YYYY')
	return !helpers.req(value) || date.isValid() && date.isBefore(moment())
}
const isPhone = helpers.regex('phone', /^\(\d{2}\)\s\d{4,5}-\d{4}$/)
const isCep = helpers.regex('cep', /^\d{5}-\d{3}$/)
export default {
	extends: WizardView,
	directives: {
		mask
	},
	props: ['first_name', 'full_name', 'email'],
	data() {
		return {
			formData: this.data,
			showAddress: this.data.address.zipcode !== ''
		}
	},
	validations: {
		formData: {
			document_number: {
				required,
				isCpf
			},
			birthdate: {
				required,
				isBirthdate
			},
			phone: {
				required: requiredIf(function(value) {
					return this.type === 'company'
				}),
				isPhone
			},
			address: {
				zipcode: {
					required,
					isCep
				},
				address: {
					required
				},
				number: {
					required
				},
				district: {
					required
				},
				city: {
					required
				},
				state: {
					required
				}
			}
		}
	},
	methods: {
		next() {
			this.$v.$touch()
			if(!this.$v.$invalid) {
				this.$router.push({ name: 'contacts' })
			}
		},
		finish() {
			this.$v.$touch()
			if(!this.$v.$invalid && !this.loading) {
				this.finishButton()
			}
		},
		resolve() {
			if(this.type == 'personal') {
				this.next()
			} else {
				this.finish()
			}
		},
		zipcodeInput(event) {
			const value = event.target.value
			if(value.length === 9) {
				this.getCep(value)
			}
		},
		async getCep(zipcode) {
			const vue = this
			const cepDiv = this.$refs.cep
			const streetDiv = this.$el.querySelector('.street')
			const numberDiv = this.$el.querySelector('.numberInput')
			const address = this.formData.address

			cepDiv.classList.add('loading')
			await cep(zipcode).then(function(result) {
				cepDiv.classList.remove('loading')
				cepDiv.firstChild.classList.add('ok')
				address.address = result.street
				address.district = result.neighborhood
				address.city = result.city
				address.state = result.state
				numberDiv.focus()
				vue.showAddress = true
			}).catch(function() {
				cepDiv.classList.remove('loading')
				streetDiv.style.width = '240px'
				streetDiv.focus()
				vue.showAddress = true
			})
			// Limpa as mensagens de erro dos campos de endereço
			this.$v.formData.address.$reset()
		},
		birthPlaceholder(event) {
			let birthInput = event.target
			if(birthInput.placeholder == 'Data de nascimento') {
				birthInput.placeholder = 'DD/MM/AAAA'
			} else {
				birthInput.placeholder = 'Data de nascimento'
			}
		}
	}
}
</script>

<style lang="scss" scoped>
div {
	h1 ~ p {
		margin-bottom: 50px;
	}
	.address {
		.grouped { input:last-child { margin-left: unset; } display: block; max-width: unset; }
	}
	input.complement { max-width: 140px; margin-right: 30px; }
	input.numberInput { max-width: 120px; }
	input.street { min-width: 240px; max-width: 720px; }
	input.city { min-width: 120px; max-width: 530px; }
	.cep {
		position: relative;
		display: inline-block;
	}
	.grouped {
		p.info {
			display: inline-block;
			font-size: 20px;
			line-height: 16px;
			color: #ffffff;
			width: 240px;
		}
		overflow: visible;
		max-width: 530px;
		display: flex;
		align-items: center;
		justify-content: space-between;
		color: #ffffff;
		margin-bottom: 30px;
		> div {
			display: inline-block;
		}
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
    &.ok {
    	margin: unset;
    	border-color: transparent;
    	&:focus { border-bottom: 3px solid #C72328; }
    }
  }
  .nextButton { margin-top: 50px; }
  .error {
  	position: absolute;
  	margin-top: 5px;
  }
}
</style>

