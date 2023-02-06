module TupleDicts

using Base

export TupleDict

struct TupleDict{TD <: Tuple, K, V} <: AbstractDict{K, V}
    dicts::TD
    function TupleDict{TD}(td::TD) where {TD}
        ks = (keytype(d) for d in td)
        vs = (eltype(values(d)) for d in td)
        K = Union{ks...}
        V = Union{vs...}

        return new{TD, K, V}(td)
    end
end
function TupleDict(td::TD) where {TD}
    return TupleDict{TD}(td)
end

function _find_dict(_d::TupleDict, ::T) where {T}
    d_idx = findfirst(d -> T <: keytype(d), _d.dicts)
    return _d.dicts[d_idx]
end

function Base.getindex(_d::TupleDict, k)
    d = _find_dict(_d, k)
    return Base.getindex(d, k)
end

function Base.setindex!(_d::TupleDict, v, k)
    d = _find_dict(_d, k)
    return Base.setindex!(d, v, k)
end

function Base.keys(td::TupleDict)
    mapreduce(keys, union, td.dicts)
end

function Base.values(td::TupleDict)
    mapreduce(values, union, td.dicts)
end


end # module TupleDict