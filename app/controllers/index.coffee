`import Em from 'ember'`
`import Square from 'tic-tac-toe/models/square'`
`import AI from 'tic-tac-toe/models/ai'`

IndexController = Em.ObjectController.extend
  board: Em.computed.alias 'model'

  isPaused: false

  actions:
    resetBoard: ->
      board = @get 'board'
      board.reset()

    squareMarked: (index) ->
      return if @get('isPaused')

      board = @get 'board'
      isGameOver = @get 'isGameOver'

      @set 'isPaused', true

      if not isGameOver and board.markSquare(index, Square.human)
        nextMove = AI.nextMove(board)
        board.markSquare(nextMove, Square.computer) unless @get('isGameOver')

      @set 'isPaused', false

`export default IndexController`
