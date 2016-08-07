// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require chartkick
//= require highcharts
//= require bootstrap
//= require jquery.scrollTo
//= require bootstrap-list-filter.src
$(document).ready(function (){
            //initialize offsets to scroll to, also add first and last classes
            var current = $("#name_container li").index();
            var imgHeight = $("#splash_container img").height();
            var splash_height = $("#splash_container").height();
            var offset = (splash_height - imgHeight) / 2;
            console.log("IMG HEIGHT", imgHeight, splash_height);
            $('#splash_container').scrollTo($('#splash_container li:eq(0)'), 100, {offset: -offset});
            $("#name_container").scrollTo($('#name_container li:eq(0)'),100, {offset: -(offset * 2 )});

            $("#splash_container li").eq(current).addClass('first');
            $('#name_container li').eq(current).addClass('active');

            //arw click to scroll
            $('#up_arw').on('click', function() {
                var i = $(".active").index();
                    i--;
                $(".active").removeClass('active');
                var prev = $('#name_container li').eq(i);
                prev.addClass('active').trigger('click');
            });
            $('#down_arw').on('click', function() {
                var i = $(".active").index();
                    i = i >= $('#name_container li').length-1 ? 0 : i+1;
                $(".active").removeClass('active');
                var next = $('#name_container li').eq(i);
                next.addClass('active').trigger('click');
            });
            $('#searchlist a').click(function (){
              var champ_name = $(this).find('span').html().replace("'", "\\'").replace('"', '\\"').replace(/\s/g, '');
              console.log("CLICKED:", champ_name);
              var li_link = $("#name_container li."+champ_name);
              console.log("LI_LINK", li_link);
              li_link.trigger('click');
              $('#champSearchModal').modal('toggle');
            });
            //when li item click also scroll with offsets
            $("#name_container li").click(function (){
              var champ_name = $(this).find('span').html().replace("'", "\\'").replace('"', '\\"').replace(/\s/g, '');
              console.log("CHAMP CLICKED:", champ_name);
              var champion_id = $(this).val();
              console.log("CHAMPION____ID:", champion_id);
              show_stats(champion_id);
              var imgHeight = document.getElementById("img_"+champion_id).clientHeight;
              var selected = $(this).index();
              console.log("SELECTED", selected);
                var name_offset = 360;
                selected = $("#name_container li").eq(selected).attr("id");
              console.log("SELECTED_ID:", selected);
              var offset = (imgHeight - document.getElementById("splash_container").clientHeight) / 2;
              $('.active').removeClass('active');
              $(this).addClass('active');
              $('#splash_container').scrollTo($("#splash_container li."+champ_name), 100, {offset: offset});
              // $('#name_container ul').scrollTo(document.getElementById(selected), 100);
              $('#name_container .scroll').scrollTo($('#name_container li.'+champ_name), 100, {offset: -name_offset});
              return false;
            });

            //display stats on target div
            function show_stats(champion_id){
              console.log("SHOWING STATS");
              stats = $('#'+champion_id+'_stats').html();
              if(stats == undefined){
                $('#stats_target').empty();
              }
              $('#stats_target').html(stats);
            };


            // var lastScrollTop = 0;
            // //scroll throttling
            // var scrollTimeout; // global for any pending scrollTimeout
            // $("#name_container ul").scroll(function() {
            //   console.log("SCROLLING");
            //     if (scrollTimeout) {
            //         // clear the timeout, if one is pending
            //         clearTimeout(scrollTimeout);
            //         scrollTimeout = null;
            //     }
            //     scrollTimeout = setTimeout(scrollHandler, 250);
            // });
            // scrollHandler = function() {
            //   $('#name_container ul').scroll(function(event) {
            //     var st = $(this).scrollTop();
            //     if (st > lastScrollTop) {
            //       // downscroll code
            //       var first = $('#name_container li').first();
            //       var first_pic = $('#splash_container li').first();
            //       var last_pic = $('#splash_container li').last();
            //       var last = $('#name_container li').last();
            //       console.log(first, first_pic, last_pic, last);
            //       first.insertAfter(last);
            //       first_pic.insertAfter(last_pic);
            //
            //       console.log("SCROLLING DOWN");
            //     } else {
            //       // upscroll code, moves last li to first to keep center autofocused
            //       var first = $('#name_container li').first();
            //       var first_pic = $('#splash_container li').first();
            //       var last_pic = $('#splash_container li').last();
            //       var last = $('#name_container li').last();
            //       last.insertBefore(first);
            //       last_pic.insertBefore(first_pic);
            //
            //       console.log("SCROLLING UP");
            //     }
            //     lastScrollTop = st;
            //   });
            //     // Check your page position and then
            //     // Load in more results
            //     // outerPane.html();
            // };


        });
