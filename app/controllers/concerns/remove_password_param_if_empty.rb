module RemovePasswordParamIfEmpty
  extend ActiveSupport::Concern

  included do
    before_action :remove_empty_password_param
  end

  def remove_empty_password_param
    password_params = params.slice :user
    return unless password_params.key? :user
    password_param = password_params.require(:user).permit(:password)
    return unless password_param[:password].strip.empty?
    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
  end
end
