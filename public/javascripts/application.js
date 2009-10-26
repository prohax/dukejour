var KEYS = { BACKSPACE:8, TAB:9, RETURN:13, ENTER:3, ESC:27, SPACE:32, LEFT:37, UP:38, RIGHT:39, DOWN:40, DELETE:46 };

function add_event(entry) {
  $('#queue ul.entries').append(entry)
    .children(':last').hide()
    .show('blind', {direction: 'vertical'}, 500);
}

function vote_event(entry) {
  entry = entry.entry
  vote_count = $('ul.entries li.entry_' + entry.id + ' .votes .count');
  vote_count
    .show('highlight', 2000)
    .html(parseInt(vote_count.html()) + 1);
}

$(function() {
  jQuery('#suggest_track').focus();
});
