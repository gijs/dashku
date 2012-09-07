#### Bucket ####
#
# This is a client-side model storage library I wrote
# to handle the specific use-cases for Dashku.
#

# TODO - write some tests for this library
class window.Bucket
  constructor: (data) ->
    @loadFnx      = data.loadFunction
    @selectCb     = data.selectCb || null
    @preSelectCb  = data.preSelectCb || null
    @preAddCb     = data.preAddCb || null
    @postUpdateCb = data.postUpdateCb || null
    @all = []
    @unique_key = '_id'
    @selected = null

  # Load data into the Bucket
  load: (cb=null) =>
    @loadFnx (data) =>
      @add data, cb

  # Clear all data from the Bucket
  unload: (cb=null) =>
    @selected = null
    @all = []
    cb() if cb?

  # Find an item in the bucket, given an id
  find: (id) =>
    return item for item in @all when item[@unique_key] is id

  # add an item, or an array of items, to the bucket
  add: (objectOrArray, cb=null) =>
    if objectOrArray instanceof Array 
      for item in objectOrArray
        try
          if @preAddCb?          
              @preAddCb item, (amendedItem) =>
                @all.push amendedItem
          else
            @all.push item 
        catch error
          console.log error
    else 
      if objectOrArray?
        if @preAddCb?
          @preAddCb objectOrArray, (amendedItem) =>
            @all.push amendedItem 
        else
          @all.push objectOrArray 
    cb() if cb?

  # remove an item, given either the item, or the id of the item
  remove: (objectOrArrayOrId, cb=null) =>
    if objectOrArrayOrId instanceof Array 
      for item in objectOrArray
        position  = _.indexOf @all, item
        @all      = @all.splice position, 1 if position isnt -1
    else
      if objectOrArrayOrId instanceof Object
        position  = _.indexOf @all, objectOrArrayOrId
        @all.splice position, 1 if position isnt -1
      else
        position  = _.indexOf @all, @find(objectOrArrayOrId)
        @all.splice position, 1 if position isnt -1
    cb() if cb?

  # update an existing item, or an array of items
  update: (objectOrArray, cb=null) =>
    if objectOrArray instanceof Array
      for item in objectOrArray
        existingItem          = @find item[@unique_key]
        position              = _.indexOf(@all, existingItem)
        if position isnt -1
          @all[position]      = _.extend @all[position], item 
          if @postUpdateCb?
            @postUpdateCb @all[position], (amendedItem) =>
              @all[position] = amendedItem
    else
      if objectOrArray?
        existingItem        = @find objectOrArray[@unique_key]
        position            = _.indexOf(@all, existingItem)
        if position isnt -1
          @all[position]    = _.extend @all[position], objectOrArray
          if @postUpdateCb?
            @postUpdateCb @all[position], (amendedItem) =>
              @all[position] = amendedItem
    cb() if cb?

  # This is a helper function used to identify a selected item from
  # the bucket, i.e. the current dashboard the user is using.
  select: (idOrObject) =>
    if @preSelectCb?
      @preSelectCb =>
        @selected = if typeof(idOrObject) is "string" then @find(idOrObject) else idOrObject
        @selectCb @selected if @selected? and @selectCb?        
    else 
      @selected = if typeof(idOrObject) is "string" then @find(idOrObject) else idOrObject
      @selectCb @selected if @selected? and @selectCb?