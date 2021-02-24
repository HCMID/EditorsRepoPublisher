module EditorsRepoPublisher

using CitableText, CitableObject, CitableImage, EditorsRepo
using CSV, DataFrames

export Publisher
export publisher, publish

include("publisher.jl")
include("iiifsvc.jl")
include("files.jl")
include("markdown.jl")

#=


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

end # module
