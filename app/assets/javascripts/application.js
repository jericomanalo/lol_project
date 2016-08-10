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
            $("#splash_container li:eq(0) #tail2").addClass("animated fadeIn")
            $("#splash_container li:eq(0)").addClass("animated pulse").one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend",
             function(){
              $(this).removeClass('animated pulse');
            });
            var current = $("#name_container li").index();
            var champion_id = $('#name_container li:eq(0)').val()
            var imgHeight = $("#splash_container img").height();
            var splash_height = $("#splash_container").height();
            var offset = (splash_height - imgHeight) / 2;
            console.log("IMG HEIGHT", imgHeight, splash_height);
            $('#splash_container').scrollTo($('#splash_container li:eq(0)'), 225, {offset: -offset});
            $("#name_container").scrollTo($('#name_container li:eq(0)'), 225, {offset: -(offset * 2 )});
            show_stats(champion_id);
            console.log(champion_id);

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


              $('.progress-bar').each(function() {
                  var me = $(this);
                  var perc = me.attr("data-percentage");
                  $(this).css('width', perc);
                });
            //when li item click also scroll with offsets
            $("#name_container li").click(function (){
              $("#splash_container li #tail2").removeClass("animated fadeIn");
              var champ_name = $(this).find('span').html().replace("'", "\\'").replace('"', '\\"').replace(/\s/g, '');
              console.log("CHAMP CLICKED:", champ_name);
              var champion_id = $(this).val();
              console.log("CHAMPION____ID:", champion_id);
              var imgHeight = document.getElementById("img_"+champion_id).clientHeight;
              var selected = $(this).index();
                var name_offset = 360;
              var offset = (imgHeight - document.getElementById("splash_container").clientHeight) / 2;
              $('.active').removeClass('active');
              $(this).addClass('active');
              $('#splash_container').scrollTo($("#splash_container li."+champ_name), 100, {offset: offset});
              $("#splash_container li."+champ_name+" #tail2").addClass("animated fadeIn");
              $("#splash_container li."+champ_name).addClass("animated pulse").one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend",
               function(){
                $(this).removeClass('animated pulse');
              });;
              // $('#name_container ul').scrollTo(document.getElementById(selected), 100);
              $('#name_container .scroll').scrollTo($('#name_container li.'+champ_name), 100, {offset: -name_offset});
              show_stats(champion_id);
              return false;
            });

            //display stats on target div
            function show_stats(champion_id){
              console.log("SHOWING STATS");
              stats = $('#'+champion_id+'_stats').html();
              if(stats == undefined){
                $('#stats_target').html("<p>No data for this champ</p>");
              }
              $('#stats_target').html(stats).addClass("animated fadeInRight").one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend",
               function(){
                $(this).removeClass('fadeInRight');
              });
            };

        });
