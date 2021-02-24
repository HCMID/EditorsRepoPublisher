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

"Publisher a text identified by URN."
function publish(publisher, urn)
    publishable = EditorsRepo.online(repo, "catalog.cex")
end