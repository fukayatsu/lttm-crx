chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
  if (request.action == 'getJSON') {
    fetch(request.url).then(function (response) {
      return response.json();
    }).then(function (json) {
      sendResponse(json);
    });

    // https://www.mitsuru-takahashi.net/blog/chrome-extension-response/
    // https://stackoverflow.com/questions/48107746/chrome-extension-message-not-sending-response-undefined
    return true;
  } else {
    console.log('unsoported action', request.action);
  }
})
