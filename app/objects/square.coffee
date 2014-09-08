`import Em from 'ember'`

Square = Em.Object.extend
  content: null

  init: (content = Square.blank) ->
    @_super()
    @set 'content', content

  isComputer: Em.computed 'content', ->
    @get('content') is Square.computer
  
  isHuman: Em.computed 'content', ->
    @get('content') is Square.human
  
  isBlank: Em.computed 'content', ->
    @get('content') is Square.blank

Square.reopenClass
  computer: 'computer'
  human: 'human'
  blank: 'blank'

`export default Square`
