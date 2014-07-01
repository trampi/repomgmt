module RepositoryAccessRefresher
	extend ActiveSupport::Concern

	included do
		after_commit :rewrite_auth
		after_destroy :rewrite_auth
	end

	def rewrite_auth
		RepositoryAccess.rewrite_auth
	end
end
