# FuzzyFinder.jl
A pure julia implementation of fuzzy finder inspired by [python fuzzyfinder](https://pypi.org/project/fuzzyfinder/)

## Example
```julia
julia> using FuzzyFinder

julia> const f = Main.FuzzyFinder
Main.FuzzyFinder

julia> suggestions = f.fuzzyfinder("xyz", ["defxyzx", "zyze", "xxgyez", "rtq", "swb"])
Base.Generator{Array{Any,1},Main.FuzzyFinder.var"#5#9"}(Main.FuzzyFinder.var"#5#9"(), Any[(3, 4, "defxyzx", "defxyzx"), (6, 1, "xxgyez", "xxgyez")])

julia> # Use a custom function to obtain the string against which fuzzy matching is done

julia> collection = ["aa bbb", "aca xyz", "qx ala", "xza az", "bc aa", "xy abca"]
6-element Array{String,1}:
 "aa bbb"
 "aca xyz"
 "qx ala"
 "xza az"
 "bc aa"
 "xy abca"

 julia> suggestions = f.fuzzyfinder("aa", collection, fetcher= x-> split(x)[2])
Base.Generator{Array{Any,1},Main.FuzzyFinder.var"#5#9"}(Main.FuzzyFinder.var"#5#9"(), Any[(2, 1, "aa", "bc aa"), (3, 1, "ala", "qx ala"), (4, 1, "abca", "xy abca")])

julia> collect(suggestions)
3-element Array{String,1}:
 "bc aa"
 "qx ala"
 "xy abca"

julia> # Preserve original order of elements if matches have same rank

julia> suggestions = collect(f.fuzzyfinder("qq", ["qqv", "qqq", "qqx", "xyz", "ada"], sorted=false))
3-element Array{String,1}:
 "qqv"
 "qqq"
 "qqx"
 ```




