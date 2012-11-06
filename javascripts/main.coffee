# functions that should run on load
$(window).load(->
  hover_tags()
  set_placeholder_text()
  set_autoexpand()
  set_square_image()
  set_center_image()
  set_autolink()
)

set_autoexpand = ->
  $('#autoexpand textarea').autoexpand()

set_square_image = ->
  $('#square_image_wrapper').square_image()

set_center_image = ->
  $('#center_image_wrapper').center_image()

set_autolink = ->
  $('#to_autolink').link_urls()
