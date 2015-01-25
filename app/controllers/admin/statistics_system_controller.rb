class Admin::StatisticsSystemController < ApplicationController
  def index
    @statistics = {
        storage: storage,
        commits_history: commits_history,
        repositories: repositories,
        user_count: User.count,
        repository_count: Repository.count,
        commits_per_author: commits_per_author,
        commit_count: Commit.count
    }
  end

  private

  def storage
    {
        bytes_free: Repository.storage_bytes_free,
        bytes_used: Repository.storage_bytes_used,
        bytes_total: Repository.storage_bytes_total,
        percent_used: Repository.storage_used_in_percent
    }
  end

  def commits_history
    Rails.cache.fetch("commit_history_#{Repository.last_index_date}", expires_in: 1.month) do
      Repository.commits_per_day.map do |date_and_commits|
        {
            date: date_and_commits[:date],
            commits: date_and_commits[:commits].count # we do not need all commits, just the count of commits per day
        }
      end
    end
  end

  def repositories
    Repository.all.map do |repo|
      {
          name: repo.name,
          size_in_bytes: repo.size_in_bytes,
          commits: repo.commits.count
      }
    end
  end

  def commits_per_author
    Repository.commits_per_author.map do |author, commits|
      {
          author: (!author.nil? && author.email) || commits[0].author_email,
          commits: commits.count
      }
    end
  end
end
