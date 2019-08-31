<template>
	<div>
		<h1>Certo, Nelson!</h1>
		<p>
			Qual é o <b>Nome Fantasia</b> de sua empresa?
			Esta informação aparecerá nas comunicações oficiais do seu evento.
		</p>
		<input v-model="data.company.name" class="input" placeholder="Ex: Nelson Produções" />
		<router-link :to="{ name: 'company_legal_information' }" class="button is-primary">Avançar</router-link>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
export default {
	extends: WizardView
}
</script>
