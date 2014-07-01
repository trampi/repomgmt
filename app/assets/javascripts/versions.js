$(document).on("page:change", function() {
    $('#version_due_date').datepicker({
        format: "yyyy-mm-dd",
        language: "de",
        autoclose: true,
        todayHighlight: true
    });
});
