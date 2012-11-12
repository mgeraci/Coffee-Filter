#      = Coffee Filter =
#
#  _______________________
#  \\\                   /
#   \\\                 /
#    \\\               /
#     \\\             /
#      \\\           /
#       \\\\\\\\\\\\/
#
#
# A collection of coffeescript helpers I've used across projects
# By Michael P. Geraci, 2012
# mgeraci.com
#
# MIT License


# show a tag on hover (e.g., a username when hovering over an avatar)
# add the desired text as a data attribute on the element, e.g.:
#   <img src='/images/avatar.png' data-hover-tag='michael geraci'>
window.hover_tags = ->
  $('body').on 'mouseover', '[data-hover-tag]', (e)->
    target = $(this).closest('[data-hover-tag]')

    # Clean out hover tag title so browser hover doesn't show
    old_title = target.attr('title')
    target.attr('title', '')
    name = unescape(target.data('hover-tag')) # unescape in case you use line breaks

    # use title attr if no hover-tag defined
    if name == ''
      name = old_title
      target.data('hover-tag', old_title)

    position = target.offset()

    # append tag and styles if it doesn't exist
    if $('.hover_tag').length == 0
      tag_styles =
        position: 'absolute'
        display: 'none'
        padding: '4px 6px 2px'
        background: 'black'
        background: 'rgba(0,0,0,0.8)'
        color: 'white'
        fontSize: '13px'
        textTransform: 'lowercase'
        zIndex: 800
        textShadow: 'none'

      pointer_styles =
        position: 'absolute'
        top: '-6px'
        left: '50%'
        marginLeft: '-3px'
        width: '8px'
        height: '6px'
        background: 'url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAGCAYAAAD+Bd/7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAElJREFUeNpiYEAFxVCMFRgD8RkoNoYJMkJpXiBeBsSSUP5zII4C4s/MUIFcILZEMg2kgR2IjzNCjZuJw9p0kILNSEajg+cAAQYA1jkKUj6WaH4AAAAASUVORK5CYII=) no-repeat'

      # add the html structure
      $('body').append "
        <div class='hover_tag'>
          <div class='text'></div>
          <div class='tag_pointer'></div>
        </div>"

      # add the styles
      $('.hover_tag').css tag_styles
      $('.hover_tag .tag_pointer').css pointer_styles

    tag = $('.hover_tag')

    # set the text
    tag.find('.text').html(name)

    top_offset = 8
    left_offset = 0

    # here's a good place to put conditionals for special cases
    # you can override top_offset and left_offset, for example:
    # if $(this).hasClass('questions_item_image')
    #  top_offset = 11
    #  left_offset = -1

    # position and show the tag
    tag.css(
      top: position.top + target.outerHeight() + top_offset
      left: position.left - tag.outerWidth() / 2 + target.width() / 2 + left_offset
    ).show()

  $('body').on 'mouseout', '[data-hover-tag]', (e)->
    $('.hover_tag').hide()


# manually handles input placeholder text for browsers that don't support the html5 spec
# requires modernizr
# http://webdesignerwall.com/tutorials/cross-browser-html5-placeholder-text
window.set_placeholder_text = ->
  return unless window.Modernizr?
  unless window.Modernizr.input.placeholder
    $('[placeholder]').focus(->
      input = $(this)
      if input.val() == input.attr('placeholder')
        input.val('')
        input.removeClass('placeholder')
    ).blur(->
      input = $(this)
      if input.val() == '' || input.val() == input.attr('placeholder')
        input.addClass('placeholder')
        input.val(input.attr('placeholder'))
    ).blur()

    $('[placeholder]').parents('form').submit ->
      $(this).find('[placeholder]').each ->
        input = $(this)
        if input.val() == input.attr('placeholder')
          input.val('')


# call on a textarea to have it grow when you type in it.
# 2nd arg. is an optional function to run on change
# 3rd arg. tells the function to focus and start watching now
#
# requires the class ie8 on <html> to keep this function from running.
# based on code from http://tore.darell.no/posts/auto_expanding_textarea
jQuery.fn.autoexpand = (on_change = false, force = false)->
  # don't run on ie8
  unless $('html').hasClass('ie8')
    elements = $(this)

    # get the textarea and its value
    elements.each (i, textarea)=>
      textarea = $(textarea)
      interval = null
      oldValue = textarea.val()
      oldLines = textarea.attr('rows') || 0

      # The observer function for auto textarea resizing
      observer = =>
        # save the value
        newValue = textarea.val()

        # if the value has changed
        if newValue != oldValue
          char_per_line = textarea.width() / 6
          current_length = newValue.length
          lines = Math.floor(current_length / char_per_line)
          returns = newValue.match(/\n/g)?.length || 0 # number of user-entered new lines

          # Set the "rows" attribute to the number of lines + 2
          textarea.attr('rows', lines + returns + 2)
          oldValue = newValue

          if oldLines != textarea.attr('rows')
            oldLines = textarea.attr('rows')

            # run on change function if it exists
            on_change() if on_change

      # When the user focuses the textarea, create the observer interval
      textarea.focus ->
        # Assign the interval to a variable so it can be removed later
        # Check every 0.5s
        interval = setInterval(observer, 250)

      # When the user is finished editing, remove the interval
      textarea.blur ->
        clearInterval(interval)

      # set the watcher if using force
      textarea.focus() if force


# given an image of arbitrary dimensions,
# center it within a square wrapper
# wrapper must have overflow: hidden
# and a defined width and height
jQuery.fn.square_image = ->
  wrapper = $(this)
  img = wrapper.find('img')
  w = img.width()
  h = img.height()

  wrapper.css({position: 'relative', overflow: 'hidden'})
  img.css({position: 'absolute'})

  if w < h
    smaller = w
    larger = h
  else
    smaller = h
    larger = w

  # get the amount of the image to offset it by
  percent = (((larger - smaller) / 2) * 100 / larger * -1) / 100

  if h > w
    img.css({width: '100%', height: 'auto'})
    img.css({top: Math.floor(percent * img.height())})
  else if h < w
    img.css({width: 'auto', height: '100%'})
    img.css({left: Math.floor(percent * img.width())})
  else
    img.css({width: '100%', height: '100%'})

# center an image a box, keeping its original
# aspect ratio
jQuery.fn.center_image = ->
  wrapper = $(this)
  img = wrapper.find('img')
  wrapper.css({position: 'relative', overflow: 'hidden'})

  w = img.width()
  h = img.height()
  max_size = if wrapper.height() > wrapper.width() then wrapper.width() else wrapper.height()

  # if the image is smaller than the box
  if w <= max_size && h <= max_size
    img.width(w)
    img.height(h)
    margin_top = (max_size - h) / 2
    margin_left = (max_size - w) / 2
    img.css({margin: "#{margin_top}px 0 0 #{margin_left}px"})

  # if the image is larger than the box
  else
    # handle each case (w>h, h>w, w==h)
    if w == h
      img.width(max_size)
      img.height(max_size)
    else
      if w > h
        new_max = max_size / (w / h)
        margin = (max_size - new_max) / 2
        img.css({
          width: max_size,
          height: new_max,
          margin: "#{margin}px 0 0 0"
        })
      else
        new_max = max_size / (h / w)
        margin = (max_size - new_max) / 2
        img.css({
          width: new_max,
          height: max_size,
          margin: "0 0 0 #{margin}px"
        })


## these next two handle "save" and "done saving" states for buttons
## expects two data attributes for the button's text:
## 'data-original-text' and 'data-saving-text'

# optionally, you can run set_original_text() to reduce repetition
# in your markup. it will look for the data-original-text attribute
# and fill in the text/value of the element if not already present.
window.set_original_text = ->
  $('[data-original-text]').each ->
    if $(this).is('a')
      $(this).text $(this).data('original-text') unless $(this).text() != ''
    else
      $(this).val $(this).data('original-text') unless $(this).val() != ''

# begin save state
jQuery.fn.save_state = ->
  saving_text = $(this).attr('data-saving-text')
  $(this).addClass('saving').css({opacity: 0.5})
  $(this).set_button_text saving_text

# return to default state
jQuery.fn.unsave_state = ->
  original_text = $(this).attr('data-original-text')
  saved_text = $(this).attr('data-saved-text')


  # either show the saved note and then the original text
  # or just the original text
  if saved_text
    $(this).set_button_text saved_text
    setTimeout(=>
      $(this).removeClass('saving').css({opacity: 1})
      $(this).set_button_text original_text
    , 1000)
  else
    $(this).removeClass('saving').css({opacity: 1})
    $(this).set_button_text original_text

# set the text on an anchor or button tag
jQuery.fn.set_button_text = (text)->
  if $(this).is('a')
    $(this).text text
  else
    $(this).val text

# replace text links with html links in a block of text
jQuery.fn.link_urls = ()->
  $(this).each ->
    unless $(this).hasClass('autolinked')
      # regular expression is from http://www.regexguru.com/2008/11/detecting-urls-in-a-block-of-text/
      exp = ///
      \b(?:(?:https?|ftp|file)://|www\.|ftp\.)
      (?:\([-A-Z0-9+&@\#/%=~_|$?!:,.]*\)|[-A-Z0-9+&@\#/%=~_|$?!:,.])*
      (?:\([-A-Z0-9+&@\#/%=~_|$?!:,.]*\)|[A-Z0-9+&@\#/%=~_|$])
      ///ig

      _($(this).text().match(exp)).each (url)=>
        # add a protocol if it just starts with www
        href = if url.match(/^www.+/) then "http://#{url}" else url

        # break the url with zero-width spaces and an ellipsis for readability
        visual_url = url.split('').join('&#8203;').replace(/(^.{300}).+/, '$1...')

        # replace the url with a link
        $(this).html $(this).html().replace(/\&amp\;/g, '&').replace(url, "<a href='#{href}' target='_blank'>#{visual_url}</a>")

      $(this).addClass('autolinked')


# remove tabindex on all items
# iterate through passed array of jQuery elements
# incrementing their tabindexes
# requires underscore.js
window.set_tabindex = (items)->
  $('[tabindex]').removeAttr('tabindex')
  _.each items, (item, i)->
    $(item).attr('tabindex', i+1)

# get the html of an object, including its wrapper
jQuery.fn.outerHTML = ()->
  $(this).clone().wrap('<div>').parent().html()

# should keyboard shortcuts be allowed? returns true or false.
# sees that you are not in an input or textarea
# requires <html> to have the class "ie8" when appropriate
window.should_allow_keyboard_shortcuts = ->
  if $(':focus').is('input') || $(':focus').is('textarea') || $(':focus').is('select') || $('html').hasClass('ie8')
    return false
  else
    return true
