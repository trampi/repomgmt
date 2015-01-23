class StatisticsUsersController < ApplicationController
  def show
    @user = current_user.admin? ? User.find(params[:id]) : current_user
    @statistics = user_statistics @user
  end

  def user_statistics user
    return {
        :user => user,
        :commits_history => user.get_commits_per_day.map { |date_and_commits| {
            date: date_and_commits[:date],
            commits: date_and_commits[:commits].count() # we do not need all commits, just the count of commits per day
        } },
        :repositories => user.commits_per_repository.map { |repository, commits| {
            :name => repository.name,
            :commits => commits.count()
        } }
    }
  end
end
