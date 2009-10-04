var KEYS = { BACKSPACE:8, TAB:9, RETURN:13, ENTER:3, ESC:27, SPACE:32, LEFT:37, UP:38, RIGHT:39, DOWN:40, DELETE:46 };

var EventCheckInterval = 10;

function checkForEvents() {
  $.getJSON(
    '/events/window?format=json&window_size=' + EventCheckInterval,
    function(data, textStatus) {
      if ('success' == textStatus) {
        $.each(data, function(i, e){
          handleEventJSON(e);
        });
      }
    }
  );
  setTimeout(checkForEvents, EventCheckInterval * 1000);
}

function handleEventJSON(e) {
  if (e.vote_event) {
    vote_count = $('ul.entries li.entry_' + e.vote_event.entry_id + ' .votes .count');
    vote_count
      .show('highlight', 2000)
      .html(parseInt(vote_count.html()) + 1);
  } else if (e.add_event) {

  }
}

$(function() {

  jQuery('#suggest_track').focus();

  // show when hovered
  jQuery('.hoverable .child').css({opacity: 0});
  jQuery('.hoverable').hover(function() {
    jQuery('.child', this).animate({opacity: 1}, 100);
  }, function() {
    jQuery('.child', this).animate({opacity: 0}, 400);
  });

});

$(window).load(checkForEvents);
