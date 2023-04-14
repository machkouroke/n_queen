struct NqueenSolver
    n::Int
    pop_size::Int64
    n_gen::Int64
    n_parents::Int64
    n_mates::Int64
    selection_method::String
    function NqueenSolver(; n::Int, pop_size::Int64, n_gen::Int64, n_mates::Int64, selection_method::String, n_parents::Int64=2)
        new(n, pop_size, n_gen, n_parents, n_mates, selection_method)
    end
end


function Base.show(io::IO, solver::NqueenSolver)
    println(io, "NqueenSolver:")
    println(io, "n: ", solver.n)
    println(io, "pop_size: ", solver.pop_size)
    println(io, "n_gen: ", solver.n_gen)
    println(io, "n_mates: ", solver.n_mates)
    println(io, "selection_method: ", solver.selection_method)
end

function solve(solver::NqueenSolver)
    max_fitness::Vector{Float64} = []
    min_fitness::Vector{Float64} = []
    avg_fitness::Vector{Float64} = []
    best_value::Chromosome = Chromosome([])
    iter = tqdm(1:solver.n_gen)
    for i in iter
        population::Vector{Chromosome} = randpop(solver.pop_size, solver.n)
        mates::Tuple = make_mates(population, solver.n_parents, solver.n_mates; method=solver.selection_method)
        children::Vector{Chromosome} = [crossover([mates[i][1];mates[i][2]]) |> x -> mutation(x, solver.n) for i in 1:solver.n_mates] |> x -> eliminate_duplicates(x)

        new_population::Vector{Chromosome} = [population; children] |> x -> survival(solver.pop_size, x)
        max_fitness = [max_fitness; aggregate_fitness(new_population; method=max)]
        min_fitness = [min_fitness; aggregate_fitness(new_population; method=min)]
        avg_fitness = [avg_fitness; aggregate_fitness(new_population; method=mean)]
        best_value = [fitness(x) for x in new_population] |> x -> sortperm(vec(x), rev=true) |> x -> new_population[x[1]]

        set_description(iter, "max fitness: $(max_fitness[end]) children_saved: $(size(children)[1])")
        if max_fitness[end] == 1
            break
        end
    end
    return max_fitness, min_fitness, avg_fitness, best_value
end