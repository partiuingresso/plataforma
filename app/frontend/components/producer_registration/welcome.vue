<template>
	<div>
		<h1>Boas vindas, Nelson</h1>
		<p>Obrigado por confiar na PartiuIngresso.com para ser a bilheteria digital de seus eventos.</p>
		<p>
			Nos próximos passos cadastraremos as informações de seu negócio e em seguida você terá acesso
			a todas nossas ferramentas para publicar seus eventos e começar a vender. Este processo leva apenas
			poucos minutos.
		</p>
		<p>Partiu?</p>
		<router-link :to="{ name: 'identification_type' }" class="button is-primary">Vamos começar</router-link>
		<p>Seu negócio já está cadastrado por aqui?</p>
		<p>Não tem problema, <a>veja o que fazer neste caso</a>.</p>
	</div>
</template>
