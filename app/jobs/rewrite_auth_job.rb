class RewriteAuthJob < ActiveJob::Base
  queue_as :default

  def perform(*)
    RepositoryAccess.rewrite_auth
  end
end
