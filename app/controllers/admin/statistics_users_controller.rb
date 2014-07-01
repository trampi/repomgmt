class Admin::StatisticsUsersController < StatisticsUsersController
	def index
		@users = User.all
	end

	def show
		@user = User.find params[:id]
		@statistics = user_statistics @user
	end
end
