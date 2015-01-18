class ReindexController < ApplicationController

	def index
		if params[:secret] == Rails.configuration.repomgmt.reindex_secret
			ReindexRepositoriesJob.perform_later
		end
		render nothing: true
	end

end
