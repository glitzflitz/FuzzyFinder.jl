module FuzzyFinder

function regex_escape(s::AbstractString)
    res = replace(s, r"([()[\]{}?*+\-|^\$\\.&~#\s=!<>|:])" => s"\\\1")
    replace(res, "\0" => "\\0")
end

default = x -> x

function fuzzyfinder(input, iterable; fetcher::Function=default, sorted=true)
	recommendations = []
	input = if !isa(input, String)
		string(input)
	else
		input
	end
	pattern = join(regex_escape(input), ".*?")
	pattern = "(?=($pattern))"
	for item in iterable
		matches = collect(eachmatch(Regex(pattern, "i"), fetcher(item)))
		if !isempty(matches)
			ord = sort(matches, by=x -> length(x.captures[1]))
			best = length(ord[1].captures)
			push!(recommendations, (length(matches[best].captures[1]), matches[best].offset, fetcher(item), item))
		end
	end
	if sorted
		return (res[end] for res in sort(recommendations))
	else
		return (res[end] for res in sort(recommendations, by=x->x[:2]))
	end
end

end
