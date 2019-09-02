<template>
	<div>
		<h1>Contatos</h1>
		<p>Informe as melhores formas de entrar em contato com {{ this.type == 'company' ? 'seu negócio' : 'você' }}.</p>
		<input
			v-if="type == 'company'"
			v-model="data.company.phone"
			class="input"
			placeholder="DDD + Telefone"
		/>
		<input
			v-else
			v-model="data.phone"
			class="input"
			placeholder="DDD + Telefone"
		/>
		<label class="checkbox">
			<input v-model="data.show_phone" type="checkbox" />
			Deseja utilizar este número para realizar atendimento aos clientes?
		</label>
		<input v-model="data.help_email" class="input" placeholder="Endereço de e-mail" />
		<p>
			<b>Importante!</b>	Este endereço de e-mail será utilizado para o atendimento aos clientes.
			Fique tranquilo! Você poderá alterar este contato quando quiser.
		</p>
		<router-link
			v-if="type == 'company'"
			:to="{ name: 'personal_information' }"
			class="button is-primary"
		>
			Avançar
		</router-link>
		<a v-else class="button is-primary" @click="finishButton">Finanlizar</a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
export default {
	extends: WizardView
}
</script>