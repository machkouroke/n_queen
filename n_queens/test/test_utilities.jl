using Test

# include("../src/utilities.jl")
function distinct(x::Vector{Int64})
    return length(unique(x)) == length(x)
end
@testset "generate_solution" begin
    @testset "n = 8" begin
        n::Int64 = 8
        chromosome = generate_solution(n)
        @test length(chromosome) == n
        @test distinct([queen.x for queen in chromosome])
        @test distinct([queen.y for queen in chromosome])
        @test all([queen.x == index && queen.y in 1:n for (index, queen) in enumerate(chromosome)])

    end
    @testset "n = 10" begin
        n::Int64 = 10
        chromosome = generate_solution(n)
        @test length(chromosome) == n
        @test distinct([queen.x for queen in chromosome])
        @test distinct([queen.y for queen in chromosome])
        @test all([queen.x == index && queen.y in 1:n for (index, queen) in enumerate(chromosome)])
    end
end

@testset "randpop" begin
    @testset "popsize = 10" begin
        popsize::Int64 = 10
        n::Int64 = 8
        population = randpop(popsize, n)
        @test size(population) == (popsize, )
    end
end

@testset "roulette" begin
    @testset "popsize = 10" begin
        popsize::Int64 = 10
        n::Int64 = 8
        n_parents::Int64 = 5
        population = randpop(popsize, n)
        @test size(roulette(popsize, n_parents, population)) == (n_parents,)
    end
end

@testset "select" begin
    @testset "popsize = 10" begin
        popsize::Int64 = 10
        n::Int64 = 8
        n_parents::Int64 = 5
        population = randpop(popsize, n)
        @test size(select(popsize, n_parents, population; method="random")) == (n_parents,)
        @test size(select(popsize, n_parents, population; method="roulette")) == (n_parents,)
    end
end

@testset "make_mates" begin
    @testset "popsize = 10" begin
        popsize::Int64 = 10
        n::Int64 = 8
        n_parents::Int64 = 5
        n_mates::Int64 = 3
        population = randpop(popsize, n)
        @testset "method = random" begin
            mates = make_mates(population, n_parents, n_mates; method="random")
            @test length(mates) == n_mates
            @test all([length(mate) == 2 for mate in mates])
        end
        @testset "method = roulette" begin
            mates = make_mates(population, n_parents, n_mates; method="roulette")
            @test length(mates) == n_mates
            @test all([length(mate) == 2 for mate in mates])
        end
    end
end

@testset "crossover" begin
    @testset "n = 8" begin
        n::Int64 = 8
        parents = randpop(2, n)
        child = crossover(parents)
        @test length(child) == n
        @test all([queen.x == index && queen.y in 1:n for (index, queen) in enumerate(child)])
        @test distinct([queen.x for queen in child])
        @test distinct([queen.y for queen in child])
    end
end

@testset "mutation" begin
    @testset "n = 8" begin
        n::Int64 = 8
        child = randpop(1, n)[1]
        mutated_child = mutation(child, n)
        @show mutated_child
        @show child
        @test length(mutated_child) == n
        @test distinct([queen.x for queen in child])
        @test distinct([queen.y for queen in child])
    end
end

# @testset "eliminate_duplicates" begin
#     @testset "n = 8" begin
#         n::Int64 = 8
#         population = [
#             Queen(1, 1) Queen(2, 2) Queen(3, 3) Queen(4, 4) Queen(5, 5) Queen(6, 6) Queen(7, 7) Queen(8, 8)
#             Queen(1, 1) Queen(2, 2) Queen(3, 3) Queen(4, 4) Queen(5, 5) Queen(6, 6) Queen(7, 7) Queen(8, 8)
#             Queen(1, 1) Queen(2, 2) Queen(3, 3) Queen(4, 4) Queen(5, 7) Queen(6, 6) Queen(7, 5) Queen(8, 8)
#         ]
#         @test size(eliminate_duplicates(population)) == (2, n)
#     end
# end

# @testset "survival" begin
#     @testset "n = 8" begin
#         n::Int64 = 8
#         n_survivors::Int64 = 2
#         # Generate different population with higth fitness at top
#         population = randpop(10, n)
#         @test size(survival(n_survivors, population)) == (n_survivors, n)
#     end
# end

"Done"