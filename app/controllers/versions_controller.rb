class VersionsController < ApplicationController
	def index
		@project = Repository.find params[:repository_id]
		@versions = @project.versions
	end

	def new
		@project = Repository.find params[:repository_id]
		@version = Version.new
	end

	def edit
		@version = Version.find params[:id]
		@project = @version.repository
	end

	def update
		@version = Version.find params[:id]
		if @version.update version_params then
			flash[:success] = t(:version_updated)
			redirect_to repository_versions_path(@version.repository)
		else
			@project = @version.repository
			render 'edit'
		end
	end

	def create
		@version = Repository.find(params[:repository_id]).versions.build version_params
		if @version.save then
			flash[:success] = t(:version_created)
			redirect_to repository_versions_path(@version.repository)
		else
			@project = Repository.find params[:repository_id]
			render 'new'
		end

	end

	def destroy
		@version = Version.find params[:id]
		@version.destroy
		flash[:success] = t(:version_deleted)
		redirect_to repository_versions_path(@version.repository)
	end

	private
	def version_params
		params.require(:version).permit(:name, :due_date, :delivered)
	end
end
