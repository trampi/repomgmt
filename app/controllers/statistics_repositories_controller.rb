class StatisticsRepositoriesController < ApplicationController
	def index
		@repositories = current_user.repositories
	end

	def show
		@repository = current_user.repositories.find params[:id]
		@statistics = repository_statistics @repository
	end

	def repository_statistics repository
		return {
				:repository => repository,
				:commits_history => repository.get_commits_per_day.map { |date_and_commits| {
						date: date_and_commits[:date],
						commits: date_and_commits[:commits].count # we do not need all commits, just the count of commits per day
				} },
				:committer => repository.commits_per_author.map { |user, commits| {
						:name => (!user.nil? && user.email) || commits[0].author_email,
						:commits => commits.count
				} }
		}
	end
end
