module MapDaysToCommits
	extend ActiveSupport::Concern

	def map_days_to_commits all_commits
		# find first commit
		first_commit = all_commits.min_by { |commit| commit.date }
		if first_commit.nil? then
			return []
		end

		# span a range from first commit to today
		dates = (first_commit.date.to_date .. Date.today).to_a

		# group the commits by day, e.g. [{"2014-06-02" => [commits]}, {"2014-06-03" => [commits]}]
		dates.map { |date| {
			date: date,
			commits: all_commits.find_all {|commit| commit.date.to_date == date }
		}}
	end
end
