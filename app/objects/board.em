`import Square from 'tic-tac-toe/objects/square'`

class Board extends Em.Object
    squares: null
    moveStack: null

    init: ->
        @squares = [
            new Square(), new Square(), new Square()
            new Square(), new Square(), new Square()
            new Square(), new Square(), new Square()
        ]
        @moveStack = []

    isGameOver:             Em.computed.or      'noMoreMoves', 'computerWins', 'humanWins'
    noMoreMoves:            Em.computed.empty   'possibleSquares'
    computerHasNotWonYet:   Em.computed.not     'computerWins'
    humanHasNotWonYet:      Em.computed.not     'humanWins'
    nobodyWins:             Em.computed.and     'noMoreMoves', 'computerHasNotWonYet', 'humanHasNotWonYet'
    cannotWin:              Em.computed.empty   'winningMove'
    canWin:                 Em.computed.not     'cannotWin'
    cannotBlock:            Em.computed.empty   'blockingMove'
    canBlock:               Em.computed.not     'cannotBlock'

    step:     Em.computed.alias 'moveStack.length'
    lastMove: ~> @moveStack.objectAt(@step)

    reset: ->
        @undoLastMark() while not Em.isEmpty(@moveStack)
            
           
    +computed squares.@each.isBlank
    isEmpty: -> @squares.every (square) -> square.get('isBlank')

    +computed squares.@each.isComputer
    computerWins: ->
        """
        Computer wins if his spots match a winning placement
        """
        for win in Board.winningPlacements
            count = 0
            count++ for index in win when @squares.objectAt(index).get('isComputer')
            return true if count is 3
        return false

    +computed squares.@each.isHuman
    humanWins: ->
        """
        Human wins if his spots match a winning placement
        """
        for win in Board.winningPlacements
            count = 0
            count++ for index in win when @squares.objectAt(index).get('isHuman')
            return true if count is 3
        return false

    +computed squares.@each.isBlank
    possibleSquares: -> (i for square, i in @squares when square.get('isBlank'))

    +computed possibleSquares.@each
    possibleWinSquaresComputer: ->
        return getPossibleWinSquares.call(@, Square.computer)

    +computed possibleSquares.@each
    possibleWinSquaresHuman: ->
        return getPossibleWinSquares.call(@, Square.human)

    markSquare: (index, squareType) ->
        return false unless @squares.objectAt(index).get('isBlank')

        @squares.objectAt(index).set('content', squareType)
        @lastMove = index
        @moveStack.unshiftObject(@lastMove)
        return true

    undoLastMark: ->
        return unless @step?
        @lastMove = @moveStack.shiftObject(@step)
        @squares.objectAt(@lastMove).set('content', Square.blank)

    +computed possibleSquares.@each
    winningMove: ->
        move = null

        for index in @possibleSquares
            break if move?
            @markSquare(index, Square.computer)
            move = index if @computerWins
            @undoLastMark()

        return move

    +computed possibleSquares.@each
    blockingMove: ->
        move = null

        for index in @possibleSquares
            break if move?
            @markSquare(index, Square.human)
            move = index if @humanWins
            @undoLastMark()

        return move

    +computed squares.@each.isBlank
    nextAvailableCorner: ->
        for index in Board.corners
            return index if @squares.objectAt(index).get('isBlank')

        return null

getPossibleWinSquares = (type) ->
    possibleWinSquares = []
    for move in @possibleSquares
        @markSquare(move, type)
        if type is Square.computer
            possibleWinSquares.push(move) if @computerWins
        else
            possibleWinSquares.push(move) if @humanWins
        @undoLastMark()
    return possibleWinSquares


Board.reopenClass
    center: 4
    corners: [0, 2, 6, 8]
    edges:   [1, 3, 5, 7]

    winningPlacements: [
        [0, 1, 2] # first row
        [3, 4, 5] # second row
        [6, 7, 8] # third row
        [0, 3, 6] # first column
        [1, 4, 7] # second column
        [2, 5, 8] # third column
        [0, 4, 8] # horiz 1
        [2, 4, 6] # horiz 2
    ]

    cornerFarthestFrom: (edge) ->
        farthest = 
            1: 6
            3: 8
            5: 0
            7: 2

        return farthest[edge]

    oppositeCorner: (corner) ->
        opps =
            0: 8
            8: 0
            2: 6
            6: 2

        return opps[corner]

`export default Board`
