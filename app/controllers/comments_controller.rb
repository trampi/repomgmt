class CommentsController < ApplicationController
  def create
    @task = Task.find params[:task_id]
    @comment = build_comment @task
    if @comment.save
      flash[:success] = t('comment.saved')
    else
      flash[:alert] = t('comment.error_saving')
    end
    redirect_to @task
  end

  private

  def build_comment(task)
    task.comments.build(user: current_user, message: params[:comment][:message])
  end
end
