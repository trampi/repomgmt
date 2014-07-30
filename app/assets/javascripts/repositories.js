//= require twitter/typeahead

window.Repomgmt.UserRelations = function(userIdsInRepository) {
    // adding users to a project
    $.get(Routes.admin_users_path({format: "json"}), function(allUsers) {
        var usersInRepository = allUsers.filter(function(user) {
            return userIdsInRepository.contains(user.id);
        });
        var usersNotInRepository = allUsers.filter(function(user) {
            return !userIdsInRepository.contains(user.id);
        });
        var userRemoveButtonClass = ".repository-user-remove";
        var $typeahead = $("#repository-user-input");
        var $userAdd = $("#repository-user-add");
        var $repositoryTableBody = $("#repository-user-table");

        var addUser = function(userToAdd) {
            usersInRepository.push(userToAdd);
            usersNotInRepository = usersNotInRepository.filter(function(user) {
                return user != userToAdd;
            });
        };

        var removeUser = function(userToRemove) {
            usersNotInRepository.push(userToRemove);
            usersInRepository = usersInRepository.filter(function(user) {
                return user != userToRemove;
            });
        };

        var refreshView = function() {
            usersInRepository.sort(function(a, b) {
                return a.name > b.name ? 1 : -1;
            });
            var userRowsHtml = HandlebarsTemplates["repositories/user-row"]({users: usersInRepository});
            $repositoryTableBody.html(userRowsHtml);
        }

        var addUserFromInput = function() {
            var query = $typeahead.typeahead('val');
            var user = usersNotInRepository.find(function(user) {
                return user.name == query;
            });

            if(user != null) {
                addUser(user);
                $typeahead.typeahead('val', '');
                refreshView();
            }
        }

        $userAdd.click(function() {
            addUserFromInput();
        });

        $typeahead.keypress(function(e) {
            var ENTER_KEY = 13
            if (e.which == ENTER_KEY) {
                addUserFromInput();
                e.preventDefault();
                return false;
            }
        });

        $(document).on("click", userRemoveButtonClass, function() {
            var userId = $(this).data("userId");
            var user = allUsers.find(function(user) { return user.id === userId });
            removeUser(user);
            refreshView();
        });

        $typeahead.typeahead({
                highlight: true
            },
            {
                displayKey: 'name',
                source: function(query, callback) {
                    var usersMatching = usersNotInRepository.filter(function(user) {
                        return user.name.toLowerCase().indexOf(query.toLowerCase()) >= 0;
                    });
                    callback(usersMatching);
                },
                templates: {
                    empty: '<div class="typeahead-item">No user found</div>',
                }
            }
        );

        refreshView();
    });
};
