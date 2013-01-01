#! Extensions done to `Backbone` directly.
#!

define (require) ->
  'use strict'

  _        = require 'underscore'
  Backbone = require 'backbone-core'

  require 'jquery-iframe-transport'
  require 'backbone-stickit'

  #! Extend Backbone.sync to pass in authorization headers from the
  #! session object.
  Backbone.sync = _.wrap Backbone.sync, (func, method, model, options = {}) ->
    # Ensure we throw cookies at the server during XHRs.
    options.xhrFields =
      withCredentials: true

    # Does the model contain any files ?\
    if model.files? and model.files.length \
            and (method is 'create' or method is 'update')
        options.files = model.files
        options.iframe = true
        options.data = model.toJSON()
        options.processData = false

    # Delegate to `Backbone.sync` to throw things at the server
    func method, model, options

  #! Return backbone
  Backbone
