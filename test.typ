#heading([Typst Todo], outlined: false)


#set heading(numbering: "1.")

#outline(indent:true)

#import "todo.typ": todo, missing_figure, list_of_todos

#let itodo = todo.with(inline:true)

#list_of_todos()

== On some content

#todo[Add some content]

=== Todo with note text

#todo(note: [test])[some text that needs fixing]

== Inline

#todo(inline: true)[Add some content]

=== Using a shortcut, and with colour

#itodo(fill:blue)[an itodo]

=== But can't specify a note


```typst
#todo(inline: true, note: "test note")[broken] // error
```

=== A very long todo, only the first line is shown in the list_of_todos

#itodo[#lorem(50)]

#itodo[Something big is coming

#lorem(50)]

== Todo figures too

#missing_figure[my pretty graph]

#pagebreak()

#itodo[new page]

