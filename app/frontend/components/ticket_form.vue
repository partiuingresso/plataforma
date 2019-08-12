<template>
	<div id="ticket-form-modal" class="modal" :class="{'is-active': isActive}">
	  <div class="modal-background" @click="closeModal()"></div>
	  <div class="modal-card">
	    <header class="modal-card-head">
	      <p class="modal-card-title" v-html="title"></p>
	      <button class="delete" aria-label="close" @click="closeModal()"></button>
	    </header>
	    <section class="modal-card-body">
	    	<div class="offer-form">
	    		<div class="columns">
	    			<div class="column is-8">
		    			<div class="field is-expanded">
		    				<label class="label is-small">Nome do ingresso</label>
		    				<p class="control has-icons-right">
		    					<input v-model="offer.name" class="input" type="text" placeholder="Ingresso único, Meia-entrada, VIP, etc.">	
									<span class="icon is-right has-text-danger">
										<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
									</span>
		    				</p>
		    			</div>
				    </div>
				    <div class="column is-4">
				    	<div class="field is-horizontal">
				    		<div class="field-body">
				    			<div class="field is-narrow" style="width: 120px;">
				    				<label class="label is-small">Lote</label>
				    				<p class="control is-narrow">
				    					<input v-model="offer.allotment" class="input" type="text" placeholder="Ex. 1">	
				    				</p>
				    			</div>
				    			<div class="field is-narrow" style="width: 120px;">
				    				<label class="label is-small">Quantidade</label>
				    				<p class="control is-narrow has-icons-right">
				    					<input v-model="offer.quantity" class="input" type="text" placeholder="Ex. 100">	
											<span class="icon is-right has-text-danger">
												<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
											</span>
				    				</p>
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
				    					<input v-model="offer.start_t" class="input" type="datetime-local">	
											<span class="icon is-right has-text-danger">
												<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
											</span>
				    				</p>
				    			</div>
				    			<div class="field is-narrow">
				    				<label class="label is-small">Data de término das vendas</label>
				    				<p class="control has-icons-right">
				    					<input v-model="offer.end_t" class="input" type="datetime-local">	
											<span class="icon is-right has-text-danger">
												<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
											</span>
				    				</p>
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
				    					<input
				    						id="price-input"
				    						@input="offerPriceInput(e)"
				    						:value="offer.price.display"
				    						class="input"
				    						type="text"
				    						placeholder="R$"
				    					>	
											<span class="icon is-right has-text-danger">
												<i class="fas fa-asterisk" style="font-size: 0.5rem;"></i>
											</span>
				    				</p>
				    			</div>
				    		</div>
				    		<div class="column is-half">
				    			<label class="label is-small">Total comprador</label>
				    			<p class="help">{{ 'R$10,00' }}</p>
				    		</div>
			    		</div>
		    		</div>
			    </div>
			    <div class="field is-narrow">
			    	<label class="label is-small">Descriação do ingresso (opcional)</label>
			    	<p class="control">
			    		<textarea v-model="offer.description" class="textarea"></textarea>
			    	</p>
			    </div>
	    	</div>
	    </section>
	    <footer class="modal-card-foot">
	      <button class="button" @click="closeModal()">Cancelar</button>
	      <button class="button is-success" @click="closeModal(true)">{{ actionMessage }}</button>
	    </footer>
	  </div>
	</div>
</template>

<script>
	export default {
		props: {
			offer: {
				type: Object,
				default() {
					return {}
				}
			},
	    free: {
	    	type: Boolean
	    }
	  },
		data() {
			return {
				isActive: true,
			}
		},
		methods: {
			closeModal(confirmation=false) {
				this.isActive = false
				if(confirmation) {
					this.$emit('confirm')
				} else {
					this.$emit('close')
				}
			},
			offerPriceInput(e) {
			}
		},
		computed: {
			title() {
				var type = this.free ? 'gratuito' : 'pago'
				return `${this.actionMessage} <b>${type}</b>`
			},
			actionMessage() {
				var action = this.offer ? 'Editar' : 'Criar'
				return `${action} ingresso`
			}
		}
	}
</script>

<style lang="scss" scoped>
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
</style>
