using EditorsRepoPublisher
using CitableText

repodir = "/Users/nsmith/Desktop/hmt-repos/criticalsigns"
publ = publisher(repodir)
textdir = "/Users/nsmith/Desktop/mid/EditorsRepoPublisher.jl/testtoday/"
urn = CtsUrn("urn:cts:hmt:aristonicus.signs.msA:")

#publishTables(publ, urn, textdir)

publishContinuous(publ, urn, textdir)