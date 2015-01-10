class Admin::RepositoriesController < ApplicationController
	include RewriteAuthorization

	def index
		@repositories = Repository.all
	end

	def new
		@repository = Repository.new

		if params[:name] then
			@repository.name = params[:name]
		end
	end

	def create
		@repository = Repository.new(repository_params)
		@repository.users = User.find(user_ids || [])
		if @repository.save then
			rewrite_authorization_if_necessary @repository
			flash[:success] = "Repository #{@repository.name} gespeichert."
			redirect_to admin_repositories_path
		else
			render 'new'
		end
	end

	def edit
		@repository = Repository.find(params[:id])
	end

	def update
		@repository = Repository.find(params[:id])
		@repository.users = User.find(user_ids)
		if @repository.update(repository_params) then
			rewrite_authorization_if_necessary @repository
			flash[:success] = "Repository #{@repository.name} gespeichert."
			redirect_to admin_repositories_path
		else
			render 'edit'
		end
	end

	def destroy
		@repository = Repository.find(params[:id]);
		@repository.destroy
		rewrite_authorization_if_necessary @repository
		flash[:success] = "Repository #{@repository.name} wurde erfolgreich gelöscht."
		redirect_to admin_repositories_path
	end

	private
	def repository_params
		params.require(:repository).permit(:name)
	end

	def user_ids
		params.require(:repository).fetch(:user_ids, [])
	end
end
