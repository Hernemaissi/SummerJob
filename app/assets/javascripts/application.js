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

$(".level").change(function() {get_stats()} );
$(".capacity").change(function() {get_stats()});
$(".type").change(function() {get_stats()});
$(".specialized").change(function() {get_stats()});

function get_stats() {
  url_var = "/companies/init/stats/"
  level = typeof  $(".level:checked").val() !== 'undefined' ? $(".level:checked").val() : 1;
  capacity =  typeof $(".capacity:checked").val() !== 'undefined' ? $(".capacity:checked").val() : 1;
  type = typeof  $(".type:checked").val() !== 'undefined' ? $(".type:checked").val() : 1;
  specialized = typeof $(".specialized").is(':checked') !== 'undefined' ? $(".specialized").is(':checked')  : false;
  key_str = "level=" + level + "&capacity=" + capacity + "&type=" + type + "&specialized=" + specialized;
  $.ajax({
  url: url_var,
  data: key_str,
  success: function() {
}
});
}

$("#plate").fadeOut(15000);
$("#plat").fadeOut(15);

$("#search_users").click(function() {$(".users").hide();});

$(".query").bind("propertychange keyup input paste", function() {
    $("#user_search_form").submit();
});

    $(".field").change(function(){
        $(".query").val("");
        if ($(".field").val() === "Name") {
            $( ".query" ).autocomplete({
                source: '/search/auto/' + $(".field").val(),
                minLength: 3
            });
        }else {
            $( ".query" ).autocomplete({
                source: '/search/auto/' + $(".field").val(),
                minLength: 1
            });
        }
      
    });
    
$('#myModal').modal(options);
$('#myModal').modal("show");


$( ".query" ).autocomplete({
        source: '/search/auto/Name',
        minLength: 3,
        select: function(event, ui) {
            if(ui.item){
                $('.query').val(ui.item.value);
            }
            $("#user_search_form").submit();
        }
    });

    $("#negotiation_form").hide();

    $("#negotiation_button").click(function() {
        $("#negotiation_button").hide();
        $("#negotiation_form").slideDown('slow');
    });
})
