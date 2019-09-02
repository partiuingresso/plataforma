<template>
	<div>
		<h1>Identificação</h1>
		<p>Você gostaria de utilizar a PartiuIngresso.com para publicar seus eventos e receber pagamentos como...</p>
		<router-link
			:to="{ name: 'personal_information', params: { type: 'personal' } }"
			class="button is-primary"
		>
			Pessoa Física
		</router-link>
		<router-link :to="{ name: 'company_fantasy_name' }" class="button is-primary">Pessoa Jurídica</router-link>
	</div>
</template>
