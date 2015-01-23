class ProjectsController < ApplicationController
  def index
    @repositories = current_user.repositories
  end

  def show
    @project = current_user.repositories.find(params[:id])
    @tasks = @project.tasks
    @filter_set = false

    #filters for tasks
    if params[:version] then
      @filter_set = true
      params[:version].each { @tasks = @tasks.where(version: params[:version]) }
    end

    if params[:author] then
      @filter_set = true
      params[:author].each { @tasks = @tasks.where(author: params[:author]) }
    end

    if params[:assignee] then
      @filter_set = true
      params[:assignee].each { @tasks = @tasks.where(assignee: params[:assignee]) }
    end

    #this filter needs to be used as last because it will execute the builded query
    if params[:state] then
      @filter_set = true
      remaining_tasks = []
      if params[:state].include?('notAssigned') then
        remaining_tasks += @tasks.to_a.find_all { |task| task.not_assigned? }
      end

      if params[:state].include?('inProgress') then
        remaining_tasks += @tasks.to_a.find_all { |task| task.in_progress? }
      end

      if params[:state].include?('solved') then
        remaining_tasks += @tasks.to_a.find_all { |task| task.solved? }
      end

      @tasks = remaining_tasks
    end
  end
end
