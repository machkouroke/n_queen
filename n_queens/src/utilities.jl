using Match
using StatsBase
using Statistics
using Random

include("./Queen.jl")
include("Chromosome.jl")



function generate_solution(n::Int)::Chromosome
    return [Queen(i, j) for (i, j) in enumerate(randperm(n))] |> Chromosome
end

function randpop(popsize::Int64, n::Int64)::Vector{Chromosome}
    return [generate_solution(n) for _ in 1:popsize]
end

function roulette(popsize::Int64, n_parents::Int64, population::Vector{Chromosome})::Vector{Int64}
    evaluations::Vector{Float64} = [fitness(x) for x in population]
    evaluations = evaluations ./ sum(evaluations)
    return sample(1:popsize, Weights(vec(evaluations)), n_parents)
end
function select(popsize::Int64, n_parents::Int64, population::Vector{Chromosome}; method::String="random")::Vector{Int64}
    @match method begin
        "random" => randperm(popsize)[1:n_parents]
        "roulette" => roulette(popsize, n_parents, population)
        _ => randperm(popsize)[1:n_parents]
    end
end

function make_mates(population::Vector{Chromosome}, n_parents::Int64, n_mates::Int64; method::String="random")::Tuple
    mates::Tuple = ()
    for _ in 1:n_mates
        indices::Vector{Int64} = select(size(population)[1], n_parents, population; method=method)
        mates = (mates..., (population[indices[1]], population[indices[2]]))
    end
    return mates
end

function crossover(parents::Vector{Chromosome})::Chromosome
    genes_limit::Vector{Int64} = [rand(1:length(parents[1])) for _ in 1:2] |> sort
    child::Chromosome = Chromosome([Queen(i, 0) for i in 1:length(parents[1])])
    child[genes_limit[1]:genes_limit[2]] = parents[1][genes_limit[1]:genes_limit[2]]
    other_queen::Vector{Queen} = [queen for queen in parents[2] if queen.y ∉ getproperty.(child, :y)]
    for index in setdiff(1:length(child), genes_limit[1]:genes_limit[2])
        child[index] = Queen(index, other_queen[1].y)
        other_queen = other_queen[2:end]
    end
    return child
end

function mutation(child::Chromosome, n::Int64)::Chromosome
    mutated_child::Chromosome = deepcopy(child)
    probability::Float64 = 0.8
    for i in 1:2
        if (rand()) < probability
            swap_index::Int64 = rand(setdiff(1:n, i))
            mutated_child[i], mutated_child[swap_index] = Queen(i, mutated_child[swap_index].y), Queen(swap_index, mutated_child[i].y)
        end
    end

    return mutated_child
end

function survival(n_survivors::Int64, population::Vector{Chromosome})::Vector{Chromosome}
    evaluations::Vector{Float64} = [fitness(x) for x in population]
    indices_tries = sortperm(vec(evaluations), rev=true)
    return population[indices_tries[1:n_survivors]]
end



function eliminate_duplicates(population::Vector{Chromosome})::Vector{Chromosome}
    return unique(population)
end

function aggregate_fitness(population::Vector{Chromosome}; method=mean)::Float64
    if method == mean
        return mean([fitness(x) for x in population])
    end
    return method([fitness(x) for x in population]...)
end







