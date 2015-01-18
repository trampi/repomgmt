class ReindexController < ApplicationController

	def index
		if params[:secret] == Rails.configuration.repomgmt.reindex_secret
			Repository.index_commits
			# TODO: extract to a job
		end
		render nothing: true
	end

end
