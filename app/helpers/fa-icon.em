FAIcon = Em.Handlebars.makeBoundHelper (str, options) ->
    new Em.Handlebars.SafeString('<i class="fa fa-%@"></i>'.fmt str)

`export default FAIcon`
