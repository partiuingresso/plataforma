<template>
	<div>
		<h1>Certo, Nelson!</h1>
		<p>
			Então precisamos apenas completar alguns dados que ainda não sabemos sobre você.
			Vamos lá? É bem rápido!
		</p>
		<input v-model="data.name" class="input" placeholder="Nome" />
		<input v-model="data.email" class="input" placeholder="Email" />
		<input v-model="data.document_number" class="input" placeholder="CPF" />
		<input v-model="data.birthdate" type="date" class="input" placeholder="Data de nascimento" />
		<input v-if="type == 'company'" v-model="data.phone" class="input" placeholder="DDD + Telefone" />
		<input v-model="data.address.zipcode" class="input" placeholder="CEP" />
		<input v-model="data.address.address" class="input" placeholder="Endereço" />
		<input v-model="data.address.number" class="input" placeholder="Número" />
		<input v-model="data.address.complement" class="input" placeholder="Complemento" />
		<input v-model="data.address.district" class="input" placeholder="Bairro" />
		<input v-model="data.address.city" class="input" placeholder="Cidade" />
		<input v-model="data.address.state" class="input" placeholder="Estado" />
		<router-link v-if="type == 'personal'" :to="{ name: 'contacts' }" class="button is-primary">Avançar</router-link>
		<a v-else class="button is-primary" @click="finishButton">Finanlizar</a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
export default {
	extends: WizardView
}
</script>