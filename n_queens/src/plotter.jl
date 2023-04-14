using Plots
include("Chromosome.jl")
function plot_chromosome(solution::Chromosome, n::Int64=8)::Plots.Plot
    board = zeros(n, n)
    for i in 1:n
        for j in 1:n
            if (i + j) % 2 == 0
                board[i, j] = 1
            end
        end
    end
    p = heatmap(board, aspect_ratio=:equal, legend=false, color=:blues, size=(400, 400))
    for queen in solution.queens
        # text!(queen.column, queen.row, queen, color=:black, halign=:center, valign=:middle, font=font(20))
        # text! is not defined used annotate! instead
        c = :white
        annotate!(queen.y, queen.x, '♛', color=c, halign=:center, valign=:middle, font=font(100))
    end
    return p
end


function plot_evolution(max_fitness::Vector, min_fitness::Vector, avg_fitness::Vector)::Plots.Plot
    p = plot(1:length(max_fitness), max_fitness, label="max fitness", xlabel="generation", ylabel="fitness", title="Evolution of the fitness")
    plot!(1:length(min_fitness), min_fitness, label="min fitness")
    plot!(1:length(avg_fitness), avg_fitness, label="avg fitness")
    return p
end



