<template>
	<div>
		<h1>Endereço</h1>
		<p>Digite o <b>CEP</b> e o endereço de <b>seu negócio</b>.</p>
		<div class="cep" ref="cep">
			<input
				placeholder="Ex: 00000-000"
				v-model.lazy="$v.address.zipcode.$model"
				v-mask="'#####-###'"
				@input="zipcodeInput($event)"
        v-on:keyup.enter="next"
			/>
			<div v-show="$v.address.zipcode.$error">
	      <div v-if="!$v.address.zipcode.required" class="error cep active">Campo obrigatório</div>
	    </div>
		</div>
		<div class="address" ref="address">
			<div class="grouped">
				<input
					placeholder="Endereço"
					class="street ok"
					v-model.lazy="$v.address.address.$model"
					:style="{ width: address.address.length * 9.95 + 'px'}"
          v-on:keyup.enter="next"
				/>,
        <div v-if="$v.address.address.$error" class="error street active">Campo obrigatório</div>
        <div class="is-inline-block">
  				<input
  					placeholder="Número"
  					class="numberInput"
  					v-model.lazy="$v.address.number.$model"
            v-on:keyup.enter="next"
  				/>
          <div v-if="$v.address.number.$error" class="error num active">Campo obrigatório</div>
        </div>
			</div>
			<div class="grouped">
				<input
					placeholder="Complemento"
					class="complement"
					v-model="address.complement"
          v-on:keyup.enter="next"
				/>
				<input
					placeholder="Bairro"
					class="ok"
					v-model.lazy="$v.address.district.$model"
          v-on:keyup.enter="next"
				/>
        <div v-if="$v.address.district.$error" class="error district active">Campo obrigatório</div>
			</div>
			<div class="grouped">
				<input
					placeholder="Cidade"
					class="ok city"
					v-model.lazy="$v.address.city.$model"
          v-on:keyup.enter="next"
					:style="{ width: address.city.length * 9.95 + 'px'}"
				/>,
        <div v-if="$v.address.city.$error" class="error city active">Campo obrigatório</div>
				<input
					placeholder="Estado"
					class="ok"
					maxLength="2"
					v-model.lazy="$v.address.state.$model"
          v-on:keyup.enter="next"
				/>
        <div v-if="$v.address.state.$error" class="error state active">Campo obrigatório</div>
			</div>
		</div>
		<a @click="next" class="nextButton" tabindex="0">Avançar -></a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
import { mask } from 'vue-the-mask'
import cep from 'cep-promise'
import { helpers, required } from 'vuelidate/lib/validators'
export default {
	extends: WizardView,
	directives: {
		mask
	},
	data() {
		return {
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
	validations: {
		address: {
			zipcode: {
				required
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
	},
	methods: {
		next() {
			this.$v.$touch()
			if(!this.$v.$invalid) {
				this.data.company.address = this.address
				this.$router.push({ name: 'contacts', params: { type: 'company' } })
			}
		},
		zipcodeInput(event) {
			const value = event.target.value
			if(value.length === 9) {
				this.getCep(value)
			}
		},
		async getCep(zipcode) {
			const addressDiv = this.$refs.address
			const cepDiv = this.$refs.cep
			const streetDiv = this.$el.querySelector('.street')
			const numberDiv = this.$el.querySelector('.numberInput')
			const address = this.address

			cepDiv.classList.add('loading')
			await cep(zipcode).then(function(result) {
				cepDiv.classList.remove('loading')
				cepDiv.firstChild.classList.add('ok')
				address.address = result.street
				address.district = result.neighborhood
				address.city = result.city
				address.state = result.state
				addressDiv.className = 'address active'
				numberDiv.focus()
			}).catch(function() {
				cepDiv.classList.remove('loading')
				addressDiv.className = 'address active'
				streetDiv.style.width = '240px'
				streetDiv.focus()
			})
			// Limpa as mensagens de erro dos campos de endereço
			this.$v.$reset()
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
  input.street { min-width: 240px; max-width: 720px; }
  input.city { min-width: 120px; max-width: 530px; }
	.cep {
		position: relative;
		margin-top: 50px;
		margin-bottom: 30px;
		max-width: 160px;
		> input { max-width: 160px; }
	}
	.grouped {
		color: #ffffff;
    margin-bottom: 30px;
    overflow: visible;
		> input {
			&:last-of-type:not(.street) { margin-left: 20px; }
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
