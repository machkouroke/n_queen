using Match
using StatsBase
using Statistics
using Random

include("./Queen.jl")
include("Chromosone.jl")



⊛(x::Int64, params::Tuple{Float64,Int64})::Int64 = (rand() < params[1]) ? x : rand(setdiff(1:params[2], x))
function generate_solution(n::Int)::Vector{Queen}
    return [Queen(i, j) for (i, j) in enumerate(randperm(n))]
end

function randpop(popsize::Int64, n::Int64)::Matrix{Queen}
    return hcat([generate_solution(n) for _ in 1:popsize]...) |> transpose |> Matrix
end

function roulette(popsize::Int64, n_parents::Int64, population::Matrix{Queen})::Vector{Int64}
    evaluations = mapslices(x -> x |> Chromosone |> fitness, population, dims=2)
    evaluations = evaluations ./ sum(evaluations)
    return sample(1:popsize, Weights(vec(evaluations)), n_parents)
end
function select(popsize::Int64, n_parents::Int64, population::Matrix{Queen}; method::String="random")::Vector{Int64}
    @match method begin
        "random" => randperm(popsize)[1:n_parents]
        "roulette" => roulette(popsize, n_parents, population)
        _ => randperm(popsize)[1:n_parents]
    end
end

function make_mates(population::Matrix{Queen}, n_parents::Int64, n_mates::Int64; method::String="random")::Tuple
    mates::Tuple = ()
    for _ in 1:n_mates
        indices::Vector{Int64} = select(size(population)[1], n_parents, population; method=method)
        mates = (mates..., (population[indices[1], :], population[indices[2], :]))
    end
    return mates
end

function crossover(parents::Matrix{Queen})::Vector{Queen}

    return [Queen(queen_1.x, rand([queen_1.y, queen_2.y])) for (queen_1, queen_2) in zip(parents[1, :], parents[2, :])]
end

function mutation(child::Vector{Queen}, n::Int64)::Vector{Queen}
    probability::Float64 = 1 / n
    return [Queen(queen.x, queen.y ⊛ (probability, n)) for queen in child]
end

function survival(n_survivors::Int64, population::Matrix{Queen})::Matrix{Queen}
    evaluations = mapslices(x -> x |> Chromosone |> fitness, population, dims=2)
    indices_tries = sortperm(vec(evaluations), rev=true)
    return population[indices_tries[1:n_survivors], :]
end


function eliminate_duplicates(population::Matrix{Queen})::Matrix{Queen}
    return unique(population, dims=1)
end

function average_fitness(population::Matrix{Queen})
    return mean(mapslices(x -> x |> Chromosone |> fitness, population, dims=2))
end

function maximum_fitness(population::Matrix{Queen})
    return maximum(mapslices(x -> x |> Chromosone |> fitness, population, dims=2))
end
function minimum_fitness(population::Matrix{Queen})
    return minimum(mapslices(x -> x |> Chromosone |> fitness, population, dims=2))
end



