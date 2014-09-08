`import Em from 'ember'`

FAIconHelper = Em.Handlebars.makeBoundHelper (str, options) ->
  new Em.Handlebars.SafeString "<i class='fa fa-#{str}'></i>"

`export default FAIconHelper`
