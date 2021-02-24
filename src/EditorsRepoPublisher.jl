module EditorsRepoPublisher

using CitableText, CitableObject, CitableImage, EditorsRepo
using CSV, DataFrames

export Publisher
export publisher, publishTables, publishContinuous

include("publisher.jl")
include("iiifsvc.jl")
include("files.jl")
include("markdown.jl")

end # module
