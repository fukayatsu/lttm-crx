$("textarea").atwho
  at: "!"
  tpl: '<li class="lttm" data-value="![${alt}](${imageUrl})"><img src="${imageUrl}" /></li>'
  limit: 10
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

        else
          $.getJSON "http://api.tiqav.com/search/random.json", {}, (data) ->
            images = []
            $.each data, (k, v) ->
              url = "http://tiqav.com/" + v.id + "." + v.ext
              images.push
                name: url
                imageUrl: url
                alt: "tiqav"
            callback images

      else if kind is "m"
        $.getJSON chrome.extension.getURL("/config/meigens.json"), (data) ->
          boys = []
          if query
            boys = _.filter(data, (n) ->
              (n.title and n.title.indexOf(query) > -1) or (n.body and n.body.indexOf(query) > -1)
            )
          else
            boys = _.sample(data, 20)
          images = []
          $.each boys, (k, v) ->
            images.push
              name: v.image
              imageUrl: v.image
              alt: "ミサワ"
          callback images
