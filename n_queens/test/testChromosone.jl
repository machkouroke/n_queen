using Test
include("../src/Chromosone.jl")

@testset "fitness" begin
    @testset "Incorrect solution" begin
        @test fitness(Chromosone([Queen(1, 2), Queen(2, 3)])) == 0.5
        @test fitness(Chromosone([Queen(1, 1), Queen(1, 1), Queen(1, 2)])) == 0.1
        @test fitness(Chromosone([Queen(1, 2), Queen(2, 3), Queen(3, 4)])) == 1 / 6
        @test fitness(Chromosone([Queen(1, 2), Queen(2, 3), Queen(3, 4), Queen(4, 3)])) == 1 / 10
        # Un cas plus complexe dans une grille 8 x 8
        @test fitness(Chromosone([Queen(1, 2), Queen(2, 3), Queen(3, 4), Queen(4, 5), Queen(5, 6), Queen(6, 7), Queen(7, 8), Queen(7, 4)])) == 1 / 48
    end

    @testset "Correct solution" begin
        @test fitness(Chromosone([Queen(1, 4), Queen(2, 7), Queen(3, 3), Queen(4, 8), Queen(5, 2), Queen(6, 5), Queen(7, 1), Queen(8, 6)])) == 1
        @test fitness(Chromosone([Queen(1, 5), Queen(2, 2), Queen(3, 4), Queen(4, 7), Queen(5, 3), Queen(6, 8), Queen(7, 6), Queen(8, 1)])) == 1
        @test fitness(Chromosone([Queen(1, 7), Queen(2, 1), Queen(3, 3), Queen(4, 8), Queen(5, 6), Queen(6, 4), Queen(7, 2), Queen(8, 5)])) == 1

    end
    
end

"Done"