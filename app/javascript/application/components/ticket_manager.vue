<template>
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
    		<li :class="{ 'is-active': this.available_filter }" @click="setAvailableFilter(true)">
    			<a>
    				<span>Ativos</span>
    			</a>
    		</li>
    		<li :class="{ 'is-active': !this.available_filter }" @click="setAvailableFilter(false)">
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
							<a style="margin-right: 8px;" data-target="">
				        <span class="icon">
					        <i class="fas fa-edit"></i>
						    </span>
							</a>
							<a data-target="">
				        <span class="icon">
					        <i class="fas fa-trash"></i>
						    </span>
							</a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</template>

<script>
	export default {
		props: ['offers_data'],
		data() {
			return {
				available_filter: true
			}
		},
		created() {
			this.offers = JSON.parse(this.offers_data).data.map(obj => obj.attributes)
		},
		methods: {
			setAvailableFilter(available) {
				this.available_filter = available
			}
		},
		computed: {
			filteredItems() {
				return this.offers.filter(item => item.available === this.available_filter)
			}
		}
	}
</script>

<style scoped>
	.icon.trash {
	  color: hsl(0, 0%, 48%);
	}

	.icon.trash:hover {
	  color: unset;
	}

	.clickable-row {
	  cursor: pointer;
	}

	.table.table-events td {
	  line-height: 1.846;
	  padding: 0.83em;
	}
</style>
