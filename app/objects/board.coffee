`import Em from 'ember'`
`import Square from 'tic-tac-toe/objects/square'`

Board = Em.Object.extend
  squares: null
  moveStack: null

  init: ->
    @_super()
    @set 'squares', [
      Square.create(), Square.create(), Square.create()
      Square.create(), Square.create(), Square.create()
      Square.create(), Square.create(), Square.create()
    ]
    @set 'moveStack', []

  isGameOver: Em.computed.or 'noMoreMoves', 'computerWins', 'humanWins'
  noMoreMoves: Em.computed.empty 'possibleSquares'
  computerHasNotWonYet: Em.computed.not 'computerWins'
  humanHasNotWonYet: Em.computed.not 'humanWins'
  nobodyWins: Em.computed.and 'noMoreMoves', 'computerHasNotWonYet', 'humanHasNotWonYet'
  cannotWin: Em.computed.empty 'winningMove'
  canWin: Em.computed.not 'cannotWin'
  cannotBlock: Em.computed.empty 'blockingMove'
  canBlock: Em.computed.not 'cannotBlock'

  step: Em.computed.alias 'moveStack.length'

  lastMove: Em.computed 'moveStack', ->
    moveStack = @get 'moveStack'
    step = @get 'step'
    moveStack.objectAt step

  reset: ->
    @undoLastMark() while not Em.isEmpty(@get('moveStack'))

  isEmpty: Em.computed 'squares.@each.content', ->
    squares = @get 'squares'
    squares.every (square) -> square.get 'isBlank'

  # Computer wins if his spots match a winning placement
  computerWins: Em.computed 'squares.@each.content', ->
    squares = @get 'squares'

    for win in Board.winningPlacements
      count = 0
      count++ for index in win when squares.objectAt(index).get('isComputer')
      return true if count is 3
    
    false

  # Human wins if his spots match a winning placement
  humanWins: Em.computed 'squares.@each.content', ->
    squares = @get 'squares'

    for win in Board.winningPlacements
      count = 0
      count++ for index in win when squares.objectAt(index).get('isHuman')
      return true if count is 3

    false

  possibleSquares: Em.computed 'squares.@each.content', ->
    squares = @get 'squares'
    (i for square, i in squares when square.get('isBlank'))

  possibleWinSquaresComputer: Em.computed 'possibleSquares.@each', ->
    _getPossibleWinSquares.call this, Square.computer

  possibleWinSquaresHuman: Em.computed 'possibleSquares.@each', ->
    _getPossibleWinSquares.call this, Square.human

  markSquare: (index, squareType) ->
    squares = @get 'squares'
    moveStack = @get 'moveStack'

    square = squares.objectAt(index)

    return false unless square.get('isBlank')

    square.set('content', squareType)

    @set 'lastMove', index
    moveStack.unshiftObject index

    true

  undoLastMark: ->
    step = @get 'step'
    moveStack = @get 'moveStack'
    squares = @get 'squares'

    return unless step?

    lastMove = moveStack.shiftObject(step)
    
    @set 'lastMove', lastMove
    
    squares.objectAt(lastMove).set('content', Square.blank)

  winningMove: Em.computed 'squares.@each.content', ->
    possibleSquares = @get 'possibleSquares'
    move = null

    # iterate until we have a winning move
    for index in possibleSquares
      break if move?
      @markSquare index, Square.computer
      move = index if @get('computerWins')
      @undoLastMark()

    return move

  blockingMove: Em.computed 'squares.@each.content', ->
    possibleSquares = @get 'possibleSquares'
    move = null

    for index in possibleSquares
      break if move?
      @markSquare index, Square.human
      move = index if @get('humanWins')
      @undoLastMark()

    return move

  nextAvailableCorner: Em.computed 'squares.@each.content', ->
    for index in Board.corners
      return index if @get('squares').objectAt(index).get('isBlank')

    return null

_getPossibleWinSquares = (type) ->
  possibleSquares = @get 'possibleSquares'
  possibleWinSquares = []

  for move in possibleSquares
    @markSquare move, type
    if type is Square.computer
      possibleWinSquares.push(move) if @get('computerWins')
    else
      possibleWinSquares.push(move) if @get('humanWins')
    @undoLastMark()
  
  possibleWinSquares

Board.reopenClass
  center: 4
  corners: [0, 2, 6, 8]
  edges: [1, 3, 5, 7]

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

    farthest[edge]

  oppositeCorner: (corner) ->
    opps =
      0: 8
      8: 0
      2: 6
      6: 2

    opps[corner]

`export default Board`
