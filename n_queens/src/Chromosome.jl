include("./Queen.jl")

struct Chromosome
    queens::Vector{Queen}
end

function Base.getindex(chromosome::Chromosome, index::Int)::Queen
    return chromosome.queens[index]
end

function Base.getindex(chromosome::Chromosome, index::UnitRange{Int})::Vector{Queen}
    return chromosome.queens[index]
end

function Base.setindex!(chromosome::Chromosome, queen::Queen, index::Int)::Chromosome
    chromosome.queens[index] = queen
    return chromosome
end

function Base.setindex!(chromosome::Chromosome, queens::Vector{Queen}, index::UnitRange{Int})::Chromosome
    chromosome.queens[index] = queens
    return chromosome
end
function Base.in(queen::Queen, chromosome::Chromosome)::Bool
    return queen in chromosome.queens
end
function Base.length(chromosome::Chromosome)::Int
    return length(chromosome.queens)
end
function Base.iterate(chromosome::Chromosome, state::Int=1)
    if state > length(chromosome)
        return nothing
    end
    return chromosome.queens[state], state + 1
end

function Base.:(==)(chromosome_1::Chromosome, chromosome_2::Chromosome)::Bool
    return chromosome_1.queens == chromosome_2.queens
end

function pop(vector::Vector{T}, element::T) where {T<:Any}
    copy_vector = deepcopy(vector)
    index = findfirst(==(element), vector)
    if index !== nothing
        deleteat!(copy_vector, index)
    end
    return copy_vector
end

function fitness(x::Chromosome)::Float64
    result =  sum(
        same_line(queen, pop(x.queens, queen))
        + same_column(queen, pop(x.queens, queen))
        + same_diagonal(queen, pop(x.queens, queen))
        for queen in x.queens
    )
    return 1 / (1 + result)
end
