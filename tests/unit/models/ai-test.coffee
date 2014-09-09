`import { test } from 'ember-qunit'`
`import AI from 'tic-tac-toe/models/ai'`
`import Board from 'tic-tac-toe/models/board'`
`import Square from 'tic-tac-toe/models/square'`

test 'AI - sanity check', ->
  equal typeof AI.nextMove, 'function', 'nextMove is a function'

test 'AI - first move works', ->
  b = Board.create()
  equal AI.nextMove(b), Board.center, 'first move is center'

test 'AI - last move works', ->
  b = Board.create()

  # o | x | o
  # ----------
  # x | o | x
  # ----------
  # x | o |
  b.markSquare(0, Square.computer)
  b.markSquare(1, Square.human)
  b.markSquare(2, Square.computer)

  b.markSquare(3, Square.human)
  b.markSquare(4, Square.computer)
  b.markSquare(5, Square.human)

  b.markSquare(6, Square.human)
  b.markSquare(7, Square.computer)

  deepEqual b.get('possibleSquares'), [8], 'only one possible square'
  equal AI.nextMove(b), 8, 'last move is last space'

test 'AI - take obvious win', ->
  b = Board.create()

  # o | x | o
  # ----------
  # x |   | x
  # ----------
  # o |   |
  b.markSquare(0, Square.computer)
  b.markSquare(1, Square.human)
  b.markSquare(2, Square.computer)

  b.markSquare(3, Square.human)
  b.markSquare(5, Square.human)

  b.markSquare(6, Square.computer)

  deepEqual b.get('possibleSquares'), [4, 7, 8], 'check possible squares'
  equal AI.nextMove(b), 4, 'took obvious win'

test 'AI - block loss', ->
  b = Board.create()

  #   |   |
  # ----------
  #   | x | x
  # ----------
  #   |   | o
  b.markSquare(4, Square.human)
  b.markSquare(5, Square.human)

  b.markSquare(8, Square.computer)

  deepEqual b.get('possibleSquares'), [[0..3]..., 6, 7], 'check possible squares'
  equal AI.nextMove(b), 3, 'blocked obvious loss'

test 'AI - block loss on 0', ->
  b = Board.create()

  #   |   |
  # ----------
  # x | o |
  # ----------
  # x |   |
  b.markSquare(3, Square.human)
  b.markSquare(4, Square.computer)

  b.markSquare(6, Square.human)

  deepEqual b.get('possibleSquares'), [[0..2]..., 5, 7, 8], 'check possible squares'
  equal AI.nextMove(b), 0, 'blocked loss'

test 'AI - block potential loss 1', ->
  b = Board.create()

  # o |   |
  # ----------
  #   | x |
  # ----------
  #   |   | x
  b.markSquare(0, Square.computer)

  b.markSquare(4, Square.human)

  b.markSquare(8, Square.human)

  deepEqual b.get('possibleSquares'), [[1..3]..., [5..7]...], 'check possible squares'
  equal AI.nextMove(b), 2, 'blocked potential loss'

test 'AI - block potential loss 2', ->
  b = Board.create()

  # x |   |
  # ----------
  #   | o |
  # ----------
  #   | x |
  b.markSquare(0, Square.human)

  b.markSquare(4, Square.computer)

  b.markSquare(7, Square.human)

  deepEqual b.get('possibleSquares'), [[1..3]..., 5, 6, 8], 'check possible squares'
  equal AI.nextMove(b), 3, 'blocked potential loss'

test 'AI - block potential loss 3', ->
  b = Board.create()

  # x |   |
  # ----------
  #   | o |
  # ----------
  #   |   | x
  b.markSquare(0, Square.human)

  b.markSquare(4, Square.computer)

  b.markSquare(8, Square.human)

  deepEqual b.get('possibleSquares'), [[1..3]..., [5..7]...], 'check possible squares'
  equal AI.nextMove(b), 1, 'blocked potential loss'
