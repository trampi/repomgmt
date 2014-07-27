window.Repomgmt.StatisticsUser = function(userId) {
    $.get(Routes.statistics_user_path(userId, {format: "json"}), function(statistics) {

        Morris.Line({
            element: 'repository-statistics-commits-user-repositories-history',
            xkey: "date",
            ykeys: ["commits"],
            data: statistics.commits_history,
            labels: ["Commits"]
        });

        Morris.Donut({
            element: 'repository-statistics-commits-user-repositories',
            data: statistics.repositories.map(function(repository) {
                return {
                    label: repository.name,
                    value: repository.commits
                };
            }),
            formatter: function(numberOfCommits, object) {
                return numberOfCommits + " Commits";
            }
        });
    });
};
