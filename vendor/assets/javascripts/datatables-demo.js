// Call the dataTables jQuery plugin
$(document).ready(function() {
  $('#dataTable').DataTable();
});


$(document).on('turbolinks:load', function(event) {
  // apply non-idempotent transformations to the body
  $('#dataTable').DataTable()
});