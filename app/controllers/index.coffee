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
      isPaused = @get 'isPaused'

      unless isPaused
        @set 'isPaused', true

        board = @get 'board'
        isGameOver = @get 'isGameOver'

        if not isGameOver and board.markSquare(index, Square.human)
          nextMove = AI.nextMove(board)
          isGameOver = @get 'isGameOver'
          board.markSquare(nextMove, Square.computer) unless isGameOver

        @set 'isPaused', false

`export default IndexController`
