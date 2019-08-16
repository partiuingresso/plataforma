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
				<a id="offer-button" class="button" @click="newOffer('costly')">
					<span class="icon has-text-success">
					  <i class="fas fa-plus"></i>
					</span>
					<span>Ingresso Pago</span>
				</a>
				<a id="offer-button" class="button" @click="newOffer('free')">
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
						<tr v-for="offer in filteredItems" :key="offer.id" :offer="offer">
							<td>{{ offer.name }}</td>
							<td>{{ `${offer.sold}/${offer.quantity}` }}</td>
							<td>{{ format(offer.price) }}</td>
							<td>{{ format(offer.price_with_fee) }}</td>
							<td>
								<a v-if="offer.sold === 0" @click="confirmOfferDeletion(offer)">
					        <span class="icon">
						        <i class="fas fa-trash"></i>
							    </span>
								</a>
								<span class="icon" v-else></span>
								<a style="margin-right: 8px;" @click="editOffer(offer)">
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
		<confirm-dialog
			v-if="confirmDialogVisible"
			title="Remover ingresso"
			:message="confirmMessage"
			type="is-danger"
			@close="confirmDialogClosed()"
			@confirm="dialogConfirmed()"
		>
		</confirm-dialog>
		<ticket-form
			v-if="ticketFormVisible"
			:event="event"
			:offer="selectedOffer"
			:free="ticketFree"
			@close="ticketFormClosed()"
		></ticket-form>
	</div>
</template>

<script>
import Rails from 'rails-ujs'
import ConfirmDialog from './confirm_dialog.vue'
import TicketForm from './ticket_form.vue'
import Money from 'src/utils/money'
export default {
	components: {
		'confirm-dialog': ConfirmDialog,
		'ticket-form': TicketForm
	},
	props: ['offers_data', 'event'],
	data() {
		return {
			offers: [],
			availableFilter: true,
			ticketFormVisible: false,
			confirmDialogVisible: false,
			selectedOffer: null,
			ticketFree: false
		}
	},
	created() {
		this.fetchOffers()
		this.$root.$on('edit:offer', ($event) => {
			let updatedOffer = this.offers.find((element) => element.id === $event.id)
			Object.assign(updatedOffer, $event)
		})
		this.$root.$on('create:offer', ($event) => {
			this.offers.unshift($event)
		})
	},
	methods: {
		format(value) {
			const intValue = Math.round(value * 100)
			return new Money({amount: intValue}).toFormat()
		},
		fetchOffers() {
			this.offers = JSON.parse(this.offers_data).data
				.map(obj => Object.assign({id: obj.id}, obj.attributes))
		},
		setAvailableFilter(available) {
			this.availableFilter = available
		},
		newOffer(type) {
			if(type === 'costly') {
				this.ticketFree = false
				this.setTicketFormVisible()
			} else {
				this.ticketFree = true
				this.setTicketFormVisible()
			}
		},
		editOffer(offer) {
			this.selectedOffer = offer
			this.ticketFree = offer.price === 0
			this.setTicketFormVisible()
		},
		ticketFormClosed() {
			this.setTicketFormVisible(false)
			this.selectedOffer = null
		},
		confirmOfferDeletion(offer) {
			this.selectedOffer = offer
			this.setConfirmDialogVisible()
		},
		dialogConfirmed() {
			this.setConfirmDialogVisible(false)
			this.deleteOffer()
		},
		confirmDialogClosed() {
			this.setConfirmDialogVisible(false)
			this.selectedOffer = null
		},
		async deleteOffer() {
			Rails.ajax({
				url: `/offers/${this.selectedOffer.id}`,
				type: 'delete',
				data: '',
				success: this.successfulOfferDeletion,
				error: this.offerDeletionError
			})
		},
		successfulOfferDeletion() {
			this.$delete(this.offers, this.offers.indexOf(this.selectedOffer))
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
			this.selectedOffer = null
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
			this.selectedOffer = null
		},
		setConfirmDialogVisible(visible=true) {
			this.confirmDialogVisible = visible
		},
		setTicketFormVisible(visible=true) {
			this.ticketFormVisible = visible
		}
	},
	computed: {
		filteredItems() {
			return this.offers.filter(item => (item.available && item.active) === this.availableFilter)
		},
		confirmMessage() {
			return `Tem certeza que deseja remover o ingresso <b>${this.selectedOffer.name}</b>?`
		}
	}
}
</script>

<style lang="scss" scoped>
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
