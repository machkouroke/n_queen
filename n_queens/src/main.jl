using ProgressBars
using Plots
using Random
# Fix seeds
Random.seed!(19)
include("utilities.jl")
include("plotter.jl")
function main(debug::Bool=false)
    n::Int64 = 8
    pop_size::Int64 = 100
    n_gen = 500
    n_parents = 2
    n_mates = 100
    max_fitness = []
    min_fitness = []
    avg_fitness = []
    best_value = []
    selection_method = "roulette"
    iter = tqdm(1:n_gen)
    for i in iter
        population::Matrix{Queen} = randpop(pop_size, n)
        mates::Tuple = make_mates(population, n_parents, n_mates; method=selection_method)
        children = [crossover(Matrix(hcat(mates[i]...)')) |> x -> mutation(x, n) for i in 1:n_mates] |>
                   x -> Matrix(hcat(x...)') |>
                        x -> eliminate_duplicates(x)

        population = [population; children] |> x -> survival(pop_size, x)
        max_fitness = [max_fitness; maximum_fitness(population)]
        min_fitness = [min_fitness; minimum_fitness(population)]
        avg_fitness = [avg_fitness; average_fitness(population)]
        best_value =
            mapslices(x -> x |> Chromosone |> fitness, population, dims=2) |>
            x -> sortperm(vec(x), rev=true) |>
                 x -> population[x[1], :]

        set_description(iter, "max fitness: $(max_fitness[end]) children_saved: $(size(children)[1])")
        if max_fitness[end] == 1
            break
        end
    end
    board = plot_chromosome(best_value' |> vec |> Chromosone, n)
    evolution = plot_evolution(max_fitness, min_fitness, avg_fitness)
    p = plot(board, evolution, layout=(1, 2), size=(2000, 1000))
    display(p)
end

main()