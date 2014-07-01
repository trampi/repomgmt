window.Repomgmt.StatisticsSystem = function() {
    $.get(Repomgmt.adminStatisticsSystemPath(), function(statistics) {

        Morris.Line({
            element: 'repository-statistics-commits-history',
            xkey: "date",
            ykeys: ["commits"],
            data: statistics.commits_history,
            labels: ["Commits"]
        });

        Morris.Donut({
            element: 'repository-statistics-sizes',
            data: statistics.repositories.map(function(repo) {
                return {
                    label: repo.name,
                    value: repo.size_in_bytes
                };
            }),
            formatter: function(sizeInBytes, object) {
                return numeral(sizeInBytes).format("0.0 b");
            }
        });

        Morris.Donut({
            element: 'repository-statistics-repositories-commits',
            data: statistics.repositories.map(function(repo) {
                return {
                    label: repo.name,
                    value: repo.commits
                };
            }),
            formatter: function(numberOfCommits, object) {
                return numberOfCommits + " Commits";
            }
        });

        Morris.Donut({
            element: 'repository-statistics-author-commits',
            data: statistics.commits_per_author.map(function(commit_author_tuple) {
                return {
                    label: commit_author_tuple.author,
                    value: commit_author_tuple.commits
                };
            }),
            formatter: function(numberOfCommits, object) {
                return numberOfCommits + " Commits";
            }
        });
    });
};
