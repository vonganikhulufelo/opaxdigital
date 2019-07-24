// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require rails-ujs
//= require jquery.turbolinks
//= require datatables
//= require activestorage
//= require turbolinks
//= require datatables
//= require select2.min
//= require popper.min
//= require bootstrap.min
//= require datatables
//= require custombox.min
//= require imports
//= require toastr.min
//= require d3
//= require c3
//= require jquery.peity.min.js
//= require echarts



$(document).on('turbolinks:load', function() {

  // hide spinner
  $("#spinner").hide();


  // show spinner on AJAX start
  $(document).on("page:fetch", function(){
    $("#spinner").show();
  });

  // hide spinner on AJAX stop
  $(document).on("page:receive", function(){
    $("#spinner").delay(3000).fadeOut();
  });

});

$(document).on('turbolinks:load', function() {

    $('form').on('click', '.remove_record', function(event) {
      $(this).prev('input[type=hidden]').val('1');
      $(this).closest('tr').hide();
      return event.preventDefault();
    });
  
    $('form').on('click', '.add_fields', function(event) {
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $('.fields').append($(this).data('fields').replace(regexp, time));
      return event.preventDefault();
    });
    
  });

$(document).ready(function(){
  $('.back').click(function(){
      parent.history.back();
      return false;
  });
})

$(document).ready(function() {
    
  $('.js-searchable').select2({
    allowClear: true,
    width: 300,
    placeholder: "Select a state"
    // If you are using Bootstrap, please add　`theme: "bootstrap"` too.
  });

  $(".js-example-placeholder-single").select2({
    placeholder: "Select a state",
    allowClear: true
  });

  $('.select2').select2();
})
  

$(document).on('turbolinks:load', function() {
  if ($(window).width() >= 768) {
      $('#menu').on('click', function () {
          $('body').toggleClass('sidebar-enable enlarged');
          $(this).toggleClass('sidebar-enable enlarged');
      });
      }else{
      $('#menu').on('click', function () {
          $('body').toggleClass('sidebar-enable');
          $(this).toggleClass('sidebar-enable');
      });
    }

      
  });