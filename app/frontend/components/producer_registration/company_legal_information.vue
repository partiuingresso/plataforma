<template>
	<div>
		<h1>{{ data.company.name }}</h1>
		<p>Curti o nome! 😎</p>
		<p>Agora precisamos saber a <b>Razão Social</b> e o <b>CNPJ</b> de sua empresa.</p>
		<input v-model="data.company.business_name" :placeholder="`Ex: ${data.company.name} Produtora de Eventos Ltda`" />
    <div class="error name">Este campo não pode ficar vazio</div>
		<input v-model="data.company.document_number" placeholder="Ex: 00.000.000/0000-00" v-mask="'##.###.###/####-##'" />
    <div class="error cnpj">CNPJ inválido</div>
		<router-link :to="{ name: 'company_address' }" class="nextButton">Avançar -></router-link>
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
  .error {
    &.name {
      margin-top: 10px;
      position: absolute;
    }
    &.cnpj {
      position: absolute;
      margin-top: -40px;
    }
  }
  input {
    &:last-of-type {
      margin-bottom: 50px;
    }
    margin-top: 50px;
    padding: 10px 0;
    border-bottom: 3px solid #C72328;
    border-style: none none solid none;
    width: 100%;
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
}
</style>