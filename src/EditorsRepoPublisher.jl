module EditorsRepoPublisher

using EditorsRepo
using CSV

export publish


function publish(catalogrow::CSV.Row, textroot)

end

"""Publish all online texts in repository.
"""
function publish(repo::EditingRepository, textroot::AbstractString)
    publishable = EditorsRepo.online(repo, "catalog.cex")
    for txt in publishable
        publish(txt, textroot)
    end
end

end # module
