<script>
export default {
	props: ['data', 'type'],
	methods: {
		finishButton() {
			this.$emit('finish')
		}
	}
}
</script>