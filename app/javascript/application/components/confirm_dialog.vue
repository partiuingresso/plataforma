<template>
	<div id="confirm-dialog" class="modal" :class="{'is-active': isActive}">
	  <div class="modal-background" @click="closeModal()"></div>
	  <div class="modal-card">
	    <header class="modal-card-head">
	      <p class="modal-card-title">{{ title }}</p>
	      <button class="delete" aria-label="close" @click="closeModal()"></button>
	    </header>
	    <section class="modal-card-body">
	    	<span v-html="message"></span>
	    </section>
	    <footer class="modal-card-foot">
	      <button class="button" @click="closeModal()">Cancelar</button>
	      <button class="button" :class="type" @click="closeModal(true)">Remover</button>
	    </footer>
	  </div>
	</div>
</template>

<script>
	export default {
		props: ['title', 'message', 'type'],
		data() {
			return {
				isActive: true
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
		}
	}
</script>

<style scoped>
	#confirm-dialog .modal-card-foot {
		justify-content: flex-end;
	}
</style>
