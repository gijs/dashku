# Documentation ruling the nation

# View the documentation page
jQuery(document).on 'click', 'a#docs', ->
  mainState.setState 'docs'
  ss.rpc 'general.getDocument', 'introduction/index', (res) ->
    jQuery('#doc-content').html res.content

# Render a document from the list on the left
jQuery(document).on 'click', '.document', ->
  doc = jQuery(@).attr('data-document')
  ss.rpc 'general.getDocument', doc, (res) ->
    jQuery('#doc-content').html res.content
    jQuery('#doc-content pre code').each (i, e) ->
      hljs.highlightBlock e