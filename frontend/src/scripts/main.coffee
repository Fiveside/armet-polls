#! Defines the project dependencies.
#!

require.config
  paths:
    # Collection of (extremely) useful utilities: <http://lodash.com/docs>.
    underscore: 'lib/underscore'

    # String manipulation extensions for underscore.
    'underscore-string': '../components/underscore.string/lib/underscore.string'

    # Eases DOM manipulation.
    jquery: '../components/jquery/jquery'

    # Provides the JSON object for manipulation of JSON strings if not
    # already defined.
    json2: '../components/json3/lib/json3'

    # Library that normalizes backbone and its extensions.
    backbone: 'lib/backbone'

    # Set of components and conventions powering Chaplin.
    'backbone-core': '../components/backbone/backbone'

    # Data binding utility library on top of backbone.
    'backbone-stickit': '../components/backbone.stickit/backbone.stickit'

    # Micro-template directory.
    templates: '../templates'

    # jQuery plugins
    'jquery-iframe-transport': 'vendor/jquery.iframe-transport'

    # Core framework powering the single-page application
    chaplin: 'vendor/chaplin'

    # Eases cookie manipulation
    # https://github.com/js-coder/cookie.js/blob/master/readme.md
    cookie: 'vendor/cookie'

    # Bootstrap plugins
    'bootstrap-datepicker': 'vendor/bootstrap-datepicker'
    'bootstrap-tooltip': '../components/bootstrap-sass/js/bootstrap-tooltip'

    # Moment js, for date/time formatting
    moment: '../components/moment/moment'

  shim:
    'underscore-string':
      exports: '_.str'

    'jquery-iframe-transport':
      exports: '$.fn.transport'
      deps: [
        'jquery'
      ]

    'backbone-core':
      exports: 'Backbone'
      deps: [
        'jquery'
        'underscore'
        'json2'
      ]

    'backbone-stickit':
      deps: [
        'backbone-core'
      ]

    'bootstrap-tooltip':
      exports: '$.fn.tooltip'
      deps: [
        'jquery'
      ]

    'bootstrap-datepicker':
      exports: '$.fn.datepicker'
      deps: [
        'jquery'
      ]

#! Instantiates the application and begins the execution cycle.
#!

require ['app'], (Application) ->
  new Application().initialize()
