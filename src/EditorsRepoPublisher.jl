module EditorsRepoPublisher

using CitableText, CitableObject, CitableImage, EditorsRepo
using CSV, DataFrames

export Publisher
export publisher, publish

include("publisher.jl")
include("iiifsvc.jl")

#=
function editionfile(csvrow, basedir)
    urn = CtsUrn(csvrow.urn)
    parts = workparts(urn)
    editiondir = basedir * "/" * string(parts[1], "_", parts[2])
    if !isdir(editiondir)
        mkdir(editiondir)
    end
    editiondir * "/index.md"
end

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

function shorttitle(csvrow)
    string("\"", csvrow.groupName, ", ", csvrow.workTitle, "\"")
end
function mdtitle(csvrow)
    string("*", csvrow.groupName, "*, ", csvrow.workTitle)
end

function publish(
    repo,
    catalogrow::CSV.Row, 
    textroot, dse,
    iiifsvc, ict)
    fname = editionfile(catalogrow, textroot)
    top = yamlplus(catalogrow)
    urnlabel = string("`", catalogrow.urn, "`\n\n")
    urn = CtsUrn(catalogrow.urn)
    rowmatches  = filter(row -> urncontains(urn, row.passage), dse)
    thumb = ""
    if nrow(rowmatches) > 0
        imgurn = rowmatches[1, :image]
        thumburn = CitableObject.dropsubref(imgurn)
        thumb = "\n\nAll images are linked to pannable/zoomable versions\n\n" * linkedMarkdownImage(ict,thumburn, iiifsvc, 200, "thumb") * "\n\n"
    end
    xml = textforurn(repo, urn)
    converter = o2converter(repo, urn)
    dipl = diplomaticnodes(repo,urn)
    normed = normalizednodes(repo,urn)
    println(normed)
end
=#
#=
"""Publish all online texts in repository.
"""

function publish(
    repo::EditingRepository, 
    textroot::AbstractString,
    baseiifurl = "http://www.homermultitext.org/iipsrv",
    ict = "http://www.homermultitext.org/ict2/?",
    imgroot = "/project/homer/pyramidal/deepzoom"
    )
    publishable = EditorsRepo.online(repo, "catalog.cex")
    dse = dse_df(repo)  
    iiifsvc = IIIFservice(baseiifurl, imgroot)




    for txt in publishable
        publish(repo, txt, textroot, dse, iiifsvc, ict)
    end
end
=#
end # module
