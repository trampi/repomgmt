class StatisticsUsersController < ApplicationController
  def show
    @user = current_user.admin? ? User.find(params[:id]) : current_user
    @statistics = user_statistics @user
  end

  def user_statistics(user)
    {
        user: user,
        commits_history: commits_history(user),
        repositories: repositories(user)
    }
  end

  private

  def commits_history(user)
    user.commits_per_day.map do |date_and_commits|
      {
          date: date_and_commits[:date],
          commits: date_and_commits[:commits].count # we do not need all commits, just the count of commits per day
      }
    end
  end

  def repositories(user)
    user.commits_per_repository.map do |repository, commits|
      {
          name: repository.name,
          commits: commits.count
      }
    end
  end
end
