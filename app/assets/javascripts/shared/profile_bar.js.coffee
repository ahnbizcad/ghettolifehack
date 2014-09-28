### 
comment
###

$(document).ready ->
  $('#profile-favorites > a')
    .on "click", (e) ->
      e.preventDefault()
      $(this).tab('show')
  $('#profile-hacks > a')
    .on "click", (e) ->
      e.preventDefault()
      $(this).tab('show')
  $('#profile-comments > a')
    .on "click", (e) ->
      e.preventDefault()
      $(this).tab('show')
