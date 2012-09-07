# Editor v2
#
# The dashboard's CSS editor. 

module.exports =

  # loads the css editor, and puts it on the page
  init: (@dashboard) ->
    jQuery('body').append ss.tmpl['dashboard-editor'].r()
    jQuery('#cssEditor').hide().fadeIn 500
    @setupDataStore()
    @element().draggable({handle:'.header'}).css
      top: "#{(window.innerHeight-@element().height())/2}px"
      left: "#{(window.innerWidth-@element().width())/2}px"
    @bindCloseAction()
    @loadEditor @dashboard.css, 'css', 'css'

  # Loads CodeMirror with the code and the code's type
  loadEditor: (value, mode, codeType) ->
    @element().find('#editContainer').html ''
    editor = CodeMirror document.getElementById('editContainer'),
      value: value
      theme: 'twilight'
      lineWrapping: true
      lineNumbers: true
      tabSize: 2
      onChange: (cm) =>
        @css = cm.getValue()
        jQuery('style#dashboardStyle').text cm.getValue()

    editor.setOption 'mode', mode
    CodeMirror.autoLoadMode editor, mode    
  
  # return the element
  element: -> 
    jQuery '#cssEditor'

  setupDataStore: ->
    @css = @dashboard.css

  # bind the close button
  bindCloseAction: ->
    @element().find('a.close').tooltip({}).on 'click', => 
      @exit()

  # handles UI removal of editor
  wrapItUp: (cb=null) ->
    jQuery('.tooltip').remove() # prevent the download tooltip hanging around
    @element().fadeOut 250, =>
      @element().remove()
    cb() if cb?

  # Identifies any changes to the dashboard's css, and saves them if so
  identifyChanges: (cb) ->
    changes = {}
    changes.css = @css if @dashboard.css isnt @css
    cb changes

  # Close the editor, save any changes
  exit: (cb=null) ->
    @identifyChanges (changes) =>
      if _.isEmpty changes
        @wrapItUp(cb)
      else
        changes._id = @dashboard._id
        ss.rpc 'dashboard.update', changes, (response) =>
          if response.status is 'success'
            @wrapItUp cb
          else
            alert response.reason
            @wrapItUp cb