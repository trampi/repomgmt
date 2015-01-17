class Admin::SystemController < ApplicationController
	def index
	end

	def reindex_repositories
		Repository.index_commits
		redirect_to admin_system_index_path
	end
end
