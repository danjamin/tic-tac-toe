`import Em from 'ember'`
`import Resolver from 'ember/resolver'`
`import loadInitializers from 'ember/load-initializers'`

Em.MODEL_FACTORY_INJECTIONS = true

App = Em.Application.extend
  modulePrefix: 'tic-tac-toe' # TODO: loaded via config
  Resolver: Resolver

loadInitializers(App, 'tic-tac-toe')

`export default App`
