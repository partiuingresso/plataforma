<template>
	<div>
	  <div class="box">
			<div class="level">
				<div class="level-left">
					<div class="level-item">
						<p class="is-uppercase has-text-weight-semibold has-text-grey">Gerenciar ingressos</p>
					</div>
				</div>
			</div>
	    <div id="offers-create-area" class="section has-text-centered">
				<div class="subtitle is-6">
					<p>Qual tipo de ingresso você deseja criar?</p>
				</div>
	      <div class="">
				<a id="offer-button" class="button">
					<span class="icon has-text-success">
					  <i class="fas fa-plus"></i>
					</span>
					<span>Ingresso Pago</span>
				</a>
				<a id="offer-button" class="button">
					<span class="icon has-text-success">
					  <i class="fas fa-plus"></i>
					</span>
					<span>Ingresso Gratuito</span>
				</a>
	      </div>
	    </div>
	    <div class="tabs is-fullwidth">
				<ul>
					<li :class="{ 'is-active': this.availableFilter }" @click="setAvailableFilter(true)">
						<a>
							<span>Ativos</span>
						</a>
					</li>
					<li :class="{ 'is-active': !this.availableFilter }" @click="setAvailableFilter(false)">
						<a>
							<span>Não Ativos</span>
						</a>
					</li>
				</ul>
	    </div>
	    <div class="table-container">
				<table class="table is-fullwidth">
					<thead>
						<th>Nome</th>
						<th>Vendidos/Total</th>
						<th>Preço</th>
						<th>Preço final</th>
						<th></th>
					</thead>
					<tbody>
						<tr v-for="offer in filteredItems">
							<td>{{ offer.name }}</td>
							<td>{{ `${offer.sold}/${offer.quantity}` }}</td>
							<td>{{ offer.price }}</td>
							<td>{{ offer.price_with_fee }}</td>
							<td>
								<a v-if="offer.sold === 0" @click="confirmOfferDeletion(offer)">
					        <span class="icon">
						        <i class="fas fa-trash"></i>
							    </span>
								</a>
								<span class="icon" v-else></span>
								<a style="margin-right: 8px;" data-target="">
					        <span class="icon">
						        <i class="fas fa-edit"></i>
							    </span>
								</a>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<confirm_dialog
			v-if="showModal"
			title="Remover ingresso"
			:message="confirmMessage"
			type="is-danger"
			@close="showModal = false"
			@confirm="dialogConfirmed()"
		>
		</confirm_dialog>
	</div>
</template>

<script>
	import Rails from 'rails-ujs'
	export default {
		props: ['offers_data'],
		data() {
			return {
				offers: [],
				availableFilter: true,
				showModal: false,
				deletionOffer: null
			}
		},
		created() {
			this.offers = JSON.parse(this.offers_data).data
				.map(obj => Object.assign({id: obj.id}, obj.attributes))
		},
		methods: {
			setAvailableFilter(available) {
				this.availableFilter = available
			},
			confirmOfferDeletion(offer) {
				this.deletionOffer = offer
				this.showModal = true
			},
			dialogConfirmed() {
				this.showModal = false
				console.log(this.deletionOffer)
				this.deleteOffer()
			},
			deleteOffer() {
				Rails.ajax({
					url: `/offers/${this.deletionOffer.id}`,
					type: 'delete',
					data: '',
					success: this.successfulOfferDeletion,
					error: this.offerDeletionError
				})
			},
			successfulOfferDeletion() {
				this.$delete(this.offers, this.offers.indexOf(this.deletionOffer))
				bulmaToast.toast(
					{
						message: 'Ingresso removido com sucesso.',
						type: 'is-success',
						dismissible: true,
						duration: 10000,
						pauseOnHover: true,
						animate: { in: 'bounceInRight', out: 'bounceOutRight' }
					}
				)
				this.deletionOffer = null
			},
			offerDeletionError() {
				bulmaToast.toast(
					{
						message: 'Não foi possível remover esse ingresso.',
						type: 'is-danger',
						dismissible: true,
						duration: 10000,
						pauseOnHover: true,
						animate: { in: 'bounceInRight', out: 'bounceOutRight' }
					}
				)
			}
		},
		computed: {
			filteredItems() {
				return this.offers.filter(item => item.available === this.availableFilter)
			},
			confirmMessage() {
				return `Tem certeza que deseja remover o ingresso <b>${this.deletionOffer.name}</b>?`
			}
		}
	}
</script>

<style scoped>
	.table {
		box-shadow: none;
	}

	.icon.trash {
	  color: hsl(0, 0%, 48%);
	}

	.icon.trash:hover {
	  color: unset;
	}
</style>
