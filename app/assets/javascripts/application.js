// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require bootstrap
//= require_tree .

$(function() {

$('.icon-info-sign').popover();
$(".alert").alert();
$(".content_block").hide();
$(".hide_block").hide();

$(".show_block").click(function(){
  $(this).next(".content_block").slideDown('slow', function(){
  });
  $(this).nextAll(".hide_block:first").show();
  $(this).hide();
});

$(".hide_block").click(function(){
  $(this).prev(".content_block").slideUp('slow', function(){
  });
  $(this).prevAll(".show_block:first").show();
  $(this).hide();
});

$("input[name='company[size]']").change(function(){
  url_var = "/companies/stats/" + $(this).val();
  $.ajax({
  url: url_var,
  success: function() {
}
});
});

$("#plate").fadeOut(15000);
$("#plat").fadeOut(15);



})
