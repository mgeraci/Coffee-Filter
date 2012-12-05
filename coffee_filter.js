// Generated by CoffeeScript 1.4.0
(function() {

  window.hover_tags = function() {
    $('body').on('mouseover', '[data-hover-tag]', function(e) {
      var left_offset, name, old_title, pointer_styles, position, tag, tag_styles, target, top_offset;
      target = $(this).closest('[data-hover-tag]');
      old_title = target.attr('title');
      target.attr('title', '');
      name = unescape(target.data('hover-tag'));
      if (name === '') {
        name = old_title;
        target.data('hover-tag', old_title);
      }
      position = target.offset();
      if ($('.hover_tag').length === 0) {
        tag_styles = {
          position: 'absolute',
          display: 'none',
          padding: '4px 6px 2px',
          background: 'black',
          background: 'rgba(0,0,0,0.8)',
          color: 'white',
          fontSize: '13px',
          textTransform: 'lowercase',
          zIndex: 800,
          textShadow: 'none'
        };
        pointer_styles = {
          position: 'absolute',
          top: '-6px',
          left: '50%',
          marginLeft: '-3px',
          width: '8px',
          height: '6px',
          background: 'url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAGCAYAAAD+Bd/7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAElJREFUeNpiYEAFxVCMFRgD8RkoNoYJMkJpXiBeBsSSUP5zII4C4s/MUIFcILZEMg2kgR2IjzNCjZuJw9p0kILNSEajg+cAAQYA1jkKUj6WaH4AAAAASUVORK5CYII=) no-repeat'
        };
        $('body').append("        <div class='hover_tag'>          <div class='text'></div>          <div class='tag_pointer'></div>        </div>");
        $('.hover_tag').css(tag_styles);
        $('.hover_tag .tag_pointer').css(pointer_styles);
      }
      tag = $('.hover_tag');
      tag.find('.text').html(name);
      top_offset = 8;
      left_offset = 0;
      if (target.data('hover-tag-top')) {
        top_offset = target.data('hover-tag-top');
      }
      if (target.data('hover-tag-left')) {
        left_offset = target.data('hover-tag-left');
      }
      return tag.css({
        top: position.top + target.outerHeight() + top_offset,
        left: position.left - tag.outerWidth() / 2 + target.width() / 2 + left_offset
      }).show();
    });
    return $('body').on('mouseout', '[data-hover-tag]', function(e) {
      return $('.hover_tag').hide();
    });
  };

  window.set_placeholder_text = function() {
    if (window.Modernizr == null) {
      return;
    }
    if (!window.Modernizr.input.placeholder) {
      $('[placeholder]').focus(function() {
        var input;
        input = $(this);
        if (input.val() === input.attr('placeholder')) {
          input.val('');
          return input.removeClass('placeholder');
        }
      }).blur(function() {
        var input;
        input = $(this);
        if (input.val() === '' || input.val() === input.attr('placeholder')) {
          input.addClass('placeholder');
          return input.val(input.attr('placeholder'));
        }
      }).blur();
      return $('[placeholder]').parents('form').submit(function() {
        return $(this).find('[placeholder]').each(function() {
          var input;
          input = $(this);
          if (input.val() === input.attr('placeholder')) {
            return input.val('');
          }
        });
      });
    }
  };

  jQuery.fn.autoexpand = function(on_change, force, on_init) {
    var elements,
      _this = this;
    if (on_change == null) {
      on_change = false;
    }
    if (force == null) {
      force = false;
    }
    if (on_init == null) {
      on_init = false;
    }
    if (!$('html').hasClass('ie8')) {
      elements = $(this);
      return elements.each(function(i, textarea) {
        var interval, newValue, observer, oldLines, oldValue, resize;
        textarea = $(textarea);
        interval = null;
        oldValue = textarea.val();
        oldLines = textarea.attr('rows') || 0;
        newValue = textarea.val();
        resize = function() {
          var char_per_line, current_length, lines, returns, _ref;
          char_per_line = textarea.width() / 6;
          current_length = newValue.length;
          lines = Math.floor(current_length / char_per_line);
          returns = ((_ref = newValue.match(/\n/g)) != null ? _ref.length : void 0) || 0;
          textarea.attr('rows', lines + returns + 2);
          oldValue = newValue;
          if (oldLines !== textarea.attr('rows')) {
            oldLines = textarea.attr('rows');
            if (on_change) {
              return on_change();
            }
          }
        };
        observer = function() {
          newValue = textarea.val();
          if (newValue !== oldValue) {
            return resize();
          }
        };
        textarea.focus(function() {
          return interval = setInterval(observer, 250);
        });
        textarea.blur(function() {
          return clearInterval(interval);
        });
        if (force) {
          textarea.focus();
        }
        if (on_init) {
          return resize();
        }
      });
    }
  };

  jQuery.fn.square_image = function() {
    var h, img, larger, percent, smaller, w, wrapper;
    wrapper = $(this);
    img = wrapper.find('img');
    w = img.width();
    h = img.height();
    wrapper.css({
      position: 'relative',
      overflow: 'hidden'
    });
    img.css({
      position: 'absolute'
    });
    if (w < h) {
      smaller = w;
      larger = h;
    } else {
      smaller = h;
      larger = w;
    }
    percent = (((larger - smaller) / 2) * 100 / larger * -1) / 100;
    if (h > w) {
      img.css({
        width: '100%',
        height: 'auto'
      });
      return img.css({
        top: Math.floor(percent * img.height())
      });
    } else if (h < w) {
      img.css({
        width: 'auto',
        height: '100%'
      });
      return img.css({
        left: Math.floor(percent * img.width())
      });
    } else {
      return img.css({
        width: '100%',
        height: '100%'
      });
    }
  };

  jQuery.fn.center_image = function() {
    var h, img, margin, margin_left, margin_top, max_size, new_max, w, wrapper;
    wrapper = $(this);
    img = wrapper.find('img');
    wrapper.css({
      position: 'relative',
      overflow: 'hidden'
    });
    w = img.width();
    h = img.height();
    max_size = wrapper.height() > wrapper.width() ? wrapper.width() : wrapper.height();
    if (w <= max_size && h <= max_size) {
      img.width(w);
      img.height(h);
      margin_top = (max_size - h) / 2;
      margin_left = (max_size - w) / 2;
      return img.css({
        margin: "" + margin_top + "px 0 0 " + margin_left + "px"
      });
    } else {
      if (w === h) {
        img.width(max_size);
        return img.height(max_size);
      } else {
        if (w > h) {
          new_max = max_size / (w / h);
          margin = (max_size - new_max) / 2;
          return img.css({
            width: max_size,
            height: new_max,
            margin: "" + margin + "px 0 0 0"
          });
        } else {
          new_max = max_size / (h / w);
          margin = (max_size - new_max) / 2;
          return img.css({
            width: new_max,
            height: max_size,
            margin: "0 0 0 " + margin + "px"
          });
        }
      }
    }
  };

  jQuery.fn.save_state = function() {
    var saving_text;
    $(this).attr('data-original-text', $(this).is('a') ? $(this).text() : $(this).val());
    saving_text = $(this).attr('data-saving-text');
    $(this).addClass('saving').css({
      opacity: 0.5
    });
    return $(this).set_button_text(saving_text);
  };

  jQuery.fn.unsave_state = function() {
    var original_text, saved_text,
      _this = this;
    original_text = $(this).attr('data-original-text');
    saved_text = $(this).attr('data-saved-text');
    if (saved_text) {
      $(this).set_button_text(saved_text);
      return setTimeout(function() {
        $(_this).removeClass('saving').css({
          opacity: 1
        });
        return $(_this).set_button_text(original_text);
      }, 1000);
    } else {
      $(this).removeClass('saving').css({
        opacity: 1
      });
      return $(this).set_button_text(original_text);
    }
  };

  jQuery.fn.set_button_text = function(text) {
    if ($(this).is('a')) {
      return $(this).text(text);
    } else {
      return $(this).val(text);
    }
  };

  jQuery.fn.link_urls = function(cutoff) {
    if (cutoff == null) {
      cutoff = null;
    }
    return $(this).each(function() {
      var cutoff_regex, exp, href, url, visual_url, _i, _len, _ref;
      if (!$(this).hasClass('autolinked')) {
        exp = /\b(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@\#\/%=~_|$?!:,.]*\)|[-A-Z0-9+&@\#\/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@\#\/%=~_|$?!:,.]*\)|[A-Z0-9+&@\#\/%=~_|$])/ig;
        _ref = $(this).text().match(exp);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          url = _ref[_i];
          href = url.match(/^www.+/) ? "http://" + url : url;
          cutoff_regex = new RegExp("(^.{" + cutoff + "}).+");
          visual_url = url.replace(cutoff_regex, '$1...').split('').join('&#8203;');
          $(this).html($(this).html().replace(/\&amp\;/g, '&').replace(url, "<a href='" + href + "' target='_blank'>" + visual_url + "</a>"));
        }
        return $(this).addClass('autolinked');
      }
    });
  };

  window.set_tabindex = function(items) {
    $('[tabindex]').removeAttr('tabindex');
    return $.each(items, function(i, item) {
      return $(item).attr('tabindex', i + 1);
    });
  };

  jQuery.fn.outerHTML = function() {
    return $(this).clone().wrap('<div>').parent().html();
  };

  window.should_allow_keyboard_shortcuts = function() {
    if ($(':focus').is('input') || $(':focus').is('textarea') || $(':focus').is('select') || $('html').hasClass('ie8')) {
      return false;
    } else {
      return true;
    }
  };

}).call(this);
