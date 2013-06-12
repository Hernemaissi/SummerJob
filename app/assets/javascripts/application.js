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

$(".rectangle_tab_1").css("visibility", "hidden");
$(".rectangle_tab_2").css("visibility", "hidden");
$(".rectangle_tab_3").css("visibility", "hidden");
$(".rectangle_tab_4").css("visibility", "hidden");
$(".full_square").parent().next().css("visibility", "visible");
$('.free_square').click(function() {
  $(".rectangle_tab_1").css("visibility", "hidden");
  $(".rectangle_tab_2").css("visibility", "hidden");
  $(".rectangle_tab_3").css("visibility", "hidden");
  $(".rectangle_tab_4").css("visibility", "hidden");
   
   $(".free_square.full_square").removeClass('full_square');
   $(this).addClass('full_square');
   square_id = $(this).attr('id');
   if (square_id === "square_1") {
       $("#hidden_service").val("3");
       $("#hidden_product").val("1");
      $(".rectangle_tab_1").css("visibility", "visible");
   }
   if (square_id === "square_2") {
       $("#hidden_service").val("3");
       $("#hidden_product").val("3");
      $(".rectangle_tab_2").css("visibility", "visible");
      
   }
   if (square_id === "square_3") {
       $("#hidden_service").val("1");
       $("#hidden_product").val("1");
       $(".rectangle_tab_3").css("visibility", "visible");
   }
   if (square_id === "square_4") {
       $("#hidden_service").val("1");
       $("#hidden_product").val("3");
       $(".rectangle_tab_4").css("visibility", "visible");
   }
   get_costs();
});





    $( "#risk_slider" ).slider({
        value: parseInt($("#risk_result").text()),
        min: 0,
        max: 100,
        step: 1,
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
        max: parseInt($("#end_cost").val()),
        step: 100,
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
        min: parseInt($("#var_min").val()),
        max: parseInt($("#var_cost").val()),
        step: 100,
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
        market_id = ($(".market_choose").val() !== undefined && $(".market_choose").val() !== null) ? $(".market_choose").val() : 0;
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
              
                $("#risk_slider").slider("option", "value", 0);
                $("#capacity_slider").slider("option", "max",  parseInt($("#end_cost").val()));
                $("#capacity_slider").slider("option", "min", parseInt($("#start_cost").val()));
                $("#capacity_slider").slider("option", "value", parseInt($("#start_cost").val()));
                $("#variable_slider").slider("option", "max",  parseInt($("#var_cost").val()));
                $("#variable_slider").slider("option", "min", parseInt($("#var_min").val()));
                $("#variable_slider").slider("option", "value", parseInt($("#var_min").val()));
                $("#capacity_result").text($("#start_cost").val());
                $("#risk_result").text(0);
                $("#variable_result").text($("#var_min").val());
                $("#risk_cost").val(0);
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
  

    $("#qualityvalues").hide();

    $("#qualities").change(function() {
        id = $("#qualities :selected").val();
        console.log(id);
        url = "/qualities/" + id + "/?format=json"
        if (id.length !== 0) {
            console.log(url);
            $.getJSON(url, function(data) {
                var qualityvalues = $("#qualityvalues").empty();
                qualityvalues.append("<option value=\"\">" + "Choose value" + "</option>");
                $.each(data, function() {
                    qualityvalues.append("<option value=" + this.id + ">" + this.value + "</option>");
                });
                $("#qualityvalues").show();
            });
        } else {
            $("#qualityvalues").empty();
            $("#qualityvalues").hide();
        }
        url = "/users/"
        $.ajax({
                url: url,
                beforeSend: function(xhr, settings) {
                    xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
                },
                success: function() {
                }
            });
    });

    $("#qualityvalues").change(function() {
        id = $("#qualityvalues :selected").val();
        if (id.length !== 0) {
            url = "/qualityvalues/" + id + "/"
            console.log(url);
            $.ajax({
                url: url,
                success: function() {
                }
            });
        } else {
            url = "/users/"
            $.ajax({
                url: url,
                beforeSend: function(xhr, settings) {
                    xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
                },
                success: function() {
                }
            });
        }
    });

    $("#dynamic_chart").click(function() {
       console.log("I was clicked!");
        var data = google.visualization.arrayToDataTable([
          ['Price', 'Sales'],
          [0,  800],
          [2000,  200],
          [9000,  0]
        ]);

        var options = {
          title: 'Company Performance',
          pointSize: 10
        };
        
        var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      
    });
    $(".market_field").change( function() {
      dataTable = new google.visualization.DataTable();
      dataTable.addColumn('number', 'Price');
      dataTable.addColumn('number', 'Sales');
      // A column for custom tooltip content
      dataTable.addColumn({type: 'string', role: 'tooltip'});
      dataTable.addRows([
        [0, parseInt($("#market_lb_max_customers").val()), "Sales: " + $("#market_lb_max_customers").val()  + "\n" + "Price: 0"  ],
        [parseInt($("#market_lb_sweet_price").val()),  parseInt($("#market_lb_amount").val()), "Sales: " + $("#market_lb_amount").val()  + "\n" + "Price: " + $("#market_lb_sweet_price").val() ],
        [parseInt($("#market_lb_max_price").val()) ,  0, "Sales: 0\nPrice: " +  $("#market_lb_max_price").val()]
      ]);




      var options = {
        title: 'Market data',
        pointSize: 10,
        vAxis: {
            title: "Sales"
        },
        hAxis: {
            title: "Price"
        }
      };
      var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
      chart.draw(dataTable, options);
    });

//Code to get accordion grouping to work on mail page, for some reason doesn't work normally
$(document).on('click', '.accordion-toggle', function(event) {
        event.stopPropagation();
        var $this = $(this);

        var parent = $this.data('parent');
        var actives = parent && $(parent).find('.collapse.in');

        // From bootstrap itself
        if (actives && actives.length) {
            hasData = actives.data('collapse');
            //if (hasData && hasData.transitioning) return;
            actives.collapse('hide');
        }

        var target = $this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, ''); //strip for ie7

        $(target).collapse('toggle');
}); 
/*
$(".accordion-toggle").click(function() {
   if ($(this).hasClass("accordion-open")) {
       $(this).closest(".accordion-group").siblings().show();
       $(this).removeClass("accordion-open");
   } else {
       $(this).closest(".accordion-group").siblings().hide();
       $(this).addClass("accordion-open");
   }
}); */

    

    $(".quality_select").change(function() {
        sort_by_qualities();
    });

   $(".modal_quality").change(function() {
         quality_id = $(this).val();
         id = $(this).prev().val();
         selected_user_id = $(this).prev().prev().val();

        url = "groups/" + id + "/answers/" + quality_id;
        key_str = "user_id=" + selected_user_id;
        console.log(url);
        $.ajax({
            url: url,
            data: key_str,
            beforeSend: function(xhr, settings) {
                xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
            },
            success: function() {
            }
        });
    });

    $(".jsonly").show();
    $("#next_news").hide();

    $("#previous_news").click(function() {
        current_id = $("#news_id").val();
        change_news_page(parseInt(current_id) - 1, "right");
    })

    $("#next_news").click(function() {
        current_id = $("#news_id").val();
        change_news_page(parseInt(current_id) + 1, "left");
    })

})

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".option").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

function change_news_page(id, direction) {
    url = "/news"
    key = "news_id=" + id + "&direction=" + direction;
    $.ajax({
            url: url,
            data: key,
            beforeSend: function(xhr, settings) {
                xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
            },
            success: function() {
            }
        });
}

function sort_by_qualities() {
    var qvalues = new Array();
        $(".quality_select").each(function(i) {
            if ($(this).val().length != 0) {
                qvalues[i] = $(this).val();
            }
        });
        key_str = "quality_array=" + qvalues.toString();
        console.log(key_str);
        url = "/sort/"
        console.log(url);
        $.ajax({
            url: url,
            data: key_str,
            beforeSend: function(xhr, settings) {
                xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
            },
            success: function() {
            }
        });
}



