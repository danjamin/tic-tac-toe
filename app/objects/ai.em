`import Board from 'tic-tac-toe/objects/board'`
`import Square from 'tic-tac-toe/objects/square'`

class AI extends Em.Object

basicStrategy = (board) ->
    lastMove = board.get('lastMove')
    step = board.get('step')

    switch step
        # if first move, take the center
        when 0 then Board.center

        # if second move, counter with center OR next available corner
        when 1
            if lastMove is Board.center
                return board.get('nextAvailableCorner')
            else
                return Board.center

        # if third move, we know we went first, counter with farthest corner
        # or opposite corner depending
        when 2
            if Board.edges.contains(lastMove)
                return Board.cornerFarthestFrom(lastMove)
            else
                return Board.oppositeCorner(lastMove)

        # all other moves
        else
            # if only one move left, return that one
            possibleSquares = board.get('possibleSquares');
            return possibleSquares[0] if possibleSquares.length is 1

            # if we can take the win, do it
            return board.get('winningMove') if board.get('canWin')

            # if we can block an immediate win, block it
            return board.get('blockingMove') if board.get('canBlock')

            goodMove = null
            neutralMove = null

            # for each possible moves
            for move in possibleSquares
                board.markSquare(move, Square.computer)

                possibleWinSquares = board.get('possibleWinSquaresComputer')

                switch possibleWinSquares.length
                    # 2 possible wins for us -> BEST
                    when 2
                        board.undoLastMark()
                        return move 
                
                    # 1 possible win, let's dive deeper
                    when 1
                        # if opponent can block and have 2 possible wins -> WORST
                        board.markSquare(possibleWinSquares[0], Square.human)

                        possibleOpponentWinSquares = board.get('possibleWinSquaresHuman')
                        if possibleOpponentWinSquares.length <= 1
                            goodMove = move if goodMove is null

                        board.undoLastMark()

                    # 0 possible wins, dive deeper
                    else
                        # if opponent can setup 2 possible wins -> WORST
                        possibleCounters = board.get('possibleSquares')
                        hasCounterMove = false

                        for counterMove in possibleCounters
                            board.markSquare(counterMove, Square.human)
                            
                            possibleOpponentWinSquares = board.get('possibleWinSquaresHuman')
                            if possibleOpponentWinSquares.length >= 1
                                hasCounterMove = true

                            board.undoLastMark()

                            break if hasCounterMove

                        unless hasCounterMove
                            neutralMove = move if neutralMove is null

                board.undoLastMark()
                
            # after iterating, return GOOD otherwise NEUTRAL
            return goodMove if goodMove?
            return neutralMove


AI.reopenClass
    nextMove: (board) -> basicStrategy(board)

`export default AI`
