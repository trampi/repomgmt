module RewriteAuthorization
	extend ActiveSupport::Concern

	def rewrite_authorization_if_necessary model

		if model.instance_variable_get(:@authentication_rewrite_necessary)
			RewriteAuthJob.perform_later
		end

	end
end
