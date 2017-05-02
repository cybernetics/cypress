_ = require("lodash")

$Log = require("../../cypress/log")
utils = require("../../cypress/utils")

module.exports = (Cypress, Commands) ->
  Commands.addAll({ prevSubject: "optional" }, {
    end: ->
      null
  })

  Commands.addAll({
    noop: (arg) -> arg

    log: (msg, args) ->
      $Log.command({
        end: true
        snapshot: true
        message: [msg, args]
        consoleProps: ->
          {
            message: msg
            args:    args
          }
      })

      return null

    wrap: (arg, options = {}) ->
      _.defaults options, {log: true}

      remoteSubject = @_getRemotejQueryInstance(arg)

      if options.log isnt false
        options._log = $Log.command()

        if utils.hasElement(arg)
          options._log.set({$el: arg})

      do resolveWrap = =>
        @verifyUpcomingAssertions(arg, options, {
          onRetry: resolveWrap
        })
  })