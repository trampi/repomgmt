// global search bar
if(Repomgmt.isLoggedIn()) {
    var usersFetchedPromise = $.get(Routes.admin_users_path({format: "json"}));
    var repositoriesFetchedPromise = $.get(Routes.admin_repositories_path({format: "json"}));
    var tasksPromise = $.get(Routes.tasks_path({format: "json"}));

    $(document).on("page:change", function() {
        $search = $("#repomgmt-search");

        var requestResolved = $.when(usersFetchedPromise, repositoriesFetchedPromise, tasksPromise);
        requestResolved.then(function(usersAjaxResult, repositoriesAjaxResult, tasksAjaxResult) {
            var mapToUrl = function(urlMappingFunction, maybeArray) {
                return Repomgmt.safeArray(maybeArray).map(function(elem) {
                    elem.url = urlMappingFunction(elem);
                    return elem;
                });
            };

            var users = mapToUrl(Routes.edit_admin_user_path, usersAjaxResult[0]);
            var repositories = mapToUrl(Routes.edit_admin_repository_path, repositoriesAjaxResult[0]);
            var tasks = mapToUrl(Routes.edit_task_path, tasksAjaxResult[0]);
            var filterCollectionForStringAttribute = function(collection, attribute, query) {
                return collection.filter(function(elem) {
                    return elem[attribute].containsCaseInsensitive(query);
                });
            };

            var repositorySearcher = {
                displayKey: 'name',
                source: function(query, callback) {
                    var result = filterCollectionForStringAttribute(repositories, "name", query);

                    if(result.length === 0) {
                        result.push({
                            name: "Projekt " + query + " anlegen?",
                            url: Routes.admin_new_repository_name_path(query)
                        });
                    }

                    callback(result);
                },
                templates: {
                    header: '<div class="typeahead-header">Projekte</div>'
                }
            };
            var taskSearcher = {
                name: "Tasks",
                displayKey: 'title',
                source: function(query, callback) {
                    var result = tasks.filter(function(elem) {
                        return elem.title.containsCaseInsensitive(query)
                                || elem.id == query;
                    });

                    if(result.length === 0) {
                        result.push({
                            title: "Task " + query + " anlegen?",
                            url: Routes.new_task_name_path(query)
                        });
                    }

                    callback(result);
                },
                templates: {
                    header: '<div class="typeahead-header">Tasks</div>'
                }
            }
            var userSearcher = { // Users
                displayKey: 'name',
                source: function(query, callback) {
                    var result = filterCollectionForStringAttribute(users, "name", query);

                    if(result.length === 0) {
                        result.push({
                            name: "Benutzer " + query + " anlegen?",
                            url: Routes.admin_new_user_name_path(query)
                        });
                    }

                    callback(result);
                },
                templates: {
                    header: '<div class="typeahead-divider"></div><div class="typeahead-header">Benutzer</div>'
                }
            }

            if(Repomgmt.isAdmin()) {
                // add a divider because we want to group the different searchers
                taskSearcher.templates.header = '<div class="typeahead-divider"></div><div class="typeahead-header">Tasks</div>';

                $search.typeahead({
                        highlight: true
                    },
                    repositorySearcher,
                    userSearcher,
                    taskSearcher
                );
            } else {
                // normal user, tasks only
                $search.typeahead(
                    {
                        highlight: true
                    },
                    taskSearcher
                );
            }

            // when a element from the search is selected we should navigate to it
            var visitHandler = function(e, suggestionObject) {
                Turbolinks.visit(suggestionObject.url);
            };
            $search.on("typeahead:selected typeahead:autocompleted", visitHandler);

        });
    });
}
