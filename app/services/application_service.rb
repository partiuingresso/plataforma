class ApplicationService

	def self.call(*args, &block)
		new(*args, &block).call
	end

	def initialize
		@errors ||= []
	end

	def success?
		@success
	end
	
	def full_error_message
		@errors.join("\n")
	end

	private

		def set_error_message(msg)
			@errors.push(msg)
		end

end
