
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
        "\n\n",
        string("`", csvrow.urn, "`"),
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



# Compose tabular display of editions
# from lists of citable nodes
function tablemarkdown(dipllist, normlist, linkedimages)
   
    diplitems = map(cn -> "| `" * passagecomponent(cn.urn) * "` | " * cn.text * " |", dipllist)
    illustrateddipl = []
    for i in 1:length(diplitems)
        push!(illustrateddipl, diplitems[i] *  linkedimages[i] * " |")
    end
    dipltable = [
        "|  | Diplomatic text | Image link |",
        "| :---: | :------  | --- |",
      
        join(illustrateddipl, "\n")
    ]

    normitems = map(cn -> "| `" * passagecomponent(cn.urn) * "` | " * cn.text * " |", normlist)
    normtable = [
        "|  | Normalized text  |",
        "| :---: | :------ |",
        join(normitems, "\n")
    ]

    blocks = [
        "## Diplomatic edition",
        join(dipltable,"\n"),
        "## Normalized edition",
        join(normtable,"\n"),
    ]
    join(blocks, "\n\n")
end



function paragraphmarkdown(dipllist, normlist, links)
    
    diplitems = []

    for n in eachindex(dipllist)
        push!(diplitems, string(links[n], " ", dipllist[n].text))
    end
    #diplitems = map(cn -> "`(" * passagecomponent(cn.urn) * ")` " * cn.text, dipllist)
    
    normitems = map(cn -> "`(" * passagecomponent(cn.urn) * ")` " * cn.text, normlist)

    blocks = [
        "## Diplomatic edition",
        join(diplitems," "),
        "## Normalized edition",
        join(normitems," "),
    ]
    join(blocks, "\n\n")
   
end