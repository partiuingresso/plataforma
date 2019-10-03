<template>
	<div>
		<h1>Contatos</h1>
		<p>Informe as melhores formas de entrar em contato com {{ this.type == 'company' ? 'seu negócio' : 'você' }}.</p>
		<input
			v-if="type == 'company'"
			v-model="data.company.phone"
			placeholder="DDD + Telefone"
			v-mask="['(##) ####-####', '(##) # ####-####']"
		/>
		<input
			v-else
			v-model="data.phone"
			placeholder="DDD + Telefone"
			v-mask="['(##) ####-####', '(##) # ####-####']"
		/>
		<div class="error"><- Campo inválido</div>
		<label class="checkbox">
			<input v-model="data.show_phone" type="checkbox" />
			Deseja utilizar este número para realizar atendimento aos clientes?
		</label>
		<input v-model="data.help_email" placeholder="Endereço de e-mail" />
		<div class="error"><- Campo inválido</div>
		<div class="warning">
			<b>Importante!</b>	Este endereço de e-mail será utilizado para o atendimento aos clientes. <br />
			Fique tranquilo! Você poderá alterar este contato quando quiser.
		</div>
		<router-link
			v-if="type == 'company'"
			:to="{ name: 'personal_information' }"
			class="nextButton"
		>
			Avançar ->
		</router-link>
		<a v-else class="nextButton" @click="finishButton">Finanlizar -></a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
import {mask} from 'vue-the-mask'
export default {
	extends: WizardView,
	directives: {mask}
}
</script>

<style lang="scss" scoped>
	div {
		p:first-of-type { margin-bottom: 50px; }
		.warning { margin-top: 12px; font-size: 14px; line-height: 18px; color: rgba(255, 255, 255, 0.75); }
		a.nextButton { margin-top: 50px; }
		label {
			margin-top: 12px;
			margin-bottom: 40px;
			color: rgba(255, 255, 255, 0.75);
			font-size: 14px;
			line-height: 24px;
			display: block;
			&:hover { color: rgba(255, 255, 255, 1); }
			> input { vertical-align: text-top; }
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
	  }
	  .error {
  		vertical-align: middle;
  		width: auto;
  		&.active { display: inline-block; }
	  }
	}
</style>