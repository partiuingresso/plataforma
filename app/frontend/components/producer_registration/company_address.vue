<template>
	<div>
		<h1>Endereço</h1>
		<p>Digite o <b>CEP</b> do endereço de <b>seu negócio</b>.</p>
		<input v-model="data.company.address.zipcode" class="input" placeholder="CEP" />
		<input v-model="data.company.address.address" class="input" placeholder="Endereço" />
		<input v-model="data.company.address.number" class="input" placeholder="Número" />
		<input v-model="data.company.address.complement" class="input" placeholder="Complemento" />
		<input v-model="data.company.address.district" class="input" placeholder="Bairro" />
		<input v-model="data.company.address.city" class="input" placeholder="Cidade" />
		<input v-model="data.company.address.state" class="input" placeholder="Estado" />
		<router-link :to="{ name: 'contacts', params: { type: 'company' } }" class="button is-primary">Avançar</router-link>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
export default {
	extends: WizardView
}
</script>
