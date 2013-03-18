Ubret.Ajax = (method, url) ->


Ubret.Get = _.partial Ubret.Ajax, 'GET'

Ubret.Post = _.partial Ubret.Ajax, 'POST'
