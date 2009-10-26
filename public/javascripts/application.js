var KEYS = { BACKSPACE:8, TAB:9, RETURN:13, ENTER:3, ESC:27, SPACE:32, LEFT:37, UP:38, RIGHT:39, DOWN:40, DELETE:46 };

function add_event(entry) {
  $('#queue ul.entries').append(entry)
    .children(':last').hide()
    .show('blind', {direction: 'vertical'}, 500);
}

function vote_event(entry) {
  entry = entry.entry;
  vote_count = $('#queue ul.entries li.entry_' + entry.id + ' .votes .count')
  vote_count.html(parseInt(vote_count.html()) + 1);

  new_list = $('#queue ul.entries li').sort(function(a, b) {
    return parseInt($(b).find('.votes .count').html())
      - parseInt($(a).find('.votes .count').html());
  });
  $.each(new_list, function(i, item) { $('#queue ul.entries').append(item); });

  $(vote_count).stop()
    .animate({'font-size': '1.5em'}, 200)
    .animate({'font-size': '0.85em'}, 200)
    .animate({'font-size': '1em'}, 200);
}

$(function() {
  jQuery('#suggest_track').focus();
});
