$(document).on("page:change", function() {
    // on the create task view if project changes reload page to refresh projects and versions
    $("#task_repository_id").change(function(e) {
        $(this).parents("form").submit();
    });
});
