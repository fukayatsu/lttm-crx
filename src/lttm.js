$('textarea').atwho({
  at: "!",
  tpl: '<li data-value="![${alt}](${imageUrl})"><img src="${imageUrl}" /></li>',
  limit: 10,
  display_timeout: 1000,
  search_key: null,
  callbacks: {
    matcher: function(flag, subtext) {
      var match, matched, regexp;
      regexp = new XRegExp('(\\s+|^)' + flag + '(\\p{L}+)$', 'gi');
      match = regexp.exec(subtext);
      if (!(match && match.length >= 2)) { return null; }
      return match[2];
    },
    remote_filter: function(query, callback) {
      if (!(query)) { return; }

      var kind, query, images, boys;
      kind  = query[0].toLowerCase();
      query = query.slice(1);

      if (kind == 'l') {
        $.getJSON("http://www.lgtm.in/g", function (data) {
          url = data.imageUrl;
          callback([{name: url, imageUrl: url, alt: 'LGTM'}]);
        });
      } else if (kind == 't' && query) {
        $.getJSON("http://api.tiqav.com/search.json", {q: query}, function (data) {
          images = [];
          $.each(data, function(k, v){
            url = 'http://tiqav.com/' + v.id + '.' + v.ext;
            images.push({name: url, imageUrl: url, alt: 'tiqav'});
          });
          callback(images);
        });
      } else if (kind == 'm' && query) {
        $.getJSON(chrome.extension.getURL('/meigens.json'), function (data) {
          boys = $.grep(data, function(n, i) {
            if (n.title && n.title.indexOf(query) > -1) { return true; }
            if (n.body  && n.body.indexOf(query) > -1)  { return true; }
            return false;
          });
          images = [];
          $.each(boys, function(k, v){
            images.push({name: v.image, imageUrl: v.image, alt: 'ミサワ'});
          });
          callback(images);
        });
      }
    }
  }
})