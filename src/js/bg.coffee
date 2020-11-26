chrome.runtime.onMessage.addListener (fetchParams, sender, onSuccess) ->
  fetch fetchParams.url, fetchParams.options || {}
  .then (response) -> response.text()
  .then (responseText) ->
    try
      onSuccess(JSON.parse(responseText))
    catch error
      onSuccess(responseText)
  true
