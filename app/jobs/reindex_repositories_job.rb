class ReindexRepositoriesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Repository.index_commits
  end
end
