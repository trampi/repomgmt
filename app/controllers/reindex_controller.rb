class ReindexController < ApplicationController

	def index
		if params[:secret] == Rails.configuration.repomgmt.reindex_secret
			Repository.index_commits
		end
		render nothing: true
	end

end
