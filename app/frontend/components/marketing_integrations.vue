<template>
	<div>
		<div class="box integrations-area">
			<div class="level">
				<div class="level-left">
					<div class="level-item">
						<p class="is-uppercase has-text-weight-semibold has-text-grey">Integrações</p>
					</div>
				</div>
			</div>
			<div class="item">
				<span>
					Google Analytics
				</span>
				<a class="button is-small is-text" @click="editing.google = !editing.google">
					<span>Conectar</span>
					<span class="icon is-small">
						<i class="fas fa-chevron-down"></i>
					</span>
				</a>
			</div>
			<div class="field has-addons" v-show="editing.google">
				<div class="control is-expanded">
					<input
						v-model="googleAnalytics"
						class="input"
						type="text"
						placeholder="Exemplo: UA-123456-1"
					/>
				</div>
				<div class="control">
					<a
						@click="saveGoogle"
						:disabled="googleAnalytics == google"
						:class="{ 'is-info': googleAnalytics != google, 'is-loading': savingGoogle }"
						class="button"
					>
						Salvar
					</a>
				</div>
			</div>
			<hr>
			<div class="item">
				<span>
					Facebook Pixel
				</span>
				<a class="button is-small is-text" @click="editing.fb = !editing.fb">
					<span>Conectar</span>
					<span class="icon is-small">
						<i class="fas fa-chevron-down"></i>
					</span>
				</a>
			</div>
			<div class="field has-addons" v-show="editing.fb">
				<div class="control is-expanded">
					<input
						v-model="fbPixel"
						class="input"
						type="text"
						placeholder="Número de identificação do Pixel"
					/>
				</div>
				<div class="control">
					<a
						@click="saveFacebook"
						:disabled="fbPixel == fb"
						:class="{ 'is-info': fbPixel != fb, 'is-loading': savingFacebook }"
						class="button"
					>
						Salvar
					</a>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	import Rails from 'rails-ujs'
	export default {
		props: ['admin', 'event_id', 'fb', 'google'],
		data() {
			return {
				editing: {
					google: false,
					fb: false
				},
				fbPixel: '',
				googleAnalytics: '',
				savingGoogle: false,
				savingFacebook: false
			}
		},
		created() {
			this.fbPixel = this.fb
			this.googleAnalytics = this.google
		},
		methods: {
			saveFacebook() {
				this.savingFacebook = true
				const formData = new FormData()
				formData.append('event[fb_pixel]', this.fbPixel)
				Rails.ajax({
					url: this.url,
					type: 'patch',
					data: formData,
					success: this.success,
					error: this.error
				})
			},
			saveGoogle() {
				this.savingGoogle = true
				const formData = new FormData()
				formData.append('event[ga_id]', this.googleAnalytics)
				Rails.ajax({
					url: this.url,
					type: 'patch',
					data: formData,
					success: this.success,
					error: this.error
				})
			},
			success() {
				this.savingGoogle = false
				this.savingFacebook = false
				bulmaToast.toast(
					{
						message: 'Integração feita com sucesso.',
						type: 'is-success',
						dismissible: true,
						duration: 5000,
						pauseOnHover: true,
						animate: { in: 'bounceInRight', out: 'bounceOutRight' }
					}
				)
			},
			error() {
				this.savingGoogle = false
				this.savingFacebook = false
				bulmaToast.toast(
					{
						message: 'Não foi possível fazer a integração.',
						type: 'is-danger',
						dismissible: true,
						duration: 5000,
						pauseOnHover: true,
						animate: { in: 'bounceInRight', out: 'bounceOutRight' }
					}
				)
			}
		},
		computed: {
			url() {
				const prefix = this.admin ? '/admin' : '/producer_admin'
				const url = prefix + `/events/${this.event_id}/marketings`

				return url
			}
		}
	}
</script>

<style lang="scss" scoped>
	.integrations-area {
		max-width: 420px;

		& .item {
			display: flex;
			align-items: center;
			justify-content: space-between;
			margin-bottom: 20px;

		}

	}

</style>
