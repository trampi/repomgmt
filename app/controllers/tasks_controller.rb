class TasksController < ApplicationController
  def show
    @task = Task.find params[:id]
    @comments = @task.comments
    @new_comment = Comment.new
  end

  def index
    @tasks = current_user.tasks_visible
  end

  def new
    @task = Task.new
    set_fields
    @task.title = params[:name] if params[:name]
  end

  def create
    @task = Task.new(task_params)
    @task.author = current_user
    if params[:commit] && @task.save
      flash[:success] = t('task.created')
      redirect_to repository_path @task.repository
    else
      set_fields
      render 'new'
    end
  end

  def edit
    @task = Task.find params[:id]
    set_fields
  end

  def update
    @task = Task.find params[:id]
    if params[:commit] && @task.update(task_params)
      flash[:success] = t('task.updated')
      redirect_to repository_path @task.repository
    else
      set_fields
      render 'edit'
    end
  end

  def destroy
    @task = Task.find params[:id]
    @task.destroy
    flash[:success] = t('task.deleted')
    redirect_to repository_path @task.repository
  end

  def solve
    @task = Task.find params[:id]
    @task.solved = true
    @task.save
    flash[:success] = t('task.solved')
    redirect_to repository_path @task.repository
  end

  private
  def set_fields
    @projects = current_user.repositories.all
    @project = selected_project
    @selected_project_id = selected_project_id
    @task.repository = @project

    if @project
      @versions = @project.versions
      @users = @project.users
    else
      @versions = []
      @users = []
    end

  end

  def selected_project
    if params[:task] && params[:task][:repository_id]
      current_user.repositories.find_by_id params[:task][:repository_id]
    elsif @task.repository
      @task.repository
    elsif params[:repository_id]
      current_user.repositories.find_by_id params[:repository_id]
    end
  end

  def selected_project_id
    selected_project.id unless selected_project.nil?
  end

  def task_params
    params.require(:task).permit(:title, :repository_id, :version_id, :assignee_id, :solved, :message)
  end
end
