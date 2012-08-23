# = Coffee Filter =
#
# a collection of coffeescript helpers I've used across projects
# by Michael P. Geraci, 2012
# mgeraci.com


# functions that should run onload
$(->
  hover_tags()
  placeholder_text()
)


# show a tag on hover (e.g., a username when hovering over an avatar)
# add the desired text as a data attribute on the element, e.g.:
#   <img src='/images/avatar.png' data-hover-tag='michael geraci'>
# some images and styles required for this to work (included)
window.hover_tags = ->
  $('body').on 'mouseover', '[data-hover-tag]', (e)->
    target = $(this).closest('[data-hover-tag]')

    # Clean out hover tag title so browser hover doesn't show
    old_title = target.attr('title')
    target.attr('title', '')
    name = unescape(target.data('hover-tag'))

    # use title attr if no hover-tag defined
    if name == ''
      name = old_title
      target.data('hover-tag', old_title)

    position = target.offset()

    # append tag if it doesn't exist
    $('body').append('<div class="hover_tag"><div class="text"></div><div class="tag_pointer"></div></div>') if $('.hover_tag').length == 0

    tag = $('.hover_tag')

    # set the text
    tag.find('.text').html(name)

    top_offset = 8
    left_offset = 0

    if $(this).hasClass('questions_item_image')
      top_offset = 11
      left_offset = -1
    else if $(this).hasClass('remove_item')
      left_offset = 2
    else if $(this).hasClass('delete_question')
      top_offset = 9
      left_offset = 6

    # position and show the tag
    if $(this).hasClass('suggested_avatar')
      return if $(window).width() < 641
    tag.css({top: position.top + target.outerHeight() + top_offset, left: position.left - tag.outerWidth() / 2 + target.width() / 2 + left_offset}).show()

  $('body').on 'mouseout', '[data-hover-tag]', (e)->
    $('.hover_tag').hide()


# manually handles input placeholder text for browsers that don't support the html5 spec
# requires modernizr
# http://webdesignerwall.com/tutorials/cross-browser-html5-placeholder-text
window.set_placeholder_text = ->
  unless Modernizr.input.placeholder
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
# requires modernizr to put the class ie8 on <html> to keep this
# function from running.
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
  img = $(this)
  wrapper = img.parent()
  w = img.width()
  h = img.height()
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


## these next two handle "save" and "done saving" states for buttons
## expects two data attributes for the button's text:
## 'data-original-text' and 'data-saving-text'

# begin save state
jQuery.fn.save_state = ->
  saving_text = $(this).attr('data-saving-text')
  $(this).addClass('saving').css({opacity: 0.5})
  if $(this).is('a')
    $(this).text(saving_text)
  else
    $(this).val(saving_text)

# return to default state
jQuery.fn.unsave_state = ->
  saving_text = $(this).attr('data-original-text')
  $(this).addClass('saving').css({opacity: 0.5})
  if $(this).is('a')
    $(this).text(saving_text)
  else
    $(this).val(saving_text)


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
# required underscore.js
window.set_tabindex = (items)->
  $('[tabindex]').removeAttr('tabindex')
  _.each items, (item, i)->
    $(item).attr('tabindex', i+1)

# get the html of an object, including its wrapper
jQuery.fn.outerHTML = ()->
  $(this).clone().wrap('<div>').parent().html()

# should keyboard shortcuts be allowed? returns true or false.
# requires modernizr for ie8 check
# sees that you are not in an input or textarea
window.should_allow_keyboard_shortcuts = ->
  if $(':focus').is('input') || $(':focus').is('textarea') || $(':focus').is('select') || $('html').hasClass('ie8')
    return false
  else
    return true
