class ApplicationService
	attr_reader :errors

	def self.call(*args, &block)
		new(*args, &block).call
	end

	def success?
		@success
	end
end
