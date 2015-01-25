module MapDaysToCommits
  extend ActiveSupport::Concern

  def map_days_to_commits(all_commits)
    return [] if all_commits.empty?
    first_commit, last_commit = all_commits.minmax { |c1, c2| c1.date <=> c2.date }
    dates = span_dates_hash(first_commit, last_commit)

    all_commits.each { |commit| dates[get_date_of_commit(commit)] << commit }

    dates.to_a.map do |e|
      {
          date: e[0],
          commits: e[1]
      }
    end
  end

  private

  def get_date_of_commit(commit)
    commit.date.to_date
  end

  def span_dates_hash(first_commit, last_commit)
    dates = {}
    (get_date_of_commit(first_commit) .. get_date_of_commit(last_commit)).each do |date|
      dates[date] = []
    end
    dates
  end
end
