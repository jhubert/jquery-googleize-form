###
Copyright (c) 2012 Jeremy Hubert (http://github.com/jhubert)
Released under the MIT License. See LICENSE for details.
###
( ($) ->

  $.fn.GoogleizeForm = (options) ->

    opts = $.extend {}, $.fn.GoogleizeForm.defaults, options

    validateEmail = (email) ->
      return false if email == ''
      emailReg = opts.emailRegex
      return emailReg.test( email )

    # The error response is what you will get back every time because
    # Google Docs doesn't have a jsonp response object.
    handleErrorResponse = (event, errorType, error) ->
      opts.success()

    # Do our own ajax form submit instead
    hijackFormSubmit = (e) ->
      # Prevent the form from submitting naturally
      e.preventDefault()

      form = $(this)
      emailField = form.find(opts.emailFieldSelector)

      if not validateEmail(emailField.val())
        opts.invalidEmail(emailField)
        return false;

      options = {}
      options.type = 'POST'
      # JSONP won't work because Google Docs doesn't have a jsonp api
      # but it just throws a console error and we assume it worked
      # This is the only way to get it to pass the data over to the
      # Google Docs URL because of cross scripting security
      options.dataType = 'jsonp'
      options.url = form.attr('action')
      options.data = form.serialize()
      options.error = handleErrorResponse

      # We are using .ajax because .post doesn't have an error handler
      $.ajax(options)

      return

    @each ->
      $(this).on 'submit', hijackFormSubmit

  $.fn.GoogleizeForm.defaults =
    emailRegex: /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/
    emailFieldSelector: '#entry.0.single'
    success: ->
    invalidEmail: (field) ->
  return
    
)(jQuery);