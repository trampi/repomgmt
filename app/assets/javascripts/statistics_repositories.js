window.Repomgmt.StatisticsRepositories = function(repositoryId) {
	$.get(Repomgmt.statisticsRepositoryPath(repositoryId), function(statistics) {

		Morris.Line({
			element: 'repository-statistics-commits-history',
			xkey: "date",
			ykeys: ["commits"],
			data: statistics.commits_history,
			labels: ["Commits"]
		});

		Morris.Donut({
			element: 'repository-statistics-commiters',
			data: statistics.committer.map(function(committer) {
				return {
					label: committer.name,
					value: committer.commits
				};
			}),
			formatter: function(numberOfCommits, object) {
				return numberOfCommits + " Commits";
			}
		});
	});
};
