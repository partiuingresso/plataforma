<template>
	<div>
		<h1>Identificação</h1>
		<p>Você gostaria de utilizar a <strong>PartiuIngresso.com</strong> para publicar seus eventos e receber pagamentos como...</p>
		<router-link
			:to="{ name: 'personal_information', params: { type: 'personal' } }"
			class="selectButton"
		>
			Pessoa Física
		</router-link>
		<router-link :to="{ name: 'company_fantasy_name' }" class="selectButton">Pessoa Jurídica</router-link>
	</div>
</template>

<style lang="scss" scoped>
	div {
		.selectButton {
			margin-top: 60px;
			display: inline-block;
			width: 240px;
			border: 3px solid #C72328;
			border-radius: 10px;
			padding: 20px 0;
			text-align: center;
			font-weight: 600;
			font-size: 20px;
			line-height: 20px;
			color: #ffffff;
	    transition: background-color 250ms ease;
			&:hover { background-color: #C72328; }
			&:first-of-type { margin-right: 40px; }
		}
	}
</style>