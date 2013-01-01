#! Defines underscore and registers extensions on it directly.
#!

define (require) ->
  _     = require '../components/lodash/lodash'
  _.str = require 'underscore-string'
  _.mixin(_.str.exports())
  _
