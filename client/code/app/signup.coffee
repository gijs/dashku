#### Signup ####
#
# At the moment, the logic for the validations is on the client,
# which isn't ideal. I would like to have them be on the server
# in the model, and be exposed to the client for the form to use.
#
# TODO - Change location of validation logic to the ODM level, 
# and find a way to expose it to the client.

# Validates that the attribute is a non-empty value
validatePresence = (value, trueFunction, falseFunction) ->
  if value isnt "" then trueFunction() else falseFunction()

# Validates that the attribute is unique
validateUniqueness = (key, value, trueFunction, falseFunction) ->
  check = {}
  check[key] = value
  ss.rpc 'authentication.isAttributeUnique', check, (attributeIsUnique) ->
    if attributeIsUnique then trueFunction() else falseFunction()

# Validates that the email address is valid
validateFormat = (value, format, trueFunction, falseFunction) ->
  if value.match(/^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i)?
    trueFunction()
  else
    falseFunction()

# Validates that the attribute is at least a certain length
validateMinimumLength = (value, number, trueFunction, falseFunction) ->
  if value.length > number - 1
    trueFunction()
  else
    falseFunction()

# This handles the storage of errors for the signup form
class ErrorHandler
  constructor: ->
    @errors = {}

  addError: (key, value, cb=null) ->
    if @errors[key]?
      @errors[key].push value unless @errors[key].indexOf value isnt -1
    else
      @errors[key] = [value]
    cb() if cb?

  removeError: (key, value, cb=null) ->
    if @errors[key]?
      index = @errors[key].indexOf value
      @errors[key].splice index, 1 if index isnt -1
      delete @errors[key] if @errors[key].length is 0
    cb() if cb?

  removeErrors: (key, cb=null) ->
    delete @errors[key]
    cb() if cb?

  valid: ->
    Object.keys(@errors).length is 0
 
module.exports =

  # Displays the signup modal, and creates bindings 
  init: (options={})->
    @id = Math.random().toString().split('.')[1]
    $(ss.tmpl.signupModal.r()).attr('id', "signup_#{@id}").modal()
    $(document).on 'shown', "#signup_#{@id}", (event) =>
      @bindUponRender options

  # Create bindings for the sign modal form
  bindUponRender: (options)->
    @errorHandler = new ErrorHandler 
    @disableSubmitButton()
    @bindUsernameValidation()
    @bindEmailValidation()
    @bindPasswordValidation()
    @bindSignupFunction options.signupFunction
    @bindUponClosure()

  # A simple semanic function
  enableSubmitButton: ->
    @element().find('button').removeAttr "disabled"

  # A simple semanic function
  disableSubmitButton: ->
    @element().find('button').attr "disabled", "disabled"
  
  # Binds the validations to the username field
  bindUsernameValidation: ->
    inputElement = @element().find('input[name="username"]')
    inputElement.blur =>
      validatePresence inputElement.val(), 
        =>
          @errorHandler.removeError inputElement.attr('name'), 'cannot be empty', =>
            validateUniqueness inputElement.attr('name'), inputElement.val(), 
              => @removeError inputElement, 'is already taken'
              , 
              => @applyError inputElement, 'is already taken'
        , 
        => @applyError inputElement, 'cannot be empty'

  # Binds the validations to the email field
  bindEmailValidation: ->
    inputElement = @element().find('input[name="email"]')
    inputElement.blur =>
      validatePresence inputElement.val(), 
        =>
          @errorHandler.removeError inputElement.attr('name'), 'cannot be empty', =>
            validateFormat inputElement.val(), /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i,
              => 
                @errorHandler.removeError inputElement.attr('name'), 'is not the right format', =>
                  validateUniqueness inputElement.attr('name'), inputElement.val(),
                    => @removeError inputElement, 'is already taken'
                    ,
                    => @applyError inputElement, 'is already taken'
              ,
              => @applyError inputElement, 'is not the right format'
        , 
        => @applyError inputElement, 'cannot be empty'

  # Binds the validations to the password field
  bindPasswordValidation: ->
    inputElement = @element().find('input[name="password"]')
    inputElement.keyup =>
      validateMinimumLength inputElement.val(), 6, 
        => @removeError inputElement, 'is too short'
        ,
        => @applyError inputElement, 'is too short', true
    
    inputElement.blur =>
      inputElement.val '' if inputElement.val().length < 6 

  # Stores the error in the ErrorHandler class, and renders it visually.
  #
  # Ideally, I think that this function should execute on ErrorHandler
  # receiving an error
  applyError: (inputElement, message, dontClearValue=false) ->
    @errorHandler.addError inputElement.attr('name'), message, =>
      inputElement.parent().addClass 'control-group error'
      inputElement.val '' unless dontClearValue
      inputElement.attr 'placeholder', "#{inputElement.attr('name')} #{message}"
      inputElement.focus -> inputElement.attr 'placeholder', inputElement.attr 'name'
      @checkFormIsReady()

  # Removes the error in the ErrorHandler class, and removes it from the form
  #
  # Like the function above, I think that this should be bound to the ErrorHandler
  # class in some way
  removeError: (inputElement, message) ->
    @errorHandler.removeError inputElement.attr('name'), message, =>
      inputElement.parent().removeClass 'control-group error'
      inputElement.attr 'placeholder', inputElement.attr 'name'
      @checkFormIsReady()

  # Checks the fields in the form have valid attributes, and will 
  # either enable or disable the submit button. 
  checkFormIsReady: ->
    username  = @element().find('input[name="username"]').val() isnt ""
    email     = @element().find('input[name="email"]').val() isnt ""
    password  = @element().find('input[name="password"]').val() isnt ""
    if username and email and password and @errorHandler.valid() 
      @enableSubmitButton()
    else
      @disableSubmitButton()  

  # This does a bit of cleanup when the modal is closed
  bindUponClosure: ->
    @errors = {}
    $(document).on 'hidden', "#signup_#{@id}", -> 
      $(@).remove()

  # This binds the signup function to the form submission
  bindSignupFunction: (signupFunction) ->
    if signupFunction?
      @element().find('form').submit (event) =>
        signupFunction @element()

  # A semantic helper function
  element: ->
    $ "#signup_#{@id}"