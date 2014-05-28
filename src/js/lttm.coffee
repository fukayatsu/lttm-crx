$("textarea").atwho
  at: "!"
  tpl: '<li class="lttm" data-value="![${alt}](${imageUrl})"><img src="${imageUrl}" /></li>'
  limit: 40
  display_timeout: 1000
  search_key: null
  callbacks:
    matcher: (flag, subtext) ->
      regexp = new XRegExp("(\\s+|^)" + flag + "(\\p{L}+)$", "gi")
      match = regexp.exec(subtext)
      return null  unless match and match.length >= 2
      match[2]

    remote_filter: (query, callback) ->
      return  unless query
      kind = query[0].toLowerCase()
      query = query.slice(1)
      if kind is "l"
        task1 = $.getJSON("http://www.lgtm.in/g?" + Math.random()).then()
        task2 = $.getJSON("http://www.lgtm.in/g?" + Math.random()).then()
        task3 = $.getJSON("http://www.lgtm.in/g?" + Math.random()).then()
        $.when(task1, task2, task3).then (a, b, c) ->
          images = _.map([
            a[0]
            b[0]
            c[0]
          ], (data) ->
            name: data.imageUrl
            imageUrl: data.imageUrl
            alt: "LGTM"
          )
          callback images
      else if kind is "t"
        if query
          $.getJSON "http://api.tiqav.com/search.json",
            q: query
          , (data) ->
            images = []
            $.each data, (k, v) ->
              url = "http://tiqav.com/" + v.id + "." + v.ext
              images.push
                name: url
                imageUrl: url
                alt: "tiqav"
            callback images

      else if kind is "g"
        if query
          $.getJSON "https://ajax.googleapis.com/ajax/services/search/images",
            v: '1.0',
            q: query
          , (data) ->
            images = []
            $.each data['responseData']['results'], (k, v) ->
              url = v['tbUrl']
              images.push
                name: url
                imageUrl: url
                alt: v['titleNoFormatting']
            callback images

      else if kind is "m"
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
            images.push
              name: v.image
              imageUrl: v.image
              alt: "ミサワ"
          callback images
      else if kind is 's'
        images = []
        _.each _.range(1, 41), (num) ->
          images.push
            name:     "https://d1zd1v0cxnbx2w.cloudfront.net/images/sets/sushiyuki/#{("0"+num).slice(-2)}.png"
            imageUrl: "https://d1zd1v0cxnbx2w.cloudfront.net/images/sets/sushiyuki/#{("0"+num).slice(-2)}.png"
            alt:      "寿司ゆき"
        callback images


$(window).on 'keyup.atwhoInner', (ev) ->
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
