module MapDaysToCommits
	extend ActiveSupport::Concern

	def map_days_to_commits all_commits
		# find first commit
		first_commit = all_commits.min_by { |commit| commit.date }
		if first_commit.nil? then
			return []
		end

		last_commit = all_commits.max_by { |commit| commit.date }

		# span a range from first commit to today
		dates = (first_commit.date.to_date .. last_commit.date.to_date).to_a

		# group the commits by day, e.g. [{date: "2014-06-02", commits: [commits]}, ...]
		dates.map { |date| {
				date: date,
				commits: all_commits.find_all { |commit| commit.date.to_date == date }
		} }
	end
end
