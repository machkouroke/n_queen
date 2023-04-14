struct Queen
    x::Int
    y::Int
end

function Base.show(io::IO, q::Queen)::Nothing
    print(io, "Queen($(q.x), $(q.y))")
end

function Base.:(==)(q1::Queen, q2::Queen)::Bool
    q1.x == q2.x && q1.y == q2.y
end

function Base.:(==)(q1::Queen, q2::Tuple{Int,Int})::Bool
    q1.x == q2[1] && q1.y == q2[2]
end

function same_line(q1::Queen, q2::Queen)::Bool
    return q1.x == q2.x
end
function same_line(q1::Queen, queens::Vector{Queen})::Int
    return sum(same_line(q1, q2) for q2 in queens)
end

function Base.transpose(queen::Queen)::Queen
    return queen
end

function Base.adjoint(queen::Queen)::Queen
    return queen
end

function same_column(q1::Queen, q2::Queen)
    return q1.y == q2.y
end

function same_column(q1::Queen, queens::Vector{Queen})::Int
    return sum(same_column(q1, q2) for q2 in queens)
end

function same_diagonal(q1::Queen, q2::Queen)
    return abs(q1.x - q2.x) == abs(q1.y - q2.y) || (q1.x - q2.x) == (q2.y - q1.y)
end

function same_diagonal(q1::Queen, queens::Vector{Queen})::Int
    return sum(same_diagonal(q1, q2) for q2 in queens)
end