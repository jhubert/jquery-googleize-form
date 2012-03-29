/*
Copyright (c) 2012 Jeremy Hubert (http://github.com/jhubert)
Released under the MIT License. See LICENSE for details.
*/
(function($) {
  $.fn.GoogleizeForm = function(options) {
    var handleErrorResponse, hijackFormSubmit, opts, validateEmail;
    opts = $.extend({}, $.fn.GoogleizeForm.defaults, options);
    validateEmail = function(email) {
      var emailReg;
      if (email === '') return false;
      emailReg = opts.emailRegex;
      return emailReg.test(email);
    };
    handleErrorResponse = function(event, errorType, error) {
      return opts.success();
    };
    hijackFormSubmit = function(e) {
      var emailField, form;
      e.preventDefault();
      form = $(this);
      emailField = form.find(opts.emailFieldSelector);
      if (!validateEmail(emailField.val())) {
        opts.invalidEmail(emailField);
        return false;
      }
      options = {};
      options.type = 'POST';
      options.dataType = 'jsonp';
      options.url = form.attr('action');
      options.data = form.serialize();
      options.error = handleErrorResponse;
      $.ajax(options);
    };
    return this.each(function() {
      return $(this).on('submit', hijackFormSubmit);
    });
  };
  $.fn.GoogleizeForm.defaults = {
    emailRegex: /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
    emailFieldSelector: '#entry.0.single',
    success: function() {},
    invalidEmail: function(field) {}
  };
})(jQuery);