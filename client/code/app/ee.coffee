# A custom Event Emitter, there is probably a better 
# solution out there.
#
# TODO - investigate if there is a better option

class window.EE
  constructor: (options) ->
    @listeners = {}
    @widget = jQuery(".widget[data-id='#{options.id}'] .content")
    if options.scriptType is 'javascript'
      eval options.code
    else
      eval CoffeeScript.compile options.code

    @emit('load', options.loadData) unless options.dontEmit?

  on: (eventName, fnk) =>
    if @listeners[eventName]?
      @listeners[eventName].push fnk
    else
      @listeners[eventName] = [fnk]

    if eventName.match?('stream_')
      streamId = eventName.split('_')[1]
      ss.rpc 'stream.subscribe', streamId, (response) =>
        ss.event.on "stream_#{streamId}", (data, channelName) =>
          @emit "stream_#{streamId}", data


  emit: (eventName, data) =>
    if @listeners[eventName]?
      fnk data for fnk in @listeners[eventName]