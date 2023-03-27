#let todo_counter = counter("todos")

#let todo(inline: false, fill: orange, note: "", numbering: none, content) = {
    let count_display = if numbering != none { todo_counter.display(numbering) }
    if inline {
        assert(note.len() == 0, message: "inline notes cannot have separate note text")
        [#box(rect(width:100%, fill:fill, radius:4pt, stroke:1pt, [#count_display #content])) <todos>]
    } else {
        [#box(rect(fill:fill, radius:4pt, stroke:1pt, [#count_display #note])) <todos> #content]
    }
    todo_counter.step()
}

#let missing_figure(content, fill: gray, stroke: none) = {
    rect(width: 100%, fill: fill, stroke: stroke, [*Missing Figure*: #content])
}

#let list_of_todos(title: "List of Todos", outlined: true, numbers: none) = {
    heading(title, numbering: none, outlined: outlined)

    locate(loc => {
        let todos = query(<todos>, loc)

        for todo in todos {
            let location = todo.location()
            let todo_counter = todo_counter.at(location)
            let counter_display = if numbers != none { numbering(numbers, ..todo_counter) }
            let page = counter(page).at(todo.location())
            let body = todo.body.body.children.last()
            let body_func = body.func()
            let text_slug = if body_func == text {
                let text = body.at("text")
                text.slice(0,calc.min(90,text.len()))
            } else {
                // need some sort of content to string
                "Unsupported content type, found " + [#repr(body_func)]
            }
            [
                #link(todo.location())[
                    #box(width: 1em, height:1em, fill: todo.body.fill, stroke: todo.body.stroke)
                    #counter_display #text_slug
                ]
                #box(width: 1fr, repeat[.])
                #link(todo.location(), [
                    #numbering("1", ..page)
                ]) \
            ]
        }
    })
}
