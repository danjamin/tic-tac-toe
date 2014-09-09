`import Em from 'ember'`

GameBoardComponent = Em.Component.extend
  tagName: 'ul'
  classNames: 'game-board-component clearfix'.w()

  board: null
  selectAction: null

  squares: Em.computed.alias 'board.squares'

  actions:
    selectSquare: (index) ->
      @sendAction 'selectAction', index

`export default GameBoardComponent`
