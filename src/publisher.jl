struct Publisher
    repo::EditingRepository
    ict
    iiifsvc::IIIFservice
end

function publisher(repo::EditingRepository)
    Publisher(repo, defaultICT, defaultIIIF())
end

function publisher(repodir::AbstractString)
    repo = EditingRepository(repodir, "editions", "dse", "config")
    publisher(repo)
end

"Publish a text identified by URN in directory textdir."
function publish(publisher, urn, textdir)
    publishable = EditorsRepo.online(publisher.repo, "catalog.cex")
    catalogrows = filter(row -> row.urn == urn.urn, publishable)
    if isempty(catalogrows)
        println("No catalog entry matchng ", urn.urn)
    elseif length(catalogrows) > 1
        println("Multiple entries in catalog for ", urn.urn, "!!")
    else
        dse = dse_df(publisher.repo)  
        row = catalogrows[1]
        outfile = editionfile(row, textdir)
        top = yamlplus(row)
        urnlabel = string("`", row.urn, "`\n\n")
        rowmatches  = filter(row -> urncontains(urn, row.passage), dse)
        thumb = ""
        if nrow(rowmatches) > 0
            imgurn = rowmatches[1, :image]
            thumb = thumbnail(publisher, imgurn)
        end
        thumb
    end
end