
((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  return  if d.getElementById(id)
  js = d.createElement(s)
  js.id = id
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=1469614829979932&version=v2.0"
  fjs.parentNode.insertBefore js, fjs
  return
) document, "script", "facebook-jssdk"


