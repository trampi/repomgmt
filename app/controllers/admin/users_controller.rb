class Admin::UsersController < ApplicationController
  include RemovePasswordParamIfEmpty
  include RewriteAuthorization

  def index
    @users = User.all
  end

  def new
    @user = User.new
    @user.name = params[:name] if params[:name]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      rewrite_authorization_if_necessary @user
      flash[:success] = "Benutzer #{@user.name} gespeichert."
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def reset_two_factor_auth
    @user = User.find(params[:id])
    @user.reset_auth
    flash[:success] = "Zwei-Faktor-Authentifizierung von #{@user.name} wurde erfolgreich zurueckgesetzt."
    redirect_to admin_users_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    rewrite_authorization_if_necessary @user
    flash[:success] = "Benutzer #{@user.name} wurde erfolgreich geloescht."
    redirect_to admin_users_path
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      rewrite_authorization_if_necessary @user
      flash[:success] = "Benutzer #{@user.name} gespeichert."
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:admin, :email, :name, :password, :password_confirmation, :public_key, :locale)
  end
end
