<template>
	<div id="ticket-form-modal" class="modal" :class="{'is-active': isActive}">
	  <div class="modal-background" @click="closeModal()"></div>
	  <div class="modal-card">
	    <header class="modal-card-head">
	      <p class="modal-card-title" v-html="title"></p>
	      <button class="delete" aria-label="close" @click="closeModal()"></button>
	    </header>
	    <section class="modal-card-body">
	    </section>
	    <footer class="modal-card-foot">
	      <button class="button" @click="closeModal()">Cancelar</button>
	      <button class="button is-success" @click="closeModal(true)">{{ actionMessage }}</button>
	    </footer>
	  </div>
	</div>
</template>

<script >
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
	#ticket-form-modal .modal-card-foot {
		justify-content: flex-end;
	}	
</style>
