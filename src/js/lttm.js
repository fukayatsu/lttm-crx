/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const atwhoOptions = {
  at: "!",
  tpl: '<li class="lttm" data-value="![${alt}](${imageUrl})"><img src="${imagePreviewUrl}" /></li>',
  limit: 80,
  display_timeout: 1000,
  search_key: null,
  callbacks: {
    matcher(flag, subtext) {
      const regexp = new XRegExp("(\\s+|^)" + flag + "([\\p{L}_-]+)$", "gi");
      const match = regexp.exec(subtext);
      if (!match || !(match.length >= 2)) { return null; }
      return match[2];
    },

    remote_filter(query, callback) {
      let url;
      if (!query) { return; }
      const kind = query[0].toLowerCase();
      query = query.slice(1);
      switch (false) {
        case kind !== "l":
          if (location.protocol === "https:") {
            url = 'https://lttm-ssl.herokuapp.com/lgtm';
          } else {
            url = 'http://www.lgtm.in/g';
          }
          var task1 = $.getJSON(url + '?' + Math.random()).then();
          var task2 = $.getJSON(url + '?' + Math.random()).then();
          var task3 = $.getJSON(url + '?' + Math.random()).then();
          return $.when(task1, task2, task3).then(function(a, b, c) {
            const images = _.map([
              a[0],
              b[0],
              c[0]
            ], function(data) {
              const imageUrl = data.actualImageUrl;
              return {
                name:            imageUrl,
                imageUrl,
                imagePreviewUrl: previewUrl(imageUrl),
                alt: "LGTM"
              };
            });
            return callback(images);
          });
        case kind !== "t":
          if (query) {
            return $.getJSON("https://d942scftf40wm.cloudfront.net/search.json",
              {q: query}
            , function(data) {
              const images = [];
              $.each(data, function(k, v) {
                url = "https://img.tiqav.com/" + v.id + "." + v.ext;
                return images.push({
                  name: url,
                  imageUrl: url,
                  imagePreviewUrl: previewUrl(url),
                  alt: "tiqav"
                });
              });
              return callback(images);
            });
          }
          break;
        case kind !== "m":
          return $.getJSON(chrome.runtime.getURL("/config/meigens.json"), function(data) {
            let boys = [];
            if (query) {
              boys = _.filter(data, n => (n.title && (n.title.indexOf(query) > -1)) || (n.body && (n.body.indexOf(query) > -1)));
            } else {
              boys = _.sample(data, 30);
            }
            const images = [];
            $.each(boys, function(k, v) {
              const image = v.image.replace('http://', 'https://');
              return images.push({
                name: image,
                imageUrl: image,
                imagePreviewUrl: previewUrl(image),
                alt: "ミサワ"
              });
            });
            return callback(images);
          });
        case kind !== "i":
          return $.getJSON(chrome.runtime.getURL("/config/irasutoya.json"), function(data) {
            let illustrations = [];
            if (query) {
              illustrations = _.filter(data, n => ((n.title != null ? n.title.indexOf(query) : undefined) > -1) ||
              ((n.description != null ? n.description.indexOf(query) : undefined) > -1) ||
              (n.categories && (n.categories.join().indexOf(query) > -1)));
            } else {
              illustrations = _.sample(data, 30);
            }
            const images = [];
            $.each(illustrations, function(k, v) {
              const image_url = v.image_url.replace('http://', 'https://');
              return images.push({
                name: image_url,
                imageUrl: image_url,
                imagePreviewUrl: previewUrl(image_url),
                alt: v.title
              });
            });
            return callback(images);
          });
        case kind !== 's':
          return $.getJSON(chrome.runtime.getURL("/config/sushi_list.json"), function(data) {
            let sushiList = [];
            if (query) {
              sushiList = _.filter(data, sushi => !!_.find(sushi.keywords, keyword => keyword.indexOf(query) > -1));
            } else {
              sushiList = data;
            }

            const images = [];
            _.each(sushiList, sushi => images.push({
              name: sushi.url,
              imageUrl: sushi.url,
              imagePreviewUrl: sushi.url,
              alt: `寿司ゆき:${sushi.keywords[0]}`}));
            return callback(images);
          });
        case kind !== 'j':
          return $.getJSON(chrome.runtime.getURL("/config/js_girls.json"), function(data) {
            let js_girls = [];
            if (query) {
              js_girls = _.filter(data, js_girl => !!_.find(js_girl.keywords, keyword => keyword.indexOf(query) > -1));
            } else {
              js_girls = data;
            }

            const images = [];
            _.each(js_girls, js_girl => images.push({
              name: js_girl.url,
              imageUrl: js_girl.url,
              imagePreviewUrl: js_girl.url,
              alt: `JS Girls:${js_girl.keywords[0]}`}));
            return callback(images);
          });
        case kind !== 'n':
          return $.getJSON(chrome.runtime.getURL("/config/engineer_homeru_neko.json"), function(data) {
            let source = [];
            if (query) {
              source = _.filter(data, js_girl => !!_.find(js_girl.keywords, keyword => keyword.indexOf(query) > -1));
            } else {
              source = data;
            }

            const images = [];
            _.each(source, item => images.push({
              name: item.url,
              imageUrl: item.url,
              imagePreviewUrl: item.url,
              alt: `エンジニアを褒めるネコ:${item.keywords[0]}`}));
            return callback(images);
          });
        case kind !== 'd':
          return $.getJSON(chrome.runtime.getURL("/config/decomoji.json"), function(data) {
            let decomojis = [];
            if (query) {
              decomojis = _.filter(data, js_girl => !!_.find(js_girl.keywords, keyword => keyword.indexOf(query) > -1));
            } else {
              decomojis = data;
            }

            const images = [];
            _.each(decomojis, decomoji => images.push({
              name: decomoji.url,
              imageUrl: decomoji.url,
              imagePreviewUrl: decomoji.url,
              alt: `:${decomoji.keywords[0]}`}));
            return callback(images);
          });
        case kind !== 'r':
          return $.getJSON(chrome.runtime.getURL("/config/sushidot.json"), function(data) {
            let sushidots = [];
            if (query) {
              sushidots = _.filter(data, js_girl => !!_.find(js_girl.keywords, keyword => keyword.indexOf(query) > -1));
            } else {
              sushidots = data;
            }

            const images = [];
            _.each(sushidots, sushidot => images.push({
              name: sushidot.url,
              imageUrl: sushidot.url,
              imagePreviewUrl: sushidot.url,
              alt: `:${sushidot.keywords[0]}`}));
            return callback(images);
          });
      }
    }
  }
};

var previewUrl = function(url) {
  if (location.protocol     === "http:") { return url; }
  if (url.indexOf('https:') === 0) { return url; }

  const shaObj = new jsSHA("SHA-1", 'TEXT');
  shaObj.setHMACKey('lttmlttm', 'TEXT');
  shaObj.update(url);
  const hmac = shaObj.getHMAC('HEX');
  return `https://lttmcamo.herokuapp.com/${hmac}?url=${url}`;
};

$(document).on('focusin', function(ev) {
  const $this = $(ev.target);
  if (!$this.is('textarea')) { return; }
  return $this.atwho(atwhoOptions);
});

$(document).on('keyup.atwhoInner', ev => setTimeout(function() {
  const $currentItem =  $('.atwho-view .cur');
  if ($currentItem.length === 0) { return; }

  const $parent = $($currentItem.parents('.atwho-view')[0]);
  let offset = Math.floor($currentItem.offset().top - $parent.offset().top) - 1;

  if ((offset < 0) || (offset > 250)) {
    return setTimeout(function() {
      offset = Math.floor($currentItem.offset().top - $parent.offset().top) - 1;
      const row    = Math.floor(offset / 150);
      return $parent.scrollTop(($parent.scrollTop() + (row * 150)) - 75);
    }
    , 100);
  }
}));
