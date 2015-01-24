class SettingsUserController < ApplicationController
  include RemovePasswordParamIfEmpty
  include RewriteAuthorization

  def index
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      sign_in @user, bypass: true # prevent logging out if password changes
      rewrite_authorization_if_necessary @user
      flash[:success] = "Benutzer #{@user.name} gespeichert."
      redirect_to settings_user_path
    else
      render 'index'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :public_key, :locale)
  end
end
