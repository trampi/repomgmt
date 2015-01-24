module RewriteAuthorization
  extend ActiveSupport::Concern

  def rewrite_authorization_if_necessary(model)
    RewriteAuthJob.perform_later if model.instance_variable_get(:@authentication_rewrite_necessary)
  end
end
