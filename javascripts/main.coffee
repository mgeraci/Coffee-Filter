# functions that should run on load
$(window).load(->
  # load syntax highlighting
  $.SyntaxHighlighter.init({
    wrapLines: false
    lineNumbers: false
    theme: 'sunburst'
    themes: ['sunburst']
    baseUrl: "#{window.location.protocol}//#{window.location.host}#{if window.location.host.match('github') then '/Coffee-Filter' else ''}"
  })

  drip_drip_drop() if Modernizr.csstransitions

  hover_tags()
  set_placeholder_text()
  set_autoexpand()
  set_square_image()
  set_center_image()
  set_ajax_button()
  set_autolink()
  set_tabindex()
  set_kb()
)

drip_drip_drop = ->
  drip = $('#drip')

  setTimeout(->
    drip.addClass('dripping')
    setTimeout(->
      drip.removeClass('dripping').addClass('drop')
    , 600)

    setTimeout(->
      drip.removeClass('drop')
      drip_drip_drop()
    , 1200)
  , 5000)

set_autoexpand = ->
  $('#autoexpand textarea').autoexpand(autoexpand_notifer)

autoexpand_notifer = ->
  note = $('#autoexpand_notifier')
  note.html('<span style="color: red">autoexpand just ran!</span>')

  setTimeout(->
    note.text 'this text will change when autoexpand runs'
  , 1000)

set_square_image = ->
  $('#square_image_wrapper').square_image()

set_center_image = ->
  $('#center_image_wrapper').center_image()

set_ajax_button = ->
  $('.fancy_button').on 'click', (e)->
    e.preventDefault()
    $(this).save_state()

    setTimeout(=>
      $(this).unsave_state()
    , 1500)

set_autolink = ->
  $('#to_autolink').link_urls(30)

set_tabindex = ->
  window.set_tabindex([
    $('.input4'),
    $('.input3'),
    $('.input2'),
    $('.input1')
  ])

set_kb = ->
  inputs = $('#keyboard_shortcuts input, #keyboard_shortcuts textarea, #keyboard_shortcuts select')

  inputs.on 'focus', ->
    set_kb_status window.should_allow_keyboard_shortcuts()

  inputs.on 'blur', ->
    set_kb_status window.should_allow_keyboard_shortcuts()

set_kb_status = (status)->
  s = $('#kb_status')
  s.removeClass('go').removeClass('no')

  if status
    s.addClass('go').text('go')
  else
    s.addClass('no').text('no go')
