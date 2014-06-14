class Square extends Em.Object
    content: null

    init: (content = Square.blank) ->
        @content = content

    isComputer: ~> @content is Square.computer
    isHuman:    ~> @content is Square.human
    isBlank:    ~> @content is Square.blank


Square.reopenClass
    computer:   'computer',
    human:      'human',
    blank:      'blank'

`export default Square`
