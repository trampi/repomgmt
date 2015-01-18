class RewriteAuthJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    RepositoryAccess.rewrite_auth
  end
end
