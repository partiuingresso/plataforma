<template>
	<div>
		<h1>Boas vindas, {{ first_name }}!</h1>
		<p>Obrigado por confiar na <strong>PartiuIngresso.com</strong> para ser a bilheteria digital de seus eventos.</p>
		<br />
		<p>
			Nos próximos passos cadastraremos as informações de seu negócio e em seguida você terá acesso
			a todas nossas ferramentas para publicar seus eventos e começar a vender. <br />
			Este processo leva apenas poucos minutos.
		</p>
		<br />
		<p>Partiu? 😍</p>
		<router-link :to="{ name: 'identification_type' }" class="startButton">Vamos começar -></router-link>
		<div class="footerText">
			<strong>Seu negócio já está cadastrado por aqui?</strong>
			<span>Não tem problema, <a href="https://ajuda.partiuingresso.com" target="_blank">veja o que fazer neste caso</a>.</span>
		</div>
	</div>
</template>

<script>
	export default {
		props: ["first_name"]
	}
</script>

<style lang="scss" scoped>
	div {
		.startButton {
			display: block;
			background: #C72328;
			border-radius: 10px;
			max-width: 480px;
			font-weight: 600;
			font-size: 20px;
			line-height: 20px;
			color: #ffffff;
			border: none;
			outline: none;
			margin: 60px auto;
			padding: 20px 0;
			text-align: center;
			&:hover { background-color: #db2b2f; }
		}
		.footerText {
			font-size: 14px;
			text-align: center;
			color: rgba(255, 255, 255, 0.4);
			> span {
				display: block;
				a { text-decoration-line: underline; color: rgba(255, 255, 255, 0.4); }
			}
		}
	}
</style>