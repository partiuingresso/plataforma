<template>
	<div id="ticket-form-modal" class="modal" :class="{'is-active': isActive}">
	  <div class="modal-background" @click="closeModal()"></div>
	  <div class="modal-card">
	    <header class="modal-card-head">
	      <p class="modal-card-title" v-html="title"></p>
	      <button class="delete" aria-label="close" @click="closeModal()"></button>
	    </header>
  		<form @submit.prevent="submit">
		    <section class="modal-card-body">
		    	<div class="offer-form">
		    		<div class="columns">
		    			<div class="column is-8">
			    			<div class="field is-expanded">
			    				<label class="label is-small">Nome do ingresso</label>
			    				<p class="control has-icons-right">
			    					<input
			    						v-model.trim="$v.actionOffer.name.$model"
			    						:class="{ 'is-danger': $v.actionOffer.name.$error }"
			    						class="input"
			    						type="text"
			    						placeholder="Ingresso único, Meia-entrada, VIP, etc."
			    						autofocus
			    					/>	
										<span class="icon is-right has-text-danger">
											<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
										</span>
			    				</p>
						    	<div class="error-wrapper">
				    				<div v-show="$v.actionOffer.name.$error">
					    				<p v-if="!$v.actionOffer.name.required" class="help is-danger">Campo Obrigatório</p>
					    				<p v-if="!$v.actionOffer.name.maxLength" class="help is-danger">
						    				Deve ter no máximo {{ $v.actionOffer.name.$params.maxLength.max }} caracteres
						    			</p>
						    		</div>
						    	</div>
			    			</div>
					    </div>
					    <div class="column is-4">
					    	<div class="field is-horizontal">
					    		<div class="field-body">
					    			<div class="field is-narrow" style="width: 120px;">
					    				<label class="label is-small">Lote</label>
					    				<p class="control is-narrow">
					    					<input
					    						v-model.trim="actionOffer.allotment"
					    						type="text"
					    						class="input"
					    						placeholder="Ex. 1"
					    					/>
					    				</p>
					    			</div>
					    			<div class="field is-narrow" style="width: 120px;">
					    				<label class="label is-small">Quantidade</label>
					    				<p class="control is-narrow has-icons-right">
					    					<input
					    						v-model.trim="$v.actionOffer.quantity.$model"
					    						:class="{ 'is-danger': $v.actionOffer.quantity.$error }"
					    						type="text"
					    						class="input"
					    						placeholder="Ex. 100"
					    					/>
												<span class="icon is-right has-text-danger">
													<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
												</span>
					    				</p>
								    	<div class="error-wrapper">
						    				<div v-show="$v.actionOffer.quantity.$error">
							    				<p v-if="!$v.actionOffer.quantity.required" class="help is-danger">
							    					Campo Obrigatório
							    				</p>
							    				<p v-else-if="!$v.actionOffer.quantity.minValue" class="help is-danger">
								    				No mínimo {{ actionOffer.sold || 1 }}
								    			</p>
								    		</div>
								    	</div>
					    			</div>
					    		</div>
					    	</div>
					    </div>
				    </div>
			    	<div class="columns">
			    		<div class="column is-8">
			    			<div class="field is-horizontal">
			    				<div class="field-body">
					    			<div class="field is-narrow">
					    				<label class="label is-small">Data de início das vendas</label>
					    				<p class="control has-icons-right">
					    					<input
					    						v-model="$v.actionOffer.start_t.$model"
					    						:class="{ 'is-danger': $v.actionOffer.start_t.$error }"
					    						type="datetime-local"
					    						class="input"
					    						novalidate
					    					/>
												<span class="icon is-right has-text-danger">
													<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
												</span>
					    				</p>
								    	<div class="error-wrapper">
						    				<div v-show="$v.actionOffer.start_t.$error">
							    				<p v-if="!$v.actionOffer.start_t.required" class="help is-danger">
							    					Campo Obrigatório
							    				</p>
							    				<p v-else-if="!$v.actionOffer.start_t.maxValue" class="help is-danger">
								    				Deve ser anterior ao término das vendas
								    			</p>
								    		</div>
								    	</div>
					    			</div>
					    			<div class="field is-narrow">
					    				<label class="label is-small">Data de término das vendas</label>
					    				<p class="control has-icons-right">
					    					<input
					    						v-model="$v.actionOffer.end_t.$model"
					    						:class="{ 'is-danger': $v.actionOffer.end_t.$error }"
					    						type="datetime-local"
					    						class="input"
					    					/>
												<span class="icon is-right has-text-danger">
													<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
												</span>
					    				</p>
								    	<div class="error-wrapper">
						    				<div v-show="$v.actionOffer.end_t.$error">
							    				<p v-if="!$v.actionOffer.end_t.required" class="help is-danger">
							    					Campo Obrigatório
							    				</p>
							    				<p v-else-if="!$v.actionOffer.end_t.minValue" class="help is-danger">
								    				Deve ser posterior ao início das vendas
								    			</p>
								    		</div>
								    	</div>
					    			</div>
					    		</div>
				    		</div>
					    </div>
				    	<div class="column is-4">
				    		<div class="columns is-vcentered">
				    			<div class="column is-half">
					    			<div class="field is-narrow" style="width: 120px;">
					    				<label class="label is-small">Preço</label>
					    				<p class="control has-icons-right">
					    					<money
					    						v-model.lazy="actionOffer.price"
					    						@blur.native="$v.actionOffer.price.$touch()"
					    						v-bind="moneyConfig"
					    						:disabled="free || actionOffer.sold > 0"
					    						:class="{ 'is-danger': $v.actionOffer.price.$error }"
					    						class="input"
					    						type="text"
					    						placeholder="R$"
					    					>	
						    				</money>
												<span v-if="!free" class="icon is-right has-text-danger">
													<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
												</span>
					    				</p>
								    	<div class="error-wrapper">
						    				<div v-show="$v.actionOffer.price.$error">
							    				<p v-if="!$v.actionOffer.price.minValue" class="help is-danger">
							    					Mínimo: {{ format(13.8) }}
							    				</p>
							    			</div>
							    		</div>
					    			</div>
					    		</div>
					    		<div class="column is-half">
					    			<label class="label is-small">Total comprador</label>
					    			<p>{{ format(finalPrice) }}</p>
					    		</div>
				    		</div>
			    		</div>
				    </div>
				    <div class="field is-narrow">
				    	<label class="label is-small">Descriação do ingresso (opcional)</label>
				    	<p class="control">
				    		<trix
				    			v-model="$v.actionOffer.description.$model"
	    						:class="{ 'is-danger': $v.actionOffer.description.$error }"
	    						@trix-file-accept.prevent
				    		>
				    		</trix>
				    	</p>
				    	<div class="error-wrapper">
		    				<div v-show="$v.actionOffer.description.$error">
			    				<p v-if="!$v.actionOffer.description.maxLength" class="help is-danger">
					    			Deve ter no máximo {{ $v.actionOffer.description.$params.maxLength.max }} caracteres
			    				</p>
			    			</div>
			    		</div>
				    </div>
						<div class="field">
							<input
								v-model="actionOffer.active"
								type="checkbox"
								id="active-switch-offer"
								class="switch is-rounded is-success"
							/>
							<label for="active-switch-offer">Ativo</label>
						</div>
		    	</div>
		    </section>
		    <footer class="modal-card-foot">
		      <a class="button" @click="closeModal()">Cancelar</a>
		      <button type="submit" class="button is-success">{{ actionMessage }}</button>
		    </footer>
		  </form>
	  </div>
	</div>
</template>

<script>
	import Rails from 'rails-ujs'
	import { Money as VMoney } from 'v-money'
	import Money from 'src/utils/money'
	import VueTrix from 'vue-trix'
	import cloneDeep from 'lodash.clonedeep'
	import { required, minValue, maxLength } from 'vuelidate/lib/validators'
	export default {
		components: {
			money: VMoney,
			trix: VueTrix
		},
		props: {
			offer: {
				type: Object,
				default() {
					return {}
				}
			},
	    free: {
	    	type: Boolean
	    },
	    event: {
	    	type: Number
	    },
	    admin: {
	    	type: Boolean
	    }
	  },
		data() {
			return {
				isActive: true,
				actionOffer: cloneDeep(this.offer) || {
					name: '',
					quantity: '',
					start_t: '',
					end_t: '',
					price: '',
					description: '',
					active: true
				},
				moneyConfig: {
					decimal: ',',
					thousands: '.',
					prefix: 'R$ ',
					precision: 2,
					masked: false
				}
			}
		},
		validations: {
			actionOffer: {
				name: {
					required,
					maxLength: maxLength(45)
				},
				quantity: {
					required,
					minValue: function(value) {
						const min = this.actionOffer.hasOwnProperty('sold') ? this.actionOffer.sold : 1
						return value >= min
					}
				},
				start_t: {
					required,
					maxValue: function(value) {
						return !this.actionOffer.end_t || (new Date(value) < new Date(this.actionOffer.end_t))
					}
				},
				end_t: {
					required,
					minValue: function(value) {
						return (new Date(value) > new Date(this.actionOffer.start_t))
					}
				},
				price: {
					minValue: function(value) {
						const min = this.free ? 0 : 13.8
						return value >= min
					}
				},
				description: {
					maxLength: maxLength(200)
				}
			}
		},
		methods: {
			format(value) {
				const intValue = Math.round(value * 100)
				return new Money({amount: intValue}).toFormat()
			},
			closeModal() {
				this.isActive = false
				this.$emit('close')
			},
			submit() {
				if(this.$v.$invalid) {
					this.$v.$touch()
					return
				}

				if(this.actionOffer.id) {
					this.updateOffer()
				} else {
					this.createOffer()
				}
				this.closeModal()
			},
			updateOffer() {
				Rails.ajax({
					url: this.url + this.actionOffer.id,
					type: 'patch',
					data: this.formData,
					success: this.successfulOfferUpdate,
					error: this.offerUpdateError 
				})
			},
			successfulOfferUpdate() {
				bulmaToast.toast(
					{
						message: 'Ingresso atualizado com sucesso.',
						type: 'is-success',
						dismissible: true,
						duration: 5000,
						pauseOnHover: true,
						animate: { in: 'bounceInRight', out: 'bounceOutRight' }
					}
				)
				this.$root.$emit('edit:offer', this.actionOffer)
			},
			offerUpdateError() {
				bulmaToast.toast(
					{
						message: 'Não foi possível atualizar esse ingresso.',
						type: 'is-danger',
						dismissible: true,
						duration: 5000,
						pauseOnHover: true,
						animate: { in: 'bounceInRight', out: 'bounceOutRight' }
					}
				)
			},
			createOffer() {
				Rails.ajax({
					url: this.url,
					type: 'post',
					data: this.formData,
					success: this.successfulOfferCreation,
					error: this.offerCreationError
				})
			},
			successfulOfferCreation(response_data) {
				bulmaToast.toast(
					{
						message: 'Ingresso criado com sucesso.',
						type: 'is-success',
						dismissible: true,
						duration: 5000,
						pauseOnHover: true,
						animate: { in: 'bounceInRight', out: 'bounceOutRight' }
					}
				)
				const response = response_data.data
				const newOffer = Object.assign({id: response.id}, response.attributes)
				this.$root.$emit('create:offer', newOffer)
			},
			offerCreationError() {
				bulmaToast.toast(
					{
						message: 'Não foi possível criar esse ingresso.',
						type: 'is-danger',
						dismissible: true,
						duration: 5000,
						pauseOnHover: true,
						animate: { in: 'bounceInRight', out: 'bounceOutRight' }
					}
				)
			}
		},
		computed: {
			title() {
				var type = this.free ? 'gratuito' : 'pago'
				return `${this.actionMessage} <b>${type}</b>`
			},
			actionMessage() {
				var action = this.actionOffer.id ? 'Editar' : 'Criar'
				return `${action} ingresso`
			},
			finalPrice() {
				const price = this.actionOffer.price > 0 ? Math.round(this.actionOffer.price * 100) : 0
				var final = Money({amount: price}).multiply(1.1).getAmount() / 100

				return final
			},
			formData() {
				const formData = new FormData()
				formData.append('offer[name]', this.actionOffer.name)
				formData.append('offer[allotment]', this.actionOffer.allotment || '')
				formData.append('offer[quantity]', this.actionOffer.quantity)
				formData.append('offer[start_t]', this.actionOffer.start_t)
				formData.append('offer[end_t]', this.actionOffer.end_t)
				formData.append('offer[price_cents]', Math.round(this.actionOffer.price * 100))
				formData.append('offer[description]', this.actionOffer.description || '')
				formData.append('offer[active]', this.actionOffer.active)

				return formData
			},
			url() {
				const prefix = this.admin ? '/admin' : ''
				const url = prefix + `/events/${this.event}/offers/`

				return url
			}
		},
		watch: {
			finalPrice(value) {
				this.actionOffer.price_with_fee = value
			}
		}
	}
</script>

<style lang="scss" scoped>
	.modal-card {
		background: rgba(23, 23, 23, 0.99);
		box-shadow: 4px 8px 16px rgba(0, 0, 0, 0.25);
		border-radius: 10px;
	}
	.modal-card-title { color: #ffffff; }
	.modal-card-body { background: unset; }
	footer { height: unset; }

	#ticket-form-modal {
		& .modal-card {
			max-width: 1000px;
			width: 100%;
			padding: 0 10px;

			& .offer-form {
				padding: 0 50px;
			}
		}
		& .modal-card-foot {
			justify-content: flex-end;
		}
	}
	.error-wrapper {
		margin-top: 4px;
		min-height: 18px;
	}
</style>
