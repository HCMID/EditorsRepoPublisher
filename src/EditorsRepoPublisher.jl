module EditorsRepoPublisher

using CitableText, CitableObject, CitableImage, EditorsRepo
using CSV, DataFrames

export Publisher
export publisher, publish

include("publisher.jl")
include("iiifsvc.jl")
include("files.jl")
include("markdown.jl")

end # module
