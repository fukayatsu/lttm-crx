atwhoOptions =
  at: "!"
  tpl: '<li class="lttm" data-value="![${alt}](${imageUrl})"><img src="${imagePreviewUrl}" /></li>'
  limit: 80
  display_timeout: 1000
  search_key: null
  callbacks:
    matcher: (flag, subtext) ->
      regexp = new XRegExp("(\\s+|^)" + flag + "([\\p{L}_-]+)$", "gi")
      match = regexp.exec(subtext)
      return null  unless match and match.length >= 2
      match[2]

    remote_filter: (query, callback) ->
      return  unless query
      kind = query[0].toLowerCase()
      query = query.slice(1)
      switch
        when kind is "l"
          task1 = $.getJSON("https://d1zktzrq1775k6.cloudfront.net/g?" + Math.random()).then()
          task2 = $.getJSON("https://d1zktzrq1775k6.cloudfront.net/g?" + Math.random()).then()
          task3 = $.getJSON("https://d1zktzrq1775k6.cloudfront.net/g?" + Math.random()).then()
          $.when(task1, task2, task3).then (a, b, c) ->
            images = _.map([
              a[0]
              b[0]
              c[0]
            ], (data) ->
              name:            data.actualImageUrl
              imageUrl:        data.actualImageUrl
              imagePreviewUrl: data.actualImageUrl
              alt: "LGTM"
            )
            callback images
        when kind is "t"
          if query
            $.getJSON "https://d942scftf40wm.cloudfront.net/search.json",
              q: query
            , (data) ->
              images = []
              $.each data, (k, v) ->
                url = "https://img.tiqav.com/" + v.id + "." + v.ext
                images.push
                  name: url
                  imageUrl: url
                  imagePreviewUrl: url
                  alt: "tiqav"
              callback images

        when kind is "g"
          if query
            $.getJSON "https://ajax.googleapis.com/ajax/services/search/images",
              v: '1.0',
              q: query,
              rsz: 'large'
            , (data) ->
              images = []
              $.each data.responseData.results, (k, v) ->
                url = v.url
                images.push
                  name: v.url
                  imageUrl: v.url
                  imagePreviewUrl: v.tbUrl
                  alt: v.titleNoFormatting
              callback images

        when kind is "m"
          $.getJSON chrome.extension.getURL("/config/meigens.json"), (data) ->
            boys = []
            if query
              boys = _.filter(data, (n) ->
                (n.title and n.title.indexOf(query) > -1) or (n.body and n.body.indexOf(query) > -1)
              )
            else
              boys = _.sample(data, 30)
            images = []
            $.each boys, (k, v) ->
              image = v.image.replace('http://livedoor.blogimg.jp', 'http://livedoor.4.blogimg.jp')
              images.push
                name: image
                imageUrl: image
                imagePreviewUrl: image
                alt: "ミサワ"
            callback images
        when kind is 's'
          $.getJSON chrome.extension.getURL("/config/sushi_list.json"), (data) ->
            sushiList = []
            if query
              sushiList = _.filter(data, (sushi) ->
                !!_.find(sushi.keywords, (keyword) ->
                  keyword.indexOf(query) == 0
                )
              )
            else
              sushiList = data

            images = []
            _.each(sushiList, (sushi) ->
              images.push
                name: sushi.url
                imageUrl: sushi.url
                imagePreviewUrl: sushi.url
                alt: "寿司ゆき:#{sushi.keywords[0]}"
            )
            callback images
        when kind is 'j'
          $.getJSON chrome.extension.getURL("/config/js_girls.json"), (data) ->
            js_girls = []
            if query
              js_girls = _.filter(data, (js_girl) ->
                !!_.find(js_girl.keywords, (keyword) ->
                  keyword.indexOf(query) == 0
                )
              )
            else
              js_girls = data

            images = []
            _.each(js_girls, (js_girl) ->
              images.push
                name: js_girl.url
                imageUrl: js_girl.url
                imagePreviewUrl: js_girl.url
                alt: "JS Girls:#{js_girl.keywords[0]}"
            )
            callback images
        when kind is 'd'
          $.getJSON chrome.extension.getURL("/config/decomoji.json"), (data) ->
            decomojis = []
            if query
              decomojis = _.filter(data, (js_girl) ->
                !!_.find(js_girl.keywords, (keyword) ->
                  keyword.indexOf(query) == 0
                )
              )
            else
              decomojis = data

            images = []
            _.each(decomojis, (decomoji) ->
              images.push
                name: decomoji.url
                imageUrl: decomoji.url
                imagePreviewUrl: decomoji.url
                alt: ":#{decomoji.keywords[0]}"
            )
            callback images

$(document).on 'focusin', (ev) ->
  $this = $ ev.target
  return unless $this.is 'textarea'
  $this.atwho atwhoOptions

$(document).on 'keyup.atwhoInner', (ev) ->
  setTimeout ->
    $currentItem =  $('.atwho-view .cur')
    return if $currentItem.length == 0

    $parent = $($currentItem.parents('.atwho-view')[0])
    offset = Math.floor($currentItem.offset().top - $parent.offset().top) - 1

    if (offset < 0) || (offset > 250)
      setTimeout ->
        offset = Math.floor($currentItem.offset().top - $parent.offset().top) - 1
        row    = Math.floor(offset / 150)
        $parent.scrollTop($parent.scrollTop() + row * 150 - 75)
      , 100
