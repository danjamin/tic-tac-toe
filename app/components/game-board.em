class GameBoard extends Em.Component
    tagName: 'ul'
    classNames: 'game-board-component clearfix'.w()

    board: null
    selectAction: null

    +computed board.squares.@each.content
    squares: ->
        board = @board
        squares = board.get('squares')

    actions:
        selectSquare: (index) ->
            this.sendAction('selectAction', index)

`export default GameBoard`
