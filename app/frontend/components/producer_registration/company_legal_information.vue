<template>
	<div>
		<h1>{{ data.company.name }}</h1>
		<p>Curti o nome! 😎</p>
		<p>Agora precisamos saber a <b>Razão Social</b> e o <b>CNPJ</b> de sua empresa.</p>
		<input
      v-autofocus
      v-model.lazy="$v.business_name.$model"
      :placeholder="`Ex: ${data.company.name} Produtora de Eventos Ltda`"
      v-on:keyup.enter="next"
    />
    <div v-if="$v.business_name.$error" class="error name active">Campo obrigatório</div>
		<input
      placeholder="Ex: 00.000.000/0000-00"
      v-model.lazy="$v.document_number.$model"
      v-mask="'##.###.###/####-##'"
      v-on:keyup.enter="next"
    />
    <div v-show="$v.document_number.$error">
      <div v-if="!$v.document_number.required" class="error active cnpj">Campo obrigatório</div>
      <div v-if="!$v.document_number.isCnpj" class="error active cnpj">Campo inválido</div>
    </div>
		<a @click="next" class="nextButton" tabindex="0">Avançar -></a>
	</div>
</template>

<script>
import WizardView from './wizard_view.vue'
import { mask } from 'vue-the-mask'
import { helpers, required } from 'vuelidate/lib/validators'
const isCnpj = helpers.regex('cnpj', /^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$/)
export default {
	extends: WizardView,
  directives: {
    mask
  },
  data() {
    return {
      business_name: '',
      document_number: ''
    }
  },
  validations: {
    business_name: {
      required
    },
    document_number: {
      required,
      isCnpj
    }
  },
  methods: {
    next() {
      this.$v.$touch()
      if(!this.$v.$invalid) {
        this.data.company.business_name = this.business_name
        this.data.company.document_number = this.document_number
        this.$router.push({ name: 'company_address' })
      }
    }
  }
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