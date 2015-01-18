module MapDaysToCommits
	extend ActiveSupport::Concern

	def map_days_to_commits all_commits

		if all_commits.empty?
			return []
		end

		sorted_commits = all_commits.sort { |c1, c2| c1.date <=> c2.date }

		first_commit = sorted_commits.first
		last_commit = sorted_commits.last

		# span a range from first commit to today
		dates = {}
		(first_commit.date.to_date .. last_commit.date.to_date).each do |date|
			dates[date] = []
		end

		sorted_commits.each do |commit|
			dates[commit.date.to_date] << commit
		end

		dates.to_a.map { |e| {date: e[0], commits: e[1]} }
	end
end
