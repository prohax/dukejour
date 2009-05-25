var KEYS = { BACKSPACE:8, TAB:9, RETURN:13, ENTER:3, ESC:27, SPACE:32, LEFT:37, UP:38, RIGHT:39, DOWN:40, DELETE:46 };

var EventCheckInterval = 10;

function checkForEvents() {
  console.log("checking for events.");

  $.get(
    '/events/window',
    {
      window_size: EventCheckInterval,
      format: 'json'
    },
    function(data) {
      $(data).each(function(elem) {
        console.log(elem);
      });
    }
  );

  setTimeout(checkForEvents, EventCheckInterval * 1000);
}

$(function() {

  // show when hovered
  jQuery('.hoverable .child').css({opacity: 0});
  jQuery('.hoverable').hover(function() {
    jQuery('.child', this).animate({opacity: 1}, 100);
  }, function() {
    jQuery('.child', this).animate({opacity: 0}, 400);
  });

});

$(window).load(checkForEvents);
