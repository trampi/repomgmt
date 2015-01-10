module RewriteAuthorization
  extend ActiveSupport::Concern

  def rewrite_authorization_if_necessary model
    if model.instance_variable_get(:@authentication_rewrite_necessary) && !RepositoryAccess.rewrite_auth
      err = 'Error while granting rights, please contact the system administrator.'
      if flash.key?(:alert)
        flash[:alert] += '<br />' + err
      else
        flash[:alert] = err
      end
    end
  end
end
