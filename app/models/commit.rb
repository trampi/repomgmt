class Commit < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user

  def self.convert commit
    Commit.new({message: commit.message,
                sha: commit.sha,
                date: commit.author.date,
                author_email: commit.author.email,
                author_name: commit.author.name,
                committer_email: commit.committer.email,
                committer_name: commit.committer.name,
                commit_date: commit.committer.date})
  end

end
