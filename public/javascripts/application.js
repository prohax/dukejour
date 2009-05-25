var KEYS = { BACKSPACE:8, TAB:9, RETURN:13, ENTER:3, ESC:27, SPACE:32, LEFT:37, UP:38, RIGHT:39, DOWN:40, DELETE:46 };

$(function() {

  // show when hovered
  jQuery('.hoverable .child').css({opacity: 0});
  jQuery('.hoverable').hover(function() {
    jQuery('.child', this).animate({opacity: 1}, 100);
  }, function() {
    jQuery('.child', this).animate({opacity: 0}, 400);
  });

});