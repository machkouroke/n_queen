using ProgressBars
using Plots
using Random
# Fix seeds
Random.seed!(1245)
include("utilities.jl")
include("plotter.jl")
include("solver.jl")
function main(debug::Bool=false)
    n::Int64 = 15
    pop_size::Int64 = 500
    n_gen = 500
    n_parents = 2
    n_mates = 10
    selection_method = "roulette"
    solver = NqueenSolver(n=n, pop_size=pop_size, n_gen=n_gen, n_mates=n_mates, selection_method=selection_method, n_parents=n_parents)
    max_fitness, min_fitness, avg_fitness, best_value = solve(solver)
    board = plot_chromosome(best_value, n)
    evolution = plot_evolution(max_fitness, min_fitness, avg_fitness)
    p = plot(board, evolution, layout=(1, 2), size=(1000, 500))
    savefig(p, "n_queens.png")
    display(p)
end

main()