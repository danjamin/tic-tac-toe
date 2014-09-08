`import Em from 'ember'`
`import Board from 'tic-tac-toe/objects/board'`

IndexRoute = Em.Route.extend
  model: -> Board.create()

`export default IndexRoute`
