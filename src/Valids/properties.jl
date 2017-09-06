@generated function isulp{N,ES}(x::Vnum{N, ES})
  inc = increment(Vnum{N, ES})
  :( (@u(x) & $inc) != 0 )
end

@generated function Base.isempty{N,ES}(x::Valid{N,ES})
  inc = increment(Vnum{N,ES})
  quote
    ((x.lower == zero(Vnum{N,ES})) || (x.upper == zero(Vnum{N,ES}))) && (@u(x.lower) == @u(x.upper) + $inc)
  end
end

Base.isnan{N,ES}(x::Valid{N,ES}) = isempty(x)

@generated function isallreals{N,ES}(x::Valid{N,ES})
  inc = increment(Vnum{N,ES})
  quote
    (x.lower != zero(Vnum{N,ES})) && (x.upper != zero(Vnum{N,ES})) && (@u(x.lower) == @u(x.upper) + $inc)
  end
end

doc"""
    roundsinf(x::Valid)
    checks if the value "rounds infinity".  Table:

    ===================================
    [(+, 0])      |           true
    [(+, +])      |  lower > upper
    [(+, Inf)     |          false
    [(+, Inf]     |           true
    [(+, -])      |           true
    [Inf, 0])     |           true
    (Inf, 0])     |          false
    [Inf, +])     |           true
    (Inf, +])     |          false
    [Inf, -])     |           true
    (Inf, -])     |          false
    [Inf, Inf]    |           true
    (Inf, Inf]    |           true (ℝp)
    [Inf, Inf)    |           true (ℝp)
    (Inf, Inf)    |          false
    [(-, 0])      |          false
    [(-, +])      |          false
    [(-, Inf)     |          false
    [(-, Inf]     |           true
    [(-, -])      |  lower > upper
    [0, 0]        |          false
    [0, 0)        |          false (∅, may be mapped to noisy NaN in the future)
    (0, 0]        |          false (∅)
    (0, 0)        |           true
    [(0, +])      |          false
    [(0, Inf)     |          false
    [(0, Inf]     |           true
    [(0, -])      |           true
"""
function roundsinf{N,ES}(x::Valid{N,ES})
    (!isempty(x)) && ((@s(x.upper) < @s(x.lower)) || isinf(x.lower))
end

#amazing symmetrical structure to "roundsinf"
function containszero{N,ES}(x::Valid{N,ES})
    (!isempty(x)) && ((@u(x.upper) < @u(x.lower)) || x.lower == zero(Vnum{N,ES}))
end

function ispositive{N,ES}(x::Valid{N,ES})
  zero(@Int) < (@s x.lower) <= (@s x.upper)
end

function isnegative{N,ES}(x::Valid{N,ES})
  (@u Vnum{N,ES}(Inf))< (@u x.lower) <= (@u x.upper)
end
