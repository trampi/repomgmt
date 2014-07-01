class SettingsUserController < ApplicationController
	include RemovePasswordParamIfEmpty

	def index
		@user = current_user
	end

	def update
		@user = current_user
		if @user.update(user_params) then
			flash[:success] = "Benutzer #{@user.name} gespeichert."
			redirect_to settings_user_path
		else
			render 'index'
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation, :public_key)
	end

end
