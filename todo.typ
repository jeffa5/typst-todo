#let todo(inline: false, fill: orange, note: "", content) = {
    if inline {
        assert(note.len() == 0, message: "inline notes cannot have separate note text")
        [#box(rect(width:100%, fill:fill, radius:4pt, stroke:1pt, content)) <todos>]
    } else {
        [#box(rect(fill:fill, radius:4pt, stroke:1pt, note)) <todos> #content]
    }
}

#let itodo = todo.with(inline:true)

#let missing_figure(content, fill: gray, stroke: none) = {
    rect(width: 100%, fill: fill, stroke: stroke, [*Missing Figure*: #content])
}

#let list_of_todos(title: "List of Todos", outlined: true) = {
    heading(title, outlined: outlined)

    locate(loc => {
        let todos = query(<todos>, loc)

        for todo in todos {
            let location = todo.location()
            let page = counter(page).at(todo.location())
            let body_func = todo.body.body.func()
            let text_slug = if body_func == text {
                let text = todo.body.body.at("text")
                text.slice(0,calc.min(90,text.len()))
            } else {
                // need some sort of content to string
                "Unsupported content type"
            }
            [
                #link(todo.location())[
                    #box(width: 1em, height:1em, fill: todo.body.fill, stroke: todo.body.stroke)
                    #text_slug
                ]
                #box(width: 1fr, repeat[.])
                #link(todo.location(), [
                    #numbering("1", ..page)
                ]) \
            ]
        }
    })
}
