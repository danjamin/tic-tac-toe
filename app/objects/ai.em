`import Board from 'tic-tac-toe/objects/board'`
`import Square from 'tic-tac-toe/objects/square'`

class AI extends Em.Object

basicStrategy = (board) ->
    lastMove = board.get('lastMove')
    step = board.get('step')

    switch step
        when 0 then Board.center
        when 1
            if lastMove is Board.center
                return board.get('nextAvailableCorner')
            else
                return Board.center
        when 2
            # we know we went first
            if Board.edges.contains(lastMove)
                return Board.cornerFarthestFrom(lastMove)
            else
                return Board.oppositeCorner(lastMove)
        else
            return board.get('winningMove') if board.get('canWin')
            return board.get('blockingMove') if board.get('canBlock')
            return board.get('nextAvailableCorner') if board.get('hasBlankCorner')
            return board.get('nextAvailable')

AI.reopenClass
    nextMove: (board) -> basicStrategy(board)

`export default AI`
