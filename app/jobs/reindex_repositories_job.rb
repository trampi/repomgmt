class ReindexRepositoriesJob < ActiveJob::Base
  queue_as :default

  def perform(*)
    Repository.index_commits
  end
end
