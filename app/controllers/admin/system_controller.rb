class Admin::SystemController < ApplicationController
	def index
	end

	def reindex_repositories
		flash[:success] = 'Job enqueued'
		redirect_to admin_system_index_path
	end
end
