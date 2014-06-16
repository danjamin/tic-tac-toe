`import Square from 'tic-tac-toe/objects/square'`
`import AI from 'tic-tac-toe/objects/ai'`

class Index extends Em.ObjectController
    
    board: Em.computed.alias 'model'

    isPaused: false

    actions:
        resetBoard: ->
            board = @board
            board.reset()

        squareMarked: (index) ->
            paused = @isPaused

            unless paused
                @isPaused = true

                board = @board
                isGameOver = @isGameOver
                if not isGameOver and board.markSquare(index, Square.human)
                    nextMove = AI.nextMove(board)
                    isGameOver = @isGameOver
                    board.markSquare(nextMove, Square.computer) unless isGameOver

                @isPaused = false

`export default Index`
