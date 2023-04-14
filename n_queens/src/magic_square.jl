using LinearAlgebra
using Random
using ProgressBars
using Statistics
using Plots
using Match
using StatsBase

# Fix seed 
seed::Int64 = 42
Random.seed!(seed)


diags_vector(A::Matrix{Int64})::Matrix{Int64} = [diag(A) reverse(A, dims=2) |> diag]
⊛(x::Int64, params::Tuple{Float64,Int64})::Int64 = (rand() < params[1]) ? x : rand(setdiff(1:params[2], x))

function fitness(x::Vector{Int64}, n::Int64)::Float64
    square = reshape(x, (n, n))
    sum_line = sum(square, dims=1)
    sum_column = sum(square, dims=2)
    sum_diagonal = sum(diags_vector(square), dims=1)
    return 1 / length(unique([sum_line..., sum_column..., sum_diagonal...]))
end

function evaluate_fitness(population::Matrix{Int64})::Vector{Float64}
    return mapslices(x -> fitness(x, Int(size(x)[1]^0.5)), population, dims=2) |> vec
end

function randpop(popsize::Int64, n::Int64, max_value::Int64)::Matrix{Int64}
    return rand(1:max_value, (popsize, n^2))
end

function roulette(popsize::Int64, n_parents::Int64, population::Matrix{Int64})::Vector{Int64}
    evaluations = evaluate_fitness(population)
    evaluations = evaluations ./ sum(evaluations)
    return sample(1:popsize, Weights(vec(evaluations)), n_parents)
end
function select(popsize::Int64, n_parents::Int64, population::Matrix{Int64}; method::String="random")::Vector{Int64}
    @match method begin
        "random" => randperm(popsize)[1:n_parents]
        "roulette" => roulette(popsize, n_parents, population)
        _ => randperm(popsize)[1:n_parents]
    end
end

function make_mates(population::Matrix{Int64}, n_parents::Int64, n_mates::Int64; method::String="random")::Tuple
    mates::Tuple = ()
    for _ in 1:n_mates
        indices::Vector{Int64} = select(size(population)[1], n_parents, population; method=method)
        mates = (mates..., (population[indices[1], :], population[indices[2], :]))
    end
    return mates
end

function crossover(parents::Matrix{Int64})::Vector{Int64}

    return [rand([square_1, square_2]) for (square_1, square_2) in zip(parents[1, :], parents[2, :])]
end

function mutation(child::Vector{Int64}, max_value::Int64, n_2::Int64)::Vector{Int64}
    probability::Float64 = 1 / n_2
    return [square ⊛ (probability, max_value) for square in child]
end

function survival(n_survivors::Int64, population::Matrix{Int64})::Matrix{Int64}
    evaluations = mapslices(x -> fitness(x, Int(size(x)[1]^0.5)), population, dims=2)
    indices_tries = sortperm(vec(evaluations), rev=true)
    return population[indices_tries[1:n_survivors], :]
end

function eliminate_duplicates(population::Matrix{Int64})::Matrix{Int}
    return unique(population, dims=1)
end

function average_fitness(population::Matrix{Int64})
    return mean(evaluate_fitness(population))
end

function maximum_fitness(population::Matrix{Int64})
    return maximum(evaluate_fitness(population))
end
function minimum_fitness(population::Matrix{Int64})
    return minimum(evaluate_fitness(population))
end
function plot_evolution(max_fitness::Vector, min_fitness::Vector, avg_fitness::Vector)
    plot(1:length(max_fitness), max_fitness, label="max fitness", xlabel="generation", ylabel="fitness", title="Evolution of the fitness")
    plot!(1:length(min_fitness), min_fitness, label="min fitness")
    plot!(1:length(avg_fitness), avg_fitness, label="avg fitness")
end

function main(debug::Bool=false)
    n::Int64 = 3
    pop_size::Int64 = 1000
    n_gen = 100
    n_parents = 2
    n_mates = 1000
    max_fitness = []
    min_fitness = []
    avg_fitness = []
    best_value = []
    selection_method = "roulette"
    iter = tqdm(1:n_gen)
    max_value = 9
    for i in iter
        population::Matrix{Int64} = randpop(pop_size, n, max_value)
        mates::Tuple = make_mates(population, n_parents, n_mates; method=selection_method)
        children = [crossover(Matrix(hcat(mates[i]...)')) |> x -> mutation(x, max_value, n^2) for i in 1:n_mates] |>
                   x -> Matrix(hcat(x...)') |>
                        x -> eliminate_duplicates(x)
        # display(children)
        population = [population; children] |> x -> survival(pop_size, x)
        max_fitness = [max_fitness; maximum_fitness(population)]
        min_fitness = [min_fitness; minimum_fitness(population)]
        avg_fitness = [avg_fitness; average_fitness(population)]
        best_value =
            evaluate_fitness(population) |>
            x -> sortperm(vec(x), rev=true) |>
                 x -> population[x[1], :]

        set_description(iter, "max fitness: $(max_fitness[end])")
        if max_fitness[end] == 1
            break
        end
    end
    display(best_value |> x -> reshape(x, (n, n)))
    plot_evolution(max_fitness, min_fitness, avg_fitness)
end

main()
