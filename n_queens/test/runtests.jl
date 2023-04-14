for file in ["test_utilities.jl", "testQueen.jl", "testChromosone.jl"]
    println("Running $file")
    include(file)
end