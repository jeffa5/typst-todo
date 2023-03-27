#let todo_counter = counter("todos")

#let todo(content, inline: false, fill: orange, note: "", numbering: none, border_radius: 4pt, border_stroke: 1pt, inline_width:100%, line_stroke: orange + 0.1em) = {
    let count_display = if numbering != none { todo_counter.display(numbering) }
    if inline {
        assert(note.len() == 0, message: "inline notes cannot have separate note text")
        [#box(rect(width:inline_width, fill:fill, radius:border_radius, stroke:border_stroke, [#count_display #content])) <todos>]
    } else {
        [#box(rect(fill:fill, radius:border_radius, stroke:border_stroke, [#count_display #note])) <todos> #underline(stroke: line_stroke, evade:false, content)]
    }
    todo_counter.step()
}

#let missing_figure(content, width: 100%, fill: gray, stroke: none, prefix: [*Missing Figure*:]) = {
    rect(width: width, fill: fill, stroke: stroke, [#prefix #content])
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
