using Test

include("../src/Queen.jl")

@testset "Base function" begin
    @testset "show" begin
        @test string(Queen(1, 2)) == "Queen(1, 2)"
    end
    @testset "==" begin
        @test Queen(1, 2) == (1, 2)
        @test Queen(1, 2) == Queen(1, 2)
        @test (Queen(1, 2) != Queen(2, 3))
    end
    @testset "same_line" begin
        @testset "single_value" begin
            @test same_line(Queen(1, 2), Queen(1, 3))
            @test !same_line(Queen(1, 2), Queen(2, 3))
        end
        @testset "set" begin
            @test same_line(Queen(1, 2), ([Queen(1, 3), Queen(1, 4)])) == 2
            @test same_line(Queen(1, 2), ([Queen(1, 3), Queen(2, 4)])) == 1
            @test same_line(Queen(1, 2), ([Queen(2, 3), Queen(2, 4)])) == 0
            @test same_line(Queen(1, 2), ([Queen(2, 3), Queen(3, 4)])) == 0
        end
    end
    @testset "same_column" begin
        @testset "single_value" begin
            @test same_column(Queen(1, 2), Queen(2, 2))
            @test !same_column(Queen(1, 2), Queen(2, 3))
        end
        @testset "set" begin
            @test same_column(Queen(1, 2), [Queen(2, 2), Queen(3, 2)]) == 2
            @test same_column(Queen(1, 2), [Queen(2, 2), Queen(3, 3)]) == 1
            @test same_column(Queen(1, 2), [Queen(2, 3), Queen(3, 4)]) == 0
            @test same_column(Queen(1, 2), [Queen(2, 3), Queen(3, 2)]) == 1
        end
    end

    @testset "same_diagonal" begin
        @testset "single_value" begin
            @test same_diagonal(Queen(1, 2), Queen(2, 3))
            @test same_diagonal(Queen(1, 2), Queen(2, 1))
            @test !same_diagonal(Queen(1, 2), Queen(2, 2))
            @test same_diagonal(Queen(4, 2), Queen(3, 3))
        end
        @testset "set" begin
            @test same_diagonal(Queen(1, 2), [Queen(2, 3), Queen(3, 4)]) == 2
            @test same_diagonal(Queen(1, 2), [Queen(2, 3), Queen(3, 3)]) == 1
            @test same_diagonal(Queen(1, 2), [Queen(2, 3), Queen(3, 2)]) == 1
        end
    end
end

"Done"