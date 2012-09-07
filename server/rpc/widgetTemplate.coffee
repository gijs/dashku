#### Widget Template RPC module ####

exports.actions = (req, res, ss) ->

  getAll: ->
    WidgetTemplate.find {}, (err, docs) ->
      if !err
        res status: 'success', widgetTemplates: docs
      else
        res status: 'failure', reason: err