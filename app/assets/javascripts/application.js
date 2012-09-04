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
    $('.bluesign').popover();
    $('.messagebox').popover();
    $(".alert").alert();
    $(".content_block").hide();
    $(".hide_block").hide();
    $('#myTab').tab();
    $(".collapse").collapse({
        toggle: false
    })



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


$('.free_square').click(function() {
   
   $(".free_square.full_square").removeClass('full_square');
   $(this).addClass('full_square');
   square_id = $(this).attr('id');
   if (square_id === "square_1") {
       $("#hidden_service").val("3");
       $("#hidden_product").val("1");
   }
   if (square_id === "square_2") {
       $("#hidden_service").val("3");
       $("#hidden_product").val("3");
   }
   if (square_id === "square_3") {
       $("#hidden_service").val("1");
       $("#hidden_product").val("1");
   }
   if (square_id === "square_4") {
       $("#hidden_service").val("1");
       $("#hidden_product").val("3");
   }
   get_costs();
});



    $( "#risk_slider" ).slider({
        value: parseInt($("#risk_result").text()),
        min: parseInt($("#start_cost").val()),
        max: parseInt($("#start_cost").val() * 2),
        step: 10000,
        slide: function(event, ui) {
            $(this).prev().text(ui.value)
        },
        stop: function(event, ui) {
            $('#risk_cost').attr('value', ui.value);
            get_stats()
        }
    });


    $( "#capacity_slider" ).slider({
        value: $("#capacity_result").text(),
        min: parseInt($("#start_cost").val()),
        max: parseInt($("#start_cost").val() * 2),
        step: 10000,
        slide: function(event, ui) {
            $(this).prev().text(ui.value)
        },
        stop: function(event, ui) {
            $('#capacity_cost').attr('value', ui.value);
            get_stats()
        }
    });

     $( "#variable_slider" ).slider({
        value: $("#variable_result").text(),
        min: parseInt($("#var_cost").val()),
        max: parseInt($("#var_cost").val() * 2),
        step: 10000,
        slide: function(event, ui) {
            $(this).prev().text(ui.value)
        },
        stop: function(event, ui) {
            $('#variable_cost').attr('value', ui.value);
            get_stats()
        }
    });

    
    $("#risk_cost").bind("blur", function() {
        get_stats()
    });
    $("#capacity_cost").bind("blur", function() {
        get_stats()
    });
    $("#variable_cost").bind("blur", function() {
        get_stats()
    });

    $("#sell_price").bind("blur", function() {
        get_stats()
    });

    $(".market_choose").change(function() {
        get_stats()
    });

    function get_stats() {
        url_var = "/companies/init/stats/"
        level = typeof $("#hidden_service").val() !== 'undefined' ? $("#hidden_service").val() : 1;
        type = typeof $("#hidden_product").val() !== 'undefined' ? $("#hidden_product").val() : 1;
        risk_cost = typeof $("#risk_cost").val() !== 'undefined' ? $("#risk_cost").val() : 0;
        capacity_cost = typeof $("#capacity_cost").val() !== 'undefined' ? $("#capacity_cost").val() : 0;
        variable_cost = typeof $("#variable_cost").val() !== 'undefined' ? $("#variable_cost").val() : 0;
        sell_price = (typeof $("#sell_price").val() !== 'undefined' && $("#sell_price").val() !== '')  ? $("#sell_price").val() : 0;
        id = typeof $("#cid").val() !== 'undefined' ? $("#cid").val() : 0;
        market_id = typeof $(".market_choose").val() !== 'undefined' ? $(".market_choose").val() : 0;
        key_str = "level=" + level +  "&type=" + type +  "&risk_cost=" + risk_cost + "&capacity_cost=" + capacity_cost + "&variable_cost=" + variable_cost +"&id=" + id + "&sell_price=" + sell_price + "&market_id=" + market_id;
        $.ajax({
            url: url_var,
            data: key_str,
            success: function() {
            }
        });
    }

     function get_costs() {
        url_var = "/companies/init/costs/"
        level = typeof $("#hidden_service").val() !== 'undefined' ? $("#hidden_service").val() : 1;
        type = typeof $("#hidden_product").val() !== 'undefined' ? $("#hidden_product").val() : 1;
        id = typeof $("#cid").val() !== 'undefined' ? $("#cid").val() : 0;
        key_str = "level=" + level +  "&type=" + type + "&id=" + id;
        $.ajax({
            url: url_var,
            data: key_str,
            success: function() {
                $("#risk_slider").slider("option", "max",  parseInt($("#start_cost").val()*2));
                $("#risk_slider").slider("option", "min", parseInt($("#start_cost").val()));
                $("#risk_slider").slider("option", "value", parseInt($("#start_cost").val()));
                $("#capacity_slider").slider("option", "max",  parseInt($("#start_cost").val()*2));
                $("#capacity_slider").slider("option", "min", parseInt($("#start_cost").val()));
                $("#capacity_slider").slider("option", "value", parseInt($("#start_cost").val()));
                $("#variable_slider").slider("option", "max",  parseInt($("#var_cost").val()*2));
                $("#variable_slider").slider("option", "min", parseInt($("#var_cost").val()));
                $("#variable_slider").slider("option", "value", parseInt($("#var_cost").val()));
                $(".slider_result").text($("#start_cost").val());
                $("#variable_result").text($("#var_cost").val());
                $("#risk_cost").val(parseInt($("#start_cost").val()));
                $("#capacity_cost").val(parseInt($("#start_cost").val()));
                $("#variable_cost").val(parseInt($("#var_cost").val()));

                get_stats()
            }
        });
    }

    $("#plate").fadeOut(15000);
    $("#plat").fadeOut(15);

    $("#search_users").click(function() {
        $(".users").hide();
    });

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
    
    $('#myModal').modal('');
    $('#myModal1').modal('');
    $('#bidReject').modal('');


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


    if ($("#progressbar").length != 0) {
        window.onload = function() {
            function get_progress() {
                url_var = "/progress"
                $.ajax({
                    url: url_var,
                    success: function() {
                    }
                });
            }
            setInterval(get_progress, 500);
        }
    }


    $("#progressbar").progressbar({
        value: 0
    });

    $("#edit_about_form").hide();

    $("#edit_about_us").click(function() {
        $("#edit_about_us").hide();
        $("#about_us").hide();
        $("#edit_about_form").show();
    });

})



