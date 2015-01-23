module RemovePasswordParamIfEmpty
  extend ActiveSupport::Concern

  included do
    before_action :remove_empty_password_param
  end

  def remove_empty_password_param
    password_params = params.slice :user
    if password_params.has_key? :user then
      password_param = password_params.require(:user).permit(:password)
      if password_param[:password].strip.empty? then
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end
  end
end
