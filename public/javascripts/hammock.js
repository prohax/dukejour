var KEYS = { BACKSPACE:8, TAB:9, RETURN:13, ENTER:3, ESC:27, SPACE:32, LEFT:37, UP:38, RIGHT:39, DOWN:40, DELETE:46 };

var hammock_link_map = {};

var hamlink_log = function(link_key, message) {
  if (console.log) console.log(link_key + ": " + message);
};

var hammock_ajax = function() {
  $('a.hammock').live('click', function() {
    link_key = $(this).attr('class').match(/hammock_link_(\w+)/)[1];
    if (!hammock_link_map[link_key]) {
      hamlink_log(link_key, 'no entry in link map');
    } else {
      fire_hammock_ajax(hammock_link_map[link_key]);
    }
  });
};

var fire_hammock_ajax = function(data) {
  var obj = null;

  if (data.spinner) {
    obj = jQuery(this).parent().find('.statuses');
    obj.find('.spinner').animate({opacity: 'show'}, 100);
  }

  if (data.before && false == data.before()) {
    hamlink_log(data.klass, "before callback failed.");
  } else {
    jQuery[data.fake_http_method](
      data.path,
      {
        '_method': data.http_method,
        'format': data.format
      },
      function(response, textStatus) {
        if (data.format == 'js') {
          eval(response);
        } else {
          jQuery('.' + (data.target || data.klass + '_target')).before(response).remove();
        }
        if (data.after && false == data.after()) {
          hamlink_log(data.klass, "after callback failed.");
        }
      }
    );
  }
};

$(function() {
  hammock_ajax();
});
