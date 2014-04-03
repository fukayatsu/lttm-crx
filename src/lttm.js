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
        var task1 = $.getJSON("http://www.lgtm.in/g?"+Math.random()).then();
        var task2 = $.getJSON("http://www.lgtm.in/g?"+Math.random()).then();
        var task3 = $.getJSON("http://www.lgtm.in/g?"+Math.random()).then();

        $.when(task1, task2, task3).then(function(a, b, c){
          images = _.map([a[0], b[0], c[0]], function(data) {
            return {name: data.imageUrl, imageUrl: data.imageUrl, alt: 'LGTM'}
          });
          callback(images);
        });
      } else if (kind == 't') {
        if (query) {
          $.getJSON("http://api.tiqav.com/search.json", {q: query}, function (data) {
            images = [];
            $.each(data, function(k, v){
              url = 'http://tiqav.com/' + v.id + '.' + v.ext;
              images.push({name: url, imageUrl: url, alt: 'tiqav'});
            });
            callback(images);
          });
        } else {
          $.getJSON("http://api.tiqav.com/search/random.json", {}, function (data) {
            images = [];
            $.each(data, function(k, v){
              url = 'http://tiqav.com/' + v.id + '.' + v.ext;
              images.push({name: url, imageUrl: url, alt: 'tiqav'});
            });
            callback(images);
          });
        }
      } else if (kind == 'm') {
        $.getJSON(chrome.extension.getURL('/meigens.json'), function (data) {
          var boys = [];
          if (query) {
            boys = _.filter(data, function(n) {
              (n.title && n.title.indexOf(query) > -1) || (n.body  && n.body.indexOf(query) > -1)
            });
          } else {
            boys = _.sample(data, 20);
          }
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