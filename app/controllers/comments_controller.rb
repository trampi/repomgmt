class CommentsController < ApplicationController
  def create
    @task = Task.find params[:task_id]
    @comment = @task.comments.build
    @comment.user = current_user
    @comment.message = params[:comment][:message]
    if @comment.save
      flash[:success] = t('comment.saved')
    else
      flash[:alert] = t('comment.error_saving')
    end
    redirect_to @task
  end
end
