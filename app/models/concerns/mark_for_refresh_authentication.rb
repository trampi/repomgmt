module MarkForRefreshAuthentication
  extend ActiveSupport::Concern

  @authentication_rewrite_necessary = false

  def mark_authentication_for_rewrite *args
    @authentication_rewrite_necessary = true
  end
end
