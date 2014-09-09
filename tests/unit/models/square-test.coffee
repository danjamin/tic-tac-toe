`import { test } from 'ember-qunit'`
`import Square from 'tic-tac-toe/models/square'`

test 'Square - sanity check', ->
  equal Square.computer, 'computer', 'computer const is correct'

test 'Square - set content', ->
  s = Square.create()
  ok s.get('isBlank'), 'is blank by default'
  s.set('content', Square.computer)
  ok not s.get('isBlank'), 'no longer blank'
  ok not s.get('isHuman'), 'not human either'
  ok s.get('isComputer'), 'is computer'
