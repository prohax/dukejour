var KEYS = { BACKSPACE:8, TAB:9, RETURN:13, ENTER:3, ESC:27, SPACE:32, LEFT:37, UP:38, RIGHT:39, DOWN:40, DELETE:46 };

function add_event(entry_html) {
  if ($('#queue ul.entries li.' + $(entry_html).attr('class').match(/entry_\d+/)[0]).length == 0) {
    $('#queue ul.entries').append(entry_html)
      .children(':last').hide()
      .show('blind', {direction: 'vertical'}, 500);
  }
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

function play_event(entry) {
  entry = entry.entry;
  $('#now_playing ul.entries').html($('#queue ul.entries li.entry_' + entry.id).remove());
}

$(function() {
  jQuery('#suggest_track').focus();
});
