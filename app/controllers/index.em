`import Square from 'tic-tac-toe/objects/square'`
`import AI from 'tic-tac-toe/objects/ai'`

class Index extends Em.ObjectController
    
    board: Em.computed.alias 'model'

    actions:
        squareMarked: (index) ->
            board = @board
            board.markSquare(index, Square.human)
            nextMove = AI.nextMove(board)
            board.markSquare(nextMove, Square.computer)

`export default Index`
