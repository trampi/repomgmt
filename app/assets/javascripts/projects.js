jQuery(document).on("click", ".panel-heading, .panel-title", function(e) {
    // extend filter on click
    if(e.target == this) {
        jQuery(this).find("a").click();
    }
});

jQuery(document).on("change", "#repomgmt-tasks-filter input", function(e) {
    // refresh tasks on filter change
    var params = $(this).parents("form").serialize();
    var projectId = $("#project_id").val();
    $.get(Routes.repository_path(projectId), params).then(function(result) {
        $("#repomgmt-project-tasks").replaceWith($(result).find("#repomgmt-project-tasks"));
    });
});
