function add_event(entry_html) {
  if ($('#queue ul.entries li.' + $(entry_html).attr('class').match(/entry_\d+/)[0]).length == 0) {
    $('#queue ul.entries').append(entry_html)
      .children(':last').hide()
      .show('blind', {direction: 'vertical'}, 500);
  }
}

function vote_event(entry_json) {
  entry = $('#queue ul.entries li.entry_' + entry_json.entry.id);
  vote_count_i = parseInt(entry.find('.votes .count').html()) + 1;
  created_at_i = parseInt(entry.find('.created_at').html());
  // console.log("re-inserting " + entry_json.entry.song.name + ": " + vote_count_i + " / " + created_at_i);

  $('#queue ul.entries li').each(function(i, item) {
    this_vote_count = parseInt($(item).find('.votes .count').html());
    this_created_at = parseInt($(item).find('.created_at').html());
    // console.log("comparing " + vote_count_i + " / " + created_at_i + " to " + this_vote_count + " / " + this_created_at);
    if ((vote_count_i > this_vote_count) || ((vote_count_i == this_vote_count) && (created_at_i <= this_created_at))) {
      if (entry.get(0) != $(item).get(0)) {
        entryHeight = entry.outerHeight() + 'px';
        entryWidth = entry.width() + 'px';
        entryOffset = entry.offset();
        itemOffset = $(item).offset();
        entry.next().css({'margin-top': entryHeight}).animate({'margin-top': 0}, 600);
        $(item).animate({'margin-top': entryHeight}, 600);
        entry.css({
          position: 'absolute', width: entryWidth,
          top: entryOffset.top + 'px', left: entryOffset.left + 'px'
        }).animate({
          top: itemOffset.top + 'px', left: itemOffset.left + 'px'
        }, 600, function() {
          $(this).insertBefore($(item).css({'margin-top': 0}))
            .css({
              position: 'static', width: 'auto'
            });
        });
      }
      entry.find('.votes .count').html(vote_count_i)
        .stop()
        .animate({'font-size': '1.5em'}, 200)
        .animate({'font-size': '0.85em'}, 200)
        .animate({'font-size': '1em'}, 200);
      return false;
    }
  });
}

function play_event(entry) {
  entry = entry.entry;
  $('#now_playing').removeClass('inactive').children('ul.entries').html($('#queue ul.entries li.entry_' + entry.id).remove());
}

function finished_event(data) {
  $('#now_playing').addClass('inactive').children('ul.entries li:first').html('<span class="name">iTunes is stopped.</span><span class="artist">At least, it was last time I checked.</span>');
}

function message_event(data) {
  console.log("<li class='message_" + data.timestamp + "'><div class='message'>" + data.message + "</div></li>");
  console.log("$('ul.messages li.message_" + data.timestamp + "').blindUp().remove();");
  $('ul.messages')
    .append($("<li class='message_" + data.timestamp + "'><div class='message'>" + data.message + "</div></li>"))
    .children(':last').hide().blindDown(function() {
      size_suggest_results_to_window();
    });
  setTimeout("$('ul.messages li.message_" + data.timestamp + "').fadeOut(2000, function() { $(this).remove(); size_suggest_results_to_window(); } );", 10000);
  if (data.stats) {
    update_stat("library_count", data.stats.library_count_str);
    update_stat("song_count", data.stats.song_count_str);
    update_stat("duration", data.stats.duration_str);
  }
  if (data.entries) {
    $.each(data.entries, function(i, entry) {
      if (entry.active)
        $('#queue ul.entries li.entry_' + entry.id).removeClass('inactive');
      else
        $('#queue ul.entries li.entry_' + entry.id).addClass('inactive');
    });
  }
}

function update_stat(elem, str) {
  if ($('.info .' + elem).html() != str) {
    $('.info .' + elem).html(str).show('highlight', 2000);
  }
}

$(function() {
  jQuery('#suggest_track').focus();
});
