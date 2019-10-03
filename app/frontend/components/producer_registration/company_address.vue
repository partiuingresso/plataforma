<template>
	<div>
		<h1>Endereço</h1>
		<p>Digite o <b>CEP</b> e o endereço de <b>seu negócio</b>.</p>
		<div class="cep">
			<input @input="getCep($event)" v-model="formData.company.address.zipcode" v-mask="'#####-###'" placeholder="Ex: 00000-000" />
      <div class="error cep">Este campo não pode ficar vazio</div>
		</div>
		<div class="address">
			<div class="grouped">
				<input v-model="formData.company.address.address" class="street ok" :style="{ width: formData.company.address.address.length * 9.8 + 'px'}" placeholder="Endereço" />,
        <div class="error street">Este campo não pode ficar vazio</div>
        <div class="is-inline-block">
  				<input v-model="formData.company.address.number" class="numberInput" placeholder="Número" />
          <div class="error num">Este campo não pode ficar vazio</div>
        </div>
			</div>
			<div class="grouped">
				<input v-model="formData.company.address.complement" class="complement" placeholder="Complemento" />
				<input v-model="formData.company.address.district" class="ok" placeholder="Bairro" />
        <div class="error district">Este campo não pode ficar vazio</div>
			</div>
			<div class="grouped">
				<input v-model="formData.company.address.city" class="ok" :style="{ width: formData.company.address.city.length * 9.8 + 'px'}" placeholder="Cidade" />,
        <div class="error city">Este campo não pode ficar vazio</div>
				<input v-model="formData.company.address.state" class="ok" placeholder="Estado" />
        <div class="error state">Este campo não pode ficar vazio</div>
			</div>
		</div>
		<router-link :to="{ name: 'contacts', params: { type: 'company' } }" class="nextButton">Avançar -></router-link>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
import {mask} from 'vue-the-mask'
import cep from 'cep-promise'
export default {
	extends: WizardView,
	data() {
		return {
			formData: {...this.data}
		}
	},
	directives: {mask},
	methods: {
		getCep(event) {
			let address = this.formData.company.address
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
		}
	}
}
</script>

<style lang="scss" scoped>
div {
	.address {
		display: none;
		&.active { display: block; }
	}
	input.complement { max-width: 140px; }
	input.numberInput { max-width: 120px; }
	.cep {
		position: relative;
		margin-top: 50px;
		margin-bottom: 30px;
		max-width: 160px;
		> input { max-width: 160px; }
	}
	.grouped {
		color: #ffffff;
		> input {
			&:last-of-type:not(.street) { margin-left: 20px; }
      &.street { margin-bottom: 30px; }
			display: inline-block;
			margin-bottom: 30px;
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
    margin: unset;
    &.cep {
      margin-top: 5px;
    }
    &.street {
      margin-top: -25px;
    }
    &.num {
      margin-top: 5px;
    }
    &.district {
      margin-top: -25px;
      left: 285px;
    }
    &.city {
      margin-top: 5px;
    }
    &.state {
      margin-top: 5px;
      left: 285px;
    }
  }
}
</style>
