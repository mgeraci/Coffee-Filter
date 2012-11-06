# functions that should run on load
$(window).load(->
  hover_tags()
  set_placeholder_text()
  set_autoexpand()
  set_square_image()
  set_center_image()
  set_autolink()
  set_tabindex()
  set_outerhtml()
  set_kb()
)

set_autoexpand = ->
  $('#autoexpand textarea').autoexpand(autoexpand_notifer)

autoexpand_notifer = ->
  note = $('#autoexpand_notifier')
  note.text('autoexpand just ran!')

  setTimeout(->
    note.text ''
  , 1000)

set_square_image = ->
  $('#square_image_wrapper').square_image()

set_center_image = ->
  $('#center_image_wrapper').center_image()

set_autolink = ->
  $('#to_autolink').link_urls()

set_tabindex = ->
  window.set_tabindex([
    $('.tabindex1'),
    $('.tabindex2'),
    $('.tabindex3'),
    $('.tabindex4')
  ])

set_outerhtml = ->
  console.log $('#to_outerhtml').html()
  console.log $('#to_outerhtml').outerHTML()

set_kb = ->
  inputs = $('#keyboard_shortcuts input, #keyboard_shortcuts textarea')

  inputs.on 'focus', ->
    console.log window.should_allow_keyboard_shortcuts()

  inputs.on 'blur', ->
    console.log window.should_allow_keyboard_shortcuts()
