$ ->
  txt = $("textarea")
  hiddenTextareaClone = $(document.createElement("div"))
  content = null
  txt.addClass "txtstuff"
  hiddenDiv.addClass "hiddendiv common"

  $("body").append hiddenTextareaClone
  txt.on "keyup", ->
    content = $(this).val()
    content = content.replace(/\n/g, "")
    hiddenDiv.html content + ""
    $(this).css "height", TextareaClone.height()
    return

  return
