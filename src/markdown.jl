
function thumbnail(publisher, imgurn, width=200)
    thumburn = CitableObject.dropsubref(imgurn)
    thumb = string(
        "\n\n",
        "All images are linked to pannable/zoomable versions\n\n",
        linkedMarkdownImage(publisher.ict,
        thumburn, publisher.iiifsvc, width, "click to zoomable"),
        "\n\n"
    )
end

"Compose YAML header and title for page."
function yamlplus(csvrow)
    title = shorttitle(csvrow)
    titlehdr = mdtitle(csvrow)
    lines = [
        "---",
        "title: " * title,
        "layout: page",
        "parent: texts",
        "nav_order: " * csvrow.workTitle,
        "---",
        "\n\n",
        "# " * titlehdr,
        "\n\n"
    ]
    join(lines,"\n")
end

"""Compose short title suitable for use in YAML header.
(No markdown allowed.)
"""
function shorttitle(csvrow)
    string("\"", csvrow.groupName, ", ", csvrow.workTitle, "\"")
end


"Compose title formatted in markdown."
function mdtitle(csvrow)
    string("*", csvrow.groupName, "*, ", csvrow.workTitle)
end