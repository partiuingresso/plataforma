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
				<input v-model="formData.document_number" v-mask="'###.###.###-##'" placeholder="CPF" />
				<div class="error">Campo inválido</div>
			</div>
			<div>
				<input v-model="formData.birthdate" @focus="birthPlaceholder($event)" @blur="birthPlaceholder($event)" v-mask="'##/##/####'" placeholder="Data de nascimento" />
				<div class="error">Campo inválido</div>
			</div>
		</div>
		
		<div class="grouped">
			<div v-if="type == 'company'">
				<input v-model="formData.phone" v-mask="['(##) ####-####', '(##) # ####-####']"  placeholder="DDD + Telefone" />
				<div class="error">Campo inválido</div>
			</div>
			<div class="cep">
				<input @input="getCep($event)" v-mask="'#####-###'" v-model="formData.address.zipcode" placeholder="CEP" />
				<div class="error">Campo inválido</div>
			</div>
		</div>

		<div class="address">
			<div class="grouped">
				<div>
					<input v-model="formData.address.address" class="street ok" :style="{ width: formData.address.address.length * 9.95 + 'px'}" placeholder="Endereço" />,
					<div class="error">Campo inválido</div>
				</div>
				<div>
					<input v-model="formData.address.number" class="numberInput" placeholder="Número" />
					<div class="error">Campo inválido</div>
				</div>
			</div>
			
			<div class="grouped">
				<div>
					<input v-model="formData.address.complement" class="complement" placeholder="Complemento" />
					<div class="error">Campo inválido</div>
				</div>
				<div>
					<input v-model="formData.address.district" class="ok" placeholder="Bairro" />
					<div class="error">Campo inválido</div>
				</div>
			</div>
			
			<div class="grouped city">
				<div>
					<input v-model="formData.address.city" :style="{ width: formData.address.city.length * 9.95 + 'px'}" class="ok city" placeholder="Cidade" />,
					<div class="error">Campo inválido</div>
				</div>
				<div>
					<input v-model="formData.address.state" class="ok" placeholder="Estado" />
					<div class="error">Campo inválido</div>
				</div>
			</div>
		</div>
		
		<router-link v-if="type == 'personal'" :to="{ name: 'contacts' }" class="nextButton">Avançar -></router-link>
		<a v-else class="nextButton" @click="finishButton">Finanlizar -></a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
import {mask} from 'vue-the-mask'
import cep from 'cep-promise'
export default {
	extends: WizardView,
	props: ["first_name", "full_name", "email"],
	data() {
		return {
			formData: {...this.data}
		}
	},
	directives: {mask},
	methods: {
		getCep(event) {
			let address = this.formData.address
			let cepDiv = event.target.parentElement
			let addressDiv = this.$el.querySelector('.address')
			let streetDiv = this.$el.querySelector('.street')
			let numberDiv = this.$el.querySelector('.numberInput')
			if(address.zipcode.length == 9) {
				cep(address.zipcode).then(function(result) {
					cepDiv.classList.remove('loading')
					cepDiv.firstChild.classList.add('ok')
					address.address = result.street
					address.district = result.neighborhood
					address.city = result.city
					address.state = result.state
					addressDiv.className = 'address active'
					numberDiv.focus()
				}).catch(function(){
					cepDiv.classList.remove('loading')
					addressDiv.className = 'address active'
					streetDiv.style.width = '240px'
					streetDiv.focus()
				})
				cepDiv.classList.add('loading')
			} else {
				cepDiv.classList.remove('loading')
			}
		},
		birthPlaceholder(event) {
			let birthInput = event.target
			if(birthInput.placeholder == 'Data de nascimento') {
				birthInput.placeholder = "DD/MM/AAAA"
			} else {
				birthInput.placeholder = "Data de nascimento"
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
		display: none;
		.grouped { input:last-child { margin-left: unset; } display: block; max-width: unset; }
		&.active { display: block; }
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
		overflow: hidden;
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
</style>