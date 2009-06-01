jQuery.fn.extend({
  serializeHash: function() {
    var ary = this.serializeArray().map(function(i, elem) {
      h = {};
      h[i.name] = i.value;
      return h;
    });

    for (var i = 0, hsh = {}; i < ary.length; i++) {
      jQuery.extend(hsh, ary[i]);
    }

    return hsh;
  }
});
