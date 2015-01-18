class Admin::StatisticsSystemController < ApplicationController
	def index

		commits_history = Rails.cache.fetch("commit_history_#{Repository.last_index_date.to_s}", {expires_in: 1.month}) do
			Repository.get_commits_per_day.map { |date_and_commits| {
					date: date_and_commits[:date],
					commits: date_and_commits[:commits].count # we do not need all commits, just the count of commits per day
			} }
		end

		@statistics = {
				:storage => {
						:bytes_free => Repository.storage_bytes_free,
						:bytes_used => Repository.storage_bytes_used,
						:bytes_total => Repository.storage_bytes_total,
						:percent_used => Repository.storage_used_in_percent
				},
				:commits_history => commits_history,
				:repositories => Repository.all.map { |repo| {
						:name => repo.name,
						:size_in_bytes => repo.size_in_bytes,
						:commits => repo.commits.count
				} },
				:user_count => User.count,
				:repository_count => Repository.count,
				:commits_per_author => Repository.commits_per_author.map { |author, commits| {
						:author => (!author.nil? && author.email) || commits[0].author_email,
						:commits => commits.count
				} },
				:commit_count => Commit.count
		}
	end
end
