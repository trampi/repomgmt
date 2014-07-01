class CommentsController < ApplicationController
	def create
		@task = Task.find params[:task_id]
		@comment = @task.comments.build
		@comment.user = current_user
		@comment.message = params[:comment][:message]
		if @comment.save then
			flash[:success] = "Ihr Kommentar wurde gespeichert!"
		else
			flash[:alert] = "Es trat ein Fehler beim Speichern des Kommentars auf. Haben Sie einen Text eingegeben?"
		end
		redirect_to @task
	end
end
