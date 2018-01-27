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
//= require jquery
//= require rails-ujs
//= require_tree .

//**************************** DASHBOARD ***************************
$(function(){
  //responsible for switching views in the dashboard on click
  $("a.load").click(function (e) {
    e.preventDefault();
    $("#tutor_view_frame").load($(this).attr("href"));
  });

  $("a.tu_load").click(function (e) {
    e.preventDefault();
    $("#tutee_view_frame").load($(this).attr("href"));
  });

  //for side nav bar, child ('button') triggers parent action ('li')
  $(".menu ul li .btn").click(function (e) {
    $(this).closest("li").focus();
  });

  //for side nav bar, parent ('li') triggers child('button')
  $(".menu ul li").click(function (e) {
    //$(this).find(".btn")[0].click();
  });
});

//default view page for the dashboards
$(document).ready(function(){
  $("#tutor_view_frame").load("/tutor/incoming_requests");
  $("#tutee_view_frame").load("/tutee/find_tutor");
});

//************************* DASHBOARD end **************************
