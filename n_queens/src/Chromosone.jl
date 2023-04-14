include("./Queen.jl")
struct Chromosone
    queens::Vector{Queen}
end

function pop(vector::Vector{T}, element::T) where {T<:Any}
    copy_vector = deepcopy(vector)
    index = findfirst(==(element), vector)
    if index !== nothing
        deleteat!(copy_vector, index)
    end
    return copy_vector
end

function fitness(x::Chromosone)::Float64
    result =  sum(
        same_line(queen, pop(x.queens, queen))
        + same_column(queen, pop(x.queens, queen))
        + same_diagonal(queen, pop(x.queens, queen))
        for queen in x.queens
    )
    return result == 0 ? 1 : 1 / result
end
