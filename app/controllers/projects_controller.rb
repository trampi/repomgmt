class ProjectsController < ApplicationController
  def index
    @repositories = current_user.repositories
  end

  def show
    @project = current_user.repositories.find(params[:id])
    @tasks = @project.tasks
    @filter_set = false

    # filters for tasks
    pre_filter_tasks

    # this filter needs to be used as last because it will execute the built query
    return unless params[:state]
    post_filter_tasks
  end

  private

  def pre_filter_tasks
    filter_for :version
    filter_for :author
    filter_for :assignee
  end

  def filter_for(sym)
    return unless params[sym]
    @filter_set = true
    params[sym].each { @tasks = @tasks.where(sym => params[sym]) }
  end

  def post_filter_tasks
    @filter_set = true
    remaining_tasks = []

    %w(not_assigned in_progress solved).each do |state|
      sym = (state + '?').to_sym
      remaining_tasks += @tasks.to_a.find_all(&sym) if params[:state].include?(state)
    end

    @tasks = remaining_tasks
  end
end
