window.Ubret.Ajax = (method, url) ->
  promise = new Ubret.Promise()
  request = new XMLHttpRequest()

  onLoad = ->
    if request.status is 200 or request.status is 304
      value = JSON.parse request.response
      promise.fulfill value
    else
      promise.reject request.statusCode

  onError = ->
    promise.reject "Network error reaching: #{url}"

  request.open method, url, true
  request.onload = onLoad
  request.onerror = onError
  request.send()
  promise

window.Ubret.Get = _.partial Ubret.Ajax, 'GET'

window.Ubret.Post = _.partial Ubret.Ajax, 'POST'
