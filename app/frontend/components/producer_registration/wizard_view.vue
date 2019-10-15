<script>
export default {
	props: ['data', 'type', 'loading'],
	methods: {
		finishButton() {
			this.$emit('finish')
		}
	}
}
</script>