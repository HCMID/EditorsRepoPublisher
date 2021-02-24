
"Construct path to file for publication of edition."
function editionfile(csvrow, basedir)
    urn = CtsUrn(csvrow.urn)
    parts = workparts(urn)
    editiondir = basedir * "/" * string(parts[1], "_", parts[2])
    if !isdir(editiondir)
        try 
            mkdir(editiondir)
        catch e
            println("Failed to make directory ", editiondir)
        end
    end
    editiondir * "/index.md"
end