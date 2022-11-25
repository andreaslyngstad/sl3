$(document).on 'page:change', ->
	url = location.pathname
	ga('send', {
  'hitType': 'pageview',
  'page': url,
  'title': 'my overridden page'
	})