<template>
	<div>
		<h1>{{ data.company.name }}</h1>
		<p>Curti o nome!</p>
		<p>Agora precisamos saber a <b>Razão Social</b> e o <b>CNPJ</b> de sua empresa.</p>
		<input v-model="data.company.business_name" class="input" placeholder="Ex: Nelson Produtora de Eventos Ltda" />
		<input v-model="data.company.document_number" class="input" placeholder="Ex: 00.000.000/0000-00" />
		<router-link :to="{ name: 'company_address' }" class="button is-primary">Avançar</router-link>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
export default {
	extends: WizardView
}
</script>