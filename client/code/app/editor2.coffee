# Editor v2
#
# A rewrite of the code editor. 
# Dependencies: jQuery, jQuery-ui(draggable), ss.tmpl(Hogan), CodeMirror, scopeCss global function, underscore.js

module.exports =

  # loads the widget editor, and puts it on the page
  init: (@dashboardId, @widget, @exitCb=null) ->
    jQuery('body').append ss.tmpl['widget-editor2'].render scriptType: @titleify @widget.scriptType
    jQuery('#editor2').hide().fadeIn 500
    @setupDataStore()
    @element().draggable({handle:'.header'}).css
      top: "#{(window.innerHeight-@element().height())/2}px"
      left: "#{(window.innerWidth-@element().width())/2}px"
    @bindTabs()
    @bindActionButtons()
    @bindCloseAction()
    @selectTab 'json'

  # return the element
  element: -> 
    jQuery '#editor2'

  # Loads CodeMirror with the code and the code's type
  loadEditor: (value, mode, codeType) ->
    @element().find('#editContainer').html ''
    @editor = CodeMirror document.getElementById('editContainer'),
      value: value
      theme: 'twilight'
      lineWrapping: true
      lineNumbers: true
      tabSize: 2
      onChange: (cm) =>
        @store[codeType] = cm.getValue()
        @liveUpdate codeType, cm.getValue()

    @editor.setOption 'mode', mode
    CodeMirror.autoLoadMode @editor, mode

  # binds the tabs for switching between different part's of the widget's code
  bindTabs: ->
    @element().find('li.tab#script').tooltip {}
    @element().find('li.tab').on 'click', (event) =>
      @selectTab jQuery(event.currentTarget).attr('id')

  # add Twitter tooltips to the action buttons, and bind their clicks
  bindActionButtons: ->
    @element().find("##{item}").tooltip {} for item in ['load', 'transmit', 'download']

    # bind the load click event
    @element().find('#load').on 'click', =>
      @liveUpdate 'html', @store.html
      @liveUpdate 'css', @store.css      
      ee = new EE code: @store.script, id: @widget._id, scriptType: @store.scriptType
  
    # bind the transmit click event
    @element().find('#transmit').on 'click', =>
      ee = new EE code: @store.script, id: @widget._id, scriptType: @store.scriptType, loadData: {}, dontEmit: true  
      ee.emit 'transmission', JSON.parse @store.json

    @element().find('#download').on 'click', =>      
      @exit =>
        @exitCb()
        jQuery(ss.tmpl['widget-scriptModal'].render({dashboardId: @dashboardId, _id: @widget._id})).modal()

  # bind the close button
  bindCloseAction: ->
    @element().find('a.close').tooltip({}).on 'click', => 
      @exit @exitCb

  # titleize's a title i.e 'coffeescript' => 'CoffeeScript'
  titleify: (text) ->
    text.charAt(0).toUpperCase() + text.slice(1)

  # changes between javascript and coffeescript if the previous tab was 'script'
  changeScriptType: (codeType) ->
    if @previousTab? and @previousTab is 'script' and codeType is 'script'
      newScriptType = _.difference(['javascript','coffeescript'],[@store.scriptType])[0]
      @store.scriptType = newScriptType
      @element().find('li.tab#script').text @titleify newScriptType

  # handles selection of tabs
  selectTab: (codeType) ->
    @changeScriptType codeType
    @element().find('li.tab').removeClass 'active'
    @element().find("li.tab##{codeType}").addClass 'active'
    cmCodeType = codeType
    cmCodeType = 'xml' if cmCodeType is 'html'
    cmCodeType = @store.scriptType if cmCodeType is 'script'
    cmCodeType = 'javascript' if cmCodeType is 'json'
    @loadEditor @store[codeType], cmCodeType, codeType
    @previousTab = codeType

  # Creates an editable copy of the widget's code
  setupDataStore: ->
    @store = 
      html:       @widget.html
      css:        @widget.css
      script:     @widget.script
      scriptType: @widget.scriptType
      json:       @widget.json

  # Updates ther widget's html and css on-the-fly
  liveUpdate: (codeType, value) ->
    widgetElement = jQuery("#widgets .widget[data-id='#{@widget._id}']")
    switch codeType
      when 'html'
        widgetElement.find('.content').html value
      when 'css'
        widgetElement.find('style').text scopeCSS value, @widget._id
      else

  # Identifies any changes to the widget's code, and saves them if so
  identifyChanges: (cb) ->
    changes = {}
    for codeType, code of @store
      changes[codeType] = code if @widget[codeType] isnt code
    cb changes

  # handles UI removal of editor
  wrapItUp: (cb=null) ->
    jQuery('.tooltip').remove() # prevent the download tooltip hanging around
    @element().remove()
    cb() if cb?

  # removes the editor from the DOM, and saves any changes
  exit: (cb) ->
    @identifyChanges (changes) =>
      if _.isEmpty changes
        @wrapItUp(cb)
      else
        changes._id = @widget._id
        changes.dashboardId = @dashboardId
        ss.rpc 'widget.update', changes, (response) =>
          if response.status is 'success'
            @wrapItUp(cb)
          else
            # TODO - figure out a nice, generic way to handle these errors
            alert response.reason
            @wrapItUp(cb)