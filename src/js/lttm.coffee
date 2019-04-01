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
          if location.protocol == "https:"
            url = 'https://lttm-ssl.herokuapp.com/lgtm'
          else
            url = 'http://www.lgtm.in/g'
          task1 = $.getJSON(url + '?' + Math.random()).then()
          task2 = $.getJSON(url + '?' + Math.random()).then()
          task3 = $.getJSON(url + '?' + Math.random()).then()
          $.when(task1, task2, task3).then (a, b, c) ->
            images = _.map([
              a[0]
              b[0]
              c[0]
            ], (data) ->
              imageUrl = data.actualImageUrl
              name:            imageUrl
              imageUrl:        imageUrl
              imagePreviewUrl: previewUrl(imageUrl)
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
                  imagePreviewUrl: previewUrl(url)
                  alt: "tiqav"
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
              image = v.image.replace('http://', 'https://')
              images.push
                name: image
                imageUrl: image
                imagePreviewUrl: previewUrl(image)
                alt: "ミサワ"
            callback images
        when kind is "i"
          $.getJSON chrome.extension.getURL("/config/irasutoya.json"), (data) ->
            illustrations = []
            if query
              illustrations = _.filter(data, (n) ->
                (n.title?.indexOf(query) > -1) ||
                (n.description?.indexOf(query) > -1) ||
                (n.categories && n.categories.join().indexOf(query) > -1)
              )
            else
              illustrations = _.sample(data, 30)
            images = []
            $.each illustrations, (k, v) ->
              image_url = v.image_url.replace('http://', 'https://')
              images.push
                name: image_url
                imageUrl: image_url
                imagePreviewUrl: previewUrl(image_url)
                alt: v.title
            callback images
        when kind is 's'
          $.getJSON chrome.extension.getURL("/config/sushi_list.json"), (data) ->
            sushiList = []
            if query
              sushiList = _.filter(data, (sushi) ->
                !!_.find(sushi.keywords, (keyword) ->
                  keyword.indexOf(query) > -1
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
                  keyword.indexOf(query) > -1
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
        when kind is 'n'
          $.getJSON chrome.extension.getURL("/config/engineer_homeru_neko.json"), (data) ->
            source = []
            if query
              source = _.filter(data, (js_girl) ->
                !!_.find(js_girl.keywords, (keyword) ->
                  keyword.indexOf(query) > -1
                )
              )
            else
              source = data

            images = []
            _.each(source, (item) ->
              images.push
                name: item.url
                imageUrl: item.url
                imagePreviewUrl: item.url
                alt: "エンジニアを褒めるネコ:#{item.keywords[0]}"
            )
            callback images
        when kind is 'd'
          $.getJSON chrome.extension.getURL("/config/decomoji.json"), (data) ->
            decomojis = []
            if query
              decomojis = _.filter(data, (js_girl) ->
                !!_.find(js_girl.keywords, (keyword) ->
                  keyword.indexOf(query) > -1
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
        when kind is 'r'
          $.getJSON chrome.extension.getURL("/config/sushidot.json"), (data) ->
            sushidots = []
            if query
              sushidots = _.filter(data, (js_girl) ->
                !!_.find(js_girl.keywords, (keyword) ->
                  keyword.indexOf(query) > -1
                )
              )
            else
              sushidots = data

            images = []
            _.each(sushidots, (sushidot) ->
              images.push
                name: sushidot.url
                imageUrl: sushidot.url
                imagePreviewUrl: sushidot.url
                alt: ":#{sushidot.keywords[0]}"
            )
            callback images

previewUrl = (url) ->
  return url if location.protocol     == "http:"
  return url if url.indexOf('https:') == 0

  shaObj = new jsSHA("SHA-1", 'TEXT')
  shaObj.setHMACKey 'lttmlttm', 'TEXT'
  shaObj.update url
  hmac = shaObj.getHMAC('HEX')
  "https://lttmcamo.herokuapp.com/#{hmac}?url=#{url}"

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
