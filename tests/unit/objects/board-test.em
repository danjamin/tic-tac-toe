`import { test } from 'ember-qunit'`
`import Board from 'tic-tac-toe/objects/board'`
`import Square from 'tic-tac-toe/objects/square'`

test 'Board - sanity check', ->
    equal Board.center, 4, 'center constant is correct'

test 'Board - empty instance works', -> 
    b = new Board()
    ok b.get('isEmpty'), 'is empty'
    ok not b.get('noMoreMoves'), 'has more moves'
    ok not b.get('computerWins'), 'computer has NOT won'
    ok b.get('computerHasNotWonYet'), 'computer has NOT won'
    ok not b.get('humanWins'), 'human has NOT won'
    ok b.get('humanHasNotWonYet'), 'human has NOT won'
    ok not b.get('isGameOver'), 'game is NOT over'
    ok not b.get('canWin'), 'can NOT win on next move'
    equal b.get('winningMove'), null, 'no winning move right now'
    ok not b.get('canBlock'), 'can NOT block on next move'
    deepEqual b.get('moveStack'), [], 'stack is empty'
    equal b.get('step'), 0, 'step is 0 to start'
    deepEqual b.get('possibleSquares'), [0..8], 'all moves are possible'
    equal b.get('nextAvailable'), 0, 'next possible move is 0'

test 'Board - after first move works', ->
    b = new Board()
    b.markSquare(0, Square.computer)
    ok b.get('squares').objectAt(0).get('isComputer'), 'square set properly'
    ok not b.get('isEmpty'), 'is not empty'
    ok not b.get('noMoreMoves'), 'has more moves'
    ok b.get('computerHasNotWonYet'), 'computer has NOT won'
    ok b.get('humanHasNotWonYet'), 'human has NOT won'
    ok not b.get('isGameOver'), 'game is NOT over'
    deepEqual b.get('moveStack'), [0], 'stack contains first move'
    equal b.get('step'), 1, 'step is 1 now'
    deepEqual b.get('possibleSquares'), [1..8], 'check remaining moves'
    equal b.get('nextAvailable'), 1, 'next possible move is 1'

test 'Board - basic win works', ->
    b = new Board()
    b.markSquare(3, Square.computer)
    b.markSquare(4, Square.computer)
    b.markSquare(5, Square.computer)
    ok b.get('squares').objectAt(3).get('isComputer'), 'square set properly'
    ok b.get('squares').objectAt(4).get('isComputer'), 'square set properly'
    ok b.get('squares').objectAt(5).get('isComputer'), 'square set properly'
    ok not b.get('isEmpty'), 'is not empty'
    ok not b.get('noMoreMoves'), 'has more moves'
    ok b.get('computerWins'), 'computer has won'
    ok not b.get('computerHasNotWonYet'), 'computer has won'
    ok b.get('humanHasNotWonYet'), 'human has NOT won'
    ok b.get('isGameOver'), 'game is over'
    deepEqual b.get('possibleSquares'), [[0..2]..., [6..8]...], 'check remaining moves'

test 'Board - diagonal win works', ->
    b = new Board()
    b.markSquare(6, Square.computer)
    b.markSquare(4, Square.computer)
    b.markSquare(2, Square.computer)
    ok b.get('squares').objectAt(6).get('isComputer'), 'square set properly'
    ok b.get('squares').objectAt(4).get('isComputer'), 'square set properly'
    ok b.get('squares').objectAt(2).get('isComputer'), 'square set properly'
    ok not b.get('isEmpty'), 'is not empty'
    ok not b.get('noMoreMoves'), 'has more moves'
    ok b.get('computerWins'), 'computer has won'
    ok not b.get('computerHasNotWonYet'), 'computer has won'
    ok b.get('isGameOver'), 'game is over'
    deepEqual b.get('possibleSquares'), [0,1,3,5,7,8], 'check remaining moves'

test 'Board - full board win', ->
    b = new Board()
    
    # x | o | x
    # ----------
    # o | x | o
    # ----------
    # o | x |
    b.markSquare(0, Square.computer)
    b.markSquare(1, Square.human)
    b.markSquare(2, Square.computer)
    
    b.markSquare(3, Square.human)
    b.markSquare(4, Square.computer)
    b.markSquare(5, Square.human)
    
    b.markSquare(6, Square.human)
    b.markSquare(7, Square.computer)

    ok not b.get('isGameOver'), 'game is over'
    b.markSquare(8, Square.computer) # verify observers are working
    ok b.get('squares').objectAt(8).get('isComputer'), 'square set properly'
    ok not b.get('isEmpty'), 'is not empty'
    ok b.get('noMoreMoves'), 'NO more moves'
    ok b.get('computerWins'), 'computer has won'
    ok b.get('isGameOver'), 'game is over'
    deepEqual b.get('possibleSquares'), [], 'no remaining moves'

test 'Board - undo last works on empty', ->
    b = new Board()

    equal b.get('step'), 0, 'step is 0 to start'
    deepEqual b.get('moveStack'), [], 'stack is empty'
    
    b.markSquare(2, Square.computer)

    equal b.get('step'), 1, 'step is 1 now'
    deepEqual b.get('moveStack'), [2], 'stack contains move'

    b.undoLastMark()

    equal b.get('step'), 0, 'step is 0 after undo'
    deepEqual b.get('moveStack'), [], 'stack is empty again'

test 'Board - undo last works after 2 moves', ->
    b = new Board()

    equal b.get('step'), 0, 'step is 0 to start'
    deepEqual b.get('moveStack'), [], 'stack is empty'
    
    b.markSquare(2, Square.computer)
    b.markSquare(3, Square.computer)

    equal b.get('step'), 2, 'step is 2 now'
    deepEqual b.get('moveStack'), [3, 2], 'stack contains moves'
    
    b.undoLastMark()

    equal b.get('step'), 1, 'step is 1 after undo'
    deepEqual b.get('moveStack'), [2], 'stack contains last move'

    b.undoLastMark()

    equal b.get('step'), 0, 'step is 0 after undo'
    deepEqual b.get('moveStack'), [], 'stack is empty again'

test 'Board - winning move row', ->
    b = new Board()

    # x |   | x
    # ----------
    #   |   | 
    # ----------
    #   |   |
    b.markSquare(0, Square.computer)
    b.markSquare(2, Square.computer)

    ok b.get('canWin'), 'computer can win'
    equal b.get('winningMove'), 1, 'the winning move is square 1'

test 'Board - winning move column', ->
    b = new Board()

    #   |   | x
    # ----------
    #   |   | 
    # ----------
    #   |   | x
    b.markSquare(2, Square.computer)
    b.markSquare(8, Square.computer)

    ok b.get('canWin'), 'computer can win'
    equal b.get('winningMove'), 5, 'the winning move is square 5'

test 'Board - winning move diagonal', ->
    b = new Board()

    # x |   | 
    # ----------
    #   |   | 
    # ----------
    #   |   | x
    b.markSquare(0, Square.computer)
    b.markSquare(8, Square.computer)

    ok b.get('canWin'), 'computer can win'
    equal b.get('winningMove'), 4, 'the winning move is square 4'

test 'Board - more than one possible win', ->
    b = new Board()

    # x |   | x
    # ----------
    #   | o | 
    # ----------
    #   |   | x
    b.markSquare(0, Square.computer)
    b.markSquare(2, Square.computer)
    b.markSquare(4, Square.human)
    b.markSquare(8, Square.computer)

    ok b.get('canWin'), 'computer can win'
    equal b.get('winningMove'), 1, 'the winning move is square 1'

    b.markSquare(1, Square.human)

    ok b.get('canWin'), 'computer can win'
    equal b.get('winningMove'), 5, 'the winning move is square 5'

test 'Board - blocking move row', ->
    b = new Board()

    # o |   | o
    # ----------
    #   |   | 
    # ----------
    #   |   |
    b.markSquare(0, Square.human)
    b.markSquare(2, Square.human)

    ok not b.get('canWin'), 'computer can NOT win'
    ok b.get('canBlock'), 'computer can block'
    equal b.get('blockingMove'), 1, 'the blocking move is square 1'

test 'Board - blocking move column', ->
    b = new Board()

    #   |   | o
    # ----------
    #   |   | 
    # ----------
    #   |   | o
    b.markSquare(2, Square.human)
    b.markSquare(8, Square.human)

    ok b.get('canBlock'), 'computer can block'
    equal b.get('blockingMove'), 5, 'the blocking move is square 5'

test 'Board - blocking move diagonal', ->
    b = new Board()

    # o |   | 
    # ----------
    #   |   | 
    # ----------
    #   |   | o
    b.markSquare(0, Square.human)
    b.markSquare(8, Square.human)

    ok b.get('canBlock'), 'computer can block'
    equal b.get('blockingMove'), 4, 'the blocking move is square 4'
