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

function publishableContent(publisher, urn)
    # Read configuration and generate editions:
    xml = textforurn(publisher.repo, urn)
    converter = o2converter(publisher.repo, urn)
    dipl = diplomaticnodes(publisher.repo,urn)
    normed = normalizednodes(publisher.repo,urn)
 
    (dipl, normed)         
end
     

function publishContinuous(publisher, urn, textdir, imgwidth = 100)
    publishable = EditorsRepo.online(publisher.repo, "catalog.cex")

    catalogrows = filter(row -> row.urn == urn.urn, publishable)
    if isempty(catalogrows)
        println("No catalog entry matching ", urn.urn)

    elseif length(catalogrows) > 1
        println("!!Multiple entries in catalog for ", urn.urn, "!!")

    else
        catalogentry = catalogrows[1]    
        dse = dse_df(publisher.repo)      
        dserows  = filter(row -> urncontains(urn, row.passage), dse)
        dipl, normed = publishableContent(publisher, urn)
        # Paste together the pieces of the markdown page:
        thumb = ""
        if nrow(dserows) > 0
            imgurn = dserows[1, :image]
            thumb = thumbnail(publisher, imgurn)
        end
        linkedimgs = []
        for row in eachrow(dserows)
            psg = passagecomponent(row.passage)
            link = string("[`", psg, "`](", publisher.ict, "urn=", row.image.urn, ")")
            push!(linkedimgs, link)
        end
        top = yamlplus(catalogentry)
        paras = paragraphmarkdown(dipl, normed, linkedimgs)
        document = join([top, thumb, paras], "\n\n")    
         # Write output to file:
         outfile = editionfile(catalogentry, textdir)
         println("Writing to ", outfile)
         open(outfile, "w") do io
             try 
                 print(io, document)
             catch e
                 groupurn = droppassage(dipl[1].urn)
                 println("FAILED in ", groupurn, " with ", length(dipl), " diplomatic lines and ", length(linkedimgs), " DSE records." )
             end
         end
    end
end

"Publish a text identified by URN in directory textdir."
function publishTables(publisher, urn, textdir, imgwidth=150)
    publishable = EditorsRepo.online(publisher.repo, "catalog.cex")

    catalogrows = filter(row -> row.urn == urn.urn, publishable)
    if isempty(catalogrows)
        println("No catalog entry matching ", urn.urn)

    elseif length(catalogrows) > 1
        println("!!Multiple entries in catalog for ", urn.urn, "!!")

    else
        catalogentry = catalogrows[1]    
        dse = dse_df(publisher.repo)      
        dserows  = filter(row -> urncontains(urn, row.passage), dse)
        dipl, normed = publishableContent(publisher, urn)

        # Paste together the pieces of the markdown page:
        linkedimgs = [] 
        if (length(dipl) != nrow(dserows))
            for row in eachrow(dserows)
                push!(linkedimgs, "Invalid indexing of text to source images.")
            end
        else 
            for row in eachrow(dserows)
            push!(linkedimgs, linkedMarkdownImage(publisher.ict, 
            row.image, publisher.iiifsvc, imgwidth, "image"))
            end
        end

        thumb = ""
        if nrow(dserows) > 0
            imgurn = dserows[1, :image]
            thumb = thumbnail(publisher, imgurn)
        end
        top = yamlplus(catalogentry)
        tables = tablemarkdown(dipl, normed, linkedimgs)
        document = join([top, thumb, tables], "\n\n")    
        
        # 5. Write output to file:
        outfile = editionfile(catalogentry, textdir)
        println("Writing to ", outfile)
        open(outfile, "w") do io
            try 
                print(io, document)
            catch e
                groupurn = droppassage(dipl[1].urn)
                println("FAILED in ", groupurn, " with ", length(dipl), " diplomatic lines and ", length(linkedimgs), " DSE records." )
            end
        end
    end
end