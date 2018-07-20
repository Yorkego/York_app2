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
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery3
//= require bootstrap-sprockets
//= require trix
//= require jquery
//= require jquery_ujs
//= require moment
//= require bootstrap-datetimepicker

$(document).on('change','.submit-on-change',function(){
  $("#filter_category").val($("#filter_post_category").val());
  $("#filter_direction").val($("#filter_post_decriment").val());
  $(".search > form").submit();
  });

$(document).ready(function(){
  $(".reply-button").click(function(){
    $(this).next('.reply').show();
    alert("broken");
  });
});


